DROP FUNCTION CPI.DERIVE_POLICY_STATUS;

CREATE OR REPLACE FUNCTION CPI.derive_policy_status (
   p_par_status   IN cg_ref_codes.rv_low_value%TYPE
)
   RETURN VARCHAR2
IS
   v_drv_par_status   cg_ref_codes.rv_meaning%TYPE;
BEGIN
   FOR i
   IN (SELECT   rv_meaning
         FROM   cg_ref_codes
        WHERE   rv_domain = 'GIPI_PARHIST.PARSTAT_CD'
                AND rv_low_value = p_par_status)
   LOOP
      v_drv_par_status := i.rv_meaning;
   END LOOP;

   IF v_drv_par_status IS NULL
   THEN
      v_drv_par_status := 'Being Updated';
   END IF;

   RETURN (v_drv_par_status);
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;
/


