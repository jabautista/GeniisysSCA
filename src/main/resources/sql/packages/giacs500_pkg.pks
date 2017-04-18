CREATE OR REPLACE PACKAGE CPI.giacs500_pkg
AS
   FUNCTION validate_transaction_date (p_tran_date DATE)
      RETURN VARCHAR2;

   FUNCTION check_tran_open (
      p_tran_date       DATE,
      p_include_month   VARCHAR2,
      p_include_year    VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION check_date (p_tran_date DATE)
      RETURN VARCHAR2;

   PROCEDURE del_giac_monthly_totals_backup;

   PROCEDURE ins_giac_monthly_totals_backup (p_tran_date DATE);

   PROCEDURE update_acctransae (p_tran_date DATE, p_update_action VARCHAR2);

   FUNCTION get_no_of_records (p_tran_date DATE)
      RETURN VARCHAR2;

   PROCEDURE del_giac_monthly_totals (p_tran_date DATE);

   PROCEDURE ins_giac_monthly_totals (p_tran_date DATE, p_user_id VARCHAR2);
END;
/


