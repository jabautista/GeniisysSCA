DROP TRIGGER CPI.GIAC_TRAN_MM_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GIAC_TRAN_MM_TAIUX 
AFTER INSERT OR UPDATE OF CLOSED_TAG ON CPI.GIAC_TRAN_MM 
FOR EACH ROW
BEGIN 
   INSERT INTO GIAC_TRANMM_STAT_HIST(fund_cd, branch_cd, tran_mm, tran_yr, closed_tag, user_id, last_update) 
   VALUES (:NEW.fund_cd, :NEW.branch_cd, :NEW.tran_mm, :NEW.tran_yr, :NEW.closed_tag, NVL (giis_users_pkg.app_user, USER), SYSDATE); 
END;
/


