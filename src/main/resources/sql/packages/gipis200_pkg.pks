CREATE OR REPLACE PACKAGE CPI.gipis200_pkg
AS
   TYPE get_line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE get_line_lov_tab IS TABLE OF get_line_lov_type;

   TYPE get_subline_lov_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE get_subline_lov_tab IS TABLE OF get_subline_lov_type;

   TYPE get_issue_lov_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE get_issue_lov_tab IS TABLE OF get_issue_lov_type;

   TYPE get_issue_year_lov_type IS RECORD (
      issue_yy   VARCHAR2 (4)
   );

   TYPE get_issue_year_lov_tab IS TABLE OF get_issue_year_lov_type;

   TYPE get_intermediary_lov_type IS RECORD (
      intm_no     giis_intermediary.intm_no%TYPE,
      intm_name   giis_intermediary.intm_name%TYPE
   );

   TYPE get_intermediary_lov_tab IS TABLE OF get_intermediary_lov_type;

   TYPE prod_param_type IS RECORD (
      line_cd         gipi_prod_param.line_cd%TYPE,
      subline_cd      gipi_prod_param.subline_cd%TYPE,
      iss_cd          gipi_prod_param.iss_cd%TYPE,
      issue_yy        gipi_prod_param.issue_yy%TYPE,
      intm_no         gipi_prod_param.intm_no%TYPE,
      cred_iss        gipi_prod_param.cred_iss%TYPE,
      param_date      gipi_prod_param.param_date%TYPE,
      from_date       gipi_prod_param.from_date%TYPE,
      TO_DATE         gipi_prod_param.TO_DATE%TYPE,
      MONTH           gipi_prod_param.MONTH%TYPE,
      YEAR            gipi_prod_param.YEAR%TYPE,
      dist_flag       gipi_prod_param.dist_flag%TYPE,
      reg_policy_sw   gipi_prod_param.reg_policy_sw%TYPE,
      user_id         gipi_prod_param.user_id%TYPE,
      last_extract    gipi_prod_param.last_extract%TYPE,
      line_name       giis_line.line_name%TYPE,
      subline_name    giis_subline.subline_name%TYPE,
      iss_name        giis_issource.iss_name%TYPE,
      intm_name       giis_intermediary.intm_name%TYPE
   );

   TYPE prod_param_tab IS TABLE OF prod_param_type;

   FUNCTION get_line_lov (p_iss_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN get_line_lov_tab PIPELINED;

   FUNCTION get_subline_lov (p_line_cd VARCHAR2)
      RETURN get_subline_lov_tab PIPELINED;

   FUNCTION get_issue_lov (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN get_issue_lov_tab PIPELINED;

   FUNCTION get_issue_year_lov
      RETURN get_issue_year_lov_tab PIPELINED;

   FUNCTION get_intermediary_lov (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN get_intermediary_lov_tab PIPELINED;

   PROCEDURE check_view_prod_dtls (
      p_user_id   IN       gicl_res_brdrx_extr.user_id%TYPE,
      p_message   OUT      VARCHAR2
   );

   PROCEDURE extract_production (
      p_line_cd            IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd         IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd             IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy           IN       gipi_polbasic.issue_yy%TYPE,
      p_intm_no            IN       giis_intermediary.intm_no%TYPE,
      p_cred_iss           IN       VARCHAR2,
      p_param_date         IN       NUMBER,
      p_from_date          IN       DATE,
      p_to_date            IN       DATE,
      p_month              IN       gipi_polbasic.booking_mth%TYPE,
      p_year               IN       gipi_polbasic.booking_year%TYPE,
      p_dist_flag          IN       VARCHAR2,
      p_reg_policy_sw      IN       VARCHAR2,
      p_user               IN       VARCHAR2,
      p_message            OUT      VARCHAR2,
      p_no_of_policies     OUT      NUMBER,
      p_total_tsi          OUT      NUMBER,
      p_total_prem         OUT      NUMBER,
      p_total_tax          OUT      NUMBER,
      p_total_commission   OUT      NUMBER
   );

   PROCEDURE extract_pol_from_prod (
      p_line_cd         IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd      IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd          IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        IN   gipi_polbasic.issue_yy%TYPE,
      p_intm_no         IN   giis_intermediary.intm_no%TYPE,
      p_cred_iss        IN   VARCHAR2,
      p_param_date      IN   NUMBER,
      p_from_date       IN   DATE,
      p_to_date         IN   DATE,
      p_month           IN   gipi_polbasic.booking_mth%TYPE,
      p_year            IN   gipi_polbasic.booking_year%TYPE,
      p_dist_flag       IN   VARCHAR2,
      p_reg_policy_sw   IN   VARCHAR2,
      p_user            IN   VARCHAR2
   );

   FUNCTION check_date_prod_policy (
      p_param_date      NUMBER,
      p_from_date       DATE,
      p_to_date         DATE,
      p_month           gipi_polbasic.booking_mth%TYPE,
      p_year            gipi_polbasic.booking_year%TYPE,
      p_issue_date      DATE,
      p_eff_date        DATE,
      p_acct_ent_date   DATE,
      p_spld_acct       DATE,
      p_booking_mth     gipi_polbasic.booking_mth%TYPE,
      p_booking_year    gipi_polbasic.booking_year%TYPE
   )
      RETURN NUMBER;

   PROCEDURE pol_taxes2 (
      p_item_grp             gipi_invoice.item_grp%TYPE,
      p_takeup_seq_no        gipi_invoice.takeup_seq_no%TYPE,
      p_policy_id            gipi_invoice.policy_id%TYPE,
      p_param_date      IN   NUMBER,
      p_from_date       IN   DATE,
      p_to_date         IN   DATE,
      p_user            IN   VARCHAR2,
      p_month                gipi_polbasic.booking_mth%TYPE,
      p_year                 gipi_polbasic.booking_year%TYPE
   );

   FUNCTION get_comm_amt (
      p_prem_seq_no   NUMBER,
      p_iss_cd        VARCHAR2,
      p_param_date    NUMBER,
      p_from_date     DATE,
      p_to_date       DATE,
      p_policy_id     NUMBER,
      p_month         gipi_polbasic.booking_mth%TYPE,
      p_year          gipi_polbasic.booking_year%TYPE
   )
      RETURN NUMBER;
      
--   added by gab 10.26.2016   
   PROCEDURE pol_taxes3 (
      p_item_grp             gipi_invoice.item_grp%TYPE,
      p_takeup_seq_no        gipi_invoice.takeup_seq_no%TYPE,
      p_policy_id            gipi_invoice.policy_id%TYPE,
      p_param_date      IN   NUMBER,
      p_from_date       IN   DATE,
      p_to_date         IN   DATE,
      p_user            IN   VARCHAR2,
      p_month                gipi_polbasic.booking_mth%TYPE,
      p_year                 gipi_polbasic.booking_year%TYPE,
      p_evat                 giac_parameters.param_value_v%TYPE,
      p_prem_tax             giac_parameters.param_value_v%TYPE,
      p_fst                  giac_parameters.param_value_v%TYPE,
      p_lgt                  giac_parameters.param_value_v%TYPE,
      p_doc_stamps            giac_parameters.param_value_v%TYPE,
      p_layout               NUMBER
   );
END;
/


