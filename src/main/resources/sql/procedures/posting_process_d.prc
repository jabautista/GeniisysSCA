DROP PROCEDURE CPI.POSTING_PROCESS_D;

CREATE OR REPLACE PROCEDURE CPI.posting_process_d(
	   	  		  p_par_id	     GIPI_PARLIST.par_id%TYPE,
				  p_user_id		 VARCHAR2
	   	  		  )
		IS
  v_par_type	gipi_parlist.par_type%TYPE;		
BEGIN
  /*
  **  Created by   : Jerome Orio 
  **  Date Created : April 06, 2010 
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : a part of Posting_process program unit 
  */
  
  FOR a IN (SELECT par_type
  	  	      FROM gipi_parlist
			 WHERE par_id = p_par_id)
  LOOP
    v_par_type := a.par_type;
  END LOOP;			  	 

  
  IF v_par_type = 'P' THEN
	  DELETE_WORKFLOW_REC('PAR-Policy (ready for posting)','GIPIS085',p_user_id,p_par_id);
	  DELETE_OTHER_WORKFLOW_REC('PAR-Policy (ready for posting)','GIPIS085',p_user_id,p_par_id);
  ELSIF v_par_type = 'E' THEN
	  DELETE_WORKFLOW_REC('PAR-Endorsement (ready for posting)','GIPIS085',p_user_id,p_par_id);
	  DELETE_OTHER_WORKFLOW_REC('PAR-Endorsement (ready for posting)','GIPIS085',p_user_id,p_par_id);
  END IF;
END;
/


