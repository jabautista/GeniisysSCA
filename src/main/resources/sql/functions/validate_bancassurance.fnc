DROP FUNCTION CPI.VALIDATE_BANCASSURANCE;

CREATE OR REPLACE FUNCTION CPI.Validate_Bancassurance (
   p_par_id   GIPI_WCOMM_INVOICES.par_id%TYPE
)
   RETURN VARCHAR2
IS
   v_bancassurance   VARCHAR2(1) := NULL;

   BEGIN
    SELECT bancassurance_sw BANC_SW 
      INTO v_bancassurance
	  FROM GIPI_WPOLBAS
     WHERE par_id = p_par_id;
  IF v_bancassurance IS NULL OR v_bancassurance <> 'Y' THEN
     v_bancassurance := 'N';
  END IF;
  RETURN (v_bancassurance);	
END Validate_Bancassurance;
/


