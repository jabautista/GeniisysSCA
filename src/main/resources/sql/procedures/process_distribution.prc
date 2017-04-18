DROP PROCEDURE CPI.PROCESS_DISTRIBUTION;

CREATE OR REPLACE PROCEDURE CPI.process_distribution(
	   	  		  p_par_id			IN  gipi_parlist.par_id%TYPE,
				  p_line_cd			IN  gipi_parlist.line_cd%TYPE,							
				  p_iss_cd			IN  GIPI_WPOLBAS.iss_cd%TYPE,
				  p_policy_id		IN  GIPI_POLBASIC.policy_id%TYPE,	
				  p_user_id			IN  VARCHAR2, 
	   	  		  p_dist_no			OUT giuw_pol_dist.dist_no%TYPE,
				  p_msg_alert		OUT VARCHAR2	
				  )
	    IS
  v_par_id 	    giuw_pol_dist.par_id%TYPE;
  v_policy_id 	giuw_pol_dist.policy_id%TYPE;
  var           VARCHAR2(1) := 'N';
  v_exist 		VARCHAR2(1) := 'N';
  v_dist_no		giuw_pol_dist.dist_no%TYPE;
  v_subline_cd	gipi_wpolbas.subline_cd%TYPE;		
  v_pack		gipi_wpolbas.pack_pol_flag%TYPE;		
  v_msg_alert	VARCHAR2(2000);												   
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : process_distribution program unit
  */
  
  FOR wpol IN (SELECT subline_cd, pack_pol_flag
  	  	   	     FROM gipi_wpolbas
				WHERE par_id = p_par_id)
  LOOP
    v_subline_cd := wpol.subline_cd;
	v_pack	 	 := wpol.pack_pol_flag;
  END LOOP;				
  
  /*SELECT par_id,dist_no,policy_id
    INTO v_par_id,:postpar.dist_no,v_policy_id
    FROM giuw_pol_dist
   WHERE par_id = :postpar.par_id;*/ --LONG TERM--
  FOR x IN (SELECT  par_id,dist_no,policy_id, auto_dist
              FROM giuw_pol_dist
             WHERE par_id = p_par_id)
  LOOP
  	v_exist 		 := 'Y';
  	v_par_id  		 := x.par_id;
  	v_dist_no 		 := x.dist_no;
  	v_policy_id      := x.policy_id;
  	
  	IF v_policy_id IS NULL THEN
	    UPDATE giuw_pol_dist
	       SET policy_id = p_policy_id
	     WHERE par_id = p_par_id;
	  END IF;
	  --beth 06212000 if auto_dist = 'Y' update tables giuw_pol_dist and gipi_polbasic
	  /*FOR A IN (SELECT '1'
	              FROM giuw_pol_dist
	             WHERE par_id = :postpar.par_id
	               AND auto_dist = 'Y')             
	  LOOP*/
	  IF x.auto_dist = 'Y' THEN
		 	var := 'Y';
		  UPDATE giuw_pol_dist
		     SET dist_flag = '3',
		         --post_flag = 'P', --comment out by glyza 06.05.08
		         user_id   = p_user_id,	
		         last_upd_date =SYSDATE
       WHERE par_id = p_par_id
	       AND dist_no = v_dist_no;
		 
		  UPDATE gipi_polbasic
		     SET dist_flag = '3'
		   WHERE policy_id = p_policy_id;
		    --EXIT;
		END IF;  
	  --END LOOP;    
	  
	  BEGIN
	    SELECT dist_no
	      INTO v_dist_no
	      FROM giuw_wpolicyds
	     WHERE dist_no = v_dist_no;

	  EXCEPTION
	    WHEN TOO_MANY_ROWS THEN
	         NULL;
	    WHEN NO_DATA_FOUND THEN
	
	      /* Create records in distribution tables GIUW_WPOLICYDS, GIUW_WPOLICYDS_DTL,
	      ** GIUW_WITEMDS, GIUW_WITEMDS_DTL, GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
	      ** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
	      IF var = 'N' THEN
	         CREATE_PAR_DISTRIBUTION_RECS
	            (v_dist_no    , p_par_id , p_line_cd ,
	             v_subline_cd , p_iss_cd , v_pack);
	      ELSE
	      	 NULL;
	      END IF;	 
	  END;
  END LOOP;	  
--EXCEPTION 
  --WHEN NO_DATA_FOUND THEN   
    IF v_exist = 'N' THEN
    	dist_giuw_pol_dist2(p_par_id,p_policy_id,v_dist_no,v_msg_alert);
    	/* Create records in distribution tables GIUW_WPOLICYDS, GIUW_WPOLICYDS_DTL,
    	** GIUW_WITEMDS, GIUW_WITEMDS_DTL, GIUW_WITEMPERILDS, GIUW_WITEMPERILDS_DTL,
    	** GIUW_WPERILDS and GIUW_WPERILDS_DTL. */
    	CREATE_PAR_DISTRIBUTION_RECS
          (v_dist_no    , p_par_id , p_line_cd , 
           v_subline_cd , p_iss_cd , v_pack);
    END IF;
  p_dist_no   := v_dist_no;
  p_msg_alert := v_msg_alert;
END;
/


