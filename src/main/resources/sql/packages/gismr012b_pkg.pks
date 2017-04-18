CREATE OR REPLACE PACKAGE CPI.GISMR012B_PKG
AS
    TYPE gismr012b_record_type IS RECORD (
        param_name      VARCHAR2(50),
        user_name       VARCHAR2(20),
        line            VARCHAR2(20),
        date_sent       DATE,
        message         VARCHAR2(160),
        message_status  VARCHAR2(1),
        user_id         VARCHAR2(20),
        cellphone_no    VARCHAR2(40),
        exist           VARCHAR2(1)
    );
    TYPE gismr012b_record_tab IS TABLE OF gismr012b_record_type;
    
    FUNCTION get_gismr012b(
        p_from_date  VARCHAR2,
        p_to_date    VARCHAR2,
        p_as_of_date VARCHAR2,
        p_user       VARCHAR2
    )
        RETURN gismr012b_record_tab PIPELINED;
        
    TYPE gismr012b_header_type IS RECORD(
        company_name        VARCHAR2(100),
        company_address     VARCHAR2(250),
        report_date         VARCHAR2(100)
    );
    
    TYPE gismr012b_header_tab IS TABLE OF gismr012b_header_type;
    
    FUNCTION get_gismr012b_header(
        p_from_date  VARCHAR2,
        p_to_date    VARCHAR2,
        p_as_of_date VARCHAR2
    )
        RETURN gismr012b_header_tab PIPELINED;
END;
/


