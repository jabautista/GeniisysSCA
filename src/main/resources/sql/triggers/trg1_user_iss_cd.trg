DROP TRIGGER CPI.TRG1_USER_ISS_CD;

CREATE OR REPLACE TRIGGER CPI.TRG1_USER_ISS_CD
BEFORE INSERT OR UPDATE
ON CPI.GIIS_USER_ISS_CD FOR EACH ROW
BEGIN
    :NEW.user_id := NVL (giis_users_pkg.app_user, USER);
    :NEW.last_update := SYSDATE;
END;
/


