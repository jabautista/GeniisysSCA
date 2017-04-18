CREATE OR REPLACE PACKAGE CPI.giacs303_pkg
AS
   PROCEDURE new_form_instance (
      p_fund_cd              OUT   giis_funds.fund_cd%TYPE,
      p_fund_desc            OUT   giis_funds.fund_desc%TYPE,
      p_sap_integration_sw   OUT   giac_parameters.param_value_v%TYPE
   );

   TYPE branch_type IS RECORD (
      gfun_fund_cd         giac_branches.gfun_fund_cd%TYPE,
      branch_cd            giac_branches.branch_cd%TYPE,
      branch_name          giac_branches.branch_name%TYPE,
      acct_branch_cd       giac_branches.acct_branch_cd%TYPE,
      comp_cd              giac_branches.comp_cd%TYPE,
      check_dv_print       giac_branches.check_dv_print%TYPE,
      dsp_check_dv_print   cg_ref_codes.rv_meaning%TYPE,
      bank_cd              giac_branches.bank_cd%TYPE,
      dsp_bank_name        giac_banks.bank_name%TYPE, 
      bank_acct_cd         giac_branches.bank_acct_cd%TYPE,
      dsp_bank_acct_no     giac_bank_accounts.bank_acct_no%TYPE,
      bir_permit           giac_branches.bir_permit%TYPE,
      branch_tin           giac_branches.branch_tin%TYPE,
      address1             giac_branches.address1%TYPE,
      address2             giac_branches.address2%TYPE,
      address3             giac_branches.address3%TYPE,
      tel_no               giac_branches.tel_no%TYPE,
      remarks              giac_branches.remarks%TYPE,
      user_id              giac_branches.user_id%TYPE,
      last_update          VARCHAR2(30)
   );

   TYPE branch_tab IS TABLE OF branch_type;

   FUNCTION get_branch_list (
      p_gfun_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_branch_cd        giac_branches.branch_cd%TYPE,
      p_acct_branch_cd          giac_branches.acct_branch_cd%TYPE,
      p_branch_name      giac_branches.branch_name%TYPE,
      p_comp_code        giac_branches.comp_cd%TYPE,
      p_check_dv_print   cg_ref_codes.rv_meaning%TYPE
   )
      RETURN branch_tab PIPELINED;

   TYPE bank_lov_type IS RECORD (
      bank_cd     giac_bank_accounts.bank_cd%TYPE,
      bank_name   giac_banks.bank_name%TYPE
   );

   TYPE bank_lov_tab IS TABLE OF bank_lov_type;

   FUNCTION get_bank_lov (p_find_text VARCHAR2)
      RETURN bank_lov_tab PIPELINED;

   TYPE bank_acct_lov_type IS RECORD (
      branch_cd        giac_bank_accounts.branch_cd%TYPE,
      bank_acct_cd     giac_bank_accounts.bank_acct_cd%TYPE,
      bank_acct_no     giac_bank_accounts.bank_acct_no%TYPE,
      bank_acct_type   giac_bank_accounts.bank_acct_type%TYPE
   );

   TYPE bank_acct_lov_tab IS TABLE OF bank_acct_lov_type;

   FUNCTION get_bank_acct_lov (p_bank_cd giac_bank_accounts.bank_cd%TYPE, p_find_text VARCHAR2)
      RETURN bank_acct_lov_tab PIPELINED;

   TYPE check_dv_print_lov_type IS RECORD (
      rv_low_value   cg_ref_codes.rv_low_value%TYPE,
      rv_meaning     cg_ref_codes.rv_meaning%TYPE
   );

   TYPE check_dv_print_lov_tab IS TABLE OF check_dv_print_lov_type;

   FUNCTION get_check_dv_print_lov (p_find_text VARCHAR2)
      RETURN check_dv_print_lov_tab PIPELINED;

   PROCEDURE update_branch (
      p_fund_cd          giac_branches.gfun_fund_cd%TYPE,
      p_branch_cd        giac_branches.branch_cd%TYPE,
      p_bank_cd          giac_branches.bank_cd%TYPE,
      p_bank_acct_cd     giac_branches.bank_acct_cd%TYPE,
      p_bir_permit       giac_branches.bir_permit%TYPE,
      p_check_dv_print   giac_branches.check_dv_print%TYPE,
      p_comp_cd          giac_branches.comp_cd%TYPE,
      p_remarks          giac_branches.remarks%TYPE
   );

   PROCEDURE val_delete_branch (
      p_check_both     IN   BOOLEAN,
      p_branch_cd      IN   VARCHAR2,
      p_gfun_fund_cd   IN   VARCHAR2
   );
END;
/


