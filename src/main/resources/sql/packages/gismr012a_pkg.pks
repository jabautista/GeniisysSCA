CREATE OR REPLACE PACKAGE CPI.GISMR012A_PKG
AS
    TYPE gismr012a_record_type IS RECORD (
        param_name      VARCHAR2(50),
        line            VARCHAR2(20),
        message         VARCHAR2(160),
        keyword         VARCHAR2(20),
        date_received   DATE,
        cellphone_no    VARCHAR2(40),
        reply           VARCHAR2(2),
        exist           VARCHAR2(1)
    );
    TYPE gismr012a_record_tab IS TABLE OF gismr012a_record_type;
    
    FUNCTION get_gismr012a(
        p_from_date  VARCHAR2,
        p_to_date    VARCHAR2,
        p_as_of_date VARCHAR2
    )
        RETURN gismr012a_record_tab PIPELINED;
        
    TYPE gismr012a_header_type IS RECORD(
        company_name        VARCHAR2(100),
        company_address     VARCHAR2(250),
        report_date         VARCHAR2(100)
    );
    
    TYPE gismr012a_header_tab IS TABLE OF gismr012a_header_type;
    
    FUNCTION get_gismr012a_header(
        p_from_date  VARCHAR2,
        p_to_date    VARCHAR2,
        p_as_of_date VARCHAR2
    )
        RETURN gismr012a_header_tab PIPELINED;
END;
/


