DROP TRIGGER CPI.GIIS_BANC_TYPE_DTL_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GIIS_BANC_TYPE_DTL_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_BANC_TYPE_DTL FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_id    := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


