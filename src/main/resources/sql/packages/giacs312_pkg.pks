CREATE OR REPLACE PACKAGE CPI.giacs312_pkg
AS
   TYPE gl_acct_list_type IS RECORD (
      gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE,
      gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE,
      gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      gslt_sl_type_cd    giac_chart_of_accts.gslt_sl_type_cd%TYPE,
      sl_type_name       giac_sl_types.sl_type_name%TYPE
   );

   TYPE gl_acct_list_tab IS TABLE OF gl_acct_list_type;

   TYPE giac_banks_type IS RECORD (
      bank_name    giac_banks.bank_name%TYPE,
      bank_sname   giac_banks.bank_sname%TYPE,
      bank_cd      giac_banks.bank_cd%TYPE
   );

   TYPE giac_banks_tab IS TABLE OF giac_banks_type;

   TYPE rec_type IS RECORD (
      bank_cd                 giac_bank_accounts.bank_cd%TYPE,
      dsp_bank_sname          giac_banks.bank_sname%TYPE,
      dsp_bank_name           giac_banks.bank_name%TYPE,
      bank_acct_cd            giac_bank_accounts.bank_acct_cd%TYPE,
      branch_bank             giac_bank_accounts.branch_bank%TYPE,
      bank_acct_no            giac_bank_accounts.bank_acct_no%TYPE,
      branch_cd               giac_bank_accounts.branch_cd%TYPE,
      dsp_branch_name         giis_issource.iss_name%TYPE,
      bank_acct_type          giac_bank_accounts.bank_acct_type%TYPE,
      dsp_bank_acct_type      cg_ref_codes.rv_meaning%TYPE,
      bank_account_flag       giac_bank_accounts.bank_account_flag%TYPE,
      dsp_bank_account_flag   cg_ref_codes.rv_meaning%TYPE,
      opening_date            VARCHAR2 (30),
      closing_date            VARCHAR2 (30),
      gl_acct_id              giac_bank_accounts.gl_acct_id%TYPE,
      dsp_gl_acct_category    giac_chart_of_accts.gl_acct_category%TYPE,
      dsp_gl_control_acct     giac_chart_of_accts.gl_control_acct%TYPE,
      dsp_gl_sub_acct_1       giac_chart_of_accts.gl_sub_acct_1%TYPE,
      dsp_gl_sub_acct_2       giac_chart_of_accts.gl_sub_acct_2%TYPE,
      dsp_gl_sub_acct_3       giac_chart_of_accts.gl_sub_acct_3%TYPE,
      dsp_gl_sub_acct_4       giac_chart_of_accts.gl_sub_acct_4%TYPE,
      dsp_gl_sub_acct_5       giac_chart_of_accts.gl_sub_acct_5%TYPE,
      dsp_gl_sub_acct_6       giac_chart_of_accts.gl_sub_acct_6%TYPE,
      dsp_gl_sub_acct_7       giac_chart_of_accts.gl_sub_acct_7%TYPE,
      dsp_gl_acct_name        giac_chart_of_accts.gl_acct_name%TYPE,
      sl_cd                   giac_bank_accounts.sl_cd%TYPE,
      dsp_sl_type_name        giac_sl_types.sl_type_name%TYPE,
      remarks                 giac_bank_accounts.remarks%TYPE,
      user_id                 giac_bank_accounts.user_id%TYPE,
      last_update             VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_gl_acct_lov (p_find VARCHAR2)
      RETURN gl_acct_list_tab PIPELINED;

   FUNCTION get_rec_list (
      p_user_id          giis_users.user_id%TYPE,
      p_bank_acct_cd     giac_bank_accounts.bank_acct_cd%TYPE,
      p_dsp_bank_sname   giac_banks.bank_sname%TYPE,
      p_dsp_bank_name    giac_banks.bank_name%TYPE,
      p_branch_bank      giac_bank_accounts.branch_bank%TYPE,
      p_bank_acct_no     giac_bank_accounts.bank_acct_no%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giac_bank_accounts%ROWTYPE);

   PROCEDURE del_rec (
      p_bank_cd        giac_bank_accounts.bank_cd%TYPE,
      p_bank_acct_cd   giac_bank_accounts.bank_acct_cd%TYPE
   );

   PROCEDURE val_del_rec (
      p_bank_cd        giac_bank_accounts.bank_cd%TYPE,
      p_bank_acct_cd   giac_bank_accounts.bank_acct_cd%TYPE
   );

   PROCEDURE val_add_rec (p_bank_acct_cd giac_bank_accounts.bank_acct_cd%TYPE);

   FUNCTION get_giac_bank_lov (p_find_text VARCHAR2)
      RETURN giac_banks_tab PIPELINED;
END;
/


