DROP FUNCTION CPI.GET_CORPORATE_TAG;

CREATE OR REPLACE FUNCTION CPI.get_corporate_tag
(p_corporate_tag VARCHAR2)
RETURN VARCHAR2 AS
v_rv_meaning  cg_ref_codes.rv_meaning%TYPE;
BEGIN
/*Created by     : Jayr
**Date created   : 012903
**Description    : This will return the value of 'dsp_corporate_tag'
*/
	FOR rec IN (SELECT rv_meaning
	            FROM cg_ref_codes
	           WHERE rv_domain = 'GIIS_ASSURED.CORPORATE_TAG'
	             AND rv_low_value = p_corporate_tag)
	LOOP
	    v_rv_meaning := rec.rv_meaning;
	    EXIT;
	END LOOP;
RETURN (v_rv_meaning);
END;
/


