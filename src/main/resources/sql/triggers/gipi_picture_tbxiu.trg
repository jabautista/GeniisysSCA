DROP TRIGGER CPI.GIPI_PICTURE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIPI_PICTURE_TBXIU
       BEFORE INSERT OR UPDATE
       ON CPI.GIPI_PICTURES        FOR EACH ROW
DECLARE
      BEGIN
        :NEW.user_id    := NVL (giis_users_pkg.app_user, USER);
        :NEW.last_update := SYSDATE;
      END;
/


