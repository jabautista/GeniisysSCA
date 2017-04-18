CREATE OR REPLACE PACKAGE CPI.SECURITY_ACCESS
AS
   TYPE branch_line_list_type IS RECORD (
      branch_cd   VARCHAR2 (10),
      line_cd     VARCHAR2 (10)
   );

   TYPE branch_list_tab IS TABLE OF branch_line_list_type;

   FUNCTION get_branch_line (
      p_module_type   VARCHAR2,
      --p_line_cd       VARCHAR2,
      p_module_id     VARCHAR2,
      p_user_id       giis_users.user_id%TYPE
   )
      RETURN branch_list_tab PIPELINED;
END;
/
