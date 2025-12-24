with Ada.Text_IO; use Ada.Text_IO;
with GL.Types; use GL.Types;

package body Weapons is
   overriding procedure Initialize(Self : in out Weapon_Base; Owner : access Entity.Entity_Interface'Class) is
   begin
      Self.Owner := Owner;
   end Initialize;


   overriding procedure Update(Self : in out Weapon_Base; Delta_Time : GL.Types.Double) is
   begin
      if Self.Auto_Fire and then Self.Can_Fire(Delta_Time) then
         Self.Fire(Delta_Time);
         Self.Next_Fire_Time := Delta_Time + Self.Cooldown;
      end if;
   end Update;

   overriding procedure On_Input_Fire(Self : in out Weapon_Base; Delta_Time : GL.Types.Double) is
   begin
      -- default: no-op for non-input weapons
      null;
   end On_Input_Fire;


   overriding procedure Set_Target(Self : in out Weapon_Base; Target_Entity : Entity.Entity_Ref) is
   begin
      Self.Target := Target_Entity;
   end Set_Target;

   overriding function Can_Fire(Self : Weapon_Base; Delta_Time : GL.Types.Double) return Boolean is
   begin
      return Delta_Time >= Self.Next_Fire_Time;
   end Can_Fire;

   overriding procedure Fire(Self : in out Weapon_Base; Delta_Time : GL.Types.Double) is
   begin
      Put_Line("Weapon fired (base)");
   end Fire;

   overriding procedure Cleanup(Self : in out Weapon_Base) is
   begin
      -- Default: no-op
      null;
   end Cleanup;
end Weapons;