DROP FUNCTION CPI.GET_DEDUCTIBLES_RISK;

CREATE OR REPLACE FUNCTION CPI.get_deductibles_risk(EXTRACT_ID NUMBER,risk_NO NUMBER)
RETURN VARCHAR2 IS
v_d_risk        VARCHAR2(2000);
v_count1        NUMBER;
v_count2         NUMBER;
BEGIN
 SELECT COUNT(ITEM_NO)
   INTO v_count1
   FROM gixx_item
  WHERE extract_id = EXTRACT_ID
    AND risk_NO = risk_NO;
FOR A IN(
  SELECT b.risk_no, DEDUCTIBLES.DEDUCTIBLE_TEXT, COUNT(*) C1
    FROM GIXX_DEDUCTIBLES     DEDUCTIBLES,
              gixx_item b,
              GIIS_DEDUCTIBLE_DESC   DEDUCT_DESC,
              GIIS_PERIL    PERIL
   WHERE DEDUCTIBLES.DED_DEDUCTIBLE_CD  = DEDUCT_DESC.DEDUCTIBLE_CD (+)
     AND DEDUCTIBLES.ITEM_NO                         = b.ITEM_NO
     AND DEDUCTIBLES.EXTRACT_ID                  = b.EXTRACT_ID
     AND DEDUCTIBLES.DED_SUBLINE_CD        = DEDUCT_DESC.SUBLINE_CD (+)
     AND DEDUCTIBLES.DED_LINE_CD               = DEDUCT_DESC.LINE_CD (+)
     AND DEDUCTIBLES.DED_LINE_CD               = PERIL.LINE_CD (+)
     AND DEDUCTIBLES.PERIL_CD                       = PERIL.PERIL_CD (+)
     AND DEDUCTIBLES.extract_id                         = b.EXTRACT_ID
GROUP BY b.risk_no, DEDUCTIBLES.DEDUCTIBLE_TEXT)
LOOP
v_count2 := A.C1;
IF v_count1 = v_count2 THEN
  FOR B IN(
       SELECT b.risk_no, DEDUCTIBLES.DEDUCTIBLE_TEXT, COUNT(*)
         FROM GIXX_DEDUCTIBLES     DEDUCTIBLES,
              gixx_item b,
              GIIS_DEDUCTIBLE_DESC   DEDUCT_DESC,
              GIIS_PERIL    PERIL
        WHERE DEDUCTIBLES.DED_DEDUCTIBLE_CD  = DEDUCT_DESC.DEDUCTIBLE_CD (+)
          AND DEDUCTIBLES.ITEM_NO                         = b.ITEM_NO
          AND DEDUCTIBLES.EXTRACT_ID                  = b.EXTRACT_ID
          AND DEDUCTIBLES.DED_SUBLINE_CD        = DEDUCT_DESC.SUBLINE_CD (+)
          AND DEDUCTIBLES.DED_LINE_CD               = DEDUCT_DESC.LINE_CD (+)
          AND DEDUCTIBLES.DED_LINE_CD               = PERIL.LINE_CD (+)
          AND DEDUCTIBLES.PERIL_CD                       = PERIL.PERIL_CD (+)
          AND DEDUCTIBLES.extract_id                         = b.EXTRACT_ID
     GROUP BY b.risk_no, DEDUCTIBLES.DEDUCTIBLE_TEXT)
    LOOP
    v_d_risk := B.deductible_text;
    END LOOP;
END IF;
END LOOP;
RETURN(v_d_risk);
END;
/


