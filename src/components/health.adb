with GL.Types; use GL.Types;

package body Health is

   procedure Initialize(Self : in out Health_Component; Max : Integer := 100) is
   begin
      Self.Max_Health := Max;
      Self.Current_Health := Max;
   end Initialize;

   procedure Take_Damage(Self : in out Health_Component; Damage_Amount : GL.Types.Double) is
   begin
      if Damage_Amount < 0.0 then
         return; -- Ignore negative damage amounts
      end if;

      if Damage_Amount > GL.Types.Double(Self.Current_Health) then
         Self.Current_Health := 0;
      else
         Self.Current_Health := Self.Current_Health - Integer(Damage_Amount);
      end if;
   end Take_Damage;

   procedure Heal(Self : in out Health_Component; Amount : GL.Types.Double) is
   begin
      if Amount < 0.0 then
         return; -- Ignore negative healing amounts
      end if;

      Self.Current_Health := Integer'Min(Self.Current_Health + Integer(Amount), Self.Max_Health);
   end Heal;

   function Is_Alive(Self : Health_Component) return Boolean is
   begin
      return Self.Current_Health > 0;
   end Is_Alive;

end Health;