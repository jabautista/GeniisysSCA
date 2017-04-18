DROP TRIGGER CPI.GIAC_PAYT_REQ_DOCS_TBXIU;

CREATE OR REPLACE TRIGGER CPI.giac_payt_req_docs_tbxiu
BEFORE INSERT OR UPDATE
ON CPI.GIAC_PAYT_REQ_DOCS FOR EACH ROW
DECLARE
BEGIN
  :NEW.user_id  := NVL (giis_users_pkg.app_user, USER);
  :NEW.last_update := SYSDATE;
END;
/


