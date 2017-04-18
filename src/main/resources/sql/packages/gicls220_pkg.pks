CREATE OR REPLACE PACKAGE CPI.gicls220_pkg
AS
   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   FUNCTION get_gicls220_line_lov (
      p_module_id   VARCHAR2,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_lov_tab PIPELINED;

   TYPE subline_lov_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE subline_lov_tab IS TABLE OF subline_lov_type;

   FUNCTION get_gicls220_subline_lov (p_line_cd giis_line.line_cd%TYPE)
      RETURN subline_lov_tab PIPELINED;

   TYPE branch_lov_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE branch_lov_tab IS TABLE OF branch_lov_type;

   FUNCTION get_gicls220_branch_lov (
      p_module_id   VARCHAR2,
      p_line_cd     giis_line.line_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN branch_lov_tab PIPELINED;

   TYPE intm_lov_type IS RECORD (
      intm_no     giis_intermediary.intm_no%TYPE,
      intm_name   giis_intermediary.intm_name%TYPE
   );

   TYPE intm_lov_tab IS TABLE OF intm_lov_type;

   FUNCTION get_gicls220_intm_lov
      RETURN intm_lov_tab PIPELINED;

   TYPE assd_lov_type IS RECORD (
      assd_no     giis_assured.assd_no%TYPE,
      assd_name   giis_assured.assd_name%TYPE
   );

   TYPE assd_lov_tab IS TABLE OF assd_lov_type;

   FUNCTION get_gicls220_assd_lov
      RETURN assd_lov_tab PIPELINED;

   TYPE when_new_form_gicls220_type IS RECORD (
      ri_iss_cd   giac_parameters.param_value_v%TYPE
   );

   TYPE when_new_form_gicls220_tab IS TABLE OF when_new_form_gicls220_type;

   FUNCTION when_new_form_gicls220
      RETURN when_new_form_gicls220_tab PIPELINED;

   PROCEDURE extract_gicls220 (
      p_user_id           IN       giis_users.user_id%TYPE,
      p_exists            OUT      NUMBER,
      p_intm_no           IN       giis_intermediary.intm_no%TYPE,
      p_claim_amt_o       IN       VARCHAR2,
      p_claim_amt_r       IN       VARCHAR2,
      p_claim_amt_s       IN       VARCHAR2,
      p_loss_expense      IN       VARCHAR2,
      p_line_cd           IN       giis_line.line_cd%TYPE,
      p_subline_cd        IN       giis_subline.subline_cd%TYPE,
      p_branch_cd         IN       giac_branches.branch_cd%TYPE,
      p_branch_param      IN       VARCHAR2,
      p_ri_iss_cd         IN       VARCHAR2,
      p_assd_cedant_no    IN       VARCHAR2,
      p_claim_status_op   IN       VARCHAR2,
      p_claim_status_cl   IN       VARCHAR2,
      p_claim_status_cc   IN       VARCHAR2,
      p_claim_status_de   IN       VARCHAR2,
      p_claim_status_wd   IN       VARCHAR2,
      p_claim_date        IN       VARCHAR2,
      p_as_of_date        IN       DATE,
      p_from_date         IN       DATE,
      p_to_date           IN       DATE,
      p_extract_type      IN       VARCHAR2,
      p_biggest_claims    IN       NUMBER,
      p_loss_amt          IN       gicl_clm_summary.loss_amt%TYPE,
      p_session_id        OUT      NUMBER
   );

   PROCEDURE get_dynamic (
      p_column         OUT      VARCHAR2,
      p_col_ins        OUT      VARCHAR2,
      p_col_frm        OUT      VARCHAR2,
      p_grp_out        OUT      VARCHAR2,
      p_intm_no        IN       giis_intermediary.intm_no%TYPE,
      p_claim_amt_o    IN       VARCHAR2,
      p_claim_amt_r    IN       VARCHAR2,
      p_claim_amt_s    IN       VARCHAR2,
      p_loss_expense   IN       VARCHAR2
   );

   PROCEDURE get_dynamic_where (
      p_where            IN OUT   VARCHAR2,
      p_col_ins          IN OUT   VARCHAR2,
      p_line_cd          IN       giis_line.line_cd%TYPE,
      p_subline_cd       IN       giis_subline.subline_cd%TYPE,
      p_branch_cd        IN       giac_branches.branch_cd%TYPE,
      p_branch_param     IN       VARCHAR2,
      p_ri_iss_cd        IN       VARCHAR2,
      p_assd_cedant_no   IN       VARCHAR2
   );

   PROCEDURE get_dynamic_clm_stat (
      p_where             IN OUT   VARCHAR2,
      p_claim_status_op   IN       VARCHAR2,
      p_claim_status_cl   IN       VARCHAR2,
      p_claim_status_cc   IN       VARCHAR2,
      p_claim_status_de   IN       VARCHAR2,
      p_claim_status_wd   IN       VARCHAR2
   );

   PROCEDURE get_dynamic_table (
      p_where          IN OUT   VARCHAR2,
      p_table          IN OUT   VARCHAR2,
      p_chk            IN OUT   VARCHAR2,
      p_claim_date     IN       VARCHAR2,
      p_as_of_date     IN       DATE,
      p_from_date      IN       DATE,
      p_to_date        IN       DATE,
      p_claim_amt_o    IN       VARCHAR2,
      p_claim_amt_r    IN       VARCHAR2,
      p_claim_amt_s    IN       VARCHAR2,
      p_loss_expense   IN       VARCHAR2
   );

   FUNCTION validate_date_params (
      p_user_id          VARCHAR2,
      p_extract_type     VARCHAR2,
      p_loss_amt         gicl_clm_summary.ploss_amt%TYPE,
      p_biggest_claims   gicl_clm_summary.pbiggest_claims%TYPE,
      p_f_date           VARCHAR2,
      p_t_date           VARCHAR2,
      p_as_of_date       VARCHAR2
   )
      RETURN VARCHAR2;
END;
/


