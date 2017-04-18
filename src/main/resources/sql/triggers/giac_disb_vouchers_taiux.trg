DROP TRIGGER CPI.GIAC_DISB_VOUCHERS_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GIAC_DISB_VOUCHERS_TAIUX
/*  insert into dv_flag history table */
AFTER INSERT OR UPDATE OF DV_FLAG ON CPI.GIAC_DISB_VOUCHERS FOR EACH ROW
BEGIN
   INSERT INTO GIAC_DV_STAT_HIST(gacc_tran_id, dv_flag, user_id, last_update)
   VALUES (:NEW.gacc_tran_id,:NEW.dv_flag,NVL (giis_users_pkg.app_user, USER),SYSDATE);
END;
/


