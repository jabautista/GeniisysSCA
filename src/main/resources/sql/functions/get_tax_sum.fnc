DROP FUNCTION CPI.GET_TAX_SUM;

CREATE OR REPLACE FUNCTION CPI.GET_TAX_SUM(
          p_policy_id    GIPI_INVOICE.policy_id%TYPE) RETURN GIPI_INV_TAX.TAX_AMT%TYPE IS
          
          v_tax_sum  GIPI_INV_TAX.TAX_AMT%TYPE;
     BEGIN 
          SELECT SUM(a.tax_amt) 
            INTO v_tax_sum
            FROM gipi_inv_tax a, gipi_invoice b  
           WHERE a.iss_cd = b.iss_cd
             AND a.prem_seq_no = b.prem_seq_no
             AND b.policy_id = p_policy_id;
 
     RETURN(v_tax_sum);
END;
/


