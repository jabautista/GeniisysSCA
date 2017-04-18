CREATE OR REPLACE PACKAGE CPI.GICLS204_PKG
   /*
   **  Created by        : bonok
   **  Date Created      : 08.01.2013
   **  Reference By      : GICLS204 - LOSS RATIO
   **
   */
AS 
   TYPE line_gicls204_lov_type IS RECORD(
      line_cd               giis_line.line_cd%TYPE,
      line_name             giis_line.line_name%TYPE
   );
    
   TYPE line_gicls204_lov_tab IS TABLE OF line_gicls204_lov_type;
     
   FUNCTION get_line_gicls204_lov(
      p_iss_cd              giis_issource.iss_cd%TYPE,
      p_module_id           giis_modules.module_id%TYPE,
      p_user_id             giis_users.user_id%TYPE
   ) RETURN line_gicls204_lov_tab PIPELINED;
    
   TYPE subline_gicls204_lov_type IS RECORD(
      subline_cd            giis_subline.subline_cd%TYPE,
      subline_name          giis_subline.subline_name%TYPE
   );
    
   TYPE subline_gicls204_lov_tab IS TABLE OF subline_gicls204_lov_type;
    
   FUNCTION get_subline_gicls204_lov(
      p_line_cd             giis_subline.line_cd%TYPE
   ) RETURN subline_gicls204_lov_tab PIPELINED;
    
   TYPE iss_gicls204_lov_type IS RECORD(
      iss_cd                giis_issource.iss_cd%TYPE,
      iss_name              giis_issource.iss_name%TYPE
   );
    
   TYPE iss_gicls204_lov_tab IS TABLE OF iss_gicls204_lov_type;
   
   FUNCTION get_iss_gicls204_lov(
      p_line_cd             giis_line.line_cd%TYPE,
      p_module_id           giis_modules.module_id%TYPE,
      p_user_id             giis_users.user_id%TYPE
   ) RETURN iss_gicls204_lov_tab PIPELINED;

   TYPE intm_gicls204_lov_type IS RECORD(
      intm_no               giis_intermediary.intm_no%TYPE,
      intm_name             giis_intermediary.intm_name%TYPE
   );
    
   TYPE intm_gicls204_lov_tab IS TABLE OF intm_gicls204_lov_type;
   
   FUNCTION get_intm_gicls204_lov
   RETURN intm_gicls204_lov_tab PIPELINED;
   
   TYPE assd_gicls204_lov_type IS RECORD(
      assd_no               giis_assured.assd_no%TYPE,
      assd_name             giis_assured.assd_name%TYPE
   );
    
   TYPE assd_gicls204_lov_tab IS TABLE OF assd_gicls204_lov_type;
   
   FUNCTION get_assd_gicls204_lov
   RETURN assd_gicls204_lov_tab PIPELINED;
   
   TYPE peril_gicls204_lov_type IS RECORD(
      peril_cd              giis_peril.peril_cd%TYPE,
      peril_name            giis_peril.peril_name%TYPE
   );
    
   TYPE peril_gicls204_lov_tab IS TABLE OF peril_gicls204_lov_type;
   
   FUNCTION get_peril_gicls204_lov(
      p_line_cd             giis_peril.line_cd%TYPE
   ) RETURN peril_gicls204_lov_tab PIPELINED;
   
   FUNCTION validate_assd_no_gicls204(
      p_assd_no             giis_assured.assd_no%TYPE
   ) RETURN VARCHAR2;
   
   FUNCTION validate_peril_cd_gicls204(
      p_line_cd             giis_peril.line_cd%TYPE,
      p_peril_cd            giis_peril.peril_cd%TYPE
   ) RETURN VARCHAR2;
   
   FUNCTION get_session_id
   RETURN NUMBER;
   
   PROCEDURE extract_gicls204(
      p_assd_no             IN giis_assured.assd_no%TYPE,
      p_date                IN gipi_polbasic.issue_date%TYPE,
      p_date_24th           IN VARCHAR2,
      p_extract_cat         IN VARCHAR2,
      p_extract_proc        IN VARCHAR2,
      p_intm_no             IN giis_intermediary.intm_no%TYPE,
      p_iss_cd              IN giis_issource.iss_cd%TYPE,
      p_issue_option        IN VARCHAR2,
      p_line_cd             IN giis_line.line_cd%TYPE,
      p_peril_cd            IN giis_peril.peril_cd%TYPE,
      p_prnt_date           IN VARCHAR2,
      p_prnt_option         IN VARCHAR2,
      p_subline_cd          IN giis_subline.subline_cd%TYPE,
      p_user_id             IN giis_users.user_id%TYPE,
      p_cnt                 OUT NUMBER,
      p_curr_24             OUT VARCHAR2,
      p_curr1_24            OUT VARCHAR2,
      p_curr_os_sw          OUT VARCHAR2,
      p_curr_prem_sw        OUT VARCHAR2,
      p_loss_paid_sw        OUT VARCHAR2,
      p_prev_24             OUT VARCHAR2,
      p_prev1_24            OUT VARCHAR2,
      p_prev_os_sw          OUT VARCHAR2,
      p_prev_prem_sw        OUT VARCHAR2,
      p_prev_rec_sw         OUT VARCHAR2,
      p_prev_year			OUT VARCHAR2,
	  p_curr_rec_sw         OUT VARCHAR2,
      p_session_id          OUT NUMBER
   );
   
   PROCEDURE pop_gicl_24th_tab_mn(
      p_date                IN VARCHAR2,
      p_session_id          IN gicl_loss_ratio_ext.session_id%TYPE,
      p_user_id             IN giis_users.user_id%TYPE
   );
   
   PROCEDURE pop_gicl_24th_tab(
      p_date                IN VARCHAR2,
      p_session_id          IN gicl_loss_ratio_ext.session_id%TYPE,
      p_user_id             IN giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_premium2(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_prev_year          VARCHAR2,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_ext_proc           VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_premium3(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_prev_year          VARCHAR2,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_ext_proc           VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_premium2_assd(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_prev_year          VARCHAR2,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_ext_proc           VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_premium_assd(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_prev_year          VARCHAR2,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_ext_proc           VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_losses_paid3(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_exists         OUT VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_os3(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_recovery3(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_recovery2(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_premium_intm2(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_prev_year          VARCHAR2,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_ext_proc           VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_premium_intm(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_prev_year          VARCHAR2,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_ext_proc           VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_prem_intm2_assd(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_prev_year          VARCHAR2,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_ext_proc           VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_prem_intm_assd(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_prev_year          VARCHAR2,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_ext_proc           VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_loss_paid_intm(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_exists         OUT VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_os_intm(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_recovery_intm(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_recovery_intm2(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param         NUMBER,
      p_issue_param        NUMBER,
      p_curr1_date         gipi_polbasic.issue_date%TYPE,
      p_curr2_date         gipi_polbasic.issue_date%TYPE,
      p_prev1_date         gipi_polbasic.issue_date%TYPE,
      p_prev2_date         gipi_polbasic.issue_date%TYPE,
      p_curr_exists    OUT VARCHAR2,
      p_prev_exists    OUT VARCHAR2,
      p_extract_cat        VARCHAR2,
      p_user_id            giis_users.user_id%TYPE
   );
   
   PROCEDURE lratio_extract_by_line(
      p_line_cd		       giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_loss_date          gicl_claims.loss_date%TYPE,
      p_counter       OUT  NUMBER,
      p_ext_proc           VARCHAR2,
      p_user_id            giis_users.user_id%TYPE,
      p_date               gipi_polbasic.issue_date%TYPE -- Dren Niebres 07.12.2016 SR-21428
   );
   
   PROCEDURE lratio_extract_by_subline(
      p_line_cd            giis_line.line_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_loss_date          gicl_claims.loss_date%TYPE,
      p_counter       OUT  NUMBER,
      p_ext_proc           VARCHAR2,
      p_user_id            giis_users.user_id%TYPE,
      p_date               gipi_polbasic.issue_date%TYPE -- Dren Niebres 07.12.2016 SR-21428
   );
   
   PROCEDURE lratio_extract_by_iss_cd(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_loss_date          gicl_claims.loss_date%TYPE,
      p_counter       OUT  NUMBER,
      p_ext_proc           VARCHAR2,
      p_user_id            giis_users.user_id%TYPE,
      p_date               gipi_polbasic.issue_date%TYPE -- Dren Niebres 07.12.2016 SR-21428
   );
   
   PROCEDURE lratio_extract_by_intermediary(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_loss_date          gicl_claims.loss_date%TYPE,
      p_counter       OUT  NUMBER,
      p_ext_proc           VARCHAR2,
      p_user_id            giis_users.user_id%TYPE,
      p_date               gipi_polbasic.issue_date%TYPE -- Dren Niebres 07.12.2016 SR-21428
   );
   
   PROCEDURE lratio_extract_by_assured(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_peril_cd           giis_peril.peril_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_loss_date          gicl_claims.loss_date%TYPE,
      p_counter       OUT  NUMBER,
      p_ext_proc           VARCHAR2,
      p_user_id            giis_users.user_id%TYPE,
      p_date               gipi_polbasic.issue_date%TYPE -- Dren Niebres 07.12.2016 SR-21428
   );
   
   PROCEDURE lratio_extract_by_peril(
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_intm_no            giis_intermediary.intm_no%TYPE,
      p_assd_no            giis_assured.assd_no%TYPE,
      p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
      p_loss_date          gicl_claims.loss_date%TYPE,
      p_counter       OUT  NUMBER,
      p_ext_proc           VARCHAR2,
      p_user_id            giis_users.user_id%TYPE,
      p_date               gipi_polbasic.issue_date%TYPE -- Dren Niebres 07.12.2016 SR-21428
   );
   
   PROCEDURE get_detail_report_date(
      p_date               IN OUT VARCHAR2,
      p_extract_proc       IN VARCHAR2,
      p_curr1_date        OUT VARCHAR2,
      p_curr2_date        OUT VARCHAR2,
      p_prev_year         OUT VARCHAR2,
      p_curr_year         OUT VARCHAR2,
      p_prev1_date        OUT VARCHAR2,
      p_prev2_date        OUT VARCHAR2
   );
   
   PROCEDURE lratio_extract_losses_paid (
      p_line_cd             gicl_claims.line_cd%TYPE,
      p_subline_cd          gicl_claims.subline_cd%TYPE,
      p_iss_cd              gicl_claims.iss_cd%TYPE,
      p_intm_no             gicl_intm_itmperil.intm_no%TYPE,
      p_assd_no             gicl_claims.assd_no%TYPE,
      p_peril_cd            gicl_clm_res_hist.peril_cd%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          DATE,       --First Day of As Of Date parameter minus 11 months(24th Method) / First Day of the year based on the year of parameter (Straight)
      p_curr2_date          DATE,       --Last Day of As Of Date parameter(24th Method) / As Of Date parameter (Straight)
      p_exists        OUT   VARCHAR2,
      p_extract_cat         VARCHAR2,   --Extract Amount By : G-GROSS or N-NET
      p_print_option        NUMBER,     --Print Report By:   4-Per Intermediary
      p_user_id             VARCHAR2
   );
   
   PROCEDURE lratio_extract_os (
      p_line_cd             gicl_claims.line_cd%TYPE,
      p_subline_cd          gicl_claims.subline_cd%TYPE,
      p_iss_cd              gicl_claims.iss_cd%TYPE,
      p_intm_no             gicl_intm_itmperil.intm_no%TYPE,
      p_assd_no             gicl_claims.assd_no%TYPE,
      p_peril_cd            gicl_clm_res_hist.peril_cd%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          DATE,       --First Day of As Of Date parameter minus 11 months(24th Method) / First Day of the year based on the year of parameter (Straight)
      p_curr2_date          DATE,       --Last Day of As Of Date parameter(24th Method) / As Of Date parameter (Straight)
      p_prev1_date          DATE,       --p_curr1_date minus 1 year
      p_prev2_date          DATE,       --p_curr2_date minus 1 year
      p_curr_exists    OUT  VARCHAR2,
      p_prev_exists    OUT  VARCHAR2,
      p_extract_cat         VARCHAR2,   --Extract Amount By : G-GROSS or N-NET
      p_print_option        NUMBER,     --Print Report By:   4-Per Intermediary
      p_user_id             VARCHAR2
   );
   
   PROCEDURE lratio_extract_recovery (
      p_line_cd             gicl_claims.line_cd%TYPE,
      p_subline_cd          gicl_claims.subline_cd%TYPE,
      p_iss_cd              gicl_claims.iss_cd%TYPE,
      p_intm_no             gicl_intm_itmperil.intm_no%TYPE,
      p_assd_no             gicl_claims.assd_no%TYPE,
      p_peril_cd            gicl_clm_res_hist.peril_cd%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          DATE,       --First Day of As Of Date parameter minus 11 months(24th Method) / First Day of the year based on the year of parameter (Straight)
      p_curr2_date          DATE,       --Last Day of As Of Date parameter(24th Method) / As Of Date parameter (Straight)
      p_prev1_date          DATE,       --p_curr1_date minus 1 year
      p_prev2_date          DATE,       --p_curr2_date minus 1 year
      p_curr_exists    OUT  VARCHAR2,
      p_prev_exists    OUT  VARCHAR2,
      p_extract_cat         VARCHAR2,   --Extract Amount By : G-GROSS or N-NET
      p_print_option        NUMBER,     --Print Report By:   4-Per Intermediary
      p_user_id             VARCHAR2
   );
   
   PROCEDURE lratio_extract_premium(
      p_line_cd             gicl_claims.line_cd%TYPE,
      p_subline_cd          gicl_claims.subline_cd%TYPE,
      p_iss_cd              gicl_claims.iss_cd%TYPE,
      p_intm_no             gicl_intm_itmperil.intm_no%TYPE,
      p_assd_no             gicl_claims.assd_no%TYPE,
      p_peril_cd            gicl_clm_res_hist.peril_cd%TYPE,
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_date_param          NUMBER,
      p_issue_param         NUMBER,
      p_curr1_date          gipi_polbasic.issue_date%TYPE,       --First Day of As Of Date parameter minus 11 months(24th Method) / First Day of the year based on the year of parameter (Straight)
      p_curr2_date          gipi_polbasic.issue_date%TYPE,       --Last Day of As Of Date parameter(24th Method) / As Of Date parameter (Straight)
      p_prev1_date          gipi_polbasic.issue_date%TYPE,       --p_curr1_date minus 1 year
      p_prev2_date          gipi_polbasic.issue_date%TYPE,       --p_curr2_date minus 1 year
      p_curr_exists    OUT  VARCHAR2,
      p_prev_exists    OUT  VARCHAR2,
      p_extract_cat         VARCHAR2,   --Extract Amount By : G-GROSS or N-NET
      p_print_option        NUMBER,     --Print Report By:   4-Per Intermediary
      p_user_id             giis_users.user_id%TYPE
   );
   
   FUNCTION get_reversal(
      p_tran_id            IN gicl_clm_res_hist.tran_id%TYPE,
      p_from_date          IN DATE,
      p_to_date            IN DATE
   ) RETURN NUMBER;
   
   FUNCTION get_multiplier(
      p_acct_ent_date      IN DATE,
      p_acct_neg_date      IN DATE,
      p_from_date          IN DATE,
      p_to_date            IN DATE
   ) RETURN NUMBER;
END GICLS204_PKG;
/


