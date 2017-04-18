CREATE OR REPLACE PACKAGE CPI.giacs111_pkg
AS
   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   TYPE branch_lov_type IS RECORD (
      branch_cd     giis_issource.iss_cd%TYPE,
      branch_name   giis_issource.iss_name%TYPE
   );

   TYPE branch_lov_tab IS TABLE OF branch_lov_type;

   FUNCTION get_line_lov (
      p_user_id   giis_users.user_id%TYPE,
      p_iss_cd    giis_issource.iss_cd%TYPE
   )
      RETURN line_lov_tab PIPELINED;

   FUNCTION get_branch_lov (p_user_id giis_users.user_id%TYPE)
      RETURN branch_lov_tab PIPELINED;
END;
/


