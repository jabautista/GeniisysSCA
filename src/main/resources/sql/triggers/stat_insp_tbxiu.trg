DROP TRIGGER CPI.STAT_INSP_TBXIU;

CREATE OR REPLACE TRIGGER CPI.STAT_INSP_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_STAT_INSP FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
     :NEW.user_ID  := NVL (giis_users_pkg.app_user, USER);
     :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/


