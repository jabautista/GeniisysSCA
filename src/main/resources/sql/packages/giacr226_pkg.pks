CREATE OR REPLACE PACKAGE CPI.GIACR226_PKG
AS
   TYPE giacr226_record_type IS RECORD (
      gl_acct                 VARCHAR2 (368),
      gl_acct_name            VARCHAR2 (100),
      debit_amt               NUMBER (16, 2),
      credit_amt              NUMBER (16, 2),
      sl_cd                   NUMBER (12),
      gslt_sl_type_cd         VARCHAR2 (2),
      gacc_tran_id            NUMBER (12),
      cf_company_name         VARCHAR2 (200),
      cf_company_add          VARCHAR2 (200),
      cf_company_month_year   VARCHAR2 (100),
      p_date                  VARCHAR2 (100),
      p_user_id               VARCHAR2 (8),
      v_iss_cd                VARCHAR2 (40),
      v_flag                  VARCHAR2 (1)
   );

   TYPE giacr226_record_tab IS TABLE OF giacr226_record_type;

   FUNCTION get_giacr226_record (
      v_iss_cd    VARCHAR2,
      p_date      VARCHAR2,
      p_user_id   VARCHAR2
   )
      RETURN giacr226_record_tab PIPELINED;
END GIACR226_PKG;
/


