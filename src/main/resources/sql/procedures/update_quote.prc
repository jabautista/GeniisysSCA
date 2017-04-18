DROP PROCEDURE CPI.UPDATE_QUOTE;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_QUOTE(
	   	  		  p_par_id      gipi_parlist.par_id%TYPE,
				  p_user_id 	VARCHAR2
				  )
	    IS
BEGIN
  /*
  **  Created by   : Jerome Orio  
  **  Date Created : April 05, 2010  
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : UPDATE_QUOTE program unit 
  */
  
  FOR A IN
      ( SELECT a.quote_id
          FROM gipi_quote a, gipi_parlist b
         WHERE a.quote_id  = b.quote_id
           AND b.par_id    = p_par_id 
      ) LOOP
      UPDATE gipi_quote
         SET status = 'P',
             post_dt = sysdate,
             last_update = sysdate,
             user_id= p_user_id
       WHERE quote_id = a.quote_id;
  END LOOP;     

END;
/


