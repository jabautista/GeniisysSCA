CREATE OR REPLACE PACKAGE CPI.GIACS081_PKG AS

    TYPE replenish_branch_type IS RECORD(
        branch_cd       GIAC_BRANCHES.branch_cd%TYPE,
        branch_name     GIAC_BRANCHES.branch_name%TYPE
    );
    
    TYPE replenish_branch_tab IS TABLE OF replenish_branch_type;

    TYPE replenish_rev_fund_type IS RECORD (
        replenish_id        giac_replenish_dv.replenish_id%TYPE,
        branch_cd           giac_replenish_dv.branch_cd%TYPE,
        branch              VARCHAR2(100),
        check_date_from     VARCHAR2(100),
        check_date_to       VARCHAR2(100),
        replenishment_no    VARCHAR2(100),
        replenish_seq_no    giac_replenish_dv.replenish_seq_no%TYPE,
        revolving_fund_amt  giac_replenish_dv.revolving_fund_amt%TYPE,
        replenishment_amt   giac_replenish_dv.replenishment_amt%TYPE,
        replenish_tran_id   giac_replenish_dv.replenish_tran_id%TYPE,
        replenish_year      giac_replenish_dv.replenish_year%TYPE,
        create_by           giac_replenish_dv.create_by%TYPE,
        create_date         giac_replenish_dv.create_date%TYPE
    );
    
    TYPE replenish_rev_fund_tab IS TABLE OF replenish_rev_fund_type;
    
    TYPE replenish_detail_type IS RECORD (
        replenish_id        giac_replenish_dv_dtl.replenish_id%TYPE,
        replenish_sw        VARCHAR2(50),
        check_date          VARCHAR2(50),--giac_chk_disbursement.check_date%TYPE,
        dv_tran_id          giac_replenish_dv_dtl.dv_tran_id%TYPE,
        --dv_pref             giac_disb_vouchers.dv_pref%TYPE,
        dv_no               VARCHAR2(100),
        --check_pref_suf      giac_chk_disbursement.check_pref_suf%TYPE,
        check_no            VARCHAR2(100),
        request_no          VARCHAR2(100),
        --gprq_ref_id         giac_disb_vouchers.gprq_ref_id%TYPE,
        check_item_no       giac_replenish_dv_dtl.check_item_no%TYPE,
        payee               giac_disb_vouchers.payee%TYPE,
        particulars         giac_disb_vouchers.particulars%TYPE,
        amount              giac_replenish_dv_dtl.amount%TYPE
    );
    
    TYPE replenish_detail_tab IS TABLE OF replenish_detail_type;
    
    TYPE rep_acct_entries_type IS RECORD (
      gl_acct_code          VARCHAR2 (500),
      sl_cd                 VARCHAR2 (12),
      debit_amt             giac_acct_entries.debit_amt%TYPE,
      credit_amt            giac_acct_entries.credit_amt%TYPE,
      gl_acct_name          VARCHAR2 (500),
      sl_name               VARCHAR2 (500),
      replenish_id          giac_replenish_dv_dtl.replenish_id%TYPE,
      gacc_tran_id          giac_acct_entries.gacc_tran_id%TYPE,
      branch_cd             giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      fund_cd               giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      total_debit           giac_acct_entries.debit_amt%TYPE,
      total_credit          giac_acct_entries.credit_amt%TYPE,
      balance               giac_acct_entries.credit_amt%TYPE
    );
    
    TYPE rep_acct_entries_tab IS TABLE OF rep_acct_entries_type;
    
    FUNCTION get_replenishment_branch(
        p_branch            giac_branches.branch_name%TYPE,
        p_user_id            giis_users.user_id%TYPE
    )
        RETURN replenish_branch_tab PIPELINED;

    FUNCTION get_replenishment(p_user_id  VARCHAR2) -- added parameter : shan 10.08.2014        
        RETURN replenish_rev_fund_tab PIPELINED;    

    FUNCTION get_replenishment_details(
        p_replenish_id      giac_replenish_dv_dtl.replenish_id%TYPE,
        p_branch_cd         giac_branches.branch_cd%TYPE,
        p_check_date_from   VARCHAR2,
        p_check_date_to     VARCHAR2,
        p_modify_rec        VARCHAR2
    )        
        RETURN replenish_detail_tab PIPELINED;
        
   FUNCTION get_rep_acct_entries(
        p_tran_id           giac_acct_entries.gacc_tran_id%TYPE
   )
        RETURN rep_acct_entries_tab PIPELINED;

    FUNCTION get_rep_sum_acct_entries(
        p_replenish_id      giac_replenish_dv_dtl.replenish_id%TYPE
    )
        RETURN rep_acct_entries_tab PIPELINED;
    
    PROCEDURE set_replenish_master_record(
        p_branch_cd          giac_replenish_dv.branch_cd%TYPE,
        p_revolving_fund     giac_replenish_dv.revolving_fund_amt%TYPE,
        p_total_tagged       giac_replenish_dv.replenishment_amt%TYPE,
        p_user_id            giis_users.user_id%TYPE
    );
    
    PROCEDURE set_rev_fund(
        p_replenish_id       giac_replenish_dv.replenish_id%TYPE,
        p_revolving_fund     giac_replenish_dv.revolving_fund_amt%TYPE
    );
    
    PROCEDURE set_replenish_dv(
        p_replenish_id       giac_replenish_dv.replenish_id%TYPE,
        p_revolving_fund     giac_replenish_dv.revolving_fund_amt%TYPE,
        p_total_tagged       giac_replenish_dv.replenishment_amt%TYPE,
        p_user_id            giis_users.user_id%TYPE
    );
    
    PROCEDURE set_replenish_detail(
        p_replenish_id       giac_replenish_dv.replenish_id%TYPE,
        p_tran_id            giac_replenish_dv_dtl.dv_tran_id%TYPE,
        p_item_no            giac_replenish_dv_dtl.check_item_no%TYPE,
        p_amount             giac_replenish_dv_dtl.amount%TYPE            
    );       
        
END GIACS081_PKG;
/


