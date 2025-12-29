with GL.Types;

package Collision is
   type Collision_Component is record
      Radius : Float := 1.0;
   end record;

   procedure Initialize(Self : in out Collision_Component; Radius : Float);
   function Check_Collision(Entity1, Entity2 : Collision_Component; X1, Y1, X2, Y2 : GL.Types.Double) return Boolean;
   function Bounding_Circle(Width, Height : GL.Types.Double) return Float;
end Collision;