CREATE OR REPLACE PACKAGE CPI.GICL_LOSS_EXP_DTL_PKG AS

    TYPE gicl_loss_exp_dtl_type IS RECORD(
        claim_id            GICL_LOSS_EXP_DTL.claim_id%TYPE,
        clm_loss_id         GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
        loss_exp_cd         GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
        dsp_exp_desc        GIIS_LOSS_EXP.loss_exp_desc%TYPE,
        no_of_units         GICL_LOSS_EXP_DTL.no_of_units%TYPE,
        nbt_no_of_units     GICL_LOSS_EXP_DTL.no_of_units%TYPE,
        ded_base_amt        GICL_LOSS_EXP_DTL.ded_base_amt%TYPE,
        dtl_amt             GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
        subline_cd          GICL_LOSS_EXP_DTL.subline_cd%TYPE,
        original_sw         GICL_LOSS_EXP_DTL.original_sw%TYPE,
        w_tax               GICL_LOSS_EXP_DTL.w_tax%TYPE,
        nbt_net_amt         NUMBER,  
        loss_exp_class      GICL_LOSS_EXP_DTL.loss_exp_class%TYPE, 
        ded_loss_exp_cd     GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE,
        ded_rate            GICL_LOSS_EXP_DTL.ded_rate%TYPE,        
        deductible_text     GICL_LOSS_EXP_DTL.deductible_text%TYPE,
        user_id             GICL_LOSS_EXP_DTL.user_id%TYPE,
        last_update         GICL_LOSS_EXP_DTL.last_update%TYPE,
        loss_exp_type       GICL_LOSS_EXP_DTL.loss_exp_type%TYPE,
        line_cd             GICL_LOSS_EXP_DTL.line_cd%TYPE,
        nbt_comp_sw         GIIS_LOSS_EXP.comp_sw%TYPE,
        dsp_ded_le_desc     GIIS_LOSS_EXP.loss_exp_desc%TYPE,
        nbt_ded_type        CG_REF_CODES.rv_meaning%TYPE,
        nbt_deductible_type GIIS_DEDUCTIBLE_DESC.ded_type%TYPE,
        nbt_min_amt         GIIS_DEDUCTIBLE_DESC.min_amt%TYPE,
        nbt_max_amt         GIIS_DEDUCTIBLE_DESC.max_amt%TYPE,
        nbt_range_sw        GIIS_DEDUCTIBLE_DESC.range_sw%TYPE
    );
    
    TYPE gicl_loss_exp_dtl_tab IS TABLE OF gicl_loss_exp_dtl_type;
    
    TYPE loss_dtl_rg_type IS RECORD(
        loss_exp_cd         VARCHAR2(50),--  GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
        loss_exp_desc       VARCHAR2(500),
        loss_amt            NUMBER,
        net_of_input_tax    NUMBER,
        w_tax               GICL_LOSS_EXP_DTL.w_tax%TYPE
    );

    TYPE loss_dtl_rg_tab IS TABLE OF loss_dtl_rg_type;
    
    TYPE loss_exp_dtl_ded_rg_type IS RECORD(
        loss_exp_cd         GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
        loss_exp_desc       GIIS_LOSS_EXP.loss_exp_desc%TYPE,
        dtl_amt             GICL_LOSS_EXP_DTL.dtl_amt%TYPE
    );
    
    TYPE dtl_loa_csl_type IS RECORD(
        claim_id        GICL_LOSS_EXP_DTL.claim_id%TYPE,
        clm_loss_id     GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
        loss_exp_cd     GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
        nbt_exp_desc    GIIS_LOSS_EXP.loss_exp_desc%TYPE,
        dtl_amt         GICL_LOSS_EXP_DTL.dtl_amt%TYPE
    );

    TYPE dtl_loa_csl_tab IS TABLE OF dtl_loa_csl_type;

    TYPE loss_exp_dtl_ded_rg_tab IS TABLE OF loss_exp_dtl_ded_rg_type;
    
    FUNCTION get_gicl_loss_exp_dtl (p_claim_id      GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                    p_clm_loss_id   GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
                                    p_line_cd       GICL_CLAIMS.line_cd%TYPE,
                                    p_payee_type    GICL_LOSS_EXP_PAYEES.payee_type%TYPE)
                                    
    RETURN gicl_loss_exp_dtl_tab PIPELINED;
    
    FUNCTION check_exist_loss_exp_dtl(p_claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                      p_clm_loss_id     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
    RETURN VARCHAR2;
    
    PROCEDURE set_gicl_loss_exp_dtl
    (p_claim_id        IN  GICL_LOSS_EXP_DTL.claim_id%TYPE,       
     p_clm_loss_id     IN  GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,  
     p_loss_exp_cd     IN  GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,                 
     p_no_of_units     IN  GICL_LOSS_EXP_DTL.no_of_units%TYPE,     
     p_ded_base_amt    IN  GICL_LOSS_EXP_DTL.ded_base_amt%TYPE,
     p_dtl_amt         IN  GICL_LOSS_EXP_DTL.dtl_amt%TYPE,   
     p_line_cd         IN  GICL_LOSS_EXP_DTL.line_cd%TYPE,
     p_loss_exp_type   IN  GICL_LOSS_EXP_DTL.loss_exp_type%TYPE,
     p_loss_exp_class  IN  GICL_LOSS_EXP_DTL.loss_exp_class%TYPE,                  
     p_original_sw     IN  GICL_LOSS_EXP_DTL.original_sw%TYPE,    
     p_w_tax           IN  GICL_LOSS_EXP_DTL.w_tax%TYPE,                
     p_user_id         IN  GICL_LOSS_EXP_DTL.user_id%TYPE);
     
    PROCEDURE delete_loss_exp_dtl(p_claim_id      IN   GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                  p_clm_loss_id   IN   GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
                                  p_loss_exp_cd   IN   GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE);
    
    PROCEDURE delete_loss_exp_dtl_2(p_claim_id      IN   GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                    p_clm_loss_id   IN   GICL_LOSS_EXP_DTL.clm_loss_id%TYPE);
                                    
    FUNCTION get_loss_exp_dtl_for_ded (p_claim_id    IN  GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                       p_clm_loss_id IN  GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
                                       p_line_cd     IN  GICL_CLAIMS.line_cd%TYPE,
                                       p_payee_type  IN  GICL_LOSS_EXP_PAYEES.payee_type%TYPE)

    RETURN gicl_loss_exp_dtl_tab PIPELINED;
  
    FUNCTION check_exist_depreciation(p_claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                      p_clm_loss_id     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
    RETURN VARCHAR2;
    
    FUNCTION check_exist_orig_part(p_claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                   p_clm_loss_id     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
    RETURN VARCHAR2;
    
    FUNCTION check_exist_loss_exp_dtl_2(p_claim_id        GICL_CLM_LOSS_EXP.claim_id%TYPE,
                                        p_clm_loss_id     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
                                        p_loss_exp_cd     GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE)
    RETURN VARCHAR2;
    
    PROCEDURE delete_ded_equals_all(p_claim_id      IN   GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                    p_clm_loss_id   IN   GICL_LOSS_EXP_DTL.clm_loss_id%TYPE);
                                    
    FUNCTION get_loss_dtl_rg_n
    (p_line_cd       IN      GICL_CLAIMS.line_cd%TYPE,
     p_claim_id      IN      GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id   IN      GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_payee_type    IN      GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_tax_cd        IN      GICL_LOSS_EXP_TAX.tax_cd%TYPE,
     p_tax_type      IN      GICL_LOSS_EXP_TAX.tax_type%TYPE)
     
    RETURN loss_dtl_rg_tab PIPELINED;
    
    FUNCTION get_loss_dtl_rg_y
    (p_line_cd       IN      GICL_CLAIMS.line_cd%TYPE,
     p_claim_id      IN      GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id   IN      GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_payee_type    IN      GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_tax_cd        IN      GICL_LOSS_EXP_TAX.tax_cd%TYPE,
     p_tax_type      IN      GICL_LOSS_EXP_TAX.tax_type%TYPE)
     
     RETURN loss_dtl_rg_tab PIPELINED;
     
    FUNCTION get_loss_dtl_won_rg
    (p_line_cd       IN      GICL_CLAIMS.line_cd%TYPE,
     p_claim_id      IN      GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id   IN      GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_payee_type    IN      GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_tax_cd        IN      GICL_LOSS_EXP_TAX.tax_cd%TYPE,
     p_tax_type      IN      GICL_LOSS_EXP_TAX.tax_type%TYPE)
     
    RETURN loss_dtl_rg_tab PIPELINED;
	
	FUNCTION get_loss_dtl_won_rg_new
    (p_line_cd       IN      GICL_CLAIMS.line_cd%TYPE,
     p_claim_id      IN      GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id   IN      GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_payee_type    IN      GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_tax_cd        IN      GICL_LOSS_EXP_TAX.tax_cd%TYPE,
     p_tax_type      IN      GICL_LOSS_EXP_TAX.tax_type%TYPE)
     
    RETURN loss_dtl_rg_tab PIPELINED;
    
    FUNCTION check_exist_loss_dtl_all_wtax
    (p_claim_id     IN    GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id  IN    GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
    RETURN VARCHAR;
    
    FUNCTION get_deductible_loss_exp_list
    (p_claim_id    IN   GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id IN   GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
     
    RETURN loss_exp_dtl_ded_rg_tab PIPELINED;
    
    FUNCTION get_deductible_loss_exp_list_2
    (p_claim_id    IN   GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id IN   GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
     
    RETURN loss_exp_dtl_ded_rg_tab PIPELINED;
    
    FUNCTION check_exist_ded_equals_all(p_claim_id      IN   GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                        p_clm_loss_id   IN   GICL_LOSS_EXP_DTL.clm_loss_id%TYPE)
    RETURN VARCHAR2;
    
    PROCEDURE set_gicl_loss_exp_dtl_2
    (p_claim_id         IN  GICL_LOSS_EXP_DTL.claim_id%TYPE,       
     p_clm_loss_id      IN  GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,  
     p_loss_exp_cd      IN  GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,                 
     p_no_of_units      IN  GICL_LOSS_EXP_DTL.no_of_units%TYPE,     
     p_ded_base_amt     IN  GICL_LOSS_EXP_DTL.ded_base_amt%TYPE,
     p_dtl_amt          IN  GICL_LOSS_EXP_DTL.dtl_amt%TYPE,   
     p_line_cd          IN  GICL_LOSS_EXP_DTL.line_cd%TYPE,
     p_loss_exp_type    IN  GICL_LOSS_EXP_DTL.loss_exp_type%TYPE,                   
     p_original_sw      IN  GICL_LOSS_EXP_DTL.original_sw%TYPE,                    
     p_user_id          IN  GICL_LOSS_EXP_DTL.user_id%TYPE,
     p_subline_cd       IN  GICL_LOSS_EXP_DTL.subline_cd%TYPE,
     p_ded_loss_exp_cd  IN  GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE,
     p_ded_rate         IN  VARCHAR2,  --Kenneth 07102015 SR 4204
     p_deductible_text  IN  GICL_LOSS_EXP_DTL.deductible_text%TYPE);
     
    FUNCTION get_dtl_loa_list(p_claim_id    IN  GICL_CLAIMS.claim_id%TYPE,
                              p_clm_loss_id IN  GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
                              p_line_cd     IN  GICL_CLAIMS.line_cd%TYPE)
    RETURN dtl_loa_csl_tab PIPELINED;
    
    FUNCTION get_dtl_csl_list(p_claim_id    IN  GICL_CLAIMS.claim_id%TYPE,
                              p_clm_loss_id IN  GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
                              p_line_cd     IN  GICL_CLAIMS.line_cd%TYPE)
    RETURN dtl_loa_csl_tab PIPELINED;
	
	FUNCTION get_all_gicl_loss_exp_dtl (p_claim_id      GICL_LOSS_EXP_DTL.claim_id%TYPE,
                                        p_clm_loss_id   GICL_LOSS_EXP_DTL.clm_loss_id%TYPE,
                                        p_line_cd       GICL_CLAIMS.line_cd%TYPE,
                                        p_payee_type    GICL_LOSS_EXP_PAYEES.payee_type%TYPE)
    RETURN gicl_loss_exp_dtl_tab PIPELINED;

END gicl_loss_exp_dtl_pkg;
/


