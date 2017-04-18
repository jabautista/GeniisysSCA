DROP TRIGGER CPI.GICL_ITEM_PERIL_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GICL_ITEM_PERIL_TAIUX
    AFTER INSERT OR UPDATE OF claim_id, item_no, peril_cd, grouped_item_no
    ON CPI.GICL_ITEM_PERIL FOR EACH ROW
DECLARE
  --BETH 07102002
  --recreate this trigger to solve error in getting intermediary record
  v_claim_id                  gicl_item_peril.claim_id%TYPE  :=  :NEW.claim_id;
  v_item_no                   gicl_item_peril.item_no%TYPE   :=  :NEW.item_no;
  v_peril_cd                  gicl_item_peril.peril_cd%TYPE  :=  :NEW.peril_cd;
  v_grouped_item_no           gicl_item_peril.grouped_item_no%TYPE := NVL(:NEW.grouped_item_no,0);
  -- function that will retrieved the parent intermediary of
  -- a particular intermediary
  
BEGIN
  -- for update of claim_id, peril_cd and item_no
  -- delete first the records in table gicl_intmperil
  -- so that duplication of records will be eliminated
  IF UPDATING THEN
     DELETE FROM gicl_intm_itmperil
      WHERE claim_id        = :OLD.claim_id
        AND peril_cd        = :OLD.peril_cd
        AND item_no         = :OLD.item_no
        AND grouped_item_no = :OLD.grouped_item_no;
  END IF;

  gicl_trig(v_claim_id,
            v_item_no,
            v_peril_cd,
            v_grouped_item_no
           ); 

END;
/


