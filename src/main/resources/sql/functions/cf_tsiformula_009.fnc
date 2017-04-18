DROP FUNCTION CPI.CF_TSIFORMULA_009;

CREATE OR REPLACE FUNCTION CPI.CF_TSIFormula_009 (V_POL GIPI_INVOICE.POLICY_ID%TYPE
	   							  ,V_ISS gipi_invoice.iss_cd%TYPE
								  ,V_PREM gipi_invoice.prem_seq_no%TYPE)RETURN NUMBER IS
V_TSI       GIPI_ITEM.TSI_AMT%TYPE;


BEGIN

  FOR A IN (SELECT ITEM_GRP
              FROM GIPI_INVOICE
             WHERE POLICY_ID = V_POL
               AND ISS_CD = V_ISS
               AND PREM_SEQ_NO = V_PREM)
  LOOP
    FOR B IN (SELECT SUM(TSI_AMT) AMT
                FROM GIPI_ITEM
               WHERE POLICY_ID = V_POL
                 AND ITEM_GRP = A.ITEM_GRP)
    LOOP
      V_TSI  := B.AMT;
      EXIT;
    END LOOP;
  END LOOP;
  RETURN V_TSI;  
END CF_TSIFormula_009;
/


