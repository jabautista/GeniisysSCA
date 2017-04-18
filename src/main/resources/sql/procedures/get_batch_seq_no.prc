DROP PROCEDURE CPI.GET_BATCH_SEQ_NO;

CREATE OR REPLACE PROCEDURE CPI.get_batch_seq_no (
         p_fund_cd      IN  GIAC_PAYT_REQ_DOCS.gibr_gfun_fund_cd%TYPE,
         p_iss_cd       IN  GIAC_PAYT_REQ_DOCS.gibr_branch_cd%TYPE,
         p_batch_year   IN  GICL_BATCH_CSR_SEQ.batch_year%TYPE,
         p_user_id      IN  GIIS_USERS.user_id%TYPE,
         p_batch_seq_no OUT GICL_BATCH_CSR_SEQ.batch_seq_no%TYPE) IS
         
  /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.14.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Retrieves next value of batch_seq_no for batch CSR generation
   **                 
   */
  
  new_batch_seq_no      NUMBER DEFAULT 1;
  v_batch_seq_no        GICL_BATCH_CSR_SEQ.batch_seq_no%TYPE;
  
BEGIN
  BEGIN
    SELECT batch_seq_no + 1
      INTO v_batch_seq_no
      FROM GICL_BATCH_CSR_SEQ
     WHERE fund_cd    = p_fund_cd
       AND iss_cd     = p_iss_cd
       AND batch_year = p_batch_year;
       
    UPDATE GICL_BATCH_CSR_SEQ
       SET batch_seq_no = v_batch_seq_no
     WHERE fund_cd = p_fund_cd
       AND iss_cd  = p_iss_cd
       AND batch_year = p_batch_year;
    
    p_batch_seq_no := v_batch_seq_no;
    
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
           v_batch_seq_no := 1;
		   p_batch_seq_no := v_batch_seq_no;
    INSERT INTO GICL_BATCH_CSR_SEQ(fund_cd, iss_cd, batch_year, 
                                   batch_seq_no, user_id, last_update)       
    VALUES (p_fund_cd, p_iss_cd, p_batch_year, 
            new_batch_seq_no, NVL(p_user_id, USER), SYSDATE);
  END;
END;
/


