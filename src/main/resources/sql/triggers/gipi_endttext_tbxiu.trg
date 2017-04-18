DROP TRIGGER CPI.GIPI_ENDTTEXT_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIPI_ENDTTEXT_TBXIU
  BEFORE INSERT OR UPDATE ON CPI.GIPI_ENDTTEXT FOR EACH ROW
DECLARE
BEGIN
  :new.user_id     := NVL (giis_users_pkg.app_user, USER);
  :new.last_update := SYSDATE;
END;
/


