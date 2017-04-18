DROP TRIGGER CPI.GIAC_CHART_OF_ACCTS_TAIUD;

CREATE OR REPLACE TRIGGER CPI.GIAC_CHART_OF_ACCTS_TAIUD
  AFTER INSERT OR
        UPDATE OF gslt_sl_type_cd OR
        DELETE ON CPI.GIAC_CHART_OF_ACCTS   FOR EACH ROW
DECLARE
  v_gl_acct_id    giac_sl_type_hist.gl_acct_id%TYPE := NVL(:NEW.gl_acct_id, :OLD.gl_acct_id);
BEGIN
  IF INSERTING OR UPDATING THEN
    INSERT INTO giac_sl_type_hist(hist_seq_no,
                                  gl_acct_id,
                                  sl_type_cd,
                                  eff_date,
                                  user_id)
       VALUES(sl_type_hist_s.nextval,
              v_gl_acct_id,
              :NEW.gslt_sl_type_cd,
              SYSDATE,
              NVL (giis_users_pkg.app_user, USER));
  ELSIF DELETING THEN
    DELETE FROM giac_sl_type_hist
      WHERE gl_acct_id = v_gl_acct_id;
  END IF;
END;
/


