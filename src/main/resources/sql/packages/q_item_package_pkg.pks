CREATE OR REPLACE PACKAGE CPI.Q_ITEM_PACKAGE_PKG 

AS

    TYPE q_item_type IS RECORD (
        extract_id       GIXX_ITEM.extract_id%TYPE,    
        policy_id        GIXX_ITEM.policy_id%TYPE,    
        line_cd          GIXX_ITEM.pack_line_cd%TYPE,      
        item_no          GIXX_ITEM.item_no%TYPE,
        item_item_title  VARCHAR2(500),
        item_title       GIXX_ITEM.item_title%TYPE, 
        item_desc        GIXX_ITEM.item_desc%TYPE,
        item_desc2       GIXX_ITEM.item_desc2%TYPE,
        coverage_cd      GIXX_ITEM.coverage_cd%TYPE,
        currency_desc    GIIS_CURRENCY.currency_desc%TYPE,
        other_info       GIXX_ITEM.other_info%TYPE,
        from_date        GIXX_ITEM.from_date%TYPE,
        to_date          GIXX_ITEM.to_date%TYPE,
        currency_rt      GIXX_ITEM.currency_rt%TYPE,       
        pack_line_cd     GIXX_ITEM.pack_line_cd%TYPE,
        risk             VARCHAR2(500),
        tsi_amt          GIXX_ITEM.tsi_amt%TYPE,
        risk_item_no     GIXX_ITEM.risk_item_no%TYPE,
        risk_no          GIXX_ITEM.risk_no%TYPE,
        show_deductible  VARCHAR2(1)
);

TYPE q_item_tab IS TABLE OF q_item_type;

FUNCTION get_q_item_package_records(p_extract_id   GIXX_ITEM.extract_id%TYPE) 
RETURN q_item_tab PIPELINED;

FUNCTION check_deductible_display (p_extract_id    GIXX_ITEM.extract_id%TYPE,
                                   p_line_cd       GIXX_ITEM.pack_line_cd%TYPE,
                                   p_policy_id     GIXX_ITEM.policy_id%TYPE)
RETURN VARCHAR2;

END;
/


