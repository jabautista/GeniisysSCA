DROP TRIGGER CPI.GICL_INTM_ITMPERIL_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GICL_INTM_ITMPERIL_TBXIU
BEFORE INSERT OR UPDATE ON CPI.GICL_INTM_ITMPERIL FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_ID          := NVL (giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE      := SYSDATE;
END;
/


