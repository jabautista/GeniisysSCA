DROP TRIGGER CPI.FBNDR_SEQ_TBXIU;

CREATE OR REPLACE TRIGGER CPI.FBNDR_SEQ_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_FBNDR_SEQ FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
     :NEW.user_ID  := NVL (giis_users_pkg.app_user, USER);
     :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/

