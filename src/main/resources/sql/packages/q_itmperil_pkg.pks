CREATE OR REPLACE PACKAGE CPI.Q_ITMPERIL_PKG
AS
    TYPE item_peril_type IS RECORD (
        extract_id               GIXX_ITMPERIL.extract_id%TYPE,
        item_no                  GIXX_ITMPERIL.item_no%TYPE,
        line_cd                  GIXX_ITMPERIL.line_cd%TYPE,
        peril_cd                 GIXX_ITMPERIL.peril_cd%TYPE,
        comp_rem                 GIXX_ITMPERIL.comp_rem%TYPE,
        peril_sname              GIIS_PERIL.peril_sname%TYPE,
        peril_lname              GIIS_PERIL.peril_lname%TYPE,
        tsi_amt                  GIXX_ITMPERIL.tsi_amt%TYPE,
        prem_amt                 GIXX_ITMPERIL.prem_amt%TYPE,
        prem_rt                  GIXX_ITMPERIL.prem_rt%TYPE,
        peril_type               GIIS_PERIL.peril_type%TYPE,
        peril_name               GIIS_PERIL.peril_name%TYPE,
        f_item_prem_amt          NUMBER,
        f_peril_name             VARCHAR2(100),        
        f_tsi_amt                NUMBER,
        f_prem_amt               NUMBER,
        f_item_short_name        VARCHAR2(20),
        f_item_peril_short_name  VARCHAR2(20));
    
    TYPE item_peril_tab IS TABLE OF item_peril_type;
    
    FUNCTION get_records (
        p_extract_id   IN GIXX_ITMPERIL.extract_id%TYPE,
        p_report_id    IN GIIS_DOCUMENT.report_id%TYPE,
        p_item_no      IN GIXX_ITMPERIL.item_no%TYPE)
    RETURN item_peril_tab PIPELINED;
    
    FUNCTION get_records2 (
        p_extract_id   IN GIXX_ITMPERIL.extract_id%TYPE,
        p_report_id    IN GIIS_DOCUMENT.report_id%TYPE)
    RETURN item_peril_tab PIPELINED;
    
    FUNCTION get_peril_name (
        p_report_id       IN GIIS_DOCUMENT.report_id%TYPE,
        p_peril_lname     IN GIIS_PERIL.peril_lname%TYPE,
        p_peril_sname     IN GIIS_PERIL.peril_sname%TYPE,
        p_peril_name      IN GIIS_PERIL.peril_name%TYPE)
    RETURN VARCHAR2;
    
    FUNCTION get_tsi_amt (
        p_extract_id     IN GIXX_INVOICE.extract_id%TYPE,
        p_item_no        IN GIXX_ITEM.item_no%TYPE,
        p_tsi_amt        IN GIXX_ITMPERIL.tsi_amt%TYPE) 
    RETURN NUMBER;
    
    FUNCTION get_premium_amt (
        p_extract_id     IN GIXX_INVOICE.extract_id%TYPE,
        p_item_no        IN GIXX_ITEM.item_no%TYPE,
        p_prem_amt       IN GIXX_ITMPERIL.prem_amt%TYPE) 
    RETURN NUMBER;
    
    FUNCTION get_item_premium_amt (
        p_extract_id     IN GIXX_INVOICE.extract_id%TYPE,
        p_item_no        IN GIXX_ITEM.item_no%TYPE) 
    RETURN NUMBER;
    
    FUNCTION get_pack_peril_records (
        p_extract_id    IN GIXX_ITMPERIL.extract_id%TYPE,
        p_report_id     IN GIIS_DOCUMENT.report_id%TYPE,
        p_item_no       IN GIXX_ITMPERIL.item_no%TYPE)
    RETURN item_peril_tab PIPELINED;
    
    FUNCTION get_pack_item_peril_records (
        p_extract_id   IN GIXX_ITMPERIL.extract_id%TYPE,
        p_report_id    IN GIIS_DOCUMENT.report_id%TYPE,
        p_item_no      IN GIXX_ITMPERIL.item_no%TYPE,
        p_policy_id    IN GIXX_PACK_POLBASIC.policy_id%TYPE)
    RETURN item_peril_tab PIPELINED;
    
    FUNCTION get_pack_tsi_amt (
        p_extract_id     IN GIXX_INVOICE.extract_id%TYPE,
        p_item_no        IN GIXX_ITEM.item_no%TYPE,
        p_policy_id      IN GIXX_PACK_POLBASIC.policy_id%TYPE,
        p_tsi_amt        IN GIXX_ITMPERIL.tsi_amt%TYPE) 
    RETURN NUMBER;
    
    FUNCTION get_pack_premium_amt (
        p_extract_id     IN GIXX_INVOICE.extract_id%TYPE,
        p_item_no        IN GIXX_ITEM.item_no%TYPE,
        p_policy_id      IN GIXX_PACK_POLBASIC.policy_id%TYPE,
        p_prem_amt       IN GIXX_ITMPERIL.prem_amt%TYPE) 
    RETURN NUMBER;
    
    FUNCTION get_pack_item_tsi_amt (
		p_extract_id 	IN GIXX_INVOICE.extract_id%TYPE,
		p_item_no		IN GIXX_ITEM.item_no%TYPE,
		p_peril_type	IN GIIS_PERIL.peril_type%TYPE,
		p_tsi_amt		IN GIXX_ITMPERIL.tsi_amt%TYPE)
    RETURN NUMBER;
	
	FUNCTION get_pack_item_tsi_amt2 (
		p_extract_id 	GIXX_INVOICE.extract_id%TYPE,
		p_item_no		GIXX_ITEM.item_no%TYPE,
		p_peril_type	GIIS_PERIL.peril_type%TYPE,
		p_policy_id     GIXX_PACK_POLBASIC.policy_id%TYPE,
		p_tsi_amt		GIXX_ITMPERIL.tsi_amt%TYPE) 
	
    RETURN NUMBER;
    
END Q_ITMPERIL_PKG;
/


