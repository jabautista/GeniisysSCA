CREATE OR REPLACE PACKAGE CPI.gicl_eval_dep_dtl_pkg
AS 
/******************************************************************************
   NAME:       gicl_eval_dep_dtl_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        4/10/2012   Irwin Tabisora  1. Created this package.
******************************************************************************/
   TYPE gicls070_dep_type IS RECORD (
      part_type       gicl_replace.part_type%TYPE,
      part_amt        gicl_replace.part_amt%TYPE,
      part_desc       giis_loss_exp.loss_exp_desc%TYPE,
      payee_type_cd   gicl_eval_dep_dtl.payee_type_cd%TYPE,
      payee_cd        gicl_eval_dep_dtl.payee_cd%TYPE,
      ded_rt          gicl_eval_dep_dtl.ded_rt%TYPE,
      ded_amt         gicl_eval_dep_dtl.ded_amt%TYPE,
      item_no         gicl_eval_dep_dtl.item_no%TYPE,
      remarks         gicl_eval_dep_dtl.remarks%TYPE,
      user_id         gicl_eval_dep_dtl.user_id%TYPE,
      last_update     gicl_eval_dep_dtl.last_update%TYPE,
      eval_id         gicl_mc_evaluation.eval_id%TYPE,
      loss_exp_cd     gicl_eval_dep_dtl.loss_exp_cd%TYPE
   );

   TYPE gicls070_dep_tab IS TABLE OF gicls070_dep_type;

   TYPE payee_dtl_type IS RECORD (
      payee_cd           gicl_eval_dep_dtl.payee_cd%TYPE,
      payee_type_cd      gicl_eval_dep_dtl.payee_type_cd%TYPE,
      eval_id            gicl_mc_evaluation.eval_id%TYPE,
      dsp_company_type   giis_payee_class.class_desc%TYPE,
      dsp_company        VARCHAR2 (500),
      total_amount       gicl_eval_dep_dtl.ded_amt%TYPE
   );

   TYPE dep_com_type_type IS RECORD (
      payee_type_cd      gicl_eval_dep_dtl.payee_type_cd%TYPE,
      dsp_company_type   giis_payee_class.class_desc%TYPE
   );

   TYPE dep_com_type IS RECORD (
      payee_cd      gicl_eval_dep_dtl.payee_cd%TYPE,
      dsp_company   VARCHAR2 (290)
   );

   TYPE dep_com_type_tab IS TABLE OF dep_com_type_type;

   TYPE dep_com_tab IS TABLE OF dep_com_type;

   TYPE payee_dtl_tab IS TABLE OF payee_dtl_type;

   FUNCTION get_eval_dep_listing (p_eval_id gicl_mc_evaluation.eval_id%TYPE)
      RETURN gicls070_dep_tab PIPELINED;

   FUNCTION get_dep_payee_dtls (p_eval_id gicl_mc_evaluation.eval_id%TYPE)
      RETURN payee_dtl_tab PIPELINED;

   FUNCTION get_initial_dep_payee_dtls (
      p_eval_id   gicl_mc_evaluation.eval_id%TYPE
   )
      RETURN payee_dtl_tab PIPELINED;

   FUNCTION get_dep_com_type_lov (
      p_eval_id     gicl_mc_evaluation.eval_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN dep_com_type_tab PIPELINED;

   FUNCTION get_dep_com_lov (
      p_eval_id     gicl_mc_evaluation.eval_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN dep_com_tab PIPELINED;

   PROCEDURE check_dep_vat (
      p_eval_id             gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd         gicl_eval_dep_dtl.loss_exp_cd%TYPE,
      payee_cd        OUT   gicl_eval_dep_dtl.payee_cd%TYPE,
      payee_type_cd   OUT   gicl_eval_dep_dtl.payee_type_cd%TYPE,
      vat_exist       OUT   VARCHAR2
   );

   PROCEDURE delete_eval_dep (
      p_eval_id       gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd   gicl_eval_dep_dtl.loss_exp_cd%TYPE
   );

   PROCEDURE set_eval_dep (
      p_eval_id         gicl_mc_evaluation.eval_id%TYPE,
      p_ded_amt         gicl_eval_dep_dtl.ded_amt%TYPE,
      p_ded_rt          gicl_eval_dep_dtl.ded_rt%TYPE,
      p_payee_type_cd   gicl_eval_dep_dtl.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_dep_dtl.payee_cd%TYPE,
      p_item_no         gicl_eval_dep_dtl.item_no%TYPE,
      p_loss_exp_cd     gicl_eval_dep_dtl.loss_exp_cd%TYPE
   );

   FUNCTION apply_depreciation (
      p_eval_id             gicl_mc_evaluation.eval_id%TYPE,
       p_clm_subline_cd      gicl_mc_evaluation.subline_cd%TYPE,
      p_pol_subline_cd      gicl_mc_evaluation.subline_cd%TYPE,
      p_claim_id               gicl_mc_evaluation.claim_id%type,
      p_item_no               gicl_mc_evaluation.item_no%type,
      p_payee_no               gicl_mc_evaluation.payee_no%type,
      p_payee_class_cd               gicl_mc_evaluation.payee_class_cd%type,
      p_tp_sw               gicl_mc_evaluation.tp_sw%type,
      user_id               gicl_mc_evaluation.user_id%type,
      main_eval_vat_exist   VARCHAR2
   )
      RETURN VARCHAR2;
END gicl_eval_dep_dtl_pkg;
/


