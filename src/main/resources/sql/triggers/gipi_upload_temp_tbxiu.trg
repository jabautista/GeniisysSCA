DROP TRIGGER CPI.GIPI_UPLOAD_TEMP_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIPI_UPLOAD_TEMP_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIPI_UPLOAD_TEMP FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
    :NEW.user_id := NVL (giis_users_pkg.app_user, USER);
    :NEW.last_update := SYSDATE;
  END;
END;
/

