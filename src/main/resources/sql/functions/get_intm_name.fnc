DROP FUNCTION CPI.GET_INTM_NAME;

CREATE OR REPLACE FUNCTION CPI.GET_INTM_NAME(p_intm_no giis_intermediary.intm_no%type)
   RETURN CHAR as
   v_intm_name giis_intermediary.intm_name%type;
   v_intm_exists BOOLEAN := FALSE;
BEGIN
   FOR c IN (SELECT intm_name
             FROM giis_intermediary
             WHERE intm_no = p_intm_no)
   LOOP
      v_intm_name   := c.intm_name;
      v_intm_exists := TRUE;
      EXIT;
   END LOOP;
   IF v_intm_exists = FALSE THEN
       RAISE_APPLICATION_ERROR(-20011,'Intermediary not in GIIS_INTERMEDARY.');
   END IF;
   RETURN(v_intm_name);
END;
/


