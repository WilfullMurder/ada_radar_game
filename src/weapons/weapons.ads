with Entity;
with GL.Types;
with Ada.Unchecked_Deallocation;

package Weapons is
   type Weapon_Interface is interface;

   procedure Initialize(Self : in out Weapon_Interface; Owner : not null access Entity.Entity_Interface'Class) is abstract;
   procedure Update(Self : in out Weapon_Interface; Delta_Time : GL.Types.Double) is abstract;
   procedure On_Input_Fire(Self : in out Weapon_Interface; Delta_Time : GL.Types.Double) is abstract;
   procedure Set_Target(Self : in out Weapon_Interface; Target_Entity : Entity.Entity_Ref) is abstract;
   function Can_Fire(Self : Weapon_Interface; Delta_Time : GL.Types.Double) return Boolean is abstract;
   procedure Fire(Self : in out Weapon_Interface; Delta_Time : GL.Types.Double) is abstract;
   procedure Cleanup(Self : in out Weapon_Interface) is abstract;

   type Weapon_Ref is access all Weapon_Interface'Class;

   procedure Free_Weapon is new Ada.Unchecked_Deallocation
     (Object => Weapon_Interface'Class,
      Name   => Weapon_Ref);

   -- Base type with cooldown/owner plumbing
   type Weapon_Base is abstract new Weapon_Interface with record
      Owner : access Entity.Entity_Interface'Class := null;
      Cooldown : GL.Types.Double := 0.25;
      Next_Fire_Time : GL.Types.Double := 0.0;
      Auto_Fire : Boolean := False;
      Target : Entity.Entity_Ref := null;
   end record;

   overriding procedure Initialize(Self : in out Weapon_Base; Owner : not null access Entity.Entity_Interface'Class);
   overriding procedure Update(Self : in out Weapon_Base; Delta_Time : GL.Types.Double);
   overriding procedure On_Input_Fire(Self : in out Weapon_Base; Delta_Time : GL.Types.Double);
   overriding procedure Set_Target(Self : in out Weapon_Base; Target : Entity.Entity_Ref);
   overriding function Can_Fire(Self : Weapon_Base; Delta_Time : GL.Types.Double) return Boolean;
   overriding procedure Fire(Self : in out Weapon_Base; Delta_Time : GL.Types.Double);
   overriding procedure Cleanup(Self : in out Weapon_Base);

end Weapons; 