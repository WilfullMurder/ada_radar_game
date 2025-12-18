with Ada.Text_IO;
with Ada.Numerics;
with Ada.Numerics.Generic_Elementary_Functions;
with GL.Objects.Textures.Targets;
with GL.Pixels;
with GL.Images;
with GL.Immediate;
with GL.Toggles;
package body Ship is
   
   use GL.Types;
   use GL.Types.Doubles;
   
   package Double_Math is new Ada.Numerics.Generic_Elementary_Functions (Double);
   use Double_Math;
   use GL.Types.Doubles;
   
   procedure Initialize is
   begin
      Ada.Text_IO.Put_Line ("Ship system initialized");
   end Initialize;
   
   procedure Load_Ship (Entity : in out Ship_Entity;
                        Filename : String;
                        X, Y : Double) is
      use GL.Objects.Textures;
      use GL.Objects.Textures.Targets;
   begin
      Entity.Initialized := True;
      Entity.X := X;
      Entity.Y := Y;
      Entity.Rotation := 0.0;
      
      -- Initialize texture
      Entity.Texture.Initialize_Id;
      Texture_2D.Bind (Entity.Texture);
      
      -- Load the ship image
      GL.Images.Load_File_To_Texture 
        (Path           => Filename,
         Texture        => Entity.Texture,
         Texture_Format => GL.Pixels.RGBA,
         Try_TGA        => False);
      
      -- Set texture parameters for smooth rendering
      Texture_2D.Set_Minifying_Filter (Linear);
      Texture_2D.Set_Magnifying_Filter (Linear);
      
      -- Set image dimensions - ship_large_body.png is 122x368
      -- Maintain proper aspect ratio (368/122 = 3.016)
      Entity.Width := 122.0;
      Entity.Height := 368.0;
      
      -- Load ripple animation textures (000-004)
      for I in Entity.Ripple_Textures'Range loop
         Entity.Ripple_Textures (I).Initialize_Id;
         Texture_2D.Bind (Entity.Ripple_Textures (I));
         
         declare
            Num_Str : constant String := Integer'Image(I);
            Padded_Num : constant String := (if I < 10 then "00" & Num_Str(Num_Str'Last .. Num_Str'Last)
                                             elsif I < 100 then "0" & Num_Str(2 .. Num_Str'Last)
                                             else Num_Str(2 .. Num_Str'Last));
            Ripple_Filename : constant String := "resources/ships/water_ripple_big_" & Padded_Num & ".png";
         begin
            GL.Images.Load_File_To_Texture
              (Path           => Ripple_Filename,
               Texture        => Entity.Ripple_Textures (I),
               Texture_Format => GL.Pixels.RGBA,
               Try_TGA        => False);
            Ada.Text_IO.Put_Line ("Loaded ripple: " & Ripple_Filename);
         end;
         
         Texture_2D.Set_Minifying_Filter (Linear);
         Texture_2D.Set_Magnifying_Filter (Linear);
      end loop;
      
      -- Set ripple dimensions - 160x415 pixels
      Entity.Ripple_Width := 160.0;
      Entity.Ripple_Height := 415.0;
      
      Ada.Text_IO.Put_Line ("Ship loaded: " & Filename);
   end Load_Ship;
   
   procedure Render_Ship (Entity : Ship_Entity; Time : Double) is
      Half_Width : constant Double := Entity.Width / 2.0;
      Half_Height : constant Double := Entity.Height / 2.0;
      Ripple_Half_Width : constant Double := Entity.Ripple_Width / 2.0;
      Ripple_Half_Height : constant Double := Entity.Ripple_Height / 2.0;
      Ripple_Frame : Integer;
   begin
      if not Entity.Initialized then
         return;
      end if;
      
      -- Calculate ripple animation frame (4 frames per second, 5 total frames)
      Ripple_Frame := Integer (Time * 4.0) mod 5;
      
      -- Render radar sweep effect (rotating conical beams)
      declare
         use Ada.Numerics;
         Radar_Max_Radius : constant Double := 800.0;  -- Maximum beam distance (longer)
         Beam_Angle : constant Double := 45.0 * Pi / 180.0;  -- 45 degree cone (wider)
         Rotation_Speed : constant Double := 60.0;  -- Degrees per second (one full rotation every 6 seconds)
         Beam_Segments : constant := 20;  -- Segments along beam arc
         Base_Angle : Double;
         Current_Angle : Double;
         Angle_Step : Double;
         
         procedure Draw_Beam (Beam_Base_Angle : Double) is
         begin
            -- Draw conical radar beam as triangle fan
            GL.Immediate.Set_Color ((0.0, 1.0, 0.0, 0.3));  -- Green with transparency
            
            declare
               Token : constant GL.Immediate.Input_Token := GL.Immediate.Start (Triangle_Fan);
               Vertex_Pos : Vector2;
            begin
               -- Center point (ship position)
               Vertex_Pos := (Entity.X, Entity.Y);
               Token.Add_Vertex (Vertex_Pos);
               
               -- Arc of the beam cone
               for I in 0 .. Beam_Segments loop
                  Current_Angle := Beam_Base_Angle - Beam_Angle / 2.0 + Double (I) * Angle_Step;
                  Vertex_Pos := (Entity.X + Radar_Max_Radius * Cos (Current_Angle),
                                Entity.Y + Radar_Max_Radius * Sin (Current_Angle));
                  Token.Add_Vertex (Vertex_Pos);
               end loop;
            end;
            
            -- Draw beam outline for better visibility
            GL.Immediate.Set_Color ((0.0, 1.0, 0.0, 0.8));  -- Brighter green
            
            declare
               Token : constant GL.Immediate.Input_Token := GL.Immediate.Start (Lines);
               Vertex_Pos : Vector2;
            begin
               -- Left edge of beam
               Vertex_Pos := (Entity.X, Entity.Y);
               Token.Add_Vertex (Vertex_Pos);
               Current_Angle := Beam_Base_Angle - Beam_Angle / 2.0;
               Vertex_Pos := (Entity.X + Radar_Max_Radius * Cos (Current_Angle),
                             Entity.Y + Radar_Max_Radius * Sin (Current_Angle));
               Token.Add_Vertex (Vertex_Pos);
               
               -- Right edge of beam
               Vertex_Pos := (Entity.X, Entity.Y);
               Token.Add_Vertex (Vertex_Pos);
               Current_Angle := Beam_Base_Angle + Beam_Angle / 2.0;
               Vertex_Pos := (Entity.X + Radar_Max_Radius * Cos (Current_Angle),
                             Entity.Y + Radar_Max_Radius * Sin (Current_Angle));
               Token.Add_Vertex (Vertex_Pos);
            end;
         end Draw_Beam;
         
      begin
         -- Calculate current beam angle (rotating continuously)
         Base_Angle := Double'Remainder (Time * Rotation_Speed * Pi / 180.0, 2.0 * Pi);
         Angle_Step := Beam_Angle / Double (Beam_Segments);
         
         -- Disable texturing for line drawing
         GL.Toggles.Disable (GL.Toggles.Texture_2D);
         
         -- Draw first beam
         Draw_Beam (Base_Angle);
         
         -- Draw second beam opposite to first (180 degrees apart)
         Draw_Beam (Base_Angle + Pi);
         
         -- Reset color to white
         GL.Immediate.Set_Color ((1.0, 1.0, 1.0, 1.0));
         
         -- Re-enable texturing
         GL.Toggles.Enable (GL.Toggles.Texture_2D);
      end;
      
      -- Render wake ripple first (behind ship)
      GL.Objects.Textures.Targets.Texture_2D.Bind (Entity.Ripple_Textures (Ripple_Frame));
      
      declare
         Token : constant GL.Immediate.Input_Token := GL.Immediate.Start (Quads);
         Tex_Coord : Vector2;
         Vertex_Pos : Vector2;
      begin
         -- Bottom-left
         Tex_Coord := (0.0, 0.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Entity.X - Ripple_Half_Width, Entity.Y + Ripple_Half_Height);
         Token.Add_Vertex (Vertex_Pos);
         
         -- Bottom-right
         Tex_Coord := (1.0, 0.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Entity.X + Ripple_Half_Width, Entity.Y + Ripple_Half_Height);
         Token.Add_Vertex (Vertex_Pos);
         
         -- Top-right
         Tex_Coord := (1.0, 1.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Entity.X + Ripple_Half_Width, Entity.Y - Ripple_Half_Height);
         Token.Add_Vertex (Vertex_Pos);
         
         -- Top-left
         Tex_Coord := (0.0, 1.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Entity.X - Ripple_Half_Width, Entity.Y - Ripple_Half_Height);
         Token.Add_Vertex (Vertex_Pos);
      end;
      
      -- Render ship on top of ripple
      GL.Objects.Textures.Targets.Texture_2D.Bind (Entity.Texture);
      
      declare
         Token : constant GL.Immediate.Input_Token := GL.Immediate.Start (Quads);
         Tex_Coord : Vector2;
         Vertex_Pos : Vector2;
      begin
         -- Draw ship centered at its position with correct orientation
         -- Bottom-left
         Tex_Coord := (0.0, 0.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Entity.X - Half_Width, Entity.Y + Half_Height);
         Token.Add_Vertex (Vertex_Pos);
         
         -- Bottom-right
         Tex_Coord := (1.0, 0.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Entity.X + Half_Width, Entity.Y + Half_Height);
         Token.Add_Vertex (Vertex_Pos);
         
         -- Top-right
         Tex_Coord := (1.0, 1.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Entity.X + Half_Width, Entity.Y - Half_Height);
         Token.Add_Vertex (Vertex_Pos);
         
         -- Top-left
         Tex_Coord := (0.0, 1.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Entity.X - Half_Width, Entity.Y - Half_Height);
         Token.Add_Vertex (Vertex_Pos);
      end;
   end Render_Ship;
   
   procedure Cleanup is
   begin
      Ada.Text_IO.Put_Line ("Ship system cleaned up");
   end Cleanup;
   
end Ship;
