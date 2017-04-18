DROP TRIGGER CPI.GICL_LOSS_EXP_ACCTRANS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GICL_LOSS_EXP_ACCTRANS_TBXIU
before INSERT OR UPDATE
ON CPI.GICL_LOSS_EXP_ACCTRANS FOR each ROW
DECLARE
BEGIN
 :NEW.user_id         :=     NVL (giis_users_pkg.app_user, USER);
 :NEW.last_update     :=     SYSDATE;
END;
/

