CREATE OR REPLACE PACKAGE CPI.gicls271_pkg
AS
 /*Modified by pjsantos 11/20/2016 for optimization, GENQA 5834*/
   TYPE in_hou_adj_type IS RECORD (
      count_               NUMBER,
      rownum_              NUMBER,
      in_hou_adj           GICL_CLAIMS.IN_HOU_ADJ%TYPE   
   );

   TYPE in_hou_adj_tab IS TABLE OF in_hou_adj_type;
  
   FUNCTION get_in_hou_adj_list(
      p_user_id             VARCHAR2,      
      p_find_text           VARCHAR2,
      p_search_string       VARCHAR2,                                        
      p_order_by            VARCHAR2,       
      p_asc_desc_flag       VARCHAR2,      
      p_first_row           NUMBER,        
      p_last_row            NUMBER
   )
      RETURN in_hou_adj_tab PIPELINED;
/*Modified by pjsantos 11/20/2016 for optimization, GENQA 5834*/
   TYPE clm_list_per_user_type IS RECORD (
      count_               NUMBER,
      rownum_              NUMBER,
      claim_id             gicl_claims.claim_id%TYPE,
      recovery_sw          gicl_claims.recovery_sw%TYPE,
      claim_no             VARCHAR2 (100),
      clm_stat_desc        giis_clm_stat.clm_stat_desc%TYPE,
      loss_res_amt         gicl_claims.loss_res_amt%TYPE,
      entry_date           gicl_claims.entry_date%TYPE, 
      exp_res_amt          gicl_claims.exp_res_amt%TYPE,
      loss_pd_amt          gicl_claims.loss_pd_amt%TYPE,
      exp_pd_amt           gicl_claims.exp_pd_amt%TYPE,
      policy_no            VARCHAR (100),
      assured_name         gicl_claims.assured_name%TYPE,
      loss_date            gicl_claims.loss_date%TYPE,
      clm_file_date        gicl_claims.clm_file_date%TYPE,
      tot_loss_res         gicl_claims.loss_res_amt%TYPE,
      tot_exp_res          gicl_claims.exp_res_amt%TYPE,
      tot_loss_pd          gicl_claims.loss_pd_amt%TYPE,
      tot_exp_pd           gicl_claims.exp_pd_amt%TYPE,
      recovery_det_count   NUMBER (10)
   );

   TYPE clm_list_per_user_tab IS TABLE OF clm_list_per_user_type;
   FUNCTION get_clm_list_per_user (
      p_user_id         giis_users.user_id%TYPE,
      p_in_hou_adj      gicl_claims.in_hou_adj%TYPE,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_to         VARCHAR2,
      p_date_from       VARCHAR2,
      p_recovery_sw     VARCHAR2,
      p_claim_number    VARCHAR2,
      p_claim_status    VARCHAR2,
      p_loss_reserve    gicl_claims.loss_res_amt%TYPE,
      p_expense_reserve gicl_claims.exp_res_amt%TYPE,
      p_losses_paid     gicl_claims.loss_pd_amt%TYPE,
      p_expenses_paid   gicl_claims.exp_pd_amt%TYPE,
      p_order_by        VARCHAR2,       
      p_asc_desc_flag   VARCHAR2,      
      p_first_row       NUMBER,        
      p_last_row        NUMBER
   )
      RETURN clm_list_per_user_tab PIPELINED;

   TYPE processor_history_type IS RECORD (
      in_hou_adj    gicl_processor_hist.in_hou_adj%TYPE,
      user_id       gicl_processor_hist.user_id%TYPE,
      last_update   VARCHAR (100)
   );

   TYPE processor_history_tab IS TABLE OF processor_history_type;

   FUNCTION get_processor_history (
      p_claim_id   gicl_processor_hist.claim_id%TYPE
   )
      RETURN processor_history_tab PIPELINED;

   TYPE clm_stat_hist_type IS RECORD (
      clm_stat_cd     gicl_clm_stat_hist.clm_stat_cd%TYPE,
      clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE,
      user_id         gicl_clm_stat_hist.user_id%TYPE,
      clm_stat_dt     VARCHAR2 (100)
   );

   TYPE clm_stat_hist_tab IS TABLE OF clm_stat_hist_type;

   FUNCTION get_claim_status_history (
      p_claim_id   gicl_clm_stat_hist.claim_id%TYPE
   )
      RETURN clm_stat_hist_tab PIPELINED;
END;
/


