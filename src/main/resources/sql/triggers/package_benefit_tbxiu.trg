DROP TRIGGER CPI.PACKAGE_BENEFIT_TBXIU;

CREATE OR REPLACE TRIGGER CPI.PACKAGE_BENEFIT_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_PACKAGE_BENEFIT FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    BEGIN
      :NEW.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :NEW.last_update :=  SYSDATE;
    END;
END;
/


