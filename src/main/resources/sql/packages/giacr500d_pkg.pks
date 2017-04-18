CREATE OR REPLACE PACKAGE CPI.giacr500d_pkg
AS
   TYPE giacr500d_record_type IS RECORD (
      branch_name            VARCHAR2 (50),
      test1                  VARCHAR2 (2),
      test2                  VARCHAR2 (3),
      test3                  VARCHAR2 (2),
      branch_cd              VARCHAR2 (2),
      gl_acct_no_formatted   VARCHAR2 (72),
      acct_name              VARCHAR2 (100),
      gl_acct_category       NUMBER (1),
      gl_control_acct        NUMBER (2),
      gl_sub_acct_1          NUMBER (38),
      gl_sub_acct_2          NUMBER (38),
      gl_sub_acct_3          NUMBER (38),
      gl_sub_acct_4          NUMBER (38),
      gl_sub_acct_5          NUMBER (38),
      gl_sub_acct_6          NUMBER (38),
      gl_sub_acct_7          NUMBER (38),
      YEAR                   NUMBER (4),
      MONTH                  NUMBER (2),
      debit                  NUMBER (16, 2),
      credit                 NUMBER (16, 2),
      cf_company_name        VARCHAR2 (300),
      cf_company_add         VARCHAR2 (350),
      cf_date                VARCHAR2 (50),
      p_month                NUMBER (2),
      p_year                 NUMBER (4),
      cname                  VARCHAR (1)
   );

   TYPE giacr500d_record_tab IS TABLE OF giacr500d_record_type;

   FUNCTION get_giacr500d_record (p_month NUMBER, p_year NUMBER)
      RETURN giacr500d_record_tab PIPELINED;
END;
/


