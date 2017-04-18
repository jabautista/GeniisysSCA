DROP TRIGGER CPI.MORTGAGEE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.MORTGAGEE_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_MORTGAGEE FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    begin
      :new.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :new.last_update :=  sysdate;
    end;
END;
/


