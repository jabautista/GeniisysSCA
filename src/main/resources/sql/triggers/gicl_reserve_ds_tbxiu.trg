DROP TRIGGER CPI.GICL_RESERVE_DS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GICL_RESERVE_DS_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GICL_RESERVE_DS FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE := SYSDATE;
  :new.grouped_item_no := nvl(:new.grouped_item_no,0);
END;
/

