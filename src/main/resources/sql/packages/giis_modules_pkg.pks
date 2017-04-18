CREATE OR REPLACE PACKAGE CPI.giis_modules_pkg
AS
   TYPE giis_modules_type IS RECORD (
      module_id        giis_modules.module_id%TYPE,
      module_desc      giis_modules.module_desc%TYPE,
      user_id          giis_modules.user_id%TYPE,
      last_update      giis_modules.last_update%TYPE,
      remarks          giis_modules.remarks%TYPE,
      module_grp       giis_modules.module_grp%TYPE,
      module_type      giis_modules.module_type%TYPE,
      mod_access_tag   cg_ref_codes.rv_meaning%TYPE
   );

   TYPE giis_modules_tab IS TABLE OF giis_modules_type;

   FUNCTION get_giis_modules_list (p_keyword VARCHAR2)
      RETURN giis_modules_tab PIPELINED;

   PROCEDURE set_giis_module (
      p_module_id        VARCHAR2,
      p_module_desc      VARCHAR2,
      p_user_id          VARCHAR2,
      p_remarks          VARCHAR2,
      p_module_grp       VARCHAR2,
      p_module_type      VARCHAR2,
      p_mod_access_tag   NUMBER
   );

   FUNCTION get_giis_modules (p_module_id VARCHAR2)
      RETURN giis_modules_tab PIPELINED;

   PROCEDURE update_giis_module (
      p_module_id        VARCHAR2,
      p_module_desc      VARCHAR2,
      p_user_id          VARCHAR2,
      p_remarks          VARCHAR2,
      p_module_grp       VARCHAR2,
      p_module_type      VARCHAR2,
      p_mod_access_tag   NUMBER
   );
END giis_modules_pkg;
/


