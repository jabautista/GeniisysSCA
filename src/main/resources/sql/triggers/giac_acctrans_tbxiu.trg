DROP TRIGGER CPI.GIAC_ACCTRANS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIAC_ACCTRANS_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIAC_ACCTRANS FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE := SYSDATE;
END;
/


