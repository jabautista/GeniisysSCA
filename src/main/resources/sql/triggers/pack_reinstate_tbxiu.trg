DROP TRIGGER CPI.PACK_REINSTATE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.PACK_REINSTATE_TBXIU
  BEFORE INSERT OR UPDATE ON CPI.GIPI_PACK_REINSTATE_HIST   FOR EACH ROW
DECLARE
  BEGIN
 DECLARE
 BEGIN
  :NEW.user_ID := NVL (giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE := SYSDATE;
 END;
  END;
/


