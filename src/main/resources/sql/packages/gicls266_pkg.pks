CREATE OR REPLACE PACKAGE CPI.gicls266_pkg
AS
/*Modified by pjsantos 11/10/2016, for optimization GENQA 5835*/ 
   TYPE get_intermediary_lov_type IS RECORD (
      count_                   NUMBER,
      rownum_                  NUMBER,
      intm_no                  giis_intermediary.intm_no%TYPE,
      intm_name                giis_intermediary.intm_name%TYPE, 
      recovery_details_count   NUMBER (10) 
   );

   TYPE get_intermediary_lov_tab IS TABLE OF get_intermediary_lov_type;

   FUNCTION get_intermediary_lov_list (p_user_id            VARCHAR2,
                                       p_search_string      VARCHAR2,
                                       p_find_text          VARCHAR2,
                                       p_intm_no            VARCHAR2,
                                       p_intm_name          VARCHAR2,
                                       p_order_by           VARCHAR2,       
                                       p_asc_desc_flag      VARCHAR2,      
                                       p_first_row          NUMBER,        
                                       p_last_row           NUMBER)
      RETURN get_intermediary_lov_tab PIPELINED;

   TYPE clm_list_per_intermediary_type IS RECORD (
      claim_id             gicl_intm_itmperil.claim_id%TYPE,
      peril_cd             gicl_intm_itmperil.peril_cd%TYPE,
      item_no              gicl_intm_itmperil.item_no%TYPE,
      line_cd              gicl_claims.line_cd%TYPE,
      claim_no             VARCHAR2 (50),
      policy_no            VARCHAR2 (50),
      assured_name         gicl_claims.assured_name%TYPE,
      loss_date            DATE,
      clm_file_date        DATE,
      entry_date           VARCHAR2 (100),
      recovery_sw          VARCHAR2 (10),
      recovery_det_count   NUMBER (10),
      claim_det_count      NUMBER (10),
      loss_cat_desc        VARCHAR (100),
      clm_stat_desc        VARCHAR (100)
   );

   TYPE clm_list_per_intermediary_tab IS TABLE OF clm_list_per_intermediary_type;

   FUNCTION get_clm_list_per_intermediary (
      p_user_id         VARCHAR2,
      p_intm_no         giis_intermediary.intm_no%TYPE,
      p_recovery_sw     VARCHAR2,
      p_claim_no        VARCHAR2,
      p_policy_no       VARCHAR2,
      p_assured_name    VARCHAR2,
      p_clm_file_date   VARCHAR2,
      p_loss_date       VARCHAR2,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN clm_list_per_intermediary_tab PIPELINED;

   TYPE claim_details_type IS RECORD (
      item_no               VARCHAR2 (10),
      item_title            gicl_clm_item.item_title%TYPE,
      peril_cd              gicl_clm_reserve.peril_cd%TYPE,
      peril_name            giis_peril.peril_name%TYPE,
      shr_intm_pct          gicl_intm_itmperil.shr_intm_pct%TYPE,
      loss_reserve          NUMBER (16, 2),
      expense_reserve       NUMBER (16, 2),
      losses_paid           NUMBER (16, 2),
      expenses_paid         NUMBER (16, 2),
      tot_loss_reserve      NUMBER (16, 2),
      tot_expense_reserve   NUMBER (16, 2),
      tot_losses_paid       NUMBER (16, 2),
      tot_expenses_paid     NUMBER (16, 2)
   );

   TYPE claim_details_tab IS TABLE OF claim_details_type;

   FUNCTION get_claim_details (
      p_claim_id   NUMBER,
      p_peril_cd   VARCHAR2,
      p_item_no    NUMBER,
      p_line_cd    VARCHAR2
   )
      RETURN claim_details_tab PIPELINED;
END;
/


