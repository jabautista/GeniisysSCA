DROP TRIGGER CPI.GIIS_INDUSTRY_GROUP_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIIS_INDUSTRY_GROUP_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_INDUSTRY_GROUP FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    BEGIN
      :NEW.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :NEW.last_update :=  SYSDATE;
    END;
END;
/


