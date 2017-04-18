CREATE OR REPLACE PACKAGE CPI.GIACS502_PKG
AS
   TYPE branch_lov_type IS RECORD (
      branch_cd     giis_issource.iss_cd%TYPE,
      branch_name   giis_issource.iss_name%TYPE
   );

   TYPE branch_lov_tab IS TABLE OF branch_lov_type;

   FUNCTION get_branch_lov (p_user_id giis_users.user_id%TYPE)
      RETURN branch_lov_tab PIPELINED;

   PROCEDURE extract_mother_accounts (
      p_user_id   giis_users.user_id%TYPE,
      p_month     NUMBER,
      p_year      NUMBER
   );

   PROCEDURE extract_mother_accounts_detail (
      p_user_id   giis_users.user_id%TYPE,
      p_month     NUMBER,
      p_year      NUMBER 
   );
END GIACS502_PKG;
/


