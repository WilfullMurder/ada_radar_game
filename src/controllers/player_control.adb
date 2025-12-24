with Control;
with Ship_Entity;
with GL.Types;
with Input;
with Key_Bindings;
with Glfw.Windows;

with Ada.Text_IO; use Ada.Text_IO;
with State;

package body Player_Control is

   overriding procedure Bind
     (Self  : in out Player_Controller;
      Owner : not null access Ship_Entity.Ship'Class) is
   begin
      Self.Owner := Owner;
   end Bind;

   overriding procedure Step(Self : in out Player_Controller; Window : in out Glfw.Windows.Window; Delta_Time : GL.Types.Double) is
      Current_Cycle_Left  : Boolean;
      Current_Cycle_Right : Boolean;
      Current_Pause       : Boolean;
      Current_Fire        : Boolean;
   begin
      -- Always check pause input regardless of game state
      Current_Pause := Input.Key_Pressed(Window, Key_Bindings.Get_Key_For_Action(Key_Bindings.Pause));

      -- Handle pause toggle (always allowed)
      if Current_Pause and not Self.Prev_Pause then
         Put_Line("Pause key detected - toggling state");
         Self.Pause;
      end if;
      Self.Prev_Pause := Current_Pause;

      -- Only process game input if we should (not paused)
      if not State.Should_Update_Entities then
         return;
      end if;

      -- Read all other input states
      Current_Cycle_Left := Input.Key_Pressed(Window, Key_Bindings.Get_Key_For_Action(Key_Bindings.Cycle_Target_Left));
      Current_Cycle_Right := Input.Key_Pressed(Window, Key_Bindings.Get_Key_For_Action(Key_Bindings.Cycle_Target_Right));

      if Current_Cycle_Left and not Self.Prev_Cycle_Left then
         Self.Cycle_Target_Left;
      end if;
      Self.Prev_Cycle_Left := Current_Cycle_Left;

      if Current_Cycle_Right and not Self.Prev_Cycle_Right then
         Self.Cycle_Target_Right;
      end if;
      Self.Prev_Cycle_Right := Current_Cycle_Right;

      -- Trigger Weapon Fire on Space (cooldown handled in Weapon logic)
      Current_Fire := Input.Key_Pressed(Window, Key_Bindings.Get_Key_For_Action(Key_Bindings.Fire));
      if Current_Fire then
         if Self.Owner /= null then
            Ship_Entity.Trigger_Input_Weapons(Ship_Entity.Ship(Self.Owner.all), Delta_Time);
         end if;
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
      State.Toggle_Pause;
   end Pause;
end Player_Control;