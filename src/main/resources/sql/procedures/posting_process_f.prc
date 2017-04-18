DROP PROCEDURE CPI.POSTING_PROCESS_F;

CREATE OR REPLACE PROCEDURE CPI.posting_process_f(
	   	  		  p_par_id	     GIPI_PARLIST.par_id%TYPE,
				  p_back_endt	 VARCHAR2
	   	  		  )
		IS
BEGIN
  /*
  **  Created by   : Jerome Orio 
  **  Date Created : April 06, 2010 
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : a part of Posting_process program unit 
  */
  
  IF p_back_endt = 'Y' THEN
     UPDATE gipi_polbasic 
        SET back_stat = 2
      WHERE par_id = p_par_id;
  ELSIF p_back_endt = 'N' THEN 
     UPDATE gipi_polbasic   
        SET back_stat = 1       
      WHERE par_id = p_par_id;
  END IF;
END;
/


