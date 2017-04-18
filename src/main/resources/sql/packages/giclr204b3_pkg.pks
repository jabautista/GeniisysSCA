CREATE OR REPLACE PACKAGE CPI.giclr204b3_pkg
AS
   TYPE curr_prem_record_type IS RECORD (
      subline_cd          gicl_lratio_curr_prem_ext.subline_cd%TYPE,
      assd_no             gicl_lratio_curr_prem_ext.assd_no%TYPE,
      policy_no           VARCHAR (100),
      policy_id           gipi_polbasic.policy_id%TYPE,
      endt_iss_cd         gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy             gipi_polbasic.endt_yy%TYPE,
      endt_seq_no         gipi_polbasic.endt_seq_no%TYPE,
      incept_date         gipi_polbasic.incept_date%TYPE,
      expiry_date         gipi_polbasic.expiry_date%TYPE,
      tsi_amt             gipi_polbasic.tsi_amt%TYPE,
      prem_amt            gicl_lratio_curr_prem_ext.prem_amt%TYPE,
      subline_name        VARCHAR (50),
      assd_name           giis_assured.assd_name%TYPE,
      date_month          DATE,
      company_name        VARCHAR2 (500),
      company_address     VARCHAR2 (500),
      mjm                 VARCHAR2 (1),
      cf_date             VARCHAR2 (20),
      date_month_string   VARCHAR2 (50)
   );

   TYPE curr_prem_record_tab IS TABLE OF curr_prem_record_type;

   TYPE prev_prem_record_type IS RECORD (
      subline_cd          gicl_lratio_curr_prem_ext.subline_cd%TYPE,
      assd_no             gicl_lratio_curr_prem_ext.assd_no%TYPE,
      policy_no           VARCHAR (100),
      policy_id           gipi_polbasic.policy_id%TYPE,
      endt_iss_cd         gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy             gipi_polbasic.endt_yy%TYPE,
      endt_seq_no         gipi_polbasic.endt_seq_no%TYPE,
      incept_date         gipi_polbasic.incept_date%TYPE,
      expiry_date         gipi_polbasic.expiry_date%TYPE,
      tsi_amt             gipi_polbasic.tsi_amt%TYPE,
      prem_amt            gicl_lratio_curr_prem_ext.prem_amt%TYPE,
      subline_name        VARCHAR (50),
      assd_name           giis_assured.assd_name%TYPE,
      date_month          DATE,
      mjm                 VARCHAR2 (1),
      cf_date             VARCHAR2 (20),
      date_month_string   VARCHAR2 (50)
   );

   TYPE prev_prem_record_tab IS TABLE OF prev_prem_record_type;

   TYPE curr_loss_record_type IS RECORD (
      subline_name    VARCHAR (50),
      subline_cd      gicl_lratio_curr_os_ext.subline_cd%TYPE,
      assd_no         gicl_lratio_curr_os_ext.assd_no%TYPE,
      assd_name       giis_assured.assd_name%TYPE,
      claim_id        gicl_lratio_curr_os_ext.claim_id%TYPE,
      os_amt          gicl_lratio_curr_os_ext.os_amt%TYPE,
      dsp_loss_date   gicl_claims.dsp_loss_date%TYPE,
      clm_file_date   gicl_claims.clm_file_date%TYPE,
      claim           VARCHAR2 (50),
      mjm             VARCHAR2 (1)
   );

   TYPE curr_loss_record_tab IS TABLE OF curr_loss_record_type;

   TYPE prev_loss_record_type IS RECORD (
      subline_name    VARCHAR (50),
      subline_cd      gicl_lratio_prev_os_ext.subline_cd%TYPE,
      assd_no         gicl_lratio_prev_os_ext.assd_no%TYPE,
      assd_name       giis_assured.assd_name%TYPE,
      claim_id        gicl_lratio_prev_os_ext.claim_id%TYPE,
      os_amt          gicl_lratio_prev_os_ext.os_amt%TYPE,
      dsp_loss_date   gicl_claims.dsp_loss_date%TYPE,
      clm_file_date   gicl_claims.clm_file_date%TYPE,
      claim           VARCHAR2 (50),
      mjm             VARCHAR2 (1)
   );

   TYPE prev_loss_record_tab IS TABLE OF prev_loss_record_type;

   TYPE losses_paid_record_type IS RECORD (
      subline_cd      gicl_lratio_loss_paid_ext.subline_cd%TYPE,
      subline_name    VARCHAR (50),
      assd_no         gicl_lratio_loss_paid_ext.assd_no%TYPE,
      assd_name       giis_assured.assd_name%TYPE,
      claim           VARCHAR2 (50),
      dsp_loss_date   gicl_claims.dsp_loss_date%TYPE,
      loss_paid       gicl_lratio_loss_paid_ext.loss_paid%TYPE,
      mjm             VARCHAR2 (1)
   );

   TYPE losses_paid_record_tab IS TABLE OF losses_paid_record_type;

   TYPE curr_recovery_record_type IS RECORD (
      subline_cd      gicl_lratio_curr_recovery_ext.subline_cd%TYPE,
      subline_name    VARCHAR (50),
      assd_no         gicl_lratio_curr_recovery_ext.assd_no%TYPE,
      assd_name       giis_assured.assd_name%TYPE,
      rec_type_desc   giis_recovery_type.rec_type_desc%TYPE,
      recovered_amt   gicl_lratio_curr_recovery_ext.recovered_amt%TYPE,
      dsp_loss_date   gicl_claims.dsp_loss_date%TYPE,
      recovery_no     VARCHAR (50),
      mjm             VARCHAR2 (1)
   );

   TYPE curr_recovery_record_tab IS TABLE OF curr_recovery_record_type;

   TYPE prev_recovery_record_type IS RECORD (
      subline_cd      gicl_lratio_prev_recovery_ext.subline_cd%TYPE,
      subline_name    VARCHAR (50),
      assd_no         gicl_lratio_prev_recovery_ext.assd_no%TYPE,
      assd_name       giis_assured.assd_name%TYPE,
      rec_type_desc   giis_recovery_type.rec_type_desc%TYPE,
      recovered_amt   gicl_lratio_prev_recovery_ext.recovered_amt%TYPE,
      dsp_loss_date   gicl_claims.dsp_loss_date%TYPE,
      recovery_no     VARCHAR (50),
      mjm             VARCHAR2 (1)
   );

   TYPE prev_recovery_record_tab IS TABLE OF prev_recovery_record_type;

   FUNCTION get_curr_prem_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN curr_prem_record_tab PIPELINED;

   FUNCTION get_prev_prem_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN prev_prem_record_tab PIPELINED;

   FUNCTION get_curr_loss_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN curr_loss_record_tab PIPELINED;

   FUNCTION get_prev_loss_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN prev_loss_record_tab PIPELINED;

   FUNCTION get_losses_paid_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN losses_paid_record_tab PIPELINED;

   FUNCTION get_curr_recovery_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN curr_recovery_record_tab PIPELINED;

   FUNCTION get_prev_recovery_record (
      p_session_id        NUMBER,
      p_curr_start_date   VARCHAR2,
      p_curr_end_date     VARCHAR2,
      p_prev_end_date     VARCHAR2,
      p_prev_year         VARCHAR2,
      p_curr_year         VARCHAR2,
      p_curr_prem         VARCHAR2,
      p_prev_prem         VARCHAR2,
      p_curr_os           VARCHAR2,
      p_prev_os           VARCHAR2,
      p_loss_paid         VARCHAR2,
      p_curr_rec          VARCHAR2,
      p_prev_rec          VARCHAR2,
      p_curr_24           VARCHAR2,
      p_curr1_24          VARCHAR2,
      p_prev_24           VARCHAR2,
      p_prev1_24          VARCHAR2,
      p_prnt_date         VARCHAR2
   )
      RETURN prev_recovery_record_tab PIPELINED;
END;
/


