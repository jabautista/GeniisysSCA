CREATE OR REPLACE PACKAGE CPI.gicl_eval_csl_pkg
AS
/******************************************************************************
   NAME:       gicl_eval_csl_pkg
   PURPOSE:    gicl_eval_csl related functions and procedures

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2/29/2012   Irwin Tabisora 1. Created this package.
******************************************************************************/
   TYPE mc_eval_csl_type IS RECORD (
      payee_cd         gicl_eval_loa.payee_cd%TYPE,
      payee_type_cd    gicl_replace.payee_type_cd%TYPE,
      eval_id          gicl_eval_loa.eval_id%TYPE,
      dsp_class_desc   giis_payee_class.class_desc%TYPE,
      payee_name       giis_payees.payee_last_name%TYPE,
      csl_no           VARCHAR2 (100),
      base_amt         gicl_replace.part_amt%TYPE,
      clm_loss_id      gicl_eval_csl.clm_loss_id%TYPE
   );

   TYPE mc_eval_csl_tab IS TABLE OF mc_eval_csl_type;

   TYPE mc_eval_csl_dtl_type IS RECORD (
      loss_exp_cd     gicl_replace.loss_exp_cd%TYPE,
      part_amt        gicl_replace.part_amt%TYPE,
      loss_exp_desc   giis_loss_exp.loss_exp_desc%TYPE,
      payee_cd        gicl_replace.payee_cd%TYPE,
      payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      eval_id         gicl_replace.eval_id%TYPE
   );

   TYPE mc_eval_csl_dtl_tab IS TABLE OF mc_eval_csl_dtl_type;

   FUNCTION get_mc_eval_csl (
      p_eval_id          gicl_eval_csl.eval_id%TYPE,
      p_dsp_class_desc   giis_payee_class.class_desc%TYPE,
      p_payee_name       giis_payees.payee_last_name%TYPE,
      p_base_amt         VARCHAR2,
      p_csl_no           VARCHAR2
   )
      RETURN mc_eval_csl_tab PIPELINED;

   FUNCTION get_mc_eval_csl_dtl (
      p_eval_id         gicl_eval_loa.eval_id%TYPE,
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_loa.payee_cd%TYPE
   )
      RETURN mc_eval_csl_dtl_tab PIPELINED;

   FUNCTION get_total_part_amt (
      p_eval_id         gicl_eval_loa.eval_id%TYPE,
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_loa.payee_cd%TYPE
   )
      RETURN gicl_replace.part_amt%TYPE;

   PROCEDURE generate_csl (
      p_claim_id        gicl_mc_evaluation.claim_id%TYPE,
      p_item_no         gicl_mc_evaluation.item_no%TYPE,
      p_eval_id         gicl_mc_evaluation.eval_id%TYPE,
      p_tp_sw           gicl_mc_evaluation.tp_sw%TYPE,
      p_subline_cd      gicl_claims.subline_cd%TYPE,
      p_iss_cd          gicl_claims.iss_cd%TYPE,
      p_clm_yy          gicl_claims.clm_yy%TYPE,
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_loa.payee_cd%TYPE,
      p_remarks         gicl_eval_loa.remarks%TYPE
   );
   
   PROCEDURE generate_csl_from_loss_exp
    (p_claim_id         IN      GICL_CLAIMS.claim_id%TYPE,
     p_subline_cd       IN      GICL_CLAIMS.subline_cd%TYPE,
     p_iss_cd           IN      GICL_CLAIMS.iss_cd%TYPE,
     p_clm_yy           IN      GICL_CLAIMS.clm_yy%TYPE,
     p_item_no          IN      GICL_ITEM_PERIL.item_no%TYPE,
     p_payee_class_cd   IN      GICL_EVAL_CSL.payee_type_cd%TYPE,
     p_payee_cd         IN      GICL_EVAL_CSL.payee_cd%TYPE,
     p_clm_loss_id      IN      GICL_EVAL_CSL.clm_loss_id%TYPE,
     p_tp_sw            IN      GICL_EVAL_CSL.tp_sw%TYPE,
     p_remarks          IN      GICL_EVAL_CSL.remarks%TYPE,
     p_cancel_sw        IN      GICL_EVAL_CSL.cancel_sw%TYPE,
     p_eval_id          IN      GICL_EVAL_CSL.eval_id%TYPE);
     
     TYPE giclr030_cash_settlement_type IS RECORD (
      assured_name     gicl_claims.assured_name%TYPE,
      contact_person   VARCHAR2 (250),
      intm             giis_intermediary.intm_name%TYPE,
      addressa          VARCHAR2 (32767),
      addressb          VARCHAR2 (32767),
      addressc          VARCHAR2 (32767),
      dear_to          giis_intermediary.intm_name%TYPE,
      address          VARCHAR2 (32767)                        := NULL,
      to_name          VARCHAR2 (32767)                        := NULL,
      claim_no         VARCHAR2 (50)                           := ' ',
      policy_no        VARCHAR2 (50)                           := ' ',
      dlbl             VARCHAR2 (1000)                         := NULL,
      c                VARCHAR2 (20)                           := NULL,
      loss_date        VARCHAR2 (32767)                        := NULL,
      curr            varchar2(5),
      net_claim        gicl_replace.part_amt%TYPE,
      NET_CLAIM_CHAR    VARCHAR2(32767),
      caption_claim    VARCHAR2 (20),
      total_loss       VARCHAR2 (500)                          := '.',
      lbl              VARCHAR2 (500)                          := ' ',
      nlabel           VARCHAR2 (500)                          := ' ',
      market_value     gicl_replace.part_amt%TYPE,
      MARKET_VALUE_CHAR    VARCHAR2(32767),
      reqd_docs        VARCHAR2 (32767)                        := NULL,
      signatory        giis_signatory_names.signatory%TYPE,
      designation      giis_signatory_names.designation%TYPE,
      dept_lbl         giac_rep_signatory.label%TYPE,
      TOTAL_TAG VARCHAR2(1)
   );

   TYPE giclr030_cash_settlement_tab IS TABLE OF giclr030_cash_settlement_type;

   FUNCTION get_giclr030_details (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_payee_cd         giis_payees.payee_no%TYPE,
      p_eval_id          gicl_eval_payment.eval_id%TYPE,
      p_iss_cd           gicl_claims.iss_cd%TYPE,
      p_line_cd          gicl_claims.line_cd%TYPE,
      p_class_desc       giis_payee_class.class_desc%TYPE,
      p_clm_loss_id      gicl_clm_loss_exp.claim_id%TYPE,
      p_peril_cd         gicl_item_peril.peril_cd%TYPE,
      p_item_no          GICL_ITEM_PERIL.item_no%TYPE,
      p_module_id     VARCHAR2
   )
      RETURN giclr030_cash_settlement_tab PIPELINED;
END gicl_eval_csl_pkg;
/


