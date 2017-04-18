CREATE OR REPLACE PACKAGE CPI.gicl_replace_pkg
AS
/******************************************************************************
   NAME:       gicl_replace_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/5/2012    Irwin Tabisora   1. Created this package.
******************************************************************************/
   TYPE gicl_replace_type IS RECORD (
      eval_id              gicl_replace.eval_id%TYPE,
      payee_type_cd        gicl_replace.payee_type_cd%TYPE,
      payee_cd             gicl_replace.payee_cd%TYPE,
      loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      part_type            gicl_replace.part_type%TYPE,
      dsp_part_type_desc   VARCHAR2 (20),
      part_orig_amt        gicl_replace.part_orig_amt%TYPE,
      orig_payee_type_cd   gicl_replace.orig_payee_type_cd%TYPE,
      orig_payee_cd        gicl_replace.orig_payee_cd%TYPE,
      part_amt             gicl_replace.part_amt%TYPE,
      total_part_amt       gicl_replace.total_part_amt%TYPE,
      base_amt             gicl_replace.base_amt%TYPE,
      no_of_units          gicl_replace.no_of_units%TYPE,
      with_vat             gicl_replace.with_vat%TYPE,
      revised_sw           gicl_replace.revised_sw%TYPE,
      user_id              gicl_replace.user_id%TYPE,
      last_update          gicl_replace.last_update%TYPE,
      payt_payee_type_cd   gicl_replace.payt_payee_type_cd%TYPE,
      payt_payee_cd        gicl_replace.payt_payee_cd%TYPE,
      replace_id           gicl_replace.replace_id%TYPE,
      replaced_master_id   gicl_replace.replaced_master_id%TYPE,
      item_no              gicl_replace.item_no%TYPE,
      update_sw            gicl_replace.update_sw%TYPE,
      dsp_part_desc        giis_loss_exp.loss_exp_desc%TYPE,
      dsp_company_type     giis_payee_class.class_desc%TYPE,
      dsp_company          VARCHAR2 (500)
   );

   TYPE gicl_replace_tab IS TABLE OF gicl_replace_type;

   FUNCTION get_mc_eval_replace_list (p_eval_id gicl_replace.eval_id%TYPE)
      RETURN gicl_replace_tab PIPELINED;

   FUNCTION get_payee_name (
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_payee_no        giis_payees.payee_no%TYPE
   )
      RETURN VARCHAR2;

   TYPE parts_list_type IS RECORD (
      loss_exp_desc   giis_loss_exp.loss_exp_desc%TYPE,
      loss_exp_cd     giis_loss_exp.loss_exp_cd%TYPE
   );

   TYPE parts_list_tab IS TABLE OF parts_list_type;

   FUNCTION get_parts_list (
      p_eval_id     gicl_replace.eval_id%TYPE,
      p_part_type   gicl_replace.part_type%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN parts_list_tab PIPELINED;

   TYPE company_list_type IS RECORD (
      dsp_company   VARCHAR2 (500),
      payee_no      giis_payees.payee_no%TYPE
   );

   TYPE company_list_tab IS TABLE OF company_list_type;

   FUNCTION get_company_list (
      p_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_claim_id        gicl_claims.claim_id%TYPE,
      p_find_text       VARCHAR2
   )
      RETURN company_list_tab PIPELINED;

   TYPE payee_company_type IS RECORD (
      payee_cd        gicl_replace.payee_cd%TYPE,
      payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      dsp_company     VARCHAR2 (500)
   );

   TYPE payee_company_tab IS TABLE OF payee_company_type;

   /***
    * gicls070 gicl_replace blk part_type - when-list-changed Trigger
   **/
   PROCEDURE validate_part_type (
      p_master_eval_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id                  gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd              gicl_replace.loss_exp_cd%TYPE,
      p_payee_type_cd            gicl_replace.payee_type_cd%TYPE,
      p_payee_cd                 gicl_replace.payee_cd%TYPE,
      p_base_amt                 gicl_replace.base_amt%TYPE,
      p_no_of_units              gicl_replace.no_of_units%TYPE,
      p_part_type                gicl_replace.part_type%TYPE,
      p_old_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      v_update_sw          OUT   VARCHAR2,
      master_report_type   OUT   gicl_mc_evaluation.report_type%TYPE,
      v_dep_exist          OUT   VARCHAR2
   );

   PROCEDURE check_update_report_dtl (
      p_eval_master_id       IN       gicl_mc_evaluation.eval_id%TYPE,
      p_eval_id                       gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd          IN       gicl_replace.loss_exp_cd%TYPE,
      p_master_report_type   OUT      gicl_mc_evaluation.report_type%TYPE,
      dep_exist              OUT      VARCHAR2
   );

   PROCEDURE validate_part_desc (
      p_master_eval_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id                  gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd              gicl_replace.loss_exp_cd%TYPE,
      p_payee_type_cd            gicl_replace.payee_type_cd%TYPE,
      p_payee_cd                 gicl_replace.payee_cd%TYPE,
      p_base_amt                 gicl_replace.base_amt%TYPE,
      p_no_of_units              gicl_replace.no_of_units%TYPE,
      p_part_type                gicl_replace.part_type%TYPE,
      p_old_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      v_update_sw          OUT   VARCHAR2,
      master_report_type   OUT   gicl_mc_evaluation.report_type%TYPE,
      v_dep_exist          OUT   VARCHAR2
   );

   PROCEDURE validate_company_type (
      p_master_eval_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id                  gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd              gicl_replace.loss_exp_cd%TYPE,
      p_payee_type_cd            gicl_replace.payee_type_cd%TYPE,
      p_payee_cd                 gicl_replace.payee_cd%TYPE,
      p_base_amt                 gicl_replace.base_amt%TYPE,
      p_no_of_units              gicl_replace.no_of_units%TYPE,
      p_part_type                gicl_replace.part_type%TYPE,
      p_old_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      v_update_sw          OUT   VARCHAR2,
      master_report_type   OUT   gicl_mc_evaluation.report_type%TYPE,
      v_dep_exist          OUT   VARCHAR2
   );

   PROCEDURE validate_company_desc (
      p_master_eval_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id                  gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd              gicl_replace.loss_exp_cd%TYPE,
      p_payee_type_cd            gicl_replace.payee_type_cd%TYPE,
      p_payee_cd                 gicl_replace.payee_cd%TYPE,
      p_base_amt                 gicl_replace.base_amt%TYPE,
      p_no_of_units              gicl_replace.no_of_units%TYPE,
      p_part_type                gicl_replace.part_type%TYPE,
      p_old_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      v_update_sw          OUT   VARCHAR2,
      master_report_type   OUT   gicl_mc_evaluation.report_type%TYPE,
      v_dep_exist          OUT   VARCHAR2
   );

   PROCEDURE validate_base_amt (
      p_master_eval_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id                  gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd              gicl_replace.loss_exp_cd%TYPE,
      p_payee_type_cd            gicl_replace.payee_type_cd%TYPE,
      p_payee_cd                 gicl_replace.payee_cd%TYPE,
      p_base_amt                 gicl_replace.base_amt%TYPE,
      p_no_of_units              gicl_replace.no_of_units%TYPE,
      p_part_type                gicl_replace.part_type%TYPE,
      p_old_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      v_update_sw          OUT   VARCHAR2,
      master_report_type   OUT   gicl_mc_evaluation.report_type%TYPE,
      v_dep_exist          OUT   VARCHAR2
   );

   PROCEDURE validate_no_of_units (
      p_master_eval_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id                  gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd              gicl_replace.loss_exp_cd%TYPE,
      p_payee_type_cd            gicl_replace.payee_type_cd%TYPE,
      p_payee_cd                 gicl_replace.payee_cd%TYPE,
      p_base_amt                 gicl_replace.base_amt%TYPE,
      p_no_of_units              gicl_replace.no_of_units%TYPE,
      p_part_type                gicl_replace.part_type%TYPE,
      p_old_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      v_update_sw          OUT   VARCHAR2,
      master_report_type   OUT   gicl_mc_evaluation.report_type%TYPE,
      v_dep_exist          OUT   VARCHAR2
   );

   TYPE prev_part_list_type IS RECORD (
      part_type            gicl_replace.part_type%TYPE,
      dsp_part_type_desc   VARCHAR2 (20),
      dsp_company_type     giis_payee_class.class_desc%TYPE,
      dsp_company          VARCHAR2 (500),
      part_amt             gicl_replace.part_amt%TYPE,
      eval_date            VARCHAR2 (10),
      payee_cd             gicl_replace.payee_cd%TYPE,
      payee_type_cd        gicl_replace.payee_type_cd%TYPE
   );

   TYPE prev_part_list_tab IS TABLE OF prev_part_list_type;

   FUNCTION get_prev_part_list (
      p_loss_exp_cd      gicl_replace.loss_exp_cd%TYPE,
      p_part_type        gicl_replace.part_type%TYPE,
      p_tp_sw            gicl_mc_evaluation.tp_sw%TYPE,
      p_claim_id         gicl_mc_evaluation.claim_id%TYPE,
      p_item_no          gicl_mc_evaluation.item_no%TYPE,
      p_payee_class_cd   gicl_mc_evaluation.payee_class_cd%TYPE,
      p_payee_no         gicl_mc_evaluation.payee_no%TYPE,
      p_find_text        VARCHAR2
   )
      RETURN prev_part_list_tab PIPELINED;

   PROCEDURE check_part_if_exist_master (
      p_loss_exp_cd                gicl_replace.loss_exp_cd%TYPE,
      p_part_type                  gicl_replace.part_type%TYPE,
      p_eval_id                    gicl_mc_evaluation.eval_id%TYPE,
      p_eval_master_id             gicl_mc_evaluation.eval_id%TYPE,
      p_payee_cd                   gicl_replace.payee_cd%TYPE,
      p_payee_type_cd              gicl_replace.payee_type_cd%TYPE,
      p_var_s                      VARCHAR2,
      p_result               OUT   VARCHAR2,
      p_replaced_master_id   OUT   gicl_replace.replaced_master_id%TYPE
   );

   TYPE multiple_parts_type IS RECORD (
      payee_type_cd      gicl_replace.payee_type_cd%TYPE,
      dsp_company_type   giis_payee_class.class_desc%TYPE,
      dsp_company        VARCHAR2 (500),
      payee_cd           gicl_replace.payee_cd%TYPE,
      replace_id         NUMBER,
      base_amt           gicl_replace.base_amt%TYPE,
      dsp_part_desc      giis_loss_exp.loss_exp_desc%TYPE
   );

   TYPE multiple_parts_tab IS TABLE OF multiple_parts_type;

   FUNCTION get_multiple_parts_list (
      p_loss_exp_cd      gicl_replace.loss_exp_cd%TYPE,
      p_part_type        gicl_replace.part_type%TYPE,
      p_eval_id          gicl_mc_evaluation.eval_id%TYPE,
      p_eval_master_id   gicl_mc_evaluation.eval_id%TYPE,
      p_find_text        VARCHAR2
   )
      RETURN multiple_parts_tab PIPELINED;

   TYPE copy_master_part_type IS RECORD (
      payee_type_cd      gicl_replace.payee_type_cd%TYPE,
      payee_cd           gicl_replace.payee_cd%TYPE,
      dsp_company_type   giis_payee_class.class_desc%TYPE,
      dsp_company        VARCHAR2 (500),
      base_amt           gicl_replace.base_amt%TYPE,
      no_of_units        gicl_replace.no_of_units%TYPE,
      part_amt           gicl_replace.part_amt%TYPE,
      total_part_amt     gicl_replace.total_part_amt%TYPE
   );

   TYPE copy_master_part_tab IS TABLE OF copy_master_part_type;

   FUNCTION copy_master_part (
      p_replaced_master_id   gicl_replace.replaced_master_id%TYPE,
      p_all_dtl_flag         VARCHAR2
   )
      RETURN copy_master_part_tab PIPELINED;

   PROCEDURE get_payee_details (
      p_claim_id              gicl_claims.claim_id%TYPE,
      p_payee_type_cd         gicl_replace.payee_type_cd%TYPE,
      dsp_company       OUT   VARCHAR2,
      payee_cd          OUT   gicl_replace.payee_cd%TYPE
   );

   FUNCTION get_rep_mortgagee_list (
      p_claim_id    gicl_claims.claim_id%TYPE,
      p_item_no     gicl_replace.item_no%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN company_list_tab PIPELINED;

   PROCEDURE check_vat_and_deductibles (
      p_payee_cd                       gicl_replace.payee_cd%TYPE,
      p_payee_type_cd                  gicl_replace.payee_type_cd%TYPE,
      p_payt_payee_cd                  gicl_replace.payee_cd%TYPE,
      p_payt_payee_type_cd             gicl_replace.payee_type_cd%TYPE,
      p_payee_cd_old                   gicl_replace.payee_cd%TYPE,
      p_payee_type_cd_old              gicl_replace.payee_type_cd%TYPE,
      p_payt_payee_cd_old              gicl_replace.payee_cd%TYPE,
      p_payt_payee_type_cd_old         gicl_replace.payee_type_cd%TYPE,
      p_eval_id                        gicl_mc_evaluation.eval_id%TYPE,
      v_old_payee_ded            OUT   NUMBER,
      v_new_payee_ded            OUT   NUMBER,
      v_old_payee_ded2           OUT   NUMBER,
      v_new_payee_ded2           OUT   NUMBER,
      v_payee_dep                OUT   NUMBER
   );

   FUNCTION countreplace (
      p_payeetypecd   VARCHAR2,
      p_payeecd       NUMBER,
      p_eval_id       gicl_mc_evaluation.eval_id%TYPE
   )
      RETURN NUMBER;

   TYPE with_vat_type IS RECORD (
      with_vat   VARCHAR2 (1)
   );

   TYPE with_vat_tab IS TABLE OF with_vat_type;

   FUNCTION get_with_vat_list (
      p_eval_master_id   gicl_mc_evaluation.eval_id%TYPE
   )
      RETURN with_vat_tab PIPELINED;

   FUNCTION final_check_vat (
      p_payee_cd             gicl_replace.payee_cd%TYPE,
      p_payee_type_cd        gicl_replace.payee_type_cd%TYPE,
      p_payt_payee_cd        gicl_replace.payee_cd%TYPE,
      p_payt_payee_type_cd   gicl_replace.payee_type_cd%TYPE,
      p_eval_id              gicl_mc_evaluation.eval_id%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION final_check_ded (
      p_eval_id       gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd   gicl_replace.loss_exp_cd%TYPE
   )
      RETURN VARCHAR2;

   PROCEDURE save_replace_dtls_gicls070 (
      p_eval_id              gicl_replace.eval_id%TYPE,
      p_payee_type_cd        gicl_replace.payee_type_cd%TYPE,
      p_payee_cd             gicl_replace.payee_cd%TYPE,
      p_loss_exp_cd          gicl_replace.loss_exp_cd%TYPE,
      p_part_type            gicl_replace.part_type%TYPE,
      p_part_orig_amt        gicl_replace.part_orig_amt%TYPE,
      p_orig_payee_type_cd   gicl_replace.orig_payee_type_cd%TYPE,
      p_orig_payee_cd        gicl_replace.orig_payee_cd%TYPE,
      p_part_amt             gicl_replace.part_amt%TYPE,
      p_total_part_amt       gicl_replace.total_part_amt%TYPE,
      p_base_amt             gicl_replace.base_amt%TYPE,
      p_no_of_units          gicl_replace.no_of_units%TYPE,
      p_with_vat             gicl_replace.with_vat%TYPE,
      p_revised_sw           gicl_replace.revised_sw%TYPE,
      p_user_id              gicl_replace.user_id%TYPE,
      p_payt_payee_type_cd   gicl_replace.payt_payee_type_cd%TYPE,
      p_payt_payee_cd        gicl_replace.payt_payee_cd%TYPE,
      p_replace_id           gicl_replace.replace_id%TYPE,
      p_replaced_master_id   gicl_replace.replaced_master_id%TYPE,
      p_update_sw            gicl_replace.update_sw%TYPE,
      p_new_rec              VARCHAR2,
      p_report_type          gicl_mc_evaluation.report_type%TYPE,
      p_eval_master_id       gicl_mc_evaluation.eval_master_id%TYPE
   );

   PROCEDURE update_item_no (p_eval_id gicl_replace.eval_id%TYPE);

   PROCEDURE delete_replace_dtl (p_replace_id gicl_replace.replace_id%TYPE);

   FUNCTION get_company_list_2 (p_eval_id IN gicl_mc_evaluation.eval_id%TYPE)
      RETURN payee_company_tab PIPELINED;

   TYPE replace_payee_listing_type IS RECORD (
      eval_id              gicl_replace.eval_id%TYPE,
      payt_payee_type_cd   gicl_replace.payt_payee_type_cd%TYPE,
      payt_payee_cd        gicl_replace.payt_payee_cd%TYPE,
      payee_type_cd        gicl_replace.payee_type_cd%TYPE,
      payee_cd             gicl_replace.payee_cd%TYPE,
      dsp_payee_type_cd    gicl_replace.payee_type_cd%TYPE,
      dsp_payee_cd         gicl_replace.payee_cd%TYPE,
      payt_part_amt        gicl_replace.part_amt%TYPE,
      payt_imp_tag         VARCHAR (1),
      dsp_company          VARCHAR2 (290)
   );

   TYPE replace_payee_listing_tab IS TABLE OF replace_payee_listing_type;

   FUNCTION get_replace_payee_listing (
      p_eval_id   IN   gicl_mc_evaluation.eval_id%TYPE
   )
      RETURN replace_payee_listing_tab PIPELINED;

   PROCEDURE change_replace_payee (
      p_eval_id               gicl_replace.eval_id%TYPE,
      p_payt_pay_typ_cd_man   gicl_replace.payt_payee_type_cd%TYPE,
      p_payt_pay_cd_man       gicl_replace.payt_payee_cd%TYPE,
      p_payee_type_cd         gicl_replace.payt_payee_type_cd%TYPE,
      p_payee_cd              gicl_replace.payt_payee_cd%TYPE
   );

   PROCEDURE update_change_payee (
      p_eval_id                 gicl_replace.eval_id%TYPE,
      p_payt_pay_typ_cd_man     gicl_replace.payt_payee_type_cd%TYPE,
      p_payt_pay_cd_man         gicl_replace.payt_payee_cd%TYPE,
      prev_payt_payee_type_cd   gicl_replace.payt_payee_type_cd%TYPE,
      prev_payt_payee_cd        gicl_replace.payt_payee_cd%TYPE
   );
END gicl_replace_pkg;
/


