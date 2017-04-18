CREATE OR REPLACE PACKAGE CPI.GICLS257_PKG AS
   TYPE clm_list_per_adjuster_type IS RECORD (
      --ADDED by MarkS 11.11.2016 SR5837 optimization
      count_                NUMBER,
      rownum_               NUMBER,
      --END 
      claim_id         GICL_CLM_ADJUSTER.claim_id%TYPE,
      clm_adj_id       GICL_CLM_ADJUSTER.clm_adj_id%TYPE,
      adj_company_cd   GICL_CLM_ADJUSTER.adj_company_cd%TYPE,
      payee_name       GIIS_ADJUSTER.payee_name%TYPE,
      assign_date      GICL_CLM_ADJUSTER.assign_date%TYPE,
      complt_date      GICL_CLM_ADJUSTER.complt_date%TYPE,
      cancel_tag       GICL_CLM_ADJUSTER.cancel_tag%TYPE,
      claim_number     VARCHAR2 (50),
      assured_name     GICL_CLAIMS.assured_name%TYPE,
      policy_number    VARCHAR2 (50),
      loss_date        GICL_CLAIMS.loss_date%TYPE,
      claim_status     GIIS_CLM_STAT.clm_stat_desc%TYPE,
      file_date        GICL_CLAIMS.clm_file_date%TYPE,
      loss_desc        GIIS_LOSS_CTGRY.loss_cat_des%TYPE,
      cancel_date      GICL_CLM_ADJ_HIST.cancel_date%TYPE,
      dpo              VARCHAR2 (10),
      paid_amt         VARCHAR2 (50),
      tot_paid_amt     VARCHAR2 (50)
   );

   TYPE clm_list_per_adjuster_tab IS TABLE OF clm_list_per_adjuster_type;
      
   FUNCTION get_clm_list_per_adjuster (
      p_user_id     GIIS_USERS.user_id%TYPE,
      p_payee_no    GIIS_PAYEES.payee_no%TYPE,
      p_searchby    VARCHAR2,
      p_date_as_of  VARCHAR2,
      p_date_from   VARCHAR2,
      p_date_to     VARCHAR2,
      p_status      VARCHAR2,
      --ADDED by MarkS 11.11.2016 SR5837 optimization
      p_order_by            VARCHAR2,
      p_asc_desc_flag       VARCHAR2,
      p_from                NUMBER,
      p_to                  NUMBER,
      p_payee_name          VARCHAR2,
      p_assign_date         VARCHAR2,
      p_complete_date       VARCHAR2,
      p_cancel_date         VARCHAR2,
      p_dpo                 NUMBER,
      p_paid_amount         NUMBER
      --END
   )
      RETURN clm_list_per_adjuster_tab PIPELINED;
    
    FUNCTION validate_payee_per_adj(p_payee GIIS_ADJUSTER.payee_name%TYPE)
      RETURN VARCHAR2;        
END;
/
