DROP PROCEDURE CPI.COMPUTE_TARF_ENDT_PERIL;

CREATE OR REPLACE PROCEDURE CPI.compute_tarf_endt_peril(p_tsi_amt           IN GIPI_WITMPERL.tsi_amt%TYPE,
                                                        p_prem_amt          IN OUT GIPI_WITMPERL.prem_amt%TYPE,                                                        
                                                        p_tariff_cd         IN NUMBER,
                                                        p_default_tag       IN VARCHAR2,
                                                        p_default_prem_amt  IN GIPI_WITMPERL.prem_amt%TYPE) IS  

/*
**  Created by    : Menandro G.C. Robes
**  Date Created  : June 17, 2010
**  Reference By  : (GIPIS097 - Endorsement Item Peril Information)
**  Description   : Procedure to compute for tariff amount.
*/ 
  v_prem_amt  GIPI_WITMPERL.prem_amt%TYPE;
  
BEGIN 
  IF p_default_tag = '1' THEN
    v_prem_amt := p_default_prem_amt;
  ELSIF p_default_tag = '2' THEN
    FOR AMT IN
      (SELECT NVL(fixed_premium,0) fix, NVL(si_deductible,0) deduct, NVL(excess_rate,0) excess, 
              NVL(loading_rate,0) load, NVL(discount_rate ,0) discount, NVL(additional_premium,0) add_prem
         FROM giis_tariff_rates_dtl
        WHERE tariff_cd = p_tariff_cd) 
    LOOP
      v_prem_amt := ((amt.fix + ((p_tsi_amt - amt.deduct) * (amt.excess/100))) +
                    ((amt.fix + ((p_tsi_amt - amt.deduct) * (amt.excess/100))) * (amt.load/100))) -
                    (((amt.fix + ((p_tsi_amt - amt.deduct) * (amt.excess/100))) +
                    ((amt.fix + ((p_tsi_amt - amt.deduct) * (amt.excess/100))) * (amt.load/100))) * (amt.discount/100)) +
                    amt.add_prem;                                              
    END LOOP;
  ELSIF p_default_tag = '3' THEN
    FOR AMT IN 
      (SELECT NVL(fixed_premium,0) fixed
         FROM giis_tariff_rates_dtl
        WHERE tariff_cd = p_tariff_cd) 
    LOOP
      v_prem_amt := amt.fixed;
    END LOOP;                
  END IF;     

  p_prem_amt := v_prem_amt;
  --:b490.ann_prem_amt :=  p2_ann_prem_amt;
  --:b490.ann_tsi_amt  :=  p2_ann_tsi_amt;                                                 
END;
/


