DROP TRIGGER CPI.GIXX_PICTURE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIXX_PICTURE_TBXIU
BEFORE INSERT
  ON CPI.GIXX_PICTURES FOR EACH ROW
BEGIN
   :NEW.create_user := NVL (giis_users_pkg.app_user, USER);
   :NEW.create_date := SYSDATE;
   :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
   :NEW.last_update := SYSDATE;
END;
/


