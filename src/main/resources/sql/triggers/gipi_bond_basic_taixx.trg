DROP TRIGGER CPI.GIPI_BOND_BASIC_TAIXX;

CREATE OR REPLACE TRIGGER CPI.gipi_bond_basic_taixx
   AFTER INSERT
   ON CPI.GIPI_BOND_BASIC    FOR EACH ROW
DECLARE
BEGIN
    FOR rec IN (
        SELECT par_id
          FROM gipi_polbasic
         WHERE policy_id = :NEW.policy_id)
    LOOP
        get_c20_dtl(rec.par_id, :NEW.policy_id);
    END LOOP;
END;
/


