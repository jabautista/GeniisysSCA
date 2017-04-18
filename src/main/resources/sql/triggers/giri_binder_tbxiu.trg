DROP TRIGGER CPI.GIRI_BINDER_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIRI_BINDER_TBXIU
  BEFORE UPDATE ON CPI.GIRI_BINDER   FOR EACH ROW
DECLARE
BEGIN
--   IF TRUNC(:NEW.bndr_print_date) <> TRUNC(:OLD.bndr_print_date) THEN
        :NEW.user_id := NVL (giis_users_pkg.app_user, USER);
--   END IF;
   
   :NEW.last_update := SYSDATE;
END;
/


