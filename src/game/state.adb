with Ada.Text_IO; use Ada.Text_IO;

package body State is
   
   procedure Set_State(New_State: Game_State) is
     begin
      if Current_State /= New_State then
         Current_State := New_State; 
         Put_Line("Game state changed to: " & Game_State'Image(Current_State));
      end if;
     end Set_State;

     function Get_State return Game_State is
     begin
        return Current_State;
     end Get_State;

     function Is_Paused return Boolean is
     begin
        return Current_State = Paused;
     end Is_Paused;

     function Should_Update_Entities return Boolean is
     begin
        return Current_State = Playing;
     end Should_Update_Entities;

      function Should_Process_Input return Boolean is
     begin
        return Current_State = Playing or Current_State = Paused;
     end Should_Process_Input;

     procedure Toggle_Pause is
     begin
     case Current_State is
        when Menu | Game_Over =>
           null; -- No action in these states
        when Playing =>
           Set_State(Paused);
        when Paused =>
           Set_State(Playing);
      end case;
     end Toggle_Pause;

      procedure Resume is
       begin
         if Current_State = Paused then
             Set_State(Playing);
         end if;
      end Resume;

      procedure Show_Menu is
      begin
         Set_State(Menu);
      end Show_Menu;

      procedure Start_Playing is
      begin
         Set_State(Playing);
      end Start_Playing;

      procedure Game_Over is
      begin
         Set_State(Game_Over);
      end Game_Over;

end State;