DROP TRIGGER CPI.TRG_USERS_HIST;

CREATE OR REPLACE TRIGGER CPI.TRG_USERS_HIST
BEFORE UPDATE OF user_grp
ON CPI.GIIS_USERS FOR EACH ROW
DECLARE
  v_hist_id  NUMBER;
BEGIN
     FOR a IN (SELECT MAX(hist_id) max_hist_id
                 FROM GIIS_USER_GRP_HIST) LOOP
 	   v_hist_id := a.max_hist_id + 1;
	   EXIT;
     END LOOP;
     INSERT INTO GIIS_USER_GRP_HIST
       (hist_id, userid, old_user_grp ,new_user_grp)
	 VALUES
	   (NVL(v_hist_id,1), :NEW.user_id, :OLD.user_grp, :NEW.user_grp);
END;
/


