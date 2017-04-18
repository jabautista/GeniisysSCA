DROP TRIGGER CPI.GIPI_WPICTURE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIPI_WPICTURE_TBXIU
BEFORE INSERT
  ON CPI.GIPI_WPICTURES FOR EACH ROW
BEGIN
   :NEW.create_user := NVL (giis_users_pkg.app_user, USER);
   :NEW.create_date := SYSDATE;
   :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
   :NEW.last_update := SYSDATE;
END;
/


