DROP TRIGGER CPI.GISM_DATA_UPLOAD_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GISM_DATA_UPLOAD_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GISM_DATA_UPLOAD FOR EACH ROW
DECLARE
BEGIN
     DECLARE
     BEGIN
        :NEW.user_id := NVL (giis_users_pkg.app_user, USER);
        :NEW.last_update := SYSDATE;
     END;
END;
/

