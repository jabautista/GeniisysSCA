DROP FUNCTION CPI.CF_VATABLE_GIPIR913;

CREATE OR REPLACE FUNCTION CPI.CF_VATABLE_GIPIR913(
    p_policy_id     GIPI_POLBASIC.policy_id%TYPE,
    p_prem_amt      GIPI_POLBASIC.prem_amt%TYPE
) RETURN NUMBER IS
    vat_amount   number;
    v_prem_vat number;
    v_diff     number;
    v_evat     number;
BEGIN
   /*
   **   Created By:     D.Alcantara, 03/31/2011
   */
   SELECT ix.tax_amt 
         INTO vat_amount
        FROM GIPI_INVOICE iv
               ,GIIS_CURRENCY cy
               ,GIPI_INV_TAX ix
               ,GIIS_TAX_CHARGES tc
       WHERE iv.currency_cd = cy.main_currency_cd
         AND iv.iss_cd = ix.iss_cd
         AND ix.iss_cd = tc.iss_cd
         AND iv.prem_seq_no = ix.prem_seq_no
         AND ix.line_cd = tc.line_cd
         AND ix.tax_cd = tc.tax_cd
         AND tc.tax_cd = giisp.n('EVAT')
         and iv.policy_id = p_policy_id;
        
    v_evat := (vat_amount/.12);
    v_diff := (p_prem_amt - v_evat);
    if abs(v_diff) <= 5 and vat_amount != 0 then
        v_prem_vat := p_prem_amt;
        
    elsif abs(v_diff) > 5 and vat_amount != 0 then
        v_prem_vat := (p_prem_amt - v_diff);
    else
        v_prem_vat := 0;
    end if;
    
    return (v_prem_vat);  
     EXCEPTION
            when no_data_found THEN
         v_prem_vat := 0;
    
    return(v_prem_vat);
END CF_VATABLE_GIPIR913;
/


