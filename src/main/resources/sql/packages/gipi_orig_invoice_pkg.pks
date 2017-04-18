CREATE OR REPLACE PACKAGE CPI.GIPI_ORIG_INVOICE_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_gipi_orig_invoice (p_par_id 	GIPI_ORIG_INVOICE.par_id%TYPE);
    
    TYPE gipi_orig_invoice_type IS RECORD (
    par_id                GIPI_ORIG_INVOICE.par_id%TYPE, 
    item_grp              GIPI_ORIG_INVOICE.item_grp%TYPE,
    property              GIPI_ORIG_INVOICE.property%TYPE, 
    insured               GIPI_ORIG_INVOICE.insured%TYPE,
    ref_inv_no            GIPI_ORIG_INVOICE.ref_inv_no%TYPE, 
    prem_amt              GIPI_ORIG_INVOICE.prem_amt%TYPE, 
    tax_amt               GIPI_ORIG_INVOICE.tax_amt%TYPE, 
    other_charges         GIPI_ORIG_INVOICE.other_charges%TYPE, 
    currency_cd           GIPI_ORIG_INVOICE.currency_cd%TYPE, 
    currency_desc         GIIS_CURRENCY.currency_desc%TYPE,
    amount_due            NUMBER);

    TYPE gipi_orig_invoice_tab IS TABLE OF gipi_orig_invoice_type;


    FUNCTION get_gipi_orig_invoice
    (p_par_id				GIPI_ORIG_INVOICE.par_id%TYPE, 
     p_item_grp 			GIPI_ORIG_INVOICE.item_grp%TYPE)
    RETURN gipi_orig_invoice_tab PIPELINED;
    


END GIPI_ORIG_INVOICE_PKG;
/


