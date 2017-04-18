DROP TRIGGER CPI.COSIGNOR_RES_TBXIU;

CREATE OR REPLACE TRIGGER CPI.COSIGNOR_RES_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_COSIGNOR_RES FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
    :NEW.user_ID     := NVL (giis_users_pkg.app_user, USER);
    :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/


