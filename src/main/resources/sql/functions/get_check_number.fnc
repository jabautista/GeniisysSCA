DROP FUNCTION CPI.GET_CHECK_NUMBER;

CREATE OR REPLACE FUNCTION CPI.Get_Check_Number (p_tran_id IN GIAC_CHK_DISBURSEMENT.gacc_tran_id%TYPE)
                  RETURN VARCHAR2 AS
/* created by judyann 02292008
** used in sorting records by check number
*/
 CURSOR c (p_tran_id IN GIAC_CHK_DISBURSEMENT.gacc_tran_id%TYPE) IS

     SELECT check_pref_suf||'-'||check_no check_number
       FROM GIAC_CHK_DISBURSEMENT
      WHERE gacc_tran_id = p_tran_id;

     p_check_number  VARCHAR2(20);

 BEGIN
   OPEN c (p_tran_id);
   FETCH c INTO p_check_number;
   IF c%FOUND THEN
     CLOSE c;
     RETURN p_check_number;
   ELSE
     CLOSE c;
     RETURN NULL;
   END IF;
 END;
/


