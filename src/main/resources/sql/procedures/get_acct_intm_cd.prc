DROP PROCEDURE CPI.GET_ACCT_INTM_CD;

CREATE OR REPLACE PROCEDURE CPI.GET_ACCT_INTM_CD (
    p_claim_id       IN    gicl_claims.claim_id%type,
    p_acct_intm_cd  OUT    number
) 
IS
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 01.17.2012
    **  Reference By    : (GICLB001 - Batch O/S Takeup)
    **  Description     :  GET_ACCT_INTM_CD program unit;
    */
BEGIN
  FOR i IN (SELECT NVL(parent_intm_no,intrmdry_intm_no) intm_no
              FROM gicl_basic_intm_v1
             WHERE claim_id = p_claim_id)
  LOOP
    FOR c IN (SELECT a.acct_intm_cd
                FROM giis_intm_type a, giis_intermediary b
               WHERE a.intm_type =  b.intm_type
                 AND b.intm_no = i.intm_no)
    LOOP
      p_acct_intm_cd := c.acct_intm_cd;
    END LOOP;
  END LOOP;  
END;
/


