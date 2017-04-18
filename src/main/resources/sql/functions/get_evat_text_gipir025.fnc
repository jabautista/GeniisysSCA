DROP FUNCTION CPI.GET_EVAT_TEXT_GIPIR025;

CREATE OR REPLACE FUNCTION CPI.GET_EVAT_TEXT_GIPIR025 (
    p_policy_id         GIPI_INVOICE.policy_id%TYPE,
    p_item_grp          GIPI_INVOICE.item_grp%TYPE
) RETURN VARCHAR2 IS
  v_param_value_n     NUMBER(2):= 0;
  v_evat_desc         VARCHAR2(100);
begin
  SELECT PARAM_VALUE_N
    INTO v_param_value_n
    FROM GIIS_PARAMETERS
   WHERE PARAM_NAME LIKE 'EVAT'
     AND PARAM_TYPE = 'N';      
    
   v_evat_desc := NULL;  
   FOR C IN (
         SELECT B.tax_cd tax_cd, B.tax_amt tax_amt 
           FROM gipi_invoice A, gipi_inv_tax B, gipi_polbasic d
          WHERE A.prem_seq_no = B.prem_seq_no
            AND A.iss_cd = B.iss_cd
            AND b.item_grp  = p_item_grp
            AND a.policy_id = d.policy_id
            AND A.policy_id = p_policy_id
            AND b.tax_cd = v_param_value_n)  
   LOOP  
      IF c.tax_amt <> 0 THEN
           v_evat_desc := '(VATABLE)';
        ELSIF c.tax_amt = 0 THEN
           v_evat_desc := '(ZERO RATE)';
        ELSIF c.tax_amt IS NULL THEN
           v_evat_desc := '(VAT EXEMPT)';
        END IF;
      EXIT;
   END LOOP;

   IF v_evat_desc IS NULL THEN
      v_evat_desc := '(VAT EXEMPT)';
   END IF;
  	
   RETURN(v_evat_desc);
END GET_EVAT_TEXT_GIPIR025;
/


