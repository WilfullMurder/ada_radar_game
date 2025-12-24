with Ada.Text_IO; use Ada.Text_IO;
with GL.Types;
with Weapons;

package body Weapon_Gun is

   overriding procedure Initialize(Self : in out Gun; Owner : not null access Entity.Entity_Interface'Class) is
   begin
      -- Call base class initializer
      Weapons.Weapon_Base(Self).Initialize(Owner);
      Self.Cooldown := 0.10;  -- Fast auto-fire rate for gun
      Self.Auto_Fire := True;
   end Initialize;

   overriding procedure Update(Self : in out Gun; Delta_Time : GL.Types.Double) is
   begin
      Weapons.Weapon_Base(Self).Update(Delta_Time);
   end Update;

   overriding procedure Fire(Self : in out Gun; Delta_Time : GL.Types.Double) is
   begin
      Put_Line("Gun auto-fired!");
      -- TODO: Spawn bullet (Line trace via shader?), aim at Self.Target if set
   end Fire;
      
end Weapon_Gun;