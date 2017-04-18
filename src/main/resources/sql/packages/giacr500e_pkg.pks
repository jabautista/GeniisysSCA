CREATE OR REPLACE PACKAGE CPI.giacr500e_pkg
AS
   TYPE giacr500e_record_type IS RECORD (
      branch_name              VARCHAR2 (50),
      gl_acct_no               VARCHAR2 (368),
      gl_acct_name             VARCHAR2 (100),
      trans_debit_bal          NUMBER (16, 2),
      trans_credit_bal         NUMBER (16, 2),
      total                    VARCHAR2 (44),
      gl_acct_category         NUMBER (1),
      gl_acct_no_formatted     VARCHAR2 (72),
      p_year                   NUMBER (4),
      p_month                  NUMBER (2),
      sum1                     VARCHAR2 (48),
      sum2                     VARCHAR2 (52),  
      cf_company_nameformula   VARCHAR2 (300),
      cf_company_add           VARCHAR2 (300),
      cf_dateformula           VARCHAR2 (300),
      cf_currentdate           VARCHAR2 (20),
      v_test                   VARCHAR2 (1)
   );

   TYPE giacr500e_record_tab IS TABLE OF giacr500e_record_type;

   FUNCTION get_giacr500e_record (p_month NUMBER, p_year NUMBER)
      RETURN giacr500e_record_tab PIPELINED;
END;
/


