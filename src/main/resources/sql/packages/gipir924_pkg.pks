CREATE OR REPLACE PACKAGE cpi.gipir924_pkg 
AS
   TYPE gipir924_type IS RECORD (
      iss_cd                         giis_issource.iss_cd%TYPE,
      iss_name                       giis_issource.iss_name%TYPE,
      line_cd                        giis_line.line_cd%TYPE,
      subline_name                   giis_subline.subline_name%TYPE,
      total_tsi                      NUMBER,
      total_prem                     NUMBER,
      vat                            NUMBER,
      prem_tax                       NUMBER,
      vat_prem_tax                   NUMBER,
      lgt                            NUMBER,
      doc_stamps                     NUMBER,
      fst                            NUMBER,
      other_charges                  NUMBER,
      other_taxes                    NUMBER,
      total_taxes                    NUMBER,
      total_amount_due               NUMBER,
      comm_amt                       NUMBER,
      wholding_tax                   NUMBER,
      param_date                     NUMBER,
      show_total_taxes               VARCHAR2 (1),
      display_wholding_tax           VARCHAR2 (1),
      display_separate_premtax_vat   VARCHAR2 (1),
      print_special_risk             VARCHAR2 (1),
      pol_count                      NUMBER,
      company_name                   giis_parameters.param_value_v%TYPE,
      company_address                giis_parameters.param_value_v%TYPE,
      date_heading                   VARCHAR2 (200),
      based_on_heading               VARCHAR2 (200)
   );

   TYPE gipir924_tab IS TABLE OF gipir924_type;

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
      RETURN gipir924_tab PIPELINED;

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

   FUNCTION get_date_heading (p_user_id VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_based_on_heading (
      p_user_id      VARCHAR2,
      p_scope        VARCHAR2,
      p_reinstated   VARCHAR2
   )
      RETURN VARCHAR2;
END gipir924_pkg;
/