CREATE OR REPLACE PACKAGE CPI.gicls267_pkg
AS
   TYPE clm_list_per_ceding_type IS RECORD (
      claim_no           VARCHAR2 (100),
      clm_stat_desc      giis_clm_stat.clm_stat_desc%TYPE,
      loss_res_amt       NUMBER (16, 2),
      exp_res_amt        NUMBER (16, 2),
      loss_pd_amt        NUMBER (16, 2),
      exp_pd_amt         NUMBER (16, 2),
      policy_number      VARCHAR2 (100),
      assured_name       VARCHAR2 (32767),
      loss_date          VARCHAR2 (100),
      clm_file_date      VARCHAR2 (100),
      tot_loss_res_amt   NUMBER (16, 2),
      tot_exp_res_amt    NUMBER (16, 2),
      tot_loss_pd_amt    NUMBER (16, 2),
      tot_exp_pd_amt     NUMBER (16, 2)
   );

   TYPE clm_list_per_ceding_tab IS TABLE OF clm_list_per_ceding_type;

   FUNCTION get_clm_list_per_ceding (
      p_ri_cd           gicl_claims.ri_cd%TYPE,
      p_user_id         giis_users.user_id%TYPE,
      p_claim_no        VARCHAR2,
      p_claim_status    VARCHAR2,
      p_loss_res_amt    NUMBER,
      p_exp_res_amt     NUMBER,
      p_loss_pd_amt     NUMBER,
      p_exp_pd_amt      NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN clm_list_per_ceding_tab PIPELINED;
END;
/


