DROP TRIGGER CPI.GIIS_BANC_BRANCH_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIIS_BANC_BRANCH_tbxiu
BEFORE INSERT OR UPDATE
ON CPI.GIIS_BANC_BRANCH FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_ID    := NVL (giis_users_pkg.app_user, USER);
  :NEW.LAST_UPDATE := SYSDATE;
END;
/


