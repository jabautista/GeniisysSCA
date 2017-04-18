DROP PROCEDURE CPI.DELETE_WORKFLOW_REC;

CREATE OR REPLACE PROCEDURE CPI.DELETE_WORKFLOW_REC(
	   	  		  			  p_event_desc  IN VARCHAR2,
                              p_module_id  IN VARCHAR2,
                              p_user       IN VARCHAR2,
                              p_col_value IN VARCHAR2
							  ) 
			 IS
  v_tran_id            gipi_user_events.tran_id%TYPE;    
  v_date_received      DATE;                        
BEGIN
  /*
  **  Created by   : Jerome Orio 
  **  Date Created : April 06, 2010 
  **  Reference By : WORKLIB library  
  **  Description  : DELETE_WORKFLOW_REC program unit 
  */ 
  
  FOR B_REC IN ( SELECT c.col_value, c.tran_id , c.event_col_cd, c.event_user_mod, c.switch, c.userid
									 FROM gipi_user_events c,
									      giis_event_modules b,
										    giis_events a
									WHERE c.event_cd = b.event_cd
									  AND c.event_mod_cd = b.event_mod_cd
									  AND c.event_mod_cd > 0
									  AND b.module_id = p_module_id
									  AND b.event_cd = a.event_cd
									  AND a.event_desc = p_event_desc)
  LOOP
  	IF b_rec.col_value = p_col_value THEN
  	   BEGIN
         v_date_received := DELAY(b_rec.event_user_mod,b_rec.event_col_cd,b_rec.tran_id);  --A.R.C. 01.18.2007
         INSERT INTO gipi_user_events_hist(event_user_mod, event_col_cd, tran_id, col_value, date_received, old_userid, new_userid)
              VALUES(b_rec.event_user_mod, b_rec.event_col_cd, b_rec.tran_id, b_rec.col_value, v_date_received, NVL(giis_users_pkg.app_user, USER), '-'); 
         DELETE FROM gipi_user_events
               WHERE event_user_mod = b_rec.event_user_mod
                 AND event_col_cd = b_rec.event_col_cd
                 AND tran_id = b_rec.tran_id;
             
  	   END;
  	ELSE	
  	  IF b_rec.switch = 'N' AND b_rec.userid = p_user THEN
    	   UPDATE gipi_user_events
    	      SET switch = 'Y'
    	    WHERE event_user_mod = b_rec.event_user_mod
    	      AND event_col_cd = b_rec.event_col_cd
    	      AND tran_id = b_rec.tran_id;
  	  END IF;    	   
  	END IF;  
  END LOOP;
END;
/


