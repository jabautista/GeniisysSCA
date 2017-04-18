CREATE OR REPLACE PACKAGE CPI.gicl_repair_other_dtl_pkg
AS
/******************************************************************************
   NAME:       gicl_repair_other_dtl_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/03/2012    Irwin Tabisora   1. Created this package.
******************************************************************************/
   TYPE gicl_repair_other_dtl_type IS RECORD (
      eval_id       gicl_repair_other_dtl.eval_id%TYPE,
      repair_cd     gicl_repair_other_dtl.repair_cd%TYPE,
      amount        gicl_repair_other_dtl.amount%TYPE,
      item_no       gicl_repair_other_dtl.item_no%TYPE,
      update_sw     gicl_repair_other_dtl.update_sw%TYPE,
      repair_desc   gicl_repair_type.repair_desc%TYPE
   );

   TYPE gicl_repair_other_dtl_tab IS TABLE OF gicl_repair_other_dtl_type;

   FUNCTION get_gicl_repair_other_dtl (
      p_eval_id   gicl_repair_other_dtl.eval_id%TYPE
   )
      RETURN gicl_repair_other_dtl_tab PIPELINED;

   PROCEDURE validate_before_save_other (
      p_eval_id                  gicl_repair_other_dtl.eval_id%TYPE,
      p_eval_master_id           gicl_mc_evaluation.eval_master_id%TYPE,
      p_payee_type_cd            gicl_repair_hdr.payee_type_cd%TYPE,
      p_payee_cd                 gicl_repair_hdr.payee_cd%TYPE,
      vat_exist            OUT   VARCHAR2,
      ded_exist            OUT   VARCHAR2,
      master_report_type   OUT   VARCHAR2
   );

   PROCEDURE delete_details_labor (
      p_eval_id         gicl_repair_other_dtl.eval_id%TYPE,
      p_payee_type_cd   gicl_repair_hdr.payee_type_cd%TYPE,
      p_payee_cd        gicl_repair_hdr.payee_cd%TYPE,
      p_vat_exist       VARCHAR2,
      p_ded_exist       VARCHAR2
   );

   PROCEDURE save_repair_other_dtl (
      p_eval_master_id       gicl_mc_evaluation.eval_master_id%TYPE,
      p_eval_id              gicl_repair_other_dtl.eval_id%TYPE,
      p_repair_cd            gicl_repair_other_dtl.repair_cd%TYPE,
      p_amount               gicl_repair_other_dtl.amount%TYPE,
      p_item_no              gicl_repair_other_dtl.item_no%TYPE,
      p_master_report_type   VARCHAR2
   );

   PROCEDURE set_repair_other_dtl (
      p_eval_id     gicl_repair_other_dtl.eval_id%TYPE,
      p_repair_cd   gicl_repair_other_dtl.repair_cd%TYPE,
      p_amount      gicl_repair_other_dtl.amount%TYPE,
      p_item_no     gicl_repair_other_dtl.item_no%TYPE,
      p_update_sw   gicl_repair_other_dtl.update_sw%TYPE
   );

   PROCEDURE update_other_details (
      p_eval_id   gicl_repair_other_dtl.eval_id%TYPE,
	  dsp_total_labor gicl_repair_other_dtl.amount%TYPE
   );

   PROCEDURE del_repair_other_dtl (
      p_eval_id     gicl_repair_other_dtl.eval_id%TYPE,
      p_item_no     gicl_repair_other_dtl.item_no%TYPE,
      p_repair_cd   gicl_repair_other_dtl.repair_cd%TYPE
   );
END;
/


