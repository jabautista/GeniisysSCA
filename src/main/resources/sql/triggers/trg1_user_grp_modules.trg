DROP TRIGGER CPI.TRG1_USER_GRP_MODULES;

CREATE OR REPLACE TRIGGER CPI.TRG1_USER_GRP_MODULES
BEFORE INSERT OR UPDATE
ON CPI.GIIS_USER_GRP_MODULES FOR EACH ROW
BEGIN
    :NEW.user_id := NVL (giis_users_pkg.app_user, USER);
    :NEW.last_update := SYSDATE;
END;
/


