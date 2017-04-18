DROP TRIGGER CPI.TRG1_COC_SEQ;

CREATE OR REPLACE TRIGGER CPI.TRG1_COC_SEQ
BEFORE INSERT OR UPDATE
ON CPI.GIIS_COC_SEQ FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
    :NEW.user_ID   := NVL (giis_users_pkg.app_user, USER);
    :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/

