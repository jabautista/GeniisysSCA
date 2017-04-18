CREATE OR REPLACE PACKAGE CPI.Gixx_Invoice_Pkg AS

  TYPE gixx_invoice_type IS RECORD(
  	extract_id2           GIXX_INVOICE.extract_id%TYPE,
	extract_id20          GIXX_INVOICE.extract_id%TYPE,
    invoice_prem_amt  	  GIXX_INVOICE.policy_currency%TYPE,
    premium_amt			  GIXX_INVOICE.prem_amt%TYPE,
	tax_amt				  GIXX_INVOICE.tax_amt%TYPE,
	other_charges		  GIXX_INVOICE.other_charges%TYPE,
	total				  NUMBER(16,2),
	policy_currency		  GIXX_INVOICE.policy_currency%TYPE
	);
	    
  TYPE gixx_invoice_tab IS TABLE OF gixx_invoice_type;
  
  FUNCTION get_gixx_invoice(p_extract_id		GIXX_INVOICE.extract_id%TYPE)
    RETURN gixx_invoice_tab PIPELINED;
	
  FUNCTION get_invoice_summary(p_extract_id		GIXX_INVOICE.extract_id%TYPE)
    RETURN gixx_invoice_tab PIPELINED;
    
  TYPE pol_doc_tsi_type IS RECORD (
      extract_id3     GIXX_INVOICE.extract_id%TYPE,
      tsi_fx_name     GIIS_CURRENCY.short_name%TYPE,
      tsi_fx_desc     GIIS_CURRENCY.currency_desc%TYPE,
      tsi_spelled_tsi VARCHAR2(2000)
      );
    
  TYPE pol_doc_tsi_tab IS TABLE OF pol_doc_tsi_type;
  
  FUNCTION get_pol_doc_tsi(p_extract_id GIXX_INVOICE.extract_id%TYPE)
    RETURN pol_doc_tsi_tab PIPELINED;
    
  TYPE pol_doc_query_1_type IS RECORD(
      extract_id2      GIXX_INVOICE.extract_id%TYPE,
      invoice_prem_amt GIXX_INVOICE.prem_amt%TYPE
      );
    
  TYPE pol_doc_query_1_tab IS TABLE OF pol_doc_query_1_type;
    
  FUNCTION get_pol_doc_quey_1 (p_extract_id GIXX_INVOICE.extract_id%TYPE)
    RETURN pol_doc_query_1_tab PIPELINED;       

  TYPE pol_doc_query_2_type IS RECORD (
      extract_id2             GIXX_INVOICE.extract_id%TYPE,
      invtax_tax_cd           GIXX_ORIG_INV_TAX.tax_cd%TYPE,
      invtax_tax_amt          GIXX_ORIG_INV_TAX.tax_amt%TYPE,
      invoice_prem_amt        GIXX_INVOICE.prem_amt%TYPE,
      taxcharg_tax_desc       GIIS_TAX_CHARGES.tax_desc%TYPE,
      tax_charge_include_tag  GIIS_TAX_CHARGES.include_tag%TYPE,
      tax_charge_sequence     GIIS_TAX_CHARGES.SEQUENCE%TYPE
      );
    
  TYPE pol_doc_query_2_tab IS TABLE OF pol_doc_query_2_type;
   
  FUNCTION get_pol_doc_query_2(p_extract_id GIXX_INVOICE.extract_id%TYPE)
    RETURN pol_doc_query_2_tab PIPELINED;
    
  TYPE pol_doc_invoice_type IS RECORD (
      extract_id20    GIXX_INVOICE.extract_id%TYPE,
      premium_amt     GIXX_INVOICE.prem_amt%TYPE,
      tax_amt         GIXX_INVOICE.tax_amt%TYPE,
      other_charges   GIXX_INVOICE.other_charges%TYPE,
      total           NUMBER(12,2),
      policy_currency GIXX_INVOICE.policy_currency%TYPE
      );
        
  TYPE pol_doc_invoice_tab IS TABLE OF pol_doc_invoice_type;
   
  FUNCTION get_pol_doc_invoice (p_extract_id GIXX_INVOICE.extract_id%TYPE)
    RETURN pol_doc_invoice_tab PIPELINED;

	FUNCTION get_policy_currency(p_extract_id GIXX_POLBASIC.extract_id%TYPE)
	RETURN VARCHAR2;
	
	FUNCTION get_pol_doc_tsi_amt(
		p_extract_id IN GIXX_POLBASIC.extract_id%TYPE,
		p_basic_tsi_amt IN GIXX_POLBASIC.tsi_amt%TYPE,
		p_basic_co_insurance_sw IN GIXX_POLBASIC.co_insurance_sw%TYPE)
	RETURN NUMBER;
	
	FUNCTION get_pol_doc_prem_amt(
		p_extract_id IN GIXX_INVOICE.extract_id%TYPE,
		p_co_insurance_sw IN GIXX_POLBASIC.co_insurance_sw%TYPE,
		p_prem_amt IN NUMBER)
	RETURN NUMBER;

END Gixx_Invoice_Pkg;
/


