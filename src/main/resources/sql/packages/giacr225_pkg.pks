CREATE OR REPLACE PACKAGE CPI.GIACR225_PKG
AS
   TYPE giacr225_record_type IS RECORD (
      tran_date            DATE,
      tran_class           VARCHAR2 (3),
      gl_acct_id           NUMBER (6),
      gl_acct_name         VARCHAR2 (100),
      debit_amt            NUMBER (12, 2),
      credit_amt           NUMBER (12, 2),
      gl_acct              VARCHAR2 (72),
      balance_amt          NUMBER (12, 2),
      p_branch_cd          VARCHAR2 (2),
      p_date               VARCHAR2 (40),
      cf_company_name      VARCHAR2 (100),
      cf_address           VARCHAR2 (500),
      cf_date              VARCHAR2 (100),
      cf_branch            VARCHAR2 (100),
      cf_tran_class_name   VARCHAR2 (500),
      p_user_id            VARCHAR2 (8),
      v_flag               VARCHAR2 (1)
   );

   TYPE giacr225_record_tab IS TABLE OF giacr225_record_type;

   FUNCTION get_giacr225_record (
      p_branch_cd   VARCHAR2,
      p_date        VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr225_record_tab PIPELINED;
END GIACR225_PKG;
/


