CREATE OR REPLACE PACKAGE CPI.gicl_repair_lps_dtl_pkg
AS
/******************************************************************************
   NAME:       gicl_repair_lps_dtl_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/28/2012    Irwin Tabisora   1. Created this package.
******************************************************************************/
   TYPE gicl_repair_lps_dtl_type IS RECORD (
      eval_id               gicl_repair_lps_dtl.eval_id%TYPE,
      loss_exp_cd           gicl_repair_lps_dtl.loss_exp_cd%TYPE,
      tinsmith_type         gicl_repair_lps_dtl.tinsmith_type%TYPE,
      tinsmith_type_desc    VARCHAR2 (10),
      item_no               gicl_repair_lps_dtl.item_no%TYPE,
      update_sw             gicl_repair_lps_dtl.update_sw%TYPE,
      paintings_repair_cd   gicl_repair_lps_dtl.repair_cd%TYPE,     -- custom
      tinsmith_repair_cd    gicl_repair_lps_dtl.repair_cd%TYPE,     -- custom
      paintings_amount      gicl_repair_lps_dtl.amount%TYPE,
      tinsmith_amount       gicl_repair_lps_dtl.amount%TYPE,
      dsp_loss_desc         giis_loss_exp.loss_exp_desc%TYPE,
      total_amount          gicl_repair_lps_dtl.amount%TYPE
   );

   TYPE gicl_repair_lps_dtl_tab IS TABLE OF gicl_repair_lps_dtl_type;

   FUNCTION get_repair_lps_dtl_list (
      p_eval_id   gicl_repair_lps_dtl.eval_id%TYPE
   )
      RETURN gicl_repair_lps_dtl_tab PIPELINED;

   TYPE vehicle_parts_type IS RECORD (
      dsp_loss_desc   giis_loss_exp.loss_exp_desc%TYPE,
      loss_exp_cd     giis_loss_exp.loss_exp_cd%TYPE
   );

   TYPE vehicle_parts_tab IS TABLE OF vehicle_parts_type;

   FUNCTION get_vehicle_parts_list (
      p_eval_id     gicl_repair_lps_dtl.eval_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN vehicle_parts_tab PIPELINED;

   FUNCTION get_tinsmith_amount (
      p_tinsmith_type   gicl_repair_lps_dtl.tinsmith_type%TYPE,
      p_loss_exp_cd     gicl_repair_lps_dtl.loss_exp_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_paintings_amount (
      p_loss_exp_cd   gicl_repair_lps_dtl.loss_exp_cd%TYPE
   )
      RETURN VARCHAR2;

   PROCEDURE save_gicl_repair_lps_dtl (
      p_eval_master_id       IN   gicl_mc_evaluation.eval_id%TYPE,
      p_eval_id                   gicl_mc_evaluation.eval_id%TYPE,
      p_loss_exp_cd               gicl_repair_lps_dtl.loss_exp_cd%TYPE,
      p_amount                    gicl_repair_lps_dtl.amount%TYPE,
      p_tinsmith_type             gicl_repair_lps_dtl.tinsmith_type%TYPE,
      p_repair_cd                 gicl_repair_lps_dtl.repair_cd%TYPE,
      p_item_no                   gicl_repair_lps_dtl.item_no%TYPE,
      p_master_report_type        VARCHAR2
   );

   PROCEDURE set_repair_lps_dtl (
      p_eval_id         gicl_repair_lps_dtl.eval_id%TYPE,
      p_loss_exp_cd     gicl_repair_lps_dtl.loss_exp_cd%TYPE,
      p_repair_cd       gicl_repair_lps_dtl.repair_cd%TYPE,
      p_tinsmith_type   gicl_repair_lps_dtl.tinsmith_type%TYPE,
      p_amount          gicl_repair_lps_dtl.amount%TYPE,
      p_item_no         gicl_repair_lps_dtl.item_no%TYPE,
      p_update_sw       gicl_repair_lps_dtl.update_sw%TYPE
   );

   PROCEDURE del_repair_lps_dtl (
      p_eval_id       gicl_repair_lps_dtl.eval_id%TYPE,
      p_loss_exp_cd   gicl_repair_lps_dtl.loss_exp_cd%TYPE
   );

   PROCEDURE del_by_rep_cd (
      p_eval_id       gicl_repair_lps_dtl.eval_id%TYPE,
      p_loss_exp_cd   gicl_repair_lps_dtl.loss_exp_cd%TYPE,
      p_repair_cd     gicl_repair_lps_dtl.repair_cd%TYPE,
      p_item_no       gicl_repair_lps_dtl.item_no%TYPE
   );
END;
/


