CREATE OR REPLACE PACKAGE CPI.GIACS220_PKG
AS

    FUNCTION check_for_prev_extract(
        p_line_cd       giac_treaty_extract.line_cd%TYPE,
        p_share_cd      giac_treaty_extract.share_cd%TYPE,
        p_trty_yy       GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_proc_year     giac_treaty_extract.proc_year%TYPE,
        p_proc_qtr      giac_treaty_extract.proc_qtr%TYPE
    ) RETURN VARCHAR;
    
    PROCEDURE check_and_extract (
        p_line_cd       IN  giac_treaty_extract.line_cd%TYPE,
        p_share_cd      IN  giac_treaty_extract.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_year          IN  giac_treaty_extract.proc_year%TYPE,
        p_qtr           IN  giac_treaty_extract.proc_qtr%TYPE,
        p_month1        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month2        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month3        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_user_id       IN  giis_users.user_id%TYPE,
        p_prev_ext      OUT VARCHAR2,
        p_rec_cnt       OUT NUMBER
    );
    
    PROCEDURE pg_extract_all(
        p_line_cd       IN  giac_treaty_extract.line_cd%TYPE,
        p_share_cd      IN  giac_treaty_extract.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_year          IN  giac_treaty_extract.proc_year%TYPE,
        p_qtr           IN  giac_treaty_extract.proc_qtr%TYPE,
        p_month1        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month2        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month3        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_rec_cnt       OUT NUMBER
    );
    
    PROCEDURE pg_extract_clm_loss(
        p_line_cd       IN  giac_treaty_extract.line_cd%TYPE,
        p_share_cd      IN  giac_treaty_extract.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_year          IN  giac_treaty_extract.proc_year%TYPE,
        p_qtr           IN  giac_treaty_extract.proc_qtr%TYPE,
        p_month1        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month2        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month3        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_rec_cnt       OUT NUMBER
    );
    
    PROCEDURE pg_extract_dist_share(
        p_line_cd       IN  giis_dist_share.line_cd%TYPE,
        p_share_cd      IN  giis_dist_share.share_cd%TYPE,
        p_year          IN  giac_treaty_cessions.cession_year%TYPE,
        p_qtr           IN  giac_treaty_perils.proc_qtr%TYPE,
        p_month1        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month2        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_month3        IN  giac_treaty_cessions.cession_mm%TYPE,
        p_rec_cnt       OUT NUMBER
    );
    
    PROCEDURE pg_delete_prev_extract(
        p_line_cd       IN  giis_dist_share.line_cd%TYPE,
        p_share_cd      IN  giis_dist_share.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_year          IN  giac_treaty_cessions.cession_year%TYPE,
        p_qtr           IN  giac_treaty_perils.proc_qtr%TYPE,
        p_user_id       IN  giis_users.user_id%TYPE
    );
    
    PROCEDURE pg_compute(
        p_line_cd       IN  giis_dist_share.line_cd%TYPE,
        p_share_cd      IN  giis_dist_share.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_ri_cd         IN  giis_reinsurer.ri_cd%TYPE,
        p_year          IN  giac_treaty_cessions.cession_year%TYPE,
        p_qtr           IN  giac_treaty_perils.proc_qtr%TYPE,
        p_user_id       IN  giis_users.user_id%TYPE
    );
    
    PROCEDURE pg_compute_cash_acct(
        p_summary_id            NUMBER, 
        p_ending_bal_amt        NUMBER,
        p_prem_resv_retnd_amt   NUMBER,
        p_prem_resv_relsd_amt   NUMBER,
        p_qtr                   NUMBER,
        p_year                  NUMBER
    );
    
    PROCEDURE pg_post(
        p_line_cd       IN  giis_dist_share.line_cd%TYPE,
        p_share_cd      IN  giis_dist_share.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_ri_cd         IN  giis_reinsurer.ri_cd%TYPE,
        p_year          IN  giac_treaty_cessions.cession_year%TYPE,
        p_qtr           IN  giac_treaty_perils.proc_qtr%TYPE,
        p_exist         OUT VARCHAR2
    );
    
    PROCEDURE check_bef_view(
        p_line_cd       IN  giis_dist_share.line_cd%TYPE,
        p_share_cd      IN  giis_dist_share.share_cd%TYPE,
        p_trty_yy       IN  GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_ri_cd         IN  giis_reinsurer.ri_cd%TYPE,
        p_year          IN  giac_treaty_cessions.cession_year%TYPE,
        p_qtr           IN  giac_treaty_perils.proc_qtr%TYPE,
        p_found         OUT VARCHAR2     
    );
    
    
    TYPE summary_breakdown_type IS RECORD (
        trty_yy             GIAC_TREATY_PERILS_V.trty_yy%TYPE, 
        line_cd             GIAC_TREATY_PERILS_V.line_cd%TYPE, 
        share_cd            GIAC_TREATY_PERILS_V.share_cd%TYPE, 
        ri_cd               GIAC_TREATY_PERILS_V.ri_cd%TYPE,
        ri_name             giis_reinsurer.ri_name%TYPE,
        year                GIAC_TREATY_PERILS_V.proc_year%TYPE,
        qtr                 GIAC_TREATY_PERILS_V.proc_qtr%TYPE,
        peril_cd            GIAC_TREATY_PERILS_V.peril_cd%TYPE,
        peril_name          giis_peril.peril_name%TYPE,
        premium_amt         GIAC_TREATY_PERILS_V.premium_amt%TYPE,
        
        -- used for Commission Breakdown by Commission Rate
        trty_comm_rt        GIAC_TREATY_COMM_V.TRTY_COMM_RT%TYPE,
        commission_amt      GIAC_TREATY_COMM_V.COMMISSION_AMT%TYPE,
        
        -- used for Loss Paid with Peril Breakdown
        loss_paid_amt       GIAC_TREATY_CLAIMS_V.LOSS_PAID_AMT%TYPE,
        treaty_seq_no       GIAC_TREATY_CLAIMS_V.TREATY_SEQ_NO%TYPE,
        
        -- used for Loss Expense with Peril Breakdown
        loss_exp_amt        GIAC_TREATY_CLAIMS_V.LOSS_EXP_AMT%TYPE
    );
    
    TYPE summary_breakdown_tab IS TABLE OF summary_breakdown_type;
    
    FUNCTION get_peril_breakdown(
        p_line_cd             GIAC_TREATY_PERILS_V.line_cd%TYPE, 
        p_share_cd            GIAC_TREATY_PERILS_V.share_cd%TYPE, 
        p_trty_yy             GIAC_TREATY_PERILS_V.trty_yy%TYPE,
        p_ri_cd               GIAC_TREATY_PERILS_V.ri_cd%TYPE,
        p_year                GIAC_TREATY_PERILS_V.proc_year%TYPE,
        p_qtr                 GIAC_TREATY_PERILS_V.proc_qtr%TYPE
    ) RETURN summary_breakdown_tab PIPELINED;
    
    FUNCTION get_commission_breakdown(
        p_line_cd             GIAC_TREATY_COMM_V.line_cd%TYPE, 
        p_share_cd            GIAC_TREATY_COMM_V.share_cd%TYPE, 
        p_trty_yy             GIAC_TREATY_COMM_V.trty_yy%TYPE,
        p_ri_cd               GIAC_TREATY_COMM_V.ri_cd%TYPE,
        p_year                GIAC_TREATY_COMM_V.proc_year%TYPE,
        p_qtr                 GIAC_TREATY_COMM_V.proc_qtr%TYPE
    ) RETURN summary_breakdown_tab PIPELINED;
    
    FUNCTION get_clm_loss_paid_breakdown(
        p_line_cd             GIAC_TREATY_COMM_V.line_cd%TYPE, 
        p_share_cd            GIAC_TREATY_COMM_V.share_cd%TYPE, 
        p_trty_yy             GIAC_TREATY_COMM_V.trty_yy%TYPE,
        p_ri_cd               GIAC_TREATY_COMM_V.ri_cd%TYPE,
        p_year                GIAC_TREATY_COMM_V.proc_year%TYPE,
        p_qtr                 GIAC_TREATY_COMM_V.proc_qtr%TYPE
    ) RETURN summary_breakdown_tab PIPELINED;
    
    FUNCTION get_clm_loss_exp_breakdown(
        p_line_cd             GIAC_TREATY_COMM_V.line_cd%TYPE, 
        p_share_cd            GIAC_TREATY_COMM_V.share_cd%TYPE, 
        p_trty_yy             GIAC_TREATY_COMM_V.trty_yy%TYPE,
        p_ri_cd               GIAC_TREATY_COMM_V.ri_cd%TYPE,
        p_year                GIAC_TREATY_COMM_V.proc_year%TYPE,
        p_qtr                 GIAC_TREATY_COMM_V.proc_qtr%TYPE
    ) RETURN summary_breakdown_tab PIPELINED;
    
    TYPE report_type IS RECORD (
        report_id             GIIS_REPORTS.report_id%TYPE,
        report_title          GIIS_REPORTS.report_title%TYPE
    );
    
    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION get_report_list_by_page(
        p_page      VARCHAR2
    ) RETURN report_tab PIPELINED;    

END GIACS220_PKG;
/


