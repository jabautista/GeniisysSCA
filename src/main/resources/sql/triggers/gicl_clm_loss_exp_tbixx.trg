DROP TRIGGER CPI.GICL_CLM_LOSS_EXP_TBIXX;

CREATE OR REPLACE TRIGGER CPI.GICL_CLM_LOSS_EXP_TBIXX
BEFORE INSERT
ON CPI.GICL_CLM_LOSS_EXP FOR EACH ROW
DECLARE
BEGIN
--beth 08012006
--     get currency rate and code from table gicl_clm_res_hist instead of getting it from gicl_clm_item
  FOR c IN (SELECT currency_cd, convert_rate
     FROM gicl_clm_res_hist
    WHERE claim_id = :NEW.claim_id
      AND item_no  = :NEW.item_no
	  AND peril_cd = :NEW.peril_cd
	  AND dist_sw = 'Y'
	  AND tran_id IS NULL
	  AND grouped_item_no = NVL(:NEW.grouped_item_no,0)) --added by gmi
  LOOP
    :NEW.currency_cd   := c.currency_cd;
    :NEW.currency_rate := c.convert_rate;
  END LOOP;
END;
/


