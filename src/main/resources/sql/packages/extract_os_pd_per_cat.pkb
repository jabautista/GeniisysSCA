CREATE OR REPLACE PACKAGE BODY CPI.EXTRACT_OS_PD_PER_CAT IS

  PROCEDURE EXTRACT_ALL(P_SESSION_ID      IN GICL_OS_PD_CLM_EXTR.SESSION_ID%TYPE,
     P_CATASTROPHIC_CD IN GICL_CLAIMS.CATASTROPHIC_CD%TYPE,
     P_LINE_CD         IN GICL_CLAIMS.LINE_CD%TYPE,
     P_ISS_CD          IN GICL_CLAIMS.ISS_CD%TYPE,
     P_LOSS_CAT_CD     IN GICL_CLAIMS.LOSS_CAT_CD%TYPE,
   P_LOCATION        IN GICL_OS_PD_CLM_EXTR.LOSS_LOC%TYPE,
     P_OS_DATE_OPT     IN NUMBER,
     P_PD_DATE_OPT     IN NUMBER,
     P_AS_OF_DATE      IN DATE) IS

    V_OS_LOSS     GICL_OS_PD_CLM_EXTR.OS_LOSS%TYPE;
    V_OS_EXP     GICL_OS_PD_CLM_EXTR.OS_EXP%TYPE;
    V_PD_LOSS     GICL_OS_PD_CLM_EXTR.PD_LOSS%TYPE;
    V_PD_EXP     GICL_OS_PD_CLM_EXTR.PD_EXP%TYPE;
    V_ASSURED_NAME      GICL_OS_PD_CLM_EXTR.ASSURED_NAME%TYPE;
    V_LOCATION       GICL_OS_PD_CLM_EXTR.LOSS_LOC%TYPE;
    V_LINE         GICL_CLAIMS.LINE_CD%TYPE;
    V_ISS_CD     GICL_CLAIMS.ISS_CD%TYPE;
 V_CAT_CD     GICL_CLAIMS.CATASTROPHIC_CD%TYPE;
    V_CNT         GICL_OS_PD_CLM_EXTR.CLM_CNT%TYPE;
    V_GROSS_LOSS          GICL_OS_PD_CLM_EXTR.GROSS_LOSS%TYPE;

    CURSOR CLAIMS IS
    SELECT A.CLAIM_ID,
           A.LINE_CD,
           A.ISS_CD,
           A.CATASTROPHIC_CD,
           A.LOSS_CAT_CD,
           A.LOSS_DATE,
    A.CLM_FILE_DATE,
           A.LINE_CD||'-'||A.SUBLINE_CD||'-'||A.ISS_CD||'-'||LTRIM(TO_CHAR(A.CLM_YY, '09'))||'-'||LTRIM(TO_CHAR(A.CLM_SEQ_NO, '0999999')) CLAIM_NO,
           A.LINE_CD||'-'||A.SUBLINE_CD||'-'||A.POL_ISS_CD||'-'||LTRIM(TO_CHAR(A.ISSUE_YY, '09'))
                    ||'-'||LTRIM(TO_CHAR(A.POL_SEQ_NO, '0999999'))||'-'||LTRIM(TO_CHAR(A.RENEW_NO, '09')) POLICY_NO,
           A.ASSD_NO,
           A.CLM_STAT_CD,
    A.PROVINCE_CD,
    A.CITY_CD,
           SUM(DECODE(B.DIST_SW, 'Y', NVL(B.CONVERT_RATE,1)*NVL(C.ANN_TSI_AMT,0),0)) ANN_TSI_AMT
      FROM GICL_CLAIMS A, GICL_CLM_RES_HIST B, GICL_ITEM_PERIL C
     WHERE A.CLAIM_ID = B.CLAIM_ID
       AND A.CLAIM_ID = C.CLAIM_ID
       AND B.CLAIM_ID = C.CLAIM_ID
       AND B.ITEM_NO = C.ITEM_NO
       AND B.PERIL_CD = C.PERIL_CD
       AND A.CATASTROPHIC_CD IS NOT NULL
       AND A.CATASTROPHIC_CD = NVL(P_CATASTROPHIC_CD, A.CATASTROPHIC_CD)
       AND A.LINE_CD = NVL(P_LINE_CD, A.LINE_CD)
       AND A.ISS_CD = NVL(P_ISS_CD, A.ISS_CD)
       AND A.LOSS_CAT_CD = NVL(P_LOSS_CAT_CD, A.LOSS_CAT_CD)
    AND A.PROVINCE_CD||'-'||A.CITY_CD = NVL(P_LOCATION, A.PROVINCE_CD||'-'||A.CITY_CD)
       AND A.CLM_STAT_CD NOT IN ('CC', 'WD', 'DN')
  GROUP BY A.CLAIM_ID,
           A.LINE_CD,
           A.ISS_CD,
           A.CATASTROPHIC_CD,
           A.LOSS_CAT_CD,
           A.LOSS_DATE,
    A.CLM_FILE_DATE,
           A.LINE_CD||'-'||A.SUBLINE_CD||'-'||A.ISS_CD||'-'||LTRIM(TO_CHAR(A.CLM_YY, '09'))||'-'||LTRIM(TO_CHAR(A.CLM_SEQ_NO, '0999999')),
           A.LINE_CD||'-'||A.SUBLINE_CD||'-'||A.POL_ISS_CD||'-'||LTRIM(TO_CHAR(A.ISSUE_YY, '09'))
                    ||'-'||LTRIM(TO_CHAR(A.POL_SEQ_NO, '0999999'))||'-'||LTRIM(TO_CHAR(A.RENEW_NO, '09')),
           A.ASSD_NO,
           A.CLM_STAT_CD,
    A.PROVINCE_CD,
    A.CITY_CD
  ORDER BY A.CATASTROPHIC_CD,
           A.ISS_CD,
     A.LINE_CD,
     A.LINE_CD||'-'||A.SUBLINE_CD||'-'||A.ISS_CD||'-'||LTRIM(TO_CHAR(A.CLM_YY, '09'))||'-'||LTRIM(TO_CHAR(A.CLM_SEQ_NO, '0999999'));

    CURSOR OS(P_CLAIM_ID      IN GICL_CLAIMS.CLAIM_ID%TYPE,
              P_LOSS_DATE     IN GICL_CLAIMS.DSP_LOSS_DATE%TYPE,
       P_CLM_FILE_DATE IN GICL_CLAIMS.CLM_FILE_DATE%TYPE) IS
       SELECT A.CLAIM_ID,
              SUM(DECODE(A.DIST_SW,'Y',NVL(A.CONVERT_RATE,1)*NVL(A.LOSS_RESERVE,0),0)) LOSS_RESERVE,
              SUM(DECODE(A.DIST_SW,NULL,NVL(A.CONVERT_RATE,1)*NVL(A.LOSSES_PAID,0),0)) LOSSES_PAID,
              SUM(DECODE(A.DIST_SW,'Y',NVL(A.CONVERT_RATE,1)*NVL(A.EXPENSE_RESERVE,0),0)) EXPENSE_RESERVE,
              SUM(DECODE(A.DIST_SW,NULL,NVL(A.CONVERT_RATE,1)*NVL(A.EXPENSES_PAID,0),0)) EXPENSES_PAID
         FROM GICL_CLM_RES_HIST A, GICL_ITEM_PERIL B
        WHERE A.CLAIM_ID = B.CLAIM_ID
          AND A.ITEM_NO  = B.ITEM_NO
          AND A.PERIL_CD = B.PERIL_CD
          AND A.CLAIM_ID = P_CLAIM_ID
          AND DECODE(P_OS_DATE_OPT, 1, TRUNC(P_LOSS_DATE), 2, TRUNC(P_CLM_FILE_DATE),
                              3, TO_DATE(NVL(A.BOOKING_MONTH,TO_CHAR(P_AS_OF_DATE,'FMMONTH'))||' 01, '||
                         NVL(TO_CHAR(A.BOOKING_YEAR,'0999'),TO_CHAR(P_AS_OF_DATE,'YYYY')),'FMMONTH DD, YYYY'))
     <= P_AS_OF_DATE
          AND TRUNC(NVL(A.DATE_PAID,P_AS_OF_DATE)) <= P_AS_OF_DATE
          AND DECODE(A.CANCEL_TAG,'Y',TRUNC(A.CANCEL_DATE),P_AS_OF_DATE + 1)
                        > P_AS_OF_DATE
          AND TRUNC(NVL(B.CLOSE_DATE2, P_AS_OF_DATE + 1)) > P_AS_OF_DATE
     GROUP BY A.CLAIM_ID
       HAVING (SUM(DECODE(A.DIST_SW,'Y',NVL(A.CONVERT_RATE,1)*NVL(A.EXPENSE_RESERVE,0),0))-
        SUM(DECODE(A.DIST_SW,NULL,NVL(A.CONVERT_RATE,1)*NVL(A.EXPENSES_PAID,0),0))) <> 0
     UNION
      SELECT A.CLAIM_ID,
             SUM(DECODE(A.DIST_SW,'Y',NVL(A.CONVERT_RATE,1)*NVL(A.LOSS_RESERVE,0),0)) LOSS_RESERVE,
             SUM(DECODE(A.DIST_SW,NULL,NVL(A.CONVERT_RATE,1)*NVL(A.LOSSES_PAID,0),0)) LOSSES_PAID,
             SUM(DECODE(A.DIST_SW,'Y',NVL(A.CONVERT_RATE,1)*NVL(A.EXPENSE_RESERVE,0),0)) EXPENSE_RESERVE,
             SUM(DECODE(A.DIST_SW,NULL,NVL(A.CONVERT_RATE,1)*NVL(A.EXPENSES_PAID,0),0)) EXPENSES_PAID
        FROM GICL_CLM_RES_HIST A, GICL_ITEM_PERIL B
       WHERE A.CLAIM_ID = B.CLAIM_ID
         AND A.ITEM_NO  = B.ITEM_NO
         AND A.PERIL_CD = B.PERIL_CD
         AND A.CLAIM_ID = P_CLAIM_ID
         AND DECODE(P_OS_DATE_OPT, 1, TRUNC(P_LOSS_DATE), 2, TRUNC(P_CLM_FILE_DATE),
                             3, TO_DATE(NVL(A.BOOKING_MONTH,TO_CHAR(P_AS_OF_DATE,'FMMONTH'))||' 01, '||
                        NVL(TO_CHAR(A.BOOKING_YEAR,'0999'),TO_CHAR(P_AS_OF_DATE,'YYYY')),'FMMONTH DD, YYYY'))
    <= P_AS_OF_DATE
         AND TRUNC(NVL(A.DATE_PAID,P_AS_OF_DATE)) <= P_AS_OF_DATE
         AND DECODE(A.CANCEL_TAG,'Y',TRUNC(A.CANCEL_DATE),P_AS_OF_DATE + 1)
                        > P_AS_OF_DATE
         AND TRUNC(NVL(B.CLOSE_DATE2, P_AS_OF_DATE + 1)) > P_AS_OF_DATE
    GROUP BY A.CLAIM_ID
      HAVING (SUM(DECODE(A.DIST_SW,'Y',NVL(A.CONVERT_RATE,1)*NVL(A.LOSS_RESERVE,0),0))-
       SUM(DECODE(A.DIST_SW,NULL,NVL(A.CONVERT_RATE,1)*NVL(A.LOSSES_PAID,0),0))) <> 0;

      CURSOR PD(P_CLAIM_ID GICL_CLAIMS.CLAIM_ID%TYPE) IS
      SELECT B.CLAIM_ID,
             NVL(SUM(NVL(A.LOSSES_PAID, 0) * NVL(A.CONVERT_RATE,1)), 0)  LOSSES_PAID,
             NVL(SUM(NVL(A.EXPENSES_PAID, 0) * NVL(A.CONVERT_RATE,1)), 0)  EXPENSES_PAID
        FROM GICL_ITEM_PERIL B, GICL_CLM_RES_HIST A, GIAC_ACCTRANS D
       WHERE A.PERIL_CD = B.PERIL_CD
         AND A.ITEM_NO = B.ITEM_NO
         AND A.CLAIM_ID = B.CLAIM_ID
         AND A.TRAN_ID = D.TRAN_ID
         AND B.CLAIM_ID = P_CLAIM_ID
         AND A.TRAN_ID IS NOT NULL
         AND DECODE(A.CANCEL_TAG,'Y',TRUNC(A.CANCEL_DATE),P_AS_OF_DATE + 1 ) > P_AS_OF_DATE
         AND DECODE(P_PD_DATE_OPT,1,TRUNC(A.DATE_PAID),2,TRUNC(D.POSTING_DATE)) <= P_AS_OF_DATE
         AND D.TRAN_FLAG != 'D'
         AND (NVL(A.LOSSES_PAID, 0) > 0 OR NVL(A.EXPENSES_PAID,0) > 0)
    GROUP BY B.CLAIM_ID
    UNION
      SELECT B.CLAIM_ID,
             SUM(NVL(A.LOSSES_PAID, 0) * NVL(A.CONVERT_RATE,1))  LOSSES_PAID,
             SUM(NVL(A.EXPENSES_PAID, 0) * NVL(A.CONVERT_RATE,1))  EXPENSES_PAID
        FROM GICL_ITEM_PERIL B, GICL_CLM_RES_HIST A, GIAC_ACCTRANS D, GIAC_REVERSALS E
       WHERE A.PERIL_CD = B.PERIL_CD
         AND A.ITEM_NO = B.ITEM_NO
         AND A.CLAIM_ID = B.CLAIM_ID
         AND A.TRAN_ID = E.GACC_TRAN_ID
         AND D.TRAN_ID = E.REVERSING_TRAN_ID
         AND B.CLAIM_ID = P_CLAIM_ID
         AND A.TRAN_ID IS NOT NULL
         AND TRUNC(A.DATE_PAID) < P_AS_OF_DATE
         AND TRUNC(D.POSTING_DATE) < P_AS_OF_DATE
    GROUP BY B.CLAIM_ID;
  BEGIN
    FOR CLAIMS_REC IN CLAIMS LOOP
        V_OS_LOSS := 0;
 V_OS_EXP := 0;
 V_PD_LOSS := 0;
 V_PD_EXP := 0;
    V_GROSS_LOSS := 0;
 V_LOCATION := NULL;
 V_OS_PD_REC_ID := V_OS_PD_REC_ID + 1;

 -- FOR LOCATION
 FOR I IN (SELECT PROVINCE_DESC
             FROM GIIS_PROVINCE
     WHERE PROVINCE_CD = CLAIMS_REC.PROVINCE_CD) LOOP
     V_LOCATION := I.PROVINCE_DESC;
 END LOOP;

 IF CLAIMS_REC.PROVINCE_CD IS NOT NULL AND CLAIMS_REC.CITY_CD IS NOT NULL THEN
    V_LOCATION := V_LOCATION||'-';
 END IF;

 FOR I IN (SELECT CITY
             FROM GIIS_CITY
            WHERE CITY_CD = CLAIMS_REC.CITY_CD) LOOP
     V_LOCATION := V_LOCATION||I.CITY;
 END LOOP;

 -- FOR NUMBER OF CLAIM PER LINE, BRANCH
 IF CLAIMS_REC.LINE_CD = V_LINE AND CLAIMS_REC.ISS_CD = V_ISS_CD AND CLAIMS_REC.CATASTROPHIC_CD = V_CAT_CD THEN
    V_CNT := V_CNT + 1;
 ELSE
    V_CNT := 1;
 END IF;

 V_LINE := CLAIMS_REC.LINE_CD;
 V_ISS_CD := CLAIMS_REC.ISS_CD;
 V_CAT_CD := CLAIMS_REC.CATASTROPHIC_CD;

 -- FOR ASSURED NAME
 FOR I IN (SELECT ASSD_NAME
             FROM GIIS_ASSURED
            WHERE ASSD_NO = CLAIMS_REC.ASSD_NO) LOOP
     V_ASSURED_NAME := I.ASSD_NAME;
 END LOOP;

 -- FOR OUTSTANDING LOSS AND EXPENSE
        FOR OS_REC IN OS(CLAIMS_REC.CLAIM_ID, CLAIMS_REC.LOSS_DATE, CLAIMS_REC.CLM_FILE_DATE) LOOP
     V_OS_LOSS := OS_REC.LOSS_RESERVE - OS_REC.LOSSES_PAID;
     V_OS_EXP  := OS_REC.EXPENSE_RESERVE - OS_REC.EXPENSES_PAID;
  IF V_OS_LOSS < 0 THEN
    V_OS_LOSS := 0;
  END IF;
  IF V_OS_LOSS < 0 THEN
    V_OS_LOSS := 0;
  END IF;
 END LOOP;

 -- FOR PAID LOSSES AND EXPENSES
 FOR PD_REC IN PD(CLAIMS_REC.CLAIM_ID) LOOP
     V_PD_LOSS := PD_REC.LOSSES_PAID;
     V_PD_EXP  := PD_REC.EXPENSES_PAID;
 END LOOP;

    -- FOR GROSS LOSS
    FOR I IN (SELECT SUM(DECODE(B.PAYEE_TYPE, 'L', A.SHR_LE_PD_AMT, 0) * NVL(B.CURRENCY_RATE, 1)) GROSS_LOSS
                FROM GICL_LOSS_EXP_DS A, GICL_CLM_LOSS_EXP B
               WHERE A.CLAIM_ID = B.CLAIM_ID
                 AND A.ITEM_NO = B.ITEM_NO
                 AND A.PERIL_CD = B.PERIL_CD
                 AND A.CLM_LOSS_ID = B.CLM_LOSS_ID
                 AND A.CLAIM_ID = CLAIMS_REC.CLAIM_ID
                 AND B.TRAN_ID IS NOT NULL
                 AND NVL(A.NEGATE_TAG, 'N') <> 'Y'
            GROUP BY A.CLAIM_ID)
    LOOP
      V_GROSS_LOSS := I.GROSS_LOSS;
    END LOOP;

 INSERT INTO GICL_OS_PD_CLM_EXTR(SESSION_ID,
                               OS_PD_REC_ID,
                                 CLM_CNT,
                                 CLAIM_ID,
                                 CLAIM_NO,
            ASSURED_NAME,
     LOSS_LOC,
     POLICY_NO,
     TSI_AMT,
     LOSS_CAT_CD,
     LOSS_DATE,
     CLM_STAT_CD,
     CATASTROPHIC_CD,
     OS_LOSS,
     OS_EXP,
     PD_LOSS,
     PD_EXP,
                    GROSS_LOSS,
     USER_ID,
     LAST_UPDATE,
     AS_OF_DATE,
      OS_DATE_OPT,
      PD_DATE_OPT,
      P_CAT_CD,
      P_LINE,
      P_ISS_CD,
      P_LOC,
      P_LOSS_CAT_CD,
     LINE_CD,
     ISS_CD)
     VALUES(P_SESSION_ID,
                        V_OS_PD_REC_ID,
                                 V_CNT,
                                 CLAIMS_REC.CLAIM_ID,
                                 CLAIMS_REC.CLAIM_NO,
     V_ASSURED_NAME,
     V_LOCATION,
     CLAIMS_REC.POLICY_NO,
     CLAIMS_REC.ANN_TSI_AMT,
     CLAIMS_REC.LOSS_CAT_CD,
     CLAIMS_REC.LOSS_DATE,
     CLAIMS_REC.CLM_STAT_CD,
     CLAIMS_REC.CATASTROPHIC_CD,
     V_OS_LOSS,
     V_OS_EXP,
     V_PD_LOSS,
     V_PD_EXP,
                    V_GROSS_LOSS,
     NVL (GIIS_USERS_PKG.APP_USER, USER), --modified by robert 03.03.15
     SYSDATE,
     P_AS_OF_DATE,
      P_OS_DATE_OPT,
      P_PD_DATE_OPT,
      P_CATASTROPHIC_CD,
      P_LINE_CD,
      P_ISS_CD,
      P_LOCATION,
      P_LOSS_CAT_CD,
     CLAIMS_REC.LINE_CD,
     CLAIMS_REC.ISS_CD);
    END LOOP;
    COMMIT;
  END EXTRACT_ALL;

  PROCEDURE EXTRACT_DISTRIBUTION(P_SESSION_ID IN GICL_OS_PD_CLM_EXTR.SESSION_ID%TYPE,
       P_DATE       IN DATE) IS
    V_OS_LOSS_DS GICL_OS_PD_CLM_DS_EXTR.OS_LOSS%TYPE;
    V_OS_EXP_DS  GICL_OS_PD_CLM_DS_EXTR.OS_EXP%TYPE;
    V_PD_LOSS_DS GICL_OS_PD_CLM_DS_EXTR.PD_LOSS%TYPE;
    V_PD_EXP_DS  GICL_OS_PD_CLM_DS_EXTR.PD_EXP%TYPE;
    V_OS_LOSS_RIDS GICL_OS_PD_CLM_RIDS_EXTR.OS_LOSS%TYPE;
    V_OS_EXP_RIDS GICL_OS_PD_CLM_RIDS_EXTR.OS_EXP%TYPE;
    V_PD_LOSS_RIDS GICL_OS_PD_CLM_RIDS_EXTR.PD_LOSS%TYPE;
    V_PD_EXP_RIDS GICL_OS_PD_CLM_RIDS_EXTR.PD_EXP%TYPE;
 V_SHR_PCT    GICL_OS_PD_CLM_RIDS_EXTR.SHR_RI_PCT%TYPE;

    CURSOR OS_DS(DS_SESSION_ID GICL_OS_PD_CLM_EXTR.SESSION_ID%TYPE) IS
   SELECT C.OS_PD_REC_ID,
     A.CLAIM_ID,
     C.OS_LOSS, -- Added by Marlo 05182010
     C.OS_EXP, -- Added by Marlo 05182010
     A.SHARE_TYPE,
   A.GRP_SEQ_NO,
               SUM(DECODE(B.DIST_SW,'Y',NVL(B.CONVERT_RATE, 1)*NVL(B.LOSS_RESERVE,0)*A.SHR_PCT/100,0)) LOSS_RESERVE,
               SUM(DECODE(B.DIST_SW,NULL,NVL(B.CONVERT_RATE, 1)*NVL(B.LOSSES_PAID,0)*A.SHR_PCT/100,0)) LOSSES_PAID,
   SUM(DECODE(B.DIST_SW,'Y',NVL(B.CONVERT_RATE, 1)*NVL(B.EXPENSE_RESERVE,0)*A.SHR_PCT/100,0)) EXPENSE_RESERVE,
               SUM(DECODE(B.DIST_SW,NULL,NVL(B.CONVERT_RATE, 1)*NVL(B.EXPENSES_PAID,0)*A.SHR_PCT/100,0)) EXPENSES_PAID
            FROM GICL_CLM_RES_HIST B, GICL_RESERVE_DS A, GICL_OS_PD_CLM_EXTR C
           WHERE A.CLAIM_ID = B.CLAIM_ID
             AND A.ITEM_NO = B.ITEM_NO
             AND A.PERIL_CD = B.PERIL_CD
             AND A.CLAIM_ID = C.CLAIM_ID
          AND C.SESSION_ID = DS_SESSION_ID
             AND NVL(A.NEGATE_TAG,'N') <> 'Y'
             AND TRUNC(NVL(DATE_PAID, P_DATE)) <= P_DATE
             AND DECODE(B.CANCEL_TAG,'Y',TRUNC(B.CANCEL_DATE),P_DATE + 1) > P_DATE
             AND EXISTS (SELECT 1
                           FROM GICL_ITEM_PERIL
                          WHERE CLAIM_ID = A.CLAIM_ID
                            AND ITEM_NO = A.ITEM_NO
                            AND PERIL_CD = A.PERIL_CD
                            AND TRUNC(NVL(CLOSE_DATE2, P_DATE + 1)) > P_DATE)
        GROUP BY C.OS_PD_REC_ID, A.CLAIM_ID, A.SHARE_TYPE, A.GRP_SEQ_NO, C.OS_EXP, C.OS_LOSS
 ORDER BY A.CLAIM_ID, A.GRP_SEQ_NO;

    CURSOR OS_RIDS(P_CLAIM_ID      GICL_CLM_RES_HIST.CLAIM_ID%TYPE,
                P_GRP_SEQ_NO      GICL_RESERVE_RIDS.GRP_SEQ_NO%TYPE,
                   P_LOSS_RESERVE    GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE,
                   P_LOSSES_PAID     GICL_CLM_RES_HIST.LOSSES_PAID%TYPE,
                   P_EXPENSE_RESERVE GICL_CLM_RES_HIST.EXPENSE_RESERVE%TYPE,
                   P_EXPENSES_PAID   GICL_CLM_RES_HIST.EXPENSES_PAID%TYPE) IS
  SELECT A.RI_CD, A.PRNT_RI_CD, A.SHR_RI_PCT_REAL,
                SUM(NVL(P_LOSS_RESERVE, 0)*A.SHR_RI_PCT_REAL/100) LOSS_RESERVE,
                SUM(NVL(P_LOSSES_PAID, 0)*A.SHR_RI_PCT_REAL/100) LOSSES_PAID,
  SUM(NVL(P_EXPENSE_RESERVE,0)*A.SHR_RI_PCT_REAL/100) EXPENSE_RESERVE,
                SUM(NVL(P_EXPENSES_PAID,0)*A.SHR_RI_PCT_REAL/100) EXPENSES_PAID
           FROM (SELECT DISTINCT CLAIM_ID, GRP_SEQ_NO, RI_CD, PRNT_RI_CD, SHR_RI_PCT_REAL FROM GICL_RESERVE_RIDS) A
          WHERE A.CLAIM_ID = P_CLAIM_ID
     AND A.GRP_SEQ_NO = P_GRP_SEQ_NO
       GROUP BY A.RI_CD, A.PRNT_RI_CD, A.SHR_RI_PCT_REAL;

    CURSOR PD_DS(DS_SESSION_ID  GICL_OS_PD_CLM_EXTR.SESSION_ID%TYPE) IS
         SELECT C.OS_PD_REC_ID,
    A.CLAIM_ID,
  A.SHARE_TYPE,
  A.GRP_SEQ_NO,
    SUM(DECODE(B.PAYEE_TYPE, 'L', A.SHR_LE_NET_AMT, 0) * NVL(B.CURRENCY_RATE, 1)) LOSSES_PAID,
  SUM(DECODE(B.PAYEE_TYPE, 'E', A.SHR_LE_NET_AMT, 0) * NVL(B.CURRENCY_RATE, 1)) EXPENSES_PAID
    FROM GICL_LOSS_EXP_DS A, GICL_CLM_LOSS_EXP B, GICL_OS_PD_CLM_EXTR C
   WHERE A.CLAIM_ID = B.CLAIM_ID
     AND A.ITEM_NO = B.ITEM_NO
     AND A.PERIL_CD = B.PERIL_CD
     AND A.CLM_LOSS_ID = B.CLM_LOSS_ID
     AND A.CLAIM_ID = C.CLAIM_ID
        AND B.TRAN_ID IS NOT NULL
     AND C.SESSION_ID = DS_SESSION_ID
     AND NVL(A.NEGATE_TAG, 'N') <> 'Y'
       GROUP BY C.OS_PD_REC_ID, A.CLAIM_ID, A.SHARE_TYPE, A.GRP_SEQ_NO
       ORDER BY A.CLAIM_ID, A.GRP_SEQ_NO;

     CURSOR PD_RIDS(P_CLAIM_ID     GICL_CLM_LOSS_EXP.CLAIM_ID%TYPE,
                    P_GRP_SEQ_NO   GICL_LOSS_EXP_RIDS.GRP_SEQ_NO%TYPE) IS
  SELECT A.CLAIM_ID,
  A.RI_CD,
  A.PRNT_RI_CD,
                --A.SHR_LOSS_EXP_RI_PCT/C.SHR_LOSS_EXP_PCT*100 SHR_LOSS_EXP_RI_PCT, comment out by Marlo 05172010
  SUM(DECODE(B.PAYEE_TYPE, 'L', A.SHR_LE_RI_NET_AMT, 0)* NVL(B.CURRENCY_RATE, 1)) LOSSES_PAID,
                SUM(DECODE(B.PAYEE_TYPE, 'E', A.SHR_LE_RI_NET_AMT, 0)* NVL(B.CURRENCY_RATE, 1)) EXPENSES_PAID
           FROM GICL_LOSS_EXP_RIDS A, GICL_CLM_LOSS_EXP B, GICL_LOSS_EXP_DS C
          WHERE A.CLAIM_ID = P_CLAIM_Id
            AND A.GRP_SEQ_NO = P_GRP_SEQ_NO
            AND A.CLAIM_ID = B.CLAIM_ID
            AND A.CLM_LOSS_ID = B.CLM_LOSS_ID
            AND A.CLAIM_ID = C.CLAIM_ID
            AND A.CLM_LOSS_ID = C.CLM_LOSS_ID
            AND A.GRP_SEQ_NO = C.GRP_SEQ_NO
            AND B.TRAN_ID IS NOT NULL
            AND NVL(C.NEGATE_TAG, 'N') <> 'Y' --Added by Marlo 05182010
            AND A.CLM_DIST_NO = C.CLM_DIST_NO --Added by Marlo 05182010
        GROUP BY A.CLAIM_ID, A.RI_CD, A.PRNT_RI_CD;--, A.SHR_LOSS_EXP_RI_PCT/C.SHR_LOSS_EXP_PCT*100; modified by Marlo 05172010
  BEGIN
    FOR OS_DS_REC IN OS_DS(P_SESSION_ID) LOOP
     /* Comment out by Marlo
     ** 05182010
     ** Change codes to not compute the distribution if the paid losses
     ** are greater than the loss reserve
     V_OS_LOSS_DS := OS_DS_REC.LOSS_RESERVE - OS_DS_REC.LOSSES_PAID;
     V_OS_EXP_DS := OS_DS_REC.EXPENSE_RESERVE - OS_DS_REC.EXPENSES_PAID;
     V_OS_PD_DS_REC_ID := V_OS_PD_DS_REC_ID + 1;
     IF V_OS_LOSS_DS < 0 THEN
        V_OS_LOSS_DS := 0;
     END IF;
     IF V_OS_EXP_DS < 0 THEN
        V_OS_EXP_DS := 0;
     END IF;*/

     -- Changed to:
     IF os_ds_rec.os_loss > 0 THEN
        V_OS_LOSS_DS := OS_DS_REC.LOSS_RESERVE - OS_DS_REC.LOSSES_PAID;
     ELSE
        V_OS_LOSS_DS := 0;
     END IF;
     IF os_ds_rec.os_exp > 0 THEN
        V_OS_EXP_DS := OS_DS_REC.EXPENSE_RESERVE - OS_DS_REC.EXPENSES_PAID;
     ELSE
        V_OS_EXP_DS := 0;
     END IF;
     V_OS_PD_DS_REC_ID := V_OS_PD_DS_REC_ID + 1;


 INSERT INTO GICL_OS_PD_CLM_DS_EXTR(SESSION_ID,
               OS_PD_REC_ID,
        OS_PD_DS_REC_ID,
        CLAIM_ID,
        SHARE_TYPE,
        GRP_SEQ_NO,
        OS_LOSS,
        OS_EXP,
        USER_ID,
        LAST_UPDATE)
          VALUES (P_SESSION_ID,
        OS_DS_REC.OS_PD_REC_ID,
        V_OS_PD_DS_REC_ID,
        OS_DS_REC.CLAIM_ID,
        OS_DS_REC.SHARE_TYPE,
        OS_DS_REC.GRP_SEQ_NO,
        V_OS_LOSS_DS,
        V_OS_EXP_DS,
        NVL (GIIS_USERS_PKG.APP_USER, USER), --modified by robert 03.03.15
        SYSDATE);

 FOR OS_RIDS_REC IN OS_RIDS(OS_DS_REC.CLAIM_ID,
                               OS_DS_REC.GRP_SEQ_NO,
                               OS_DS_REC.LOSS_RESERVE,
                               OS_DS_REC.LOSSES_PAID,
                               OS_DS_REC.EXPENSE_RESERVE,
                               OS_DS_REC.EXPENSES_PAID) LOOP

     V_OS_LOSS_RIDS := OS_RIDS_REC.LOSS_RESERVE - OS_RIDS_REC.LOSSES_PAID;
     V_OS_EXP_RIDS := OS_RIDS_REC.EXPENSE_RESERVE - OS_RIDS_REC.EXPENSES_PAID;
      V_OS_PD_RIDS_REC_ID := V_OS_PD_RIDS_REC_ID + 1;
        IF V_OS_LOSS_RIDS < 0 THEN
        V_OS_LOSS_RIDS := 0;
     END IF;
     IF V_OS_EXP_RIDS < 0 THEN
        V_OS_EXP_RIDS := 0;
     END IF;

     INSERT INTO GICL_OS_PD_CLM_RIDS_EXTR(SESSION_ID,
                 OS_PD_REC_ID,
       OS_PD_DS_REC_ID,
       OS_PD_RIDS_REC_ID,
       CLAIM_ID,
       GRP_SEQ_NO,
       RI_CD,
       PRNT_RI_CD,
       SHR_RI_PCT,
       OS_LOSS,
       OS_EXP,
       USER_ID,
       LAST_UPDATE)
              VALUES(P_SESSION_ID,
       OS_DS_REC.OS_PD_REC_ID,
       V_OS_PD_DS_REC_ID,
       V_OS_PD_RIDS_REC_ID,
       OS_DS_REC.CLAIM_ID,
       OS_DS_REC.GRP_SEQ_NO,
       OS_RIDS_REC.RI_CD,
       OS_RIDS_REC.PRNT_RI_CD,
       OS_RIDS_REC.SHR_RI_PCT_REAL,
       V_OS_LOSS_RIDS,
       V_OS_EXP_RIDS,
       NVL (GIIS_USERS_PKG.APP_USER, USER), --modified by robert 03.03.15
       SYSDATE);
 END LOOP;
    END LOOP;

    FOR PD_DS_REC IN PD_DS(P_SESSION_ID) LOOP
        V_PD_LOSS_DS := PD_DS_REC.LOSSES_PAID;
 V_PD_EXP_DS := PD_DS_REC.EXPENSES_PAID;
 V_OS_PD_DS_REC_ID := V_OS_PD_DS_REC_ID + 1;

 INSERT INTO GICL_OS_PD_CLM_DS_EXTR(SESSION_ID,
        OS_PD_REC_ID,
        OS_PD_DS_REC_ID,
               CLAIM_ID,
        SHARE_TYPE,
        GRP_SEQ_NO,
        PD_LOSS,
        PD_EXP,
           USER_ID,
        LAST_UPDATE)
         VALUES (P_SESSION_ID,
        PD_DS_REC.OS_PD_REC_ID,
        V_OS_PD_DS_REC_ID,
        PD_DS_REC.CLAIM_ID,
        PD_DS_REC.SHARE_TYPE,
        PD_DS_REC.GRP_SEQ_NO,
        V_PD_LOSS_DS,
        V_PD_EXP_DS,
        NVL (GIIS_USERS_PKG.APP_USER, USER), --modified by robert 03.03.15
        SYSDATE);

   FOR PD_RIDS_REC IN PD_RIDS(PD_DS_REC.CLAIM_ID, PD_DS_REC.GRP_SEQ_NO) LOOP

    /* Added by Marlo
 ** 05172010*/
 FOR i IN (SELECT a.TRTY_SHR_PCT
                FROM giis_trty_panel a
               WHERE a.RI_CD = pd_rids_rec.ri_cd
        AND a.TRTY_SEQ_NO = PD_DS_REC.GRP_SEQ_NO
     AND a.line_cd = (SELECT line_cd
                        FROM gicl_claims
           WHERE claim_id = PD_DS_REC.CLAIM_ID))
 LOOP
    v_shr_pct := i.trty_shr_pct;
 END LOOP;

     V_PD_LOSS_RIDS := PD_RIDS_REC.LOSSES_PAID;
     V_PD_EXP_RIDS := PD_RIDS_REC.EXPENSES_PAID;
     V_OS_PD_RIDS_REC_ID := V_OS_PD_RIDS_REC_ID + 1;

     INSERT INTO GICL_OS_PD_CLM_RIDS_EXTR(SESSION_ID,
              OS_PD_REC_ID,
       OS_PD_DS_REC_ID,
       OS_PD_RIDS_REC_ID,
       CLAIM_ID,
       GRP_SEQ_NO,
       RI_CD,
       PRNT_RI_CD,
       SHR_RI_PCT,
       PD_LOSS,
       PD_EXP,
       USER_ID,
       LAST_UPDATE)
       VALUES(P_SESSION_ID,
              PD_DS_REC.OS_PD_REC_ID,
              V_OS_PD_DS_REC_ID,
              V_OS_PD_RIDS_REC_ID,
       PD_RIDS_REC.CLAIM_ID,
       PD_DS_REC.GRP_SEQ_NO,
       PD_RIDS_REC.RI_CD,
       PD_RIDS_REC.PRNT_RI_CD,
       v_shr_pct, -- Modified by Marlo 05172010
       V_PD_LOSS_RIDS,
       V_PD_EXP_RIDS,
       NVL (GIIS_USERS_PKG.APP_USER, USER), --modified by robert 03.03.15
       SYSDATE);
     END LOOP;
    END LOOP;
    COMMIT;
  END EXTRACT_DISTRIBUTION;

  PROCEDURE RESET_RECORD_ID IS
  BEGIN
    V_OS_PD_REC_ID      := 0;
    V_OS_PD_DS_REC_ID   := 0;
    V_OS_PD_RIDS_REC_ID := 0;
  END RESET_RECORD_ID;

  PROCEDURE DELETE_DATA IS
  BEGIN
    DELETE FROM GICL_OS_PD_CLM_RIDS_EXTR WHERE USER_ID = NVL (GIIS_USERS_PKG.APP_USER, USER); --modified by robert 03.03.15
    DELETE FROM GICL_OS_PD_CLM_DS_EXTR WHERE USER_ID = NVL (GIIS_USERS_PKG.APP_USER, USER); --modified by robert 03.03.15
    DELETE FROM GICL_OS_PD_CLM_EXTR WHERE USER_ID = NVL (GIIS_USERS_PKG.APP_USER, USER); --modified by robert 03.03.15
    COMMIT;
END;
END;
/


