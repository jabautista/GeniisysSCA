DROP TRIGGER CPI.GIAC_PAYT_REQUESTS_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GIAC_PAYT_REQUESTS_TAIUX
 AFTER INSERT OR UPDATE OF create_by
    ON CPI.GIAC_PAYT_REQUESTS    FOR EACH ROW
DECLARE
BEGIN
  INSERT INTO giac_paytreq_user_hist (ref_id, payreq_user, user_id, last_update)
       VALUES (:new.ref_id, :new.create_by, NVL (giis_users_pkg.app_user, USER), SYSDATE);
END;
/


