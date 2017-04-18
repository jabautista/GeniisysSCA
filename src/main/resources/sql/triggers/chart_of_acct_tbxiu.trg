DROP TRIGGER CPI.CHART_OF_ACCT_TBXIU;

CREATE OR REPLACE TRIGGER CPI.CHART_OF_ACCT_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIAC_CHART_OF_ACCTS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
       :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
       :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/

