with Ada.Text_IO;
with Ada.Numerics.Float_Random;
with GL.Objects.Textures.Targets;
with GL.Pixels;
with GL.Toggles;
with GL.Blending;
with GL.Images;
with GL.Immediate;

package body Tile_Map is
   
   use GL.Types;
   use GL.Types.Doubles;
   
   -- Animation speed for water
   Water_Scroll_Speed : constant Double := 0.2;
   
   procedure Initialize is
   begin
      -- Enable 2D texturing
      GL.Toggles.Enable (GL.Toggles.Texture_2D);
      
      -- Enable blending for transparency
      GL.Toggles.Enable (GL.Toggles.Blend);
      GL.Blending.Set_Blend_Func (GL.Blending.Src_Alpha, GL.Blending.One_Minus_Src_Alpha);
      
      Ada.Text_IO.Put_Line ("Tile map system initialized");
   end Initialize;
   
   procedure Load_Tileset (Filename : String) is
      use GL.Objects.Textures;
      use GL.Objects.Textures.Targets;
   begin
      Tileset_Texture.Initialize_Id;
      
      -- Bind the texture
      Texture_2D.Bind (Tileset_Texture);
      
      -- Load the image file
      GL.Images.Load_File_To_Texture 
        (Path           => Filename,
         Texture        => Tileset_Texture,
         Texture_Format => GL.Pixels.RGBA,
         Try_TGA        => False);
      
      -- Set texture parameters for pixel art
      Texture_2D.Set_Minifying_Filter (Nearest);
      Texture_2D.Set_Magnifying_Filter (Nearest);
      
      -- Enable texture wrapping for water animation
      Texture_2D.Set_X_Wrapping (Repeat);
      Texture_2D.Set_Y_Wrapping (Repeat);
      
      Ada.Text_IO.Put_Line ("Tileset loaded: " & Filename);
   end Load_Tileset;
   
   procedure Generate_Sample_Map is
   begin
      -- Initialize entire map with water
      for Y in World_Map'Range (1) loop
         for X in World_Map'Range (2) loop
            World_Map (Y, X) := Water;
         end loop;
      end loop;
      
      Ada.Text_IO.Put_Line ("Sample map generated - all water");
   end Generate_Sample_Map;
   
   procedure Get_Tile_Coords (Tile : Tile_Type; Frame : Integer; U1, V1, U2, V2 : out Single) is
      -- water.png is a horizontal strip: 480 wide
      -- Each tile is 48 wide, so 10 tiles in a row (480/48 = 10)
      -- The texture tiles are 32 pixels high
      Tile_Index : Integer;
      Total_Tiles : constant := 10;
      Tile_Width : constant := 48;
      Tile_Height : constant := 32;  -- Actual tile height
      Texture_Width : constant := 480;
      Texture_Height : constant := 48;
   begin
      -- Map tile types to positions in the horizontal strip
      -- Using different water tiles for variety and animation
      -- Note: water.png contains 10 water variant tiles (0-9)
      case Tile is
         when Water =>
            -- Cycle through first 4 water tiles for animation
            Tile_Index := Frame mod 4;
         when Sand =>
            Tile_Index := 6;  -- 7th tile - lighter/shallower water
         when Grass =>
            Tile_Index := 8;  -- 9th tile - different water texture for land
         when Tree =>
            Tile_Index := 7;  -- 8th tile
         when Mountain =>
            Tile_Index := 9;  -- 10th tile - last in strip
      end case;
      
      -- Calculate normalized texture coordinates (0.0 to 1.0)
      U1 := Single (Tile_Index * Tile_Width) / Single (Texture_Width);
      V1 := 0.0;  -- Top of texture
      U2 := Single ((Tile_Index + 1) * Tile_Width) / Single (Texture_Width);
      V2 := Single (Tile_Height) / Single (Texture_Height);  -- Stop before text
   end Get_Tile_Coords;
   
   procedure Render (Time : Double) is
      Tile_Screen_Size : constant Double := 50.0; -- Size of tile on screen
      U1, V1, U2, V2 : Single;
      X_Pos, Y_Pos : Double;
      Water_Offset : Double;
   begin
      -- Calculate animation frame (change frame every 0.5 seconds)
      Water_Offset := Time * 2.0;  -- 2 frames per second
      
      GL.Objects.Textures.Targets.Texture_2D.Bind (Tileset_Texture);
      
      declare
         Token : constant GL.Immediate.Input_Token := GL.Immediate.Start (Quads);
         Tex_Coord : Vector2;
         Vertex_Pos : Vector2;
         Anim_Frame : Integer := Integer (Water_Offset);
      begin
         for Y in World_Map'Range (1) loop
            for X in World_Map'Range (2) loop
               Get_Tile_Coords (World_Map (Y, X), Anim_Frame, U1, V1, U2, V2);
               
               X_Pos := Double (X) * Tile_Screen_Size;
               Y_Pos := Double (Y) * Tile_Screen_Size;
               
               -- Draw a textured quad for this tile
               Tex_Coord := (Double (U1), Double (V1));
               GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
               Vertex_Pos := (X_Pos, Y_Pos);
               Token.Add_Vertex (Vertex_Pos);
               
               Tex_Coord := (Double (U2), Double (V1));
               GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
               Vertex_Pos := (X_Pos + Tile_Screen_Size, Y_Pos);
               Token.Add_Vertex (Vertex_Pos);
               
               Tex_Coord := (Double (U2), Double (V2));
               GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
               Vertex_Pos := (X_Pos + Tile_Screen_Size, Y_Pos + Tile_Screen_Size);
               Token.Add_Vertex (Vertex_Pos);
               
               Tex_Coord := (Double (U1), Double (V2));
               GL.Immediate.Set_Texture_Coordinates (Tex_Coord);
               Vertex_Pos := (X_Pos, Y_Pos + Tile_Screen_Size);
               Token.Add_Vertex (Vertex_Pos);
            end loop;
         end loop;
      end;
   end Render;
   
   procedure Cleanup is
   begin
      -- Texture cleanup is automatic with controlled types
      Ada.Text_IO.Put_Line ("Tile map cleaned up");
   end Cleanup;
   
end Tile_Map;
