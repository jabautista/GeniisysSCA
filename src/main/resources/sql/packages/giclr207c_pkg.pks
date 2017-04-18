CREATE OR REPLACE PACKAGE CPI.giclr207c_pkg
AS
   TYPE giclr207c_record_type IS RECORD (
      gl_acct_id     NUMBER (6),
      gl_acct        VARCHAR2 (200),
      gl_acct_name   VARCHAR2 (100),
      tran_date      DATE,
      tran_class     VARCHAR2 (3),
      debit_amt      NUMBER (16, 2),
      credit_amt     NUMBER (16, 2),
      flag           VARCHAR2 (50),
      company_name   VARCHAR2 (200),
      company_add    VARCHAR2 (350),
      as_of_date     VARCHAR2 (100)
   );

   TYPE giclr207c_record_tab IS TABLE OF giclr207c_record_type;

   FUNCTION get_giclr207c_records (
      p_month        VARCHAR2,
      p_year         VARCHAR2,
      p_tran_class   VARCHAR2,
      p_tran_date    VARCHAR2
   )
      RETURN giclr207c_record_tab PIPELINED;
END;
/


