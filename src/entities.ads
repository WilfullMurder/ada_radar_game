with GL.Types;

package Entities is

   type Entity_Type is tagged record
      ID        : Integer;
      X, Y      : GL.Types.Double;  -- Position in world coordinates
      Rotation : GL.Types.Double;
      Width, Height     : GL.Types.Double;
      Texture : GL.Objects.Textures.Texture;
      Active    : Boolean := True;
   end record;
   

   type Entity_Array is array (Natural range <>) of Entity_Type;


   function Create_Entity (ID : Integer;
                           X, Y : GL.Types.Double;
                           Width, Height : GL.Types.Double) return Entity_Type;

   procedure Update(Self : in out Entity_Type; Delta_Time : GL.Types.Double);

   procedure Render(Self : in Entity_Type; Delta_Time : GL.Types.Double);

   procedure Cleanup(Self: in out Entity_Type);

end Entities;