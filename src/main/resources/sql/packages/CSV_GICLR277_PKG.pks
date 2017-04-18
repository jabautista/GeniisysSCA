CREATE OR REPLACE PACKAGE CPI.csv_giclr277_pkg
AS
 
   TYPE giclr277_details_type IS RECORD (
      
      type           VARCHAR2(20), --gicl_mc_tp_dtl.tp_type%TYPE,
      name           VARCHAR2 (775),
      claim_number   VARCHAR2(100),
      policy_number  VARCHAR2(100),
      assured        gicl_claims.assured_name%TYPE,
      loss_date      VARCHAR2(100),
      file_date      VARCHAR2(100),
      item_itemtitle VARCHAR2(100),
      peril          VARCHAR2(100),
      loss_reserve   VARCHAR2(30),
      loss_paid    VARCHAR2(30),
      expense_reserve VARCHAR2(30),
      expense_paid    VARCHAR2(30)
      
      
   );

   TYPE giclr277_details_tab IS TABLE OF giclr277_details_type;

   FUNCTION csv_giclr277(   
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
END csv_giclr277_pkg;
/
