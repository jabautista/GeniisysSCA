DROP TRIGGER CPI.GIPI_USER_EVENTS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIPI_USER_EVENTS_TBXIU
       BEFORE INSERT OR UPDATE
       ON CPI.GIPI_USER_EVENTS        FOR EACH ROW
DECLARE
      BEGIN
        IF :NEW.user_id IS NULL THEN
           :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
        END IF;
        :NEW.last_update := SYSDATE;
      END;
/


