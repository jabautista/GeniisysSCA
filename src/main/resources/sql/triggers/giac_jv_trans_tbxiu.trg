DROP TRIGGER CPI.GIAC_JV_TRANS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.giac_jv_trans_tbxiu
BEFORE INSERT OR UPDATE
ON CPI.GIAC_JV_TRANS FOR EACH ROW
DECLARE
BEGIN
 :NEW.user_id    := NVL (giis_users_pkg.app_user, USER);
 :NEW.last_update := SYSDATE;
END;
/


