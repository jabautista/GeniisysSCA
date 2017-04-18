CREATE OR REPLACE PACKAGE CPI.giacs046_pkg
AS
   TYPE acc_check_release_info_type IS RECORD (
      check_number         VARCHAR2 (30),
      check_date           giac_chk_disbursement.check_date%TYPE,
      dv_number            VARCHAR2 (30),
      dv_no                giac_disb_vouchers.dv_no%TYPE,
      payee                giac_chk_disbursement.payee%TYPE,
      short_name           giis_currency.short_name%TYPE,
      fcurrency_amt        giac_chk_disbursement.fcurrency_amt%TYPE,
      bank_sname           giac_banks.bank_sname%TYPE,
      bank_acct_no         giac_bank_accounts.bank_acct_no%TYPE,
      amount               giac_chk_disbursement.amount%TYPE,
      particulars          giac_disb_vouchers.particulars%TYPE,
      check_release_date   giac_chk_release_info.check_release_date%TYPE,
      or_no                giac_chk_release_info.or_no%TYPE,
      check_released_by    giac_chk_release_info.check_released_by%TYPE,
      or_date              giac_chk_release_info.or_date%TYPE,
      check_received_by    giac_chk_release_info.check_received_by%TYPE,
      user_id              giac_chk_release_info.user_id%TYPE,
      last_update          VARCHAR2 (30),
      gacc_tran_id         giac_chk_disbursement.gacc_tran_id%TYPE,
      item_no              giac_chk_disbursement.item_no%TYPE,
      check_pref_suf       giac_chk_disbursement.check_pref_suf%TYPE,
      check_no             giac_chk_disbursement.check_no%TYPE,
      --SR19642 lara 07082015
      check_stat           cg_ref_codes.RV_MEANING%TYPE, 
      dv_stat              cg_ref_codes.RV_MEANING%TYPE
      --end SR19642
   );

   TYPE acc_check_release_info_tab IS TABLE OF acc_check_release_info_type;

   FUNCTION get_list_check_release_info (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN acc_check_release_info_tab PIPELINED;

   FUNCTION get_list_check_release_infou (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN acc_check_release_info_tab PIPELINED;

   FUNCTION get_list_check_release_infor (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN acc_check_release_info_tab PIPELINED;

   PROCEDURE set_check_release_info (
      v_tran_id              IN   giac_chk_release_info.gacc_tran_id%TYPE,
      v_item_no              IN   giac_chk_release_info.item_no%TYPE,
      v_check_no             IN   giac_chk_release_info.check_no%TYPE,
      v_check_release_date   IN   giac_chk_release_info.check_release_date%TYPE,
      v_check_release_by     IN   giac_chk_release_info.check_released_by%TYPE,
      v_check_receive_by     IN   giac_chk_release_info.check_received_by%TYPE,
      v_check_pref_suf       IN   giac_chk_release_info.check_pref_suf%TYPE,
      v_or_no                IN   giac_chk_release_info.or_no%TYPE,
      v_or_date              IN   giac_chk_release_info.or_no%TYPE,
      v_user_id              IN   giac_chk_release_info.user_id%TYPE
   );
   
   TYPE branch_cd_lov_type IS RECORD (
      branch_cd     giac_branches.branch_cd%TYPE,
      branch_name   giac_branches.branch_name%TYPE
   );

   TYPE branch_cd_lov_tab IS TABLE OF branch_cd_lov_type;
   
   FUNCTION get_branch_lov (
     p_module_id      giis_modules.module_id%TYPE,
     p_user_id        giis_users.user_id%TYPE,
     p_keyword        VARCHAR2
   )
   
   RETURN branch_cd_lov_tab PIPELINED;
END;
/
