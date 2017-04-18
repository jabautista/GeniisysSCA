DROP FUNCTION CPI.GET_YTD_PREM_INTM;

CREATE OR REPLACE FUNCTION CPI.get_ytd_prem_intm(p_loss_year NUMBER,
	   	  		  		   					 p_loss_mm   NUMBER,
	    		   					         p_line_name VARCHAR2,
									         p_intm_name VARCHAR2,
									         p_ref_cd    VARCHAR2,
											 p_br_name	 VARCHAR2)
RETURN NUMBER AS
  v_ytd_prem  NUMBER;

BEGIN

  FOR ytd IN (
    SELECT NVL(SUM(prem_amt),0) ytd_prem
          FROM eim_intermediary_ext
         WHERE 1=1
		   AND line_name = p_line_name
           AND intermediary_name = p_intm_name
		   AND ref_code = p_ref_cd
		   AND branch_name = p_br_name
           AND TO_NUMBER(TO_CHAR(acct_prod_date,'YYYY')) = p_loss_year
           AND TO_NUMBER(TO_CHAR(acct_prod_date,'MM'))  <= p_loss_mm)
  LOOP
    v_ytd_prem := ytd.ytd_prem;
  END LOOP;

  RETURN (v_ytd_prem);

END;
/

DROP FUNCTION CPI.GET_YTD_PREM_INTM;

