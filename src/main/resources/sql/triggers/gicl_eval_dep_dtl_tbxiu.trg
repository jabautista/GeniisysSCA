DROP TRIGGER CPI.GICL_EVAL_DEP_DTL_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GICL_EVAL_DEP_DTL_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GICL_EVAL_DEP_DTL FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_id := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


