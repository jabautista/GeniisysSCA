DROP TRIGGER CPI.QUOTATION_NO_TBXIU;

CREATE OR REPLACE TRIGGER CPI.QUOTATION_NO_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_QUOTATION_NO FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    begin
      :new.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :new.last_update :=  sysdate;
    end;
END;
/


