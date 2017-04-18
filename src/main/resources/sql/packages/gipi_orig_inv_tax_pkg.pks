CREATE OR REPLACE PACKAGE CPI.GIPI_ORIG_INV_TAX_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_gipi_orig_inv_tax (p_par_id 	GIPI_ORIG_INV_TAX.par_id%TYPE);
    
    TYPE gipi_orig_inv_tax_type IS RECORD(
        par_id                  GIPI_ORIG_INV_TAX.par_id%TYPE,
        item_grp                GIPI_ORIG_INV_TAX.item_grp%TYPE,
        tax_cd                  GIPI_ORIG_INV_TAX.tax_cd%TYPE,
        tax_desc                GIIS_TAX_CHARGES.tax_desc%TYPE,
        line_cd                 GIPI_ORIG_INV_TAX.line_cd%TYPE,
        tax_allocation          GIPI_ORIG_INV_TAX.tax_allocation%TYPE,
        fixed_tax_allocation    GIPI_ORIG_INV_TAX.fixed_tax_allocation%TYPE,
        policy_id               GIPI_ORIG_INV_TAX.policy_id%TYPE,
        iss_cd                  GIPI_ORIG_INV_TAX.iss_cd%TYPE,
        tax_amt                 GIPI_ORIG_INV_TAX.tax_amt%TYPE,
        share_tax_amt           GIPI_ORIG_INV_TAX.tax_amt%TYPE,
        tax_id                  GIPI_ORIG_INV_TAX.tax_id%TYPE,
        rate                    GIPI_ORIG_INV_TAX.rate%TYPE
    );
    
    TYPE gipi_orig_inv_tax_tab IS TABLE OF gipi_orig_inv_tax_type;
    
    FUNCTION get_gipi_orig_inv_tax
    (p_par_id     GIPI_ORIG_INV_TAX.par_id%TYPE,
     p_line_cd    GIPI_ORIG_INV_TAX.line_cd%TYPE,
     p_iss_cd     GIPI_ORIG_INV_TAX.iss_cd%TYPE)
    RETURN gipi_orig_inv_tax_tab PIPELINED;
                                 
    TYPE inv_taxes_type IS RECORD(

        full_tax_cd     gipi_orig_inv_tax.tax_cd%TYPE,
        full_tax_amt    gipi_orig_inv_tax.tax_amt%TYPE,
        full_tax_desc   giis_tax_charges.tax_desc%TYPE,
        your_tax_cd     gipi_inv_tax.tax_cd%TYPE,
        your_tax_amt    gipi_inv_tax.tax_amt%TYPE,
        your_tax_desc   giis_tax_charges.tax_desc%TYPE
        
    );
 
    TYPE inv_taxes_tab IS TABLE OF inv_taxes_type;
    
    FUNCTION get_inv_taxes(p_policy_id   GIPI_ORIG_INV_TAX.policy_id%TYPE,
                           p_item_grp    GIPI_ORIG_INV_TAX.item_grp%TYPE
                           )
    RETURN inv_taxes_tab PIPELINED;   

END GIPI_ORIG_INV_TAX_PKG;
/


