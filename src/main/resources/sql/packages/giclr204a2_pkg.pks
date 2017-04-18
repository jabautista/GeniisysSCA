CREATE OR REPLACE PACKAGE CPI.giclr204a2_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giclr_204a2_report (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN report_tab PIPELINED;

   TYPE giclr204a2_type IS RECORD (
      line          VARCHAR2 (100),
      POLICY        VARCHAR2 (200),
      assured       VARCHAR2 (520),
      incept_date   gipi_polbasic.incept_date%TYPE,
      expiry_date   gipi_polbasic.expiry_date%TYPE,
      cf_date       VARCHAR2 (100),
      tsi_amt       gipi_polbasic.tsi_amt%TYPE,
      prem_amt      gipi_polbasic.prem_amt%TYPE,
      page_header   VARCHAR2 (200)
   );

   TYPE giclr204a2_tab IS TABLE OF giclr204a2_type;

   FUNCTION get_giclr_204a2_q1 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab PIPELINED;

   FUNCTION get_giclr_204a2_q2 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a2_tab PIPELINED;

   TYPE giclr204a3_type IS RECORD (
      line          VARCHAR2 (100),
      claim_no      VARCHAR2 (200),
      assured       VARCHAR2 (520),
      loss_date     gicl_claims.dsp_loss_date%TYPE,
      file_date     gicl_claims.clm_file_date%TYPE,
      loss_amt      gicl_lratio_curr_os_ext.os_amt%TYPE,
      page_header   VARCHAR2 (200)
   );

   TYPE giclr204a3_tab IS TABLE OF giclr204a3_type;

   FUNCTION get_giclr_204a2_q3 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a3_tab PIPELINED;

   FUNCTION get_giclr_204a2_q4 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a3_tab PIPELINED;

   TYPE giclr204a4_type IS RECORD (
      line          VARCHAR2 (100),
      claim_no      VARCHAR2 (200),
      assured       VARCHAR2 (520),
      loss_date     gicl_claims.dsp_loss_date%TYPE,
      loss_amt      gicl_lratio_curr_os_ext.os_amt%TYPE,
      page_header   VARCHAR2 (200)
   );

   TYPE giclr204a4_tab IS TABLE OF giclr204a4_type;

   FUNCTION get_giclr_204a2_q5 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a4_tab PIPELINED;

   TYPE giclr204a5_type IS RECORD (
      line          VARCHAR2 (100),
      rec_no        VARCHAR2 (200),
      assured       VARCHAR2 (520),
      rec_type      giis_recovery_type.rec_type_desc%TYPE,
      loss_date     gicl_claims.dsp_loss_date%TYPE,
      rec_amt       gicl_lratio_curr_recovery_ext.recovered_amt%TYPE,
      page_header   VARCHAR2 (200)
   );

   TYPE giclr204a5_tab IS TABLE OF giclr204a5_type;

   FUNCTION get_giclr_204a2_q6 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a5_tab PIPELINED;

   FUNCTION get_giclr_204a2_q7 (
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204a5_tab PIPELINED;
END;
/


