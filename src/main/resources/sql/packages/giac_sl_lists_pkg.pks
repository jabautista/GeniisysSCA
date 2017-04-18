CREATE OR REPLACE PACKAGE CPI.giac_sl_lists_pkg
AS

  TYPE vat_sl_list_type IS RECORD(
        sl_cd       giac_sl_lists.sl_cd%TYPE, 
        sl_name     giac_sl_lists.sl_name%TYPE, 
        item_no     giac_module_entries.item_no%TYPE,
        sl_type_cd  giac_sl_lists.sl_type_cd%TYPE);
        
  TYPE vat_sl_list_tab IS TABLE OF vat_sl_list_type;
  
  FUNCTION get_vat_sl_list RETURN vat_sl_list_tab PIPELINED; 

  FUNCTION get_sl_list(p_gslt_sl_type_cd    giac_sl_lists.sl_type_cd%TYPE,
                       p_sl_name            giac_sl_lists.sl_name%TYPE)
  RETURN vat_sl_list_tab PIPELINED;
  
  FUNCTION get_sl_name(p_sl_type_cd			GIAC_SL_LISTS.sl_type_cd%TYPE,
  		   			   p_sl_cd				GIAC_SL_LISTS.sl_cd%TYPE)
    RETURN GIAC_SL_LISTS.sl_name%TYPE;
	
  FUNCTION get_sl_list_by_whtax_id(p_whtax_id		GIAC_WHOLDING_TAXES.whtax_id%TYPE,
  		   						   p_keyword		VARCHAR2)
    RETURN vat_sl_list_tab PIPELINED; 
  
  FUNCTION get_sl_name_list_by_sltype (p_sl_type_cd GIAC_SL_LISTS.sl_type_cd%TYPE,
  		   							  p_fund_cd GIAC_SL_LISTS.fund_cd%TYPE)	
	RETURN vat_sl_list_tab PIPELINED;
	
  FUNCTION get_sl_list_GIACS030 (
        p_sl_type_cd    GIAC_SL_LISTS.sl_type_cd%TYPE,
        p_find          GIAC_SL_LISTS.sl_name%TYPE)
    RETURN vat_sl_list_tab PIPELINED;
  
  FUNCTION get_sl_list_for_tax_type_W(p_tax_cd IN GIIS_LOSS_TAXES.tax_cd%TYPE)
    RETURN vat_sl_list_tab PIPELINED;
    
  FUNCTION get_sl_list_for_tax_type_I(p_tax_cd IN GIIS_LOSS_TAXES.tax_cd%TYPE,
  									  p_find_text IN VARCHAR2) --added by steven 11.20.2012
    RETURN vat_sl_list_tab PIPELINED;
    
  FUNCTION get_sl_list_for_tax_type_O(p_tax_cd IN GIIS_LOSS_TAXES.tax_cd%TYPE)
    RETURN vat_sl_list_tab PIPELINED;
    
   FUNCTION get_sl_code_list(
      p_gl_acct_id            GIAC_SL_TYPE_HIST.gl_acct_id%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN vat_sl_list_tab PIPELINED;
END;
/


