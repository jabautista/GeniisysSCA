CREATE OR REPLACE PACKAGE CSV_AC_EOM_REPORTS
AS
   TYPE giacr225_record_type IS RECORD (
      branch_code             VARCHAR2 (2),
      branch_name             VARCHAR2 (100),
      transaction_class       VARCHAR2 (500),
      gl_account_no           VARCHAR2 (72),
      gl_account_name         VARCHAR2 (100),
      debit_amount            NUMBER (12, 2),
      credit_amount           NUMBER (12, 2),
      balance_amount          NUMBER (12, 2)
   );

   TYPE giacr225_record_tab IS TABLE OF giacr225_record_type;

   FUNCTION csv_giacr225(
      p_branch_cd   VARCHAR2,
      p_date        VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giacr225_record_tab PIPELINED;
END CSV_AC_EOM_REPORTS;
/
