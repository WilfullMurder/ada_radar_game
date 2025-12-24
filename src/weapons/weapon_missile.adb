with Ada.Text_IO; use Ada.Text_IO;
with GL.Types; use GL.Types;
with Weapons;

package body Weapon_Missile is
   overriding procedure Initialize(Self : in out Missile_Launcher; Owner : access Entity.Entity_Interface'Class) is
   begin
      -- Call base class initializer
      Weapons.Weapon_Base(Self).Initialize(Owner);
      Self.Cooldown := 1.0;  -- Slower fire rate for missile
      Self.Auto_Fire := False; -- Manual fire only
   end Initialize;

   overriding procedure On_Input_Fire(Self : in out Missile_Launcher; Delta_Time : GL.Types.Double) is
   begin
      if Self.Can_Fire(Delta_Time) then
         Self.Fire(Delta_Time);
         Self.Next_Fire_Time := Delta_Time + Self.Cooldown;
      end if;
   end On_Input_Fire;

   overriding procedure Fire(Self : in out Missile_Launcher; Delta_Time : GL.Types.Double) is
   begin
      Put_Line("Missile launched!");
      -- TODO: Spawn missile entity, aim at Self.Target if set
   end Fire;
end Weapon_Missile;