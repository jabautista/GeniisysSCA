CREATE OR REPLACE PACKAGE CPI.giacs480_pkg
AS
   TYPE branch_lov_type IS RECORD (
      branch_cd         giac_branches.branch_cd%TYPE,
      branch_name       giac_branches.branch_name%TYPE
   );
   
   TYPE branch_lov_tab IS TABLE OF branch_lov_type;
   
   FUNCTION get_branch_lov (
      p_user_id         giis_users.user_id%TYPE,
      p_keyword         VARCHAR2
   )
      RETURN branch_lov_tab PIPELINED;
   
   TYPE company_lov_type IS RECORD (
      payee_no          giis_payees.payee_no%TYPE,
      payee_last_name   giis_payees.payee_last_name%TYPE
   );

   TYPE company_lov_tab IS TABLE OF company_lov_type;

   FUNCTION get_company_lov (p_keyword VARCHAR2)
      RETURN company_lov_tab PIPELINED;

   TYPE employee_lov_type IS RECORD (
      ref_payee_cd   giis_payees.ref_payee_cd%TYPE,
      emp_name       VARCHAR2 (200)
   );

   TYPE employee_lov_tab IS TABLE OF employee_lov_type;

   FUNCTION get_employee_lov (
      p_company_cd giis_payees.payee_no%TYPE,
      p_keyword    VARCHAR2
   )
      RETURN employee_lov_tab PIPELINED;

   FUNCTION validate_date_params (p_as_of_date VARCHAR2, p_user_id VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE extract_giacs480 (
      p_as_of_date          DATE,
      p_iss_cd              giac_branches.branch_cd%TYPE,
      p_company_cd          giis_payees.payee_no%TYPE,
      p_employee_cd         giis_payees.ref_payee_cd%TYPE,
      p_user_id             giis_users.user_id%TYPE,
      p_exists        OUT   VARCHAR2
   );
   
   TYPE when_new_form_instance_type IS RECORD (
      v_as_of_date VARCHAR2 (15)
   );

   TYPE when_new_form_instance_tab IS TABLE OF when_new_form_instance_type;
   
   FUNCTION when_new_form_instance (p_user_id giis_users.user_id%TYPE)
      RETURN when_new_form_instance_tab PIPELINED;
END;
/


