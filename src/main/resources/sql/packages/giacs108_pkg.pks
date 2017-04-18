CREATE OR REPLACE PACKAGE CPI.giacs108_pkg 
   /*
   **  Created by        : bonok
   **  Date Created      : 07.18.2013
   **  Reference By      : GIACS108 - EVAT
   **
   */
AS
   TYPE branch_cd_giacs108_lov_type IS RECORD(
      iss_cd            giis_issource.iss_cd%TYPE,
      iss_name          giis_issource.iss_name%TYPE
   );
    
   TYPE branch_cd_giacs108_lov_tab IS TABLE OF branch_cd_giacs108_lov_type;
   
   FUNCTION get_branch_cd_giacs108_lov(
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE
   ) RETURN branch_cd_giacs108_lov_tab PIPELINED;
   
   TYPE line_cd_giacs108_lov_type IS RECORD(
      line_cd           giis_line.line_cd%TYPE,
      line_name         giis_line.line_name%TYPE
   );
    
   TYPE line_cd_giacs108_lov_tab IS TABLE OF line_cd_giacs108_lov_type;
   
   FUNCTION get_line_cd_giacs108_lov   
   RETURN line_cd_giacs108_lov_tab PIPELINED;
END giacs108_pkg;
/


