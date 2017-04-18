DROP FUNCTION CPI.SPELL_AMT;

CREATE OR REPLACE FUNCTION CPI.spell_amt (x_number number)
RETURN VARCHAR2 IS
    w_amt   varchar2(2000);
begin
    select dh_util.spell(x_number)
      into w_amt
      from dual;
    return w_amt;
end;
/


