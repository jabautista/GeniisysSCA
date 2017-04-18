DROP TRIGGER CPI.TRG1_PARAMETERS;

CREATE OR REPLACE TRIGGER CPI.TRG1_PARAMETERS
BEFORE INSERT OR UPDATE
ON CPI.GIIS_PARAMETERS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
     :NEW.user_ID  := NVL (giis_users_pkg.app_user, USER);
     :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/


