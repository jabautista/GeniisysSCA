DROP TRIGGER CPI.GICL_EVAL_VAT_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GICL_EVAL_VAT_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GICL_EVAL_VAT FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_id := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


