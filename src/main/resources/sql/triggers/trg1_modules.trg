DROP TRIGGER CPI.TRG1_MODULES;

CREATE OR REPLACE TRIGGER CPI.TRG1_MODULES
BEFORE INSERT OR UPDATE
ON CPI.GIIS_MODULES FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
    :NEW.user_ID  := NVL (giis_users_pkg.app_user, USER);
    :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/

