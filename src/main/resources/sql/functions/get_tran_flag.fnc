DROP FUNCTION CPI.GET_TRAN_FLAG;

CREATE OR REPLACE FUNCTION CPI.get_tran_flag (
   p_gacc_tran_id   IN   giac_order_of_payts.gacc_tran_id%TYPE
)
   RETURN VARCHAR2
IS
   v_tran_flag   giac_acctrans.tran_flag%TYPE;
BEGIN
   FOR t IN (SELECT tran_flag
               FROM giac_acctrans
              WHERE tran_id = p_gacc_tran_id)
   LOOP
      v_tran_flag := t.tran_flag;
   END LOOP;

   RETURN v_tran_flag;
END;
/


