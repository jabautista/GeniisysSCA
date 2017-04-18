DROP FUNCTION CPI.GET_SIGNATORY;

CREATE OR REPLACE FUNCTION CPI.get_signatory
(p_signatory_id VARCHAR2)
RETURN VARCHAR2 AS
v_signatory  giis_signatory_names.signatory%TYPE;
BEGIN
FOR rec IN (SELECT signatory
             FROM giis_signatory_names
            WHERE signatory_id = p_signatory_id)
 LOOP
     v_signatory := rec.signatory;
     EXIT;
 END LOOP;
RETURN (v_signatory);
END;
/


