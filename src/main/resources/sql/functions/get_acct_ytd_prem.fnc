DROP FUNCTION CPI.GET_ACCT_YTD_PREM;

CREATE OR REPLACE FUNCTION CPI.get_acct_ytd_prem(p_loss_date  DATE,
	    		   					         p_line_cd    VARCHAR2,
									         p_subline_cd VARCHAR2,
									         p_iss_cd     VARCHAR2,
											 p_intm_no	  NUMBER,
											 p_assd_no	  NUMBER)
RETURN NUMBER AS
  v_ytd_prem  NUMBER;

BEGIN

  FOR ytd IN (
    SELECT NVL(SUM(prod_prem),0) prem
	  FROM eim_production_ext
	 WHERE line_cd    = NVL(p_line_cd, line_cd)
	   AND subline_cd = NVL(p_subline_cd, subline_cd)
	   AND branch_cd  = NVL(p_iss_cd, branch_cd)
	   AND intm_no    = NVL(p_intm_no, intm_no)
	   AND assd_no    = NVL(p_assd_no, assd_no)
	   AND acct_prod_date >= TO_DATE ('01-01-'||TO_CHAR(p_loss_date, 'YYYY'),'MM-DD-YYYY')
       AND acct_prod_date <= p_loss_date)
  LOOP
    v_ytd_prem := ytd.prem;
  END LOOP;

  RETURN (v_ytd_prem);

END;
/

DROP FUNCTION CPI.GET_ACCT_YTD_PREM;
