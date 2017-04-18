DROP TRIGGER CPI.GIPI_PICTURE_TBXIU2;

CREATE OR REPLACE TRIGGER CPI.GIPI_PICTURE_TBXIU2
BEFORE UPDATE
  ON CPI.GIPI_PICTURES FOR EACH ROW
BEGIN
   :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
   :NEW.last_update := SYSDATE;
END;
/

