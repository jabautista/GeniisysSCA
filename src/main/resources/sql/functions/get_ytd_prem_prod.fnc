DROP FUNCTION CPI.GET_YTD_PREM_PROD;

CREATE OR REPLACE FUNCTION CPI.get_ytd_prem_prod(p_date		 DATE,
									    	 p_line	  	 VARCHAR2,
											 p_sub     	 VARCHAR2,
									    	 p_branch  	 VARCHAR2,
											 p_intm	     NUMBER,
											 p_assd		 VARCHAR2)

 RETURN NUMBER AS
  v_ytd_prem  NUMBER;

BEGIN

  FOR ytd IN (
    SELECT NVL(SUM(prod_prem),0) ytd_prem
      FROM eim_production_ext
     WHERE 1=1
       AND line_cd 		                          = NVL(p_line, line_cd)
       AND subline_cd 							  = NVL(p_sub, subline_cd)
       AND branch_cd 								  = NVL(p_branch, branch_cd)
	   AND intm_no						  = NVL(p_intm, intm_no)
	   AND assd_no								  = NVL(p_assd, assd_no)
       AND acct_prod_date  >= TO_DATE ('01-01-'||TO_CHAR(p_date, 'YYYY'),'MM-DD-YYYY')
       AND acct_prod_date  <= p_date)
  LOOP
    v_ytd_prem := ytd.ytd_prem;
  END LOOP;

  RETURN (v_ytd_prem);

END;
/

DROP FUNCTION CPI.GET_YTD_PREM_PROD;
