CREATE OR REPLACE PACKAGE CPI.GIACR220_PKG
AS

    TYPE giacr220_type IS RECORD (
        summary_id                  giac_treaty_qtr_summary.summary_id%TYPE,
        line_cd                     giac_treaty_qtr_summary.line_cd%TYPE,
        trty_yy                     giac_treaty_qtr_summary.trty_yy%TYPE,
        share_cd                    giac_treaty_qtr_summary.share_cd%TYPE,
        ri_cd                       giac_treaty_qtr_summary.ri_cd%TYPE,
        ri_name                     giis_reinsurer.ri_name%TYPE,
        proc_qtr                    giac_treaty_qtr_summary.proc_qtr%TYPE,
        proc_year                   giac_treaty_qtr_summary.proc_year%TYPE,
        trty_name                   giis_dist_share.trty_name%TYPE,
        period                      VARCHAR2(100),
        acct_trty_type              giac_treaty_qtr_summary.acct_trty_type%TYPE,
        extract_date                giac_treaty_qtr_summary.extract_date%TYPE,
        premium_ceded_amt           giac_treaty_qtr_summary.premium_ceded_amt%TYPE,
        trty_shr_pct                giac_treaty_qtr_summary.trty_shr_pct%TYPE,
        OUTSTANDING_LOSS_AMT        GIAC_TREATY_QTR_SUMMARY.OUTSTANDING_LOSS_AMT%TYPE,
        commission_amt              giac_treaty_qtr_summary.commission_amt%TYPE,
        clm_loss_paid_amt           giac_treaty_qtr_summary.clm_loss_paid_amt%TYPE,
        clm_loss_expense_amt        giac_treaty_qtr_summary.clm_loss_expense_amt%TYPE,
        prem_resv_retnd_amt         giac_treaty_qtr_summary.prem_resv_retnd_amt%TYPE,
        prem_resv_relsd_amt         giac_treaty_qtr_summary.prem_resv_relsd_amt%TYPE,
        funds_held_pct              giac_treaty_qtr_summary.funds_held_pct%TYPE,
        int_on_prem_pct             giac_treaty_qtr_summary.int_on_prem_pct%TYPE,
        released_int_amt            giac_treaty_qtr_summary.released_int_amt%TYPE,
        wht_tax_amt                 giac_treaty_qtr_summary.wht_tax_amt%TYPE,
        wht_tax_rt                  giac_treaty_qtr_summary.wht_tax_rt%TYPE,
        ending_bal_amt              giac_treaty_qtr_summary.ending_bal_amt%TYPE,
        previous_bal_amt            giac_treaty_qtr_summary.previous_bal_amt%TYPE,
        prev_balance                giac_treaty_cash_acct.prev_balance%TYPE,
        prev_balance_dt             giac_treaty_cash_acct.prev_balance_dt%TYPE,
        balance_as_above            giac_treaty_cash_acct.balance_as_above%TYPE,
        our_remittance              giac_treaty_cash_acct.our_remittance%TYPE,
        your_remittance             giac_treaty_cash_acct.your_remittance%TYPE,
        cash_call_paid              giac_treaty_cash_acct.cash_call_paid%TYPE,
        cash_bal_in_favor           giac_treaty_cash_acct.cash_bal_in_favor%TYPE,
        resv_balance                giac_treaty_cash_acct.resv_balance%TYPE,
        prev_resv_balance           giac_treaty_cash_acct.prev_resv_balance%TYPE,
        prev_resv_bal_dt            giac_treaty_cash_acct.prev_resv_bal_dt%TYPE,
        resv_balance_dt             giac_treaty_cash_acct.resv_balance_dt%TYPE,
        cf_sum_cash_ending_credit   NUMBER(20,2),
        CF_sum_cash_ending_debit    NUMBER(20,2),
        CF_sum_ending_credit        NUMBER(20,2),
        CF_sum_ending_debit         NUMBER(20,2),
        CF_trty_comm_rt             NUMBER(20,2),
        prem_ceded_brk              GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
        comm_amt_brk                GIAC_PARAMETERS.param_value_n%TYPE,
        loss_paid_brk               GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
        exp_paid_brk                GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
        company_name                GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
        gi_address                  GIAC_PARAMETERS.PARAM_VALUE_V%TYPE, 
        
        -- used in formatting
        dr_cr_tag_1         VARCHAR2(1),
        dr_cr_tag_2         VARCHAR2(1),
        dr_cr_tag_3         VARCHAR2(1),
        dr_cr_tag_4         VARCHAR2(1),
        dr_cr_tag_5         VARCHAR2(1),
        dr_cr_tag_6         VARCHAR2(1),
        dr_cr_tag_7         VARCHAR2(1),
        dr_cr_tag_8         VARCHAR2(1),
        dr_cr_tag_9         VARCHAR2(1),
        dr_cr_tag_10        VARCHAR2(1),
        dr_cr_tag_11        VARCHAR2(1),
        dr_cr_tag_12        VARCHAR2(1),
        dr_cr_tag_13        VARCHAR2(1),
        dr_cr_tag_14        VARCHAR2(1),
        dr_cr_tag_15        VARCHAR2(1)
    );
    
    TYPE giacr220_tab IS TABLE OF giacr220_type;
    
    FUNCTION get_report_details(
        p_line_cd           giac_treaty_qtr_summary.LINE_CD%TYPE,
        p_trty_yy           giac_treaty_qtr_summary.trty_yy%TYPE,
        p_share_cd          giac_treaty_qtr_summary.share_cd%TYPE,
        p_ri_cd             giac_treaty_qtr_summary.ri_cd%TYPE,
        p_proc_year         giac_treaty_qtr_summary.proc_year%TYPE,
        p_proc_qtr          giac_treaty_qtr_summary.proc_qtr%TYPE
    ) RETURN giacr220_tab PIPELINED;
    
    
    
    -- sub reports
    
    TYPE subreport_type IS RECORD (
        -- used in get_subreport2
        line_cd             giac_treaty_perils_v.line_cd%TYPE, 
        trty_yy             giac_treaty_perils_v.trty_yy%TYPE, 
        share_cd            giac_treaty_perils_v.share_cd%TYPE,   
        ri_cd               giac_treaty_perils_v.ri_cd%TYPE, 
        proc_year           giac_treaty_perils_v.proc_year%TYPE, 
        proc_qtr            giac_treaty_perils_v.proc_qtr%TYPE,
        peril_cd            giac_treaty_perils_v.peril_cd%TYPE, 
        peril_name          giis_peril.peril_name%TYPE,
        premium_amt         giac_treaty_perils_v.premium_amt%TYPE, 
        commission_amt      giac_treaty_perils_v.commission_amt%TYPE,
        
        -- used in get_subreport3
        trty_comm_rt        giac_treaty_comm_v.trty_comm_rt%TYPE,
        
        -- used in get_subreport4
        loss_paid_amt       giac_treaty_claims_v.loss_paid_amt%TYPE,
        loss_exp_amt        giac_treaty_claims_v.loss_exp_amt%TYPE,
        treaty_seq_no       giac_treaty_claims_v.treaty_seq_no%TYPE
    );
    
    TYPE subreport_tab IS TABLE OF subreport_type;    
    
    FUNCTION get_subreport2(
        p_line_cd           giac_treaty_perils_v.LINE_CD%TYPE,
        p_trty_yy           giac_treaty_perils_v.trty_yy%TYPE,
        p_share_cd          giac_treaty_perils_v.share_cd%TYPE,
        p_ri_cd             giac_treaty_perils_v.ri_cd%TYPE,
        p_proc_year         giac_treaty_perils_v.proc_year%TYPE,
        p_proc_qtr          giac_treaty_perils_v.proc_qtr%TYPE
    ) RETURN subreport_tab PIPELINED;
    
    FUNCTION get_subreport3(
        p_line_cd           giac_treaty_comm_v.LINE_CD%TYPE,
        p_trty_yy           giac_treaty_comm_v.trty_yy%TYPE,
        p_share_cd          giac_treaty_comm_v.share_cd%TYPE,
        p_ri_cd             giac_treaty_comm_v.ri_cd%TYPE,
        p_proc_year         giac_treaty_comm_v.proc_year%TYPE,
        p_proc_qtr          giac_treaty_comm_v.proc_qtr%TYPE
    ) RETURN subreport_tab PIPELINED;
    
    FUNCTION get_subreport4(
        p_line_cd           giac_treaty_claims_v.LINE_CD%TYPE,
        p_trty_yy           giac_treaty_claims_v.trty_yy%TYPE,
        p_share_cd          giac_treaty_claims_v.share_cd%TYPE,
        p_ri_cd             giac_treaty_claims_v.ri_cd%TYPE,
        p_proc_year         giac_treaty_claims_v.proc_year%TYPE,
        p_proc_qtr          giac_treaty_claims_v.proc_qtr%TYPE
    ) RETURN subreport_tab PIPELINED;
    
END GIACR220_PKG;
/


