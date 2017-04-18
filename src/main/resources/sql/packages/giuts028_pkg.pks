CREATE OR REPLACE PACKAGE CPI.giuts028_pkg
AS
   /* Created by Joms Diago
   ** 07.25.2013
   */
   TYPE when_new_form_giuts028_type IS RECORD (
      allow_spoilage   giac_parameters.param_value_v%TYPE,
      v_iss_cd_param   giac_parameters.param_value_v%TYPE,
      v_ho             giis_parameters.param_value_v%TYPE,
      v_restrict       giis_parameters.param_value_v%TYPE,
      v_subline        giis_parameters.param_value_v%TYPE,
      v_renew          giis_parameters.param_value_v%TYPE 
   );

   TYPE when_new_form_giuts028_tab IS TABLE OF when_new_form_giuts028_type;

   FUNCTION when_new_form_giuts028
      RETURN when_new_form_giuts028_tab PIPELINED;

   TYPE get_policy_giuts028_lov_type IS RECORD (
      policy_id        gipi_polbasic.policy_id%TYPE,
      policy_no        VARCHAR2 (100),
      assd_name        giis_assured.assd_name%TYPE,
      line_cd          gipi_polbasic.line_cd%TYPE,
      subline_cd       gipi_polbasic.subline_cd%TYPE,
      iss_cd           gipi_polbasic.iss_cd%TYPE,
      issue_yy         gipi_polbasic.issue_yy%TYPE,
      pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      renew_no         gipi_polbasic.renew_no%TYPE,
      pack_policy_id   gipi_polbasic.pack_policy_id%TYPE,
      is_cancelled     VARCHAR2 (1),
      pack_policy_no   VARCHAR2 (100),
      pol_flag         gipi_polbasic.pol_flag%TYPE,
      old_pol_flag     gipi_polbasic.old_pol_flag%TYPE,
       --Added by pjsantos 10/27/2016, for optimization GENQA 5807
      count_           NUMBER,                         
      rownum_          NUMBER 
      --pjsantos end
   );

   TYPE get_policy_giuts028_lov_tab IS TABLE OF get_policy_giuts028_lov_type;

   FUNCTION get_policy_giuts028_lov (p_user_id giis_users.user_id%TYPE,
   --added by pjsantos 10/27/2016, for optimization GENQA 5807 
   p_filter_line_cd     VARCHAR2,
   p_filter_subline_cd  VARCHAR2,
   p_filter_iss_cd      VARCHAR2,
   p_filter_issue_yy    NUMBER,
   p_filter_pol_seq_no  NUMBER,
   p_filter_renew_no    NUMBER,
   p_find_text          VARCHAR2,
   p_order_by           VARCHAR2,      
   p_asc_desc_flag      VARCHAR2,      
   p_first_row          NUMBER,        
   p_last_row           NUMBER)
   --pjsantos end
      RETURN get_policy_giuts028_lov_tab PIPELINED;

   TYPE reinstatement_hist_type IS RECORD (
      hist_id           gipi_reinstate_hist.hist_id%TYPE,
      max_endt_seq_no   gipi_reinstate_hist.max_endt_seq_no%TYPE,
      user_id           gipi_reinstate_hist.user_id%TYPE,
      last_update       gipi_reinstate_hist.last_update%TYPE
   );

   TYPE reinstatement_hist_tab IS TABLE OF reinstatement_hist_type;

   FUNCTION get_reinstatement_hist (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN reinstatement_hist_tab PIPELINED;

   TYPE validate_endt_rec_type IS RECORD (
      v_cancel_policy   gipi_polbasic.policy_id%TYPE,
      v_acct_ent_date   VARCHAR2(15),--gipi_polbasic.acct_ent_date%TYPE,
      v_spld_flag       gipi_polbasic.spld_flag%TYPE,
      v_max_endt        gipi_polbasic.endt_seq_no%TYPE,
      v_sw              giis_issource.ho_tag%TYPE
   );

   TYPE validate_endt_rec_tab IS TABLE OF validate_endt_rec_type;

   FUNCTION validate_giuts028_endt_rec (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_iss_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_policy_id    gipi_polbasic.policy_id%TYPE
   )
      RETURN validate_endt_rec_tab PIPELINED;

   PROCEDURE check_paid_policy (
      p_policy_id   IN       gipi_polbasic.policy_id%TYPE,
      p_iss_cd      IN       gipi_polbasic.iss_cd%TYPE,
      p_msge1       OUT      VARCHAR2,
      p_msge2       OUT      VARCHAR2,
      p_msge3       OUT      VARCHAR2
   );

   PROCEDURE check_reinsurance_payment (
      p_policy_id   IN       gipi_polbasic.policy_id%TYPE,
      p_line_cd     IN       gipi_polbasic.line_cd%TYPE,
      p_msge1       OUT      VARCHAR2,
      p_msge2       OUT      VARCHAR2,
      p_msge3       OUT      VARCHAR2
   );

   PROCEDURE check_acct_ent_date (
      p_acct_ent_date         gipi_polbasic.acct_ent_date%TYPE,
      p_restrict              giis_parameters.param_value_v%TYPE,
      p_msge1           OUT   VARCHAR2,
      p_msge2           OUT   VARCHAR2,
      p_msge3           OUT   VARCHAR2
   );

   TYPE chk_marine_rec_type IS RECORD (
      v_exist     VARCHAR2 (1),
      v_subline   giis_subline.subline_cd%TYPE
   );

   TYPE chk_marine_rec_tab IS TABLE OF chk_marine_rec_type;

   FUNCTION chk_marine (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_iss_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN chk_marine_rec_tab PIPELINED;

   TYPE chk_ongoing_endt_type IS RECORD (
      v_exist   VARCHAR2 (1)
   );

   TYPE chk_ongoing_endt_tab IS TABLE OF chk_ongoing_endt_type;

   FUNCTION chk_on_going_endt (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_iss_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN chk_ongoing_endt_tab PIPELINED;

   PROCEDURE process_reinstate (
      p_user_id           IN   giis_users.user_id%TYPE,
      p_v_cancel_policy   IN   gipi_polbasic.policy_id%TYPE,
      p_old_pol_flag      IN   gipi_polbasic.old_pol_flag%TYPE,
      p_line_cd           IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd        IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd            IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          IN   gipi_polbasic.renew_no%TYPE,
      p_v_max_endt        IN   gipi_polbasic.endt_seq_no%TYPE,
      p_policy_id         IN   gipi_polbasic.policy_id%TYPE
   );

   PROCEDURE update_affected_endt (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   );

   PROCEDURE create_history (
      p_policy_id    IN   gipi_polbasic.policy_id%TYPE,
      p_v_max_endt   IN   gipi_polbasic.endt_seq_no%TYPE,
      p_user_id      IN   giis_users.user_id%TYPE
   );
   
   /* benjo 09.03.2015 UW-SPECS-2015-080 */
   TYPE chk_orig_renew_status_type IS RECORD (
      invalid_orig      VARCHAR2 (1),
      valid_renew       VARCHAR2 (1),
      cancel_renew      VARCHAR2 (1)
   );

   TYPE chk_orig_renew_status_tab IS TABLE OF chk_orig_renew_status_type;

   FUNCTION chk_orig_renew_status (
      p_policy_id    gipi_polbasic.policy_id%TYPE
   )
      RETURN chk_orig_renew_status_tab PIPELINED;
   /* benjo end */
END;
/


