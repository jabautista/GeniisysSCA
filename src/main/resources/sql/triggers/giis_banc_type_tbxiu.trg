DROP TRIGGER CPI.GIIS_BANC_TYPE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIIS_BANC_TYPE_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_BANC_TYPE FOR EACH ROW
DECLARE
BEGIN
 :NEW.USER_ID    := NVL (giis_users_pkg.app_user, USER);
 :NEW.LAST_UPDATE := SYSDATE;
END;
/


