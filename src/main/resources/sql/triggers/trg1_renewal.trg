DROP TRIGGER CPI.TRG1_RENEWAL;

CREATE OR REPLACE TRIGGER CPI.TRG1_RENEWAL
BEFORE INSERT OR UPDATE
ON CPI.GIIS_RENEWAL FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
       :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
       :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/


