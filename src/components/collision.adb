
with Ada.Numerics;
with Ada.Numerics.Generic_Elementary_Functions;
with GL.Immediate;
with GL.Types;
with GL.Types.Colors;



package body Collision is

   use GL.Types;
   use GL.Types.Doubles;
   
   package Double_Math is new Ada.Numerics.Generic_Elementary_Functions (Double);
   use Double_Math;

   procedure Initialize(Self : in out Collision_Component; Radius : Float) is
   begin
      Self.Radius := Radius;
   end Initialize;

   procedure Update(Self : in out Collision_Component) is
   begin
      -- Placeholder for any future updates to collision component
      null;
   end Update;

   procedure Render(Self : in Collision_Component; X, Y : GL.Types.Double) is
      use Ada.Numerics;
      Segments : constant Integer := 32;
      Angle    : GL.Types.Double;
      Token    : constant GL.Immediate.Input_Token := GL.Immediate.Start (GL.Types.Line_Loop);
      Vertex_Pos : Vector2;
   begin
      GL.Immediate.Set_Color (GL.Types.Colors.Color'(1.0, 0.0, 0.0, 1.0));

      for I in 0 .. Segments - 1 loop
         Angle := 2.0 * Pi * GL.Types.Double(I) / GL.Types.Double(Segments);
         Vertex_Pos := (X + GL.Types.Double(Self.Radius) * Cos(Angle),
                        Y + GL.Types.Double(Self.Radius) * Sin(Angle));
         Token.Add_Vertex (Vertex_Pos);
      end loop;
   end Render;

   procedure Cleanup(Self : in out Collision_Component) is
   begin
      -- Placeholder for cleanup logic if needed
      null;
   end Cleanup;

   function Check_Collision(Entity1, Entity2 : Collision_Component; X1, Y1, X2, Y2 : GL.Types.Double) return Boolean is
      Distance_Squared : GL.Types.Double := (X1 - X2) ** 2 + (Y1 - Y2) ** 2;
      Radii_Sum        : GL.Types.Double := GL.Types.Double(Entity1.Radius) + GL.Types.Double(Entity2.Radius);
   begin
      return Distance_Squared <= Radii_Sum ** 2;
   end Check_Collision;

   function Bounding_Circle(Width, Height : GL.Types.Double) return Float is
   begin
      return Float(Sqrt((Width / 2.0) ** 2 + (Height / 2.0) ** 2));
   end Bounding_Circle;
end Collision;