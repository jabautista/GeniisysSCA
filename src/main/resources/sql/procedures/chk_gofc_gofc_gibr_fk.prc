DROP PROCEDURE CPI.CHK_GOFC_GOFC_GIBR_FK;

CREATE OR REPLACE PROCEDURE CPI.chk_gofc_gofc_gibr_fk(
  p_gibr_gfun_fund_cd      IN       GIAC_BRANCHES.gfun_fund_cd%TYPE,
  p_gibr_branch_cd         IN       GIAC_BRANCHES.branch_cd%TYPE,
  p_msg_alert              OUT      VARCHAR2
  ) 
  IS

/*
**  Created by        : Veronica V. Raymundo 
**  Date Created     : 12.29.2010
**  Reference By     : GIACS012 - Collection From Other Offices
**  Description 	: This procedure checks if the fund_cd and branch_cd exist
**                    
*/ 
  
  v_branch_name                 GIAC_BRANCHES.branch_name%TYPE;
  v_fund_desc                   GIIS_FUNDS.fund_desc%TYPE;

BEGIN
  p_msg_alert   :=  'SUCCESS';
  
  DECLARE
    CURSOR C IS
      SELECT gibr.branch_name
            ,gfun.fund_desc
      FROM   GIAC_BRANCHES gibr
            ,GIIS_FUNDS gfun
      WHERE  gibr.gfun_fund_cd = p_gibr_gfun_fund_cd
      AND    gibr.branch_cd    = p_gibr_branch_cd
      AND    gfun.fund_cd      = gibr.gfun_fund_cd;
  
  BEGIN
    OPEN C;
    FETCH C
    INTO   v_branch_name
          ,v_fund_desc;
    
    IF C%NOTFOUND THEN
        p_msg_alert   :=  'This Fund Code,Branch Code does not exist';  
    END IF;
    CLOSE C;
  END;
END;
/


