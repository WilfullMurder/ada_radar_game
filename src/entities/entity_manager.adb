with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;
with GL.Types;
with Entity;
with Glfw.Windows;

package body Entity_Manager is

procedure Initialize is
begin
   Put_Line("Entity manager initialized");
end Initialize;


procedure Update_All (Window : in out Glfw.Windows.Window; Delta_Time : GL.Types.Double) is
begin
   for E of V loop
      begin
         if E.Is_Active then
            E.Update(Window, Delta_Time);
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
E: Entity.Entity_Ref;
begin
   for I in V.First_Index .. V.Last_Index loop
      E := V(I); -- Variable copy
      
      if E.Get_ID = Entity_ID then
         E.Cleanup;
         Free(E);
         V.Delete(I);
         exit;
      end if;
   end loop; 
end Remove;

procedure Cleanup_All is
   begin
      for E of V loop
         E.Cleanup;
         Free(E);
      end loop;
      V.Clear;
   end Cleanup_All;
end Entity_Manager;