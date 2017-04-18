DROP TRIGGER CPI.GIIS_EVENTS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIIS_EVENTS_TBXIU
       BEFORE INSERT OR UPDATE
       ON CPI.GIIS_EVENTS        FOR EACH ROW
DECLARE
      BEGIN
        :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
        :NEW.last_update := SYSDATE;
      END;
/


