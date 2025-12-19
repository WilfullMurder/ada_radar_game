package Entity_Manager is

   Entity_Array : Entities.Entity_Array (0 .. 99);
   
   procedure Initialize;
   
   procedure Update (Delta_Time : GL.Types.Double);
   
   procedure Render (Time : GL.Types.Double);

   procedure Add_Entity (New_Entity : Entities.Entity_Type);

   procedure Remove_Entity (Entity_ID : Integer);

   procedure Cleanup;
   
end Entity_Manager;