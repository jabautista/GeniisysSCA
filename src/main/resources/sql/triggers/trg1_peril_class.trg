DROP TRIGGER CPI.TRG1_PERIL_CLASS;

CREATE OR REPLACE TRIGGER CPI.TRG1_PERIL_CLASS
BEFORE INSERT OR UPDATE
ON CPI.GIIS_PERIL_CLASS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
     :NEW.user_ID  := NVL (giis_users_pkg.app_user, USER);
     :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/


