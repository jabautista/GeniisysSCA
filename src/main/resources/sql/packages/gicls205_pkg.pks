CREATE OR REPLACE PACKAGE CPI.GICLS205_PKG
   /*
   **  Created by        : bonok
   **  Date Created      : 08.22.2013
   **  Reference By      : GICLS205 - LOSS RATIO DETAILS
   **
   */
AS 
   TYPE gicl_loss_ratio_ext_type IS RECORD (
      loss_paid_amt         gicl_loss_ratio_ext.loss_paid_amt%TYPE,
      curr_prem_amt         gicl_loss_ratio_ext.curr_prem_amt%TYPE,
      prev_loss_res         gicl_loss_ratio_ext.prev_loss_res%TYPE,
      curr_loss_res         gicl_loss_ratio_ext.curr_loss_res%TYPE,
      curr_prem_res         gicl_loss_ratio_ext.curr_prem_res%TYPE,
      prev_prem_res         gicl_loss_ratio_ext.prev_prem_res%TYPE,
      premium_earned        gicl_loss_ratio_ext.curr_prem_amt%TYPE,
      losses_incurred       gicl_loss_ratio_ext.loss_paid_amt%TYPE,
      loss_ratio            NUMBER(16,4), --Dren Niebres 06.03.2016 SR-21428
      display               VARCHAR2(550),
      display_label         VARCHAR2(20)
   );
   
   TYPE gicl_loss_ratio_ext_tab IS TABLE OF gicl_loss_ratio_ext_type; 
   
   FUNCTION get_gicl_loss_ratio_ext(
      p_session_id          gicl_loss_ratio_ext.session_id%TYPE,
      p_prnt_option         VARCHAR2
   ) RETURN gicl_loss_ratio_ext_tab PIPELINED;
  
   TYPE lr_curr_prem_prl_type IS RECORD (
      policy_no             VARCHAR2(50),
      prem_amt              gicl_lratio_curr_prem_ext.prem_amt%TYPE,
      incept_date           VARCHAR2(50),
      expiry_date           VARCHAR2(50),
      tsi_amt               gipi_polbasic.tsi_amt%TYPE,
      nbt_date              VARCHAR2(50),
      nbt_assured           giis_assured.assd_name%TYPE,
      nbt_peril_name        giis_peril.peril_name%TYPE
   );
   
   TYPE lr_curr_prem_prl_tab IS TABLE OF lr_curr_prem_prl_type; 

   FUNCTION get_lr_curr_prem_prl(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN lr_curr_prem_prl_tab PIPELINED;
   
   TYPE lr_curr_prem_intm_type IS RECORD (
      policy_no             VARCHAR2(50),
      prem_amt              gicl_lratio_curr_prem_ext.prem_amt%TYPE,
      nbt_incept_date       VARCHAR2(50),
      nbt_expiry_date       VARCHAR2(50),
      nbt_tsi_amt           gipi_polbasic.tsi_amt%TYPE,
      nbt_date              VARCHAR2(50),
      nbt_assured           giis_assured.assd_name%TYPE,
      nbt_intm              giis_intermediary.intm_name%TYPE
   );
   
   TYPE lr_curr_prem_intm_tab IS TABLE OF lr_curr_prem_intm_type;
   
   FUNCTION get_lr_curr_prem_intm(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN lr_curr_prem_intm_tab PIPELINED;
   
   TYPE lr_curr_prem_type IS RECORD (
      policy_no             VARCHAR2(50),
      prem_amt              gicl_lratio_curr_prem_ext.prem_amt%TYPE,
      nbt_incept_date       VARCHAR2(50),
      nbt_expiry_date       VARCHAR2(50),
      nbt_tsi_amt           gipi_polbasic.tsi_amt%TYPE,
      nbt_date              VARCHAR2(50),
      nbt_assured           giis_assured.assd_name%TYPE
   );
   
   TYPE lr_curr_prem_tab IS TABLE OF lr_curr_prem_type;
   
   FUNCTION get_lr_curr_prem(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN lr_curr_prem_tab PIPELINED;
   
   FUNCTION get_lr_prev_prem_prl(
      p_session_id          gicl_lratio_prev_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN lr_curr_prem_prl_tab PIPELINED;
   
   FUNCTION get_lr_prev_prem_intm(
      p_session_id          gicl_lratio_prev_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN lr_curr_prem_intm_tab PIPELINED;
   
   FUNCTION get_lr_prev_prem(
      p_session_id          gicl_lratio_prev_prem_ext.session_id%TYPE,
      p_prnt_date           VARCHAR2
   ) RETURN lr_curr_prem_tab PIPELINED;
   
   TYPE lr_os_prl_type IS RECORD (
      nbt_claim_no          VARCHAR2(50),
      nbt_assured           giis_assured.assd_name%TYPE,
      nbt_peril_name        giis_peril.peril_name%TYPE,
      nbt_loss_date         VARCHAR2(50),
      nbt_file_date         VARCHAR2(50),
      os_amt                gicl_lratio_curr_os_ext.os_amt%TYPE
   );
   
   TYPE lr_os_prl_tab IS TABLE OF lr_os_prl_type;
   
   FUNCTION get_lr_curr_os_prl(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE
   ) RETURN lr_os_prl_tab PIPELINED;
   
   TYPE lr_os_intm_type IS RECORD (
      nbt_claim_no          VARCHAR2(50),
      nbt_assured           giis_assured.assd_name%TYPE,
      nbt_intm              giis_intermediary.intm_name%TYPE,
      nbt_loss_date         VARCHAR2(50),
      nbt_file_date         VARCHAR2(50),
      os_amt                gicl_lratio_curr_os_ext.os_amt%TYPE
   );
   
   TYPE lr_os_intm_tab IS TABLE OF lr_os_intm_type;
   
   FUNCTION get_lr_curr_os_intm(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE
   ) RETURN lr_os_intm_tab PIPELINED;
   
   TYPE lr_os_type IS RECORD (
      nbt_claim_no          VARCHAR2(50),
      nbt_assured           giis_assured.assd_name%TYPE,
      nbt_loss_date         VARCHAR2(50),
      nbt_file_date         VARCHAR2(50),
      os_amt                gicl_lratio_curr_os_ext.os_amt%TYPE
   );
   
   TYPE lr_os_tab IS TABLE OF lr_os_type;
   
   FUNCTION get_lr_curr_os(
      p_session_id          gicl_lratio_curr_prem_ext.session_id%TYPE
   ) RETURN lr_os_tab PIPELINED;
   
   FUNCTION get_lr_prev_os_prl(
      p_session_id          gicl_lratio_prev_prem_ext.session_id%TYPE
   ) RETURN lr_os_prl_tab PIPELINED;
   
   FUNCTION get_lr_prev_os_intm(
      p_session_id          gicl_lratio_prev_prem_ext.session_id%TYPE
   ) RETURN lr_os_intm_tab PIPELINED;
   
   FUNCTION get_lr_prev_os(
      p_session_id          gicl_lratio_prev_prem_ext.session_id%TYPE
   ) RETURN lr_os_tab PIPELINED;
   
   TYPE lr_loss_paid_prl_type IS RECORD (
      nbt_claim_no          VARCHAR2(50),
      nbt_assured           giis_assured.assd_name%TYPE,
      nbt_peril_name        giis_peril.peril_name%TYPE,
      nbt_loss_date         VARCHAR2(50),
      loss_paid             gicl_lratio_loss_paid_ext.loss_paid%TYPE
   );
   
   TYPE lr_loss_paid_prl_tab IS TABLE OF lr_loss_paid_prl_type;
   
   FUNCTION get_lr_loss_paid_prl(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN lr_loss_paid_prl_tab PIPELINED;
   
   TYPE lr_loss_paid_intm_type IS RECORD (
      nbt_claim_no          VARCHAR2(50),
      nbt_assured           giis_assured.assd_name%TYPE,
      nbt_intm              giis_intermediary.intm_name%TYPE,
      nbt_loss_date         VARCHAR2(50),
      loss_paid             gicl_lratio_loss_paid_ext.loss_paid%TYPE
   );
   
   TYPE lr_loss_paid_intm_tab IS TABLE OF lr_loss_paid_intm_type;
   
   FUNCTION get_lr_loss_paid_intm(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN lr_loss_paid_intm_tab PIPELINED;
   
   TYPE lr_loss_paid_type IS RECORD (
      nbt_claim_no          VARCHAR2(50),
      nbt_assured           giis_assured.assd_name%TYPE,
      nbt_loss_date         VARCHAR2(50),
      loss_paid             gicl_lratio_loss_paid_ext.loss_paid%TYPE
   );
   
   TYPE lr_loss_paid_tab IS TABLE OF lr_loss_paid_type;
   
   FUNCTION get_lr_loss_paid(
      p_session_id          gicl_lratio_loss_paid_ext.session_id%TYPE
   ) RETURN lr_loss_paid_tab PIPELINED;
   
   TYPE lr_rec_prl_type IS RECORD (
      nbt_rec_no            VARCHAR2(50),
      nbt_assured           giis_assured.assd_name%TYPE,
      nbt_peril_name        giis_peril.peril_name%TYPE,
      nbt_rec_type          giis_recovery_type.rec_type_desc%TYPE,
      nbt_date_recovered    VARCHAR2(50),
      recovered_amt         gicl_lratio_curr_recovery_ext.recovered_amt%TYPE
   );
   
   TYPE lr_rec_prl_tab IS TABLE OF lr_rec_prl_type;
   
   FUNCTION get_lr_curr_rec_prl(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN lr_rec_prl_tab PIPELINED;
   
   TYPE lr_rec_intm_type IS RECORD (
      nbt_rec_no            VARCHAR2(50),
      nbt_assured           giis_assured.assd_name%TYPE,
      nbt_intm              giis_intermediary.intm_name%TYPE,
      nbt_rec_type          giis_recovery_type.rec_type_desc%TYPE,
      nbt_date_recovered    VARCHAR2(50),
      recovered_amt         gicl_lratio_curr_recovery_ext.recovered_amt%TYPE
   );
   
   TYPE lr_rec_intm_tab IS TABLE OF lr_rec_intm_type;
   
   FUNCTION get_lr_curr_rec_intm(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN lr_rec_intm_tab PIPELINED;
   
   TYPE lr_rec_type IS RECORD (
      nbt_rec_no            VARCHAR2(50),
      nbt_assured           giis_assured.assd_name%TYPE,
      nbt_rec_type          giis_recovery_type.rec_type_desc%TYPE,
      nbt_date_recovered    VARCHAR2(50),
      recovered_amt         gicl_lratio_curr_recovery_ext.recovered_amt%TYPE
   );
   
   TYPE lr_rec_tab IS TABLE OF lr_rec_type;
   
   FUNCTION get_lr_curr_rec(
      p_session_id          gicl_lratio_curr_recovery_ext.session_id%TYPE
   ) RETURN lr_rec_tab PIPELINED;
   
   FUNCTION get_lr_prev_rec_prl(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN lr_rec_prl_tab PIPELINED;
   
   FUNCTION get_lr_prev_rec_intm(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN lr_rec_intm_tab PIPELINED;
  
   FUNCTION get_lr_prev_rec(
      p_session_id          gicl_lratio_prev_recovery_ext.session_id%TYPE
   ) RETURN lr_rec_tab PIPELINED;
   
END GICLS205_PKG;
/


