CREATE OR REPLACE PACKAGE CPI.GIACS354_WEB_PKG AS   

    TYPE prev_extract_type IS RECORD(
        from_date   VARCHAR2(32),
        vto_date    VARCHAR2(32),
        date_tag    giac_batch_check_gross_ext.date_tag%TYPE,
        v_exists    VARCHAR2(8)
    );
    TYPE prev_extract_tab IS TABLE OF prev_extract_type;
    
    TYPE gross_type IS RECORD(
        line_cd         giac_batch_check_gross_ext.line_cd%TYPE,
        line_name       giis_line.line_name%TYPE,
        gl_acct_sname   giac_batch_check_gross_ext.gl_acct_sname%TYPE,
        prem_amt        giac_batch_check_gross_ext.prem_amt%TYPE,
        balance         giac_batch_check_gross_ext.balance%TYPE,
        difference      giac_batch_check_gross_ext.balance%TYPE,
        base_amt        giac_batch_check_gross_ext.base_amt%TYPE,
        prem_amt_tot    NUMBER(16, 2),
        balance_tot     NUMBER(16, 2),
        difference_tot  NUMBER(16, 2)
    );
    TYPE gross_tab IS TABLE OF gross_type;
    
    TYPE gross_dtl_type IS RECORD(
        policy_no       giac_batch_check_gross_dtl_ext.policy_no%TYPE,
        pol_flag        giac_batch_check_gross_dtl_ext.pol_flag%TYPE,
        uw_amount       giac_batch_check_gross_dtl_ext.uw_amount%TYPE,
        gl_amount       giac_batch_check_gross_dtl_ext.gl_amount%TYPE,
        difference      NUMBER(16, 2),
        uw_amount_tot   NUMBER(16, 2),
        gl_amount_tot   NUMBER(16, 2),
        difference_tot  NUMBER(16, 2)
    );
    TYPE gross_dtl_tab IS TABLE OF gross_dtl_type;
    
    TYPE facul_type IS RECORD(
        line_cd         giac_batch_check_facul_ext.line_cd%TYPE,
        line_name       giis_line.line_name%TYPE,
        gl_acct_sname   giac_batch_check_facul_ext.gl_acct_sname%TYPE,
        prem_amt        giac_batch_check_facul_ext.prem_amt%TYPE,
        balance         giac_batch_check_facul_ext.balance%TYPE,
        difference      giac_batch_check_facul_ext.balance%TYPE,
        base_amt        giac_batch_check_gross_ext.base_amt%TYPE,
        prem_amt_tot    NUMBER(16, 2),
        balance_tot     NUMBER(16, 2),
        difference_tot  NUMBER(16, 2)
    );
    TYPE facul_tab IS TABLE OF facul_type;

    TYPE facul_dtl_type IS RECORD(
        policy_no       giac_batch_check_facul_dtl_ext.policy_no%TYPE,
        binder_no       giac_batch_check_facul_dtl_ext.binder_no%TYPE,
        uw_amount       giac_batch_check_facul_dtl_ext.uw_amount%TYPE,
        gl_amount       giac_batch_check_facul_dtl_ext.gl_amount%TYPE,
        difference      NUMBER(16, 2),
        uw_amount_tot   NUMBER(16, 2),
        gl_amount_tot   NUMBER(16, 2),
        difference_tot  NUMBER(16, 2)
    );
    TYPE facul_dtl_tab IS TABLE OF facul_dtl_type;    
    
    TYPE treaty_type IS RECORD(
        line_cd         giac_batch_check_treaty_ext.line_cd%TYPE,
        line_name       giis_line.line_name%TYPE,
        gl_acct_sname   giac_batch_check_treaty_ext.gl_acct_sname%TYPE,
        prem_amt        giac_batch_check_treaty_ext.prem_amt%TYPE,
        balance         giac_batch_check_treaty_ext.balance%TYPE,
        difference      giac_batch_check_treaty_ext.balance%TYPE,
        base_amt        giac_batch_check_gross_ext.base_amt%TYPE,
        prem_amt_tot    NUMBER(16, 2),
        balance_tot     NUMBER(16, 2),
        difference_tot  NUMBER(16, 2)
    );
    TYPE treaty_tab IS TABLE OF treaty_type;

    TYPE treaty_dtl_type IS RECORD(
        policy_no       giac_batch_check_trty_dtl_ext.policy_no%TYPE,
        dist_no         giac_batch_check_trty_dtl_ext.dist_no%TYPE,
        uw_amount       giac_batch_check_trty_dtl_ext.uw_amount%TYPE,
        gl_amount       giac_batch_check_trty_dtl_ext.gl_amount%TYPE,
        difference      NUMBER(16, 2),
        uw_amount_tot   NUMBER(16, 2),
        gl_amount_tot   NUMBER(16, 2),
        difference_tot  NUMBER(16, 2)
    );
    TYPE treaty_dtl_tab IS TABLE OF treaty_dtl_type;    

    TYPE net_type IS RECORD(
        line_cd         giac_batch_check_treaty_ext.line_cd%TYPE,
        line_name       giis_line.line_name%TYPE,
        gross_amt       giac_batch_check_gross_ext.prem_amt%TYPE,
        facul_amt       giac_batch_check_facul_ext.prem_amt%TYPE,
        treaty_amt      giac_batch_check_treaty_ext.prem_amt%TYPE,
        difference      giac_batch_check_treaty_ext.prem_amt%TYPE,
        gross_total     giac_batch_check_treaty_ext.prem_amt%TYPE,
        facul_total     giac_batch_check_treaty_ext.prem_amt%TYPE,
        treaty_total    giac_batch_check_treaty_ext.prem_amt%TYPE,
        diff_total      giac_batch_check_treaty_ext.prem_amt%TYPE
    );
    TYPE net_tab IS TABLE OF net_type;
    
    TYPE giacr354_rec_type IS RECORD (
      branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
      line_cd          giis_line.line_cd%TYPE,
      gl_acct_no       VARCHAR2 (30),
      gl_acct_name     giac_chart_of_accts.gl_acct_name%TYPE,
      acct_trty_type   giis_dist_share.acct_trty_type%TYPE,
      base_amt         VARCHAR2 (50),
      gl_amount        giac_acct_entries.debit_amt%TYPE,
      uw_amount        giac_acct_entries.debit_amt%TYPE,
      variances        giac_acct_entries.debit_amt%TYPE
   );
   TYPE giacr354_type IS TABLE OF giacr354_rec_type;

   TYPE giacr354_gl_rec_type IS RECORD (
      gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      line_cd          giis_line.line_cd%TYPE,
      gl_acct_no       VARCHAR2 (30),
      gl_acct_name     giac_chart_of_accts.gl_acct_name%TYPE,
      tran_id          giac_acctrans.tran_id%TYPE,
      tran_class       giac_acctrans.tran_class%TYPE,
      balance          giac_acct_entries.debit_amt%TYPE,
      acct_trty_type   giis_dist_share.acct_trty_type%TYPE
   );
   TYPE giacr354_gl_type IS TABLE OF giacr354_gl_rec_type;

   TYPE giacr354_tb_reg_rec_type IS RECORD (
      gl_acct_no     VARCHAR2 (30),
      gl_acct_name   giac_chart_of_accts.gl_acct_name%TYPE,
      cash_reg_dr    giac_acct_entries.debit_amt%TYPE,
      cash_reg_cr    giac_acct_entries.credit_amt%TYPE,
      disb_reg_dr    giac_acct_entries.debit_amt%TYPE,
      disb_reg_cr    giac_acct_entries.credit_amt%TYPE,
      jv_reg_dr      giac_acct_entries.debit_amt%TYPE,
      jv_reg_cr      giac_acct_entries.credit_amt%TYPE,
      tb_debit       giac_acct_entries.debit_amt%TYPE,
      tb_credit      giac_acct_entries.credit_amt%TYPE,
      variances      giac_acct_entries.debit_amt%TYPE
   );
   TYPE giacr354_tb_reg_type IS TABLE OF giacr354_tb_reg_rec_type;

   TYPE giacr354_brdrx_rec_type IS RECORD (
      branch_cd      giac_acctrans.gibr_branch_cd%TYPE,
      line_cd        giis_line.line_cd%TYPE,
      gl_acct_no     VARCHAR2 (30),
      gl_acct_name   giac_chart_of_accts.gl_acct_name%TYPE,
      base_amt       VARCHAR2 (50),
      gl_amount      giac_acct_entries.debit_amt%TYPE,
      brdrx_amount   giac_acct_entries.debit_amt%TYPE,
      variances      giac_acct_entries.debit_amt%TYPE
   );
   TYPE giacr354_brdrx_reg_type IS TABLE OF giacr354_brdrx_rec_type;

   TYPE giacr354_brdrx_dtl_rec_type IS RECORD (
      line_cd        giis_line.line_cd%TYPE,
      claim_no       VARCHAR2 (100),
      claim_id       gicl_claims.claim_id%TYPE,
      item_no        NUMBER (9),
      peril_cd       NUMBER (5),
      base_amt       VARCHAR2 (50),
      gl_amount      giac_acct_entries.debit_amt%TYPE,
      brdrx_amount   giac_acct_entries.debit_amt%TYPE,
      variances      giac_acct_entries.debit_amt%TYPE
   );
   TYPE giacr354_brdrx_dtl_type IS TABLE OF giacr354_brdrx_dtl_rec_type;

   TYPE giacr354_dtl_rec_type IS RECORD (
      branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
      line_cd          giis_line.line_cd%TYPE,
      policy_id        gipi_invoice.policy_id%TYPE,
      policy_no        VARCHAR2 (50),
      pol_flag         VARCHAR2 (20),
      binder_no        VARCHAR2 (50),
      dist_no          giuw_pol_dist.dist_no%TYPE,
      acct_trty_type   giis_dist_share.acct_trty_type%TYPE,
      base_amt         VARCHAR2 (50),
      gl_amount        giac_acct_entries.debit_amt%TYPE,
      uw_amount        giac_acct_entries.debit_amt%TYPE,
      variances        giac_acct_entries.debit_amt%TYPE
   );
   TYPE giacr354_dtl_type IS TABLE OF giacr354_dtl_rec_type;

   TYPE giacr354_tax_rec_type IS RECORD (
      reference_no   VARCHAR2 (60),
      tran_id        giuw_pol_dist.dist_no%TYPE,
      gl_amount      giac_acct_entries.debit_amt%TYPE,
      tax_amount     giac_acct_entries.debit_amt%TYPE,
      variances      giac_acct_entries.debit_amt%TYPE
   );
   TYPE giacr354_tax_type IS TABLE OF giacr354_tax_rec_type;
   
    TYPE claim_type IS RECORD(
        line_cd         giac_batch_check_os_loss_ext.line_cd%TYPE,
        line_name       giis_line.line_name%TYPE,
        gl_acct_sname   giac_batch_check_os_loss_ext.gl_acct_sname%TYPE,
        brdrx_amt       giac_batch_check_os_loss_ext.brdrx_amt%TYPE,
        balance         giac_batch_check_os_loss_ext.balance%TYPE,
        from_date       giac_batch_check_os_loss_ext.from_date%TYPE,
        to_date         giac_batch_check_os_loss_ext.to_date%TYPE,
        user_id         giac_batch_check_os_loss_ext.user_id%TYPE,
        date_tag        giac_batch_check_os_loss_ext.date_tag%TYPE,
        base_amt        giac_batch_check_os_loss_ext.base_amt%TYPE,
        difference      giac_batch_check_os_loss_ext.brdrx_amt%TYPE,
        brdrx_tot       NUMBER(16, 2),
        balance_tot     NUMBER(16, 2),
        difference_tot  NUMBER(16, 2)
    );
    TYPE claim_tab IS TABLE OF claim_type;
    
    TYPE claim_dtl_type IS RECORD(
        claim_no        giac_batch_chk_os_loss_dtl_ext.claim_no%TYPE,
        item_no         giac_batch_chk_os_loss_dtl_ext.item_no%TYPE,
        peril_name      VARCHAR2(30),
        brdrx_amt       giac_batch_chk_os_loss_dtl_ext.brdrx_amt%TYPE,
        gl_amount       giac_batch_chk_os_loss_dtl_ext.gl_amount%TYPE,
        difference      giac_batch_chk_os_loss_dtl_ext.brdrx_amt%TYPE,
        brdrx_amt_tot   NUMBER(16, 2),
        gl_amount_tot   NUMBER(16, 2),
        difference_tot  NUMBER(16, 2)
    );
    TYPE claim_dtl_tab IS TABLE OF claim_dtl_type;
            
    FUNCTION check_prev_extract(
        p_batch_type    VARCHAR2,
        p_user_id       giac_batch_check_gross_ext.user_id%TYPE
    )
      RETURN prev_extract_tab PIPELINED;

    FUNCTION get_gross(
        p_from_date     VARCHAR2,     
        p_to_date       VARCHAR2,
        p_date_tag      giac_batch_check_gross_ext.date_tag%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_line_name     giis_line.line_name%TYPE,
        p_gl_acct_sname giac_batch_check_gross_ext.gl_acct_sname%TYPE,
        p_prem_amt      giac_batch_check_gross_ext.prem_amt%TYPE,
        p_balance       giac_batch_check_gross_ext.balance%TYPE,
        p_difference    NUMBER
    )
      RETURN gross_tab PIPELINED;
    
    FUNCTION get_gross_dtl(
        p_line_cd       giis_line.line_cd%TYPE,
        p_base_amt      giac_batch_check_gross_ext.base_amt%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_policy_no     giac_batch_check_gross_dtl_ext.policy_no%TYPE,
        p_pol_flag      giac_batch_check_gross_dtl_ext.pol_flag%TYPE,
        p_uw_amount     giac_batch_check_gross_dtl_ext.uw_amount%TYPE,
        p_gl_amount     giac_batch_check_gross_dtl_ext.gl_amount%TYPE,
        p_difference    NUMBER
    )
      RETURN gross_dtl_tab PIPELINED;

    FUNCTION get_facul(
        p_from_date     VARCHAR2,     
        p_to_date       VARCHAR2,
        p_date_tag      giac_batch_check_facul_ext.date_tag%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_line_name     giis_line.line_name%TYPE,
        p_gl_acct_sname giac_batch_check_gross_ext.gl_acct_sname%TYPE,
        p_prem_amt      giac_batch_check_gross_ext.prem_amt%TYPE,
        p_balance       giac_batch_check_gross_ext.balance%TYPE,
        p_difference    NUMBER
    )
      RETURN facul_tab PIPELINED;
    
    FUNCTION get_facul_dtl(
        p_line_cd       giis_line.line_cd%TYPE,
        p_base_amt      giac_batch_check_facul_ext.base_amt%TYPE,
        p_user_id       giac_batch_check_facul_ext.user_id%TYPE,
        p_policy_no     giac_batch_check_facul_dtl_ext.policy_no%TYPE,
        p_binder_no     giac_batch_check_facul_dtl_ext.binder_no%TYPE,
        p_uw_amount     giac_batch_check_facul_dtl_ext.uw_amount%TYPE,
        p_gl_amount     giac_batch_check_facul_dtl_ext.gl_amount%TYPE,
        p_difference    NUMBER
    )
      RETURN facul_dtl_tab PIPELINED;
    
    FUNCTION get_treaty(
        p_from_date     VARCHAR2,     
        p_to_date       VARCHAR2,
        p_date_tag      giac_batch_check_treaty_ext.date_tag%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_line_name     giis_line.line_name%TYPE,
        p_gl_acct_sname giac_batch_check_gross_ext.gl_acct_sname%TYPE,
        p_prem_amt      giac_batch_check_gross_ext.prem_amt%TYPE,
        p_balance       giac_batch_check_gross_ext.balance%TYPE,
        p_difference    NUMBER
    )
      RETURN treaty_tab PIPELINED;
    
    FUNCTION get_treaty_dtl(
        p_line_cd       giis_line.line_cd%TYPE,
        p_base_amt      giac_batch_check_treaty_ext.base_amt%TYPE,
        p_user_id       giac_batch_check_treaty_ext.user_id%TYPE,
        p_policy_no     giac_batch_check_trty_dtl_ext.policy_no%TYPE,
        p_dist_no       giac_batch_check_trty_dtl_ext.dist_no%TYPE,
        p_uw_amount     giac_batch_check_trty_dtl_ext.uw_amount%TYPE,
        p_gl_amount     giac_batch_check_trty_dtl_ext.gl_amount%TYPE,
        p_difference    NUMBER
    )
      RETURN treaty_dtl_tab PIPELINED;        

    FUNCTION get_net(
        p_user_id       giis_users.user_id%TYPE,
        p_line_name     giis_line.line_name%TYPE
    )
      RETURN net_tab PIPELINED;
      
    FUNCTION select_gl_branch_line(
        p_module        VARCHAR2,
        p_item_no       NUMBER,
        p_tran_class    VARCHAR2,
        p_break_by      VARCHAR2,
        p_date_option   VARCHAR2,
        p_from_date     DATE,
        p_to_date       DATE
    )
      RETURN giacr354_gl_type PIPELINED;

    FUNCTION giacr354_prd(
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN giacr354_type PIPELINED;

    FUNCTION giacr354_prd_dtl(
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN giacr354_dtl_type PIPELINED;

    FUNCTION giacr354_uw(
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN giacr354_type PIPELINED;

    FUNCTION giacr354_uw_dtl(
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN giacr354_dtl_type PIPELINED;

    FUNCTION giacr354_of(
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN giacr354_type PIPELINED;

    FUNCTION giacr354_of_dtl(
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN giacr354_dtl_type PIPELINED;

    FUNCTION giacr354_inf(
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN giacr354_type PIPELINED;

    FUNCTION giacr354_inf_dtl(
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN giacr354_dtl_type PIPELINED;

    FUNCTION giacr354_ol(
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN giacr354_brdrx_reg_type PIPELINED;

    FUNCTION giacr354_ol_dtl(
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN giacr354_brdrx_dtl_type PIPELINED;

    FUNCTION giacr354_clm_payt (
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN giacr354_brdrx_reg_type PIPELINED;

    FUNCTION giacr354_clm_payt_dtl (
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    )
      RETURN giacr354_brdrx_dtl_type PIPELINED;
      
   FUNCTION is_gl_treaty_xol_same (
      p_module_id     VARCHAR2,
      p_treaty_item   NUMBER,
      p_xol_item      NUMBER
   )
      RETURN NUMBER;

    FUNCTION check_treaty_level(
        p_module        VARCHAR2,
        p_item_no       NUMBER
    )
      RETURN NUMBER;

    PROCEDURE extract_gross_prem(
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE,
        p_count  IN OUT NUMBER
    );

    PROCEDURE extract_gross_prem_dtl(
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    );

    PROCEDURE extract_treaty_prem(
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE,
        p_count  IN OUT NUMBER
    );

    PROCEDURE extract_facul_prem (
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE,
        p_count  IN OUT NUMBER
    );

    PROCEDURE extract_facul_prem_dtl (
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    );

    PROCEDURE extract_treaty_prem_dtl (
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    );

    PROCEDURE extract_os_loss (
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE,
        p_count   IN OUT NUMBER
    );

    PROCEDURE extract_os_loss_dtl (
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    );

    PROCEDURE extract_losses_paid (
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%TYPE,
        p_count  IN OUT NUMBER
    );
    
    PROCEDURE extract_losses_paid_dtl (
        p_from_date     DATE,
        p_to_date       DATE,
        p_post_tran     VARCHAR2,
        p_user_id       giis_users.user_id%type
    );
    
    FUNCTION get_os_loss(
        p_user_id       giis_users.user_id%TYPE,
        p_line_name     giis_line.line_name%TYPE,
        p_gl_acct_sname giac_batch_check_os_loss_ext.gl_acct_sname%TYPE,
        p_brdrx_amt     giac_batch_check_os_loss_ext.brdrx_amt%TYPE,
        p_balance       giac_batch_check_os_loss_ext.balance%TYPE,
        p_difference    NUMBER
    )
      RETURN claim_tab PIPELINED;
      
    FUNCTION get_losses_paid(
        p_user_id       giis_users.user_id%TYPE,
        p_line_name     giis_line.line_name%TYPE,
        p_gl_acct_sname giac_batch_check_os_loss_ext.gl_acct_sname%TYPE,
        p_brdrx_amt     giac_batch_check_os_loss_ext.brdrx_amt%TYPE,
        p_balance       giac_batch_check_os_loss_ext.balance%TYPE,
        p_difference    NUMBER
    )
      RETURN claim_tab PIPELINED;
      
    FUNCTION get_os_loss_dtl(
        p_line_cd       giac_batch_chk_os_loss_dtl_ext.line_cd%TYPE,
        p_base_amt      giac_batch_chk_os_loss_dtl_ext.base_amt%TYPE,
        p_user_id       giac_batch_chk_os_loss_dtl_ext.user_id%TYPE,
        p_claim_no      VARCHAR2,
        p_item_no       NUMBER,
        p_peril_name    VARCHAR2,
        p_brdrx_amt     NUMBER,
        p_gl_amount     NUMBER,
        p_difference    NUMBER
    )
      RETURN claim_dtl_tab PIPELINED;
      
    FUNCTION get_losses_paid_dtl(
        p_line_cd       giac_batch_chk_loss_pd_dtl_ext.line_cd%TYPE,
        p_base_amt      giac_batch_chk_loss_pd_dtl_ext.base_amt%TYPE,
        p_user_id       giac_batch_chk_loss_pd_dtl_ext.user_id%TYPE,
        p_claim_no      VARCHAR2,
        p_item_no       NUMBER,
        p_peril_name    VARCHAR2,
        p_brdrx_amt     NUMBER,
        p_gl_amount     NUMBER,
        p_difference    NUMBER
    )
      RETURN  claim_dtl_tab PIPELINED;
    
    PROCEDURE check_extraction(
        p_from_date     DATE,     
        p_to_date       DATE,
        p_batch_type    VARCHAR2,
        p_tab           VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    );
    
    PROCEDURE check_records(
        p_batch_type    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_user_id       giis_users.user_id%TYPE
    );
    
    PROCEDURE check_details(
        p_line_cd       giac_batch_chk_loss_pd_dtl_ext.line_cd%TYPE,
        p_base_amt      giac_batch_chk_loss_pd_dtl_ext.base_amt%TYPE,
        p_user_id       giac_batch_chk_loss_pd_dtl_ext.user_id%TYPE,
        p_table         VARCHAR2
    );
      
    PROCEDURE extract_records(
        p_from_date     VARCHAR2,     
        p_to_date       VARCHAR2,
        p_date_tag      giac_batch_check_treaty_ext.date_tag%TYPE,
        p_batch_type    VARCHAR2,
        p_tab           VARCHAR2,
        p_user_id       VARCHAR2,
        p_out       OUT VARCHAR2
    );
    
END;
/


