with Ada.Numerics;
with Ada.Numerics.Generic_Elementary_Functions;
with GL.Immediate;
with GL.Toggles;
with Glfw.Windows;
with Control;
with Entity;
with Ship_Entity;
with Weapons;
with Weapon_Gun;
with Weapon_Missile;
with Player_Control;


package body Player_Entity is

   use GL.Types;
   use GL.Types.Doubles;
   
   package Double_Math is new Ada.Numerics.Generic_Elementary_Functions (Double);
   use Double_Math;
   use GL.Types.Doubles;

   overriding
   procedure Initialize(Self : in out Player_Ship) is
   Controller: Control.Control_Ref;
   begin
      Ship_Entity.Initialize(Ship_Entity.Ship(Self));
      
      Controller := new Player_Control.Player_Controller'(others => <>);
      Controller.Bind(Self'Unchecked_Access);
      Self.Controller := Controller;

      declare
         Gun : Weapons.Weapon_Ref := new Weapon_Gun.Gun'(others => <>);
         Missile : Weapons.Weapon_Ref := new Weapon_Missile.Missile_Launcher'(others => <>);
      begin
         Ship_Entity.Add_Weapon(Ship_Entity.Ship(Self), Gun);
         Ship_Entity.Add_Weapon(Ship_Entity.Ship(Self), Missile);
      end;
   end Initialize;

   function Create_Ship (ID : Integer;
                           X, Y : GL.Types.Double;
                           Filename : String) return Player_Ship is

New_Ship : Player_Ship :=
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
     Controller => null,
     Radar_Radius    => 600.0,
     Weapons => Ship_Entity.Weapon_Vector.Empty_Vector);
   begin
      Load_Ship (Entity => New_Ship, Filename => Filename);
      return New_Ship;
   end Create_Ship;

   overriding
   procedure Update(Self : in out Player_Ship; Window : in out Glfw.Windows.Window; Delta_Time : Double) is
   begin
      if Self.Controller /= null then
         Self.Controller.Step(Window, Delta_Time);
      end if;
      -- Note: Ship_Entity.Update will handle weapon updates if called.
      -- Here we keep player-specific logic; base Ship handles auto-fire updates now.
   end Update;

   overriding
   procedure Render(Self : in Player_Ship; Delta_Time : Double) is
      -- Call base Ship render
   begin
      Ship_Entity.Render(Ship_Entity.Ship(Self), Delta_Time);
      
      declare
         use Ada.Numerics;
         Beam_Angle: constant Double := 45.0 * Pi / 180.0; -- 45 degrees in radians
         Rotation_Speed: constant Double := 60.0; -- Degrees per second (one full rotation every 6 seconds)
         Beam_Segments: constant := 20; -- Segments along beam arc
         Base_Angle: Double;
         Current_Angle: Double;
         Angle_Step: Double;

         procedure Draw_Beam (Beam_Base_Angle : Double) is
         begin
            GL.Immediate.Set_Color ((0.0, 1.0, 0.0, 0.3));  -- Green with transparency

            declare
               Token : constant GL.Immediate.Input_Token := GL.Immediate.Start (Triangle_Fan);
               Vertex_Pos : Vector2;
            begin
               -- Center point (ship position)
               Vertex_Pos := (Self.X, Self.Y);
               Token.Add_Vertex (Vertex_Pos);

               -- Arc of the beam cone
               for I in 0 .. Beam_Segments loop
                  Current_Angle := Beam_Base_Angle - Beam_Angle / 2.0 + Double (I) * Angle_Step;
                  Vertex_Pos := (Self.X + Double(Self.Radar_Radius) * Cos (Current_Angle),
                                Self.Y + Double(Self.Radar_Radius) * Sin (Current_Angle));
                  Token.Add_Vertex (Vertex_Pos);
               end loop;
            end;
            -- Draw beam outline for better visibility
            GL.Immediate.Set_Color ((0.0, 1.0, 0.8, 0.8));  -- Brighter green

            declare
               Token : constant GL.Immediate.Input_Token := GL.Immediate.Start (Lines);
               Vertex_Pos : Vector2;
            begin
               -- Left edge of beam
               Vertex_Pos := (Self.X, Self.Y);
               Token.Add_Vertex (Vertex_Pos);
               Current_Angle := Beam_Base_Angle - Beam_Angle / 2.0;
               Vertex_Pos := (Self.X + Double(Self.Radar_Radius) * Cos (Current_Angle),
                             Self.Y + Double(Self.Radar_Radius) * Sin (Current_Angle));
               Token.Add_Vertex (Vertex_Pos);

               -- Right edge of beam
               Vertex_Pos := (Self.X, Self.Y);
               Token.Add_Vertex (Vertex_Pos);
               Current_Angle := Beam_Base_Angle + Beam_Angle / 2.0;
               Vertex_Pos := (Self.X + Double(Self.Radar_Radius) * Cos (Current_Angle),
                             Self.Y + Double(Self.Radar_Radius) * Sin (Current_Angle));
               Token.Add_Vertex (Vertex_Pos);
            end;
         end Draw_Beam;
      begin
         -- Calculate base angle based on time for rotation
         Base_Angle := Double'Remainder (Delta_Time * Rotation_Speed * Pi / 180.0, 2.0 * Pi);
         Angle_Step := Beam_Angle / Double (Beam_Segments);

         GL.Toggles.Disable(GL.Toggles.Texture_2D);
         Draw_Beam(Base_Angle);

         -- Draw second beam opposite to first (180 degrees apart)
         Draw_Beam (Base_Angle + Pi);

         GL.Immediate.Set_Color ((1.0, 1.0, 1.0, 1.0));
         GL.Toggles.Enable(GL.Toggles.Texture_2D);
      end;
   end Render;

   overriding
   procedure Cleanup(Self: in out Player_Ship) is
   begin
      if Self.Controller /= null then
         Control.Free_Controller (Self.Controller);
         Self.Controller := null;
      end if;
   end Cleanup;

   overriding procedure Load_Ship (Entity : in out Player_Ship;
                        Filename : String) is
   begin
      Ship_Entity.Load_Ship (Ship_Entity.Ship(Entity), Filename);
   end Load_Ship;


   overriding function Is_Active (Self : Player_Ship) return Boolean is
   begin
      return Self.Active;
   end Is_Active;

   overriding function Get_ID (Self : Player_Ship) return Integer is
   begin
      return Self.ID;
   end Get_ID;

end Player_Entity;