DROP TRIGGER CPI.TRG1_TAX_PERIL;

CREATE OR REPLACE TRIGGER CPI.TRG1_TAX_PERIL
BEFORE INSERT OR UPDATE
ON CPI.GIIS_TAX_PERIL FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
       :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
       :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/


