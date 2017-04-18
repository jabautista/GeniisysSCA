DROP TRIGGER CPI.TRG1_MODULES_TRAN;

CREATE OR REPLACE TRIGGER CPI.TRG1_MODULES_TRAN
BEFORE INSERT OR UPDATE
ON CPI.GIIS_MODULES_TRAN FOR EACH ROW
BEGIN
  :NEW.user_id  := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


