DROP TRIGGER CPI.GUE_ATTACH_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GUE_ATTACH_TBXIU
                            BEFORE INSERT OR UPDATE ON CPI.GUE_ATTACH FOR EACH ROW
BEGIN
                             :NEW.user_ID := NVL (giis_users_pkg.app_user, USER);
                             :NEW.LAST_UPDATE := SYSDATE;
                            END
/
/


