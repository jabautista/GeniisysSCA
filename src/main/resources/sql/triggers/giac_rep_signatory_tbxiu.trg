DROP TRIGGER CPI.GIAC_REP_SIGNATORY_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIAC_REP_SIGNATORY_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIAC_REP_SIGNATORY FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


