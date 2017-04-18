CREATE OR REPLACE PACKAGE CPI.Gipi_Inv_Tax_Pkg
AS
    /*
    **  Created by        : Queenie Santos
    **  Date Created     : 05.09.2011
    **  Reference By     : (GIACS050 - OR PRINTING CALLING FORM)
    **  Description     : Determine tax type
    */
      FUNCTION get_vat_type (p_tran_id giac_order_of_payts.gacc_tran_id%TYPE)
       RETURN VARCHAR2;
       
      PROCEDURE update_for_change_payment (
        p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE   
      );
    
    
    TYPE invoice_tax_type IS RECORD(
        iss_Cd          gipi_inv_tax.iss_cd%TYPE,
        line_cd         gipi_inv_tax.line_cd%TYPE,
        tax_cd          gipi_inv_tax.tax_cd%TYPE,
        tax_id          gipi_inv_tax.tax_id%TYPE,
        tax_amt         gipi_inv_tax.tax_amt%TYPE,
        prem_seq_no     gipi_inv_tax.prem_seq_no%TYPE,
        item_grp        gipi_inv_tax.item_grp%TYPE,
        tax_desc        giis_tax_charges.tax_Desc%TYPE
    );
    
    TYPE invoice_tax_tab IS TABLE OF invoice_tax_type;
    
    FUNCTION get_invoice_tax_list(
        p_iss_cd        GIPI_INV_TAX.iss_cd%TYPE,
        p_prem_seq_no   GIPI_INV_TAX.prem_seq_no%TYPE,
        p_item_grp      GIPI_INV_TAX.item_grp%TYPE
    ) RETURN invoice_tax_tab PIPELINED;
    
    
END Gipi_Inv_Tax_Pkg;
/


