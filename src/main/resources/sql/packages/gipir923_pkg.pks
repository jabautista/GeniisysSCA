CREATE OR REPLACE PACKAGE CPI.gipir923_pkg 
AS
   TYPE main_type IS RECORD (
      show_total_taxes               VARCHAR2 (1),
      display_wholding_tax           VARCHAR2 (1),
      display_separate_premtax_vat   VARCHAR2 (1),
      print_special_risk             VARCHAR2 (1),
      company_name                   giis_parameters.param_value_v%TYPE,
      company_address                giis_parameters.param_value_v%TYPE,
      company_tin							 giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5962
      gen_version							 giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5962
      date_heading                   VARCHAR2 (200),
      based_on_heading               VARCHAR2 (200)
   );

   TYPE main_tab IS TABLE OF main_type;

   FUNCTION get_main (
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_user_id      VARCHAR2,
      p_tab          VARCHAR2,
      p_reinstated   VARCHAR2
   )
      RETURN main_tab PIPELINED;

   TYPE detail_type IS RECORD (
      line_cd              giis_line.line_cd%TYPE,
      line_name            giis_line.line_name%TYPE,
      subline_cd           giis_subline.subline_cd%TYPE,
      subline_name         giis_subline.subline_name%TYPE,
      iss_cd               giis_issource.iss_cd%TYPE,
      iss_name             giis_issource.iss_name%TYPE,      
      policy_status        VARCHAR2 (100),
      policy_id            gipi_polbasic.policy_id%TYPE,
      policy_no            VARCHAR2 (100),
      is_unique            VARCHAR2 (1),
      issue_yy             gipi_polbasic.issue_yy%TYPE,
      pol_seq_no           gipi_polbasic.pol_seq_no%TYPE,
      renew_no             gipi_polbasic.renew_no%TYPE,
      endt_seq_no          gipi_polbasic.endt_seq_no%TYPE,
      assd_no              giis_assured.assd_no%TYPE,
      assd_name            giis_assured.assd_name%TYPE,
      prem_seq_no          NUMBER,
      invoice_no           VARCHAR2 (100),
      issue_date           VARCHAR2 (100),
      incept_date          VARCHAR2 (100),
      expiry_date          VARCHAR2 (100),
      booking_date         VARCHAR2 (100),
      acct_ent_date        VARCHAR2 (100),
      spld_date            VARCHAR2 (100),
      spld_acct_ent_date   VARCHAR2 (100),
      reg_policy_sw        gipi_polbasic.reg_policy_sw%TYPE,
      total_tsi            NUMBER,
      total_prem           NUMBER,
      vat                  NUMBER,
      prem_tax             NUMBER,
      vat_prem_tax         NUMBER,
      lgt                  NUMBER,
      doc_stamps           NUMBER,
      fst                  NUMBER,
      other_charges        NUMBER,
      other_taxes          NUMBER,
      total_taxes          NUMBER,
      total_amount_due     NUMBER,
      comm_amt             NUMBER,
      wholding_tax         NUMBER,
      param_date           NUMBER,
      pol_count            NUMBER,
      spld_label           VARCHAR2 (1),
      iss_cd2              giis_issource.iss_cd%TYPE, --to be used in csv
      user_id              giis_users.user_id%TYPE, --to be used in csv
      rec_type             gipi_uwreports_ext.rec_type%TYPE --to be used in csv
   );

   TYPE detail_tab IS TABLE OF detail_type;

   FUNCTION get_details (
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_user_id      VARCHAR2,
      p_tab          VARCHAR2,
      p_reinstated   VARCHAR2
   )
      RETURN detail_tab PIPELINED;

   TYPE risk_totals_type IS RECORD (
      s_total_si              NUMBER,
      ns_total_si             NUMBER,
      s_total_prem            NUMBER,
      ns_total_prem           NUMBER,
      s_total_comm            NUMBER,
      ns_total_comm           NUMBER,
      s_total_wholding_tax    NUMBER,
      ns_total_wholding_tax   NUMBER
   );

   TYPE risk_totals_tab IS TABLE OF risk_totals_type;

   FUNCTION get_risk_totals (
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_user_id      VARCHAR2,
      p_tab          VARCHAR2,
      p_reinstated   VARCHAR2
   )
      RETURN risk_totals_tab PIPELINED;

   TYPE recaps_type IS RECORD (
      policy_status   VARCHAR2 (20),
      pol_count       NUMBER,
      total_prem      NUMBER,
      total_comm      NUMBER,
      pos             NUMBER
   );

   TYPE recaps_tab IS TABLE OF recaps_type;

   FUNCTION get_recaps (
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_scope        VARCHAR2,
      p_iss_param    VARCHAR2,
      p_user_id      VARCHAR2,
      p_tab          VARCHAR2,
      p_reinstated   VARCHAR2
   )
      RETURN recaps_tab PIPELINED;

   FUNCTION get_date_heading (p_user_id VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_based_on_heading (
      p_user_id      VARCHAR2,
      p_scope        VARCHAR2,
      p_reinstated   VARCHAR2
   )
      RETURN VARCHAR2;
   FUNCTION check_unique_policy(pol_id_i gipi_uwreports_ext.policy_id%TYPE,pol_id_j gipi_uwreports_ext.policy_id%TYPE) 
        RETURN CHAR;
END;
/
