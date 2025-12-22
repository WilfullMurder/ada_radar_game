with Glfw.Input.Keys;
package Key_Bindings is
   type Key_Action is (Fire, Cycle_Target_Left, Cycle_Target_Right, Pause);

   function Get_Key_For_Action(Action : Key_Action) return Glfw.Input.Keys.Key;
   procedure Set_Key_For_Action(Action : Key_Action; Key_Code : Glfw.Input.Keys.Key);
end Key_Bindings;