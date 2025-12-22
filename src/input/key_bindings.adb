with Glfw.Input.Keys;

package body Key_Bindings is

   Key_Mappings : array (Key_Action) of Glfw.Input.Keys.Key :=
     (Fire               => Glfw.Input.Keys.Space,
      Cycle_Target_Left  => Glfw.Input.Keys.A,
      Cycle_Target_Right => Glfw.Input.Keys.D,
      Pause              => Glfw.Input.Keys.P);

   function Get_Key_For_Action(Action : Key_Action) return Glfw.Input.Keys.Key is
   begin
      return Key_Mappings(Action);
   end Get_Key_For_Action;

   procedure Set_Key_For_Action(Action : Key_Action; Key_Code : Glfw.Input.Keys.Key) is
   begin
      Key_Mappings(Action) := Key_Code;
   end Set_Key_For_Action;

end Key_Bindings;