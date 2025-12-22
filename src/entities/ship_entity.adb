with Ada.Numerics;
with Ada.Numerics.Generic_Elementary_Functions;
with GL.Objects.Textures.Targets;
with GL.Pixels;
with GL.Images;
with GL.Immediate;
with Glfw.Windows;
with Ada.Text_IO; use Ada.Text_IO;
with Entity;

package body Ship_Entity is

   use GL.Types;
   use GL.Types.Doubles;
   
   package Double_Math is new Ada.Numerics.Generic_Elementary_Functions (Double);
   use Double_Math;
   use GL.Types.Doubles;

   overriding
   procedure Initialize(Self : in out Ship) is
   begin
      Put_Line("Ship entity system for: " & Integer'Image(Self.ID) & " initialized");
   end Initialize;


   function Create_Ship (ID : Integer;
                           X, Y : GL.Types.Double;
                           Filename : String) return Ship is

New_Ship : Ship :=
  (Entity.Entity_Type'
     (ID        => ID,
      X         => X,
      Y         => Y,
      Rotation  => 0.0,
      Width     => 0.0,
      Height    => 0.0,
      Texture   => <>,
      Active    => True)
   with
     Ripple_Textures => (others => <>),
     Ripple_Width    => 0.0,
     Ripple_Height   => 0.0,
     Controller => null);
   begin
      Load_Ship (Entity => New_Ship, Filename => Filename);
      return New_Ship;
   end Create_Ship;

   overriding
   procedure Update(Self : in out Ship; Window : in out Glfw.Windows.Window; Delta_Time : GL.Types.Double) is
   begin
      if Self.Controller /= null then
         Self.Controller.Step(Window, Delta_Time);
      end if;
   end Update;

   overriding
   procedure Render(Self : in Ship; Delta_Time : GL.Types.Double) is
      Half_Width : constant Double := Self.Width / 2.0;
      Half_Height : constant Double := Self.Height / 2.0;
      Ripple_Half_Width : constant Double := Self.Ripple_Width / 2.0;
      Ripple_Half_Height : constant Double := Self.Ripple_Height / 2.0;
      Ripple_Frame : Integer;
   begin
      if not Self.Active then
         return;
      end if;

      -- Calculate ripple animation frame (4 frames per second, 5 total frames)
      Ripple_Frame := Integer (Delta_Time * 4.0) mod 5;
      

      -- Render wake ripple first (behind ship)
      GL.Objects.Textures.Targets.Texture_2D.Bind (Self.Ripple_Textures (Ripple_Frame));
      
      declare
         Token : constant GL.Immediate.Input_Token := GL.Immediate.Start (Quads);
         Tex_Coord : Vector2;
         Vertex_Pos : Vector2;
      begin
         -- Bottom-left
         Tex_Coord := (0.0, 0.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Self.X - Ripple_Half_Width, Self.Y + Ripple_Half_Height);
         Token.Add_Vertex (Vertex_Pos);
         
         -- Bottom-right
         Tex_Coord := (1.0, 0.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Self.X + Ripple_Half_Width, Self.Y + Ripple_Half_Height);
         Token.Add_Vertex (Vertex_Pos);
         
         -- Top-right
         Tex_Coord := (1.0, 1.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Self.X + Ripple_Half_Width, Self.Y - Ripple_Half_Height);
         Token.Add_Vertex (Vertex_Pos);
         
         -- Top-left
         Tex_Coord := (0.0, 1.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Self.X - Ripple_Half_Width, Self.Y - Ripple_Half_Height);
         Token.Add_Vertex (Vertex_Pos);
      end;
      
      -- Render ship on top of ripple
      GL.Objects.Textures.Targets.Texture_2D.Bind (Self.Texture);
      
      declare
         Token : constant GL.Immediate.Input_Token := GL.Immediate.Start (Quads);
         Tex_Coord : Vector2;
         Vertex_Pos : Vector2;
      begin
         -- Draw ship centered at its position with correct orientation
         -- Bottom-left
         Tex_Coord := (0.0, 0.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Self.X - Half_Width, Self.Y + Half_Height);
         Token.Add_Vertex (Vertex_Pos);
         
         -- Bottom-right
         Tex_Coord := (1.0, 0.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Self.X + Half_Width, Self.Y + Half_Height);
         Token.Add_Vertex (Vertex_Pos);
         
         -- Top-right
         Tex_Coord := (1.0, 1.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Self.X + Half_Width, Self.Y - Half_Height);
         Token.Add_Vertex (Vertex_Pos);
         
         -- Top-left
         Tex_Coord := (0.0, 1.0);
         GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
         Vertex_Pos := (Self.X - Half_Width, Self.Y - Half_Height);
         Token.Add_Vertex (Vertex_Pos);
      end;


      
   end Render;

   overriding
   procedure Cleanup(Self: in out Ship) is
   begin
      if Self.Controller /= null then
         Control.Free_Controller(Self.Controller);
         Self.Controller := null;
      end if;
      null;
   end Cleanup;

   procedure Load_Ship (Entity : in out Ship;
                     Filename : String) is
      use GL.Objects.Textures;
      use GL.Objects.Textures.Targets;
   begin
      -- Load main ship texture
      Entity.Texture.Initialize_Id;
      Texture_2D.Bind (Entity.Texture);

      GL.Images.Load_File_To_Texture(
         Path => Filename,
         Texture => Entity.Texture,
         Texture_Format => GL.Pixels.RGBA,
         Try_TGA => False
      );

      Texture_2D.Set_Minifying_Filter(Linear);
      Texture_2D.Set_Magnifying_Filter(Linear);

      Entity.Width := GL.Types.Double(Texture_2D.Width(Level => 0));
      Entity.Height := GL.Types.Double(Texture_2D.Height(Level => 0));

      -- Load ripple textures
      for I in Entity.Ripple_Textures'Range loop
         Entity.Ripple_Textures(I).Initialize_Id;
         Texture_2D.Bind (Entity.Ripple_Textures(I));

         declare
            Num_Str: constant String := Integer'Image(I);
            Padded_Num_Str: constant String := (if I < 10 then "00" & Num_Str(Num_Str'Last .. Num_Str'Last)
                                             elsif I < 100 then "0" & Num_Str(2 .. Num_Str'Last)
                                             else Num_Str(2 .. Num_Str'Last));
            Ripple_Filename: constant String := "resources/ships/water_ripple_big_" & Padded_Num_Str & ".png";
         begin
            GL.Images.Load_File_To_Texture(
               Path => Ripple_Filename,
               Texture => Entity.Ripple_Textures(I),
               Texture_Format => GL.Pixels.RGBA,
               Try_TGA => False
            );
            Put_Line("Loaded ripple texture: " & Ripple_Filename);
         end;
         Texture_2D.Set_Minifying_Filter(Linear);
         Texture_2D.Set_Magnifying_Filter(Linear);
      end loop;
      Entity.Ripple_Width := GL.Types.Double(Texture_2D.Width(Level => 0));
      Entity.Ripple_Height := GL.Types.Double(Texture_2D.Height(Level => 0));

      Put_Line ("Ship Loaded: " & Filename);
   end Load_Ship;



   overriding function Is_Active (Self : Ship) return Boolean is
   begin
      return Self.Active;
   end Is_Active;

   overriding function Get_ID (Self : Ship) return Integer is
   begin
      return Self.ID;
   end Get_ID;

end Ship_Entity;