CREATE OR REPLACE PACKAGE CPI.GIACR502C_PKG
AS
   TYPE giacr502c_record_type IS RECORD (
      fund_cd           VARCHAR2 (3),
      branch_cd         VARCHAR2 (2),
      gl_acct_name      VARCHAR2 (100),
      gl_acct_id        NUMBER (6),
      gl_no             VARCHAR2 (100),
      debit             NUMBER (16, 2),
      credit            NUMBER (16, 2),
      comp_name         VARCHAR2 (100),
      company_address   VARCHAR2 (500),
      as_of_date        VARCHAR2 (200),
      branch_name2      VARCHAR2 (200),
      branch            VARCHAR2 (25),
      balance           NUMBER (16, 2),
      branch_totals     VARCHAR2 (50),
      flag              VARCHAR2 (50),
      v_header          VARCHAR2 (2)
   );

   TYPE giacr502c_record_tab IS TABLE OF giacr502c_record_type;

   FUNCTION get_giacr502c_records (
      p_branch_cd   VARCHAR2,
      p_tran_mm     VARCHAR2,
      p_tran_yr     VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr502c_record_tab PIPELINED;
END;
/


