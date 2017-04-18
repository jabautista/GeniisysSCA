CREATE OR REPLACE PACKAGE CPI.Gixx_Mortgagee_Pkg AS      

    TYPE pol_doc_mortgagee_type IS RECORD (
        norec               VARCHAR2(10), 
        extract_id4         GIXX_MORTGAGEE.extract_id%TYPE, 
        mortgagee_iss_cd    GIXX_MORTGAGEE.iss_cd%TYPE,
        mortgagee_name      GIIS_MORTGAGEE.mortg_name%TYPE,
        mortgagee_item_no   GIXX_MORTGAGEE.item_no%TYPE,
        mortgagee_amount    GIXX_MORTGAGEE.amount%TYPE
        );		
        
    TYPE pol_doc_mortgagee_tab IS TABLE OF pol_doc_mortgagee_type;
    
    FUNCTION get_pol_doc_mortgagee RETURN pol_doc_mortgagee_tab PIPELINED;
	
	TYPE pol_doc_mortgagee_type2 IS RECORD (
		extract_id			GIXX_MORTGAGEE.extract_id%TYPE, 
        mortgagee_iss_cd    GIXX_MORTGAGEE.iss_cd%TYPE,
        mortgagee_name      GIIS_MORTGAGEE.mortg_name%TYPE,
        mortgagee_item_no   GIXX_MORTGAGEE.item_no%TYPE,
        mortgagee_amount    GIXX_MORTGAGEE.amount%TYPE,
        mortgagee_remarks   GIXX_MORTGAGEE.remarks%TYPE,
		f_mortgagee_amount	NUMBER,
		show_mortgagee_amt	VARCHAR2(1));
	
	TYPE pol_doc_mort_tab IS TABLE OF pol_doc_mortgagee_type2;
	
	FUNCTION get_pol_doc_mort (p_extract_id IN GIXX_MORTGAGEE.extract_id%TYPE,
		p_report_id IN GIIS_DOCUMENT.report_id%TYPE,
		p_print_mort_amt IN GIIS_DOCUMENT.text%TYPE)
	RETURN pol_doc_mort_tab PIPELINED;
	
	FUNCTION get_mortgagee_amount (
		p_extract_id 		IN GIXX_MORTGAGEE.extract_id%TYPE,
		p_mortgagee_amount 	IN GIXX_MORTGAGEE.amount%TYPE)
	RETURN NUMBER;
	
	FUNCTION pol_doc_show_mortgagee_amt(
		p_report_id IN GIIS_DOCUMENT.report_id%TYPE,
		p_print_mort_amt IN GIIS_DOCUMENT.text%TYPE,
		p_mort_amount IN GIXX_MORTGAGEE.amount%TYPE)
	RETURN VARCHAR2;
    
    FUNCTION get_pack_pol_doc_mort (p_extract_id IN GIXX_MORTGAGEE.extract_id%TYPE,
								    p_report_id  IN GIIS_DOCUMENT.report_id%TYPE)
    RETURN pol_doc_mort_tab PIPELINED;
    
    FUNCTION get_pack_mortgagee_amount (
		p_extract_id 		IN GIXX_MORTGAGEE.extract_id%TYPE,
		p_mortgagee_amount 	IN GIXX_MORTGAGEE.amount%TYPE)
    RETURN NUMBER;
	
	
	-- added by Kris 02.20.2013 for GIPIS101 
    TYPE mortg_list_type IS RECORD (
        extract_id      gixx_mortgagee.extract_id%TYPE,
        iss_cd          gixx_mortgagee.iss_cd%TYPE,
        item_no         gixx_mortgagee.item_no%TYPE,
        mortg_cd        gixx_mortgagee.mortg_cd%TYPE,
        mortg_name      giis_mortgagee.MORTG_NAME%TYPE,
        amount          gixx_mortgagee.amount%TYPE,
        total_amount    NUMBER(20,2),
        remarks         gixx_mortgagee.remarks%TYPE,
        delete_sw       gixx_mortgagee.delete_sw%TYPE,
        policy_id       gixx_mortgagee.policy_id%TYPE,
        
        dsp_item_no     gixx_mortgagee.item_no%TYPE 
    );
    
    TYPE mortg_list_tab IS TABLE OF mortg_list_type;
    
    FUNCTION get_mortgagee_list(
        p_extract_id    gixx_mortgagee.extract_id%TYPE
    ) RETURN mortg_list_tab PIPELINED;
    
    FUNCTION get_item_mortgagee_info(
        p_extract_id    gixx_mortgagee.extract_id%TYPE,
        p_item_no       gixx_mortgagee.item_no%TYPE
    ) RETURN mortg_list_tab PIPELINED;
    
    -- end 02.20.2013 GIPIS101

END Gixx_Mortgagee_Pkg;
/


