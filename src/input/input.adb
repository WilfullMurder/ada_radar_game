with Glfw.Input;
with Glfw.Input.Keys;
with Glfw.Windows;


-- The Key_Pressed function checks the current key state, not whether the key was just pressed.
-- This means actions like Pause (line 33-35) will be triggered every frame while the key is held, rather than once per key press. 
-- Consider implementing key state tracking to detect when a key transitions from unpressed to pressed, or add logic to handle single-press vs held-key actions differently.


package body Input is

   function Key_Pressed(Window : in out Glfw.Windows.Window; Key_Code : Glfw.Input.Keys.Key) return Boolean is
   begin
      return Window.Key_State(Key_Code) = Glfw.Input.Pressed;
   end Key_Pressed;

end Input;