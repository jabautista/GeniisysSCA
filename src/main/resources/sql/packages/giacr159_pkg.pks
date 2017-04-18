CREATE OR REPLACE PACKAGE CPI.GIACR159_PKG AS

TYPE giacr159_type IS RECORD(
    company_name        GIAC_PARAMETERS.param_value_v%TYPE,
    company_address     GIAC_PARAMETERS.param_value_v%TYPE,
    or_pref_suf         GIAC_ORDER_OF_PAYTS.OR_PREF_SUF%TYPE,
    or_no               GIAC_ORDER_OF_PAYTS.OR_NO%TYPE,
    or_pref_suf_or_no   VARCHAR2(30),
    incept_date         GIPI_POLBASIC.INCEPT_DATE%TYPE,
    policy_no           VARCHAR2(50),
    bill_no             VARCHAR2(50),
    b140_iss_cd         GIAC_DIRECT_PREM_COLLNS.B140_ISS_CD%TYPE,
    b140_prem_seq_no    GIAC_DIRECT_PREM_COLLNS.B140_PREM_SEQ_NO%TYPE,
    inst_no             GIAC_DIRECT_PREM_COLLNS.INST_NO%TYPE,
    tran_date           GIAC_ACCTRANS.TRAN_DATE%TYPE,
    collection_amt      GIAC_DIRECT_PREM_COLLNS.COLLECTION_AMT%TYPE,
    tran_flag           GIAC_ACCTRANS.TRAN_FLAG%TYPE,
    posted              GIAC_DIRECT_PREM_COLLNS.COLLECTION_AMT%TYPE,
    unposted            GIAC_DIRECT_PREM_COLLNS.COLLECTION_AMT%TYPE,
    posting_date        GIAC_ACCTRANS.POSTING_DATE%TYPE,
    par_id              GIPI_PARLIST.PAR_ID%TYPE,
    assd_no             GIIS_ASSURED.ASSD_NO%TYPE,
    assd_name           GIIS_ASSURED.ASSD_NAME%TYPE,
    intm_no             VARCHAR2(20)
);

TYPE giacr159_tab IS TABLE OF giacr159_type;

FUNCTION populate_giacr159(
    p_from_date     DATE,
    p_to_date       DATE
    
)
RETURN giacr159_tab PIPELINED;

FUNCTION CF_intm_noFormula(
    p_b140_iss_cd  GIAC_DIRECT_PREM_COLLNS.B140_ISS_CD%TYPE,
     p_b140_prem_seq_no  GIAC_DIRECT_PREM_COLLNS.B140_PREM_SEQ_NO%TYPE
    
)
RETURN number;
   
END GIACR159_PKG;
/


