CREATE OR REPLACE PACKAGE CPI.POPULATE_AC_QUOTE_PKG AS

/******************************************************************************
   NAME:       POPULATE_AC_QUOTE_PKG - GIIMM006
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/08/2012    Nikko           1. Created this package.
******************************************************************************/


TYPE quote_accident_type IS RECORD
 (
  assd_name               VARCHAR2(50),
  assd_add1               VARCHAR2(50),
  assd_add2               VARCHAR2(50),
  assd_add3               VARCHAR2(50),
  address                 VARCHAR2(200),
  incept                  VARCHAR2(20),
  expiry                  VARCHAR2(20),
  footer                  GIPI_QUOTE.footer%TYPE,
  HEADER                  GIPI_QUOTE.HEADER%TYPE,
  attn_position           VARCHAR2(200),
  designation             VARCHAR2(200),
  quote_num               VARCHAR2(50),
  line_cd                 GIPI_QUOTE.line_cd%TYPE,
  prem_amt                VARCHAR(30),
  tot_prem                VARCHAR(30),
  tot_tax                 NUMBER(16,2)  
 );
 
TYPE quote_accident_tab IS TABLE OF quote_accident_type;
 
TYPE quote_accident_item_type IS RECORD(
  no_person       VARCHAR2(30),
  destination     VARCHAR2(200),
  position        VARCHAR2(50)
);

TYPE quote_accident_item_tab IS TABLE OF quote_accident_item_type;
 
TYPE quote_pa_itmperil_type IS RECORD(
  peril_title   GIIS_PERIL.peril_lname%TYPE,
  tsi_amt       VARCHAR2(30)

);

TYPE quote_pa_itmperil_tab IS TABLE OF quote_pa_itmperil_type;

TYPE quote_pa_invtax_type IS RECORD(
  tax_desc      VARCHAR2(30),
  tax_amt       VARCHAR2(25)   
);

TYPE quote_pa_invtax_tab IS TABLE OF quote_pa_invtax_type;

  
TYPE quote_accident_wc_type IS RECORD(
  wc_title       GIPI_QUOTE_WC.wc_title%TYPE,
  wc_text        VARCHAR2(4000)
);

TYPE quote_accident_wc_tab IS TABLE OF quote_accident_wc_type;

FUNCTION populate_accident_quotation(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                                     p_attn_position VARCHAR2,
                                     p_designation   VARCHAR2)
 
  RETURN quote_accident_tab PIPELINED;
     
FUNCTION populate_pa_quote_item(p_quote_id GIPI_QUOTE.quote_id%TYPE)
 
  RETURN quote_accident_item_tab PIPELINED;
 
FUNCTION get_pa_quote_itmperil(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                               p_line_cd GIIS_PERIL.line_cd%TYPE)

  RETURN quote_pa_itmperil_tab PIPELINED;

FUNCTION populate_pa_quote_invtax(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                                  p_line_cd GIIS_PERIL.line_cd%TYPE)

  RETURN quote_pa_invtax_tab PIPELINED;

FUNCTION populate_pa_quote_wc(p_quote_id GIPI_QUOTE.quote_id%TYPE)
  
  RETURN quote_accident_wc_tab PIPELINED;
  
END POPULATE_AC_QUOTE_PKG;
/


