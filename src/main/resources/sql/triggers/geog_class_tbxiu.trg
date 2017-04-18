DROP TRIGGER CPI.GEOG_CLASS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GEOG_CLASS_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_GEOG_CLASS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    begin
      :new.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :new.last_update :=  sysdate;
    end;
END;
/


