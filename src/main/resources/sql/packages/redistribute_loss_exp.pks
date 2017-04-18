CREATE OR REPLACE PACKAGE CPI.REDISTRIBUTE_LOSS_EXP
/*Created by  :  Jess Sotingco 
**Date        : 01.26.2011 
**Description :1. This package will re-distribute loss_exp claim record.
*/
AS
--DIST_CLM_RECORDS
PROCEDURE DIST_CLM_RECORDS(P_CLAIM_ID           IN  GICL_CLM_LOSS_EXP.CLAIM_ID%TYPE,
                               P_CLM_LOSS_ID        IN  GICL_CLM_LOSS_EXP.CLM_LOSS_ID%TYPE,
                               P_DIST_RG            IN  GICL_CLM_LOSS_EXP.DIST_SW%TYPE,
                               P_ITEM_NO            IN  GICL_CLM_LOSS_EXP.ITEM_NO%TYPE,
                               P_PERIL_CD           IN  GICL_CLM_LOSS_EXP.PERIL_CD%TYPE,
                               P_GROUPED_ITEM_NO    IN  GICL_CLM_LOSS_EXP.GROUPED_ITEM_NO%TYPE,
                               P_LOSS_DATE          IN  GICL_CLAIMS.LOSS_DATE%TYPE,
                               P_POL_EFF_DATE       IN  GIPI_POLBASIC.EFF_DATE%TYPE,
                               P_EXPIRY_DATE        IN  GIPI_POLBASIC.EXPIRY_DATE%TYPE, 
                               P_LINE_CD            IN  GICL_CLAIMS.LINE_CD%TYPE, 
                               P_SUBLINE_CD         IN  GICL_CLAIMS.SUBLINE_CD%TYPE,
                               P_POL_ISS_CD         IN  GICL_CLAIMS.POL_ISS_CD%TYPE, 
                               P_ISSUE_YY           IN  GICL_CLAIMS.ISSUE_YY%TYPE,
                               P_POL_SEQ_NO         IN  GICL_CLAIMS.POL_SEQ_NO%TYPE, 
                               P_RENEW_NO           IN  GICL_CLAIMS.RENEW_NO%TYPE,
                               P_DISTRIBUTION_DATE  IN  GIIS_DIST_SHARE.EFF_DATE%TYPE, 
                               P_PAYEE_CD           IN  GICL_CLM_LOSS_EXP.PAYEE_CD%TYPE,
                               P_HIST_SEQ_NO        IN  GICL_CLM_LOSS_EXP.HIST_SEQ_NO%TYPE,
                               P_PAYEE_TYPE         IN  GICL_CLM_LOSS_EXP.PAYEE_TYPE%TYPE,
                               P_CATASTROPHIC_CD    IN  GICL_CLAIMS.CATASTROPHIC_CD%TYPE,
                               P_MESSAGE            OUT VARCHAR2);
--VALIDATE_EXISTING_DIST                  
PROCEDURE VALIDATE_EXISTING_DIST (P_LINE_CD            IN  GICL_CLAIMS.LINE_CD%TYPE, 
                                  P_SUBLINE_CD         IN  GICL_CLAIMS.SUBLINE_CD%TYPE,
                                  P_POL_ISS_CD         IN  GICL_CLAIMS.POL_ISS_CD%TYPE, 
                                  P_ISSUE_YY           IN  GICL_CLAIMS.ISSUE_YY%TYPE,
                                  P_POL_SEQ_NO         IN  GICL_CLAIMS.POL_SEQ_NO%TYPE, 
                                  P_RENEW_NO           IN  GICL_CLAIMS.RENEW_NO%TYPE,
                                  P_MESSAGE            OUT  VARCHAR2,
                                  P_ERROR              OUT  VARCHAR2);

--DISTRIBUTE_LOSS_EXP
PROCEDURE DISTRIBUTE_LOSS_EXP (P1_CLAIM_ID          IN  GICL_CLM_LOSS_EXP.CLAIM_ID%TYPE,
                                   P1_CLM_LOSS_ID       IN  GICL_CLM_LOSS_EXP.CLM_LOSS_ID%TYPE,
                                   P1_ITEM_NO           IN  GICL_CLM_LOSS_EXP.ITEM_NO%TYPE,
                                   P1_PERIL_CD          IN  GICL_CLM_LOSS_EXP.PERIL_CD%TYPE,
                                   P1_GROUPED_ITEM_NO   IN  GICL_CLM_LOSS_EXP.GROUPED_ITEM_NO%TYPE,
                                   P1_LOSS_DATE         IN  GICL_CLAIMS.LOSS_DATE%TYPE,
                                   P1_POL_EFF_DATE      IN  GIPI_POLBASIC.EFF_DATE%TYPE,
                                   P1_EXPIRY_DATE       IN  GIPI_POLBASIC.EXPIRY_DATE%TYPE, 
                                   P1_LINE_CD           IN  GICL_CLAIMS.LINE_CD%TYPE, 
                                   P1_SUBLINE_CD        IN  GICL_CLAIMS.SUBLINE_CD%TYPE,
                                   P1_POL_ISS_CD        IN  GICL_CLAIMS.POL_ISS_CD%TYPE, 
                                   P1_ISSUE_YY          IN  GICL_CLAIMS.ISSUE_YY%TYPE,
                                   P1_POL_SEQ_NO        IN  GICL_CLAIMS.POL_SEQ_NO%TYPE, 
                                   P1_RENEW_NO          IN  GICL_CLAIMS.RENEW_NO%TYPE,
                                   P1_DISTRIBUTION_DATE IN  GIIS_DIST_SHARE.EFF_DATE%TYPE, 
                                   P1_PAYEE_CD          IN  GICL_CLM_LOSS_EXP.PAYEE_CD%TYPE,
                                   V1_CLM_DIST_NO       IN  GICL_RESERVE_DS.CLM_DIST_NO%TYPE,
                                   P1_MESSAGE           OUT VARCHAR2);
--OFFSET_AMT
PROCEDURE OFFSET_AMT (P_CLM_DIST_NO IN  GICL_LOSS_EXP_DS.CLM_DIST_NO%TYPE,
                          P_CLAIM_ID    IN  GICL_LOSS_EXP_DS.CLAIM_ID%TYPE,
                          P_CLM_LOSS_ID IN  GICL_LOSS_EXP_DS.CLM_LOSS_ID%TYPE);

--DIST_BY_RESERVE_RISK_LOC
PROCEDURE DIST_BY_RESERVE_RISK_LOC (P2_CLAIM_ID          IN  GICL_CLM_LOSS_EXP.CLAIM_ID%TYPE,
                                        P2_CLM_LOSS_ID       IN  GICL_CLM_LOSS_EXP.CLM_LOSS_ID%TYPE,
                                        P2_ITEM_NO           IN  GICL_CLM_LOSS_EXP.ITEM_NO%TYPE,
                                        P2_PERIL_CD          IN  GICL_CLM_LOSS_EXP.PERIL_CD%TYPE,
                                        P2_GROUPED_ITEM_NO   IN  GICL_CLM_LOSS_EXP.GROUPED_ITEM_NO%TYPE,
                                        P2_LINE_CD           IN  GICL_CLAIMS.LINE_CD%TYPE, 
                                        P2_DISTRIBUTION_DATE IN  GIIS_DIST_SHARE.EFF_DATE%TYPE, 
                                        V2_CLM_DIST_NO       IN  GICL_RESERVE_DS.CLM_DIST_NO%TYPE,
                                        P2_PAYEE_CD          IN  GICL_CLM_LOSS_EXP.PAYEE_CD%TYPE,
                                        P2_POL_EFF_DATE      IN  GIPI_POLBASIC.EFF_DATE%TYPE,
                                        P2_EXPIRY_DATE       IN  GIPI_POLBASIC.EXPIRY_DATE%TYPE,
                                        P2_MESSAGE           OUT VARCHAR2);

--DISTRIBUTE_BY_RESERVE
PROCEDURE DISTRIBUTE_BY_RESERVE (P2_CLAIM_ID          IN  GICL_CLM_LOSS_EXP.CLAIM_ID%TYPE,
                                     P2_CLM_LOSS_ID       IN  GICL_CLM_LOSS_EXP.CLM_LOSS_ID%TYPE,
                                     P2_ITEM_NO           IN  GICL_CLM_LOSS_EXP.ITEM_NO%TYPE,
                                     P2_PERIL_CD          IN  GICL_CLM_LOSS_EXP.PERIL_CD%TYPE,
                                     P2_GROUPED_ITEM_NO   IN  GICL_CLM_LOSS_EXP.GROUPED_ITEM_NO%TYPE,
                                     P2_LOSS_DATE         IN  GICL_CLAIMS.LOSS_DATE%TYPE,
                                     P2_POL_EFF_DATE      IN  GIPI_POLBASIC.EFF_DATE%TYPE,
                                     P2_EXPIRY_DATE       IN  GIPI_POLBASIC.EXPIRY_DATE%TYPE, 
                                     P2_LINE_CD           IN  GICL_CLAIMS.LINE_CD%TYPE, 
                                     P2_SUBLINE_CD        IN  GICL_CLAIMS.SUBLINE_CD%TYPE,
                                     P2_POL_ISS_CD        IN  GICL_CLAIMS.POL_ISS_CD%TYPE, 
                                     P2_ISSUE_YY          IN  GICL_CLAIMS.ISSUE_YY%TYPE,
                                     P2_POL_SEQ_NO        IN  GICL_CLAIMS.POL_SEQ_NO%TYPE, 
                                     P2_RENEW_NO          IN  GICL_CLAIMS.RENEW_NO%TYPE,
                                     P2_DISTRIBUTION_DATE IN  GIIS_DIST_SHARE.EFF_DATE%TYPE, 
                                     P2_PAYEE_CD          IN  GICL_CLM_LOSS_EXP.PAYEE_CD%TYPE,
                                     V2_CLM_DIST_NO       IN  GICL_RESERVE_DS.CLM_DIST_NO%TYPE,
                                     P2_MESSAGE           OUT VARCHAR2);

--DISTRIBUTE_LOSS_EXP_XOL
PROCEDURE DISTRIBUTE_LOSS_EXP_XOL (P_CLAIM_ID           IN  GICL_CLM_RES_HIST.CLAIM_ID%TYPE,
                                   P_CLM_LOSS_ID        IN  GICL_CLM_LOSS_EXP.CLM_LOSS_ID%TYPE,
                                   P_HIST_SEQ_NO        IN  GICL_CLM_RES_HIST.HIST_SEQ_NO%TYPE, 
                                   P_LINE_CD            IN  GICL_CLAIMS.LINE_CD%TYPE,                          
                                   P_ITEM_NO            IN  GICL_CLM_RES_HIST.ITEM_NO%TYPE,
                                   P_PERIL_CD           IN  GICL_CLM_RES_HIST.PERIL_CD%TYPE,
                                   P_GROUPED_ITEM_NO    IN  GICL_CLM_RES_HIST.GROUPED_ITEM_NO%TYPE,
                                   P_CLM_DIST_NO        IN  GICL_LOSS_EXP_DS.CLM_DIST_NO%TYPE,
                                   P_LOSS_DATE          IN  GICL_CLAIMS.LOSS_DATE%TYPE,
                                   P_CATASTROPHIC_CD    IN  GICL_CLAIMS.CATASTROPHIC_CD%TYPE,
                                   P_PAYEE_CD           IN  GICL_CLM_LOSS_EXP.PAYEE_CD%TYPE);                                  

--CHK_XOL
PROCEDURE CHK_XOL (P_CLAIM_ID           IN  GICL_CLM_LOSS_EXP.CLAIM_ID%TYPE,
                   P_CLM_LOSS_ID        IN  GICL_CLM_LOSS_EXP.CLM_LOSS_ID%TYPE,
                   P_CATASTROPHIC_CD    IN  GICL_CLAIMS.CATASTROPHIC_CD%TYPE,
                   V_XOL_SHARE_TYPE    IN giac_parameters.param_value_v%TYPE,
                   V_EXISTS   IN OUT    VARCHAR2,
                   V_CURR_XOL IN OUT    VARCHAR2);

END REDISTRIBUTE_LOSS_EXP;
/


