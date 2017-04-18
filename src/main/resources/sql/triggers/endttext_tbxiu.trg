DROP TRIGGER CPI.ENDTTEXT_TBXIU;

CREATE OR REPLACE TRIGGER CPI.ENDTTEXT_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_ENDTTEXT FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    begin
      :new.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :new.last_update :=  sysdate;
    end;
END;
/


