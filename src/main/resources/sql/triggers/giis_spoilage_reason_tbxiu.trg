DROP TRIGGER CPI.GIIS_SPOILAGE_REASON_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIIS_SPOILAGE_REASON_TBXIU
BEFORE INSERT OR UPDATE ON CPI.GIIS_SPOILAGE_REASON FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_ID     := NVL (giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE := SYSDATE;
END;
/


