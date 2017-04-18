CREATE OR REPLACE PACKAGE CPI.GIACS328_PKG  
AS
   TYPE brach_lov_type IS RECORD (
      iss_cd     giac_branches.branch_cd%TYPE,
      iss_name   giac_branches.branch_name%TYPE
   );

   TYPE brach_lov_tab IS TABLE OF brach_lov_type;

   PROCEDURE get_last_extract_param (
      p_user_id     giis_users.user_id%TYPE,
      p_from_date   OUT   VARCHAR2,
      p_to_date     OUT   VARCHAR2,
      p_extract_by  OUT   VARCHAR2,
      p_iss_cd      OUT   VARCHAR2,
      p_iss_name    OUT   VARCHAR2
   );
      
   FUNCTION get_branch_lov (p_user_id giis_users.user_id%TYPE)
      RETURN brach_lov_tab PIPELINED;

   PROCEDURE extract_aging_of_collections (p_user_id giis_users.user_id%TYPE);

   PROCEDURE insert_to_aging_ext (
      p_user_id           giis_users.user_id%TYPE,
      p_from_date         DATE,
      p_to_date           DATE,
      p_eff_date          VARCHAR2,
      p_due_date          VARCHAR2,
      p_branch_cd         VARCHAR2,
      p_message     OUT   VARCHAR2
   );
END GIACS328_PKG;
/


