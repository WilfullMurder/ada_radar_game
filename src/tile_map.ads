with GL.Objects.Textures;
with GL.Types;

package Tile_Map is
   
   -- Tile types matching the overworld.png tileset
   type Tile_Type is (Water, Grass, Sand, Mountain, Tree);
   
   -- Map dimensions
   Map_Width  : constant := 32;
   Map_Height : constant := 24;
   
   -- Tile size in pixels in the texture (water.png uses 48x48 tiles)
   Tile_Size : constant := 48;
   
   type Map_Array is array (0 .. Map_Height - 1, 0 .. Map_Width - 1) of Tile_Type;
   
   -- Initialize the tile map system
   procedure Initialize;
   
   -- Load the tileset texture
   procedure Load_Tileset (Filename : String);
   
   -- Set up a sample map with water, beaches, land, etc.
   procedure Generate_Sample_Map;
   
   -- Render the entire map
   procedure Render (Time : GL.Types.Double);
   
   -- Cleanup resources
   procedure Cleanup;
   
private
   Tileset_Texture : GL.Objects.Textures.Texture;
   World_Map : Map_Array;
   
end Tile_Map;
