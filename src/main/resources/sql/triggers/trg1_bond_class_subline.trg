DROP TRIGGER CPI.TRG1_BOND_CLASS_SUBLINE;

CREATE OR REPLACE TRIGGER CPI.TRG1_BOND_CLASS_SUBLINE
BEFORE INSERT OR UPDATE
ON CPI.GIIS_BOND_CLASS_SUBLINE FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  begin
     :new.user_id  :=  NVL (giis_users_pkg.app_user, USER);
     :new.last_update := sysdate;
  end;
END;
/


