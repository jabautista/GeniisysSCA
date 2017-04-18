DROP PROCEDURE CPI.VALIDATE_IN_PARLIST;

CREATE OR REPLACE PROCEDURE CPI.validate_in_PARLIST(
	   	  		  p_line_cd	   IN  GIPI_PARLIST.line_cd%TYPE,
				  p_par_yy	   IN  GIPI_PARLIST.par_yy%TYPE,
				  p_par_seq_no IN  GIPI_PARLIST.par_seq_no%TYPE,
	   	  		  p_msg_alert  OUT VARCHAR2
	   	  		  )
     IS
  v_dumm_var   VARCHAR2(200);
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : validate_in_PARLIST program unit
  */
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Validating PAR listing...';
  ELSE
    :gauge.FILE := 'passing validate policy PARLIST';
  END IF;
  vbx_counter;*/
  SELECT line_cd
    INTO v_dumm_var
    FROM GIPI_PARLIST
   WHERE line_cd    = p_line_cd AND
         par_yy	    = p_par_yy AND
         par_seq_no = p_par_seq_no;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       p_msg_alert := 'PAR no. does not exist in the PAR files.';
       --:gauge.FILE := 'PAR no. does not exist in the PAR files.';
       --error_rtn;
  WHEN TOO_MANY_ROWS THEN
       NULL;
END;
/


