DROP TRIGGER CPI.GIIS_MORTGAGEE_TBIXX;

CREATE OR REPLACE TRIGGER CPI.GIIS_MORTGAGEE_TBIXX
/* to insert mortgagee_id on giis_mortgagee before inserting new record*/
/* created by: ging 100705*/
BEFORE INSERT
ON CPI.GIIS_MORTGAGEE FOR EACH ROW
DECLARE
  v_mortgagee_id      giis_mortgagee.mortgagee_id%TYPE;
BEGIN
  SELECT NVL(MAX(mortgagee_id),0)
    INTO v_mortgagee_id
    FROM giis_mortgagee;
	v_mortgagee_id := v_mortgagee_id + 1;
    :NEW.mortgagee_id :=v_mortgagee_id;
END;
/


