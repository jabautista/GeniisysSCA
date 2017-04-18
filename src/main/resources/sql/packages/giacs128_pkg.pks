CREATE OR REPLACE PACKAGE CPI.giacs128_pkg
AS
   PROCEDURE extract_records (
      p_from_date    DATE,
      p_to_date      DATE,
      p_module_id    VARCHAR,
      p_per_branch   VARCHAR,
      p_user_id      giis_users.user_id%TYPE
   );

   TYPE check_prev_ext_type IS RECORD (
      v_from_date   VARCHAR2 (15),
      v_to_date     VARCHAR2 (15)
   );

   TYPE check_prev_ext_tab IS TABLE OF check_prev_ext_type;

   FUNCTION check_prev_ext (p_user_id giis_users.user_id%TYPE)
      RETURN check_prev_ext_tab PIPELINED;

   TYPE branch_lov_type IS RECORD (
      branch_cd     giac_branches.branch_cd%TYPE,
      branch_name   giac_branches.branch_name%TYPE
   );

   TYPE branch_lov_tab IS TABLE OF branch_lov_type;

   FUNCTION get_branch_lov (
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN branch_lov_tab PIPELINED;

   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   FUNCTION get_line_lov (
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN line_lov_tab PIPELINED;
END;
/


