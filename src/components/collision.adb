with GL.Types; use GL.Types;
with GL_Math;


package body Collision is

   procedure Initialize(Self : in out Collision_Component; Radius : Float) is
   begin
      Self.Radius := Radius;
   end Initialize;

   function Check_Collision(Entity1, Entity2 : Collision_Component; X1, Y1, X2, Y2 : GL.Types.Double) return Boolean is
      Distance_Squared : GL.Types.Double := (X1 - X2) ** 2 + (Y1 - Y2) ** 2;
      Radii_Sum        : GL.Types.Double := GL.Types.Double(Entity1.Radius) + GL.Types.Double(Entity2.Radius);
   begin
      return Distance_Squared <= Radii_Sum ** 2;
   end Check_Collision;

   function Bounding_Circle(Width, Height : GL.Types.Double) return Float is
   use GL_Math;
      begin
         return Float(Sqrt((Width / 2.0) ** 2 + (Height / 2.0) ** 2));
      end Bounding_Circle;
end Collision;