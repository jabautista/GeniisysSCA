DROP PROCEDURE CPI.DELETE_OTHER_WORKFLOW_REC;

CREATE OR REPLACE PROCEDURE CPI.DELETE_OTHER_WORKFLOW_REC(
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
  **  Description  : DELETE_OTHER_WORKFLOW_REC program unit 
  */ 
  
    FOR B_REC IN ( SELECT a.col_value, a.tran_id , a.event_col_cd, a.event_user_mod, a.switch, a.user_id
										 FROM giis_events_column b,
											  gipi_user_events a		
										WHERE 1=1
										  AND a.userid = p_user
										  AND b.event_col_cd = a.event_col_cd
										  AND a.col_value = p_col_value
										  AND EXISTS (SELECT 'X'
										                FROM giis_events z
										               WHERE z.event_type IN (2,4)
										                 AND z.event_cd = a.event_cd)  
										  AND EXISTS (SELECT 1
										                FROM giis_events_column x, 
										                     giis_event_modules y,
															           giis_events z
										               WHERE 1=1
																		 AND x.table_name = b.table_name
																		 AND x.column_name = b.column_name
																		 AND x.event_mod_cd = y.event_mod_cd
															 			 AND x.event_cd = y.event_cd
																		 AND y.module_id = p_module_id
																		 AND y.event_cd = z.event_cd
																		 AND z.event_desc = p_event_desc))
	  LOOP
	   BEGIN       
       v_date_received := DELAY(b_rec.event_user_mod,b_rec.event_col_cd,b_rec.tran_id);
       INSERT INTO gipi_user_events_hist(event_user_mod, event_col_cd, tran_id, col_value, date_received, old_userid, new_userid)
            VALUES(b_rec.event_user_mod, b_rec.event_col_cd, b_rec.tran_id, b_rec.col_value, v_date_received, NVL(giis_users_pkg.app_user, USER), '-'); 
       DELETE FROM gipi_user_events
             WHERE event_user_mod = b_rec.event_user_mod
               AND event_col_cd = b_rec.event_col_cd
               AND tran_id = b_rec.tran_id;
           
	   END;
	  END LOOP;
END;
/


