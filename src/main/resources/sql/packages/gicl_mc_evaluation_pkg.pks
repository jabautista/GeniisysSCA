CREATE OR REPLACE PACKAGE CPI.gicl_mc_evaluation_pkg
AS
   /***
       NAME: gicl_mc_evaluation_pkg
       AUTHOR: Irwin Co Tabisora
       Description: Package for module GICLS07 MC Evaluation Report
   */
   TYPE subline_list_type IS RECORD (
      subline_cd     gicl_claims.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE issue_code_list_type IS RECORD (
      iss_cd     gicl_claims.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE subline_list_tab IS TABLE OF subline_list_type;

   TYPE issue_code_list_tab IS TABLE OF issue_code_list_type;

   TYPE clm_year_list_type IS RECORD (
      clm_yy       gicl_claims.clm_yy%TYPE,
      clm_seq_no   gicl_claims.clm_seq_no%TYPE
   );

   TYPE clm_year_list_tab IS TABLE OF clm_year_list_type;

   TYPE mc_evaluation_info_type IS RECORD (
      claim_id             gicl_claims.claim_id%TYPE,
      line_cd              gicl_claims.line_cd%TYPE,
      subline_cd           gicl_claims.subline_cd%TYPE,
      clm_yy               gicl_claims.clm_yy%TYPE,
      clm_seq_no           gicl_claims.clm_seq_no%TYPE,
      renew_no             gicl_claims.renew_no%TYPE,
      assured_name         gicl_claims.assured_name%TYPE,
      assd_no              gicl_claims.assd_no%TYPE,
      loss_date            VARCHAR2 (10),
      item_no              gicl_mc_evaluation.item_no%TYPE,
      plate_no             gicl_mc_evaluation.plate_no%TYPE,
      peril_cd             gicl_mc_evaluation.peril_cd%TYPE,
      payee_no             gicl_mc_evaluation.payee_no%TYPE,
      payee_class_cd       gicl_mc_evaluation.payee_class_cd%TYPE,
      tp_sw                gicl_mc_evaluation.tp_sw%TYPE,
      in_hou_adj           gicl_claims.in_hou_adj%TYPE,
      pol_iss_cd           gicl_claims.pol_iss_cd%TYPE,
      pol_seq_no           gicl_claims.pol_seq_no%TYPE,
      issue_yy             gicl_claims.issue_yy%TYPE,
      iss_cd               gicl_claims.iss_cd%TYPE,
      clm_file_date        gicl_claims.clm_file_date%TYPE,
      dsp_item_desc        gicl_motor_car_dtl.item_title%TYPE,
      dsp_peril_desc       giis_peril.peril_name%TYPE,
      currency_cd          gicl_motor_car_dtl.currency_cd%TYPE,
      currency_rate        gicl_motor_car_dtl.currency_rate%TYPE,
      dsp_curr_shortname   giis_currency.short_name%TYPE,
      ann_tsi_amt          gipi_polbasic.ann_tsi_amt%TYPE
   );

   TYPE mc_evaluation_info_tab IS TABLE OF mc_evaluation_info_type;

   TYPE le_eval_report_type IS RECORD (
      eval_no        VARCHAR2 (100),
      eval_id        gicl_mc_evaluation.eval_id%TYPE,
      peril_cd       gicl_mc_evaluation.peril_cd%TYPE,
      tot_estcos     NUMBER,
      repair_amt     gicl_mc_evaluation.repair_amt%TYPE,
      replace_amt    gicl_mc_evaluation.replace_amt%TYPE,
      vat            gicl_mc_evaluation.vat%TYPE,
      deductible     gicl_mc_evaluation.deductible%TYPE,
      depreciation   gicl_mc_evaluation.depreciation%TYPE
   );

   TYPE le_eval_report_tab IS TABLE OF le_eval_report_type;

   FUNCTION get_mc_evaluation_info (
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_clm_yy       gicl_claims.clm_yy%TYPE,
      p_clm_seq_no   gicl_claims.clm_seq_no%TYPE,
      p_user_id      VARCHAR2
   )
      RETURN mc_evaluation_info_tab PIPELINED;

   FUNCTION get_evaluation_subline_list (p_find_text VARCHAR2)
      RETURN subline_list_tab PIPELINED;

   FUNCTION get_evaluation_issue_cd_list (
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_find_text    VARCHAR2
   )
      RETURN issue_code_list_tab PIPELINED;

   FUNCTION get_evaluation_clm_year_list (
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_find_text    VARCHAR2
   )
      RETURN clm_year_list_tab PIPELINED;

   FUNCTION get_evaluation_clm_seq_no_list (
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_clm_yy       gicl_claims.clm_yy%TYPE,
      p_find_text    VARCHAR2
   )
      RETURN clm_year_list_tab PIPELINED;

   PROCEDURE get_pol_info (
      p_subline_cd              gicl_claims.subline_cd%TYPE,
      p_iss_cd                  gicl_claims.iss_cd%TYPE,
      p_clm_yy                  gicl_claims.clm_yy%TYPE,
      p_clm_seq_no              gicl_claims.clm_seq_no%TYPE,
      p_user_id                 VARCHAR2,
      p_claim_id       IN OUT   gicl_claims.claim_id%TYPE,
      p_pol_iss_cd     OUT      gicl_claims.pol_iss_cd%TYPE,
      p_pol_seq_no     OUT      gicl_claims.pol_seq_no%TYPE,
      p_pol_renew_no   OUT      gicl_claims.renew_no%TYPE,
      p_pol_issue_yy   OUT      gicl_claims.issue_yy%TYPE,
      p_loss_date      OUT      VARCHAR2,
      p_assured_name   OUT      VARCHAR2,
      p_plate_no       OUT      VARCHAR2,
      p_peril_cd       OUT      gicl_item_peril.peril_cd%TYPE,
      p_peril_name     OUT      VARCHAR2,
      p_message        OUT      VARCHAR2
   );

   TYPE mc_eval_list_type IS RECORD (
      claim_id                       gicl_mc_evaluation.claim_id%TYPE,
      eval_id                        gicl_mc_evaluation.eval_id%TYPE,
      item_no                        gicl_mc_evaluation.item_no%TYPE,
      peril_cd                       gicl_mc_evaluation.peril_cd%TYPE,
      subline_cd                     gicl_mc_evaluation.subline_cd%TYPE,
      iss_cd                         gicl_mc_evaluation.iss_cd%TYPE,
      eval_yy                        gicl_mc_evaluation.eval_yy%TYPE,
      eval_seq_no                    gicl_mc_evaluation.eval_seq_no%TYPE,
      eval_version                   gicl_mc_evaluation.eval_version%TYPE,
      report_type                    gicl_mc_evaluation.report_type%TYPE,
      eval_master_id                 gicl_mc_evaluation.eval_master_id%TYPE,
      payee_no                       gicl_mc_evaluation.payee_no%TYPE,
      payee_class_cd                 gicl_mc_evaluation.payee_class_cd%TYPE,
      plate_no                       gicl_mc_evaluation.plate_no%TYPE,
      tp_sw                          gicl_mc_evaluation.tp_sw%TYPE,
      cso_id                         gicl_mc_evaluation.cso_id%TYPE,
      eval_date                      VARCHAR2 (10),
      inspect_date                   VARCHAR2 (10),
      inspect_place                  gicl_mc_evaluation.inspect_place%TYPE,
      adjuster_id                    gicl_mc_evaluation.adjuster_id%TYPE,
      replace_amt                    gicl_mc_evaluation.replace_amt%TYPE,
      vat                            gicl_mc_evaluation.vat%TYPE,
      depreciation                   gicl_mc_evaluation.depreciation%TYPE,
      remarks                        gicl_mc_evaluation.remarks%TYPE,
      currency_cd                    gicl_mc_evaluation.currency_cd%TYPE,
      currency_rate                  gicl_mc_evaluation.currency_rate%TYPE,
      user_id                        gicl_mc_evaluation.user_id%TYPE,
      dsp_adjuster_desc              giis_adjuster.payee_name%TYPE,
      dsp_payee                      VARCHAR2 (290),
      dsp_curr_shortname             giis_currency.short_name%TYPE,
      dsp_discount                   gicl_eval_deductibles.ded_amt%TYPE,
      deductible                     gicl_eval_deductibles.ded_amt%TYPE,
      tot_estcos                     gicl_eval_deductibles.ded_amt%TYPE,
      tot_erc                        gicl_eval_deductibles.ded_amt%TYPE,
      tot_inp                        gicl_eval_deductibles.ded_amt%TYPE,
      tot_inl                        gicl_eval_deductibles.ded_amt%TYPE,
      eval_stat_cd                   gicl_mc_evaluation.eval_stat_cd%TYPE,
      dsp_report_type_desc           cg_ref_codes.rv_meaning%TYPE,
      dsp_eval_desc                  gicl_mc_eval_stat.eval_stat_desc%TYPE,
      replace_gross                  gicl_eval_vat.vat_amt%TYPE,
      repair_gross                   gicl_repair_hdr.lps_repair_amt%TYPE,
      evaluation_no                  VARCHAR2 (1000),
      repair_amt                     gicl_mc_evaluation.repair_amt%TYPE,
      master_flag                    VARCHAR2 (1),
      cancel_flag                    VARCHAR2 (1),
      ded_flag                       NUMBER (1),
      dep_flag                       NUMBER (1),
      v_payee_cd_gicl_replace        gicl_replace.payee_cd%TYPE,
      v_payee_type_cd_gicl_replace   gicl_replace.payee_type_cd%TYPE,
      in_hou_adj                     gicl_claims.in_hou_adj%TYPE,
      master_report_type             gicl_mc_evaluation.report_type%TYPE,
      main_eval_vat_exist            VARCHAR2 (1)
   );

   TYPE mc_eval_list_tab IS TABLE OF mc_eval_list_type;

   FUNCTION get_mc_evaluation_list (
      p_claim_id         gicl_mc_evaluation.claim_id%TYPE,
      p_item_no          gicl_mc_evaluation.item_no%TYPE,
      p_payee_no         gicl_mc_evaluation.payee_no%TYPE,
      p_payee_class_cd   gicl_mc_evaluation.payee_class_cd%TYPE,
      p_plate_no         gicl_mc_evaluation.plate_no%TYPE,
      p_peril_cd         gicl_mc_evaluation.peril_cd%TYPE,
      p_subline_cd       VARCHAR2,
      p_iss_cd           VARCHAR2,
      p_eval_yy          NUMBER,
      p_eval_seq_no      NUMBER,
      p_eval_version     NUMBER,
      p_cso_id           VARCHAR2,
      p_eval_date        VARCHAR2,
      p_inspect_date     VARCHAR2,
      p_pol_line_cd      gipi_polbasic.line_cd%TYPE,
      p_pol_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_pol_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_renew_no     gipi_polbasic.renew_no%TYPE
   )
      RETURN mc_eval_list_tab PIPELINED;

   PROCEDURE get_variables (
      replace_label        OUT   VARCHAR2,
      repair_label         OUT   VARCHAR2,
      mortgagee_class_cd   OUT   VARCHAR2,
      assd_class_cd        OUT   VARCHAR2,
      input_vat_rt         OUT   NUMBER
   );

   PROCEDURE mc_eval_blk_pre_insert (
      p_new_rep_flag              VARCHAR2,
      p_copy_dtl_flag             VARCHAR2,
      p_revise_flag      IN       VARCHAR2,
      p_iss_cd                    gicl_mc_evaluation.iss_cd%TYPE,
      p_subline_cd                gicl_mc_evaluation.subline_cd%TYPE,
      p_inspect_date     IN OUT   VARCHAR2,
      p_eval_master_id   IN OUT   gicl_mc_evaluation.eval_master_id%TYPE,
      p_replace_amt      IN OUT   gicl_mc_evaluation.replace_amt%TYPE,
      p_repair_amt       IN OUT   gicl_mc_evaluation.repair_amt%TYPE,
      p_deductible2      OUT      gicl_mc_evaluation.deductible%TYPE,
      p_depreciation     OUT      gicl_mc_evaluation.depreciation%TYPE,
      p_eval_seq_no      OUT      gicl_mc_evaluation.eval_seq_no%TYPE,
      p_eval_yy          IN OUT   gicl_mc_evaluation.eval_yy%TYPE,
      p_eval_id          OUT      gicl_mc_evaluation.eval_id%TYPE,
      p_eval_version     OUT      gicl_mc_evaluation.eval_version%TYPE,
      p_eval_stat_cd     IN OUT   gicl_mc_evaluation.eval_stat_cd%TYPE,
      p_report_type      IN OUT   gicl_mc_evaluation.report_type%TYPE,
      p_vat              OUT      gicl_mc_evaluation.vat%TYPE,   -- added by kenneth L to insert vat value when copying MC eval report
      p_inspect_place    IN OUT   gicl_mc_evaluation.inspect_place%TYPE, --marco - 03.27.2014
      p_adjuster_id      IN OUT   gicl_mc_evaluation.adjuster_id%TYPE    --
   );

   PROCEDURE insert_mc_eval (
      p_eval_master_id   gicl_mc_evaluation.eval_master_id%TYPE,
      p_inspect_date     VARCHAR2,
      p_inspect_place    gicl_mc_evaluation.inspect_place%TYPE,
      p_subline_cd       gicl_mc_evaluation.subline_cd%TYPE,
      p_iss_cd           gicl_mc_evaluation.iss_cd%TYPE,
      p_eval_yy          gicl_mc_evaluation.eval_yy%TYPE,
      p_cso_id           gicl_mc_evaluation.cso_id%TYPE,
      p_item_no          gicl_mc_evaluation.item_no%TYPE,
      p_claim_id         gicl_mc_evaluation.claim_id%TYPE,
      p_peril_cd         gicl_mc_evaluation.peril_cd%TYPE,
      p_plate_no         gicl_mc_evaluation.plate_no%TYPE,
      p_tp_sw            gicl_mc_evaluation.tp_sw%TYPE,
      p_payee_no         gicl_mc_evaluation.payee_no%TYPE,
      p_payee_class_cd   gicl_mc_evaluation.payee_class_cd%TYPE,
      p_currency_cd      gicl_mc_evaluation.currency_cd%TYPE,
      p_currency_rate    gicl_mc_evaluation.currency_rate%TYPE,
      p_replace_amt      gicl_mc_evaluation.replace_amt%TYPE,
      p_report_type      gicl_mc_evaluation.report_type%TYPE,
      p_eval_version     gicl_mc_evaluation.eval_version%TYPE,
      p_eval_id          gicl_mc_evaluation.eval_id%TYPE,
      p_eval_seq_no      gicl_mc_evaluation.eval_seq_no%TYPE,
      p_repair_amt       gicl_mc_evaluation.repair_amt%TYPE,
      p_depreciation     gicl_mc_evaluation.depreciation%TYPE,
      p_deductible       gicl_mc_evaluation.deductible%TYPE,
      p_adjuster_id      gicl_mc_evaluation.adjuster_id%TYPE,
      p_eval_stat_cd     gicl_mc_evaluation.eval_stat_cd%TYPE,
      p_eval_date        VARCHAR2,
      p_remarks          gicl_mc_evaluation.remarks%TYPE,
      p_vat              gicl_mc_evaluation.vat%TYPE
   );

   TYPE copy_report_type IS RECORD (
      evaluation_no   VARCHAR2 (1000),
      eval_id         gicl_mc_evaluation.eval_id%TYPE
   );

   TYPE copy_report_tab IS TABLE OF copy_report_type;

   FUNCTION get_copy_report_list (
      p_claim_id    gicl_claims.claim_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN copy_report_tab PIPELINED;

   PROCEDURE update_mc_eval (
      p_eval_id         gicl_mc_evaluation.eval_id%TYPE,
      p_remarks         gicl_mc_evaluation.remarks%TYPE,
      p_inspect_date    VARCHAR2,
      p_adjuster_id     gicl_mc_evaluation.adjuster_id%TYPE,
      p_inspect_place   gicl_mc_evaluation.inspect_place%TYPE
   );

   PROCEDURE cancel_mc_eval (
      p_eval_id          gicl_mc_evaluation.eval_id%TYPE,
      p_eval_master_id   gicl_mc_evaluation.eval_master_id%TYPE,
      p_report_type      gicl_mc_evaluation.report_type%TYPE
   );

   TYPE for_additional_report_type IS RECORD (
      eval_id         gicl_mc_evaluation.eval_id%TYPE,
      evaluation_no   VARCHAR2 (1000),
      eval_date       VARCHAR2 (10),
      inspect_date    VARCHAR2 (10),
      inspect_place   gicl_mc_evaluation.inspect_place%TYPE,
      dsp_eval_desc   gicl_mc_eval_stat.eval_stat_desc%TYPE,
      adjuster_id     gicl_mc_evaluation.adjuster_id%TYPE,
      adjuster        VARCHAR2 (290)
   );

   TYPE for_additional_report_tab IS TABLE OF for_additional_report_type;

   FUNCTION get_for_additional_report_list (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_plate_no         gicl_mc_evaluation.plate_no%TYPE,
      p_peril_cd         gicl_mc_evaluation.peril_cd%TYPE,
      p_payee_class_cd   gicl_mc_evaluation.payee_class_cd%TYPE,
      p_payee_no         gicl_mc_evaluation.payee_no%TYPE,
      p_tp_sw            gicl_mc_evaluation.tp_sw%TYPE,
      p_eval_stat_cd     gicl_mc_evaluation.eval_stat_cd%TYPE,
      p_item_no          gicl_mc_evaluation.item_no%TYPE,
      p_find_text        VARCHAR2
   )
      RETURN for_additional_report_tab PIPELINED;

   PROCEDURE validate_before_posting (
      p_claim_id           gicl_claims.claim_id%TYPE,
      p_item_no            gicl_mc_evaluation.item_no%TYPE,
      p_peril_cd           gicl_mc_evaluation.peril_cd%TYPE,
      p_eval_id            gicl_mc_evaluation.eval_id%TYPE,
      p_clm_iss_cd         gicl_claims.iss_cd%TYPE,
      p_user_id            VARCHAR2,
      p_res_amt      OUT   gicl_mc_evaluation.repair_amt%TYPE,
      p_message      OUT   VARCHAR2
   );

   PROCEDURE post_evaluation_report (
      p_eval_id         gicl_mc_evaluation.eval_id%TYPE,
      p_claim_id        gicl_claims.claim_id%TYPE,
      p_item_no         gicl_mc_evaluation.item_no%TYPE,
      p_peril_cd        gicl_mc_evaluation.peril_cd%TYPE,
      p_currency_cd     gicl_mc_evaluation.currency_cd%TYPE,
      p_currency_rate   gicl_mc_evaluation.currency_rate%TYPE,
      p_remarks         gicl_mc_evaluation.remarks%TYPE,
      p_inspect_date    VARCHAR2,
      p_adjuster_id     gicl_mc_evaluation.adjuster_id%TYPE,
      p_inspect_place   gicl_mc_evaluation.inspect_place%TYPE
   );

   PROCEDURE create_settlement_for_report (
      p_eval_id           gicl_mc_evaluation.eval_id%TYPE,
      p_claim_id     IN   gicl_mc_evaluation.claim_id%TYPE,
      p_item_no      IN   gicl_mc_evaluation.item_no%TYPE,
      p_peril_cd     IN   gicl_mc_evaluation.peril_cd%TYPE,
      p_tot_estcos        gicl_mc_evaluation.vat%TYPE,
      p_vat               gicl_mc_evaluation.vat%TYPE
   );

   FUNCTION validate_override_user (
      p_user_id   IN   giac_users.user_id%TYPE,
      p_iss_cd    IN   gicl_claims.iss_cd%TYPE,
      p_res_amt   IN   gicl_mc_evaluation.repair_amt%TYPE,
      p_param          VARCHAR2
   )
      RETURN VARCHAR2;

   PROCEDURE update_eval_dep_vat_amt (
      p_eval_id   gicl_mc_evaluation.eval_id%TYPE
   );

   FUNCTION get_le_eval_report_list (p_claim_id IN gicl_claims.claim_id%TYPE)
      RETURN le_eval_report_tab PIPELINED;

   PROCEDURE create_settlement_for_eval_rep (
      p_claim_id         IN   gicl_item_peril.claim_id%TYPE,
      p_item_no          IN   gicl_item_peril.item_no%TYPE,
      p_peril_cd         IN   gicl_item_peril.peril_cd%TYPE,
      p_eval_id          IN   gicl_mc_evaluation.eval_id%TYPE,
      p_param_peril_cd   IN   gicl_mc_evaluation.peril_cd%TYPE
   );

   PROCEDURE pop_giclmceval (
      p_claim_id             IN OUT   gicl_item_peril.claim_id%TYPE,
      p_subline_cd           IN OUT   gicl_claims.subline_cd%TYPE,
      p_iss_cd               IN OUT   gicl_claims.iss_cd%TYPE,
      p_clm_yy               IN OUT   gicl_claims.clm_yy%TYPE,
      p_clm_seq_no           IN OUT   gicl_claims.clm_seq_no%TYPE,
      p_user_id              IN       gicl_claims.user_id%TYPE,
      p_loss_date            OUT      VARCHAR2,
      p_assured_name         OUT      VARCHAR2,
      p_pol_iss_cd           OUT      gicl_claims.iss_cd%TYPE,
      p_pol_issue_yy         OUT      gicl_claims.clm_yy%TYPE,
      p_pol_seq_no           OUT      gicl_claims.clm_seq_no%TYPE,
      p_pol_renew_no         OUT      gicl_claims.renew_no%TYPE,
      p_item_no              OUT      gicl_item_peril.item_no%TYPE,
      p_plate_no             OUT      gicl_mc_evaluation.plate_no%TYPE,
      p_tp_sw                OUT      gicl_mc_evaluation.tp_sw%TYPE,
      p_dsp_payee            OUT      VARCHAR2,
      p_dsp_curr_shortname   OUT      giis_currency.short_name%TYPE,
      p_currency_cd          OUT      gicl_motor_car_dtl.currency_cd%TYPE,
      p_currency_rate        OUT      gicl_motor_car_dtl.currency_rate%TYPE,
      p_peril_cd             OUT      gicl_mc_evaluation.peril_cd%TYPE,
      p_dsp_peril_desc       OUT      giis_peril.peril_name%TYPE,
      p_dsp_item_desc        OUT      gicl_motor_car_dtl.item_title%TYPE,
      p_adjuster_id          OUT      gicl_mc_evaluation.adjuster_id%TYPE,
      p_dsp_adjuster_desc    OUT      giis_adjuster.payee_name%TYPE,
      p_ann_tsi_amt          OUT      gipi_polbasic.ann_tsi_amt%TYPE,
      allow_plate_no         OUT      VARCHAR2,
      allow_peril_cd         OUT      VARCHAR2,
      allow_adjuster         OUT      VARCHAR2,
      eval_exist             OUT      VARCHAR2,
      MESSAGE                OUT      VARCHAR2
   );

   TYPE mc_eval_peril_type IS RECORD (
      peril_cd         gicl_mc_evaluation.peril_cd%TYPE,
      dsp_peril_desc   giis_peril.peril_name%TYPE
   );

   TYPE mc_eval_peril_tab IS TABLE OF mc_eval_peril_type;

   FUNCTION get_eval_peril_lov (
      p_claim_id    gicl_item_peril.claim_id%TYPE,
      p_item_no     gicl_item_peril.item_no%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN mc_eval_peril_tab PIPELINED;

   TYPE item_no_lov_type IS RECORD (
      item_no          gicl_mc_tp_dtl.item_no%TYPE,
      plate_no         gicl_mc_tp_dtl.plate_no%TYPE,
      item_title       gicl_motor_car_dtl.item_title%TYPE,
      car_company      giis_mc_car_company.car_company%TYPE,
      make             giis_mc_make.make%TYPE,
      engine_series    giis_mc_eng_series.engine_series%TYPE,
      payee_name       VARCHAR2 (290),
      tp_sw            VARCHAR2 (1),
      payee_class_cd   gicl_mc_tp_dtl.payee_class_cd%TYPE,
      payee_no         gicl_mc_tp_dtl.payee_no%TYPE,
      currency_cd      gicl_motor_car_dtl.currency_cd%TYPE,
      short_name       giis_currency.short_name%TYPE,
      peril_cd         gicl_mc_evaluation.peril_cd%TYPE,
      dsp_peril_desc   giis_peril.peril_name%TYPE,
      allow_peril      VARCHAR2 (1)
   );

   TYPE item_no_lov_tab IS TABLE OF item_no_lov_type;

   FUNCTION get_mc_eval_item_lov (
      p_claim_id    gicl_claims.claim_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN item_no_lov_tab PIPELINED;

   PROCEDURE master_blk_key_commit (
      p_claim_id         gicl_item_peril.claim_id%TYPE,
      p_item_no          gicl_item_peril.item_no%TYPE,
      p_plate_no         gicl_mc_tp_dtl.plate_no%TYPE,
      p_tp_sw            gicl_mc_evaluation.tp_sw%TYPE,
      p_peril_cd         gicl_mc_evaluation.peril_cd%TYPE,
      p_payee_class_cd   gicl_mc_evaluation.payee_class_cd%TYPE,
      p_payee_no         gicl_mc_evaluation.payee_no%TYPE,
      v_item_no          gicl_item_peril.item_no%TYPE,
      v_plate_no         gicl_mc_tp_dtl.plate_no%TYPE,
      v_tp_sw            gicl_mc_evaluation.tp_sw%TYPE,
      v_peril_cd         gicl_mc_evaluation.peril_cd%TYPE,
      v_payee_class_cd   gicl_mc_evaluation.payee_class_cd%TYPE,
      v_payee_no         gicl_mc_evaluation.payee_no%TYPE,
      p_eval_id          gicl_mc_evaluation.eval_id%TYPE
   );

   TYPE plate_no_lov_type IS RECORD (
      plate_no         gicl_mc_tp_dtl.plate_no%TYPE,
      payee_name       VARCHAR2 (290),
      tp_sw            VARCHAR2 (1),
      payee_class_cd   gicl_mc_evaluation.payee_class_cd%TYPE,
      payee_no         gicl_mc_evaluation.payee_no%TYPE
   );

   TYPE plate_no_lov_tab IS TABLE OF plate_no_lov_type;

   FUNCTION get_plate_no_lov (
      p_claim_id    gicl_item_peril.claim_id%TYPE,
      p_item_no     gicl_item_peril.item_no%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN plate_no_lov_tab PIPELINED;
	  
    procedure get_item_peril(p_claim_id gicl_claims.claim_id%type, p_item_no gicl_item_peril.item_no%type, v_peril_cd out gicl_item_peril.peril_cd%type, v_peril_name out giis_peril.peril_name%type, v_multiple_peril out varchar2 );	  

    FUNCTION check_mc_evaluation_exist (
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.iss_cd%TYPE,
      p_clm_yy       gicl_claims.clm_yy%TYPE,
      p_clm_seq_no   gicl_claims.clm_seq_no%TYPE,
      p_user_id      VARCHAR2
   )
      RETURN mc_evaluation_info_tab PIPELINED;
      
END gicl_mc_evaluation_pkg;

--DROP PUBLIC SYNONYM GICL_MC_EVALUATION_PKG; comment out by MAC 12/05/2013.
/


