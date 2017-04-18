DROP FUNCTION CPI.COMPUTE_PREM_AMT;

CREATE OR REPLACE FUNCTION CPI.COMPUTE_PREM_AMT (p_prorate_flag     gipi_polbasic.prorate_flag%TYPE,
                                             p_incept_date      gipi_polbasic.incept_date%TYPE,
											 p_expiry_date      gipi_polbasic.expiry_date%TYPE,
											 p_short_rt_pct     gipi_polbasic.short_rt_percent%TYPE,
											 p_prem_rt			gipi_itmperil.prem_rt%TYPE,
											 p_tsi_amt			gipi_itmperil.tsi_amt%TYPE)
  RETURN NUMBER IS
   
   v_prem_amt    gipi_itmperil.prem_amt%TYPE := 0;

BEGIN
 
  IF p_prorate_flag = 1 THEN
 
     v_prem_amt := (TO_NUMBER(p_expiry_date - p_incept_date)/TO_NUMBER(ADD_MONTHS(p_incept_date,12)-p_incept_date) * 
	               (p_prem_rt/100) * p_tsi_amt);
 
  ELSIF p_prorate_flag = 2 OR p_prorate_flag IS NULL THEN
	
	 v_prem_amt := p_tsi_amt * (p_prem_rt/100);

  ELSE

   	v_prem_amt := p_tsi_amt * (p_prem_rt/100) * p_short_rt_pct;

  END IF;
  RETURN v_prem_amt;
  
END COMPUTE_PREM_AMT;
/


