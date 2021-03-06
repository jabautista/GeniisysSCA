DROP TRIGGER CPI.TRG1_GPDC_HIST;

CREATE OR REPLACE TRIGGER CPI.TRG1_GPDC_HIST
BEFORE INSERT OR UPDATE
ON CPI.GIAC_PDC_REP_HIST FOR EACH ROW
BEGIN
    :NEW.user_id := NVL (giis_users_pkg.app_user, USER);
    :NEW.last_update := SYSDATE;
END;
/


