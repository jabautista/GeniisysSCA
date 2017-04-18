CREATE OR REPLACE PACKAGE CPI.gicl_repair_hdr_pkg
/******************************************************************************
   NAME:       gicl_repair_hdr_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/27/2012    Irwin Tabisora   1. Created this package.
******************************************************************************/
AS
   TYPE repair_dtl_type IS RECORD (
      eval_id               gicl_repair_hdr.eval_id%TYPE,
      payee_type_cd         gicl_repair_hdr.payee_type_cd%TYPE,
      payee_cd              gicl_repair_hdr.payee_cd%TYPE,
      lps_repair_amt        gicl_repair_hdr.lps_repair_amt%TYPE,
      actual_total_amt      gicl_repair_hdr.actual_total_amt%TYPE,
      actual_tinsmith_amt   gicl_repair_hdr.actual_tinsmith_amt%TYPE,
      actual_painting_amt   gicl_repair_hdr.actual_painting_amt%TYPE,
      other_labor_amt       gicl_repair_hdr.other_labor_amt%TYPE,
      with_vat              gicl_repair_hdr.with_vat%TYPE,
      user_id               gicl_repair_hdr.user_id%TYPE,
      last_update           gicl_repair_hdr.last_update%TYPE,
      update_sw             gicl_repair_hdr.update_sw%TYPE,
      dsp_company_type      giis_payee_class.class_desc%TYPE,
      dsp_company           VARCHAR2 (290),
      dsp_labor_com_type    giis_payee_class.class_desc%TYPE,
      dsp_labor_company     VARCHAR2 (290),
      dsp_total_labor       NUMBER (16, 2),
      dsp_total_p           gicl_repair_hdr.other_labor_amt%TYPE,
      dsp_total_t           gicl_repair_hdr.other_labor_amt%TYPE
   );

   TYPE repair_dtl_tab IS TABLE OF repair_dtl_type;

   FUNCTION get_repair_dtl (p_eval_id gicl_repair_hdr.eval_id%TYPE)
      RETURN repair_dtl_tab PIPELINED;

   FUNCTION validate_before_save (
      p_eval_master_id     IN   gicl_mc_evaluation.eval_id%TYPE,
      p_eval_id                 gicl_mc_evaluation.eval_id%TYPE,
      p_actual_total_amt        gicl_repair_hdr.actual_total_amt%TYPE,
      p_payee_type_cd           gicl_repair_hdr.payee_type_cd%TYPE,
      p_payee_cd                gicl_repair_hdr.payee_cd%TYPE
   )
      RETURN VARCHAR2;

   PROCEDURE save_gicl_repair_hdr (
      p_eval_id               gicl_repair_hdr.eval_id%TYPE,
      p_payee_type_cd         gicl_repair_hdr.payee_type_cd%TYPE,
      p_payee_cd              gicl_repair_hdr.payee_cd%TYPE,
      p_lps_repair_amt        gicl_repair_hdr.lps_repair_amt%TYPE,
      p_actual_total_amt      gicl_repair_hdr.actual_total_amt%TYPE,
      p_actual_tinsmith_amt   gicl_repair_hdr.actual_tinsmith_amt%TYPE,
      p_actual_painting_amt   gicl_repair_hdr.actual_painting_amt%TYPE,
      p_other_labor_amt       gicl_repair_hdr.other_labor_amt%TYPE,
      p_with_vat              gicl_repair_hdr.with_vat%TYPE
   );

   PROCEDURE update_gicl_repair_dtls (
      p_eval_id            gicl_repair_hdr.eval_id%TYPE,
      p_actual_total_amt   gicl_repair_hdr.actual_total_amt%TYPE,
      p_payee_type_cd      gicl_repair_hdr.payee_type_cd%TYPE,
      p_payee_cd           gicl_repair_hdr.payee_cd%TYPE,
      p_dsp_total_labor    gicl_repair_hdr.actual_total_amt%TYPE
   );
END;
/


