CREATE OR REPLACE PACKAGE CPI.GICL_ADVS_PLA_PKG
AS
    TYPE gicl_advs_pla_type IS RECORD(
        pla_id                   gicl_advs_pla.pla_id%TYPE,
        claim_id                 gicl_advs_pla.claim_id%TYPE,
        grp_seq_no               gicl_advs_pla.grp_seq_no%TYPE,
        ri_cd                    gicl_advs_pla.ri_cd%TYPE,
        line_cd                  gicl_advs_pla.line_cd%TYPE,
        la_yy                    gicl_advs_pla.la_yy%TYPE,
        pla_seq_no               gicl_advs_pla.pla_seq_no%TYPE,
        user_id                  gicl_advs_pla.user_id%TYPE,
        last_update              gicl_advs_pla.last_update%TYPE,
        share_type               gicl_advs_pla.share_type%TYPE,
        peril_cd                 gicl_advs_pla.peril_cd%TYPE,
        loss_shr_amt             gicl_advs_pla.loss_shr_amt%TYPE,
        exp_shr_amt              gicl_advs_pla.exp_shr_amt%TYPE,
        pla_title                gicl_advs_pla.pla_title%TYPE,
        pla_header               gicl_advs_pla.pla_header%TYPE,
        pla_footer               gicl_advs_pla.pla_footer%TYPE,
        print_sw                 gicl_advs_pla.print_sw%TYPE,
        cpi_rec_no               gicl_advs_pla.cpi_rec_no%TYPE,
        cpi_branch_cd            gicl_advs_pla.cpi_branch_cd%TYPE,
        item_no                  gicl_advs_pla.item_no%TYPE,
        cancel_tag               gicl_advs_pla.cancel_tag%TYPE,
        res_pla_id               gicl_advs_pla.res_pla_id%TYPE,
        pla_date         		 gicl_advs_pla.pla_date%TYPE,
        grouped_item_no  		 gicl_advs_pla.grouped_item_no%TYPE,
        dsp_ri_name              giis_reinsurer.ri_name%TYPE
        );
        
    TYPE gicl_advs_pla_tab IS TABLE OF gicl_advs_pla_type;
    
    FUNCTION get_gicl_advs_pla(
        p_claim_id              gicl_reserve_ds.claim_id%TYPE, 
        p_clm_res_hist_id       gicl_reserve_ds.clm_res_hist_id%TYPE,
        p_grp_seq_no            gicl_reserve_ds.grp_seq_no%TYPE,
        p_share_type            gicl_reserve_ds.share_type%TYPE
        )
    RETURN gicl_advs_pla_tab PIPELINED;

    PROCEDURE cancel_pla(
        p_claim_id              gicl_advs_pla.claim_id%TYPE, 
        p_res_pla_id            gicl_advs_pla.res_pla_id%TYPE
        );

    PROCEDURE get_pla_id(p_pla_id   OUT NUMBER);
    
    PROCEDURE clm_pla_grp1 (
        p_hist_id	        VARCHAR2,
        p_claim_id          gicl_claims.claim_id%TYPE,
        p_line_cd           gicl_claims.line_cd%TYPE,
        p_clm_yy            gicl_claims.clm_yy%TYPE
        );

    PROCEDURE clm_pla_grp1A (
        p_hist_id	        VARCHAR2,
        p_claim_id          gicl_claims.claim_id%TYPE,
        p_line_cd           gicl_claims.line_cd%TYPE,
        p_clm_yy            gicl_claims.clm_yy%TYPE
        );
    
    PROCEDURE generate_pla(
        p_claim_id          gicl_claims.claim_id%TYPE,
        p_hist_seq_no       gicl_clm_res_hist.hist_seq_no%TYPE,
        p_grouped_item_no   gicl_clm_res_hist.grouped_item_no%TYPE,
        p_item_no           gicl_clm_res_hist.item_no%TYPE,
        p_peril_cd          gicl_clm_res_hist.peril_cd%TYPE
        );

    PROCEDURE update_print_sw_pla(
        p_claim_id          gicl_advs_pla.claim_id%TYPE,
        p_ri_cd             gicl_advs_pla.ri_cd%TYPE,
        p_pla_seq_no        gicl_advs_pla.pla_seq_no%TYPE,
        p_line_cd           gicl_advs_pla.line_cd%TYPE,
        p_la_yy             gicl_advs_pla.la_yy%TYPE
        );

    PROCEDURE update_print_sw_pla(
        p_claim_id          gicl_advs_pla.claim_id%TYPE,
        p_grp_seq_no        gicl_advs_pla.grp_seq_no%TYPE,
        p_ri_cd             gicl_advs_pla.ri_cd%TYPE,
        p_pla_seq_no        gicl_advs_pla.pla_seq_no%TYPE,
        p_line_cd           gicl_advs_pla.line_cd%TYPE,
        p_la_yy             gicl_advs_pla.la_yy%TYPE
        );

    PROCEDURE set_gicl_advs_pla(
        p_pla_id                   gicl_advs_pla.pla_id%TYPE,
        p_claim_id                 gicl_advs_pla.claim_id%TYPE,
        p_grp_seq_no               gicl_advs_pla.grp_seq_no%TYPE,
        p_ri_cd                    gicl_advs_pla.ri_cd%TYPE,
        p_line_cd                  gicl_advs_pla.line_cd%TYPE,
        p_la_yy                    gicl_advs_pla.la_yy%TYPE,
        p_pla_seq_no               gicl_advs_pla.pla_seq_no%TYPE,
        p_user_id                  gicl_advs_pla.user_id%TYPE,
        p_last_update              gicl_advs_pla.last_update%TYPE,
        p_share_type               gicl_advs_pla.share_type%TYPE,
        p_peril_cd                 gicl_advs_pla.peril_cd%TYPE,
        p_loss_shr_amt             gicl_advs_pla.loss_shr_amt%TYPE,
        p_exp_shr_amt              gicl_advs_pla.exp_shr_amt%TYPE,
        p_pla_title                gicl_advs_pla.pla_title%TYPE,
        p_pla_header               gicl_advs_pla.pla_header%TYPE,
        p_pla_footer               gicl_advs_pla.pla_footer%TYPE,
        p_print_sw                 gicl_advs_pla.print_sw%TYPE,
        p_cpi_rec_no               gicl_advs_pla.cpi_rec_no%TYPE,
        p_cpi_branch_cd            gicl_advs_pla.cpi_branch_cd%TYPE,
        p_item_no                  gicl_advs_pla.item_no%TYPE,
        p_cancel_tag               gicl_advs_pla.cancel_tag%TYPE,
        p_res_pla_id               gicl_advs_pla.res_pla_id%TYPE,
        p_pla_date         		   gicl_advs_pla.pla_date%TYPE,
        p_grouped_item_no  		   gicl_advs_pla.grouped_item_no%TYPE
        );        
        
    -- added by Kris for GICLS050
    PROCEDURE tag_pla_as_printed(
        p_pla   gicl_advs_pla%ROWTYPE
    );
        
END GICL_ADVS_PLA_PKG;
/


