DROP TRIGGER CPI.GIAC_APDC_PAYT_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIAC_APDC_PAYT_TBXIU
BEFORE INSERT OR UPDATE OR INSERT
ON CPI.GIAC_APDC_PAYT FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    BEGIN
      :NEW.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :NEW.last_update :=  SYSDATE;
    END;
END;
/


