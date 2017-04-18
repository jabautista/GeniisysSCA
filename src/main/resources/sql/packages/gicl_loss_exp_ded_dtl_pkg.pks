CREATE OR REPLACE PACKAGE CPI.GICL_LOSS_EXP_DED_DTL_PKG AS

    TYPE gicl_loss_exp_ded_dtl_type IS RECORD(
        claim_id        GICL_LOSS_EXP_DED_DTL.claim_id%TYPE,
        clm_loss_id     GICL_LOSS_EXP_DED_DTL.clm_loss_id%TYPE,
        line_cd         GICL_LOSS_EXP_DED_DTL.line_cd%TYPE,
        subline_cd      GICL_LOSS_EXP_DED_DTL.subline_cd%TYPE,
        loss_exp_type   GICL_LOSS_EXP_DED_DTL.loss_exp_type%TYPE,
        loss_exp_cd     GICL_LOSS_EXP_DED_DTL.loss_exp_cd%TYPE,
        dsp_exp_desc    GIIS_LOSS_EXP.loss_exp_desc%TYPE,
        loss_amt        GICL_LOSS_EXP_DED_DTL.loss_amt%TYPE,
        ded_cd          GICL_LOSS_EXP_DED_DTL.ded_cd%TYPE,
        dsp_ded_desc    GIIS_LOSS_EXP.loss_exp_desc%TYPE,
        ded_amt         GICL_LOSS_EXP_DED_DTL.ded_amt%TYPE,
        ded_rate        GICL_LOSS_EXP_DED_DTL.ded_rate%TYPE,
        user_id         GICL_LOSS_EXP_DED_DTL.user_id%TYPE,
        last_update     GICL_LOSS_EXP_DED_DTL.last_update%TYPE,
        aggregate_sw    GICL_LOSS_EXP_DED_DTL.aggregate_sw%TYPE,
        ceiling_sw      GICL_LOSS_EXP_DED_DTL.ceiling_sw%TYPE,
        min_amt         GICL_LOSS_EXP_DED_DTL.min_amt%TYPE,
        max_amt         GICL_LOSS_EXP_DED_DTL.max_amt%TYPE,
        range_sw        GICL_LOSS_EXP_DED_DTL.range_sw%TYPE
    );

    TYPE gicl_loss_exp_ded_dtl_tab IS TABLE OF gicl_loss_exp_ded_dtl_type;
    
    FUNCTION check_exist_loss_exp_ded_dtl
        (p_claim_id     IN  GICL_LOSS_EXP_DED_DTL.claim_id%TYPE,
         p_clm_loss_id  IN  GICL_LOSS_EXP_DED_DTL.clm_loss_id%TYPE,
         p_loss_exp_cd  IN  GICL_LOSS_EXP_DED_DTL.loss_exp_cd%TYPE )
    
    RETURN VARCHAR2;
    
    PROCEDURE delete_loss_exp_ded_dtl
        (p_claim_id     IN  GICL_CLAIMS.claim_id%TYPE,
         p_clm_loss_id  IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
         p_loss_exp_cd  IN  GICL_LOSS_EXP_DED_DTL.loss_exp_cd%TYPE);
    
    FUNCTION get_gicl_loss_exp_ded_dtl_list
    (p_claim_id     IN   GICL_LOSS_EXP_DED_DTL.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_LOSS_EXP_DED_DTL.clm_loss_id%TYPE,
     p_loss_exp_cd  IN   GICL_LOSS_EXP_DED_DTL.loss_exp_cd%TYPE,
     p_line_cd      IN   GICL_CLAIMS.line_cd%TYPE,
     p_subline_cd   IN   GICL_LOSS_EXP_DTL.subline_cd%TYPE,
     p_payee_type   IN   GICL_LOSS_EXP_PAYEES.payee_type%TYPE)
        
    RETURN gicl_loss_exp_ded_dtl_tab PIPELINED;
    
    PROCEDURE delete_loss_exp_ded_dtl_2
    (p_claim_id     IN  GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id  IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_loss_exp_cd  IN  GICL_LOSS_EXP_DED_DTL.loss_exp_cd%TYPE);
     
    PROCEDURE insert_le_ded_dtl_for_all
    (p_claim_id         IN  GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id      IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_line_cd          IN  GICL_CLAIMS.line_cd%TYPE,
     p_subline_cd       IN  GICL_LOSS_EXP_DTL.subline_cd%TYPE,
     p_payee_type       IN  GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_loss_exp_cd      IN  GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
     p_dtl_amt          IN  GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
     p_ded_rate         IN  GICL_LOSS_EXP_DTL.ded_rate%TYPE,
     p_ded_aggregate_sw IN  GIPI_DEDUCTIBLES.aggregate_sw%TYPE,
     p_nbt_ceiling_sw   IN  GIPI_DEDUCTIBLES.ceiling_sw%TYPE,
     p_nbt_min_amt      IN  GIPI_DEDUCTIBLES.min_amt%TYPE,
     p_nbt_max_amt      IN  GIPI_DEDUCTIBLES.max_amt%TYPE,
     p_nbt_range_sw     IN  GIPI_DEDUCTIBLES.range_sw%TYPE,
     p_user_id          IN  GIIS_USERS.user_id%TYPE);
     
    PROCEDURE insert_le_ded_dtl_not_for_all
    (p_claim_id         IN  GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id      IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_line_cd          IN  GICL_CLAIMS.line_cd%TYPE,
     p_subline_cd       IN  GICL_LOSS_EXP_DTL.subline_cd%TYPE,
     p_payee_type       IN  GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_loss_exp_cd      IN  GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
     p_ded_loss_exp_cd  IN  GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE,
     p_dtl_amt          IN  GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
     p_ded_rate         IN  GICL_LOSS_EXP_DTL.ded_rate%TYPE,
     p_ded_aggregate_sw IN  GIPI_DEDUCTIBLES.aggregate_sw%TYPE,
     p_nbt_ceiling_sw   IN  GIPI_DEDUCTIBLES.ceiling_sw%TYPE,
     p_nbt_min_amt      IN  GIPI_DEDUCTIBLES.min_amt%TYPE,
     p_nbt_max_amt      IN  GIPI_DEDUCTIBLES.max_amt%TYPE,
     p_nbt_range_sw     IN  GIPI_DEDUCTIBLES.range_sw%TYPE,
     p_user_id          IN  GIIS_USERS.user_id%TYPE);
     
    PROCEDURE delete_excess_loss_exp_ded_dtl
    (p_claim_id     IN   GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_CLM_LOSS_EXP.clm_loss_id%TYPE);
    
END;
/


