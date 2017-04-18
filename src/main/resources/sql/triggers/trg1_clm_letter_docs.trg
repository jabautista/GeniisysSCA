DROP TRIGGER CPI.TRG1_CLM_LETTER_DOCS;

CREATE OR REPLACE TRIGGER CPI.TRG1_CLM_LETTER_DOCS
BEFORE INSERT OR DELETE OR UPDATE
ON CPI.GIIS_CLM_LETTER_DOCS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
       :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
       :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/


