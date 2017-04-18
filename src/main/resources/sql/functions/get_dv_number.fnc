DROP FUNCTION CPI.GET_DV_NUMBER;

CREATE OR REPLACE FUNCTION CPI.Get_DV_Number (p_tran_id IN GIAC_DISB_VOUCHERS.gacc_tran_id%TYPE)
                  RETURN VARCHAR2 AS
/* created by judyann 02292008
** used in sorting records by DV number
*/
 CURSOR v (p_tran_id IN GIAC_DISB_VOUCHERS.gacc_tran_id%TYPE) IS

     SELECT dv_pref||'-'||dv_no dv_number
       FROM GIAC_DISB_VOUCHERS
      WHERE gacc_tran_id = p_tran_id;

     p_dv_number  VARCHAR2(20);

 BEGIN
   OPEN v (p_tran_id);
   FETCH v INTO p_dv_number;
   IF v%FOUND THEN
     CLOSE v;
     RETURN p_dv_number;
   ELSE
     CLOSE v;
     RETURN NULL;
   END IF;
 END;
/


