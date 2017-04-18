CREATE OR REPLACE PACKAGE CPI.giacs190_pkg
AS
   TYPE branch_lov_type IS RECORD (
      branch_cd     giac_branches.branch_cd%TYPE,
      branch_name   giac_branches.branch_name%TYPE
   );

   TYPE branch_lov_tab IS TABLE OF branch_lov_type;

   FUNCTION get_sl_type_cd
      RETURN VARCHAR;

   FUNCTION get_branch_lov (
      p_user_id     giis_users.user_id%TYPE,
      p_module_id   VARCHAR2
   )
      RETURN branch_lov_tab PIPELINED;
END;
/


