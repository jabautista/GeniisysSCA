DROP TRIGGER CPI.TRG1_USER_GRP_DTL;

CREATE OR REPLACE TRIGGER CPI.TRG1_USER_GRP_DTL
BEFORE INSERT OR UPDATE
ON CPI.GIIS_USER_GRP_DTL FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
    :NEW.user_ID := NVL (giis_users_pkg.app_user, USER);
    :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/


