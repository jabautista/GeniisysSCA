CREATE OR REPLACE PACKAGE CPI.GIACR044R_PKG AS 

  TYPE giacr044r_record_type IS RECORD (
    company_name    giis_parameters.param_value_v%TYPE,
    company_address giis_parameters.param_value_v%TYPE,
    cf_date         VARCHAR2(100),
    gl_acct_id      giac_chart_of_accts.gl_acct_id%TYPE,
    gl_acct         VARCHAR2(100),
    gl_acct_name    giac_chart_of_accts.gl_acct_name%TYPE,
    debit_amt       giac_acct_entries.debit_amt%TYPE,
    credit_amt      giac_acct_entries.credit_amt%TYPE, 
    tran_class      giac_acctrans.tran_class%TYPE,
    tran_class_name VARCHAR2(500),
    header_flag     VARCHAR2 (1)
  );

  TYPE giacr044r_record_tab IS TABLE OF giacr044r_record_type;
  
  FUNCTION get_report (
      p_mm          NUMBER,
      p_year        NUMBER,
      p_branch_cd   VARCHAR2
    )
    RETURN giacr044r_record_tab PIPELINED;

END GIACR044R_PKG;
/


