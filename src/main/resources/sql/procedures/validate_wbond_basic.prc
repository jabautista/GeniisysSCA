DROP PROCEDURE CPI.VALIDATE_WBOND_BASIC;

CREATE OR REPLACE PROCEDURE CPI.validate_WBOND_BASIC(
	   	  		  p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				  p_affecting   IN  VARCHAR2,				 
	   	  		  p_msg_alert   OUT VARCHAR2
	   	  		  )
	    IS
    v_coll_flag		GIPI_WBOND_BASIC.coll_flag%TYPE;
	v_dumm_var		VARCHAR2(200);
BEGIN
  IF p_affecting = 'Y' THEN  --bdarusin, 010302
  	                                 --will check bond basic only when endt is affecting
	   BEGIN
			 /*IF :gauge.process='Y' THEN
			    :gauge.FILE := 'Validating Bond Basic...';
			 ELSE
			    :gauge.FILE := 'passing validate policy BOND BASIC';
			 END IF;
			 vbx_counter;*/
			 SELECT par_id,coll_flag
			   INTO v_dumm_var,v_coll_flag
			   FROM GIPI_WBOND_BASIC
			  WHERE par_id	= p_par_id;
			 IF v_coll_flag = 'Q' OR v_coll_flag = 'S' OR v_coll_flag = 'P' OR v_coll_flag = 'R' THEN
			    --validate_wcollateral_dtl(v_coll_flag);  -- at least one record w/out release date for 
			 	NULL;
			 END IF;
			 EXCEPTION
			  WHEN NO_DATA_FOUND THEN
			       p_msg_alert := 'PAR should have BOND BASIC existing.';
			       --:gauge.FILE := 'PAR should have BOND BASIC existing.';
			       --error_rtn;
	   END;	       
  END IF;
END;
/


