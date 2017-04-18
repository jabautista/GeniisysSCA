DROP TRIGGER CPI.GIIS_ADHOC_REPORTS;

CREATE OR REPLACE TRIGGER CPI.GIIS_ADHOC_REPORTS
BEFORE INSERT OR UPDATE
ON CPI.GIIS_ADHOC_REPORTS FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE := SYSDATE;
END;
/


