with GL.Types;

package Collision is
   type Collision_Component is record
      Radius : Float := 1.0;
   end record;

   procedure Initialize(Self : in out Collision_Component; Radius : Float);
   procedure Update(Self : in out Collision_Component);
   procedure Render(Self : in Collision_Component; X, Y : GL.Types.Double);
   procedure Cleanup(Self : in out Collision_Component);
   function Check_Collision(Entity1, Entity2 : Collision_Component; X1, Y1, X2, Y2 : GL.Types.Double) return Boolean;
   function Bounding_Circle(Width, Height : GL.Types.Double) return Float;

end Collision;