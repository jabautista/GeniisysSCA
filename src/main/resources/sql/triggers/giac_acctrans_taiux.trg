DROP TRIGGER CPI.GIAC_ACCTRANS_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GIAC_ACCTRANS_TAIUX
/*Created by Rosch JULIANO, June 27, 2005
Create history of changes in Transaction Status*/
AFTER INSERT OR UPDATE OF tran_flag ON CPI.GIAC_ACCTRANS FOR EACH ROW
BEGIN
   INSERT INTO GIAC_TRAN_STAT_HIST(tran_id,tran_flag,user_id,last_update)
   VALUES(:NEW.tran_id,:NEW.tran_flag,NVL (giis_users_pkg.app_user, USER),SYSDATE);
END;
/


