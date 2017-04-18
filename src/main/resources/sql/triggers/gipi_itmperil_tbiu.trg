DROP TRIGGER CPI.GIPI_ITMPERIL_TBIU;

CREATE OR REPLACE TRIGGER CPI.GIPI_ITMPERIL_TBIU
BEFORE INSERT OR UPDATE ON CPI.GIPI_ITMPERIL FOR EACH ROW
BEGIN
--  replaced codes by robert SR 21705 03.09.16
--  FOR A IN (SELECT prorate_flag
--              FROM gipi_polbasic
--             WHERE policy_id = :NEW.policy_id)
--  LOOP            
--    IF A.prorate_flag = '2' AND :NEW.tsi_amt <> 0 THEN
--       :NEW.prem_rt := ROUND(:NEW.prem_amt/:NEW.tsi_amt,9)*100;
--    END IF; 
--    EXIT;
--  END LOOP;
   IF ABS (ROUND (:NEW.tsi_amt * (:NEW.prem_rt / 100), 2) - :NEW.prem_amt) > 0.05
   THEN
      FOR a IN (SELECT a.prorate_flag, a.prov_prem_tag,
                       a.discount_sw pol_disc_sw, a.surcharge_sw pol_sur_sw,
                       b.discount_sw itm_disc_sw, b.surcharge_sw itm_sur_sw
                  FROM gipi_polbasic a, gipi_item b
                 WHERE a.policy_id = :NEW.policy_id
                   AND a.policy_id = b.policy_id
                   AND b.item_no = :NEW.item_no)
      LOOP
         IF     a.prov_prem_tag = 'N'
            AND NVL(a.pol_disc_sw,'N') = 'N'
            AND NVL(a.pol_sur_sw,'N') = 'N'
            AND NVL(a.itm_disc_sw,'N') = 'N'
            AND NVL(a.itm_sur_sw, 'N') = 'N'
            AND NVL(:NEW.discount_sw,'N') = 'N'
            AND NVL(:NEW.surcharge_sw,'N') = 'N'
            AND a.prorate_flag = '2'
            AND :NEW.tsi_amt <> 0
         THEN
            :NEW.prem_rt := ROUND (:NEW.prem_amt / :NEW.tsi_amt, 9) * 100;
         END IF;
         EXIT;
      END LOOP;
   END IF;
END;
/


