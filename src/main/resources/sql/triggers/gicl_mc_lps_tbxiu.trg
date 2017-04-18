DROP TRIGGER CPI.GICL_MC_LPS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GICL_MC_LPS_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GICL_MC_LPS FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE := SYSDATE;
END;
/


