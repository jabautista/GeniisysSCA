DROP TRIGGER CPI.MASTER_INTM_TRIG;

CREATE OR REPLACE TRIGGER CPI.MASTER_INTM_TRIG
BEFORE INSERT OR UPDATE
ON CPI.GIIS_MASTER_INTM FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
  :NEW.user_id := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
  END;
END;
/


