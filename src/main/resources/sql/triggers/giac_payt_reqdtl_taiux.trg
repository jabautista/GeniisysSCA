DROP TRIGGER CPI.GIAC_PAYT_REQDTL_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GIAC_PAYT_REQDTL_TAIUX
/*Created by Rosch JULIANO, July 8, 2005
Create history of changes in Payment Request Status*/
AFTER INSERT OR UPDATE OF payt_req_flag ON CPI.GIAC_PAYT_REQUESTS_DTL FOR EACH ROW
BEGIN
   INSERT INTO GIAC_PAYTREQ_STAT_HIST(tran_id,payt_req_flag,user_id,last_update)
   VALUES(:NEW.tran_id,:NEW.payt_req_flag,NVL (giis_users_pkg.app_user, USER),SYSDATE);
END;
/


