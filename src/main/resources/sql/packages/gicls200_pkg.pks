CREATE OR REPLACE PACKAGE CPI.GICLS200_PKG
AS

    PROCEDURE get_def_values_for_user(
        p_user_id           IN  giis_users.user_id%TYPE,
        p_as_of_date        OUT VARCHAR2,
        p_os_date_opt       OUT GICL_OS_PD_CLM_EXTR.os_date_opt%TYPE,
        p_pd_date_opt       OUT GICL_OS_PD_CLM_EXTR.pd_date_opt%TYPE,
        p_cat_cd            OUT GICL_OS_PD_CLM_EXTR.p_cat_cd%TYPE,
        p_cat_desc          OUT GICL_CAT_DTL.CATASTROPHIC_DESC%TYPE,
        p_line              OUT GICL_OS_PD_CLM_EXTR.p_line%TYPE,
        p_line_name         OUT giis_line.line_name%TYPE,
        p_iss_cd            OUT GICL_OS_PD_CLM_EXTR.p_iss_cd%TYPE,
        p_iss_name          OUT giis_issource.iss_name%TYPE,
        p_loc               OUT GICL_OS_PD_CLM_EXTR.p_loc%TYPE,
        p_location_desc     OUT VARCHAR2,
        p_loss_cat_cd       OUT GICL_OS_PD_CLM_EXTR.p_loss_cat_cd%TYPE,
        p_loss_cat_desc     OUT GIIS_LOSS_CTGRY.LOSS_CAT_DES%TYPE,
        p_ri_cd             OUT giis_reinsurer.ri_cd%TYPE,
        p_ri_name           OUT giis_reinsurer.ri_name%TYPE
    );
    
     PROCEDURE validate_bef_print(
        p_user_id       IN  giis_users.user_id%TYPE,
        p_session_id    OUT gicl_os_pd_clm_extr.session_id%TYPE,
        p_ext_date      OUT VARCHAR2
    );
    
    TYPE line_listing_type IS RECORD (
      line_cd         giis_line.line_cd%TYPE,
      line_name       giis_line.line_name%TYPE
   );

   TYPE line_listing_tab IS TABLE OF line_listing_type;
   
   TYPE issue_source_list_type IS RECORD (
      iss_cd     GIIS_ISSOURCE.iss_cd%TYPE,
      iss_name   GIIS_ISSOURCE.iss_name%TYPE
   );
   
   TYPE issue_source_list_tab IS TABLE OF issue_source_list_type;
   
   FUNCTION get_gicls200_line_list (
      p_module_id    giis_modules.module_id%TYPE,
      p_pol_iss_cd   VARCHAR2,
      p_user_id      giis_users.user_id%TYPE,
      p_keyword      VARCHAR2
   )
      RETURN line_listing_tab PIPELINED;
   
   FUNCTION get_gicls200_branch_list (
      p_line_cd      giis_line.line_cd%TYPE,
      p_user_id      VARCHAR2,
      p_module_id    giis_user_grp_modules.module_id%TYPE,
      p_keyword      VARCHAR2
   )
      RETURN issue_source_list_tab PIPELINED;  
    
END GICLS200_PKG;
/


