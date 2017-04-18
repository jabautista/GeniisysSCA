CREATE OR REPLACE PACKAGE CPI.GIACS310_PKG
AS
   TYPE rec_type IS RECORD (
      aging_id          giac_aging_parameters.aging_id%TYPE,
      gibr_gfun_fund_cd giac_aging_parameters.gibr_gfun_fund_cd%TYPE,
      fund_desc         giis_funds.fund_desc%TYPE,
      gibr_branch_cd    giac_aging_parameters.gibr_branch_cd%TYPE,
      branch_name       giac_branches.branch_name%TYPE,
      column_no         giac_aging_parameters.column_no%TYPE,
      column_heading    giac_aging_parameters.column_heading%TYPE,
      min_no_days       giac_aging_parameters.min_no_days%TYPE,
      max_no_days       giac_aging_parameters.max_no_days%TYPE,
      over_due_tag      giac_aging_parameters.over_due_tag%TYPE,
      rep_col_no        giac_aging_parameters.rep_col_no%TYPE,
      user_id           giac_aging_parameters.user_id%TYPE,
      last_update       VARCHAR2(30),
      remarks           giac_aging_parameters.remarks%TYPE,
      cpi_rec_no        giac_aging_parameters.cpi_rec_no%TYPE,
      cpi_branch_cd     giac_aging_parameters.cpi_branch_cd%TYPE
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list(
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE
   ) RETURN rec_tab PIPELINED;
   
   TYPE fund_lov_type IS RECORD (
      gibr_gfun_fund_cd giac_aging_parameters.gibr_gfun_fund_cd%TYPE,
      fund_desc         giis_funds.fund_desc%TYPE
   );

   TYPE fund_lov_tab IS TABLE OF fund_lov_type;
   
   FUNCTION get_fund_cd_lov(
      p_keyword         VARCHAR2
   ) RETURN fund_lov_tab PIPELINED;
   
   TYPE branch_lov_type IS RECORD (
      gibr_branch_cd    giac_branches.branch_cd%TYPE,
      branch_name       giac_branches.branch_name%TYPE
   );

   TYPE branch_lov_tab IS TABLE OF branch_lov_type;
   
   FUNCTION get_branch_cd_lov(
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE,  
      p_keyword         VARCHAR2
   ) RETURN branch_lov_tab PIPELINED;
   
   FUNCTION get_branch_cd_to_lov(
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE,  
      p_keyword         VARCHAR2
   ) RETURN branch_lov_tab PIPELINED;
   
   FUNCTION get_branch_cd_from_lov(
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE,  
      p_keyword         VARCHAR2
   ) RETURN branch_lov_tab PIPELINED;

   PROCEDURE set_rec(p_rec giac_aging_parameters%ROWTYPE);
   
   PROCEDURE del_rec(p_rec giac_aging_parameters%ROWTYPE);
   
   PROCEDURE copy_records(
      p_fund_cd_from    giac_aging_parameters.gibr_gfun_fund_cd%TYPE,
      p_branch_cd_from  giac_aging_parameters.gibr_branch_cd%TYPE,
      p_fund_cd_to      giac_aging_parameters.gibr_gfun_fund_cd%TYPE,
      p_branch_cd_to    giac_aging_parameters.gibr_branch_cd%TYPE,
      p_user_id         giac_aging_parameters.user_id%TYPE
   );
END;
/


