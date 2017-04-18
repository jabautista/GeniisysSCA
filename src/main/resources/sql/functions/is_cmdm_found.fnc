DROP FUNCTION CPI.IS_CMDM_FOUND;

CREATE OR REPLACE FUNCTION CPI.is_cmdm_found (
   p_gopp_tran_id   giac_disb_vouchers.gacc_tran_id%TYPE
)
   RETURN BOOLEAN
IS
   CURSOR cm_dm
   IS
      SELECT gacc_tran_id
        FROM giac_cm_dm
       WHERE dv_tran_id = p_gopp_tran_id;

   v_cm      NUMBER;
   v_found   BOOLEAN := FALSE;
BEGIN
   OPEN cm_dm;

   FETCH cm_dm
    INTO v_cm;

   IF cm_dm%FOUND
   THEN
      v_found := TRUE;
   END IF;

   RETURN v_found;
END;
/


