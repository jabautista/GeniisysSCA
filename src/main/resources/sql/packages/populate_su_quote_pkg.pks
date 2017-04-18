CREATE OR REPLACE PACKAGE CPI.POPULATE_SU_QUOTE_PKG AS
/******************************************************************************
   NAME:       POPULATE_SU_QUOTE_PKG
   PURPOSE:
   MODULE:     GIIMM006

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/08/2012   Christian        1. Created this package.
******************************************************************************/

  TYPE su_quote_type IS RECORD(
       assd_name        giis_assured.assd_name%TYPE,
       assd_add1        VARCHAR2(50),
       assd_add2        VARCHAR2(50),
       assd_add3        VARCHAR2(50),
       incept           VARCHAR2(20),
       expiry           VARCHAR2(20),
       bond_amt         VARCHAR2(25),    
       premium          VARCHAR2(25),
       prem_amt         GIPI_QUOTE_ITEM.prem_amt%TYPE,
       total_amt        GIPI_QUOTE_ITEM.prem_amt%TYPE,
       user_id          VARCHAR2(30),
       line_cd          GIPI_QUOTE.line_cd%TYPE,
       subline_cd       GIPI_QUOTE.subline_cd%TYPE,
       header           GIPI_QUOTE.header%TYPE,
       footer           GIPI_QUOTE.footer%TYPE,
       obligee          VARCHAR2(100),
       principal        VARCHAR2(100),
       quote_no         VARCHAR2(50),
       position         VARCHAR2(50),
       designation      VARCHAR2(50));
  
  TYPE su_quote_tab IS TABLE OF su_quote_type;
  
  FUNCTION populate_bonds_quotation(p_quote_id GIPI_QUOTE.quote_id%TYPE, p_position VARCHAR2, p_designation VARCHAR2)
  RETURN su_quote_tab PIPELINED;
    
  TYPE su_quote_tax_type IS RECORD(
       tax_cd             gipi_quote_invtax.tax_cd%TYPE,
       tax_desc           giis_tax_charges.tax_desc%TYPE,
       tax_amt            VARCHAR2(30));
    
  TYPE su_quote_tax_tab IS TABlE OF su_quote_tax_type;
    
  FUNCTION get_su_quote_tax(p_quote_id GIPI_QUOTE.quote_id%TYPE, p_line_cd GIPI_QUOTE.line_cd%TYPE)
  RETURN su_quote_tax_tab PIPELINED;
    
END POPULATE_SU_QUOTE_PKG;
/


