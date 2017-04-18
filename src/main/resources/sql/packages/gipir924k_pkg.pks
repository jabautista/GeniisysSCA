CREATE OR REPLACE PACKAGE cpi.gipir924k_pkg 
AS
   TYPE get_details_type IS RECORD (
      company_name       giis_parameters.param_value_v%TYPE,
      company_address    giis_parameters.param_value_v%TYPE,
      report_title       giis_reports.report_title%TYPE,
      report_from_to     VARCHAR2 (100),
      policy_id          gipi_uwreports_dist_ext.policy_id%TYPE,
      prem_seq_no        gipi_uwreports_dist_ext.prem_seq_no%TYPE,
      branch_cd          giis_issource.iss_cd%TYPE,
      iss_cd             giis_issource.iss_cd%TYPE,
      iss_name           giis_issource.iss_name%TYPE,
      line_cd            giis_line.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      issue_date         VARCHAR2 (50),
      policy_no          VARCHAR2 (100),
      invoice_no         VARCHAR2 (50),
      policy_term        VARCHAR2 (100),
      assd_tin           VARCHAR2 (100),
      assd_name          giis_assured.assd_name%TYPE,
      prem_amt           gipi_uwreports_dist_ext.prem_amt%TYPE,
      evatprem           gipi_uwreports_polinv_tax_ext.tax_amt%TYPE,
      lgt                gipi_uwreports_polinv_tax_ext.tax_amt%TYPE,
      doc_stamps         gipi_uwreports_polinv_tax_ext.tax_amt%TYPE,
      fst                gipi_uwreports_polinv_tax_ext.tax_amt%TYPE,
      other_taxes        gipi_uwreports_dist_ext.other_charges%TYPE,
      RETENTION          gipi_uwreports_dist_ext.RETENTION%TYPE,
      facultative        gipi_uwreports_dist_ext.facultative%TYPE,
      ri_comm            gipi_uwreports_dist_ext.ri_comm%TYPE,
      ri_comm_vat        gipi_uwreports_dist_ext.ri_comm_vat%TYPE,
      treaty             gipi_uwreports_dist_ext.treaty%TYPE,
      trty_ri_comm       gipi_uwreports_dist_ext.trty_ri_comm%TYPE,
      trty_ri_comm_vat   gipi_uwreports_dist_ext.trty_ri_comm_vat%TYPE,
      intm_name          /*giis_intermediary.intm_name%TYPE*/ VARCHAR2(1000) ,
      commission_amt     NUMBER (12, 2),
      print_tag          VARCHAR2 (1)   
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_report_details (
      p_parameter    VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_scope        NUMBER,
      p_user_id      VARCHAR2,
      p_param_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_tab          VARCHAR2,
      p_reinstated VARCHAR2
   )
      RETURN get_details_tab PIPELINED;

   FUNCTION get_date_format (p_date DATE)
      RETURN VARCHAR2;
END gipir924k_pkg;
/