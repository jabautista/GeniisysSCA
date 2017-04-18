DROP TRIGGER CPI.TRG1_VESSEL;

CREATE OR REPLACE TRIGGER CPI.TRG1_VESSEL
BEFORE INSERT OR UPDATE
ON CPI.GIIS_VESSEL FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
       :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
       :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/

