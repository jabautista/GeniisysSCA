SET SERVEROUTPUT ON;

BEGIN
   EXECUTE IMMEDIATE
      'CREATE TABLE CPI.GIAC_RECAP_PRIOR_DTL_EXT
                    (
                      ISS_CD              VARCHAR2(2 BYTE),
                      LINE_CD             VARCHAR2(2 BYTE),
                      SUBLINE_CD          VARCHAR2(7 BYTE),
                      POLICY_ID           NUMBER(12),
                      PERIL_CD            NUMBER(5),
                      ITEM_NO             NUMBER(9),
                      TARIFF_CD           VARCHAR2(12 BYTE),
                      SUBLINE_TYPE_CD     VARCHAR2(3 BYTE),
                      BOND_CLASS_SUBLINE  VARCHAR2(3 BYTE),
                      PREMIUM_AMT         NUMBER(18,4),
                      COMMISSION_AMT      NUMBER(18,4),
                      TSI_AMT             NUMBER(18,4),
                      RI_CD               NUMBER(5),
                      LOCAL_FOREIGN_SW    VARCHAR2(1 BYTE),
                      TREATY_PREM         NUMBER(18,4),
                      TREATY_COMM         NUMBER(18,4),
                      TREATY_TSI          NUMBER(18,4),
                      FACUL_PREM          NUMBER(18,4),
                      FACUL_COMM          NUMBER(18,4),
                      FACUL_TSI           NUMBER(18,4),
                      INW_RI_COMM         NUMBER(18,4),
                      DATE_TAG            VARCHAR2(1 BYTE),
                      CEDANT              NUMBER(5),
                      ISSUE_YY            NUMBER(2),
                      POL_SEQ_NO          NUMBER(7),
                      RENEW_NO            NUMBER(2),
                      EFF_DATE            DATE,
                      EXP_DATE            DATE,
                      DEF_PREM_AMT        NUMBER(16,2)
                    )';
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;