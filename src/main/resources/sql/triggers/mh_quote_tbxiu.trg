DROP TRIGGER CPI.MH_QUOTE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.MH_QUOTE_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIPI_QUOTE_MH_ITEM FOR EACH ROW
DECLARE
BEGIN
     DECLARE
     BEGIN
         :NEW.user_id    := NVL (giis_users_pkg.app_user, USER);
         :NEW.last_update := SYSDATE;
     END;
END;
/


