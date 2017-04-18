DROP PROCEDURE CPI.AUTO_POP_INSTALLMENT;

CREATE OR REPLACE PROCEDURE CPI.AUTO_POP_INSTALLMENT
  (P_POLICY_ID           GIPI_POLBASIC.POLICY_ID%TYPE,
   P_ISS_CD              GIPI_INVOICE.ISS_CD%TYPE,
   P_PREM_SEQ_NO         GIPI_INVOICE.PREM_SEQ_NO%TYPE,
   P_LINE_CD             GIPI_POLBASIC.LINE_CD%TYPE,
   P_EXPIRY_DATE         GIPI_POLBASIC.EXPIRY_DATE%TYPE,
   P_INCEPT_DATE         GIPI_POLBASIC.INCEPT_DATE%TYPE )
IS
  V_TAX_AMT1        GIPI_INSTALLMENT.TAX_AMT%TYPE;
  V_TAX_AMT2        GIPI_INSTALLMENT.TAX_AMT%TYPE;
  V_TAX_AMT3        GIPI_INSTALLMENT.TAX_AMT%TYPE;
  V_TAX1            GIPI_INSTALLMENT.TAX_AMT%TYPE;
  V_TAX2            GIPI_INSTALLMENT.TAX_AMT%TYPE;
  V_TAX3            GIPI_INSTALLMENT.TAX_AMT%TYPE;
  COUNTER           NUMBER:=0;
  VAR_NO_OF_PAYT    GIIS_PAYTERM.NO_OF_PAYT%TYPE;
  VAR_INST_NO       GIPI_INSTALLMENT.INST_NO%TYPE:=0;
  VAR_SHARE_PCT     GIPI_INSTALLMENT.SHARE_PCT%TYPE:=0;
  V_SHARE_PCT_DUE   GIPI_INSTALLMENT.SHARE_PCT%TYPE;
  VAR_PREM_AMT      GIPI_INSTALLMENT.PREM_AMT%TYPE:=0;
  V_PREM_AMT_DUE    GIPI_INSTALLMENT.PREM_AMT%TYPE;
  VAR_TAX_AMT       GIPI_INSTALLMENT.TAX_AMT%TYPE:=0;
  VAR_DUE_DATE      GIPI_INSTALLMENT.DUE_DATE%TYPE;  --GIPI_INVOICE.DUE_DATE
  V_TOT_DIST_PREM   NUMBER;
  V_TOT_TAX_AMT     NUMBER;
  V_DIFF_TAX_AMT    NUMBER;
  V_DIFF_CENTS      NUMBER;
  V_TOT_SHARE_PCT   NUMBER;
  V_DIFF_PCT        NUMBER;
  VAR_TAX_AMT_DUE   GIPI_INSTALLMENT.TAX_AMT%TYPE;
  VAR_INI_TAX_AMT   NUMBER;
  V_POL_PERIOD      NUMBER;
  V_INTERVAL        NUMBER;
  V_INCEPT_DATE     GIPI_POLBASIC.INCEPT_DATE%TYPE:= P_INCEPT_DATE;
  V_EXPIRY_DATE     GIPI_POLBASIC.EXPIRY_DATE%TYPE:= P_EXPIRY_DATE;
  CURSOR  GRP IS
    SELECT ITEM_GRP
    FROM GIPI_INVOICE
    WHERE POLICY_ID = P_POLICY_ID
    AND ISS_CD = P_ISS_CD
    AND PREM_SEQ_NO = P_PREM_SEQ_NO;
--  CURSOR  DATES IS
--    SELECT EXPIRY_DATE, INCEPT_DATE
--    FROM GIPI_POLBASIC
--    WHERE POLICY_ID = P_POLICY_ID;
  CURSOR  PAYTS
    (V_ITEM_GRP      GIPI_INVOICE.ITEM_GRP%TYPE)  IS
    SELECT A.NO_OF_PAYT, B.PREM_AMT, B.OTHER_CHARGES, B.NOTARIAL_FEE
    FROM GIIS_PAYTERM A, GIPI_INVOICE B
    WHERE A.PAYT_TERMS = B.PAYT_TERMS
    AND B.POLICY_ID = P_POLICY_ID
    AND B.ITEM_GRP =  V_ITEM_GRP
    AND B.ISS_CD = P_ISS_CD
    AND B.PREM_SEQ_NO = P_PREM_SEQ_NO;
  CURSOR  GIT  IS
    SELECT TAX_AMT, TAX_ALLOCATION
    FROM GIPI_INV_TAX
    WHERE ISS_CD = P_ISS_CD
    AND PREM_SEQ_NO = P_PREM_SEQ_NO;
BEGIN
  /*** TO MAKE SURE NO DUPLICATE RECORDS IN INSTALLMENT ***/
  DELETE FROM GIPI_INSTALLMENT
  WHERE ISS_CD = P_ISS_CD
  AND PREM_SEQ_NO = P_PREM_SEQ_NO;
  /*** END INITIALIZATION OF GIPI_INSTALLMENT  ***/
  FOR JA1 IN GRP LOOP
    --FOR JA2 IN DATES LOOP
    --  V_EXPIRY_DATE := JA2.EXPIRY_DATE;
    --  V_INCEPT_DATE := JA2.INCEPT_DATE;
    --END LOOP;
    V_TAX_AMT1 := 0;
    V_TAX_AMT2 := 0;
    V_TAX_AMT3 := 0;
    V_TAX1 := 0;
    V_TAX2 := 0;
    V_TAX3 := 0;
    VAR_SHARE_PCT := 0;
    VAR_PREM_AMT := 0;
    VAR_TAX_AMT := 0;
    VAR_TAX_AMT_DUE := 0;
    FOR JA3 IN PAYTS(JA1.ITEM_GRP) LOOP
      VAR_NO_OF_PAYT   :=  JA3.NO_OF_PAYT;
      VAR_SHARE_PCT    :=  ROUND(100/VAR_NO_OF_PAYT,2);
      V_TOT_SHARE_PCT  :=  (VAR_SHARE_PCT * VAR_NO_OF_PAYT);
      V_DIFF_PCT       :=  100 - V_TOT_SHARE_PCT;
      VAR_PREM_AMT     :=  ROUND(((JA3.PREM_AMT + NVL(JA3.OTHER_CHARGES,0) + NVL(JA3.NOTARIAL_FEE,0))/VAR_NO_OF_PAYT),2);
      V_TOT_DIST_PREM  :=  VAR_PREM_AMT * VAR_NO_OF_PAYT;
      V_DIFF_CENTS     :=  JA3.PREM_AMT + NVL(JA3.OTHER_CHARGES,0) + NVL(JA3.NOTARIAL_FEE,0) - V_TOT_DIST_PREM;
      V_POL_PERIOD     :=  ((V_EXPIRY_DATE - V_INCEPT_DATE) + ROUND(1));
      V_INTERVAL       :=  ROUND((V_POL_PERIOD/30) / JA3.NO_OF_PAYT);
      FOR JA4 IN GIT LOOP
        IF JA4.TAX_ALLOCATION = 'F' THEN
           V_TAX_AMT1 := V_TAX_AMT1 + JA4.TAX_AMT;
        ELSIF JA4.TAX_ALLOCATION = 'S' THEN
           V_TAX_AMT2 := V_TAX_AMT2 + JA4.TAX_AMT;
        ELSIF JA4.TAX_ALLOCATION = 'L' THEN
           V_TAX_AMT3 := V_TAX_AMT3 + JA4.TAX_AMT;
        END IF;
      END LOOP JA4;
      IF V_TAX_AMT2 IS NOT NULL THEN
        VAR_INI_TAX_AMT := ROUND((V_TAX_AMT2 / VAR_NO_OF_PAYT),2);
        V_TOT_TAX_AMT   := VAR_INI_TAX_AMT * VAR_NO_OF_PAYT;
        V_DIFF_TAX_AMT  := V_TAX_AMT2 - V_TOT_TAX_AMT;
      END IF;
      VAR_INST_NO := 0;
      FOR JA IN 1..VAR_NO_OF_PAYT LOOP
        VAR_INST_NO := VAR_INST_NO + 1;
        -- IF 'SC' DIFF DUE_DATE
        VAR_DUE_DATE := VAR_DUE_DATE + ROUND (V_INTERVAL * 30 );
        IF VAR_INST_NO = 1 THEN
          VAR_TAX_AMT_DUE := V_TAX_AMT1 + VAR_INI_TAX_AMT;
          V_PREM_AMT_DUE  := VAR_PREM_AMT;
          V_SHARE_PCT_DUE := VAR_SHARE_PCT;
          VAR_DUE_DATE    := V_INCEPT_DATE;
        ELSIF VAR_INST_NO = VAR_NO_OF_PAYT THEN
          VAR_TAX_AMT_DUE := V_TAX_AMT3 + VAR_INI_TAX_AMT + V_DIFF_TAX_AMT;
          V_PREM_AMT_DUE  := VAR_PREM_AMT + V_DIFF_CENTS;
          V_SHARE_PCT_DUE := VAR_SHARE_PCT + V_DIFF_PCT;
        ELSE
          VAR_TAX_AMT_DUE := VAR_INI_TAX_AMT;
          V_PREM_AMT_DUE  := VAR_PREM_AMT;
          V_SHARE_PCT_DUE := VAR_SHARE_PCT;
        END IF;
        INSERT INTO GIPI_INSTALLMENT
          (ISS_CD                 ,PREM_SEQ_NO            ,INST_NO                ,
           ITEM_GRP               ,SHARE_PCT              ,TAX_AMT                ,
           PREM_AMT               ,DUE_DATE               )
        VALUES
          (P_ISS_CD               ,P_PREM_SEQ_NO          ,VAR_INST_NO            ,
           ja1.ITEM_GRP           ,V_SHARE_PCT_DUE        ,VAR_TAX_AMT            ,
           V_PREM_AMT_DUE         ,VAR_DUE_DATE           );
      END LOOP JA;
    END LOOP JA3;
  END LOOP JA1;
END;
/

