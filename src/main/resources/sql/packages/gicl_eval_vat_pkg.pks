CREATE OR REPLACE PACKAGE CPI.gicl_eval_vat_pkg
AS
/******************************************************************************
   NAME:       gicl_eval_vat
   PURPOSE: for gicl_eval_vat table functions

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/23/2012    Irwin Tabisora   1. Created this package.
*****************************************************************************/
   PROCEDURE update_old_eval_vat (
      p_payee_type_cd       gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd            gicl_eval_vat.payee_cd%TYPE,
      p_var_payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      p_var_payee_cd        gicl_eval_vat.payee_cd%TYPE,
      p_eval_id             gicl_eval_vat.eval_id%TYPE
   );

   PROCEDURE delete_eval_vat (
      p_payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_vat.payee_cd%TYPE,
      p_eval_id         gicl_eval_vat.eval_id%TYPE
   );

   TYPE eval_vat_type IS RECORD (
      eval_id              gicl_eval_vat.eval_id%TYPE,
      payee_type_cd        gicl_eval_vat.payee_type_cd%TYPE,
      payee_cd             gicl_eval_vat.payee_cd%TYPE,
      apply_to             gicl_eval_vat.apply_to%TYPE,
      vat_amt              gicl_eval_vat.vat_amt%TYPE,
      vat_rate             gicl_eval_vat.vat_rate%TYPE,
      base_amt             gicl_eval_vat.base_amt%TYPE,
      with_vat             gicl_eval_vat.with_vat%TYPE,
      user_id              gicl_eval_vat.user_id%TYPE,
      last_update          gicl_eval_vat.last_update%TYPE,
      payt_payee_type_cd   gicl_eval_vat.payt_payee_type_cd%TYPE,
      payt_payee_cd        gicl_eval_vat.payt_payee_cd%TYPE,
      net_tag              gicl_eval_vat.net_tag%TYPE,
      less_ded             gicl_eval_vat.less_ded%TYPE,
      less_dep             gicl_eval_vat.less_dep%TYPE,
      dsp_company          VARCHAR2 (290),
      dsp_part_labor       giis_loss_exp.loss_exp_desc%TYPE
   );

   TYPE eval_vat_tab IS TABLE OF eval_vat_type;

   FUNCTION get_mc_eval_vat_listing (p_eval_id gicl_eval_vat.eval_id%TYPE)
      RETURN eval_vat_tab PIPELINED;

   TYPE vat_com_lov_type IS RECORD (
      dsp_company     VARCHAR2 (290),
      payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      payee_cd        gicl_eval_vat.payee_cd%TYPE
   );

   TYPE vat_com_lov_tab IS TABLE OF vat_com_lov_type;

   FUNCTION get_vat_com_lov (
      p_eval_id     gicl_eval_vat.eval_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN vat_com_lov_tab PIPELINED;

   TYPE vat_labor_part_type IS RECORD (
      dsp_part_labor   giis_loss_exp.loss_exp_desc%TYPE,
      apply_to         gicl_eval_vat.apply_to%TYPE,
      with_vat         gicl_eval_vat.with_vat%TYPE,
      base_amt         gicl_eval_vat.base_amt%TYPE
   );

   TYPE vat_labor_part_tab IS TABLE OF vat_labor_part_type;

   FUNCTION get_vat_part_labor_lov (
      p_eval_id         gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_vat.payee_cd%TYPE,
      p_find_text       VARCHAR2
   )
      RETURN vat_labor_part_tab PIPELINED;

   PROCEDURE validate_eval_vat_com (
      p_eval_id               gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd         gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd              gicl_eval_vat.payee_cd%TYPE,
      dsp_part_labor    OUT   giis_loss_exp.loss_exp_desc%TYPE,
      base_amt          OUT   gicl_eval_vat.base_amt%TYPE,
      vat_rate          OUT   gicl_eval_vat.vat_rate%TYPE,
      vat_amt           OUT   gicl_eval_vat.vat_amt%TYPE,
      apply_to          OUT   gicl_eval_vat.apply_to%TYPE,
      allow_labor_lov   OUT   VARCHAR2
   );

   PROCEDURE validate_eval_part_labor (
      p_eval_id               gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd         gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd              gicl_eval_vat.payee_cd%TYPE,
      p_apply_to              gicl_eval_vat.apply_to%TYPE,
      base_amt          OUT   gicl_eval_vat.base_amt%TYPE,
      vat_rate          OUT   gicl_eval_vat.vat_rate%TYPE,
      vat_amt           OUT   gicl_eval_vat.vat_amt%TYPE
   );

   PROCEDURE validate_less_deductible (
      p_eval_id               gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd         gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd              gicl_eval_vat.payee_cd%TYPE,
      p_less_ded              gicl_eval_vat.less_ded%TYPE,
      p_apply_to              gicl_eval_vat.apply_to%TYPE,
      base_amt          OUT   gicl_eval_vat.base_amt%TYPE,
      vat_amt           OUT   gicl_eval_vat.vat_amt%TYPE,
      MESSAGE           OUT   VARCHAR2
   );

   PROCEDURE validate_less_depreciation (
      p_eval_id               gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd         gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd              gicl_eval_vat.payee_cd%TYPE,
      p_less_dep              gicl_eval_vat.less_ded%TYPE,
      p_apply_to              gicl_eval_vat.apply_to%TYPE,
      base_amt          OUT   gicl_eval_vat.base_amt%TYPE,
      vat_amt           OUT   gicl_eval_vat.vat_amt%TYPE,
      MESSAGE           OUT   VARCHAR2
   );

   FUNCTION check_enable_create_vat (p_eval_id gicl_eval_vat.eval_id%TYPE)
      RETURN VARCHAR2;

   PROCEDURE set_gicl_eval_vat (
      p_eval_id              gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd        gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd             gicl_eval_vat.payee_cd%TYPE,
      p_apply_to             gicl_eval_vat.apply_to%TYPE,
      p_vat_amt              gicl_eval_vat.vat_amt%TYPE,
      p_vat_rate             gicl_eval_vat.vat_rate%TYPE,
      p_base_amt             gicl_eval_vat.base_amt%TYPE,
      p_with_vat             gicl_eval_vat.with_vat%TYPE,
      p_payt_payee_type_cd   gicl_eval_vat.payt_payee_type_cd%TYPE,
      p_payt_payee_cd        gicl_eval_vat.payt_payee_cd%TYPE,
      p_net_tag              gicl_eval_vat.net_tag%TYPE,
      p_less_ded             gicl_eval_vat.less_ded%TYPE,
      p_less_dep             gicl_eval_vat.less_dep%TYPE
   );

   PROCEDURE del_gicl_eval_vat (
      p_eval_id         gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_vat.payee_cd%TYPE,
      p_apply_to        gicl_eval_vat.apply_to%type -- 12.17.2013 ruben
   );

   PROCEDURE create_vat_details (
      p_eval_id            gicl_eval_vat.eval_id%TYPE,
      v_totalvat     OUT   gicl_mc_evaluation.vat%TYPE,
      v_totallabor   OUT   gicl_mc_evaluation.repair_amt%TYPE,
      v_totalpart    OUT   gicl_mc_evaluation.replace_amt%TYPE,
      v_changed1     OUT   VARCHAR2
   );

   PROCEDURE create_vat_details2 (
      p_eval_id         gicl_eval_vat.eval_id%TYPE,
      p_payee_type_cd   gicl_eval_vat.payee_type_cd%TYPE,
      p_payee_cd        gicl_eval_vat.payee_cd%TYPE,
      p_apply_to        gicl_eval_vat.apply_to%TYPE,
      p_less_ded        gicl_eval_vat.less_ded%TYPE,
      p_less_dep        gicl_eval_vat.less_dep%TYPE
   );

   PROCEDURE create_vat_details3 (
      p_eval_id      gicl_eval_vat.eval_id%TYPE,
      v_totalvat     gicl_mc_evaluation.vat%TYPE,
      v_totallabor   gicl_mc_evaluation.repair_amt%TYPE,
      v_totalpart    gicl_mc_evaluation.replace_amt%TYPE,
      v_changed1     VARCHAR2
   );
   
   FUNCTION check_gicl_eval_vat_exist (p_eval_id  IN  GICL_MC_EVALUATION.eval_id%TYPE) 
    RETURN VARCHAR2;

END;
/


