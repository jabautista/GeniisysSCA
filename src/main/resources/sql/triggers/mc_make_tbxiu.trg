DROP TRIGGER CPI.MC_MAKE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.MC_MAKE_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_MC_MAKE FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    begin
      :new.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :new.last_update :=  sysdate;
    end;
END;
/


