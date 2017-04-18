CREATE OR REPLACE PACKAGE CPI.giacs329_pkg
AS
   FUNCTION validate_date_params (p_as_of_date VARCHAR2, p_user_id VARCHAR2) 
      RETURN VARCHAR2;  

   PROCEDURE extract_giacs329 (  
      p_as_of_date         DATE,
      p_branch_cd          giac_branches.branch_cd%TYPE, 
      p_user_id            giis_users.user_id%TYPE, 
      p_intm_type          VARCHAR2, --marco - 08.05.2014 - added
      p_intm_no            NUMBER,   --
      p_exists       OUT   VARCHAR2 
   );

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

   TYPE intmtype_lov_type IS RECORD (
      intm_type   giis_intm_type.intm_type%TYPE,
      intm_desc   giis_intm_type.intm_desc%TYPE
   );

   TYPE intmtype_lov_tab IS TABLE OF intmtype_lov_type;

   FUNCTION get_intmtype_lov (
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN intmtype_lov_tab PIPELINED;

   TYPE intm_lov_type IS RECORD (
      intm_no     giis_intermediary.intm_no%TYPE,
      intm_name   giis_intermediary.intm_name%TYPE
   );

   TYPE intm_lov_tab IS TABLE OF intm_lov_type;

   FUNCTION get_intm_lov (
      p_intm_type   giis_intm_type.intm_type%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN intm_lov_tab PIPELINED;
      
   TYPE when_new_form_instance_type IS RECORD (
      v_as_of_date VARCHAR2 (15)
   );

   TYPE when_new_form_instance_tab IS TABLE OF when_new_form_instance_type;
      
   FUNCTION when_new_form_instance (p_user_id giis_users.user_id%TYPE)
      RETURN when_new_form_instance_tab PIPELINED;
END giacs329_pkg;
/


