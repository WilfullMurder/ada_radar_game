with Entity;
with Control;
with GL.Types;
with GL.Objects.Textures;
with Glfw.Windows;

package Ship_Entity is
   use type Control.Control_Ref;

   type Ripple_Texture_Array is array (0 .. 4) of GL.Objects.Textures.Texture;

   type Ship is 
      new Entity.Entity_Type 
      and Entity.Entity_Interface 
   with record
      Ripple_Textures : Ripple_Texture_Array;
      Ripple_Width, Ripple_Height : GL.Types.Double;
      Controller : Control.Control_Ref; --OWNED
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

   overriding function Is_Active (Self : Ship) return Boolean;

   overriding function Get_ID (Self : Ship) return Integer;

end Ship_Entity;