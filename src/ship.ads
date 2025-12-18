with GL.Objects.Textures;
with GL.Types;

package Ship is
   
   type Ripple_Textures is array (0 .. 4) of GL.Objects.Textures.Texture;
   
   type Ship_Entity is record
      X, Y : GL.Types.Double;  -- Position in world coordinates
      Rotation : GL.Types.Double;  -- Angle in degrees
      Width, Height : GL.Types.Double;  -- Ship dimensions
      Texture : GL.Objects.Textures.Texture;
      Ripple_Textures : Ship.Ripple_Textures;
      Ripple_Width, Ripple_Height : GL.Types.Double;
      Radar_Radius : GL.Types.Double := 0.0;  -- Current radar sweep radius
      Initialized : Boolean := False;
   end record;
   
   -- Initialize the ship system
   procedure Initialize;
   
   -- Load a ship texture and create a ship entity
   procedure Load_Ship (Entity : in out Ship_Entity;
                        Filename : String;
                        X, Y : GL.Types.Double);
   
   -- Render a ship with animated wake ripple
   procedure Render_Ship (Entity : Ship_Entity; Time : GL.Types.Double);
   
   -- Cleanup
   procedure Cleanup;
   
end Ship;
