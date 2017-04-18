DROP TRIGGER CPI.TRAN_STAT_HIST_TBIXX;

CREATE OR REPLACE TRIGGER CPI.TRAN_STAT_HIST_TBIXX
BEFORE INSERT
ON CPI.GIAC_TRAN_STAT_HIST FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    BEGIN
       :NEW.user_id     := giis_users_pkg.app_user;       
    END;
END;
/
