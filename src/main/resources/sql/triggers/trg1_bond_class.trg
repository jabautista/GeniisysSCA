DROP TRIGGER CPI.TRG1_BOND_CLASS;

CREATE OR REPLACE TRIGGER CPI.TRG1_BOND_CLASS
BEFORE INSERT OR UPDATE
ON CPI.GIIS_BOND_CLASS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
       :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
       :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/


