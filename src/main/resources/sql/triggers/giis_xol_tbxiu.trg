DROP TRIGGER CPI.GIIS_XOL_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIIS_XOL_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_XOL FOR EACH ROW
BEGIN
  :NEW.user_ID     := NVL (giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE := SYSDATE;
END;
/


