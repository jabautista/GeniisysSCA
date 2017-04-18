CREATE OR REPLACE TRIGGER CPI."BIN$j5HZv9K+QnK1rW8ErhSMaA==$0"
 BEFORE INSERT OR UPDATE ON CPI.GIIS_GENIN_INFO  FOR EACH ROW
DECLARE
 BEGIN
  :NEW.USER_ID    := NVL(giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE := SYSDATE;
 END;
/

DROP TRIGGER CPI."BIN$j5HZv9K+QnK1rW8ErhSMaA==$0";
