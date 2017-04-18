CREATE OR REPLACE PACKAGE CPI.REDISTRIBUTE_RESERVE
/*Created by  :  Jess Sotingco 
**Date        : 01.24.2011 
**Description :1. This package will re-distribute reserve claim record.
*/
AS
  --GET_BOOKING_DATE
  PROCEDURE GET_BOOKING_DATE(P_LOSS_DATE      IN  GICL_CLAIMS.LOSS_DATE%TYPE,
                             P_CLM_FILE_DATE  IN  GICL_CLAIMS.CLM_FILE_DATE%TYPE,
                             P_MONTH          OUT VARCHAR2,
                             P_YEAR           OUT NUMBER);
  
  --OFFSET_AMT
  PROCEDURE OFFSET_AMT (P_CLM_DIST_NO     IN  GICL_RESERVE_DS.CLM_DIST_NO%TYPE,
                        P_CLAIM_ID        IN  GICL_CLM_RES_HIST.CLAIM_ID%TYPE,
                        P_CLM_RES_HIST_ID IN  GICL_RESERVE_DS.CLM_RES_HIST_ID%TYPE);
    
  --DISTRIBUTE_RESERVE
  PROCEDURE DISTRIBUTE_RESERVE(P_CLAIM_ID            IN   GICL_CLM_RES_HIST.CLAIM_ID%TYPE,
                               P_HIST_SEQ_NO         IN   GICL_CLM_RES_HIST.HIST_SEQ_NO%TYPE, 
                               P_CLM_RES_HIST_ID     IN   GICL_CLM_RES_HIST.CLM_RES_HIST_ID%TYPE,
                               P_ITEM_NO             IN   GICL_CLM_RES_HIST.ITEM_NO%TYPE,
                               P_PERIL_CD            IN   GICL_CLM_RES_HIST.PERIL_CD%TYPE,
                               P_GROUPED_ITEM_NO     IN   GICL_CLM_RES_HIST.GROUPED_ITEM_NO%TYPE,
                               P_EFF_DATE            IN   GIPI_POLBASIC.EFF_DATE%TYPE,
                               P_EXPIRY_DATE         IN   GIPI_POLBASIC.EXPIRY_DATE%TYPE,
                               P_LOSS_DATE           IN   GICL_CLAIMS.LOSS_DATE%TYPE,
                               P_LINE_CD             IN   GIPI_POLBASIC.LINE_CD%TYPE,
                               P_SUBLINE_CD          IN   GIPI_POLBASIC.SUBLINE_CD%TYPE,
                               P_POL_ISS_CD          IN   GIPI_POLBASIC.ISS_CD%TYPE,
                               P_ISSUE_YY            IN   GIPI_POLBASIC.ISSUE_YY%TYPE,
                               P_POL_SEQ_NO          IN   GIPI_POLBASIC.POL_SEQ_NO%TYPE,
                               P_RENEW_NO            IN   GIPI_POLBASIC.RENEW_NO%TYPE,
                               P_CATASTROPHIC_CD     IN   GICL_CLAIMS.CATASTROPHIC_CD%TYPE,
                               P_DISTRIBUTION_DATE   IN   GICL_CLM_RES_HIST.DISTRIBUTION_DATE%TYPE,
                               P_MESSAGE             OUT  VARCHAR2);

  --PROCESS_DISTRIBUTION
  PROCEDURE PROCESS_DISTRIBUTION(P_CLM_RES_HIST_ID   IN   GICL_CLM_RES_HIST.CLM_RES_HIST_ID%TYPE,
                                 P_HIST_SEQ_NO       IN   GICL_CLM_RES_HIST.HIST_SEQ_NO%TYPE,
                                 P_CLAIM_ID          IN   GICL_CLM_RES_HIST.CLAIM_ID%TYPE,
                                 P_ITEM_NO           IN   GICL_CLM_RES_HIST.ITEM_NO%TYPE,
                                 P_PERIL_CD          IN   GICL_CLM_RES_HIST.PERIL_CD%TYPE,
                                 P_GROUPED_ITEM_NO   IN   GICL_CLM_RES_HIST.GROUPED_ITEM_NO%TYPE,
                                 P_DISTRIBUTION_DATE IN   GICL_CLM_RES_HIST.DISTRIBUTION_DATE%TYPE,
                                 P_CATASTROPHIC_CD   IN   GICL_CLAIMS.CATASTROPHIC_CD%TYPE,
                                 P_MESSAGE           OUT  VARCHAR2);
 
  --CREATE NEW RESERVE
  PROCEDURE CREATE_NEW_RESERVE(P_CLAIM_ID            IN   GICL_CLM_RES_HIST.CLAIM_ID%TYPE,
                               P_LOSS_DATE           IN   GICL_CLAIMS.LOSS_DATE%TYPE,
                               P_ITEM_NO             IN   GICL_CLM_RES_HIST.ITEM_NO%TYPE,
                               P_PERIL_CD            IN   GICL_CLM_RES_HIST.PERIL_CD%TYPE,
                               P_GROUPED_ITEM_NO     IN   GICL_CLM_RES_HIST.GROUPED_ITEM_NO%TYPE,
                               P_LOSS_RESERVE        IN   GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE,
                               P_EXPENSE_RESERVE     IN   GICL_CLM_RES_HIST.EXPENSE_RESERVE%TYPE,
                               P_CURRENCY_CD         IN   GICL_CLM_RES_HIST.CURRENCY_CD%TYPE,
                               P_CONVERT_RATE        IN   GICL_CLM_RES_HIST.CONVERT_RATE%TYPE,
                               P_DISTRIBUTION_DATE   IN   GICL_CLM_RES_HIST.DISTRIBUTION_DATE%TYPE,
                               P_CAT_CD              IN   GICL_CLAIMS.CATASTROPHIC_CD%TYPE,                                                
                               P_CLM_FILE_DATE       IN   GICL_CLAIMS.CLM_FILE_DATE%TYPE,
                               P_MESSAGE             OUT      VARCHAR2);
                                
  --UPDATE_CLM_DIST_TAG
  PROCEDURE UPDATE_CLM_DIST_TAG(P_CLAIM_ID   IN  GICL_CLM_RES_HIST.CLAIM_ID%TYPE);
  
  --DIST_CLM_RECORDS
  PROCEDURE DIST_CLM_RECORDS(P_CLAIM_ID            IN       GICL_CLAIMS.CLAIM_ID%TYPE,
                             P_LOSS_DATE           IN       GICL_CLAIMS.LOSS_DATE%TYPE,
                             P_ITEM_NO             IN       GICL_ITEM_PERIL.ITEM_NO%TYPE,
                             P_PERIL_CD            IN       GICL_ITEM_PERIL.PERIL_CD%TYPE,
                             P_GROUPED_ITEM_NO     IN       GICL_ITEM_PERIL.GROUPED_ITEM_NO%TYPE,
                             P_LOSS_RESERVE        IN       GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE,
                             P_EXPENSE_RESERVE     IN       GICL_CLM_RES_HIST.EXPENSE_RESERVE%TYPE,
                             P_CURRENCY_CD         IN       GICL_CLM_RES_HIST.CURRENCY_CD%TYPE,
                             P_CONVERT_RATE        IN       GICL_CLM_RES_HIST.CONVERT_RATE%TYPE,  
                             P_DISTRIBUTION_DATE   IN       GIIS_DIST_SHARE.EFF_DATE%TYPE,
                             P_CAT_CD              IN       GICL_CLAIMS.CATASTROPHIC_CD%TYPE,
                             P_CLM_FILE_DATE       IN       GICL_CLAIMS.CLM_FILE_DATE%TYPE,
                             P_MESSAGE             OUT      VARCHAR2);
END REDISTRIBUTE_RESERVE;
/


