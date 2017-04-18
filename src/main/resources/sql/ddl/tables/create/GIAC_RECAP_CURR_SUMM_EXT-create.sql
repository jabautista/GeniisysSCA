SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      'CREATE TABLE CPI.GIAC_RECAP_CURR_SUMM_EXT
                    (
                      ROWNO                NUMBER(5,2),
                      ROWTITLE             VARCHAR2(50 BYTE),
                      POLICY_ID            NUMBER(12),
                      ITEM_NO              NUMBER(9),
                      PERIL_CD             NUMBER(5),
                      ISS_CD               VARCHAR2(2 BYTE),
                      LINE_CD              VARCHAR2(2 BYTE),
                      RI_CD                NUMBER(5),
                      CEDANT_CD            NUMBER(5),
                      RI_TYPE              VARCHAR2(1 BYTE),
                      DIRECT_PREM          NUMBER(16,2),
                      DIRECT_COMM          NUMBER(16,2),
                      DIRECT_TSI           NUMBER(16,2),
                      INW_PREM_AUTH        NUMBER(16,2),
                      INW_COMM_AUTH        NUMBER(16,2),
                      INW_TSI_AUTH         NUMBER(16,2),
                      INW_PREM_ASEAN       NUMBER(16,2),
                      INW_COMM_ASEAN       NUMBER(16,2),
                      INW_TSI_ASEAN        NUMBER(16,2),
                      INW_PREM_OTH         NUMBER(16,2),
                      INW_COMM_OTH         NUMBER(16,2),
                      INW_TSI_OTH          NUMBER(16,2),
                      CEDED_PREM_AUTH      NUMBER(16,2),
                      CEDED_COMM_AUTH      NUMBER(16,2),
                      CEDED_TSI_AUTH       NUMBER(16,2),
                      CEDED_PREM_ASEAN     NUMBER(16,2),
                      CEDED_COMM_ASEAN     NUMBER(16,2),
                      CEDED_TSI_ASEAN      NUMBER(16,2),
                      CEDED_PREM_OTH       NUMBER(16,2),
                      CEDED_COMM_OTH       NUMBER(16,2),
                      CEDED_TSI_OTH        NUMBER(16,2),
                      RETCEDED_PREM_AUTH   NUMBER(16,2),
                      RETCEDED_COMM_AUTH   NUMBER(16,2),
                      RETCEDED_TSI_AUTH    NUMBER(16,2),
                      RETCEDED_PREM_ASEAN  NUMBER(16,2),
                      RETCEDED_COMM_ASEAN  NUMBER(16,2),
                      RETCEDED_TSI_ASEAN   NUMBER(16,2),
                      RETCEDED_PREM_OTH    NUMBER(16,2),
                      RETCEDED_COMM_OTH    NUMBER(16,2),
                      RETCEDED_TSI_OTH     NUMBER(16,2),
                      EFF_DATE             DATE,
                      EXP_DATE             DATE,
                      DEF_PREM_AMT    NUMBER(16,2)
                    )';
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;