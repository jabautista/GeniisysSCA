DROP TRIGGER CPI.COVERAGE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.COVERAGE_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_COVERAGE FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    begin
      :new.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :new.last_update :=  sysdate;
    end;
END;
/


