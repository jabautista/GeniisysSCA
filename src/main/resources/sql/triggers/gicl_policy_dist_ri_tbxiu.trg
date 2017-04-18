DROP TRIGGER CPI.GICL_POLICY_DIST_RI_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GICL_POLICY_DIST_RI_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GICL_POLICY_DIST_RI FOR EACH ROW
DECLARE
BEGIN
  :NEW.GROUPED_ITEM_NO := NVL(:NEW.GROUPED_ITEM_NO,0);
END;
/


