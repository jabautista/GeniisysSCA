DROP TRIGGER CPI.POLGENIN_TBXIU;

CREATE OR REPLACE TRIGGER CPI.POLGENIN_TBXIU
            BEFORE INSERT OR UPDATE
            ON CPI.GIPI_POLGENIN FOR EACH ROW
DECLARE
            BEGIN
              :NEW.user_id     :=  NVL (giis_users_pkg.app_user, USER);
              :NEW.last_update :=  SYSDATE;
            END;
/


