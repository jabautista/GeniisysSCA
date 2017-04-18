CREATE OR REPLACE PACKAGE CPI.gicls251_pkg
AS
   TYPE assured_lov_type IS RECORD (
      count_                NUMBER,-- added By MarkS 11.10.2016 SR5836 optimization
      rownum_               NUMBER,-- added By MarkS 11.10.2016 SR5836 optimization
      assd_no                  gicl_claims.assd_no%TYPE,
      assd_name                giis_assured.assd_name%TYPE,
      recovery_details_count   NUMBER (10)
   );

   TYPE assured_lov_tab IS TABLE OF assured_lov_type;

   FUNCTION get_assured_lov (p_user_id VARCHAR2,
                             p_module_id VARCHAR2,
                             p_find_text            VARCHAR2,
                             p_order_by             VARCHAR2,
                             p_asc_desc_flag   VARCHAR2,
                             p_from                 NUMBER,
                             p_to                   NUMBER,
                             p_search_string         VARCHAR2
                             ) -- added By MarkS 11.10.2016 SR5836 optimization
      RETURN assured_lov_tab PIPELINED;

   TYPE clm_list_per_assured_type IS RECORD (
      claim_id             gicl_claims.claim_id%TYPE,
      claim_number         VARCHAR2 (50),
      assd_no              gicl_claims.assd_no%TYPE,
      free_text            VARCHAR2 (32767),
      assured_name         gicl_claims.assured_name%TYPE,
      loss_res_amt         gicl_claims.loss_res_amt%TYPE,
      exp_res_amt          gicl_claims.exp_res_amt%TYPE,
      loss_pd_amt          gicl_claims.loss_pd_amt%TYPE,
      exp_pd_amt           gicl_claims.exp_pd_amt%TYPE,
      recovery_sw          gicl_claims.recovery_sw%TYPE,
      policy_number        VARCHAR2 (50),
      clm_stat_desc        giis_clm_stat.clm_stat_desc%TYPE,
      clm_file_date        gicl_claims.clm_file_date%TYPE,
      dsp_loss_date        gicl_claims.dsp_loss_date%TYPE,
      tot_loss_res_amt     gicl_claims.loss_res_amt%TYPE,
      tot_loss_paid_amt    gicl_claims.loss_pd_amt%TYPE,
      tot_exp_res_amt      gicl_claims.exp_res_amt%TYPE,
      tot_exp_paid_amt     gicl_claims.exp_pd_amt%TYPE,
      recovery_det_count   NUMBER (10)
   );

   TYPE clm_list_per_assured_tab IS TABLE OF clm_list_per_assured_type;

   FUNCTION get_clm_list_per_assured (
      p_module_id       VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_assd_no         gicl_claims.assd_no%TYPE,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_to         VARCHAR2,
      p_date_from       VARCHAR2,
      p_recovery_sw     VARCHAR2,
      p_claim_number    VARCHAR2,
      p_free_text       VARCHAR2,
      p_loss_res_amt    NUMBER,
      p_exp_res_amt     NUMBER,
      p_loss_pd_amt     NUMBER,
      p_exp_pd_amt      NUMBER
   )
      RETURN clm_list_per_assured_tab PIPELINED;

   FUNCTION get_per_assured_freetext (
      p_module_id       VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_free_text       VARCHAR2,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_to         VARCHAR2,
      p_date_from       VARCHAR2,
      p_recovery_sw     VARCHAR2,
      p_claim_number    VARCHAR2,
      p_loss_res_amt    NUMBER,
      p_exp_res_amt     NUMBER,
      p_loss_pd_amt     NUMBER,
      p_exp_pd_amt      NUMBER
   )
      RETURN clm_list_per_assured_tab PIPELINED;

   TYPE recovery_details_type IS RECORD (
      recovery_id       gicl_clm_recovery.recovery_id%TYPE,
      recovery_no       VARCHAR2 (50),
      recoverable_amt   gicl_clm_recovery.recoverable_amt%TYPE,
      recovered_amt     gicl_clm_recovery.recovered_amt%TYPE,
      lawyer            VARCHAR2 (255),
      plate_no          gicl_clm_recovery.plate_no%TYPE,
      status            VARCHAR2 (50),
      tp_item_desc      gicl_clm_recovery.tp_item_desc%TYPE
   );

   TYPE recovery_details_tab IS TABLE OF recovery_details_type;

   FUNCTION get_recovery_details (p_claim_id gicl_clm_recovery.claim_id%TYPE)
      RETURN recovery_details_tab PIPELINED;

   TYPE payor_details_type IS RECORD (
      class_desc      giis_payee_class.class_desc%TYPE,
      payor           VARCHAR2 (600), -- changed by robert from VARCHAR2 (255), 10.02.2013 
      recovered_amt   gicl_recovery_payor.recovered_amt%TYPE
   );

   TYPE payor_details_tab IS TABLE OF payor_details_type;

   FUNCTION get_payor_details (
      p_claim_id      gicl_recovery_payor.claim_id%TYPE,
      p_recovery_id   gicl_recovery_payor.recovery_id%TYPE
   )
      RETURN payor_details_tab PIPELINED;

   TYPE history_type IS RECORD (
      rec_hist_no     gicl_rec_hist.rec_hist_no%TYPE,
      rec_stat_cd     gicl_rec_hist.rec_stat_cd%TYPE,
      rec_stat_desc   VARCHAR2 (255),
      remarks         gicl_rec_hist.remarks%TYPE,
      user_id         gicl_rec_hist.user_id%TYPE,
      last_update     VARCHAR2 (255)
   );

   TYPE history_tab IS TABLE OF history_type;

   FUNCTION get_history (p_recovery_id gicl_rec_hist.recovery_id%TYPE)
      RETURN history_tab PIPELINED;
END;
/
