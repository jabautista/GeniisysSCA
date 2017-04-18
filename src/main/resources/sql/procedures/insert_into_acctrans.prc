DROP PROCEDURE CPI.INSERT_INTO_ACCTRANS;

CREATE OR REPLACE PROCEDURE CPI.insert_into_acctrans(
       p_fund_cd   IN  GIAC_ACCTRANS.gfun_fund_cd%TYPE,
       p_branch_cd IN  GIAC_ACCTRANS.gibr_branch_cd%TYPE,
       p_user_id   IN  GIIS_USERS.user_id%TYPE,
       p_tran_id   OUT GIAC_ACCTRANS.tran_id%TYPE,
       p_msg_alert OUT VARCHAR2) IS

  v_tran_seq_no   GIAC_ACCTRANS.tran_seq_no%TYPE;

   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.21.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Executes insert_into_acctrans program unit in GICLS043
   **                 
   */

BEGIN
  
  BEGIN 
    SELECT acctran_tran_id_s.NEXTVAL
      INTO p_tran_id
      FROM dual;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN   
         p_msg_alert := 'ACCTRAN_TRAN_ID_S sequence does not exist.';
  END;
  
  INSERT INTO GIAC_ACCTRANS(tran_id, gfun_fund_cd, 
                            gibr_branch_cd, tran_date,
                            tran_flag, tran_class,
                            user_id, last_update)
         VALUES(p_tran_id, p_fund_cd,p_branch_cd, SYSDATE, 
                            'O', 'DV', p_user_id, SYSDATE);

  IF SQL%NOTFOUND THEN               
     p_msg_alert := 'Cannot insert into GIAC_ACCTRANS'; 
  END IF;
END insert_into_acctrans;
/


