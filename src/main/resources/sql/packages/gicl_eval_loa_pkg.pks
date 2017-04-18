CREATE OR REPLACE PACKAGE CPI.gicl_eval_loa_pkg
AS
/******************************************************************************
   NAME:       gicl_eval_loa_pkg
   PURPOSE:    gicl_eval_loa related functions and procedures

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2/27/2012   Irwin Tabisora 1. Created this package.
******************************************************************************/
   TYPE mc_eval_loa_type IS RECORD (
      payee_cd         gicl_eval_loa.payee_cd%TYPE,
      payee_type_cd    gicl_replace.payee_type_cd%TYPE,
      eval_id          gicl_eval_loa.eval_id%TYPE,
      dsp_class_desc   giis_payee_class.class_desc%TYPE,
      payee_name       giis_payees.payee_last_name%TYPE,
      loa_no           VARCHAR2 (100),
      base_amt         gicl_replace.part_amt%TYPE,
      clm_loss_id      gicl_eval_loa.clm_loss_id%TYPE,
      remarks          gicl_eval_loa.remarks%TYPE
   );

   TYPE mc_eval_loa_tab IS TABLE OF mc_eval_loa_type;

   FUNCTION get_mc_eval_loa (
      p_eval_id          gicl_eval_loa.eval_id%TYPE,
      p_dsp_class_desc   giis_payee_class.class_desc%TYPE,
      p_payee_name       giis_payees.payee_last_name%TYPE,
      p_base_amt         VARCHAR2,
      p_loa_no           VARCHAR2
   )
      RETURN mc_eval_loa_tab PIPELINED;

   TYPE mc_eval_loa_dtl_type IS RECORD (
      loss_exp_cd     gicl_replace.loss_exp_cd%TYPE,
      part_amt        gicl_replace.part_amt%TYPE,
      loss_exp_desc   giis_loss_exp.loss_exp_desc%TYPE,
      payee_cd        gicl_replace.payee_cd%TYPE,
      payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      eval_id         gicl_replace.eval_id%TYPE
   );

   TYPE mc_eval_loa_dtl_tab IS TABLE OF mc_eval_loa_dtl_type;

   FUNCTION get_mc_eval_loa_dtl (
      p_eval_id         gicl_eval_loa.eval_id%TYPE,
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_loa.payee_cd%TYPE
   )
      RETURN mc_eval_loa_dtl_tab PIPELINED;

   FUNCTION get_total_part_amt (
      p_eval_id         gicl_eval_loa.eval_id%TYPE,
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_loa.payee_cd%TYPE
   )
      RETURN gicl_replace.part_amt%TYPE;

   PROCEDURE generate_loa (
      p_claim_id        gicl_mc_evaluation.claim_id%TYPE,
      p_item_no         gicl_mc_evaluation.item_no%TYPE,
      p_eval_id         gicl_mc_evaluation.eval_id%TYPE,
      p_tp_sw           gicl_mc_evaluation.tp_sw%TYPE,
      p_subline_cd      gicl_claims.subline_cd%TYPE,
      p_iss_cd          gicl_claims.iss_cd%TYPE,
      p_clm_yy          gicl_claims.clm_yy%type,
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_loa.payee_cd%TYPE,
      p_remarks         gicl_eval_loa.remarks%TYPE
   );
   
   FUNCTION check_if_loa_generated(p_claim_id      IN  GICL_CLAIMS.claim_id%TYPE,
                                   p_clm_loss_id   IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
                                   p_nbt_tp_sw     IN  GICL_EVAL_LOA.tp_sw%TYPE) 
    RETURN VARCHAR2;
    
   PROCEDURE generate_loa_from_loss_exp
    (p_claim_id         IN    GICL_CLAIMS.claim_id%TYPE,
     p_subline_cd       IN    GICL_CLAIMS.subline_cd%TYPE,
     p_iss_cd           IN    GICL_CLAIMS.iss_cd%TYPE,
     p_clm_yy           IN    GICL_CLAIMS.clm_yy%TYPE,
     p_item_no          IN    GICL_ITEM_PERIL.item_no%TYPE,
     p_payee_class_cd   IN    GICL_EVAL_LOA.payee_type_cd%TYPE,
     p_payee_cd         IN    GICL_EVAL_LOA.payee_cd%TYPE,
     p_clm_loss_id      IN    GICL_EVAL_LOA.clm_loss_id%TYPE,
     p_tp_sw            IN    GICL_EVAL_LOA.tp_sw%TYPE,
     p_remarks          IN    GICL_EVAL_LOA.remarks%TYPE,
     p_cancel_sw        IN    GICL_EVAL_LOA.cancel_sw%TYPE,
     p_eval_id          IN    GICL_EVAL_LOA.eval_id%TYPE);
     
	 TYPE giclr027_loa_type IS RECORD (
      claim_no        VARCHAR2 (50)                         := ' ',
      policy_no       VARCHAR2 (50)                         := ' ',
      loa_no          VARCHAR2 (32767),
      motshop         VARCHAR2 (300),
      cntct_prsn      VARCHAR2 (50),
      loss_date       VARCHAR2 (20),
      assured         giis_assured.assd_name%TYPE,
      plate_no        VARCHAR2 (10),
      mk_type_a       VARCHAR2 (200),
      mk_type_t       VARCHAR2 (200),
      curr            giis_currency.short_name%TYPE,
      repair_cost     gicl_mc_evaluation.repair_amt%TYPE    := 0,
      deductible      gicl_eval_deductibles.ded_amt%TYPE    := 0,
      eop             gicl_eval_deductibles.ded_amt%TYPE    := 0,
      LESS            gicl_mc_evaluation.repair_amt%TYPE    := 0,
      battery         gicl_eval_dep_dtl.ded_amt%TYPE        := 0,
      tire            gicl_eval_dep_dtl.ded_amt%TYPE        := 0,
      dep_total       gicl_eval_dep_dtl.ded_amt%TYPE        := 0,
      other_total     gicl_eval_dep_dtl.ded_amt%TYPE        := 0,
      dep_others      gicl_eval_dep_dtl.ded_amt%TYPE        := 0,
      dep_others2     gicl_eval_dep_dtl.ded_amt%TYPE        := 0,
      bat_rt          gicl_eval_dep_dtl.ded_rt%TYPE         := 0,
      tire_rt         gicl_eval_dep_dtl.ded_rt%TYPE         := 0,
      other_rt        gicl_eval_dep_dtl.ded_rt%TYPE         := 0,
      other_rt2       gicl_eval_dep_dtl.ded_rt%TYPE         := 0,
      net_liability   gicl_mc_evaluation.repair_amt%TYPE    := 0,
      prepared        giis_users.user_name%TYPE,
      approved        giis_signatory_names.signatory%TYPE
   );

   TYPE giclr027_loa_tab IS TABLE OF giclr027_loa_type;

       /**
      CREATED BY: IRWIN TABISORA
      DESCRIPTION: FOR GICLR027 REPORT DETAILS OF GICLS070 AND GICLS030
      DATE: MAY 10, 2012
      CLARIFICATION:

      p_payee_class_cd      =    GICLS070 : master_loa_blk.payee_type_cd / GICLS030: :master_loa_blk.payee_type_cd
      p_payee_cd            =  GICLS070 : master_loa_blk.payee_cd / GICLS030: :master_loa_blk.payee_cd
      p_main_payee_class_cd  =  GICLS070 : gicl_mc_evaluation.payee_class_cd / GICLS030: :master_loa_blk.tp_payeeclasscd
      p_main_payee_no        =  GICLS070 : gicl_mc_evaluation.payee_no / GICLS030: :master_loa_blk.tp_payeeno

   **/
   FUNCTION get_gicl_r027_details (
      p_claim_id              gicl_claims.claim_id%TYPE,
      p_payee_class_cd        giis_payees.payee_class_cd%TYPE,
      p_payee_cd              giis_payees.payee_no%TYPE,
      p_main_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_main_payee_no         giis_payees.payee_no%TYPE,
      p_eval_id               gicl_eval_payment.eval_id%TYPE,
      p_iss_cd                gicl_claims.iss_cd%TYPE,
      p_line_cd               gicl_claims.line_cd%TYPE,
      p_loa_no                VARCHAR2,
      p_tp_sw                 VARCHAR2,
      p_clm_loss_id           gicl_clm_loss_exp.claim_id%TYPE,
      p_item_no               gicl_item_peril.item_no%TYPE,
      p_user_id               VARCHAR2,
      p_module_id          VARCHAR2
   )
       RETURN giclr027_loa_tab PIPELINED;
	  
END gicl_eval_loa_pkg;
/


