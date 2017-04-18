CREATE OR REPLACE PACKAGE CPI.gicls277_pkg
AS
   TYPE gicls277_details_type IS RECORD (
      payee_class_cd    GICL_MC_TP_DTL.payee_class_cd%TYPE,
      payee_no          GICL_MC_TP_DTL.payee_no%TYPE,
      claim_id          GICL_MC_TP_DTL.claim_id%TYPE,
      tp_type           GICL_MC_TP_DTL.tp_type%TYPE,
      class_desc        GIIS_PAYEE_CLASS.class_desc%TYPE,
      payee_name        VARCHAR2(200),
      recovery_details  VARCHAR2(8),
      line_cd           GICL_CLAIMS.line_cd%TYPE,    
      subline_cd        GICL_CLAIMS.subline_cd%TYPE,
      iss_cd            GICL_CLAIMS.iss_cd%TYPE,
      clm_yy            VARCHAR2(8),
      clm_seq_no        VARCHAR2(10),
      pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE,
      issue_yy          VARCHAR2(8),
      pol_seq_no        VARCHAR2(12),
      renew_no          VARCHAR2(8),
      assured_name      GICL_CLAIMS.assured_name%TYPE,
      loss_date         VARCHAR2(50),
      claim_date        VARCHAR2(50),
      intm_no           GICL_CLAIMS.intm_no%TYPE,
      claim_number      VARCHAR2(100),
      policy_number     VARCHAR2(100),
      peril_cd          gicl_clm_loss_exp.peril_cd%TYPE,
      item_no           gicl_clm_loss_exp.item_no%TYPE,
      loss_cat_des      giis_loss_ctgry.loss_cat_des%TYPE,
      clm_stat_desc     giis_clm_stat.clm_stat_desc%TYPE
   );
   
   TYPE gicls277_details_tab IS TABLE OF gicls277_details_type;
   
   TYPE valid_third_party_type IS RECORD(
      payee_class_cd    GICL_MC_TP_DTL.payee_class_cd%TYPE,
      payee_no          GICL_MC_TP_DTL.payee_no%TYPE
   );
   
   TYPE valid_third_party_tab IS TABLE OF valid_third_party_type;

   FUNCTION populate_gicls277_main (
      P_USER_ID             VARCHAR2,
      P_PAYEE_CLASS_CD      VARCHAR2,
      P_PAYEE_NO            VARCHAR2,
      P_FROM_DATE           VARCHAR2,
      P_TO_DATE             VARCHAR2,
      P_AS_OF_DATE          VARCHAR2,
      P_SEARCH_BY           VARCHAR2,
      P_TP_TYPE             VARCHAR2
   )
      RETURN gicls277_details_tab PIPELINED;
      
   FUNCTION populate_gicls277_main2 (
      P_USER_ID             VARCHAR2,
      P_PAYEE_CLASS_CD      VARCHAR2,
      P_PAYEE_NO            VARCHAR2,
      P_FROM_DATE           VARCHAR2,
      P_TO_DATE             VARCHAR2,
      P_AS_OF_DATE          VARCHAR2,
      P_SEARCH_BY           VARCHAR2,
      P_TP_TYPE             VARCHAR2
   )
      RETURN gicls277_details_tab PIPELINED;
      
   FUNCTION fetch_valid_third_party(
      P_USER_ID          VARCHAR2
   )
      RETURN valid_third_party_tab PIPELINED;
      
   PROCEDURE validate_gicls277_name(
      p_payee_no         OUT VARCHAR2,
      p_payee_name       OUT VARCHAR2,
      p_search        IN     VARCHAR2,
      p_payee_class   IN     VARCHAR2
   );
END;
/


