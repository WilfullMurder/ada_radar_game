with GL.Types;

package Health is
   type Health_Component is record
      Max_Health : Integer := 100;
      Current_Health : Integer := 100;
   end record;

   procedure Initialize(Self : in out Health_Component; Max: Integer := 100);
   procedure Take_Damage(Self : in out Health_Component; Damage_Amount : GL.Types.Double);
   procedure Heal(Self : in out Health_Component; Amount : GL.Types.Double);
   function Is_Alive(Self : Health_Component) return Boolean;
end Health;