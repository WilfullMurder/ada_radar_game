package Logger is
   procedure Initialise(Filename: String := "game_debug.log");
   procedure Log(Message: String);
   procedure Close;
end Logger;