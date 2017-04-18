DROP FUNCTION CPI.VALIDATE_ADD_WARR_CLA;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_ADD_WARR_CLA (p_main_wc_cd VARCHAR2)
   RETURN VARCHAR2
IS
   v_main_wc_cd     VARCHAR2 (2);
BEGIN
     SELECT( SELECT '0'
                 FROM giis_warrcla
                WHERE LOWER (main_wc_cd) LIKE LOWER (p_main_wc_cd)
            )
       INTO v_main_wc_cd
     FROM DUAL;

   IF v_main_wc_cd IS NOT NULL
   THEN
      RETURN v_main_wc_cd;
  END IF;
   
   RETURN '1';
END;
/


