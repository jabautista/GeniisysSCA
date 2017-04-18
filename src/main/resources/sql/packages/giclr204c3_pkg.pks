CREATE OR REPLACE PACKAGE CPI.giclr204c3_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giclr_204c3_report (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN report_tab PIPELINED;

   TYPE giclr204c3_type IS RECORD (
      iss           VARCHAR2 (100),
      MONTH         VARCHAR2 (100),
      POLICY        VARCHAR2 (200),
      assured       VARCHAR2 (520),
      incept_date   gipi_polbasic.incept_date%TYPE,
      expiry_date   gipi_polbasic.expiry_date%TYPE,
      cf_date       VARCHAR2 (100),
      tsi_amt       gipi_polbasic.tsi_amt%TYPE,
      prem_amt      gipi_polbasic.prem_amt%TYPE,
      page_header   VARCHAR2 (200)
   );

   TYPE giclr204c3_tab IS TABLE OF giclr204c3_type;

   FUNCTION get_giclr_204c3_q1 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_tab PIPELINED;

   FUNCTION get_giclr_204c3_q2 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_tab PIPELINED;

   TYPE giclr204c3_q3type IS RECORD (
      iss           VARCHAR2 (100),
      claim_no      VARCHAR2 (100),
      assured       VARCHAR2 (520),
      loss_date     gicl_claims.loss_date%TYPE,
      file_date     gicl_claims.clm_file_date%TYPE,
      loss_amt      gicl_lratio_curr_os_ext.os_amt%TYPE,
      page_header   VARCHAR2 (200)
   );

   TYPE giclr204c3_q3tab IS TABLE OF giclr204c3_q3type;

   FUNCTION get_giclr_204c3_q3 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_q3tab PIPELINED;

   FUNCTION get_giclr_204c3_q4 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_q3tab PIPELINED;

   FUNCTION get_giclr_204c3_q5 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_q3tab PIPELINED;

   TYPE giclr204c3_q6type IS RECORD (
      iss           VARCHAR2 (100),
      rec_no        VARCHAR2 (200),
      assured       VARCHAR2 (520),
      rec_type      giis_recovery_type.rec_type_desc%TYPE,
      loss_date     gicl_claims.dsp_loss_date%TYPE,
      rec_amt       gicl_lratio_curr_recovery_ext.recovered_amt%TYPE,
      page_header   VARCHAR2 (200)
   );

   TYPE giclr204c3_q6tab IS TABLE OF giclr204c3_q6type;

   FUNCTION get_giclr_204c3_q6 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_q6tab PIPELINED;

   FUNCTION get_giclr_204c3_q7 (
      p_curr1_24          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_curr_os           VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_curr_start_date   VARCHAR2,
      p_curr_year         VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_os           VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_prev_year         VARCHAR2,
      p_print_date        NUMBER,
      p_session_id        NUMBER
   )
      RETURN giclr204c3_q6tab PIPELINED;
END;
/


