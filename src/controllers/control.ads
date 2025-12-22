limited with Ship_Entity;
with GL.Types;
with Ada.Unchecked_Deallocation;
with GLfw.Windows;

package Control is
   type Control_Interface is interface;

   type Control_Ref is access all Control.Control_Interface'Class;

      procedure Bind
     (Self  : in out Control_Interface;
      Owner : not null access Ship_Entity.Ship'Class) is abstract;

   procedure Step(Self : in out Control_Interface; Window : in out Glfw.Windows.Window; Delta_Time : GL.Types.Double) is abstract;

   procedure Fire(Self : in out Control_Interface) is abstract;
   procedure Cycle_Target_Left(Self : in out Control_Interface) is abstract;
   procedure Cycle_Target_Right(Self : in out Control_Interface) is abstract;
   procedure Pause(Self : in out Control_Interface) is abstract;

   procedure Free_Controller is new Ada.Unchecked_Deallocation
   (Control.Control_Interface'Class, Control_Ref);

end Control;