with Control;
with GL.Types;
with Ship_Entity;
with GLfw.Windows;

package Player_Control is
   type Player_Controller is new Control.Control_Interface with record
      Owner: access Ship_Entity.Ship'Class := null;
   end record;

   overriding procedure Bind
     (Self  : in out Player_Controller;
      Owner : not null access Ship_Entity.Ship'Class);

   overriding procedure Step(Self : in out Player_Controller; Window : in out Glfw.Windows.Window; Delta_Time : GL.Types.Double);
   overriding procedure Fire(Self : in out Player_Controller);
   overriding procedure Cycle_Target_Left(Self : in out Player_Controller);
   overriding procedure Cycle_Target_Right(Self : in out Player_Controller);
   overriding procedure Pause(Self : in out Player_Controller);

end Player_Control;