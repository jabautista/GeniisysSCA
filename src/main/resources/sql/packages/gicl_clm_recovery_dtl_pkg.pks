CREATE OR REPLACE PACKAGE CPI.GICL_CLM_RECOVERY_DTL_PKG 
AS
 
    TYPE gicl_clm_recovery_dtl_type IS RECORD(
        recovery_id                 gicl_clm_recovery_dtl.recovery_id%TYPE,
        claim_id                    gicl_clm_recovery_dtl.claim_id%TYPE,
        clm_loss_id                 gicl_clm_recovery_dtl.clm_loss_id%TYPE,
        item_no                     gicl_clm_recovery_dtl.item_no%TYPE,
        peril_cd                    gicl_clm_recovery_dtl.peril_cd%TYPE,
        recoverable_amt             gicl_clm_recovery_dtl.recoverable_amt%TYPE,
        user_id                     gicl_clm_recovery_dtl.user_id%TYPE,
        last_update                 gicl_clm_recovery_dtl.last_update%TYPE,
        cpi_rec_no       		    gicl_clm_recovery_dtl.cpi_rec_no%TYPE,
        cpi_branch_cd    		    gicl_clm_recovery_dtl.cpi_branch_cd%TYPE,
        dsp_item_no                 gicl_clm_item.item_title%TYPE,
        dsp_peril_cd                giis_peril.peril_sname%TYPE,
        dsp_chk_box                 VARCHAR2(1),
        dsp_tsi_amt                 gicl_item_peril.ann_tsi_amt%TYPE
        );
        
    TYPE gicl_clm_recovery_dtl_tab IS TABLE OF gicl_clm_recovery_dtl_type;
    
    FUNCTION get_gicl_clm_recovery_dtl(
        p_recovery_id                 gicl_clm_recovery_dtl.recovery_id%TYPE,
        p_claim_id                    gicl_clm_recovery_dtl.claim_id%TYPE,
        p_line_cd                     gicl_claims.line_cd%TYPE
        )
    RETURN gicl_clm_recovery_dtl_tab PIPELINED;     

END;
/


