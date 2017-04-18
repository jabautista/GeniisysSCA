DROP TRIGGER CPI.GILO_LOSSES_EXTRACT_TAXIU;

CREATE OR REPLACE TRIGGER CPI.GILO_LOSSES_EXTRACT_TAXIU
--
-- Created by AL
--
-- Created date: July 31, 2000
--
-- Purpose: For EIM (Executive Inquiry MOdule) Claims monitoring
-- Tables Affected:
--  GICL_CLAIMS - IUD
--  GILO_LOSSES_EXTRACT - IUD
--
-- Remarks: (Please record all the necessary changes made.)
--   07-31-2000 - Original Version
--
AFTER INSERT OR UPDATE OF loss_res_amt, loss_pd_amt, exp_res_amt,
      exp_pd_amt ON CPI.GICL_CLAIMS FOR EACH ROW
DECLARE
   v_exist VARCHAR2(1) := 'N';
BEGIN
  FOR exist IN (
    SELECT 'a'
      FROM gilo_losses_extract
     WHERE claim_id = :NEW.claim_id)
  LOOP
    v_exist := 'Y';
  END LOOP;
  IF v_exist = 'N' THEN
    IF INSERTING THEN
      INSERT INTO gilo_losses_extract(
        claim_id,       rec_status)
      VALUES(
        :new.claim_id, 'I');
    ELSIF UPDATING THEN
      INSERT INTO gilo_losses_extract(
        claim_id,      rec_status)
      VALUES(
        :new.claim_id, 'U');
    END IF;
  END IF;
END;
/


