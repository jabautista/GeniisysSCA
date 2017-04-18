DROP TRIGGER CPI.INSPECTOR_TBXIU;

CREATE OR REPLACE TRIGGER CPI.INSPECTOR_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_INSPECTOR FOR EACH ROW
DECLARE
BEGIN
DECLARE
BEGIN
:NEW.user_id := NVL (giis_users_pkg.app_user, USER);
:NEW.last_update := sysdate;
END;
END;
/


