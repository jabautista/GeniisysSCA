CREATE OR REPLACE PACKAGE CPI.giacr500A_pkg
AS
   TYPE giacr500a_record_type IS RECORD (
      gl_acct_no_formatted     VARCHAR2 (72),
      acct_name                VARCHAR2 (100),
      gl_acct_category         NUMBER (1),
      gl_control_acct          NUMBER (2),
      gl_sub_acct_1            NUMBER (38),
      gl_sub_acct_2            NUMBER (38),
      gl_sub_acct_3            NUMBER (38),
      gl_sub_acct_4            NUMBER (38),
      gl_sub_acct_5            NUMBER (38),
      gl_sub_acct_6            NUMBER (38),
      gl_sub_acct_7            NUMBER (38),
      YEAR                     NUMBER (4),
      MONTH                    NUMBER (2),
      debit                    NUMBER (16, 2),
      credit                   NUMBER (16, 2),
      p_year                   NUMBER (4),
      p_month                  NUMBER (2),
      cf_company_nameformula   VARCHAR2 (300),
      cf_1formula              VARCHAR2 (300),
      cf_dateformula           VARCHAR2 (300),
      v_test                   VARCHAR2 (1)
   );

   TYPE giacr500a_record_tab IS TABLE OF giacr500a_record_type;

   FUNCTION get_giacr500a_record (p_month NUMBER, p_year NUMBER)
      RETURN giacr500a_record_tab PIPELINED;
END;
/


