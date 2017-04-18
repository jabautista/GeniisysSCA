CREATE OR REPLACE PACKAGE CPI.giac_check_status_pkg
AS
   TYPE giac_bank_type IS RECORD (
      bank_name      giac_banks.bank_name%TYPE,
      bank_cd        giac_banks.bank_cd%TYPE,
      bank_acct_no   giac_bank_accounts.bank_acct_no%TYPE,
      bank_acct_cd   giac_bank_accounts.bank_acct_cd%TYPE
   );

   TYPE giac_bank_tab IS TABLE OF giac_bank_type;

   TYPE giac_disbursement_type IS RECORD (
      gacc_tran_id         giac_chk_disbursement.gacc_tran_id%TYPE,
      gibr_branch_cd       giac_disb_vouchers.gibr_branch_cd%TYPE,
      branch_name          giac_branches.branch_name%TYPE,
      item_no              giac_chk_disbursement.item_no%TYPE,
      bank_cd              giac_chk_disbursement.bank_cd%TYPE,
      bank_acct_cd         giac_chk_disbursement.bank_acct_cd%TYPE,
      check_pref_suf       giac_chk_disbursement.check_pref_suf%TYPE,
      check_no             giac_chk_disbursement.check_no%TYPE,
      check_date           VARCHAR2 (30),
      payee                giac_chk_disbursement.payee%TYPE,
      amount               giac_chk_disbursement.amount%TYPE,
      check_release_date   VARCHAR2 (30),
      clearing_date        VARCHAR2 (30)
   );

   TYPE giac_disbursement_tab IS TABLE OF giac_disbursement_type;

   FUNCTION get_bank_info (p_branch_cd giac_bank_accounts.branch_cd%TYPE)
      RETURN giac_bank_tab PIPELINED;

   FUNCTION get_chk_disbursement (
      p_bank_cd        giac_banks.bank_cd%TYPE,
      p_bank_acct_cd   giac_bank_accounts.bank_acct_cd%TYPE,
      p_branch_cd      VARCHAR2,        -- shan 11.10.2014
      p_from_date      DATE,
      p_to_date        DATE,
      p_status         NUMBER
   )
      RETURN giac_disbursement_tab PIPELINED;

   PROCEDURE update_date (
      p_clearing_date        IN   giac_chk_release_info.clearing_date%TYPE,
      p_check_release_date   IN   giac_chk_release_info.check_release_date%TYPE,
      p_gacc_tran_id         IN   giac_chk_release_info.gacc_tran_id%TYPE,
      p_user_id              IN   giis_users.user_id%TYPE
   );

   PROCEDURE get_branch (
      p_tran_id       IN       giac_chk_disbursement.gacc_tran_id%TYPE,
      p_branch_cd     OUT      VARCHAR2,
      p_branch_name   OUT      VARCHAR2
   );
END;
/


