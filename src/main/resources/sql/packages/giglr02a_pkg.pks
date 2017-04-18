CREATE OR REPLACE PACKAGE CPI.GIGLR02A_PKG
AS
    TYPE main_report_type IS RECORD (
        cf_company      giis_parameters.param_value_v%TYPE,
        cf_address      giis_parameters.param_value_v%TYPE,
        cf_title        giis_reports.report_title%TYPE,
        gl_acct_cd      VARCHAR2(30),
        gl_acct_name    giac_chart_of_accts.gl_acct_name%TYPE,
        gl_acct_sname   giac_chart_of_accts.gl_acct_sname%TYPE,
        gslt_sl_type_cd giac_chart_of_accts.gslt_sl_type_cd%TYPE,
        sl_type_name    giac_sl_types.sl_type_name%TYPE,
        leaf_tag        giac_chart_of_accts.leaf_tag%TYPE,
        v_print         VARCHAR2(8)
    );
    
    TYPE main_report_tab IS TABLE OF main_report_type;
    
    FUNCTION get_main_report
      RETURN main_report_tab PIPELINED;
             
END GIGLR02A_PKG;
/


