CREATE OR REPLACE PACKAGE CPI.gicl_clm_adjuster_pkg
AS
   TYPE gicl_clm_adjuster_type IS RECORD (
      claim_id            gicl_clm_adjuster.claim_id%TYPE,
      clm_adj_id          gicl_clm_adjuster.clm_adj_id%TYPE,
      adj_company_cd      gicl_clm_adjuster.adj_company_cd%TYPE,
      priv_adj_cd         gicl_clm_adjuster.priv_adj_cd%TYPE,
      assign_date         VARCHAR2 (11),
      --gicl_clm_adjuster.assign_date%TYPE,
      cancel_tag          gicl_clm_adjuster.cancel_tag%TYPE,
      complt_date         VARCHAR2 (11),
      --gicl_clm_adjuster.complt_date%TYPE,
      delete_tag          gicl_clm_adjuster.delete_tag%TYPE,
      remarks             gicl_clm_adjuster.remarks%TYPE,
      surveyor_sw         gicl_clm_adjuster.surveyor_sw%TYPE,
      dsp_adj_co_name     VARCHAR2 (600), --VARCHAR2 (290), changed by robert from 290 to 600
      dsp_priv_adj_name   giis_adjuster.payee_name%TYPE
   );

   TYPE gicl_clm_adjuster_tab IS TABLE OF gicl_clm_adjuster_type;

   FUNCTION get_clm_adjuster_listing (
      p_claim_id   gicl_clm_adjuster.claim_id%TYPE
   )
      RETURN gicl_clm_adjuster_tab PIPELINED;

   PROCEDURE pre_del_adjuster (
      p_claim_id               gicl_clm_loss_exp.claim_id%TYPE,
      p_adj_company_cd         gicl_clm_loss_exp.payee_cd%TYPE,
      p_cancel           OUT   VARCHAR2,
      p_cnt_exist        OUT   VARCHAR2
   );

   PROCEDURE set_gicl_clm_adjuster (
      p_clm_adj_id       gicl_clm_adjuster.clm_adj_id%TYPE,
      p_claim_id         gicl_clm_adjuster.claim_id%TYPE,
      p_adj_company_cd   gicl_clm_adjuster.adj_company_cd%TYPE,
      p_priv_adj_cd      gicl_clm_adjuster.priv_adj_cd%TYPE,
      p_assign_date      gicl_clm_adjuster.assign_date%TYPE,
      p_cancel_tag       gicl_clm_adjuster.cancel_tag%TYPE,
      p_complt_date      gicl_clm_adjuster.complt_date%TYPE,
      p_delete_tag       gicl_clm_adjuster.delete_tag%TYPE,
      p_user_id          gicl_clm_adjuster.user_id%TYPE,
      p_last_update      gicl_clm_adjuster.last_update%TYPE,
      p_remarks          gicl_clm_adjuster.remarks%TYPE,
      p_surveyor_sw      gicl_clm_adjuster.surveyor_sw%TYPE
   );

   PROCEDURE del_gicl_clm_adjuster (
      p_clm_adj_id   gicl_clm_adjuster.clm_adj_id%TYPE,
      p_claim_id     gicl_clm_adjuster.claim_id%TYPE
   );

   TYPE mc_evaluation_adjuster_type IS RECORD (
      payee_name   VARCHAR2 (290),
      clm_adj_id   gicl_clm_adjuster.clm_adj_id%TYPE
   );

   TYPE mc_evaluation_adjuster_tab IS TABLE OF mc_evaluation_adjuster_type;

   FUNCTION get_mc_evaluation_adjuster (
      p_claim_id    gicl_claims.claim_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN mc_evaluation_adjuster_tab PIPELINED;
      
   FUNCTION get_loss_exp_adjuster_list(p_claim_id  IN  GICL_CLAIMS.claim_id%TYPE)
    RETURN gicl_clm_adjuster_tab PIPELINED;
    
END;
/


