package State is
   type Game_State is (Menu, Playing, Paused, Game_Over);

   -- State Management
   procedure Set_State(New_State: Game_State);
   function Get_State return Game_State;

   -- State Queries
   function Is_Paused return Boolean;
   function Should_Update_Entities return Boolean;
   function Should_Process_Input return Boolean;
   
   --  State transitions
   procedure Toggle_Pause;
   procedure Resume;
   procedure Show_Menu;
   procedure Start_Playing;
   procedure Game_Over;

   private
      Current_State : Game_State := Playing;
end State;