CREATE OR REPLACE PACKAGE CPI.GIIS_LOSS_EXP_PKG AS

    TYPE giis_loss_exp_type IS RECORD(
        line_cd             GIIS_LOSS_EXP.line_cd%TYPE,
        loss_exp_cd         GIIS_LOSS_EXP.loss_exp_cd%TYPE,
        loss_exp_desc       GIIS_LOSS_EXP.loss_exp_desc%TYPE,
        loss_exp_type       GIIS_LOSS_EXP.loss_exp_type%TYPE,
        user_id             GIIS_LOSS_EXP.user_id%TYPE,
        last_update         GIIS_LOSS_EXP.last_update%TYPE,
        remarks             GIIS_LOSS_EXP.remarks%TYPE,
        subline_cd          GIIS_LOSS_EXP.subline_cd%TYPE,
        comp_sw             GIIS_LOSS_EXP.comp_sw%TYPE,
        deductible_rate     GIIS_LOSS_EXP.deductible_rate%TYPE,
        part_sw             GIIS_LOSS_EXP.part_sw%TYPE,
        peril_cd            GIIS_LOSS_EXP.peril_cd%TYPE,
        lps_sw              GIIS_LOSS_EXP.lps_sw%TYPE,
        sum_ded_amt         NUMBER
    );
    
    TYPE giis_loss_exp_tab IS TABLE OF giis_loss_exp_type;
    
    TYPE giis_loss_exp_for_ded_type IS RECORD(
        ded_cd              GIIS_LOSS_EXP.loss_exp_cd%TYPE,
        ded_title           GIIS_LOSS_EXP.loss_exp_desc%TYPE,
        ded_type            CG_REF_CODES.rv_meaning%TYPE,
        ded_rate            GIIS_LOSS_EXP.deductible_rate%TYPE,
        ded_amount          GIPI_DEDUCTIBLES.deductible_amt%TYPE,
        ded_text            GIPI_DEDUCTIBLES.deductible_text%TYPE,
        ded_subline_cd      GIIS_LOSS_EXP.subline_cd%TYPE,
        comp_sw             GIIS_LOSS_EXP.comp_sw%TYPE,
        aggregate_sw        GIPI_DEDUCTIBLES.aggregate_sw%TYPE,
        ceiling_sw          GIPI_DEDUCTIBLES.ceiling_sw%TYPE,
        min_amt             GIPI_DEDUCTIBLES.min_amt%TYPE,
        max_amt             GIPI_DEDUCTIBLES.max_amt%TYPE,
        range_sw            GIPI_DEDUCTIBLES.range_sw%TYPE,
        deductible_type     GIIS_DEDUCTIBLE_DESC.ded_type%TYPE,
        ded_amt             GIPI_DEDUCTIBLES.deductible_amt%TYPE
    );
        
    TYPE giis_loss_exp_for_ded_tab IS TABLE OF giis_loss_exp_for_ded_type;
    
    TYPE mc_eval_deductible_type IS RECORD(
        loss_exp_cd     GIIS_LOSS_EXP.loss_exp_cd%TYPE,
        loss_exp_desc   GIIS_LOSS_EXP.loss_exp_desc%TYPE,
        amount          NUMBER,
        subline_cd      GIPI_POLBASIC.subline_cd%TYPE,
        ded_rate        GIIS_LOSS_EXP.deductible_rate%TYPE,
        comp_sw         GIIS_LOSS_EXP.comp_sw%TYPE,
        ded_text        GIPI_DEDUCTIBLES.deductible_text%TYPE
    );

    TYPE mc_eval_deductible_tab IS TABLE OF mc_eval_deductible_type;
    
    FUNCTION get_giis_loss_exp_list
        ( p_claim_id		IN    GICL_CLM_LOSS_EXP.claim_id%TYPE,	
          p_clm_loss_id		IN    GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
          p_item_no			IN    GICL_ITEM_PERIL.item_no%TYPE,
          p_peril_cd 		IN	  GICL_ITEM_PERIL.peril_cd%TYPE,
          p_payee_type	    IN    GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
          p_line_cd			IN    GICL_CLAIMS.line_cd%TYPE,
          p_subline_cd		IN    GICL_CLAIMS.subline_cd%TYPE,
          p_pol_iss_cd		IN    GICL_CLAIMS.pol_iss_cd%TYPE,
          p_issue_yy		IN	  GICL_CLAIMS.issue_yy%TYPE,
          p_pol_seq_no		IN    GICL_CLAIMS.pol_seq_no%TYPE,
          p_renew_no		IN	  GICL_CLAIMS.renew_no%TYPE,
          p_loss_date		IN	  GICL_CLAIMS.loss_date%TYPE )
          
     RETURN giis_loss_exp_tab PIPELINED;
     
    FUNCTION get_giis_loss_exp_lov_for_ded
        (p_claim_id      IN    GICL_CLAIMS.claim_id%TYPE,
         p_clm_loss_id   IN    GICL_CLM_LOSS_EXP.clm_loss_id%TYPE, 
         p_item_no       IN    GICL_ITEM_PERIL.item_no%TYPE,
         p_peril_cd      IN    GICL_ITEM_PERIL.peril_cd%TYPE,
         p_payee_type    IN    GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
         p_line_cd       IN    GICL_CLAIMS.line_cd%TYPE,
         p_subline_cd    IN    GICL_CLAIMS.subline_cd%TYPE,
         p_pol_iss_cd    IN    GICL_CLAIMS.pol_iss_cd%TYPE,
         p_issue_yy      IN    GICL_CLAIMS.issue_yy%TYPE,
         p_pol_seq_no    IN    GICL_CLAIMS.pol_seq_no%TYPE,
         p_renew_no      IN    GICL_CLAIMS.renew_no%TYPE,
         p_loss_date     IN    GICL_CLAIMS.loss_date%TYPE,
         p_pol_eff_date  IN    GICL_CLAIMS.pol_eff_date%TYPE,
         p_expiry_date   IN    GICL_CLAIMS.expiry_date%TYPE) 
     
     RETURN giis_loss_exp_for_ded_tab PIPELINED;
     
    FUNCTION get_deduct_list_for_mc_eval
    (p_claim_id         IN   GICL_CLAIMS.claim_id%TYPE,
     p_pol_line_cd      IN   GICL_CLAIMS.line_cd%TYPE,
     p_pol_subline_cd   IN   GICL_CLAIMS.subline_cd%TYPE,
     p_pol_iss_cd       IN   GICL_CLAIMS.pol_iss_cd%TYPE,
     p_pol_issue_yy     IN   GICL_CLAIMS.issue_yy%TYPE,
     p_pol_seq_no       IN   GICL_CLAIMS.pol_seq_no%TYPE,
     p_pol_renew_no     IN   GICL_CLAIMS.renew_no%TYPE,
     p_loss_date        IN   GICL_CLAIMS.loss_date%TYPE,
     p_item_no          IN   GICL_MC_EVALUATION.item_no%TYPE,
     p_peril_cd         IN   GICL_MC_EVALUATION.peril_cd%TYPE)
     
     RETURN mc_eval_deductible_tab PIPELINED;
    
     PROCEDURE get_orig_surplus_amt
     (p_claim_id        IN    gicl_motor_car_dtl.claim_id%TYPE,
      p_item_no         IN    gicl_motor_car_dtl.item_no%TYPE,
      p_loss_exp_cd     IN    gicl_mc_part_cost.loss_exp_cd%TYPE,
      p_tag             IN    VARCHAR2,
      p_amount          OUT   gicl_mc_part_cost.orig_amt%TYPE);
END;
/


