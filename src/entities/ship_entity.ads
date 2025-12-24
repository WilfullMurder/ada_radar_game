with Ada.Containers.Vectors;
with GL.Types;
with GL.Objects.Textures;
with Glfw.Windows;
with Entity;
with Control;
with Weapons;



package Ship_Entity is
   use type Control.Control_Ref;
   use type Weapons.Weapon_Ref;

   type Ripple_Texture_Array is array (0 .. 4) of GL.Objects.Textures.Texture;

   package Weapon_Vector is new Ada.Containers.Vectors
     (Index_Type   => Natural,
      Element_Type => Weapons.Weapon_Ref);

   type Ship is 
      new Entity.Entity_Type 
      and Entity.Entity_Interface 
   with record
      Ripple_Textures : Ripple_Texture_Array;
      Ripple_Width, Ripple_Height : GL.Types.Double;
      Controller : Control.Control_Ref; --OWNED
      Weapons : Weapon_Vector.Vector; --OWNED
   end record;



   overriding
   procedure Initialize(Self : in out Ship);

   function Create_Ship (ID : Integer;
                           X, Y : GL.Types.Double;
                           Filename: String) return Ship;

   overriding
   procedure Update(Self : in out Ship; Window : in out Glfw.Windows.Window; Delta_Time : GL.Types.Double);

   overriding
   procedure Render(Self : in Ship; Delta_Time : GL.Types.Double);

   overriding
   procedure Cleanup(Self: in out Ship);

   procedure Load_Ship (Entity : in out Ship;
                        Filename : String);

   procedure Add_Weapon (Entity : in out Ship; W : Weapons.Weapon_Ref);
   procedure Update_Weapons (Entity : in out Ship; Delta_Time : GL.Types.Double);
   procedure Trigger_Input_Weapons (Entity : in out Ship; Delta_Time : GL.Types.Double);

   overriding function Is_Active (Self : Ship) return Boolean;

   overriding function Get_ID (Self : Ship) return Integer;

end Ship_Entity;