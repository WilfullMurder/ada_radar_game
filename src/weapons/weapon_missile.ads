with GL.Types;
with Weapons;
with Entity;

package Weapon_Missile is
 type Missile_Launcher is new Weapons.Weapon_Base with null record;

overriding procedure Initialize(Self : in out Missile_Launcher; Owner : not null access Entity.Entity_Interface'Class);
overriding procedure On_Input_Fire(Self : in out Missile_Launcher; Delta_Time : GL.Types.Double);
overriding procedure Fire(Self : in out Missile_Launcher; Delta_Time : GL.Types.Double);
end Weapon_Missile;