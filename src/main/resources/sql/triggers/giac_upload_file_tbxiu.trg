DROP TRIGGER CPI.GIAC_UPLOAD_FILE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIAC_UPLOAD_FILE_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIAC_UPLOAD_FILE FOR EACH ROW
BEGIN
  :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


