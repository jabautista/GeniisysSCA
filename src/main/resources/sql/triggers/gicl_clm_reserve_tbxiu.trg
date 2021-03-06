DROP TRIGGER CPI.GICL_CLM_RESERVE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GICL_CLM_RESERVE_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GICL_CLM_RESERVE FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE := SYSDATE;
  :NEW.GROUPED_ITEM_NO := NVL(:NEW.GROUPED_ITEM_NO,0);
END;
/


