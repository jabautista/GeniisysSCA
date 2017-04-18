DROP PROCEDURE CPI.VALIDATE_ADDL_ITEMS;

CREATE OR REPLACE PROCEDURE CPI.Validate_Addl_Items(
	   	  		  p_par_id			IN  GIPI_PARLIST.par_id%TYPE,			
				  p_pack			IN  GIPI_WPOLBAS.pack_pol_flag%TYPE,					
				  p_line_cd			IN  GIPI_WPOLBAS.line_cd%TYPE,					
				  p_subline_cd		IN  GIPI_WPOLBAS.subline_cd%TYPE,
				  p_affecting		IN  VARCHAR2,
				  p_iss_cd			IN  GIPI_WPOLBAS.iss_cd%TYPE,
				  p_msg_alert		OUT VARCHAR2  				
	   	  		  )
	    IS
  v_subline_mop		  GIPI_WPOLBAS.subline_cd%TYPE := 'MOP';
  v_subline_mrn		  GIPI_WPOLBAS.subline_cd%TYPE := 'MRN';
  v_subline_bbb   	  GIPI_WPOLBAS.subline_cd%TYPE := 'BBB';
  v_subline_ddd   	  GIPI_WPOLBAS.subline_cd%TYPE := 'DDD';
  v_subline_mrsb  	  GIPI_WPOLBAS.subline_cd%TYPE := 'MRSB';
  v_subline_mspr  	  GIPI_WPOLBAS.subline_cd%TYPE := 'MSPR';
  v_accident_cd		  GIIS_PARAMETERS.param_value_v%TYPE;
  v_aviation_cd		  GIIS_PARAMETERS.param_value_v%TYPE;	  
  v_casualty_cd		  GIIS_PARAMETERS.param_value_v%TYPE;		  	  			   
  v_engrng_cd		  GIIS_PARAMETERS.param_value_v%TYPE;  
  v_fire_cd			  GIIS_PARAMETERS.param_value_v%TYPE;  
  v_motor_cd		  GIIS_PARAMETERS.param_value_v%TYPE; 
  v_hull_cd			  GIIS_PARAMETERS.param_value_v%TYPE;  
  v_cargo_cd		  GIIS_PARAMETERS.param_value_v%TYPE;  
  v_surety_cd		  GIIS_PARAMETERS.param_value_v%TYPE;
  v_msg_alert		  VARCHAR2(32000);
  v_open_flag 		  GIIS_SUBLINE.op_flag%TYPE;
  v_open_policy_sw	  GIIS_SUBLINE.open_policy_sw%TYPE;
  v_issue_ri		  GIIS_PARAMETERS.param_value_v%TYPE :=  Giisp.v('ISS_CD_RI');
  v_dumm_var		  VARCHAR2(2000);
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : Validate_Addl_Items program unit
  */
   BEGIN
    SELECT  a.param_value_v  param_a, b.param_value_v  param_b, c.param_value_v  param_c,
  				d.param_value_v  param_d, e.param_value_v  param_e, f.param_value_v  param_f,
  				g.param_value_v  param_g, h.param_value_v  param_h, i.param_value_v  param_i
  	INTO  v_accident_cd, v_aviation_cd, v_casualty_cd,
  	      v_engrng_cd, v_fire_cd, v_motor_cd,
  	      v_hull_cd, v_cargo_cd, v_surety_cd
    FROM  GIIS_PARAMETERS A, GIIS_PARAMETERS B, GIIS_PARAMETERS C, 
          GIIS_PARAMETERS D, GIIS_PARAMETERS E, GIIS_PARAMETERS F,
          GIIS_PARAMETERS G, GIIS_PARAMETERS H, GIIS_PARAMETERS I
	 WHERE  a.param_name = 'LINE_CODE_AC'
	   AND  b.param_name = 'LINE_CODE_AV'
	   AND  c.param_name = 'LINE_CODE_CA'
	   AND  d.param_name = 'LINE_CODE_EN'
  	 AND  e.param_name = 'LINE_CODE_FI'
  	 AND  f.param_name = 'LINE_CODE_MC'
  	 AND  g.param_name = 'LINE_CODE_MH'
  	 AND  h.param_name = 'LINE_CODE_MN'
  	 AND  i.param_name = 'LINE_CODE_SU';
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
       p_msg_alert := 'No parameter record found. Please report error to CSD';
       --error_rtn;
  END; 
  
  BEGIN
  	   SELECT op_flag,open_policy_sw
         INTO v_open_flag,v_open_policy_sw
         FROM GIIS_SUBLINE
        WHERE line_cd    = p_line_cd AND
              subline_cd = p_subline_cd;
	EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
       --error_rtn;
  END;
  
  IF p_pack = 'Y' THEN
    FOR A IN (SELECT  pack_line_cd line_cd,pack_subline_cd subline_cd
                FROM  GIPI_WPACK_LINE_SUBLINE
               WHERE  par_id  =  p_par_id) LOOP
     IF A.line_cd       = v_fire_cd THEN
        NULL;--validate_wfire;
     ELSIF A.line_cd    = v_engrng_cd THEN
        NULL;
     ELSIF A.line_cd    = v_casualty_cd AND
        A.subline_cd = v_subline_bbb  OR 
        A.subline_cd = v_subline_ddd  OR
        A.subline_cd = v_subline_mrsb OR
        A.subline_cd = v_subline_mspr THEN
        NULL;
     ELSIF A.line_cd    = v_accident_cd THEN
        NULL;
     ELSIF A.line_cd    = v_surety_cd THEN
        Validate_Wbond_Basic(p_par_id, p_affecting, v_msg_alert);
		p_msg_alert := NVL(v_msg_alert,p_msg_alert);
     ELSIF A.line_cd IN (v_hull_cd,v_cargo_cd) THEN
        IF A.line_cd = v_cargo_cd THEN
           IF A.line_cd = v_cargo_cd AND v_open_policy_sw = 'Y' THEN
              --validate_wopen_policy;
			  BEGIN
			  	SELECT par_id
    			  INTO v_dumm_var
                  FROM GIPI_WOPEN_POLICY
                 WHERE par_id  = p_par_id;
			  EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 IF p_iss_cd  != v_issue_ri THEN 
                   p_msg_alert := 'PAR should have OPEN POLICY existing.';
    			   --:gauge.FILE :='PAR should have OPEN POLICY existing.';
    			   --error_rtn;
    		     END IF;
			  END;
	          --validate_wves_air;
			  BEGIN
			    SELECT vessel_cd	
    			  INTO v_dumm_var
    			  FROM GIPI_WVES_AIR	
                 WHERE GIPI_WVES_AIR.par_id = p_par_id;
			  EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  p_msg_alert := 'PAR should have a vessel/conveyance description.';
                WHEN TOO_MANY_ROWS THEN
                  NULL;
              END;
           END IF;
           IF A.line_cd = v_cargo_cd AND v_open_flag = 'Y' THEN
              --validate_wopen_liab;
			  BEGIN
			    SELECT geog_cd
    			  INTO v_dumm_var
    			  FROM GIPI_WOPEN_LIAB	
                 WHERE par_id	= p_par_id;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  p_msg_alert := 'PAR should have OPEN LIABILITY existing.';
              END;
           END IF;
        ELSIF A.line_cd = v_hull_cd THEN
           NULL;       
        END IF;
     END IF;
    END LOOP;
  ELSE
     IF p_line_cd       = v_fire_cd THEN
        --validate_wfire;
		NULL;
     ELSIF p_line_cd    = v_engrng_cd THEN
        NULL;
     ELSIF p_line_cd = v_casualty_cd AND
        p_subline_cd = v_subline_bbb  OR 
        p_subline_cd = v_subline_ddd  OR
        p_subline_cd = v_subline_mrsb OR
        p_subline_cd = v_subline_mspr THEN
        NULL;
     ELSIF p_line_cd    = v_accident_cd THEN
        NULL;
     ELSIF p_line_cd    = v_surety_cd THEN
       Validate_Wbond_Basic(p_par_id, p_affecting, v_msg_alert);
     ELSIF p_line_cd IN (v_hull_cd,v_cargo_cd) THEN
        IF p_line_cd = v_cargo_cd THEN
           IF p_line_cd = v_cargo_cd AND v_open_policy_sw = 'Y' THEN
              --validate_wopen_policy;
			  BEGIN
			  	SELECT par_id
    			  INTO v_dumm_var
                  FROM GIPI_WOPEN_POLICY
                 WHERE par_id  = p_par_id;
			  EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                 IF p_iss_cd  != v_issue_ri THEN 
                   p_msg_alert := 'PAR should have OPEN POLICY existing.';
    			   --:gauge.FILE :='PAR should have OPEN POLICY existing.';
    			   --error_rtn;
    		     END IF;
			  END;
	          --validate_wves_air;
			  BEGIN
			    SELECT vessel_cd	
    			  INTO v_dumm_var
    			  FROM GIPI_WVES_AIR	
                 WHERE GIPI_WVES_AIR.par_id = p_par_id;
			  EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  p_msg_alert := 'PAR should have a vessel/conveyance description.';
                WHEN TOO_MANY_ROWS THEN
                  NULL;
              END;
           END IF;
           IF p_line_cd = v_cargo_cd AND v_open_flag = 'Y' THEN
              --validate_wopen_liab;
			  BEGIN
			    SELECT geog_cd
    			  INTO v_dumm_var
    			  FROM GIPI_WOPEN_LIAB	
                 WHERE par_id	= p_par_id;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  p_msg_alert := 'PAR should have OPEN LIABILITY existing.';
              END;
           END IF;
        ELSIF p_line_cd = v_hull_cd THEN
           NULL;       
        END IF;
     END IF;
  END IF;
END;
/


