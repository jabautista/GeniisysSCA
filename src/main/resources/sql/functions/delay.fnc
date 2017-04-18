DROP FUNCTION CPI.DELAY;

CREATE OR REPLACE FUNCTION CPI.DELAY(
	   	  		p_event_user_mod IN NUMBER,
                p_event_col_cd   IN NUMBER,
                p_tran_id        IN NUMBER
				) 
	RETURN DATE IS                
  v_time        DATE := NULL;
BEGIN
  /*
  **  Created by   : Jerome Orio 
  **  Date Created : April 06, 2010 
  **  Reference By : WORKLIB library  
  **  Description  : DELAY program unit 
  */ 
  
	FOR c1 IN (SELECT MAX(date_received) date_received
	  		       FROM gipi_user_events_hist
	  		      WHERE event_user_mod = p_event_user_mod
	  		        AND event_col_cd = p_event_col_cd
	  		        AND tran_id = p_tran_id)
  LOOP	  		        
	  v_time := c1.date_received;
	END LOOP;
	IF v_time >= SYSDATE THEN
		 v_time := v_time+(1/(24*60*60));
	ELSE	
     v_time := SYSDATE;
	END IF;	
	RETURN(v_time);
END;
/


