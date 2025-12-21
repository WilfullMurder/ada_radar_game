with GL.Types;
with GL.Objects.Textures;

package Entity is

   type Entity_Interface is interface;

   procedure Initialize (Self : in out Entity_Interface) is abstract;
   procedure Update
     (Self : in out Entity_Interface; Delta_Time : GL.Types.Double) is abstract;
   procedure Render
     (Self : in Entity_Interface; Delta_Time : GL.Types.Double) is abstract;
   procedure Cleanup
     (Self : in out Entity_Interface) is abstract;

   function Is_Active (Self : in Entity_Interface) return Boolean is abstract;
   function Get_ID (Self : in Entity_Interface) return Integer is abstract;

   -- Concrete shared data
   type Entity_Type is tagged record
      ID        : Integer;
      X, Y      : GL.Types.Double;
      Rotation  : GL.Types.Double;
      Width     : GL.Types.Double;
      Height    : GL.Types.Double;
      Texture   : GL.Objects.Textures.Texture;
      Active    : Boolean := True;
   end record;

   type Entity_Ref is access all Entity_Interface'Class;
   type Entity_Array is array (Natural range <>) of Entity_Ref;

end Entity;
