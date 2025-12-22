with Control;
with Ship_Entity;
with GL.Types;
with Input;
with Key_Bindings;
with Glfw.Windows;

with Ada.Text_IO; use Ada.Text_IO;

package body Player_Control is

   overriding procedure Bind
     (Self  : in out Player_Controller;
      Owner : not null access Ship_Entity.Ship'Class) is
   begin
      Self.Owner := Owner;
   end Bind;

   overriding procedure Step(Self : in out Player_Controller; Window : in out Glfw.Windows.Window; Delta_Time : GL.Types.Double) is
   begin
      if Input.Key_Pressed(Window, Key_Bindings.Get_Key_For_Action(Key_Bindings.Fire)) then
         Self.Fire;
      end if;

      if Input.Key_Pressed(Window, Key_Bindings.Get_Key_For_Action(Key_Bindings.Cycle_Target_Left)) then
         Self.Cycle_Target_Left;
      end if;

      if Input.Key_Pressed(Window, Key_Bindings.Get_Key_For_Action(Key_Bindings.Cycle_Target_Right)) then
         Self.Cycle_Target_Right;
      end if;

      if Input.Key_Pressed(Window, Key_Bindings.Get_Key_For_Action(Key_Bindings.Pause)) then
         Self.Pause;
      end if;
   end Step;


   overriding procedure Fire(Self : in out Player_Controller) is
   begin
      Put_Line ("Fired weapon");
   end Fire;

   overriding procedure Cycle_Target_Left(Self : in out Player_Controller) is
   begin
      Put_Line ("Cycled target left");
   end Cycle_Target_Left;


   overriding procedure Cycle_Target_Right(Self : in out Player_Controller) is
   begin
      Put_Line ("Cycled target right");
   end Cycle_Target_Right;


   overriding procedure Pause(Self : in out Player_Controller) is
   begin
      Put_Line ("Game paused");
   end Pause;
end Player_Control;