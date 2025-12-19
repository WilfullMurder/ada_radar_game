with Ada.Text_IO; use Ada.Text_IO;


   function Create_Entity (ID : Integer;
                           X, Y : GL.Types.Double;
                           Width, Height : GL.Types.Double) return Entity_Type is
   begin
      return (ID => ID,
              X => X,
              Y => Y,
              Width => Width,
              Height => Height,
              Active => True);
   end Create_Entity;


   procedure Update(Self : in out Entity_Type; Delta_Time : GL.Types.Double) is
   begin
      -- Update entity logic here (e.g., movement, state changes)
   end Update;


   procedure Render(Self : in Entity_Type; Delta_Time : GL.Types.Double) is
   begin
      -- Render entity here
   end Render;

   procedure Cleanup(Self: in out Entity_Type) is
   begin
      Put_Line("Cleaning up entity ID: " & Integer'Image(Self.ID));
      Self.Active := False;
      -- Free resources associated with the entity if any
   end Cleanup;