DROP TRIGGER CPI.GIPI_FIREITEM_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIPI_FIREITEM_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIPI_FIREITEM FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE := SYSDATE;
END;
/


