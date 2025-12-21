with Ship_Entity;
with GL.Types;

package Player_Entity is
   
   type Radar_Radius_Type is new GL.Types.Double range 0.0 .. 800.0;

   type Player_Ship is new Ship_Entity.Ship with record
      Radar_Radius : Radar_Radius_Type := 0.0;
   end record;

   overriding procedure Initialize(Self : in out Player_Ship);
   overriding procedure Update(Self : in out Player_Ship; Delta_Time : GL.Types.Double);
   overriding procedure Render(Self : in Player_Ship; Delta_Time : GL.Types.Double);
   overriding procedure Cleanup(Self: in out Player_Ship);

   function Create_Ship (ID : Integer;
                        X, Y : GL.Types.Double;
                        Filename: String) return Player_Ship;

   overriding procedure Load_Ship (Entity : in out Player_Ship;
                        Filename : String);

   overriding function Is_Active (Self : Player_Ship) return Boolean;

   overriding function Get_ID (Self : Player_Ship) return Integer;

end Player_Entity;