CREATE OR REPLACE PACKAGE CPI.GIACR276_PKG
AS
    TYPE giacr276_type IS RECORD (
        line_cd           VARCHAR2(2),            
        line              VARCHAR2(50),
        iss_cd            VARCHAR2(2),
        iss_source        VARCHAR2(100),
        assd_name         VARCHAR2(500),
        policy_no         VARCHAR2(50),
        incept_date       DATE,
        acct_ent_date     DATE,
        peril             VARCHAR2(100),
        prem_amt          NUMBER(12,2),
        comm_amt          NUMBER(12,2),
        flag              VARCHAR2(1)
    );
    
    TYPE giacr276_tab IS TABLE OF giacr276_type;
    
    FUNCTION get_giacr276_tab(
        P_ISS_PARAM       NUMBER,
        P_FROM_DATE       VARCHAR2,    
        P_TO_DATE         VARCHAR2,
        P_MODULE_ID       VARCHAR2,
        P_LINE_CD         VARCHAR2,
        P_USER_ID         VARCHAR2
        )
    RETURN giacr276_tab PIPELINED;
    
    TYPE giacr276_header_type IS RECORD(
        company_name        VARCHAR2(100),
        company_address     VARCHAR2(250),
        report_date_header  VARCHAR2(200)
    );
    
    TYPE giacr276_header_tab IS TABLE OF giacr276_header_type;
    
    FUNCTION get_giacr276_header(
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2
    )
        RETURN giacr276_header_tab PIPELINED;
END;
/


