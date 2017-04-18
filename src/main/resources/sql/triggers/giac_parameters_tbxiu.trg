DROP TRIGGER CPI.GIAC_PARAMETERS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.giac_parameters_tbxiu
BEFORE INSERT OR UPDATE
ON CPI.GIAC_PARAMETERS FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_id  := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


