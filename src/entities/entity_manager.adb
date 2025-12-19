with Ada.Text_IO; use Ada.Text_IO;
with GL.Types;
with Entity;

package body Entity_Manager is

procedure Initialize is
begin
   Put_Line("Entity manager initialized");
end Initialize;


procedure Update_All (Delta_Time : GL.Types.Double) is
begin
   for E of V loop
      begin
         if E.Is_Active then
            E.Update(Delta_Time);
         end if;
      end;
   end loop;
end Update_All;

procedure Render_All (Delta_Time : GL.Types.Double) is
begin
   for E of V loop
      begin
         if E.Is_Active then
            E.Render(Delta_Time);
         end if;
      end;
   end loop;
end Render_All;


procedure Register (New_Entity : Entity.Entity_Ref) is
begin
   V.Append (New_Entity);
end Register;


procedure Remove (Entity_ID : Integer) is
begin
   for E of V loop
      if E.Get_ID = Entity_ID then
         E.Cleanup;
         exit;
      end if;
   end loop;
end Remove;

procedure Cleanup_All is
   begin
      for E of V loop
         E.Cleanup;
      end loop;
   end Cleanup_All;
end Entity_Manager;