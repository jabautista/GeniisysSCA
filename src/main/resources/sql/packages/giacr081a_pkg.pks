CREATE OR REPLACE PACKAGE CPI.GIACR081A_PKG AS
    
    TYPE main_report_record_type IS RECORD (
        company_name        giis_parameters.param_value_v%TYPE,
        company_address     giis_parameters.param_value_v%TYPE,
        replenishment_no    VARCHAR2(256),
        gl_acct_no          VARCHAR2(256),
        gl_acct_name        VARCHAR2(256),
        debit_amt           giac_acct_entries.debit_amt%TYPE,
        credit_amt          giac_acct_entries.credit_amt%TYPE
    );

    TYPE main_report_record_tab IS TABLE OF main_report_record_type;
  
    FUNCTION get_dv_records(
        p_replenish_id  giac_replenish_dv.replenish_id%TYPE
    )
        RETURN main_report_record_tab PIPELINED;

END GIACR081A_PKG;
/


