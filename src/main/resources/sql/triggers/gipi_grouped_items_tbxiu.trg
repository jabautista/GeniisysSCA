DROP TRIGGER CPI.GIPI_GROUPED_ITEMS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIPI_GROUPED_ITEMS_TBXIU
  BEFORE INSERT OR UPDATE ON CPI.GIPI_GROUPED_ITEMS FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_id    := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


