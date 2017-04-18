CREATE OR REPLACE PACKAGE CPI.giacs052_pkg
AS
   TYPE check_type IS RECORD (
      item_no           giac_chk_disbursement.item_no%TYPE,
      bank_cd           giac_chk_disbursement.bank_cd%TYPE,
      bank_sname        giac_banks.bank_sname%TYPE,
      bank_acct_cd      giac_chk_disbursement.bank_acct_cd%TYPE,
      bank_acct_no      giac_bank_accounts.bank_acct_no%TYPE,
      check_stat        giac_chk_disbursement.check_stat%TYPE,
      check_stat_mean   VARCHAR2 (100),
      payee             giac_chk_disbursement.payee%TYPE,
      amount            giac_chk_disbursement.amount%TYPE,
      short_name        giis_currency.short_name%TYPE,
      check_date        VARCHAR2 (20)
   );

   TYPE check_tab IS TABLE OF check_type;

   FUNCTION get_checks_lov (p_tran_id giac_chk_disbursement.gacc_tran_id%TYPE, p_find_text VARCHAR2)
      RETURN check_tab PIPELINED;

   PROCEDURE on_load_giacs052 (
      p_gacc_tran_id        IN       giac_chk_disbursement.gacc_tran_id%TYPE,
      p_item_no             OUT      giac_chk_disbursement.item_no%TYPE,
      p_bank_cd             OUT      giac_chk_disbursement.bank_cd%TYPE,
      p_bank_sname          OUT      giac_banks.bank_sname%TYPE,
      p_bank_acct_cd        OUT      giac_chk_disbursement.bank_acct_cd%TYPE,
      p_bank_acct_no        OUT      giac_bank_accounts.bank_acct_no%TYPE,
      p_check_stat          OUT      giac_chk_disbursement.check_stat%TYPE,
      p_check_stat_mean     OUT      VARCHAR2,
      p_payee               OUT      giac_chk_disbursement.payee%TYPE,
      p_check_date          OUT      VARCHAR2,
      p_disb_mode           OUT      giac_chk_disbursement.disb_mode%TYPE,
      p_still_with_check    OUT      VARCHAR2,
      p_gen_transfer_no     OUT      VARCHAR2,
      p_edit_check_no       OUT      VARCHAR2,
      p_allow_dv_printing   OUT      VARCHAR2,
      p_dv_approved_by      OUT      giac_disb_vouchers.dv_approved_by%TYPE,
      p_dv_flag             OUT      giac_disb_vouchers.dv_flag%TYPE,
      p_dv_flag_mean        OUT      cg_ref_codes.rv_meaning%TYPE

   );

   PROCEDURE default_check (
      p_print_prsd          IN       VARCHAR2,
      p_disb_mode           IN       giac_chk_disbursement.disb_mode%TYPE,
      p_bank_cd             IN       giac_chk_disbursement.bank_cd%TYPE,
      p_bank_sname          IN       giac_banks.bank_sname%TYPE,
      p_bank_acct_cd        IN       giac_chk_disbursement.bank_acct_cd%TYPE,
      p_print_check         IN       VARCHAR2,
      p_branch_cd           IN       giac_branches.branch_cd%TYPE,
      p_fund_cd             IN       giac_branches.gfun_fund_cd%TYPE,
      p_check_pref          OUT      VARCHAR2,
      p_check_no            OUT      VARCHAR2,
      p_check_no_required   OUT      VARCHAR2
   );

   PROCEDURE process_aft_print (
      p_gacc_tran_id              giac_chk_disbursement.gacc_tran_id%TYPE,
      p_fund_cd                   giac_branches.gfun_fund_cd%TYPE,
      p_branch_cd                 giac_branches.branch_cd%TYPE,
      p_item_no                   giac_chk_disbursement.item_no%TYPE,
      p_bank_cd                   giac_chk_disbursement.bank_cd%TYPE,
      p_bank_acct_cd              giac_chk_disbursement.bank_acct_cd%TYPE,
      p_user_id                   giis_users.user_id%TYPE,
      p_check_dv_print            VARCHAR2,
      p_print_dv                  VARCHAR2,
      p_print_check               VARCHAR2,
      p_check_date                giac_chk_disbursement.check_date%TYPE,
      p_disb_mode                 giac_chk_disbursement.disb_mode%TYPE,
      p_dv_flag          IN OUT   VARCHAR2,
      p_check_cnt                 VARCHAR2,
      p_prt_dv                    VARCHAR2,
      p_prt_chk                   VARCHAR2,
      p_document_cd               giac_payt_requests.document_cd%TYPE, -- added by: Nica 06.11.2013 AC-SPECS-2012-153
      p_chk_prefix       IN OUT   VARCHAR2,
      p_check_no         IN OUT   VARCHAR2,
      p_still_with_check OUT         VARCHAR2,
      p_dv_flag_mean     OUT      VARCHAR2
   );

   PROCEDURE update_giac (
      p_gacc_tran_id   giac_chk_disbursement.gacc_tran_id%TYPE,
      p_branch_cd      giac_branches.branch_cd%TYPE,
      p_fund_cd        giac_branches.gfun_fund_cd%TYPE
   );

   PROCEDURE spoil_check (
      p_gacc_tran_id     giac_chk_disbursement.gacc_tran_id%TYPE,
      p_item_no          giac_chk_disbursement.item_no%TYPE,
      p_fund_cd          giac_branches.gfun_fund_cd%TYPE,
      p_branch_cd        giac_branches.branch_cd%TYPE,
      p_user_id          giis_users.user_id%TYPE,
      p_check_dv_print   VARCHAR2,
      p_check_cnt        VARCHAR2

   );

   PROCEDURE restore_check (
      p_gacc_tran_id     giac_chk_disbursement.gacc_tran_id%TYPE,
      p_item_no          giac_chk_disbursement.item_no%TYPE,
      p_fund_cd          giac_branches.gfun_fund_cd%TYPE,
      p_branch_cd        giac_branches.branch_cd%TYPE,
      p_user_id          giis_users.user_id%TYPE,
      p_bank_cd          giac_chk_disbursement.bank_cd%TYPE,
      p_bank_acct_cd     giac_chk_disbursement.bank_acct_cd%TYPE,
      p_check_date       giac_chk_disbursement.check_date%TYPE,
      p_check_dv_print   VARCHAR2,
      p_check_cnt        VARCHAR2,
      p_chk_prefix       VARCHAR2,
      p_check_no         VARCHAR2
   );

   PROCEDURE check_dup_or(
      p_bank_cd          giac_chk_disbursement.bank_cd%TYPE,
      p_bank_acct_cd     giac_chk_disbursement.bank_acct_cd%TYPE,
      p_chk_prefix       VARCHAR2,
      p_check_no         VARCHAR2
   );

   PROCEDURE aeg_check_chart_of_accts
    (cca_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
     cca_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
     cca_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
     cca_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
     cca_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
     cca_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
     cca_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
     cca_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
     cca_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
     cca_gl_acct_id   IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE );

   PROCEDURE aeg_insert_update_acct_entries
    (p_fund_cd                GIIS_FUNDS.fund_cd%TYPE,
     p_branch_cd             GIAC_BRANCHES.branch_cd%TYPE,
     p_tran_id                GIAC_ACCTRANS.tran_id%TYPE,
     p_user_id              GIAC_ACCT_ENTRIES.user_id%TYPE,
     iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
     iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
     iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
     iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
     iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
     iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
     iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
     iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
     iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
     iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
     iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
     iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,
     iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
     iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
     iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE);

   PROCEDURE aeg_create_acct_entries
    (p_fund_cd                GIIS_FUNDS.fund_cd%TYPE,
     p_branch_cd             GIAC_BRANCHES.branch_cd%TYPE,
     p_tran_id                GIAC_ACCTRANS.tran_id%TYPE,
     p_user_id              GIAC_ACCT_ENTRIES.user_id%TYPE,
     aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
     aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
     aeg_acct_amt           GIAC_CM_DM.local_amt%TYPE,
     aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
     aeg_line_cd            GIIS_LINE.line_cd%TYPE, --mikel 09.30.2013
     aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE);

   PROCEDURE aeg_parameters
    (p_fund_cd              GIIS_FUNDS.fund_cd%TYPE,
     p_branch_cd            GIAC_BRANCHES.branch_cd%TYPE,
     p_user_id              GIAC_ACCT_ENTRIES.user_id%TYPE,
     aeg_tran_id            GIAC_ACCTRANS.tran_id%TYPE,
     aeg_module_nm          GIAC_MODULES.module_name%TYPE,
     aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE);

   FUNCTION INSERT_INTO_ACCTRANS (
     p_fund_cd              GIIS_FUNDS.fund_cd%TYPE,
     p_branch_cd            GIAC_BRANCHES.branch_cd%TYPE,
     p_memo_date            GIAC_ACCTRANS.tran_date%TYPE,
     p_user_id              GIAC_ACCTRANS.user_id%TYPE)

   RETURN NUMBER;

   PROCEDURE insert_into_cm_dm (p_gopp_tran_id GIAC_ACCTRANS.tran_id%TYPE,
                                p_user_id      GIAC_ACCTRANS.user_id%TYPE);

   PROCEDURE set_cm_dm_print_btn
    (p_tran_id          IN    GIAC_ACCTRANS.tran_id%TYPE,
     p_document_cd         OUT   GIAC_PAYT_REQUESTS.document_cd%TYPE,
     p_cm_dm_tran_id    OUT   GIAC_CM_DM.gacc_tran_id%TYPE,
     p_memo_status        OUT   GIAC_CM_DM.memo_status%TYPE,
     p_print_tag        OUT   GIAC_DISB_VOUCHERS.print_tag%TYPE,
     p_cm_tag           OUT   NUMBER,
     p_enable_print     OUT   VARCHAR2);
END giacs052_pkg;
/
