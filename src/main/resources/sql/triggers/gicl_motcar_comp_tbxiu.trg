DROP TRIGGER CPI.GICL_MOTCAR_COMP_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GICL_MOTCAR_COMP_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GICL_MOTCAR_COMP FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE := SYSDATE;
END;
/


