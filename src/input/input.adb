with Glfw.Input;
with Glfw.Input.Keys;
with Glfw.Windows;
package body Input is

   function Key_Pressed(Window : in out Glfw.Windows.Window; Key_Code : Glfw.Input.Keys.Key) return Boolean is
   begin
      return Window.Key_State(Key_Code) = Glfw.Input.Pressed;
   end Key_Pressed;

end Input;