DROP TRIGGER CPI.GIAC_PDC_REPLACE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIAC_PDC_REPLACE_TBXIU
BEFORE INSERT OR UPDATE OR INSERT
ON CPI.GIAC_PDC_REPLACE FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    BEGIN
      :NEW.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :NEW.last_update :=  SYSDATE;
    END;
END;
/


