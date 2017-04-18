CREATE OR REPLACE PACKAGE CPI.EXTRACT_PAID_LE_ENROLLEE AS

----------------------------EXTRACT BASIC INFORMATION--------------------------------

  PROCEDURE EXTRACT_ALL(P_SESSION_ID      IN GICL_RES_BRDRX_EXTR.SESSION_ID%TYPE,
                        P_BRDRX_REP_TYPE  IN GICL_RES_BRDRX_EXTR.BRDRX_REP_TYPE%TYPE,
           P_PD_DATE_OPT     IN GICL_RES_BRDRX_EXTR.PD_DATE_OPT%TYPE,
           P_FROM_DATE       IN GICL_RES_BRDRX_EXTR.FROM_DATE%TYPE,
           P_TO_DATE       IN GICL_RES_BRDRX_EXTR.TO_DATE%TYPE,
           P_ENROLLEE      IN GICL_ACCIDENT_DTL.GROUPED_ITEM_TITLE%TYPE,
      P_CONTROL_TYPE   IN GICL_ACCIDENT_DTL.CONTROL_TYPE_CD%TYPE,
      P_CONTROL_NUMBER  IN GICL_ACCIDENT_DTL.CONTROL_CD%TYPE);

---------------------------EXTRACT DISTRIBUTION--------------------------------------

  PROCEDURE EXTRACT_DISTRIBUTION(
           /*added date parameters by Edison 06.05.2012*/
           P_SESSION_ID           IN GICL_RES_BRDRX_DS_EXTR.SESSION_ID%TYPE,
           P_BRDRX_REP_TYPE  IN GICL_RES_BRDRX_EXTR.BRDRX_REP_TYPE%TYPE,
           p_from_date        IN   gicl_res_brdrx_extr.from_date%TYPE,
           p_to_date        IN   gicl_res_brdrx_extr.to_date%TYPE
           --end of added code 06.05.2012
           );

----------------------------GENERATE RECORD ID------------------------------------------

  PROCEDURE RESET_RECORD_ID;

-----------------------------------------------------------------------------------------

    V_BRDRX_RECORD_ID         GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%TYPE;
    V_BRDRX_DS_RECORD_ID      GICL_RES_BRDRX_DS_EXTR.BRDRX_DS_RECORD_ID%TYPE;
    V_BRDRX_RIDS_RECORD_ID    GICL_RES_BRDRX_RIDS_EXTR.BRDRX_RIDS_RECORD_ID%TYPE;

END EXTRACT_PAID_LE_ENROLLEE;
/


