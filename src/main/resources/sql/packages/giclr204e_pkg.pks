CREATE OR REPLACE PACKAGE CPI.giclr204e_pkg
AS
   TYPE giclr204e_record_type IS RECORD (
      assd_no           gicl_loss_ratio_ext.assd_no%TYPE,
      line_cd           gicl_loss_ratio_ext.line_cd%TYPE,
      loss_ratio_date   gicl_loss_ratio_ext.loss_ratio_date%TYPE,
      curr_prem_amt     gicl_loss_ratio_ext.curr_prem_amt%TYPE,
      prem_res_cy       gicl_loss_ratio_ext.curr_prem_res%TYPE,
      prem_res_py       gicl_loss_ratio_ext.prev_prem_res%TYPE,
      loss_paid_amt     gicl_loss_ratio_ext.loss_paid_amt%TYPE,
      curr_loss_res     gicl_loss_ratio_ext.curr_loss_res%TYPE,
      prev_loss_res     gicl_loss_ratio_ext.prev_loss_res%TYPE,
      premiums_earned   gicl_loss_ratio_ext.curr_prem_amt%TYPE,
      losses_incurred   gicl_loss_ratio_ext.loss_paid_amt%TYPE,
      company_name      VARCHAR2 (500),
      company_address   VARCHAR2 (500),
      line_name         VARCHAR2 (25),
      subline_name      VARCHAR2 (30),
      iss_name          VARCHAR2 (50),
      intm_name         VARCHAR2 (240),
      assd_name         VARCHAR2 (500),
      as_of_date        VARCHAR2 (100),
      mjm               VARCHAR2(1)
   );

   TYPE giclr204e_record_tab IS TABLE OF giclr204e_record_type;

   FUNCTION get_giclr204e_record (
      p_assd_no      NUMBER,
      p_intm_no      NUMBER,
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_session_id   NUMBER,
      p_subline_cd   VARCHAR2,
      p_date         VARCHAR2
   )
      RETURN giclr204e_record_tab PIPELINED;
END;
/


