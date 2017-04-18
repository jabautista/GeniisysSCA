DROP PROCEDURE CPI.BRANCH_SL_CD;

CREATE OR REPLACE PROCEDURE CPI.BRANCH_SL_CD (p_branch_cd     IN  giac_acctrans.gibr_branch_cd%type,
                        p_sl_cd         OUT giac_sl_lists.sl_cd%type) IS
BEGIN
  FOR c in (SELECT acct_iss_cd 
              FROM giis_issource
             WHERE iss_cd = p_branch_cd)               
  LOOP
    p_sl_cd := c.acct_iss_cd;  
  END LOOP; 
END;
/


