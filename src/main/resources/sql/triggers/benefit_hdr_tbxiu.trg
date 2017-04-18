DROP TRIGGER CPI.BENEFIT_HDR_TBXIU;

CREATE OR REPLACE TRIGGER CPI.BENEFIT_HDR_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_BENEFIT_HDR FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    BEGIN
      :NEW.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :NEW.last_update :=  SYSDATE;
    END;
END;
/


