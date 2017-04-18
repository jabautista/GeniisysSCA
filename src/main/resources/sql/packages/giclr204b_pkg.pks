CREATE OR REPLACE PACKAGE CPI.giclr204b_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      as_of             VARCHAR2 (100),
      assd_name         VARCHAR2 (500),
      line_name         VARCHAR2 (100),
      iss_name          VARCHAR2 (100),
      intm_name         VARCHAR2 (500),
      assd_no           VARCHAR2 (100),
      line_cd           VARCHAR2 (100),
      iss_cd            VARCHAR2 (100),
      intm_no           VARCHAR2 (100),
      subline           VARCHAR2 (100),
      loss_paid_amt     gicl_loss_ratio_ext.loss_paid_amt%TYPE,
      curr_loss_res     gicl_loss_ratio_ext.curr_loss_res%TYPE,
      prev_loss_res     gicl_loss_ratio_ext.prev_loss_res%TYPE,
      curr_prem_amt     gicl_loss_ratio_ext.curr_prem_amt%TYPE,
      prem_res_cy       gicl_loss_ratio_ext.curr_prem_res%TYPE,
      prem_res_py       gicl_loss_ratio_ext.prev_prem_res%TYPE,
      losses_incurred   NUMBER (16, 2),
      premiums_earned   NUMBER (16, 2),
      loss_ratio        NUMBER
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giclr_204b_report (
      p_assd_no      NUMBER,
      p_date         VARCHAR2,
      p_intm_no      NUMBER,
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_session_id   NUMBER,
      p_subline_cd   VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/


