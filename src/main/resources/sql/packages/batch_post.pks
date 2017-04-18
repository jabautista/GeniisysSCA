CREATE OR REPLACE PACKAGE CPI.BATCH_POST AS
PROCEDURE POST(p_par_id            IN NUMBER,
               p_line_cd           IN VARCHAR2,
      p_iss_cd            IN VARCHAR2,
      p_par_type          IN VARCHAR2,
      p_back_endt         IN VARCHAR2,
      out_postpar_policy_id  OUT giuw_pol_dist.policy_id%TYPE, 
      out_postpar_dist_no    OUT giuw_pol_dist.dist_no%TYPE,
      out_postpar_par_id     OUT gipi_parlist.par_id%TYPE,
      out_postpar_line_cd    OUT gipi_parlist.line_cd%TYPE,  
      out_postpar_subline_cd OUT gipi_wpolbas.subline_cd%TYPE,
      out_postpar_iss_cd     OUT gipi_wpolbas.iss_cd%TYPE,
      out_postpar_pack       OUT gipi_wpolbas.pack_pol_flag%TYPE,
      out_affecting          OUT VARCHAR2
      );
PROCEDURE DELETE_DIST_WORKING_TABLES (v_dist_no giuw_pol_dist.dist_no%TYPE);
PROCEDURE VALIDATE_EXISTING_WORKING_DIST(p_dist_no giuw_pol_dist.dist_no%TYPE,
                                         p_check_on OUT NUMBER);
PROCEDURE copy_pol_wendttext;
PROCEDURE update_quote;
PROCEDURE delete_par;
PROCEDURE process_distribution(v_check_on OUT NUMBER);
PROCEDURE DELETE_WORKFLOW_REC(p_event_desc  IN VARCHAR2,
                              p_module_id  IN VARCHAR2,
                              p_user       IN VARCHAR2,
                              p_col_value IN VARCHAR2);
PROCEDURE DELETE_OTHER_WORKFLOW_REC(p_event_desc  IN VARCHAR2,
                                    p_module_id  IN VARCHAR2,
                                    p_user       IN VARCHAR2,
                                    p_col_value IN VARCHAR2);
PROCEDURE CREATE_TRANSFER_WORKFLOW_REC(p_event_desc IN VARCHAR2,
                                       p_module_id  IN VARCHAR2,
                                       p_user       IN VARCHAR2,
                                       p_col_value  IN VARCHAR2,
                                       p_info       IN VARCHAR2);
PROCEDURE PRE_POST_ERROR (p_par_id  IN NUMBER,
                          p_remarks IN VARCHAR2
                          );                                   
END;
/


