DROP PROCEDURE CPI.AUTO_POP_INV_TAX;

CREATE OR REPLACE PROCEDURE CPI.AUTO_POP_INV_TAX
 (P_POLICY_ID               GIPI_POLBASIC.POLICY_ID%TYPE,
  P_ISS_CD                  GIPI_PARLIST.ISS_CD%TYPE,
  P_LINE_CD                 GIPI_PARLIST.LINE_CD%TYPE,
  P_ITEM_GRP                GIPI_INVOICE.ITEM_GRP%TYPE,
  P_PREM_AMT                GIPI_INVOICE.PREM_AMT%TYPE,
  P_PREM_SEQ_NO             GIPI_INVOICE.PREM_SEQ_NO%TYPE  )
IS
  V_TAX_ALLOCATION          GIPI_INV_TAX.TAX_ALLOCATION%TYPE;
  V_FIXED_TAX_ALLOCATION    GIPI_INV_TAX.FIXED_TAX_ALLOCATION%TYPE;
  V_TAX                     GIPI_INV_TAX.TAX_AMT%TYPE;

CURSOR GIT IS
  SELECT C.TAX_CD, C.RATE, C.TAX_ID, C.ALLOCATION_TAG, C.ISS_CD, C.LINE_CD
  FROM GIIS_TAX_CHARGES C
  WHERE C.LINE_CD = P_LINE_CD
  AND C.ISS_CD = P_ISS_CD
  AND C.PRIMARY_SW = 'Y'
  AND NOT EXISTS (SELECT 'X'
    FROM GIPI_INV_TAX D
    WHERE ISS_CD||PREM_SEQ_NO = P_ISS_CD||P_PREM_SEQ_NO
    AND D.ITEM_GRP = P_ITEM_GRP
    AND D.TAX_CD = C.TAX_CD );

BEGIN
  -- FOR NON - PACKAGE POLICIES ONLY --
  FOR JA1 IN  GIT  LOOP
    IF JA1.ALLOCATION_TAG != 'N' THEN
       V_TAX_ALLOCATION := JA1.ALLOCATION_TAG;
       V_FIXED_TAX_ALLOCATION := 'Y' ;
    ELSE
       V_TAX_ALLOCATION := 'F';
       V_FIXED_TAX_ALLOCATION := 'N' ;
    END IF;
    V_TAX := JA1.RATE * P_PREM_AMT /100;
    INSERT INTO GIPI_INV_TAX
      (ISS_CD                 ,PREM_SEQ_NO            ,TAX_CD                 ,
       LINE_CD                ,ITEM_GRP               ,TAX_AMT                ,
       TAX_ID                 ,TAX_ALLOCATION         ,FIXED_TAX_ALLOCATION   ,
       RATE                   )
    VALUES
      (P_ISS_CD               ,P_PREM_SEQ_NO          ,JA1.TAX_CD             ,
       P_LINE_CD              ,P_ITEM_GRP             ,V_TAX                  ,
       JA1.TAX_ID             ,V_TAX_ALLOCATION       ,V_FIXED_TAX_ALLOCATION ,
       JA1.RATE               );

  END LOOP JA1;
END;
/

