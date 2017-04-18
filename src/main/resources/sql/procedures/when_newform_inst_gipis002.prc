DROP PROCEDURE CPI.WHEN_NEWFORM_INST_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.When_Newform_Inst_Gipis002
	   	  (p_iss_cd           IN VARCHAR2,
    	   p_upd_cred_branch  IN OUT VARCHAR2,
		   p_msg			  IN OUT VARCHAR2,
		   p_req_cred_branch  IN OUT VARCHAR2,
		   p_upd_issue_date	  IN OUT VARCHAR2,
		   p_req_ref_pol_no	  IN OUT VARCHAR2,
		   p_def_cred_branch  IN OUT VARCHAR2,
		   p_var_vdate		  IN OUT VARCHAR2,
           p_line_cd          IN gipi_wpolbas.line_cd%TYPE,
           p_type_cd_status   OUT VARCHAR2,
           p_req_ref_no       OUT VARCHAR2) 
	IS
	PARAMETER_VAR_VDATE		 GIIS_PARAMETERS.param_value_n%TYPE;  
	v_clm_stat_cancel		 GIIS_PARAMETERS.param_value_v%TYPE;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information)
  **  Description  : WHEN-NEWFORM-INSTANCE in gipis002
  */
	 When_Newform_Inst_B_Gipis002(PARAMETER_VAR_VDATE);
		 IF PARAMETER_VAR_VDATE > 4 THEN
  	  		 p_msg := 'The parameter value ('||TO_CHAR(PARAMETER_VAR_VDATE)||') for parameter name ''PROD_TAKE_UP'' is invalid. Please do the necessary changes.';
             RETURN;	 
		 END IF;
	 When_Newform_Inst_C_Gipis002(v_clm_stat_cancel);		
   		 IF v_clm_stat_cancel IS NULL THEN
   	         p_msg := 'Record not found in GIIS_PARAMETERS  for param_name GICL_CLAIMS_CLM_STAT_CD_CANCELLED';
             RETURN;
		 END IF; 
     When_Newform_Inst_D_Gipis002(p_upd_issue_date);
	 --When_Newform_Inst_E_Gipis002(p_iss_cd, p_upd_cred_branch); removed by robert 01.07.15
	 p_upd_cred_branch := 'Y'; --added by robert 01.07.15
	 When_Newform_Inst_F_Gipis002(p_req_ref_pol_no);		 										  	
	 When_Newform_Inst_G_Gipis002(p_req_cred_branch , p_def_cred_branch);
 	 p_var_vdate := PARAMETER_VAR_VDATE;
     
     FOR A IN (
         SELECT param_value_v
           FROM giis_parameters
          WHERE param_name LIKE 'TYPE_CD_LINES%'
            AND param_value_v = p_line_cd) 
     LOOP
        p_type_cd_status  :=  'Y';
        EXIT;
     END LOOP;
     
     -- added by Jdiago 09.09.2014
     FOR brn IN (SELECT NVL(param_value_v, 'N') param_value_v 
                   FROM giis_parameters
                  WHERE param_name LIKE 'REQUIRE_REF_NO')
     LOOP
        p_req_ref_no := brn.param_value_v;
        EXIT;
     END LOOP;
     p_msg := nvl(p_msg,'');
END;
/


