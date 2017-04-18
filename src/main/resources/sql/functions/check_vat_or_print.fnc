DROP FUNCTION CPI.CHECK_VAT_OR_PRINT;

CREATE OR REPLACE FUNCTION CPI.CHECK_VAT_OR_PRINT (
    p_tran_id       GIAC_OP_TEXT.gacc_tran_id%TYPE,
    p_branch_cd     GIAC_OR_PREF.branch_cd%TYPE,
    p_fund_cd       GIAC_OR_PREF.fund_cd%TYPE
) RETURN VARCHAR2 IS
    v_exist         varchar2(1);
    v_exist2         varchar2(1);    
    v_tax_exist varchar2(1);
    v_pd_exist    varchar2(1);
    v_diff             giac_acct_entries.debit_amt%type;
	v_tax_cd 		giac_taxes.tax_cd%type;
    v_print_type    VARCHAR2(1) := 'N';
BEGIN
    FOR rec IN (SELECT '1' exist_1 
                FROM giac_direct_prem_collns
                  WHERE gacc_tran_id = p_tran_id
                UNION		
                SELECT '1' exist_1 
                  FROM giac_inwfacul_prem_collns
                 WHERE gacc_tran_id = p_tran_id)
    LOOP
        v_exist := rec.exist_1;
    END LOOP;
    
    FOR pdep IN (SELECT '1' exist_2
                 FROM giac_prem_deposit
                WHERE gacc_tran_id = p_tran_id)
    LOOP
       v_exist2 := pdep.exist_2;
    END LOOP;	
    
    IF v_exist IS NOT NULL THEN
         FOR tax_cd IN (SELECT param_value_n tax
                      FROM giac_parameters
                     WHERE param_name = 'EVAT')
         LOOP
           v_tax_cd := tax_cd.tax;
         EXIT;
         END LOOP;
         
        FOR tax IN (SELECT '1' tax
                   FROM GIAC_DIRECT_PREM_COLLNS a, GIPI_INV_TAX b, GIAC_TAXES c
                  WHERE a.b140_iss_cd = b.iss_cd 
                    AND a.b140_prem_seq_no = b.prem_seq_no  
                    AND b.tax_cd  = c.tax_cd
                    AND c.fund_cd = p_fund_cd                   
   			  			    AND a.gacc_tran_id = p_tran_id 
                    AND c.tax_cd = v_tax_cd
                 UNION                                                     
                 SELECT '1' tax
                   FROM GIAC_INWFACUL_PREM_COLLNS a, GIPI_INV_TAX b, GIAC_TAXES c
                  WHERE a.b140_iss_cd = b.iss_cd 
                    AND a.b140_prem_seq_no = b.prem_seq_no  
                    AND b.tax_cd  = c.tax_cd
                    AND c.fund_cd = p_fund_cd                   
   			  			    AND a.gacc_tran_id = p_tran_id 
                    AND c.tax_cd = v_tax_cd)     
         LOOP
           v_tax_exist := tax.tax;
         EXIT;	
         END LOOP;
         
         IF v_tax_exist IS NOT NULL THEN
  		    v_print_type := 'V';
			--  default_vat_or;
         ELSE  	
            v_print_type := 'N';
           --   default_non_vat_or;
         END IF;
    
    ELSIF v_exist2 IS NOT NULL THEN    
        FOR p IN (SELECT '1' exist
                    FROM giac_prem_deposit
                   WHERE gacc_tran_id = p_tran_id
                     AND or_tag = 'V')              
        LOOP                     	
          v_pd_exist := p.exist;
        END LOOP;
        IF v_pd_exist IS NOT NULL THEN
             v_print_type := 'V';
             --default_vat_or;
            ELSE	  
             v_print_type := 'N';
             --default_non_vat_or;
        END IF;
        
    ELSIF (v_exist IS NULL OR v_exist2 IS NULL)  THEN
         --variables.v_nodetail := 1;
         FOR diff IN (SELECT (SUM(NVL(debit_amt,0))-SUM(NVL(credit_amt,0))) diff_sum 
                        FROM giac_acct_entries
                       WHERE gacc_tran_id = p_tran_id 
                         AND gacc_gibr_branch_cd = p_branch_cd
                         AND gacc_gfun_fund_cd = p_fund_cd)
         LOOP
           v_diff := diff.diff_sum;
         EXIT;	
         END LOOP;
         IF v_diff = 0 THEN                  
              v_print_type := 'N';
         --     default_non_vat_or;
         ELSIF v_diff <> 0 THEN
              v_print_type := 'N';
         --   default_non_vat_or;
         END IF;	   
    END IF;
    RETURN v_print_type;
END CHECK_VAT_OR_PRINT;
/


