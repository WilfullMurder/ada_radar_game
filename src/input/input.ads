with Glfw.Windows;
with Glfw.Input.Keys;


package Input is
   use type Glfw.Input.Button_State;
   function Key_Pressed(Window : in out Glfw.Windows.Window; Key_Code : Glfw.Input.Keys.Key) return Boolean;
end Input;