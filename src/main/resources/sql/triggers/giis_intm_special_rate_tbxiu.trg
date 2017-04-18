DROP TRIGGER CPI.GIIS_INTM_SPECIAL_RATE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIIS_INTM_SPECIAL_RATE_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_INTM_SPECIAL_RATE FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
       :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
       :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/


