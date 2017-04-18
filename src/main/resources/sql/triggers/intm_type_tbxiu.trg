DROP TRIGGER CPI.INTM_TYPE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.INTM_TYPE_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_INTM_TYPE FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    begin
      :new.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :new.last_update :=  sysdate;
    end;
END;
/

