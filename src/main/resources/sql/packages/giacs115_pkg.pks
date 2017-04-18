CREATE OR REPLACE PACKAGE CPI.GIACS115_PKG
AS
   /* Created by : Bonok
   * Date Created : 9.30.2013
   * Reference By : GIACS115 - BIR RELIEF FORMS
   *
   */ 
   TYPE giacs115_type IS RECORD (
      report_id            giis_reports.report_id%TYPE,
      report_title         giis_reports.report_title%TYPE
   );
      
   TYPE giacs115_tab IS TABLE OF giacs115_type;
   
   FUNCTION get_giacs115_list(
      p_rep_type           VARCHAR2,
      p_alp_type           VARCHAR2,
      p_bir_freq_tag_query giac_map_expanded_ext.period_tag%TYPE
   ) RETURN giacs115_tab PIPELINED;
   
   FUNCTION check_extract(
      p_rep_type           VARCHAR2,
      p_alp_type           VARCHAR2,
      p_report_id          giis_reports.report_id%TYPE,
      p_bir_freq_tag_query giac_map_expanded_ext.period_tag%TYPE,
      p_month              giac_map_expanded_ext.return_month%TYPE,
      p_myear              giac_map_expanded_ext.return_year%TYPE,
      p_yyear              giac_map_expanded_ext.return_year%TYPE,
      p_user_id            giac_map_expanded_ext.user_id%TYPE
   ) RETURN VARCHAR2;
   
   PROCEDURE extract_giacs115(
      p_report_id          IN  giis_reports.report_id%TYPE,
      p_rep_type           IN  VARCHAR2,
      p_alp_type           IN  VARCHAR2,
      p_bir_freq_tag_query IN  giac_map_expanded_ext.period_tag%TYPE,
      p_month              IN  giac_map_expanded_ext.return_month%TYPE,
      p_myear              IN  giac_map_expanded_ext.return_year%TYPE,
      p_yyear              IN  giac_map_expanded_ext.return_year%TYPE,
      p_user_id            IN  giac_sawt_ext.user_id%TYPE,
      p_count              OUT NUMBER
   );
   
   PROCEDURE continue_extract(
      p_report_id          IN  giis_reports.report_id%TYPE,
      p_bir_freq_tag_query IN  giac_map_expanded_ext.period_tag%TYPE,
      p_month              IN  giac_map_expanded_ext.return_month%TYPE,
      p_myear              IN  giac_map_expanded_ext.return_year%TYPE,
      p_yyear              IN  giac_map_expanded_ext.return_year%TYPE,
      p_user_id            IN  giac_sawt_ext.user_id%TYPE,
      p_count              OUT NUMBER
   );
   
   PROCEDURE map_expanded (
      p_return_month       giac_map_expanded_ext.return_month%TYPE,
      p_return_myear       giac_map_expanded_ext.return_year%TYPE,
      p_return_yyear       giac_map_expanded_ext.return_year%TYPE,
      p_period_tag         giac_map_expanded_ext.period_tag%TYPE,
      p_user_id            giac_map_expanded_ext.user_id%TYPE
   );
   
   PROCEDURE sawt_expanded (
      p_return_month       giac_sawt_ext.return_month%TYPE,
      p_return_myear       giac_sawt_ext.return_year%TYPE,
      p_return_yyear       giac_sawt_ext.return_year%TYPE,
      p_period_tag         giac_sawt_ext.period_tag%TYPE,
      p_user_id            giac_sawt_ext.user_id%TYPE
   );
   
   TYPE giacs115_csv_type IS RECORD (
      payee_name           VARCHAR2(800),
      tin                  giac_map_expanded_ext.tin%TYPE,
      atc_code             giac_map_expanded_ext.atc_code%TYPE,
      tax_rate             giac_map_expanded_ext.tax_rate%TYPE,
      tax_base             giac_map_expanded_ext.tax_base%TYPE,
      wholding_tax_amt     giac_map_expanded_ext.wholding_tax_amt%TYPE
   );
      
   TYPE giacs115_csv_tab IS TABLE OF giacs115_csv_type;
   
   FUNCTION get_giacs115_csv_list(
      p_report_id          giis_reports.report_id%TYPE,
      p_month              giac_map_expanded_ext.return_month%TYPE,
      p_myear              giac_map_expanded_ext.return_year%TYPE,
      p_yyear              giac_map_expanded_ext.return_year%TYPE,
      p_user_id            giac_sawt_ext.user_id%TYPE
   ) RETURN giacs115_csv_tab PIPELINED;
   
   TYPE giacs115_sawt_csv_type IS RECORD (
      payee_name           VARCHAR2(800),
      tin                  giac_map_expanded_ext.tin%TYPE,
      atc_code             giac_map_expanded_ext.atc_code%TYPE,
      tax_rate             giac_map_expanded_ext.tax_rate%TYPE,
      base_amount          giac_sawt_ext.base_amount%TYPE,
      creditable_amt       giac_sawt_ext.creditable_amt%TYPE
   );
      
   TYPE giacs115_sawt_csv_tab IS TABLE OF giacs115_sawt_csv_type;
   
   FUNCTION get_giacs115_sawt_csv_list(
      p_report_id          giis_reports.report_id%TYPE,
      p_month              giac_map_expanded_ext.return_month%TYPE,
      p_myear              giac_map_expanded_ext.return_year%TYPE,
      p_user_id            giac_sawt_ext.user_id%TYPE
   ) RETURN giacs115_sawt_csv_tab PIPELINED;
   
   TYPE giacs115_dat_type IS RECORD(
      dat_rows             VARCHAR2(5000)
   );
   
   TYPE giacs115_dat_tab IS TABLE OF giacs115_dat_type;
   
   FUNCTION get_giacs115_dat_map_list(
      p_report_id          giis_reports.report_id%TYPE,
      p_month              giac_map_expanded_ext.return_month%TYPE,
      p_myear              giac_map_expanded_ext.return_year%TYPE,
      p_user_id            giac_sawt_ext.user_id%TYPE
   ) RETURN giacs115_dat_tab PIPELINED;
   
   PROCEDURE get_giacs115_dat_map_details(
      p_report_id          IN giis_reports.report_id%TYPE,
      p_month              IN giac_map_expanded_ext.return_month%TYPE,
      p_myear              IN giac_map_expanded_ext.return_year%TYPE,
      p_user_id            IN giac_sawt_ext.user_id%TYPE,
      p_file_name          OUT VARCHAR2,
      p_header             OUT VARCHAR2,
      p_footer             OUT VARCHAR2
   );
   
   FUNCTION get_giacs115_dat_map_ann_list(
      p_report_id          giis_reports.report_id%TYPE,
      p_yyear              giac_map_expanded_ext.return_year%TYPE,
      p_bir_freq_tag_query giac_map_expanded_ext.period_tag%TYPE,
      p_user_id            giac_sawt_ext.user_id%TYPE
   ) RETURN giacs115_dat_tab PIPELINED;
   
   PROCEDURE get_giacs115_dat_map_ann_dtls(
      p_report_id          IN giis_reports.report_id%TYPE,
      p_yyear              IN giac_map_expanded_ext.return_year%TYPE,
      p_user_id            IN giac_sawt_ext.user_id%TYPE,
      p_bir_freq_tag_query IN giac_map_expanded_ext.period_tag%TYPE,
      p_amended_rtn        IN VARCHAR2,
      p_no_of_sheets       IN NUMBER,
      p_file_name          OUT VARCHAR2,
      p_header             OUT VARCHAR2,
      p_footer             OUT VARCHAR2
   );
   
   FUNCTION get_giacs115_dat_sawt_list(
      p_sawt_form          VARCHAR2,
      p_month              giac_sawt_ext.return_month%TYPE,
      p_myear              giac_sawt_ext.return_year%TYPE,
      p_user_id            giac_sawt_ext.user_id%TYPE
   ) RETURN giacs115_dat_tab PIPELINED;
   
   PROCEDURE get_giacs115_dat_sawt_details(
      p_sawt_form          IN VARCHAR2,
      p_month              IN giac_map_expanded_ext.return_month%TYPE,
      p_myear              IN giac_map_expanded_ext.return_year%TYPE,
      p_user_id            IN giac_sawt_ext.user_id%TYPE,
      p_file_name          OUT VARCHAR2,
      p_header             OUT VARCHAR2,
      p_footer             OUT VARCHAR2
   );
   
   PROCEDURE sls_vat (
      p_return_month   giac_relief_sls_ext.return_month%TYPE,
      p_return_myear   giac_relief_sls_ext.return_year%TYPE,
      p_return_yyear   giac_relief_sls_ext.return_year%TYPE,
      p_period_tag     giac_relief_sls_ext.period_tag%TYPE,
      p_user_id        giac_relief_sls_ext.user_id%TYPE
   );
   --added by robert SR 5473 03.14.16
   TYPE giacs115_rlf_sls_csv_type IS RECORD (
      issuing_source        GIAC_RELIEF_SLS_EXT.iss_source%TYPE,
      payee_name            VARCHAR2(1600),
      tin                   GIAC_RELIEF_SLS_EXT.cust_tin%TYPE,
      first_address         GIAC_RELIEF_SLS_EXT.address1%TYPE,
      second_address        GIAC_RELIEF_SLS_EXT.address2%TYPE,
      tax_exempt            GIAC_RELIEF_SLS_EXT.exempt_sales%TYPE,
      zero_rated            GIAC_RELIEF_SLS_EXT.zero_rated_sales%TYPE,
      taxable               GIAC_RELIEF_SLS_EXT.taxable_sales_net_vat%TYPE,
      output_tax            GIAC_RELIEF_SLS_EXT.output_tax%TYPE
   );
      
   TYPE giacs115_rlf_sls_csv_tab IS TABLE OF giacs115_rlf_sls_csv_type;
   
   FUNCTION generate_csv_rlf_sls(
       p_month     giac_relief_sls_ext.return_month%TYPE,
       p_myear     giac_relief_sls_ext.return_year%TYPE,
       p_user_id   giac_relief_sls_ext.user_id%TYPE
   ) RETURN giacs115_rlf_sls_csv_tab PIPELINED;
   
   FUNCTION generate_dat_rlf_sls_list(
       p_month     giac_relief_sls_ext.return_month%TYPE,
       p_myear     giac_relief_sls_ext.return_year%TYPE,
       p_user_id   giac_relief_sls_ext.user_id%TYPE
   ) RETURN giacs115_dat_tab PIPELINED;
   
   PROCEDURE generate_dat_rlf_sls_details(
      p_month              IN giac_relief_sls_ext.return_month%TYPE,
      p_myear              IN giac_relief_sls_ext.return_year%TYPE,
      p_user_id            IN giac_relief_sls_ext.user_id%TYPE,
      p_file_name          OUT VARCHAR2,
      p_header             OUT VARCHAR2,
      p_footer             OUT VARCHAR2
   );
   --end of codes by robert SR 5473 03.14.16
END;
/


