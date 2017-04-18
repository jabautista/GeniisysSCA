CREATE OR REPLACE PACKAGE CPI.GIAC_TREATY_QTR_SUMMARY_PKG 
AS
    TYPE giac_trty_qtr_summ_type IS RECORD (
        ri_cd                   GIAC_TREATY_QTR_SUMMARY.ri_cd%TYPE,
        ri_name                 giis_reinsurer.ri_name%TYPE,
        line_cd                 GIAC_TREATY_QTR_SUMMARY.line_cd%TYPE,
        line_name               giis_line.line_name%TYPE,
        trty_yy                 GIAC_TREATY_QTR_SUMMARY.trty_yy%TYPE,
        sharE_cd                GIAC_TREATY_QTR_SUMMARY.share_cd%TYPE,
        treaty_name             giis_dist_share.trty_name%TYPE,
        trty_shr_pct            GIAC_TREATY_QTR_SUMMARY.trty_shr_pct%TYPE,
        proc_year               GIAC_TREATY_QTR_SUMMARY.proc_year%TYPE,
        proc_qtr                GIAC_TREATY_QTR_SUMMARY.proc_qtr%TYPE,
        premium_ceded_amt       GIAC_TREATY_QTR_SUMMARY.premium_ceded_amt%TYPE,
        commission_amt          GIAC_TREATY_QTR_SUMMARY.commission_amt%TYPE,
        clm_loss_paid_amt       GIAC_TREATY_QTR_SUMMARY.clm_loss_paid_amt%TYPE,
        clm_loss_expense_amt    GIAC_TREATY_QTR_SUMMARY.clm_loss_expense_amt%TYPE,
        prem_resv_retnd_amt     GIAC_TREATY_QTR_SUMMARY.prem_resv_retnd_amt%TYPE,
        funds_held_pct          GIAC_TREATY_QTR_SUMMARY.funds_held_pct%TYPE,
        outstanding_loss_amt    GIAC_TREATY_QTR_SUMMARY.outstanding_loss_amt%TYPE,
        prem_resv_relsd_amt     GIAC_TREATY_QTR_SUMMARY.prem_resv_relsd_amt%TYPE,
        released_int_amt        GIAC_TREATY_QTR_SUMMARY.released_int_amt%TYPE,
        wht_tax_rt              GIAC_TREATY_QTR_SUMMARY.wht_tax_rt%TYPE,
        wht_tax_amt             GIAC_TREATY_QTR_SUMMARY.wht_tax_amt%TYPE,
        ending_bal_amt          GIAC_TREATY_QTR_SUMMARY.ending_bal_amt%TYPE,
        prev_balance_due        GIAC_TREATY_QTR_SUMMARY.prev_balance_due%TYPE,
        previous_bal_amt        GIAC_TREATY_QTR_SUMMARY.previous_bal_amt%TYPE,
        retained_int_amt        GIAC_TREATY_QTR_SUMMARY.retained_int_amt%TYPE,
        summary_id              GIAC_TREATY_QTR_SUMMARY.summary_id%TYPE,
        acct_trty_type          GIAC_TREATY_QTR_SUMMARY.acct_trty_type%TYPE,
        extract_date            GIAC_TREATY_QTR_SUMMARY.extract_date%TYPE,
        int_on_prem_pct         GIAC_TREATY_QTR_SUMMARY.int_on_prem_pct%TYPE,
        prem_tax_amt            GIAC_TREATY_QTR_SUMMARY.prem_tax_amt%TYPE,
        final_tag               GIAC_TREATY_QTR_SUMMARY.final_tag%TYPE,
        user_id                 GIAC_TREATY_QTR_SUMMARY.user_id%TYPE,
        last_update_str         VARCHAR2(20)
    );
    
    TYPE giac_trty_qtr_summ_tab IS TABLE OF giac_trty_qtr_summ_type;
    
    FUNCTION get_trty_qtr_summary(
        p_line_cd       giis_dist_share.line_cd%TYPE,
        p_share_cd      giis_dist_share.share_cd%TYPE,
        p_trty_yy       GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_ri_cd         giis_reinsurer.ri_cd%TYPE,
        p_year          giac_treaty_cessions.cession_year%TYPE,
        p_qtr           giac_treaty_perils.proc_qtr%TYPE
    ) RETURN giac_trty_qtr_summ_tab PIPELINED;
    
    PROCEDURE update_treaty_statement(
        p_treaty        GIAC_TREATY_QTR_SUMMARY%ROWTYPE
    );

END GIAC_TREATY_QTR_SUMMARY_PKG;
/


