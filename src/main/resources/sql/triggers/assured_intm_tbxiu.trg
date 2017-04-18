DROP TRIGGER CPI.ASSURED_INTM_TBXIU;

CREATE OR REPLACE TRIGGER CPI.ASSURED_INTM_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_ASSURED_INTM FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    begin
      :new.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :new.last_update :=  sysdate;
    end;
END;
/


