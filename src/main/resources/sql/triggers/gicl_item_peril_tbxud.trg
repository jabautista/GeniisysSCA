DROP TRIGGER CPI.GICL_ITEM_PERIL_TBXUD;

CREATE OR REPLACE TRIGGER CPI.GICL_ITEM_PERIL_TBXUD
  BEFORE DELETE OR UPDATE OF claim_id, item_no, peril_cd, grouped_item_no
  ON CPI.GICL_ITEM_PERIL FOR EACH ROW
DECLARE
BEGIN
  DELETE FROM gicl_intm_itmperil
   WHERE peril_cd       = :OLD.peril_cd
     AND item_no        = :OLD.item_no
     AND claim_id       = :OLD.claim_id
	 AND grouped_item_no = :OLD.grouped_item_no;
END;
/


