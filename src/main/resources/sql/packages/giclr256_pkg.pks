CREATE OR REPLACE PACKAGE CPI.GICLR256_PKG
AS
    TYPE giclr256_report_type IS RECORD(
        line               VARCHAR2(50),
        loss_cat_des       VARCHAR2(100),
        claim_no           VARCHAR2(50),
        policy_no          VARCHAR2(50),
        assd_name          VARCHAR2(500),
        dsp_loss_date      DATE,
        item               VARCHAR2(60),
        item_title         VARCHAR2(50),
        peril_name         VARCHAR2(20),
        claim_id           NUMBER(12),
        item_no            NUMBER(9),
        peril_cd           NUMBER(5),
        loss_res_amt       NUMBER(16,2),
        loss_pd_amt        NUMBER(16,2), 
        exp_res_amt        NUMBER(16,2), 
        exp_pd_amt         NUMBER(16,2),
        not_exist          VARCHAR2(1)
    );
    TYPE giclr256_report_tab IS TABLE OF giclr256_report_type;
    FUNCTION populate_giclr256(
        p_line_cd       VARCHAR2,
        p_loss_cat      VARCHAR2,
        p_search_by     VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2
    )
    RETURN giclr256_report_tab PIPELINED;
    
    TYPE giclr256_header_type IS RECORD(
        company_name        VARCHAR2(100),
        company_address     VARCHAR2(250),
        report_date         VARCHAR2(150)
    );
    
    TYPE giclr256_header_tab IS TABLE OF giclr256_header_type;
    
    FUNCTION get_giclr256_header(
        p_search_by     VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2
    )
        RETURN giclr256_header_tab PIPELINED;
END;
/


