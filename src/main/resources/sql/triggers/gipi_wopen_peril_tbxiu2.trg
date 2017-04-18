DROP TRIGGER CPI.GIPI_WOPEN_PERIL_TBXIU2;

CREATE OR REPLACE TRIGGER CPI.GIPI_WOPEN_PERIL_TBXIU2
BEFORE UPDATE
ON CPI.GIPI_WOPEN_PERIL FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_ID      := NVL (giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE  := SYSDATE;
END;
/


