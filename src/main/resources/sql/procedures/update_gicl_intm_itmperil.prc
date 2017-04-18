DROP PROCEDURE CPI.UPDATE_GICL_INTM_ITMPERIL;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_GICL_INTM_ITMPERIL AS
  CURSOR POLICIES(POLICIES_CLAIM_ID     IN GICL_CLAIMS.CLAIM_ID%TYPE,
                  POLICIES_ITEM_NO      IN GICL_ITEM_PERIL.ITEM_NO%TYPE,
                  POLICIES_PERIL_CD     IN GICL_ITEM_PERIL.PERIL_CD%TYPE,
                  POLICIES_LOSS_DATE    IN GICL_CLM_ITEM.LOSS_DATE%TYPE) IS
    SELECT A.CLAIM_ID,
           B.POLICY_ID
      FROM GICL_CLAIMS A,GICL_CLM_POLBAS B,GIUW_POL_DIST C
     WHERE A.CLAIM_ID                  = B.CLAIM_ID
       AND B.POLICY_ID                 = C.POLICY_ID
       AND C.DIST_FLAG                 = '3'
       AND A.POL_ISS_CD               <> 'RI'
       AND TRUNC(B.EFF_DATE)          <= POLICIES_LOSS_DATE
       AND TRUNC(B.EXPIRY_DATE)       >= POLICIES_LOSS_DATE
       AND A.CLAIM_ID                  = POLICIES_CLAIM_ID
       AND EXISTS                     (SELECT 'X'
                                         FROM GIPI_ITMPERIL D
                                        WHERE D.POLICY_ID        = B.POLICY_ID
                                          AND D.PERIL_CD         = POLICIES_PERIL_CD
                                          AND D.ITEM_NO          = POLICIES_ITEM_NO)
     ORDER BY A.CLAIM_ID,B.POLICY_ID;
  CURSOR INVOICE(INVOICE_CLAIM_ID         IN GICL_CLAIMS.CLAIM_ID%TYPE,
                 INVOICE_POLICY_ID        IN GIPI_POLBASIC.POLICY_ID%TYPE,
                 INVOICE_ITEM_NO          IN GICL_ITEM_PERIL.ITEM_NO%TYPE,
                 INVOICE_PERIL_CD         IN GICL_ITEM_PERIL.PERIL_CD%TYPE) IS
    SELECT D.POLICY_ID,
           D.ISS_CD,
           D.PREM_SEQ_NO,
           NVL(SUM(B.PREM_AMT),0) PREM_AMT
      FROM GIPI_POLBASIC A,
           GIPI_ITMPERIL B,
           GIPI_ITEM C,
           GIPI_INVOICE D
     WHERE A.POLICY_ID        = C.POLICY_ID
       AND C.ITEM_NO          = B.ITEM_NO
       AND C.POLICY_ID        = B.POLICY_ID
       AND C.ITEM_GRP         = D.ITEM_GRP
       AND C.POLICY_ID        = D.POLICY_ID
       AND B.PERIL_CD         = INVOICE_PERIL_CD
       AND B.ITEM_NO          = INVOICE_ITEM_NO
       AND A.POLICY_ID        = INVOICE_POLICY_ID
     GROUP BY D.POLICY_ID,D.ITEM_GRP,D.ISS_CD,D.PREM_SEQ_NO;
  CURSOR INTERMEDIARY(INTERMEDIARY_POLICY_ID      IN GIPI_COMM_INVOICE.POLICY_ID%TYPE,
                      INTERMEDIARY_ISS_CD         IN GIPI_COMM_INVOICE.ISS_CD%TYPE,
                      INTERMEDIARY_PREM_SEQ_NO    IN GIPI_COMM_INVOICE.PREM_SEQ_NO%TYPE) IS
    SELECT A.INTRMDRY_INTM_NO,
           A.SHARE_PERCENTAGE
      FROM GIPI_COMM_INVOICE A
     WHERE A.PREM_SEQ_NO           = INTERMEDIARY_PREM_SEQ_NO
       AND A.ISS_CD                = INTERMEDIARY_ISS_CD
       AND A.POLICY_ID             = INTERMEDIARY_POLICY_ID;
  V_CLAIM_ID                  GICL_ITEM_PERIL.CLAIM_ID%TYPE;
  V_ITEM_NO                   GICL_ITEM_PERIL.ITEM_NO%TYPE;
  V_PERIL_CD                  GICL_ITEM_PERIL.PERIL_CD%TYPE;
  V_LOSS_DATE                 GICL_CLM_ITEM.LOSS_DATE%TYPE;
  V_TOT_PREM_AMT              GIPI_ITMPERIL.PREM_AMT%TYPE;
  V_INTM_SHR_PCT              GIPI_COMM_INVOICE.SHARE_PERCENTAGE%TYPE;
  V_INTM_NO                   GIIS_INTERMEDIARY.INTM_NO%TYPE;
  V_LOSSES_PAID               GICL_CLM_RES_HIST.LOSSES_PAID%TYPE;
  FUNCTION GET_PARENT_INTM(P_INTRMDRY_INTM_NO    IN GIIS_INTERMEDIARY.INTM_NO%TYPE)
                           RETURN NUMBER IS
    V_INTM_NO        GIIS_INTERMEDIARY.INTM_NO%TYPE;
  BEGIN
    BEGIN
       SELECT NVL(A.PARENT_INTM_NO,A.INTM_NO)
         INTO V_INTM_NO
         FROM GIIS_INTERMEDIARY A
        WHERE LEVEL = (SELECT MAX(LEVEL)
                         FROM GIIS_INTERMEDIARY B
                      CONNECT BY PRIOR B.PARENT_INTM_NO = B.INTM_NO
                          AND LIC_TAG                   = 'N'
                        START WITH B.INTM_NO            = P_INTRMDRY_INTM_NO
                          AND LIC_TAG                   = 'N')
      CONNECT BY PRIOR A.PARENT_INTM_NO                 = A.INTM_NO
        START WITH A.INTM_NO = P_INTRMDRY_INTM_NO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_INTM_NO  := P_INTRMDRY_INTM_NO;
      WHEN OTHERS THEN
        V_INTM_NO  := P_INTRMDRY_INTM_NO;
    END;
    RETURN V_INTM_NO;
  END GET_PARENT_INTM;
BEGIN
  BEGIN
    FOR I IN (SELECT CLAIM_ID, ITEM_NO, PERIL_CD
                FROM GICL_ITEM_PERIL) LOOP
    V_CLAIM_ID := I.CLAIM_ID;
    V_ITEM_NO := I.ITEM_NO;
    V_PERIL_CD := I.PERIL_CD;
    BEGIN
      SELECT LOSS_DATE
        INTO V_LOSS_DATE
        FROM GICL_CLAIMS
       WHERE CLAIM_ID       = V_CLAIM_ID;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    BEGIN
      SELECT NVL(SUM(B.PREM_AMT),0) TOT_PREM_AMT
        INTO V_TOT_PREM_AMT
        FROM GICL_CLM_POLBAS A,
             GIUW_POL_DIST D,
             GIPI_ITMPERIL B,
             GICL_CLAIMS C
       WHERE A.POLICY_ID           = B.POLICY_ID
         AND A.CLAIM_ID            = C.CLAIM_ID
         AND TRUNC(A.EFF_DATE)    <= V_LOSS_DATE
         AND TRUNC(A.EXPIRY_DATE) >= V_LOSS_DATE
         AND A.POLICY_ID           = D.POLICY_ID
         AND D.DIST_FLAG           = '3'
         AND B.PERIL_CD            = V_PERIL_CD
         AND B.ITEM_NO             = V_ITEM_NO
         AND C.CLAIM_ID            = V_CLAIM_ID;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    FOR POLICIES_REC IN POLICIES(V_CLAIM_ID,
                                 V_ITEM_NO,
                                 V_PERIL_CD,
                                 V_LOSS_DATE) LOOP
      FOR INVOICE_REC IN INVOICE(V_CLAIM_ID,
                                 POLICIES_REC.POLICY_ID,
                                 V_ITEM_NO,
                                 V_PERIL_CD) LOOP
        FOR INTERMEDIARY_REC IN INTERMEDIARY(INVOICE_REC.POLICY_ID,
                                             INVOICE_REC.ISS_CD,
                                             INVOICE_REC.PREM_SEQ_NO) LOOP
          V_INTM_NO    := GET_PARENT_INTM(INTERMEDIARY_REC.INTRMDRY_INTM_NO);
          BEGIN
            V_INTM_SHR_PCT  := NVL((INVOICE_REC.PREM_AMT*INTERMEDIARY_REC.SHARE_PERCENTAGE/
                               V_TOT_PREM_AMT), 0);
          EXCEPTION
            WHEN ZERO_DIVIDE THEN
              V_INTM_SHR_PCT  := 0;
          END;
          BEGIN
            UPDATE GICL_INTM_ITMPERIL
               SET SHR_INTM_PCT    = SHR_INTM_PCT + V_INTM_SHR_PCT,
                   PREMIUM_AMT     = PREMIUM_AMT + V_INTM_SHR_PCT*V_TOT_PREM_AMT/100
             WHERE INTM_NO         = INTERMEDIARY_REC.INTRMDRY_INTM_NO
               AND PERIL_CD        = V_PERIL_CD
               AND ITEM_NO         = V_ITEM_NO
               AND CLAIM_ID        = V_CLAIM_ID;
            IF SQL%NOTFOUND THEN
              INSERT INTO GICL_INTM_ITMPERIL
                            (CLAIM_ID,
                             ITEM_NO,
                             PERIL_CD,
                             INTM_NO,
                             PARENT_INTM_NO,
                             SHR_INTM_PCT,
                             PREMIUM_AMT)
                      VALUES(V_CLAIM_ID,
                             V_ITEM_NO,
                             V_PERIL_CD,
                             INTERMEDIARY_REC.INTRMDRY_INTM_NO,
                             V_INTM_NO,
                             V_INTM_SHR_PCT,
                             V_INTM_SHR_PCT*V_TOT_PREM_AMT/100);
            END IF;
          END;
        END LOOP;
      END LOOP;
    END LOOP;
    END LOOP;
  END;
COMMIT;
END;
/


