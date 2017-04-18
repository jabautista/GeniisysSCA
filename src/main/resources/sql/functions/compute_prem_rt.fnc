DROP FUNCTION CPI.COMPUTE_PREM_RT;

CREATE OR REPLACE FUNCTION CPI.compute_prem_rt (p_par_id       IN GIPI_WPOLBAS.par_id%TYPE,
                                                p_prem_amt     IN GIPI_WITMPERL.prem_amt%TYPE,
                                                p_tsi_amt      IN GIPI_WITMPERL.tsi_amt%TYPE,
                                                p_prorate_flag IN GIPI_WITEM.prorate_flag%TYPE)
  RETURN NUMBER IS
/*
**  Created by	    : Menandro G.C. Robes
**  Date Created 	: May 27, 2010
**  Reference By 	: (GIPIS097 - Endorsement Item Peril Information)
**  Description 	: Function to compute premium rate.
*/  
  
  v_prorate_flag  gipi_wpolbas.prorate_flag%TYPE;
  v_comp_sw       gipi_wpolbas.comp_sw%TYPE;            
  v_prorate       NUMBER;
  v_from_date     DATE;
  v_to_date       DATE;
  v_rate          NUMBER;
  v_short_rate    NUMBER;
  v_current_item  VARCHAR2(40);
BEGIN 
  SELECT prorate_flag,comp_sw,eff_date,expiry_date,(short_rt_percent/100)
    INTO v_prorate_flag,v_comp_sw,v_from_date,v_to_date,v_short_rate
    FROM gipi_wpolbas
   WHERE par_id = p_par_id;
         
      
  IF v_prorate_flag = '1' THEN
    IF v_comp_sw = 'Y' THEN
       v_prorate  :=  ((TRUNC( v_TO_DATE) - TRUNC( v_from_date )) + 1);                                                    
    ELSIF v_comp_sw = 'M' THEN
       v_prorate  :=  ((TRUNC( v_TO_DATE) - TRUNC( v_from_date )) - 1);
    ELSE
       v_prorate  :=  (TRUNC ( v_TO_DATE) - TRUNC( v_from_date ) );
    END IF;
       v_rate  :=  ((NVL(p_prem_amt,0) * check_duration(v_from_date, v_to_date)) / 
                      (NVL(p_tsi_amt,1) * (v_prorate))) * 100;                              
  ELSIF p_prorate_flag = 2 THEN
    v_rate  :=  (((NVL(p_prem_amt,0) / NVL(p_tsi_amt,1)))) * 100;
  ELSE
    v_rate  :=  (NVL(p_prem_amt,0) /
                  (NVL(p_tsi_amt,1) * NVL(v_short_rate,1))) * 100;
  END IF;     
    
  RETURN v_rate;     
  
--  IF v_rate > 100 THEN
--     Msg_alert('Premium Rate exceeds 100%, please check your Premium Computation Conditions at Basic Information Screen','I',TRUE);
--  ELSE 
--     490.prem_rt := v_rate;
--  END IF;            
END;
/


