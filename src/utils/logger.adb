with Ada.Text_IO;

package body Logger is
   Log_File : Ada.Text_IO.File_Type;
   Is_Open : Boolean := False;

   procedure Initialise(Filename: String := "game_debug.log") is
   begin
      if not Is_Open then
         Ada.Text_IO.Create(Log_File, Ada.Text_IO.Out_File, Filename);
         Is_Open := True;
      end if;
   end Initialise;

   procedure Log(Message: String) is
   begin
      if Is_Open then
         Ada.Text_IO.Put_Line(Log_File, Message);
         Ada.Text_IO.Flush(Log_File);
      end if;
   end Log;

   procedure Close is
   begin
      if Is_Open then
         Ada.Text_IO.Close(Log_File);
         Is_Open := False;
      end if;
   end Close;
end Logger;