CREATE OR REPLACE PACKAGE CPI.GICLR204F2_PKG
AS
   TYPE company_details_type IS RECORD(
      company_name          giis_parameters.param_value_v%TYPE,
      company_address       giis_parameters.param_value_v%TYPE
   );

   TYPE company_details_tab IS TABLE OF company_details_type;

   FUNCTION get_company_details
   RETURN company_details_tab PIPELINED;
   
   TYPE prem_details_type IS RECORD(
      peril_cd              gicl_lratio_curr_prem_ext.peril_cd%TYPE,
      peril_name            giis_peril.peril_name%TYPE,
      assd_no               gicl_lratio_curr_prem_ext.assd_no%TYPE,
      assd_name             giis_assured.assd_name%TYPE,
      policy_no             VARCHAR2(50),
      endt_iss_cd           gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy               gipi_polbasic.endt_yy%TYPE,
      endt_seq_no           gipi_polbasic.endt_seq_no%TYPE,
      incept_date           gipi_polbasic.incept_date%TYPE,
      expiry_date           gipi_polbasic.expiry_date%TYPE,
      tsi_amt               gipi_polbasic.tsi_amt%TYPE,
      sum_prem_amt          gipi_polbasic.prem_amt%TYPE,
      policy_id             gipi_polbasic.policy_id%TYPE,
      date_label            VARCHAR(15),
      cf_date               VARCHAR(20)
   );
   
   TYPE prem_details_tab IS TABLE OF prem_details_type;
  
   FUNCTION get_curr_prem(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab PIPELINED;

   FUNCTION get_prev_prem(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN prem_details_tab PIPELINED;
   
   TYPE os_details_type IS RECORD(
      peril_cd              gicl_lratio_curr_os_ext.peril_cd%TYPE,
      peril_name            giis_peril.peril_name%TYPE,
      assd_no               gicl_lratio_curr_prem_ext.assd_no%TYPE,
      assd_name             giis_assured.assd_name%TYPE,
      claim_id              gicl_lratio_curr_os_ext.claim_id%TYPE,
      sum_os_amt            gicl_lratio_curr_os_ext.os_amt%TYPE,
      dsp_loss_date         gicl_claims.dsp_loss_date%TYPE,
      clm_file_date         gicl_claims.clm_file_date%TYPE,
      claim_no              VARCHAR2(50)
   );
   
   TYPE os_details_tab IS TABLE OF os_details_type;
  
   FUNCTION get_curr_os(
      p_session_id          gicl_lratio_curr_os_ext.session_id%TYPE
   ) RETURN os_details_tab PIPELINED;
   
   FUNCTION get_prev_os(
      p_session_id          gicl_lratio_prev_os_ext.session_id%TYPE
   ) RETURN os_details_tab PIPELINED;
   
   TYPE loss_paid_details_type IS RECORD(
      assd_no               gicl_lratio_loss_paid_ext.assd_no%TYPE,
      assd_name             giis_assured.assd_name%TYPE,
      claim_no              VARCHAR2(50),
      peril_cd              gicl_lratio_loss_paid_ext.peril_cd%TYPE,
      peril_name            giis_peril.peril_name%TYPE,
      dsp_loss_date         gicl_claims.dsp_loss_date%TYPE,
      sum_loss_paid         gicl_lratio_loss_paid_ext.loss_paid%TYPE
   );
   
   TYPE loss_paid_details_tab IS TABLE OF loss_paid_details_type;
 
   FUNCTION get_loss_paid(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN loss_paid_details_tab PIPELINED;
   
   TYPE rec_details_type IS RECORD(
      peril_cd              gicl_lratio_curr_recovery_ext.peril_cd%TYPE,
      peril_name            giis_peril.peril_name%TYPE,
      assd_no               gicl_lratio_curr_recovery_ext.assd_no%TYPE,
      assd_name             giis_assured.assd_name%TYPE,
      rec_type_desc         giis_recovery_type.rec_type_desc%TYPE,
      sum_recovered_amt     gicl_lratio_curr_recovery_ext.recovered_amt%TYPE,
      dsp_loss_date         gicl_claims.dsp_loss_date%TYPE,
      recovery_no           VARCHAR2(50)
   );

   TYPE rec_details_tab IS TABLE OF rec_details_type;
   
   FUNCTION get_curr_rec(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN rec_details_tab PIPELINED;
   
   FUNCTION get_prev_rec(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN rec_details_tab PIPELINED;

END;
/


