DROP PROCEDURE CPI.GIPIS002A_WHEN_NEW_FORM_INST;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002A_WHEN_NEW_FORM_INST
             (p_line_cd             IN VARCHAR2,
              p_iss_cd              IN VARCHAR2,
              p_type_cd_status      IN OUT VARCHAR2,
              p_upd_cred_branch     IN OUT VARCHAR2,
              p_msg                 IN OUT VARCHAR2,
              p_req_cred_branch     IN OUT VARCHAR2,
              p_upd_issue_date      IN OUT VARCHAR2,
              p_req_ref_pol_no      IN OUT VARCHAR2,
              p_def_cred_branch     IN OUT VARCHAR2,
              p_var_vdate           IN OUT VARCHAR2) 
    IS
    parameter_var_vdate       GIIS_PARAMETERS.param_value_n%TYPE;  
    v_clm_stat_cancel         GIIS_PARAMETERS.param_value_v%TYPE;

BEGIN
  
  /*
  **  Created by   :  Veronica V. Raymundo
  **  Date Created :  March 07, 2011
  **  Reference By : (GIPIS002A - Package Basic Information)
  **  Description  : Executes WHEN-NEW-FORM-INSTANCE in GIPIS002A
  */
  
     BEGIN
        FOR C IN (SELECT param_value_n
                   FROM GIAC_PARAMETERS
                   WHERE param_name = 'PROD_TAKE_UP')
        LOOP
         parameter_var_vdate := C.param_value_n;
        END LOOP; 
            
        IF PARAMETER_VAR_VDATE > 3 THEN
         p_msg := 'The parameter value ('||TO_CHAR(parameter_var_vdate)||') for parameter name ''PROD_TAKE_UP'' is invalid. Please do the necessary changes.';     
        END IF;
            
     END;
     
     BEGIN
        FOR STAT IN ( SELECT param_value_v  cd
                       FROM giis_parameters
                       WHERE param_name = 'GICL_CLAIMS_CLM_STAT_CD_CANCELLED') 
        LOOP
            v_clm_stat_cancel := stat.cd;
        END LOOP;
                 
        IF v_clm_stat_cancel IS NULL THEN
            p_msg := 'Record not found in GIIS_PARAMETERS  for param_name GICL_CLAIMS_CLM_STAT_CD_CANCELLED';
        END IF;
     END;
     
     BEGIN
         FOR C1 IN (
            SELECT param_value_v
              FROM GIIS_PARAMETERS
             WHERE param_name = 'UPDATE_ISSUE_DATE')
         LOOP
           p_upd_issue_date := C1.param_value_v;
         END LOOP;
     END;
     
     BEGIN
         /* removed by robert 01.07.15
			 FOR sw IN (SELECT cred_br_tag
						FROM GIIS_ISSOURCE
						WHERE iss_cd = p_iss_cd)
			 LOOP
			  p_upd_cred_branch := sw.cred_br_tag;
			 END LOOP;
		 */
		 p_upd_cred_branch := 'Y'; --added by robert 01.07.15
     END;
     
     BEGIN
         FOR A IN (SELECT param_value_v
                   FROM GIIS_PARAMETERS
                   WHERE param_name = 'REQUIRE_REF_POL_NO')
         LOOP
            p_req_ref_pol_no := A.param_value_v;
         END LOOP;
     END;
     
     BEGIN
          FOR A IN ( SELECT a.param_value_v ap,
                          b.param_value_v bp
                 FROM giis_parameters a, 
                      giis_parameters b
                WHERE a.param_name = 'MANDATORY_CRED_BRANCH'
                  AND b.param_name = 'DEFAULT_CRED_BRANCH')
        LOOP
            p_req_cred_branch := A.ap;
            p_def_cred_branch := A.bp;
        END LOOP;  
     END;
     
     TYPE_CD_STATUS(p_line_cd, p_type_cd_status);
     p_var_vdate := parameter_var_vdate;
END;
/


