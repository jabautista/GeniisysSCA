DROP TRIGGER CPI.POSITION_LEVEL_TBXIU;

CREATE OR REPLACE TRIGGER CPI.POSITION_LEVEL_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_POSITION_LEVEL FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    BEGIN
      :NEW.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :NEW.last_update :=  SYSDATE;
    END;
END;
/

