SET serveroutput ON
DECLARE
    v_exists    NUMBER := 0;
BEGIN
    SELECT DISTINCT 1
      INTO v_exists
      FROM all_constraints
     WHERE owner = 'CPI'
       AND table_name = 'GIIS_ASSURED_INTM'
       AND constraint_name = 'INTERMEDIARY_ASSURED_INTM_FK'
       AND status = 'DISABLED';

    IF v_exists = 1 THEN
        EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_ASSURED_INTM ENABLE CONSTRAINT INTERMEDIARY_ASSURED_INTM_FK');
    END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      dbms_output.put_line('Constraint INTERMEDIARY_ASSURED_INTM_FK is already enabled.');
END;