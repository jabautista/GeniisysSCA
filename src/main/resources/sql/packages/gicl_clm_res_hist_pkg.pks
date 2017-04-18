CREATE OR REPLACE PACKAGE CPI.GICL_CLM_RES_HIST_PKG
AS

    TYPE gicl_clm_res_hist_type IS RECORD(
        claim_id                   gicl_clm_res_hist.claim_id%TYPE,
        clm_res_hist_id            gicl_clm_res_hist.clm_res_hist_id%TYPE,
        hist_seq_no                gicl_clm_res_hist.hist_seq_no%TYPE,
        item_no                    gicl_clm_res_hist.item_no%TYPE,
        peril_cd                   gicl_clm_res_hist.peril_cd%TYPE,
        user_id                    gicl_clm_res_hist.user_id%TYPE,
        last_update                gicl_clm_res_hist.last_update%TYPE,
        payee_class_cd             gicl_clm_res_hist.payee_class_cd%TYPE,
        payee_cd                   gicl_clm_res_hist.payee_cd%TYPE,
        date_paid                  gicl_clm_res_hist.date_paid%TYPE,
        loss_reserve               gicl_clm_res_hist.loss_reserve%TYPE,
        losses_paid                gicl_clm_res_hist.losses_paid%TYPE,
        expense_reserve            gicl_clm_res_hist.expense_reserve%TYPE,
        expenses_paid              gicl_clm_res_hist.expenses_paid%TYPE,
        dist_sw                    gicl_clm_res_hist.dist_sw%TYPE,
        currency_cd                gicl_clm_res_hist.currency_cd%TYPE,
        convert_rate               gicl_clm_res_hist.convert_rate%TYPE,
        cpi_rec_no                 gicl_clm_res_hist.cpi_rec_no%TYPE,
        cpi_branch_cd              gicl_clm_res_hist.cpi_branch_cd%TYPE,
        prev_loss_res              gicl_clm_res_hist.prev_loss_res%TYPE,
        prev_loss_paid             gicl_clm_res_hist.prev_loss_paid%TYPE,
        prev_exp_res               gicl_clm_res_hist.prev_exp_res%TYPE,
        prev_exp_paid              gicl_clm_res_hist.prev_exp_paid%TYPE,
        eim_takeup_tag             gicl_clm_res_hist.eim_takeup_tag%TYPE,
        tran_id                    gicl_clm_res_hist.tran_id%TYPE,
        cancel_tag                 gicl_clm_res_hist.cancel_tag%TYPE,
        remarks                    gicl_clm_res_hist.remarks%TYPE,
        booking_month              gicl_clm_res_hist.booking_month%TYPE,
        booking_year               gicl_clm_res_hist.booking_year%TYPE,
        negate_date                gicl_clm_res_hist.negate_date%TYPE,
        cancel_date                gicl_clm_res_hist.cancel_date%TYPE,
        advice_id                  gicl_clm_res_hist.advice_id%TYPE,
        distribution_date          gicl_clm_res_hist.distribution_date%TYPE,
        clm_loss_id                gicl_clm_res_hist.clm_loss_id%TYPE,
        net_pd_loss                gicl_clm_res_hist.net_pd_loss%TYPE,
        net_pd_exp                 gicl_clm_res_hist.net_pd_exp%TYPE,
        dist_no                    gicl_clm_res_hist.dist_no%TYPE,
        grouped_item_no            gicl_clm_res_hist.grouped_item_no%TYPE,
        dist_type                     gicl_clm_res_hist.dist_type%TYPE,
        dsp_peril_name             giis_peril.peril_sname%TYPE,
        dsp_currency_desc          giis_currency.currency_desc%TYPE,
        gicl_reserve_rids_exist    VARCHAR2(1)
        );
        
    TYPE gicl_clm_res_hist_tab IS TABLE OF gicl_clm_res_hist_type;
    
    FUNCTION get_gicl_clm_res_hist(
        p_claim_id     gicl_claims.claim_id%TYPE,
        p_line_cd      gicl_claims.line_cd%TYPE)
    RETURN gicl_clm_res_hist_tab PIPELINED;
    
    PROCEDURE get_loss_exp_reserve(
        p_claim_id         IN  GICL_CLM_RES_HIST.claim_id%TYPE,
        p_item_no          IN  GICL_CLM_RES_HIST.item_no%TYPE,
        p_peril_cd         IN  GICL_CLM_RES_HIST.peril_cd%TYPE,
        p_loss_reserve     OUT GICL_CLM_RES_HIST.loss_reserve%TYPE,
        p_expense_reserve  OUT GICL_CLM_RES_HIST.expense_reserve%TYPE);
        
    FUNCTION dist_by_risk_loc (
       v_claim_id   GICL_CLAIMS.claim_id%TYPE,
       v_item_no    GICL_CLM_RES_HIST.item_no%TYPE,
       v_peril_cd   GICL_CLM_RES_HIST.peril_cd%TYPE
    )
    RETURN VARCHAR2;
    
    TYPE gicl_clm_res_hist_type2 IS RECORD(
        claim_id                   gicl_clm_res_hist.claim_id%TYPE,
        clm_res_hist_id            gicl_clm_res_hist.clm_res_hist_id%TYPE,
        currency_cd                gicl_clm_res_hist.currency_cd%TYPE,
        convert_rate               gicl_clm_res_hist.convert_rate%TYPE,
        dist_sw                    gicl_clm_res_hist.dist_sw%TYPE,
        hist_seq_no                gicl_clm_res_hist.hist_seq_no%TYPE,
        item_no                    gicl_clm_res_hist.item_no%TYPE,
        peril_cd                   gicl_clm_res_hist.peril_cd%TYPE,
        user_id                    gicl_clm_res_hist.user_id%TYPE,
        last_update                gicl_clm_res_hist.last_update%TYPE,
        booking_month              gicl_clm_res_hist.booking_month%TYPE,
        booking_year               gicl_clm_res_hist.booking_year%TYPE,
        grouped_item_no            gicl_clm_res_hist.grouped_item_no%TYPE,
        remarks                    gicl_clm_res_hist.remarks%TYPE,
        currency_desc              giis_currency.currency_desc%TYPE,
        distribution_desc          VARCHAR2(30) 
    );
   
    TYPE gicl_clm_res_hist_tab2 IS TABLE OF gicl_clm_res_hist_type2;

    FUNCTION get_gicl_clm_res_hist2 (
       p_claim_id   GICL_CLAIMS.claim_id%TYPE,
       p_item_no    GICL_CLM_RES_HIST.item_no%TYPE,
       p_peril_cd   GICL_CLM_RES_HIST.peril_cd%TYPE
    ) RETURN gicl_clm_res_hist_tab2 PIPELINED;
    
    TYPE gicl_clm_res_hist_type3 IS RECORD(
        -- tran_id is null     
        clm_res_hist_id            gicl_clm_res_hist.clm_res_hist_id%TYPE, 
        grouped_item_no            gicl_clm_res_hist.grouped_item_no%TYPE,
        hist_seq_no                gicl_clm_res_hist.hist_seq_no%TYPE,
        loss_reserve               gicl_clm_res_hist.loss_reserve%TYPE,
        expense_reserve            gicl_clm_res_hist.expense_reserve%TYPE, 
        claim_id                   gicl_clm_res_hist.claim_id%TYPE,
        convert_rate               gicl_clm_res_hist.convert_rate%TYPE,
        booking_year               gicl_clm_res_hist.booking_year%TYPE,
        booking_month              gicl_clm_res_hist.booking_month%TYPE,
        dist_sw                    gicl_clm_res_hist.dist_sw%TYPE,
        remarks                    gicl_clm_res_hist.remarks%TYPE,
        user_id                    gicl_clm_res_hist.user_id%TYPE,
        last_update                gicl_clm_res_hist.last_update%TYPE
    );
    
    TYPE gicl_clm_res_hist_tab3 IS TABLE OF gicl_clm_res_hist_type3;
    
     FUNCTION get_gicl_clm_res_hist3 (
       p_claim_id   GICL_CLAIMS.claim_id%TYPE,
       p_item_no    GICL_CLM_RES_HIST.item_no%TYPE,
       p_peril_cd   GICL_CLM_RES_HIST.peril_cd%TYPE
    ) RETURN gicl_clm_res_hist_tab3 PIPELINED;
    
    TYPE payment_history_type IS RECORD (
        claim_id            gicl_clm_res_hist.claim_id%TYPE,
        clm_res_hist_id     gicl_clm_res_hist.clm_res_hist_id%TYPE,
        hist_seq_no         gicl_clm_res_hist.hist_seq_no%TYPE,
        losses_paid         gicl_clm_res_hist.losses_paid%TYPE,
        expenses_paid       gicl_clm_res_hist.expenses_paid%TYPE,
        convert_rate        gicl_clm_res_hist.convert_rate%TYPE,
        date_paid           gicl_clm_res_hist.date_paid%TYPE,
        cancel_tag          gicl_clm_res_hist.cancel_tag%TYPE,
        payee_class_cd      gicl_clm_res_hist.payee_class_cd%TYPE,
        class_desc          giis_payee_class.class_desc%TYPE,
        payee_cd            gicl_clm_res_hist.payee_cd%TYPE,
        payee               VARCHAR2(290),
        remarks             gicl_clm_res_hist.remarks%TYPE,
		user_id             gicl_clm_res_hist.user_id%TYPE,
        last_update         gicl_clm_res_hist.last_update%TYPE
    );
    
    TYPE payment_history_tab IS TABLE OF payment_history_type;
    
    FUNCTION get_payment_history (
        p_claim_id        gicl_clm_res_hist.claim_id%TYPE,
        p_item_no         gicl_clm_res_hist.item_no%TYPE,
        p_peril_cd        gicl_clm_res_hist.peril_cd%TYPE,
        p_grouped_item_no gicl_clm_res_hist.grouped_item_no%TYPE
    ) RETURN payment_history_tab PIPELINED;
    
    PROCEDURE update_res_hist_remarks(
        p_claim_id         IN  GICL_CLM_RES_HIST.claim_id%TYPE,
        p_item_no          IN  GICL_CLM_RES_HIST.item_no%TYPE,
        p_peril_cd         IN  GICL_CLM_RES_HIST.peril_cd%TYPE,
        p_remarks          IN  GICL_CLM_RES_HIST.remarks%TYPE
    );
    
	FUNCTION get_last_clm_res_hist(
        p_claim_id         IN  GICL_CLM_RES_HIST.claim_id%TYPE,
        p_item_no          IN  GICL_CLM_RES_HIST.item_no%TYPE,
        p_peril_cd         IN  GICL_CLM_RES_HIST.peril_cd%TYPE
    ) RETURN gicl_clm_res_hist_tab2 PIPELINED;
    
    TYPE gicl_clm_res_hist_type4 IS RECORD(
        claim_id                   gicl_clm_res_hist.claim_id%TYPE,
        clm_res_hist_id            gicl_clm_res_hist.clm_res_hist_id%TYPE,
        currency_cd                gicl_clm_res_hist.currency_cd%TYPE,
        convert_rate               gicl_clm_res_hist.convert_rate%TYPE,
        dist_sw                    gicl_clm_res_hist.dist_sw%TYPE,
        hist_seq_no                gicl_clm_res_hist.hist_seq_no%TYPE,
        item_no                    gicl_clm_res_hist.item_no%TYPE,
        peril_cd                   gicl_clm_res_hist.peril_cd%TYPE,
        user_id                    gicl_clm_res_hist.user_id%TYPE,
        last_update                gicl_clm_res_hist.last_update%TYPE,
        booking_month              gicl_clm_res_hist.booking_month%TYPE,
        booking_year               gicl_clm_res_hist.booking_year%TYPE,
        grouped_item_no            gicl_clm_res_hist.grouped_item_no%TYPE,
        remarks                    gicl_clm_res_hist.remarks%TYPE,
        tran_id                    gicl_clm_res_hist.tran_id%TYPE,
        loss_reserve               gicl_clm_res_hist.loss_reserve%TYPE,
        expense_reserve            gicl_clm_res_hist.expense_reserve%TYPE,
        currency_desc              giis_currency.currency_desc%TYPE,
        distribution_desc          VARCHAR2(30),
        sdf_last_update            VARCHAR2(30), --added by steven 06.03.2013
        setup_date                 VARCHAR2(30),
        setup_by				   gicl_clm_res_hist.setup_by%TYPE
    );
   
    TYPE gicl_clm_res_hist_tab4 IS TABLE OF gicl_clm_res_hist_type4;
    
    FUNCTION get_gicl_clm_res_hist4(
        p_claim_id         IN  GICL_CLM_RES_HIST.claim_id%TYPE,
        p_item_no          IN  GICL_CLM_RES_HIST.item_no%TYPE,
        p_peril_cd         IN  GICL_CLM_RES_HIST.peril_cd%TYPE
    ) RETURN gicl_clm_res_hist_tab4 PIPELINED;
    
    FUNCTION get_dist_type (
        p_tran_id       GICL_CLM_RES_HIST.TRAN_ID%TYPE,
        p_cancel_tag    gicl_clm_res_hist.cancel_tag%TYPE,
        p_dist_sw       gicl_clm_res_hist.dist_sw%TYPE,
        p_dist_type     gicl_clm_res_hist.dist_type%TYPE
    )
       RETURN VARCHAR2;
       
    FUNCTION get_last_clm_res_hist2(
        p_claim_id         IN  GICL_CLM_RES_HIST.claim_id%TYPE,
        p_item_no          IN  GICL_CLM_RES_HIST.item_no%TYPE,
        p_peril_cd         IN  GICL_CLM_RES_HIST.peril_cd%TYPE
    ) RETURN gicl_clm_res_hist_tab4 PIPELINED;   
    
END GICL_CLM_RES_HIST_PKG;
/


