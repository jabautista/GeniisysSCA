CREATE OR REPLACE PACKAGE CPI.GIPI_QUOTE_INVTAX_PKG AS
    
  TYPE gipi_quote_invtax_type IS RECORD
    (quote_inv_no           GIPI_QUOTE_INVTAX.quote_inv_no%TYPE,
     line_cd                GIPI_QUOTE_INVTAX.line_cd%TYPE,
     iss_cd                 GIPI_QUOTE_INVTAX.iss_cd%TYPE,
     tax_cd                 GIPI_QUOTE_INVTAX.tax_cd%TYPE,
     tax_desc               GIIS_TAX_CHARGES.tax_desc%TYPE,
     tax_amt                GIPI_QUOTE_INVTAX.tax_amt%TYPE,
     tax_id                 GIPI_QUOTE_INVTAX.tax_id%TYPE,
     rate                   GIPI_QUOTE_INVTAX.rate%TYPE,
     item_grp               GIPI_QUOTE_INVTAX.item_grp%TYPE,
     fixed_tax_alloc        GIPI_QUOTE_INVTAX.fixed_tax_allocation%TYPE,
     tax_allocation         GIPI_QUOTE_INVTAX.tax_allocation%TYPE,
     primary_sw             GIIS_TAX_CHARGES.primary_sw%TYPE
  );
  TYPE gipi_quote_invtax_tab IS TABLE OF gipi_quote_invtax_type;
  
  TYPE gipi_quote_invtax_type2 IS RECORD(
     quote_inv_no           GIPI_QUOTE_INVTAX.quote_inv_no%TYPE,
     line_cd                GIPI_QUOTE_INVTAX.line_cd%TYPE,
     iss_cd                 GIPI_QUOTE_INVTAX.iss_cd%TYPE,
     tax_cd                 GIPI_QUOTE_INVTAX.tax_cd%TYPE,
     tax_desc               GIIS_TAX_CHARGES.tax_desc%TYPE,
     tax_amt                GIPI_QUOTE_INVTAX.tax_amt%TYPE,
     tax_id                 GIPI_QUOTE_INVTAX.tax_id%TYPE,
     rate                   GIPI_QUOTE_INVTAX.rate%TYPE,
     item_grp               GIPI_QUOTE_INVTAX.item_grp%TYPE,
     fixed_tax_alloc        GIPI_QUOTE_INVTAX.fixed_tax_allocation%TYPE,
     tax_allocation         GIPI_QUOTE_INVTAX.tax_allocation%TYPE,
     primary_sw             GIIS_TAX_CHARGES.primary_sw%TYPE,
     peril_sw               GIIS_TAX_CHARGES.peril_sw%TYPE,
     no_rate_tag            GIIS_TAX_CHARGES.no_rate_tag%TYPE
  );
  TYPE gipi_quote_invtax_tab2 IS TABLE OF gipi_quote_invtax_type2;
  
  FUNCTION get_gipi_quote_invtax(p_quote_inv_no           GIPI_QUOTE_INVTAX.quote_inv_no%TYPE,
                                 p_iss_cd                 GIPI_QUOTE_INVTAX.iss_cd%TYPE)
    RETURN gipi_quote_invtax_tab PIPELINED;
    
  FUNCTION get_gipi_quote_invtax2(p_quote_inv_no           GIPI_QUOTE_INVTAX.quote_inv_no%TYPE,
                                  p_iss_cd                 GIPI_QUOTE_INVTAX.iss_cd%TYPE,
                                  p_tax_amt                GIPI_QUOTE_INVTAX.tax_amt%TYPE,
                                  p_tax_desc               GIIS_TAX_CHARGES.tax_desc%TYPE)
    RETURN gipi_quote_invtax_tab2 PIPELINED;
    
  PROCEDURE set_gipi_quote_invtax(
    p_quote_id              GIPI_QUOTE.quote_id%TYPE,
    p_quote_inv_no          GIPI_QUOTE_INVTAX.quote_inv_no%TYPE,
    p_line_cd               GIPI_QUOTE_INVTAX.line_cd%TYPE,
    p_iss_cd                GIPI_QUOTE_INVTAX.iss_cd%TYPE,
    p_tax_cd                GIPI_QUOTE_INVTAX.tax_cd%TYPE,
    p_tax_amt               GIPI_QUOTE_INVTAX.tax_amt%TYPE,
    p_tax_id                GIPI_QUOTE_INVTAX.tax_id%TYPE,
    p_rate                  GIPI_QUOTE_INVTAX.rate%TYPE,
    p_item_grp              GIPI_QUOTE_INVTAX.item_grp%TYPE,
    p_fixed_tax_allocation  GIPI_QUOTE_INVTAX.fixed_tax_allocation%TYPE,
    p_tax_allocation        GIPI_QUOTE_INVTAX.tax_allocation%TYPE
  );
  
  PROCEDURE delete_gipi_quote_invtax(
    p_quote_inv_no          GIPI_QUOTE_INVTAX.quote_inv_no%TYPE,
    p_line_cd               GIPI_QUOTE_INVTAX.line_cd%TYPE,
    p_iss_cd                GIPI_QUOTE_INVTAX.iss_cd%TYPE,
    p_tax_cd                GIPI_QUOTE_INVTAX.tax_cd%TYPE,
	p_tax_id                GIPI_QUOTE_INVTAX.tax_id%TYPE
  );
  
END GIPI_QUOTE_INVTAX_PKG;
/


