DROP PROCEDURE CPI.AUTO_COMPUTE_PREM_RT;

CREATE OR REPLACE PROCEDURE CPI.auto_compute_prem_rt (
   p_par_id              gipi_wpolbas.par_id%TYPE,
   p_prem_amt            gipi_witmperl.prem_amt%TYPE,
   p_tsi_amt             gipi_witmperl.tsi_amt%TYPE,
   p_prorate_flag       IN       gipi_witem.prorate_flag%TYPE,
   p_prem_rt    IN OUT   NUMBER --gipi_witmperl.prem_rt%TYPE   
)
IS
   v_prorate_flag   gipi_wpolbas.prorate_flag%TYPE;
   v_comp_sw        gipi_wpolbas.comp_sw%TYPE;
   v_prorate        NUMBER;
   v_from_date      DATE;
   v_to_date        DATE;
   v_rate           NUMBER;
   v_short_rate     NUMBER;
   v_current_item   VARCHAR2 (40);
BEGIN
   --v_current_item := :SYSTEM.current_item;
   IF NVL (p_prem_amt, 0) != 0 AND NVL (p_tsi_amt, 0) != 0
   THEN
      SELECT prorate_flag, comp_sw, eff_date, NVL(endt_expiry_date, expiry_date), (short_rt_percent / 100)
        INTO v_prorate_flag, v_comp_sw, v_from_date, v_to_date, v_short_rate
        FROM gipi_wpolbas
       WHERE par_id = p_par_id;

      IF v_prorate_flag = '1'
      THEN
         IF v_comp_sw = 'Y'
         THEN
            v_prorate := ((TRUNC (v_to_date) - TRUNC (v_from_date)) + 1);                                                     --/
         --check_duration(v_from_date, v_to_date);
         ELSIF v_comp_sw = 'M'
         THEN
            v_prorate := ((TRUNC (v_to_date) - TRUNC (v_from_date)) - 1);                                                     --/
         --check_duration(v_from_date, v_to_date);
         ELSE
            v_prorate := (TRUNC (v_to_date) - TRUNC (v_from_date));                                                           --/
         --check_duration(v_from_date, v_to_date);
         END IF;

         v_rate := ((NVL (p_prem_amt, 0) * check_duration (v_from_date, v_to_date)) / (NVL (p_tsi_amt, 1) * (v_prorate))) * 100;
      ELSIF NVL(p_prorate_flag, v_prorate_flag) = '2' -- andrew 11.7.2012 added NVL
      THEN
         v_rate := (((NVL (p_prem_amt, 0) / NVL (p_tsi_amt, 1)))) * 100;
      ELSE
         v_rate := (NVL (p_prem_amt, 0) / (NVL (p_tsi_amt, 1) * NVL (v_short_rate, 1))) * 100;
      END IF;

      IF v_rate > 100 
      THEN
--         p_tsi_amt := :b490.nbt_tsi_amt;
--         p_prem_amt := :b490.nbt_prem_amt;

--               --A.R.C. 11.15.2006
--         --to reset the values of TSI and Prem
--         IF :SYSTEM.cursor_item IN ('B490.PREM_AMT', 'B490.TSI_AMT')
--         THEN
--            :b480.tsi_amt := NVL (variables.b480_tsi_amt, 0);
--            :b480.prem_amt := NVL (variables.b480_prem_amt, 0);
--         END IF;
         
         raise_application_error (-20001, 'Geniisys Exception#I#Premium Rate exceeds 100%, please check your Premium Computation Conditions at Basic Information Screen.');
      ELSIF v_rate < 0 THEN
         raise_application_error (-20001, 'Geniisys Exception#I#Rate must not be less than zero (0%).');
      END IF;
            
      p_prem_rt := v_rate;
   END IF;
END;
/


