CREATE OR REPLACE PACKAGE CPI.Gixx_Itmperil_Pkg AS

    TYPE pol_doc_item_peril_type IS RECORD (
		SEQUENCE				GIIS_PERIL.SEQUENCE%TYPE,
        extract_id				GIXX_ITMPERIL.extract_id%TYPE,
		item_no					GIXX_ITMPERIL.item_no%TYPE,
		line_cd					GIXX_ITMPERIL.line_cd%TYPE,
		peril_cd				GIXX_ITMPERIL.peril_cd%TYPE,
		comp_rem				GIXX_ITMPERIL.comp_rem%TYPE,
		peril_sname				GIIS_PERIL.peril_sname%TYPE,
		peril_lname				GIIS_PERIL.peril_lname%TYPE,
		tsi_amt					GIXX_ITMPERIL.tsi_amt%TYPE,
		prem_amt				GIXX_ITMPERIL.prem_amt%TYPE,
		prem_rt					GIXX_ITMPERIL.prem_rt%TYPE,
		peril_type				GIIS_PERIL.peril_type%TYPE,
		peril_name				GIIS_PERIL.peril_name%TYPE,
		f_item_prem_amt			NUMBER,
		f_peril_name			VARCHAR2(100),		
		f_tsi_amt				NUMBER,
		f_prem_amt				NUMBER,
		f_item_short_name		VARCHAR2(20),
		f_item_peril_short_name VARCHAR2(20));
    
    TYPE pol_doc_item_peril_tab IS TABLE OF pol_doc_item_peril_type;
    
    FUNCTION get_pol_doc_item_peril (p_extract_id   IN GIXX_ITMPERIL.extract_id%TYPE,
                                     p_report_id    IN GIIS_DOCUMENT.report_id%TYPE,
                                     p_item_no      IN GIXX_ITMPERIL.item_no%TYPE)
	RETURN pol_doc_item_peril_tab PIPELINED;	
	 
	FUNCTION GET_ITEM_TSI_AMT (
		p_extract_id IN GIXX_ITMPERIL.extract_id%TYPE,
		p_item_no	 IN GIXX_ITMPERIL.item_no%TYPE) RETURN VARCHAR;
		
	FUNCTION get_mn_tsi_amt_total(p_extract_id      GIXX_ITMPERIL.extract_id%TYPE,
   						    	  p_item_no		  GIXX_ITMPERIL.item_no%TYPE)
	  RETURN NUMBER;
	  
	FUNCTION get_mn_prem_amt_total(p_extract_id      GIXX_ITMPERIL.extract_id%TYPE,
   							     p_item_no		  GIXX_ITMPERIL.item_no%TYPE)
	  RETURN NUMBER;
	  
	FUNCTION get_peril_name (
		p_report_id		IN GIIS_DOCUMENT.report_id%TYPE,
		p_peril_lname 	IN GIIS_PERIL.peril_lname%TYPE,
		p_peril_sname 	IN GIIS_PERIL.peril_sname%TYPE,
		p_peril_name  	IN GIIS_PERIL.peril_name%TYPE)
	RETURN VARCHAR2;
	
	FUNCTION get_tsi_amt (
		p_extract_id 	IN GIXX_INVOICE.extract_id%TYPE,
		p_item_no		IN GIXX_ITEM.item_no%TYPE,
		p_tsi_amt		IN GIXX_ITMPERIL.tsi_amt%TYPE) 
	RETURN NUMBER;
	
	FUNCTION get_premium_amt (
		p_extract_id 	IN GIXX_INVOICE.extract_id%TYPE,
		p_item_no		IN GIXX_ITEM.item_no%TYPE,
		p_prem_amt		IN GIXX_ITMPERIL.prem_amt%TYPE) 
	RETURN NUMBER;
	
	FUNCTION get_item_premium_amt (
		p_extract_id 	IN GIXX_INVOICE.extract_id%TYPE,
		p_item_no		IN GIXX_ITEM.item_no%TYPE,
		p_prem_amt		IN GIXX_ITMPERIL.prem_amt%TYPE) 
	RETURN NUMBER;
    
    
    
    -- added by Kris 02.26.2013: for GIPIS101
    TYPE item_peril_type IS RECORD (
        extract_id          gixx_itmperil.extract_id%TYPE,
        policy_id           gixx_itmperil.policy_id%TYPE,
        item_no             gixx_itmperil.item_no%TYPE,
        peril_cd            gixx_itmperil.peril_cd%TYPE,
        peril_name          giis_peril.peril_name%TYPE,
        line_cd             gixx_itmperil.line_cd%TYPE,
        tarf_cd             gixx_itmperil.tarf_cd%TYPE,
        tsi_amt             gixx_itmperil.tsi_amt%TYPE,
        prem_amt            gixx_itmperil.prem_amt%TYPE,
        prem_rt             gixx_itmperil.prem_rt%TYPE,
        comp_rem            gixx_itmperil.comp_rem%TYPE,
        ri_comm_rate        gixx_itmperil.ri_comm_rate%TYPE,
        ri_comm_amt         gixx_itmperil.ri_comm_amt%TYPE,
        rec_flag            gixx_itmperil.rec_flag%TYPE
    );
    
    TYPE item_peril_tab IS TABLE OF item_peril_type;
    
    FUNCTION get_itmperil (
        p_extract_id        gixx_itmperil.extract_id%TYPE,
        p_item_no           gixx_itmperil.item_no%TYPE,
        p_pack_pol_flag     gixx_polbasic.pack_pol_flag%TYPE,  
        p_pack_line_cd      gixx_item.pack_line_cd%TYPE,       
        p_line_cd           giis_line.line_cd%TYPE             
    ) RETURN item_peril_tab PIPELINED;
    -- end 02.26.2013: for GIPIS101

END Gixx_Itmperil_Pkg;
/


