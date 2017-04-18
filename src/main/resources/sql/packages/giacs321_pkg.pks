CREATE OR REPLACE PACKAGE CPI.GIACS321_PKG
AS
   TYPE giac_modules_type IS RECORD (
      module_id      giac_modules.module_id%TYPE,
      module_name    giac_modules.module_name%TYPE,
      scrn_rep_name  giac_modules.scrn_rep_name%TYPE
   );

   TYPE giac_modules_tab IS TABLE OF giac_modules_type;

   TYPE rec_type IS RECORD (
      module_id               giac_module_entries.module_id%TYPE,
      item_no                 giac_module_entries.item_no%TYPE,
      gl_acct_category        giac_module_entries.gl_acct_category%TYPE,
      gl_control_acct         giac_module_entries.gl_control_acct%TYPE,
      pol_type_tag            giac_module_entries.pol_type_tag%TYPE,
      dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE,
      gl_sub_acct_1           giac_module_entries.gl_sub_acct_1%TYPE,
      gl_sub_acct_2           giac_module_entries.gl_sub_acct_2%TYPE,
      gl_sub_acct_3           giac_module_entries.gl_sub_acct_3%TYPE,
      gl_sub_acct_4           giac_module_entries.gl_sub_acct_4%TYPE,
      gl_sub_acct_5           giac_module_entries.gl_sub_acct_5%TYPE,
      gl_sub_acct_6           giac_module_entries.gl_sub_acct_6%TYPE,
      gl_sub_acct_7           giac_module_entries.gl_sub_acct_7%TYPE,
      sl_type_cd              giac_module_entries.sl_type_cd%TYPE,
      description             giac_module_entries.description%TYPE,
      line_dependency_level   giac_module_entries.line_dependency_level%TYPE,
      intm_type_level         giac_module_entries.intm_type_level%TYPE,
      old_new_acct_level      giac_module_entries.old_new_acct_level%TYPE,
      ca_treaty_type_level    giac_module_entries.ca_treaty_type_level%TYPE,
      user_id                 giac_module_entries.user_id%TYPE,
      last_update             VARCHAR2(30),
      cpi_rec_no              giac_module_entries.cpi_rec_no%TYPE,
      cpi_branch_cd           giac_module_entries.cpi_branch_cd%TYPE,
      subline_level           giac_module_entries.subline_level%TYPE,
      neg_item_no             giac_module_entries.neg_item_no%TYPE,
      branch_level            giac_module_entries.branch_level%TYPE,
      max_item_no             giac_module_entries.item_no%TYPE
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_giac_modules(
      p_keyword         VARCHAR2
   ) RETURN giac_modules_tab PIPELINED;

   FUNCTION get_rec_list(
      p_module_id             giac_module_entries.module_id%TYPE,
      p_item_no               giac_module_entries.item_no%TYPE,
      p_gl_acct_category      giac_module_entries.gl_acct_category%TYPE,
      p_gl_control_acct       giac_module_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1         giac_module_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2         giac_module_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3         giac_module_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4         giac_module_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5         giac_module_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6         giac_module_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7         giac_module_entries.gl_sub_acct_7%TYPE,
      p_sl_type_cd            giac_module_entries.sl_type_cd%TYPE,
      p_line_dependency_level giac_module_entries.line_dependency_level%TYPE,
      p_subline_level         giac_module_entries.subline_level%TYPE,
      p_branch_level          giac_module_entries.branch_level%TYPE,
      p_intm_type_level       giac_module_entries.intm_type_level%TYPE,
      p_ca_treaty_type_level  giac_module_entries.ca_treaty_type_level%TYPE,
      p_old_new_acct_level    giac_module_entries.old_new_acct_level%TYPE,
      p_dr_cr_tag             giac_module_entries.dr_cr_tag%TYPE,
      p_pol_type_tag          giac_module_entries.pol_type_tag%TYPE
   ) RETURN rec_tab PIPELINED;

   PROCEDURE val_add_rec(
      p_module_id             giac_module_entries.module_id%TYPE,
      p_item_no               giac_module_entries.item_no%TYPE
   );

   PROCEDURE set_rec(p_rec giac_module_entries%ROWTYPE);
END;
/


