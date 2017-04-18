DROP TRIGGER CPI.TRG_USERS;

CREATE OR REPLACE TRIGGER CPI.TRG_USERS
BEFORE INSERT OR UPDATE
ON CPI.GIIS_USERS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
    IF :NEW.LAST_LOGIN = NULL THEN                                     --SR-5264 added by. June Mark [10.07.16] 
        :NEW.LAST_UPDATE := SYSDATE;
        
        IF :NEW.ACTIVE_FLAG <> NULL THEN                                        --SR-23271 added by. June Mark [10.13.16] 
            IF :NEW.ACTIVE_FLAG <> 'L' THEN
                :NEW.LAST_user_ID := NVL (giis_users_pkg.app_user, USER);
            END IF;
        ELSE
            :NEW.LAST_user_ID := NVL (giis_users_pkg.app_user, USER);
        END IF;                                                                 --end SR-23271
    END IF;                                                            --end SR-5264
  END;
END;
/

