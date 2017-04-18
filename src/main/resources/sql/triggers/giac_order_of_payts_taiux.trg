DROP TRIGGER CPI.GIAC_ORDER_OF_PAYTS_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GIAC_ORDER_OF_PAYTS_TAIUX
/*created by:ging
date created:070205
insert into or_flag history table
*/
AFTER INSERT OR UPDATE OF or_flag ON CPI.GIAC_ORDER_OF_PAYTS FOR EACH ROW
BEGIN
  IF :NEW.or_flag IS NOT NULL THEN -- cheryl 04.24.2009 to avoid ORA-01400 when cancelling posted OR transaction
     INSERT INTO GIAC_OR_STAT_HIST(gacc_tran_id,or_flag,user_id,last_update)
     VALUES(:NEW.gacc_tran_id,:NEW.or_flag,NVL (giis_users_pkg.app_user, USER),SYSDATE);
  END IF;
END;
/


