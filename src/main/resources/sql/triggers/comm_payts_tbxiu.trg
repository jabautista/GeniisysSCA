DROP TRIGGER CPI.COMM_PAYTS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.COMM_PAYTS_TBXIU
BEFORE INSERT OR UPDATE OR INSERT
ON CPI.GIAC_COMM_PAYTS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    begin
      :new.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :new.last_update :=  sysdate;
    end;
END;
/


