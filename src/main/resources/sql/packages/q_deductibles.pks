CREATE OR REPLACE PACKAGE CPI.Q_DEDUCTIBLES
AS
	TYPE deductible_type IS RECORD (
		extract_id			GIXX_DEDUCTIBLES.extract_id%TYPE,
		item_no				GIXX_DEDUCTIBLES.item_no%TYPE,
		deductible_title	GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
		ded_deductible_text	GIXX_DEDUCTIBLES.deductible_text%TYPE,
		ded_deductible_amt	GIXX_DEDUCTIBLES.deductible_amt%TYPE,
		ded_line_cd			GIXX_DEDUCTIBLES.ded_line_cd%TYPE,
		ded_subline_cd		GIXX_DEDUCTIBLES.ded_subline_cd%TYPE,
		ded_deductible_cd	GIXX_DEDUCTIBLES.ded_deductible_cd%TYPE,
		deductible_rt		VARCHAR2(10),
		ded_peril_sname		GIIS_PERIL.peril_sname%TYPE,
		deductible_amt		GIXX_DEDUCTIBLES.deductible_amt%TYPE,
		f_deductible_amt	NUMBER(38,2));
		
	TYPE deductible_tab IS TABLE OF deductible_type;
	
	FUNCTION get_records (
		p_extract_id	IN GIXX_DEDUCTIBLES.extract_id%TYPE,
		p_item_no		IN GIXX_DEDUCTIBLES.item_no%TYPE)
	RETURN deductible_tab PIPELINED;
	
	FUNCTION get_records (
		p_extract_id	IN GIXX_DEDUCTIBLES.extract_id%TYPE,
		p_item_no		IN GIXX_DEDUCTIBLES.item_no%TYPE,
		p_report_id		VARCHAR2)
	RETURN deductible_tab PIPELINED;
	
	FUNCTION get_deductible_amount (
		p_extract_id		IN GIXX_INVOICE.extract_id%TYPE,
		p_item_no			IN GIXX_ITEM.item_no%TYPE,
		p_deductible_amt	IN GIXX_DEDUCTIBLES.deductible_amt%TYPE)
	RETURN NUMBER;
END Q_DEDUCTIBLES;
/


