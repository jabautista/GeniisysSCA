DROP FUNCTION CPI.CF_VATTOTAL_FORMULA;

CREATE OR REPLACE FUNCTION CPI.cf_vattotal_formula(v_pol GIPI_INVOICE.POLICY_ID%TYPE) 
   RETURN NUMBER IS
  v_vat_total	NUMBER  := 0;
  v_ri_comm_vat	NUMBER  := 0;
  v_prem_vat    NUMBER  := 0;
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
     FOR b IN (SELECT b.tax_amt tax
                 FROM gipi_invoice a,
                      gipi_inv_tax b
                WHERE a.iss_cd = b.iss_cd
                  AND a.prem_seq_no = b.prem_seq_no
                  AND a.policy_id   = v_pol)
     LOOP
  	   v_prem_vat := ROUND(NVL(b.tax,0),2);
  	   EXIT;
     END LOOP;	                     
     v_vat_total := NVL(v_prem_vat,0) - NVL(v_ri_comm_vat,0);
  RETURN(v_vat_total);
END cf_vattotal_formula;
/


