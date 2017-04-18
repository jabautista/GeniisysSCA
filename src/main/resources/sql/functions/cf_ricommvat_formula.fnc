DROP FUNCTION CPI.CF_RICOMMVAT_FORMULA;

CREATE OR REPLACE FUNCTION CPI.cf_ricommvat_formula(v_pol GIPI_INVOICE.policy_id%TYPE) RETURN NUMBER IS
  v_ri_comm_vat	    NUMBER := 0;
BEGIN
	 FOR a IN ( SELECT comm_vat, currency_rt
                  FROM gipi_invoice a,
                       giac_aging_ri_soa_details b
                 WHERE a.iss_cd      = 'RI'
                   AND a.prem_seq_no = b.prem_seq_no
                   AND a.policy_id   = v_pol)
     LOOP
  	   v_ri_comm_vat := ROUND(NVL(a.comm_vat, 0)/NVL(a.currency_rt,1),2);
  	   EXIT;
     END LOOP;	              
  RETURN(v_ri_comm_vat);
END cf_ricommvat_formula;
/


