CREATE OR REPLACE PACKAGE CPI.giuts028a_pkg
AS
   TYPE when_new_form_giuts028a_type IS RECORD (
      allow_spoilage   giac_parameters.param_value_v%TYPE,
      v_iss_cd_param   giac_parameters.param_value_v%TYPE,
      v_ho             giis_parameters.param_value_v%TYPE,
      v_restrict       giis_parameters.param_value_v%TYPE,
      v_subline        giis_parameters.param_value_v%TYPE,
      v_renew          giis_parameters.param_value_v%TYPE
   );

   TYPE when_new_form_giuts028a_tab IS TABLE OF when_new_form_giuts028a_type;

   FUNCTION when_new_form_giuts028a
      RETURN when_new_form_giuts028a_tab PIPELINED;

   TYPE get_policy_giuts028a_lov_type IS RECORD (
      pack_policy_id   gipi_pack_polbasic.pack_policy_id%TYPE,
      pack_policy_no   VARCHAR2 (100),
      assd_name        giis_assured.assd_name%TYPE,
      line_cd          gipi_pack_polbasic.line_cd%TYPE,
      subline_cd       gipi_pack_polbasic.subline_cd%TYPE,
      iss_cd           gipi_pack_polbasic.iss_cd%TYPE,
      issue_yy         gipi_pack_polbasic.issue_yy%TYPE,
      pol_seq_no       gipi_pack_polbasic.pol_seq_no%TYPE,
      renew_no         gipi_pack_polbasic.renew_no%TYPE,
      v_subcancel      gipi_polbasic.pol_flag%TYPE,
      pack_pol_flag    gipi_pack_polbasic.pol_flag%TYPE,
      v_hist           VARCHAR2 (1)
   );

   TYPE get_policy_giuts028a_lov_tab IS TABLE OF get_policy_giuts028a_lov_type;

   FUNCTION get_policy_giuts028a_lov (p_user_id giis_users.user_id%TYPE)
      RETURN get_policy_giuts028a_lov_tab PIPELINED;

   TYPE reinstatement_hist_type IS RECORD (
      hist_id           gipi_reinstate_hist.hist_id%TYPE,
      max_endt_seq_no   gipi_reinstate_hist.max_endt_seq_no%TYPE,
      user_id           gipi_reinstate_hist.user_id%TYPE,
      last_update       gipi_reinstate_hist.last_update%TYPE
   );

   TYPE reinstatement_hist_tab IS TABLE OF reinstatement_hist_type;

   FUNCTION get_reinstatement_hist (
      p_pack_policy_id   gipi_pack_polbasic.pack_policy_id%TYPE
   )
      RETURN reinstatement_hist_tab PIPELINED;

   PROCEDURE process_reinstate (
      p_user_id          IN       giis_users.user_id%TYPE,
      p_line_cd          IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd       IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd           IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy         IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no       IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no         IN       gipi_polbasic.renew_no%TYPE,
      p_pack_policy_id   IN       gipi_pack_polbasic.pack_policy_id%TYPE,
      p_subpol_check     OUT      VARCHAR2
   );

   PROCEDURE check_package_cancellation (
      p_cancel_all       OUT      VARCHAR2,
      p_pack_policy_id   IN       gipi_pack_polbasic.pack_policy_id%TYPE
   );

   PROCEDURE check_mrn (
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_iss_cd       IN   VARCHAR2,
      p_issue_yy     IN   VARCHAR2,
      p_pol_seq_no   IN   VARCHAR2,
      p_renew_no     IN   VARCHAR2
   );

   PROCEDURE post_reinstate (
      p_user_id          IN   giis_users.user_id%TYPE,
      p_line_cd          IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd       IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd           IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy         IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no       IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no         IN   gipi_polbasic.renew_no%TYPE,
      p_pack_policy_id   IN   gipi_pack_polbasic.pack_policy_id%TYPE
   );

   PROCEDURE reinstate (
      p_reinstate       OUT      VARCHAR2,
      p_cancel_policy   IN       gipi_polbasic.policy_id%TYPE,
      p_line_cd         IN       gipi_polbasic.line_cd%TYPE,
      p_old_pol_flag    IN       gipi_polbasic.old_pol_flag%TYPE,
      p_subline_cd      IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd          IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        IN       gipi_polbasic.renew_no%TYPE,
      p_user_id         IN       giis_users.user_id%TYPE
   );

   PROCEDURE update_affected_endt (
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_iss_cd       IN   VARCHAR2,
      p_issue_yy     IN   VARCHAR2,
      p_pol_seq_no   IN   VARCHAR2,
      p_renew_no     IN   VARCHAR2,
      p_user_id      IN   giis_users.user_id%TYPE
   );

   PROCEDURE reinstate_package (
      p_pack_policy_id        IN   gipi_pack_polbasic.pack_policy_id%TYPE,
      p_old_pol_flag          IN   gipi_polbasic.old_pol_flag%TYPE,
      p_line_cd               IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd            IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd                IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy              IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no            IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no              IN   gipi_polbasic.renew_no%TYPE,
      p_max_endt_no           IN   gipi_polbasic.endt_seq_no%TYPE,
      p_user_id               IN   giis_users.user_id%TYPE,
      p_b250_pack_policy_id   IN   gipi_pack_polbasic.pack_policy_id%TYPE
   );

   PROCEDURE create_history (
      p_endt_seq_no      IN   NUMBER,
      p_pack_policy_id   IN   gipi_pack_polbasic.pack_policy_id%TYPE,
      p_user_id          IN   giis_users.user_id%TYPE
   );
   
   /* benjo 09.03.2015 UW-SPECS-2015-080 */
   TYPE chk_orig_renew_status_type IS RECORD (
      invalid_orig      VARCHAR2 (1),
      valid_renew       VARCHAR2 (1),
      cancel_renew      VARCHAR2 (1)
   );

   TYPE chk_orig_renew_status_tab IS TABLE OF chk_orig_renew_status_type;

   FUNCTION chk_orig_renew_status (
      p_pack_policy_id    gipi_pack_polbasic.pack_policy_id%TYPE
   )
      RETURN chk_orig_renew_status_tab PIPELINED;
   /* benjo end */
END;
/


