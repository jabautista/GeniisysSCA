CREATE OR REPLACE PACKAGE CPI.GICL_LOSS_EXP_TAX_PKG AS

/****************************************************************
 * PACKAGE NAME : GICL_LOSS_EXP_TAX_PKG
 * MODULE NAME  : GIACS017
 * CREATED BY   : RENCELA
 * DATE CREATED : 2011-07-14
 * MODIFICATIONS-------------------------------------------------
 * MODIFIED BY  | DATE      | REMARKS 
 * RENCELA        20110714    MODULE CREATED 
*****************************************************************/                           

   TYPE loss_exp_tax_type IS RECORD(
       claim_id         GICL_LOSS_EXP_TAX.claim_id%TYPE,
       clm_loss_id      GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
       tax_id           GICL_LOSS_EXP_TAX.tax_id%TYPE,
       tax_cd           GICL_LOSS_EXP_TAX.tax_cd%TYPE,
       tax_name         GIIS_LOSS_TAXES.tax_name%TYPE,
       tax_type         GICL_LOSS_EXP_TAX.tax_type%TYPE,
       loss_exp_cd      GICL_LOSS_EXP_TAX.loss_exp_cd%TYPE,
       base_amt         GICL_LOSS_EXP_TAX.base_amt%TYPE,
       user_id          GICL_LOSS_EXP_TAX.user_id%TYPE,
       last_update      GICL_LOSS_EXP_TAX.last_update%TYPE,
       tax_amt          GICL_LOSS_EXP_TAX.tax_amt%TYPE,
       tax_pct          GICL_LOSS_EXP_TAX.tax_pct%TYPE,
       adv_tag          GICL_LOSS_EXP_TAX.adv_tag%TYPE,
       net_tag          GICL_LOSS_EXP_TAX.net_tag%TYPE,
       cpi_rec_no       GICL_LOSS_EXP_TAX.cpi_rec_no%TYPE,
       cpi_branch_cd    GICL_LOSS_EXP_TAX.cpi_branch_cd%TYPE,
       w_tax            GICL_LOSS_EXP_TAX.w_tax%TYPE,
       sl_type_cd       GICL_LOSS_EXP_TAX.sl_type_cd%TYPE,
       sl_cd            GICL_LOSS_EXP_TAX.sl_cd%TYPE
   ); 
   
   TYPE loss_exp_tax_tab IS TABLE OF loss_exp_tax_type;

   FUNCTION get_loss_exp_taxes(
            p_claim_id      GICL_LOSS_EXP_TAX.claim_id%TYPE,
            p_clm_loss_id   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
            p_tax_id        GICL_LOSS_EXP_TAX.tax_id%TYPE,
            p_tax_cd        GICL_LOSS_EXP_TAX.tax_cd%TYPE,
            p_tax_type      GICL_LOSS_EXP_TAX.tax_type%TYPE
   )RETURN loss_exp_tax_tab PIPELINED;
   
   FUNCTION check_exist_loss_exp_tax
    (p_claim_id     IN   GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE)
     
     RETURN VARCHAR2;
     
   FUNCTION check_exist_loss_exp_tax_2
    (p_claim_id     IN   GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
     p_loss_exp_cd  IN   GICL_LOSS_EXP_TAX.loss_exp_cd%TYPE)
     
     RETURN VARCHAR2;
     
   FUNCTION get_count_loss_exp_tax 
    (p_claim_id     IN   GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE)
     
    RETURN NUMBER;
    
   PROCEDURE delete_loss_exp_tax(p_claim_id      GICL_LOSS_EXP_TAX.claim_id%TYPE,
                                 p_clm_loss_id   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE);
                                 
   PROCEDURE delete_loss_exp_tax_2(p_claim_id      GICL_LOSS_EXP_TAX.claim_id%TYPE,
                                   p_clm_loss_id   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
                                   p_loss_exp_cd   GICL_LOSS_EXP_TAX.loss_exp_cd%TYPE);
                                   
   FUNCTION get_gicl_loss_exp_tax_list(p_claim_id     IN    GICL_LOSS_EXP_TAX.claim_id%TYPE,
                                       p_clm_loss_id  IN    GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
                                       p_iss_cd       IN    GICL_CLAIMS.iss_cd%TYPE )
    RETURN loss_exp_tax_tab PIPELINED;
    
   FUNCTION get_next_tax_id(p_claim_id      IN  GICL_CLAIMS.claim_id%TYPE,
                            p_clm_loss_id   IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE)
    RETURN NUMBER;
    
   PROCEDURE set_gicl_loss_exp_tax
    (p_claim_id     IN   GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_tax_id       IN   GICL_LOSS_EXP_TAX.tax_id%TYPE,
     p_tax_cd       IN   GICL_LOSS_EXP_TAX.tax_cd%TYPE,
     p_tax_type     IN   GICL_LOSS_EXP_TAX.tax_type%TYPE,
     p_loss_exp_cd  IN   GICL_LOSS_EXP_TAX.loss_exp_cd%TYPE,
     p_base_amt     IN   GICL_LOSS_EXP_TAX.base_amt%TYPE,
     p_tax_amt      IN   GICL_LOSS_EXP_TAX.tax_amt%TYPE,
     p_tax_pct      IN   GICL_LOSS_EXP_TAX.tax_pct%TYPE,
     p_adv_tag      IN   GICL_LOSS_EXP_TAX.adv_tag%TYPE,
     p_net_tag      IN   GICL_LOSS_EXP_TAX.net_tag%TYPE,
     p_w_tax        IN   GICL_LOSS_EXP_TAX.w_tax%TYPE,
     p_sl_type_cd   IN   GICL_LOSS_EXP_TAX.sl_type_cd%TYPE,
     p_sl_cd        IN   GICL_LOSS_EXP_TAX.sl_cd%TYPE,
     p_user_id      IN   GICL_LOSS_EXP_TAX.user_id%TYPE);
     
   PROCEDURE delete_loss_exp_tax_3
    (p_claim_id    IN  GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id IN  GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
     p_tax_id      IN  GICL_LOSS_EXP_TAX.tax_id%TYPE,
     p_tax_cd      IN  GICL_LOSS_EXP_TAX.tax_cd%TYPE,
     p_tax_type    IN  GICL_LOSS_EXP_TAX.tax_type%TYPE);
     
   PROCEDURE gicls030_c009_key_commit
    (p_claim_id      IN     GICL_CLAIMS.claim_id%TYPE,
     p_clm_loss_id   IN     GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
     p_user_id       IN     GICL_CLM_LOSS_EXP.user_id%TYPE );
     
   FUNCTION get_count_loss_exp_tax_2 
        (p_claim_id         IN   GICL_LOSS_EXP_TAX.claim_id%TYPE,
         p_clm_loss_id      IN   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
         p_ded_loss_exp_cd  IN   GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE)   
    RETURN NUMBER;
    
   PROCEDURE delete_loss_exp_tax_4
    (p_claim_id         IN  GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id      IN  GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
     p_ded_loss_exp_cd  IN  GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE);
     
   FUNCTION get_count_loss_exp_tax_3 
    (p_claim_id         IN   GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id      IN   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
     p_loss_exp_cd      IN   GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
     p_ded_loss_exp_cd  IN   GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE)
   RETURN NUMBER;
   
   PROCEDURE delete_loss_exp_tax_5
    (p_claim_id         IN  GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id      IN  GICL_LOSS_EXP_TAX.clm_loss_id%TYPE,
     p_loss_exp_cd      IN  GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
     p_ded_loss_exp_cd  IN  GICL_LOSS_EXP_DTL.ded_loss_exp_cd%TYPE);
    
   FUNCTION check_loss_exp_tax_type
    (p_claim_id     IN   GICL_LOSS_EXP_TAX.claim_id%TYPE,
     p_clm_loss_id  IN   GICL_LOSS_EXP_TAX.clm_loss_id%TYPE)
     
    RETURN NUMBER;
    
END;
/


