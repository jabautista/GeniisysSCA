DROP TRIGGER CPI.GICL_RECOVERY_ACCT_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GICL_RECOVERY_ACCT_TBXIU
BEFORE INSERT OR UPDATE ON CPI.GICL_RECOVERY_ACCT FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_id     := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


