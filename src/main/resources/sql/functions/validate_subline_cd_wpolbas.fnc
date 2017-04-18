DROP FUNCTION CPI.VALIDATE_SUBLINE_CD_WPOLBAS;

CREATE OR REPLACE FUNCTION CPI.Validate_Subline_Cd_Wpolbas (
	   p_par_id	  		    GIPI_WPOLBAS.par_id%TYPE,
	   p_line_cd 			GIPI_WPOLBAS.line_cd%TYPE,
	   p_subline_cd 		GIPI_WPOLBAS.subline_cd%TYPE,
	   param_subline_cd 	GIPI_WPOLBAS.subline_cd%TYPE)
  RETURN VARCHAR2
  IS 
	v_result	 						 VARCHAR2(4000);
	v_exist		                         VARCHAR2(1) := 'N';
    v_exist1    						 VARCHAR2(1) := 'N';
	v_others 							 NUMBER 	 := 0;
    v_subline_name					     GIIS_SUBLINE.subline_name%TYPE;
	
	cg$ctrl_date_format 				 VARCHAR2(50);
	variables_lc_MH				 	 	 GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
    variables_lc_AV 					 GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
    variables_lc_MC 				 	 GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
    variables_lc_AC 				 	 GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
    variables_lc_FI 				 	 GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
    variables_lc_MN 				 	 GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
    variables_lc_CA 				 	 GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
    variables_lc_EN 				 	 GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
    variables_v_ri_cd 			 	 	 GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
    variables_subline_bbi 			 	 GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
    variables_subline_MI 				 GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
    variables_subline_MOP 		 	 	 GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
    variables_v_advance_booking  	 	 VARCHAR2(1);
    variables_dflt_takeup_term 	  	 	 GIIS_TAKEUP_TERM.takeup_term%TYPE;
    var_dflt_takeup_term_desc 		 	 GIIS_TAKEUP_TERM.takeup_term_desc%TYPE;
    variables_override_takeup_term 	 	 GIIS_PARAMETERS.param_value_v%TYPE;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information)
  **  Description  : to validate subline_cd
  */
	 Initialize_Parameters_Gipis002
  	   		(cg$ctrl_date_format,
   			 variables_lc_MH,
   			 variables_lc_AV,
   			 variables_lc_MC,
   			 variables_lc_AC,
   			 variables_lc_FI,
   			 variables_lc_MN,
   			 variables_lc_CA,
   			 variables_lc_EN,
   			 variables_v_ri_cd,
   			 variables_subline_bbi,
   			 variables_subline_MI,
   			 variables_subline_MOP,
   			 variables_v_advance_booking,
   			 variables_dflt_takeup_term,
   			 var_dflt_takeup_term_desc,
   			 variables_override_takeup_term);
			 
	 B540_Sublcd_Wvi_A_Gipis002(p_line_cd, param_subline_cd, variables_subline_MOP, p_par_id, v_exist1, v_exist);
     
     IF v_exist = 'Y' OR v_exist1 = 'Y' AND
     	  p_subline_cd <> param_subline_cd THEN

        IF v_exist = 'Y' THEN
           v_result := 'The subline code of this PAR cannot be updated, for detail records already ' ||
                     'exist.  However, you may choose to delete this PAR and recreate it with the ' ||
                     'necessary changes.';     
        ELSIF v_exist1 = 'Y' THEN
           v_result := 'The subline code of this PAR cannot be updated, for limits of liabilities already ' ||
                     'exist.  However, you may choose to delete this PAR and recreate it with the ' ||
                     'necessary changes.';     
        END IF;                  
     END IF;
	 
	 Cgfk$chk_B540sublwpol_Gipis002(TRUE,p_line_cd, p_subline_cd, p_line_cd, v_subline_name, v_others);
     IF v_others = 0 THEN
    	NULL;
     ELSIF v_others = 100 THEN
        v_result := 'Subline for this line does not exist in master file.';
     ELSE
        v_result := 'Error in Getting the Subline';
     END IF;
		
	RETURN v_result;
END;
/


