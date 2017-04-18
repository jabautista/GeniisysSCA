DROP PROCEDURE CPI.VALIDATE_IN_WPOLBAS;

CREATE OR REPLACE PROCEDURE CPI.validate_in_wpolbas(
	   	  		  p_par_id		IN  GIPI_PARLIST.par_id%TYPE,				
	   	  		  p_MSG_ALERT   OUT VARCHAR2
	   	  		  )
     IS
  v_dumm_var   VARCHAR2(200);
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : validate_in_wpolbas program unit
  */
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Validating Basic Info...';
  ELSE
    :gauge.FILE := 'passing validate policy WPOLBAS';
  END IF;
  vbx_counter;*/
  SELECT line_cd
    INTO v_dumm_var
    FROM GIPI_WPOLBAS
   WHERE par_id = p_par_id;
--beth 121599 disallow POSTING if booking date is null
	FOR CHK_BOOKING IN (SELECT booking_mth, booking_year
	        		      FROM GIPI_WPOLBAS
	       				 WHERE par_id = p_par_id) 
    LOOP
	    IF chk_booking.booking_mth IS NULL AND chk_booking.booking_year IS NULL THEN
	    	 p_MSG_ALERT := 'Unable to post PAR, please enter booking date in Basic Information screen.';
             --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
	    	 --EXIT_FORM;
	    ELSIF chk_booking.booking_mth IS NULL THEN
	    	 p_MSG_ALERT := 'Unable to post PAR, please enter booking month in Basic Information screen.';
	    	 --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
	    	 --EXIT_FORM; 	 
      ELSIF chk_booking.booking_year IS NULL THEN
	    	 p_MSG_ALERT := 'Unable to post PAR, please enter booking year in Basic Information screen.';
	    	 --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
	    	 --EXIT_FORM; 	 	    	 
      END IF;
    END LOOP;       
EXCEPTION
  WHEN NO_DATA_FOUND THEN
       p_MSG_ALERT := 'INFORMATION in WPOLBAS TABLE NOT YET ENTERED.';
       --:gauge.FILE := 'INFORMATION in WPOLBAS TABLE NOT YET ENTERED.';
       --error_rtn;
  WHEN TOO_MANY_ROWS THEN
       NULL;
END;
/


