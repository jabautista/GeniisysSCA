CREATE OR REPLACE PACKAGE CPI.GIACR354_PKG
AS
    TYPE main_report_type IS RECORD (
        cf_company      giis_parameters.param_value_v%TYPE,
        cf_address      giis_parameters.param_value_v%TYPE,
        cf_title        giis_reports.report_title%TYPE,
        cf_subtitle     VARCHAR2(200),
        line_name       giis_line.line_name%TYPE,
        gl_acct_sname   VARCHAR2(100),
        prem_amt        giac_batch_check_gross_ext.prem_amt%TYPE,
        balance         giac_batch_check_gross_ext.balance%TYPE,
        difference      giac_batch_check_gross_ext.balance%TYPE,
        net             giac_batch_check_gross_ext.balance%TYPE,
        type            NUMBER,
        col_header      VARCHAR2(128),
        v_print         VARCHAR2(8)
    );
    
    TYPE main_report_tab IS TABLE OF main_report_type;
    
    FUNCTION get_main_report(
        p_user_id       giac_batch_check_gross_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED;
      
    FUNCTION get_gross(
        p_user_id       giac_batch_check_gross_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED;
      
    FUNCTION get_facultative(
        p_user_id       giac_batch_check_gross_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED;
      
    FUNCTION get_treaty(
        p_user_id       giac_batch_check_gross_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED;
      
    FUNCTION get_net(
        p_user_id       giac_batch_check_gross_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED;
      
    FUNCTION get_claim_report(
        p_user_id       giac_batch_check_os_loss_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED;
      
    FUNCTION get_outstanding(
        p_user_id       giac_batch_check_os_loss_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED;
      
    FUNCTION get_losses(
        p_user_id       giac_batch_check_loss_pd_ext.user_id%TYPE
    )
      RETURN main_report_tab PIPELINED;
             
   --Deo [02.02.2017]: add start (SR-5923)
   TYPE str_csv_rec_type IS RECORD (
      rec   VARCHAR2 (32767)
   );

   TYPE str_csv_rec_tab IS TABLE OF str_csv_rec_type;

   FUNCTION production_csv (p_user_id VARCHAR2)
      RETURN str_csv_rec_tab PIPELINED;

   FUNCTION claims_csv (p_user_id VARCHAR2)
      RETURN str_csv_rec_tab PIPELINED;
   --Deo [02.02.2017]: add ends (SR-5923)
END GIACR354_PKG;
/


