with Ada.Containers.Vectors;
with Ada.Unchecked_Deallocation;
with Entity;
with GL.Types;

package Entity_Manager is

   use type Entity.Entity_Ref;

   package Entity_Vector is new Ada.Containers.Vectors (
      Index_Type => Natural, 
      Element_Type => Entity.Entity_Ref
   );

   V : Entity_Vector.Vector := Entity_Vector.Empty_Vector;
   
   procedure Initialize;
   
   procedure Update_All(Delta_Time: GL.Types.Double);
   
   procedure Render_All(Delta_Time: GL.Types.Double);

   procedure Register(New_Entity: Entity.Entity_Ref);

   procedure Remove (Entity_ID: Integer);

   procedure Cleanup_All;

private
procedure Free is new Ada.Unchecked_Deallocation(
   Object => Entity.Entity_Interface'Class,
   Name   => Entity.Entity_Ref
);

end Entity_Manager;