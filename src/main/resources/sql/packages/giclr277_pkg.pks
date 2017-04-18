CREATE OR REPLACE PACKAGE CPI.giclr277_pkg
AS
   TYPE giclr277_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      cp_datetype       varchar2(100)
      
   );

   TYPE giclr277_tab IS TABLE OF giclr277_type;

   FUNCTION populate_giclr277(
   
      P_PAYEE_CLASS_CD   VARCHAR2,
      P_PAYEE_NO         NUMBER,
      P_TP_TYPE          VARCHAR2,
      P_FROM_DATE        VARCHAR2,
      P_TO_DATE          VARCHAR2,
      P_AS_OF_DATE       VARCHAR2,
      P_FROM_LDATE       VARCHAR2,
      P_TO_LDATE         VARCHAR2,
      P_AS_OF_LDATE      VARCHAR2
   )
   
   
      RETURN giclr277_tab PIPELINED;

   TYPE giclr277_details_type IS RECORD (
   
      v_peril_cd        VARCHAR2 (775),
      v_itemno          VARCHAR2(775),
      v_peril           giis_peril.peril_name%TYPE,
      v_item            VARCHAR2 (775),
      v_name            VARCHAR2 (775),
      claim_id          gicl_mc_tp_dtl.claim_id%TYPE,
      policy_no         varchar2(100),
      claim_no          varchar2(100),
      tp_type           varchar2(20), --gicl_mc_tp_dtl.tp_type%TYPE,
      assured_name      gicl_claims.assured_name%TYPE,
      dsp_loss_date     VARCHAR2(100),
      clm_file_date     VARCHAR2(100),
      item_no           gicl_clm_res_hist.item_no%TYPE,
      peril_cd          gicl_clm_res_hist.peril_cd%TYPE,
      loss_reserve       NUMBER(20,2),
      losses_paid        NUMBER(20,2),
      expense_reserve    NUMBER(20,2),
      expense_paid       NUMBER(20,2)
      
   );

   TYPE giclr277_details_tab IS TABLE OF giclr277_details_type;

   FUNCTION populate_giclr277_details(   
      P_PAYEE_CLASS_CD   VARCHAR2,
      P_PAYEE_NO         NUMBER,
      P_TP_TYPE          VARCHAR2,
      P_FROM_DATE        VARCHAR2,
      P_TO_DATE          VARCHAR2,
      P_AS_OF_DATE       VARCHAR2,
      P_FROM_LDATE       VARCHAR2,
      P_TO_LDATE         VARCHAR2,
      P_AS_OF_LDATE      VARCHAR2
   )
      RETURN giclr277_details_tab PIPELINED;
END giclr277_pkg;
/


