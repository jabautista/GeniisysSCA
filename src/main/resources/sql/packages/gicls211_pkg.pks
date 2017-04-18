CREATE OR REPLACE PACKAGE CPI.GICLS211_PKG
   /*
   **  Created by        : bonok
   **  Date Created      : 09.02.2013
   **  Reference By      : GICLS211 - LOSS PROFILE
   **
   */
AS 
   TYPE gicls211_param_type IS RECORD(
      line_cd_mc           giis_line.line_cd%TYPE,
      line_cd_fi           giis_line.line_cd%TYPE,
      cur_exist            VARCHAR2(1)
   );
   TYPE gicls211_param_tab IS TABLE OF gicls211_param_type;

   FUNCTION when_new_form_instance
     RETURN gicls211_param_tab PIPELINED;
   
   TYPE risk_profile_type IS RECORD (
      line_cd               giis_line.line_cd%TYPE,
      dsp_line_name         giis_line.line_name%TYPE,
      subline_cd            giis_subline.subline_cd%TYPE,
      dsp_subline_name      giis_subline.subline_name%TYPE,
      date_from             VARCHAR2(10),
      date_to               VARCHAR2(10),
      loss_date_from        VARCHAR2(10),
      loss_date_to          VARCHAR2(10),
      cur_exist             VARCHAR2(1),
      cg$ctrl_line_cd       giis_line.line_cd%TYPE,
      no_of_range           NUMBER,
      user_id               gicl_loss_profile.user_id%TYPE,
      gicls212_access       VARCHAR2(1)
   );
   
   TYPE risk_profile_tab IS TABLE OF risk_profile_type; 
   
   FUNCTION get_risk_profile_list(
      p_user_id             giis_users.user_id%TYPE,
      p_module_id           giis_modules.module_id%TYPE
   ) RETURN risk_profile_tab PIPELINED;
   
   TYPE range_type IS RECORD (
      line_cd               gicl_loss_profile.line_cd%TYPE,
      subline_cd            gicl_loss_profile.subline_cd%TYPE,
      range_from            gicl_loss_profile.range_from%TYPE,
      range_to              gicl_loss_profile.range_to%TYPE,
      user_id               gicl_loss_profile.user_id%TYPE
   );
   
   TYPE range_tab IS TABLE OF range_type;
   
   FUNCTION get_range_list(
      p_line_cd             gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          gicl_loss_profile.subline_cd%TYPE,
      p_user_id             gicl_loss_profile.user_id%TYPE,
      p_module_id           giis_modules.module_id%TYPE
   ) RETURN range_tab PIPELINED;
   
   TYPE subline_lov_type IS RECORD (
      subline_cd            giis_subline.subline_cd%TYPE,
      subline_name          giis_subline.subline_name%TYPE,
      line_cd               giis_subline.line_cd%TYPE
   );
   
   TYPE subline_lov_tab IS TABLE OF subline_lov_type;
   
   FUNCTION get_subline_lov(
      p_line_cd             giis_subline.line_cd%TYPE,
      p_module_id           giis_modules.module_id%TYPE,
      p_user_id             giis_users.user_id%TYPE
   ) RETURN subline_lov_tab PIPELINED; 
   
   PROCEDURE delete_profile_line_subline(
      p_user_id             IN giis_users.user_id%TYPE,
      p_dsp_line_name       IN giis_line.line_name%TYPE,
      p_dsp_subline_name    IN giis_subline.subline_name%TYPE,
      p_type                IN VARCHAR2,
      p_line_cd             OUT gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          OUT gicl_loss_profile.subline_cd%TYPE
   );
   
   PROCEDURE save_line_subline_range(
      p_user_id             IN giis_users.user_id%TYPE,
      p_line_cd             IN gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          IN gicl_loss_profile.subline_cd%TYPE,
      p_range_from          IN gicl_loss_profile.range_from%TYPE,
      p_range_to            IN gicl_loss_profile.range_to%TYPE,
      p_date_from           IN gicl_loss_profile.date_from%TYPE,
      p_date_to             IN gicl_loss_profile.date_to%TYPE,
      p_loss_date_from      IN gicl_loss_profile.loss_date_from%TYPE,
      p_loss_date_to        IN gicl_loss_profile.loss_date_to%TYPE,
      p_type                IN VARCHAR2
   );
   
   PROCEDURE delete_profile_line(
      p_dsp_line_name       IN giis_line.line_name%TYPE,
      p_line_cd             OUT gicl_loss_profile.line_cd%TYPE
   );
   
   PROCEDURE delete_line_and_subline(
      p_user_id             IN giis_users.user_id%TYPE,
      p_dsp_line_name       IN giis_line.line_name%TYPE,
      p_line_cd             OUT gicl_loss_profile.line_cd%TYPE
   );
   
   PROCEDURE save_line_and_subline_range(
      p_user_id             IN giis_users.user_id%TYPE,
      p_line_cd             IN gicl_loss_profile.line_cd%TYPE,
      p_range_from          IN gicl_loss_profile.range_from%TYPE,
      p_range_to            IN gicl_loss_profile.range_to%TYPE,
      p_date_from           IN gicl_loss_profile.date_from%TYPE,
      p_date_to             IN gicl_loss_profile.date_to%TYPE,
      p_loss_date_from      IN gicl_loss_profile.loss_date_from%TYPE,
      p_loss_date_to        IN gicl_loss_profile.loss_date_to%TYPE
   );
   
   PROCEDURE delete_all_line(
      p_user_id             IN giis_users.user_id%TYPE
   );
   
   PROCEDURE save_all_line(
      p_user_id             IN giis_users.user_id%TYPE,
      p_range_from          IN gicl_loss_profile.range_from%TYPE,
      p_range_to            IN gicl_loss_profile.range_to%TYPE,
      p_date_from           IN gicl_loss_profile.date_from%TYPE,
      p_date_to             IN gicl_loss_profile.date_to%TYPE,
      p_loss_date_from      IN gicl_loss_profile.loss_date_from%TYPE,
      p_loss_date_to        IN gicl_loss_profile.loss_date_to%TYPE
   );
   
   PROCEDURE extract_loss_profile(
      p_user_id             IN giis_users.user_id%TYPE,
      p_param_date          IN VARCHAR2,
      p_claim_date          IN VARCHAR2,
      p_line_cd             IN gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          IN gicl_loss_profile.subline_cd%TYPE,
      p_date_from           IN gicl_loss_profile.date_from%TYPE,
      p_date_to             IN gicl_loss_profile.date_to%TYPE,
      p_loss_date_from      IN gicl_loss_profile.loss_date_from%TYPE,
      p_loss_date_to        IN gicl_loss_profile.loss_date_to%TYPE,
      p_extract_by_rg       IN NUMBER,
      p_e_type              IN NUMBER,
      p_var_ext             OUT VARCHAR2,
      p_message             OUT VARCHAR2
   );
  
   PROCEDURE loss_profile_extract_tsi(
      p_user_id             IN giis_users.user_id%TYPE,
      p_param_date          IN VARCHAR2,
      p_claim_date          IN VARCHAR2,
      p_line_cd             IN gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          IN gicl_loss_profile.subline_cd%TYPE,
      p_date_from           IN gicl_loss_profile.date_from%TYPE,
      p_date_to             IN gicl_loss_profile.date_to%TYPE,
      p_loss_date_from      IN gicl_loss_profile.loss_date_from%TYPE,
      p_loss_date_to        IN gicl_loss_profile.loss_date_to%TYPE,
      p_e_type              IN NUMBER,
      p_var_ext             OUT VARCHAR2,
      p_message             OUT VARCHAR2
   );
   
   PROCEDURE get_loss_ext(
      p_loss_sw  IN VARCHAR2,
      p_loss_fr  IN DATE,
      p_loss_to  IN DATE,
      p_line_cd  IN VARCHAR2,
      p_subline  IN VARCHAR2,
      p_user_id  IN giis_users.user_id%TYPE
   );
   
   PROCEDURE get_loss_ext2(
      p_pol_sw      IN VARCHAR2,
      p_date_fr     IN DATE,
      p_date_to     IN DATE,
      p_line_cd     IN VARCHAR2,
      p_subline     IN VARCHAR2,
      p_user_id     IN giis_users.user_id%TYPE
   );
   
   TYPE get_profile_extract_tsi_type IS RECORD (
      value0                NUMBER,
      value1                NUMBER,
      line_cd               gicl_loss_profile.line_cd%TYPE,
      subline_cd            gicl_loss_profile.subline_cd%TYPE,
      range_from            gicl_loss_profile.range_from%TYPE,
      range_to              gicl_loss_profile.range_to%TYPE,
      grp_count             NUMBER,
      policy_count          NUMBER,
      tsi_amt        	    gipi_polbasic.tsi_amt%TYPE,
      net_retention  	    gicl_loss_profile.net_retention%TYPE,
      quota_share    	    gicl_loss_profile.quota_share%TYPE,
      treatyx               gicl_loss_profile.treaty%TYPE,
      facultative    	    gicl_loss_profile.facultative%TYPE,
      xol		         	gicl_loss_profile.xol_treaty%TYPE,
      chk_ext               NUMBER
   );
   
   TYPE get_profile_extract_tsi_tab IS TABLE OF get_profile_extract_tsi_type;
   
   FUNCTION get_profile_extract_tsi(
      p_line_cd             gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          gicl_loss_profile.subline_cd%TYPE,
      v_loss_sw             VARCHAR2,
      v_loss_fr             DATE,
      v_loss_to             DATE,
      p_user_id             gicl_loss_profile.user_id%TYPE
   ) RETURN get_profile_extract_tsi_tab PIPELINED;
   
   PROCEDURE get_loss_ext_motor(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   );
   
   PROCEDURE get_loss_ext2_motor(
      p_pol_sw              IN VARCHAR2,
      p_date_fr             IN DATE,
      p_date_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   );
   
   PROCEDURE get_loss_ext_fire(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   );
   
   PROCEDURE get_loss_ext2_fire(
      p_pol_sw              IN VARCHAR2,
      p_date_fr             IN DATE,
      p_date_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   );
   
   PROCEDURE get_loss_ext_peril(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   );
   
   PROCEDURE get_loss_ext2_peril(
      p_pol_sw              IN VARCHAR2,
      p_date_fr             IN DATE,
      p_date_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   );
   
   PROCEDURE loss_profile_extract_loss_amt(
      p_user_id             IN giis_users.user_id%TYPE,
      p_param_date          IN VARCHAR2,
      p_claim_date          IN VARCHAR2,
      p_line_cd             IN gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          IN gicl_loss_profile.subline_cd%TYPE,
      p_date_from           IN gicl_loss_profile.date_from%TYPE,
      p_date_to             IN gicl_loss_profile.date_to%TYPE,
      p_loss_date_from      IN gicl_loss_profile.loss_date_from%TYPE,
      p_loss_date_to        IN gicl_loss_profile.loss_date_to%TYPE,
      p_e_type              IN NUMBER,
      p_var_ext             OUT VARCHAR2,
      p_message             OUT VARCHAR2
   );
   
   TYPE get_loss_amt_type IS RECORD (
      value0                NUMBER,
      value1                NUMBER,
      line_cd               gicl_loss_profile.line_cd%TYPE,
      subline_cd            gicl_loss_profile.subline_cd%TYPE,
      range_from            gicl_loss_profile.range_from%TYPE,
      range_to              gicl_loss_profile.range_to%TYPE,
      grp_count             NUMBER,
      claim_count           NUMBER,
      tsi_amt        	    gipi_polbasic.tsi_amt%TYPE,
      net_retention  	    gicl_loss_profile.net_retention%TYPE,
      quota_share    	    gicl_loss_profile.quota_share%TYPE,
      treatyx               gicl_loss_profile.treaty%TYPE,
      facultative    	    gicl_loss_profile.facultative%TYPE,
      xol		         	gicl_loss_profile.xol_treaty%TYPE,
      chk_ext               NUMBER
   );
   
   TYPE get_loss_amt_tab IS TABLE OF get_loss_amt_type;
   
   FUNCTION get_loss_profile_loss_amt(
      p_line_cd             gicl_loss_profile.line_cd%TYPE,
      p_subline_cd          gicl_loss_profile.subline_cd%TYPE,
      v_loss_sw             VARCHAR2,
      v_loss_fr             DATE,
      v_loss_to             DATE,
      p_user_id             gicl_loss_profile.user_id%TYPE
   ) RETURN get_loss_amt_tab PIPELINED;
   
   PROCEDURE get_loss_ext3(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   );
   
   PROCEDURE get_loss_ext3_motor(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   );
   
   PROCEDURE get_loss_ext3_fire(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   );
   
   PROCEDURE get_loss_ext3_peril(
      p_loss_sw             IN VARCHAR2,
      p_loss_fr             IN DATE,
      p_loss_to             IN DATE,
      p_line_cd             IN VARCHAR2,
      p_subline             IN VARCHAR2,
      p_user_id             IN gicl_loss_profile.user_id%TYPE
   );
   
   PROCEDURE validate_range(
      p_line_cd               gicl_loss_profile.line_cd%TYPE,
      p_subline_cd            gicl_loss_profile.subline_cd%TYPE,
      p_range_from            gicl_loss_profile.range_from%TYPE,
      p_range_to              gicl_loss_profile.range_to%TYPE,
      p_old_from              gicl_loss_profile.range_from%TYPE,
      p_old_to                gicl_loss_profile.range_to%TYPE,
      p_user_id               gicl_loss_profile.user_id%TYPE
   );
   
   PROCEDURE delete_loss_profile(
      p_rec                   gicl_loss_profile%ROWTYPE
   );
   
   PROCEDURE delete_loss_profile_range(
      p_rec                   gicl_loss_profile%ROWTYPE
   );
   
   PROCEDURE set_loss_profile(
      p_rec                   gicl_loss_profile%ROWTYPE,
      p_type                  VARCHAR2
   );
   
   PROCEDURE set_line_subline(
      p_rec                   gicl_loss_profile%ROWTYPE
   );
   
   PROCEDURE set_by_line(
      p_rec                   gicl_loss_profile%ROWTYPE
   );
   
   PROCEDURE set_by_line_subline(
      p_rec                   gicl_loss_profile%ROWTYPE
   );
   
   PROCEDURE set_all_lines(
      p_rec                   gicl_loss_profile%ROWTYPE
   );
   
   PROCEDURE set_all_sublines(
      p_rec                   gicl_loss_profile%ROWTYPE
   );
   
   PROCEDURE update_loss_profile(
      p_rec                   gicl_loss_profile%ROWTYPE
   );
   
   PROCEDURE update_loss_profile_range(
      p_rec                   gicl_loss_profile%ROWTYPE,
      p_old_from              gicl_loss_profile.range_from%TYPE,
      p_old_to                gicl_loss_profile.range_to%TYPE
   ); 
   
END GICLS211_PKG;
/


