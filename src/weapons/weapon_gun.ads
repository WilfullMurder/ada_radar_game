with Weapons;
with Entity;
with GL.Types;


package Weapon_Gun is
    type Gun is new Weapons.Weapon_Base with null record;

   overriding procedure Initialize(Self : in out Gun; Owner : access Entity.Entity_Interface'Class);
   overriding procedure Update(Self : in out Gun; Delta_Time : GL.Types.Double);
   overriding procedure Fire(Self : in out Gun; Delta_Time : GL.Types.Double);

end Weapon_Gun;