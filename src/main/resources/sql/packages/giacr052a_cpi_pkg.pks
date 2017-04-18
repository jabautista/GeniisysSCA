CREATE OR REPLACE PACKAGE CPI.giacr052a_cpi_pkg AS
    
  TYPE giacr052a_record_type IS RECORD (
    dv_no               VARCHAR2(100),
    dv_no2              VARCHAR2(100),
    bank_account        VARCHAR2(100),
    check_number        VARCHAR2(100),
    check_number2       VARCHAR2(300),
    check_amt           VARCHAR2(100),
    chk_date            DATE,
    dv_amt              VARCHAR2(100),
    payee               giac_disb_vouchers.payee%TYPE,
    particulars         giac_disb_vouchers.particulars%TYPE,
    prepared_by         giac_disb_vouchers.dv_created_by%TYPE,
    payment_request     VARCHAR2(100),
    curr_date           VARCHAR2(10),
    curr_time           VARCHAR2(10)
  );

  TYPE giacr052a_record_tab IS TABLE OF giacr052a_record_type;
  
  FUNCTION populate_giacr052a_records (
    p_tran_id           VARCHAR2
    )
    RETURN giacr052a_record_tab PIPELINED;

  TYPE giacr052a_ent_type IS RECORD (
    gl_acct_no          VARCHAR2(30),
    gl_acct_name        giac_chart_of_accts.gl_acct_name%TYPE,
    debit_amt           NUMBER,
    credit_amt          NUMBER
  );

  TYPE giacr052a_ent_tab IS TABLE OF giacr052a_ent_type;
  
  FUNCTION populate_giacr052a_ent (
     p_tran_id          VARCHAR2
    )
    RETURN giacr052a_ent_tab PIPELINED;

END giacr052a_cpi_pkg;
/

DROP PACKAGE CPI.GIACR052A_CPI_PKG;
