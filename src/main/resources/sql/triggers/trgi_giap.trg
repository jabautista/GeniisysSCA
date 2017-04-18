DROP TRIGGER CPI.TRGI_GIAP;

CREATE OR REPLACE TRIGGER CPI.TRGI_GIAP
BEFORE INSERT OR UPDATE
ON CPI.GIAC_AGING_PARAMETERS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
       :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
       :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/


