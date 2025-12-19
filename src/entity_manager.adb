with Ada.Text_IO; use Ada.Text_IO;

procedure Initialize is
   begin
      Put_Line("Entity manager initialized");
   end Initialize;


procedure Update (Delta_Time : GL.Types.Double) is
   begin
      for I in Entity_Array'Range loop
         if Entity_Array(I).Active then
            Entity.Update(Entity_Array(I), Delta_Time);
         end if;
      end loop;
   end Update;

procedure Render (Delta_Time : GL.Types.Double) is
   begin
      for I in Entity_Array'Range loop
         if Entity_Array(I).Active then
            Entity.Render(Entity_Array(I), Delta_Time);
         end if;
      end loop;
   end Render;


procedure Add_Entity (New_Entity : Entities.Entity_Type) is
   begin
      for I in Entity_Array'Range loop
         if not Entity_Array(I).Active then
            Entity_Array(I) := New_Entity;
            exit;
         end if;
      end loop;
   end Add_Entity;


procedure Remove_Entity (Entity_ID : Integer) is
   begin
      for I in Entity_Array'Range loop
         if Entity_Array(I).ID = Entity_ID then
            Entity_Array(I).Active := False;
            exit;
         end if;
      end loop;
   end Remove_Entity;

procedure Cleanup is
   begin
      for I in Entity_Array'Range loop
         Entity.Cleanup(Entity_Array(I));
      end loop;
      Put_Line("Entity manager cleaned up");
   end Cleanup;