CREATE OR REPLACE PACKAGE CPI.GIACR190E_PKG
AS

    /* report variable */
    cp_date_format      VARCHAR2(20);
    dsp_name2           VARCHAR2(200);
    
    TYPE report_header_type IS RECORD(
        company_name        GIIS_PARAMETERS.PARAM_VALUE_V%TYPE,
        company_address     GIIS_PARAMETERS.PARAM_VALUE_V%TYPE,
        print_company       VARCHAR2(1),
        rundate             VARCHAR2(20),
        cf_title            GIAC_PARAMETERS.PARAM_VALUE_V%type,
        cf_date_label       GIAC_PARAMETERS.PARAM_VALUE_V%type,
        cf_date             GIAC_SOA_REP_EXT.PARAM_DATE%type,
        cf_dates            VARCHAR2(100),
        cf_as_of_date       VARCHAR2(50),
        cf_date_tag1        VARCHAR2(300),
        cf_date_tag2        VARCHAR2(300),
        cf_date_tag3        VARCHAR2(300)
    );
    
    TYPE report_header_tab IS TABLE OF report_header_type;
    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
       
    
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
       
    
    FUNCTION CF_TITLE
        RETURN VARCHAR2;
        
       
    FUNCTION CF_DATE_LABEL
        RETURN VARCHAR2;
       
    
    FUNCTION CF_DATE(
        p_user      GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN DATE;
    
    
    FUNCTION CF_DATES(
        p_user      GIAC_SOA_REP_EXT.USER_ID%TYPE,
        p_as_of_date    DATE
    ) RETURN VARCHAR2;
        
       
    FUNCTION CF_AS_OF_DATE(
        p_user          GIAC_SOA_REP_EXT.USER_ID%TYPE,
        p_as_of_date    DATE
    ) RETURN VARCHAR2;
      
    
    FUNCTION CF_DATE_TAG1(
        p_user      GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN VARCHAR;
    
    
    FUNCTION CF_DATE_TAG2(
        p_user      GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_DATE_TAG3(
        p_user      GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN VARCHAR2;
    
    
    PROCEDURE BEFOREREPORT;
    
    
    FUNCTION GET_REPORT_HEADER(
        p_user          GIAC_SOA_REP_EXT.USER_ID%TYPE,
        p_as_of_date    DATE
    ) RETURN report_header_tab PIPELINED;
    
    
    TYPE report_details_type IS RECORD(
        iss_cd                  GIAC_SOA_REP_EXT.ISS_CD%type,
        iss_name                GIIS_ISSOURCE.ISS_NAME%type,
        intm_type               GIAC_SOA_REP_EXT.INTM_TYPE%type,
        intm_no                 GIAC_SOA_REP_EXT.INTM_NO%type,
        intm_name               GIAC_SOA_REP_EXT.INTM_NAME%type,
        agent_code              VARCHAR2(15),
        cf_total                NUMBER(18,2),
        afterdate_collection    GIAC_SOA_REP_EXT.AFTERDATE_COLL%type,
        balance_amt_due         GIAC_SOA_REP_EXT.BALANCE_AMT_DUE%type
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    FUNCTION CF_TOTAL(
        p_balance_amt_due       NUMBER,
        p_afterdate_collection  NUMBER
    ) RETURN NUMBER;
    
    
    FUNCTION GET_REPORT_DETAILS(
        p_branch_cd     GIAC_SOA_REP_EXT.BRANCH_CD%TYPE,
        p_intm_type     GIAC_SOA_REP_EXT.INTM_TYPE%TYPE,
        p_intm_no       GIAC_SOA_REP_EXT.INTM_NO%TYPE,
        p_param_date    GIAC_SOA_REP_EXT.PARAM_DATE%TYPE,
        p_bal_amt_due   GIAC_SOA_REP_EXT.BALANCE_AMT_DUE%TYPE,
        p_user          GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN report_details_tab PIPELINED;
     

    TYPE column_header_type IS RECORD(
        col_no      GIAC_SOA_TITLE.COL_NO%TYPE,
        col_title   GIAC_SOA_TITLE.COL_TITLE%TYPE
    );
    
    TYPE column_header_tab IS TABLE OF column_header_type;
    
    
    FUNCTION GET_COLUMN_HEADER
        RETURN column_header_tab PIPELINED;
        
    
    TYPE column_details_type IS RECORD(
        iss_cd              GIAC_SOA_REP_EXT.ISS_CD%type,
        iss_name            GIIS_ISSOURCE.ISS_NAME%type,
        intm_type           GIAC_SOA_REP_EXT.INTM_TYPE%type,
        intm_no             GIAC_SOA_REP_EXT.INTM_NO%type,
        intm_name           GIAC_SOA_REP_EXT.INTM_NAME%type,
        col_no              NUMBER(5),
        column_title        GIAC_SOA_REP_EXT.COLUMN_TITLE%type,
        intmbal             NUMBER(18,2),
        intmprem            NUMBER(18,2),
        intmtax             NUMBER(18,2)
    );
    
    TYPE column_details_tab IS TABLE OF column_details_type;
    
    
    FUNCTION GET_COLUMN_DETAILS(
        p_branch_cd     GIAC_SOA_REP_EXT.BRANCH_CD%TYPE,
        p_intm_type     GIAC_SOA_REP_EXT.INTM_TYPE%TYPE,
        p_intm_no       GIAC_SOA_REP_EXT.INTM_NO%TYPE,
        p_param_date    GIAC_SOA_REP_EXT.PARAM_DATE%TYPE,
        p_bal_amt_due   GIAC_SOA_REP_EXT.BALANCE_AMT_DUE%TYPE,
        p_user          GIAC_SOA_REP_EXT.USER_ID%TYPE
    ) RETURN column_details_tab PIPELINED;   
    

END GIACR190E_PKG;
/


