CREATE OR REPLACE PACKAGE CPI.POPULATE_EN_QUOTE_PKG AS

/******************************************************************************
   NAME:       POPULATE_EN_QUOTE_PKG - GIIMM006
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        3/08/2012    Nikko           1. Created this package.
******************************************************************************/

TYPE quote_en_type IS RECORD(
  assd_name                GIIS_ASSURED.assd_name%TYPE,
  assd_add1                VARCHAR2(50),
  assd_add2                VARCHAR2(50),
  assd_add3                VARCHAR2(50),
  quote_num                VARCHAR2(50),
  incept                   VARCHAR2(30),
  expiry                   VARCHAR2(30),
  HEADER                   GIPI_QUOTE.HEADER%TYPE,
  footer                   GIPI_QUOTE.footer%TYPE,
  attn_position            VARCHAR2(200),
  designation              VARCHAR2(200),
  line_cd                  GIPI_QUOTE.line_cd%TYPE,
  subline_cd               GIPI_QUOTE.subline_cd%TYPE,  
  --item_title               VARCHAR2(50),
  business                 VARCHAR2(100),
  site                     VARCHAR2(100),
  prem_amt                 VARCHAR(30),
  tot_prem                 VARCHAR(30),
  tax                      NUMBER(16,2)                
);

TYPE quote_en_tab IS TABLE OF quote_en_type;

TYPE quote_en_item_title_type IS RECORD(
  item_title        VARCHAR2(50)
);

TYPE quote_en_item_title_tab IS TABLE OF quote_en_item_title_type;

TYPE quote_en_itmperil_type IS RECORD(
  peril_name        VARCHAR2(50),
  tsi_amt           VARCHAR2(25)
);

TYPE quote_en_itmperil_tab IS TABLE OF quote_en_itmperil_type;

TYPE quote_en_invtax_type IS RECORD(
  tax_desc      VARCHAR2(30),
  tax_amt       VARCHAR2(25)   
);

TYPE quote_en_invtax_tab IS TABLE OF quote_en_invtax_type;

TYPE quote_en_deductible_type IS RECORD(
  title          VARCHAR2(50),
  rate           VARCHAR2(25),
  amt            VARCHAR2(25),
  deduct         VARCHAR2(25),
  text           VARCHAR2(2000)
);

TYPE quote_en_deductible_tab IS TABLE OF quote_en_deductible_type;

TYPE quote_en_wc_type IS RECORD(
  wc_title            GIPI_QUOTE_WC.wc_title%TYPE,
  wc_text             VARCHAR2(6000)
);

TYPE quote_en_wc_tab IS TABLE OF quote_en_wc_type;

FUNCTION populate_engineering_quotation(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                                        p_attn_position VARCHAR2,
                                        p_designation   VARCHAR2)
  RETURN quote_en_tab PIPELINED;

FUNCTION get_en_quote_item_title(p_quote_id GIPI_QUOTE.quote_id%TYPE)
  RETURN quote_en_item_title_tab PIPELINED;
  
FUNCTION get_en_quote_itmperil(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                               p_line_cd GIPI_QUOTE.line_cd%TYPE)
  RETURN quote_en_itmperil_tab PIPELINED;

FUNCTION get_en_quote_invtax(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                             p_line_cd GIPI_QUOTE.line_cd%TYPE)
  RETURN quote_en_invtax_tab PIPELINED;
  
FUNCTION get_en_quote_deduc(p_quote_id GIPI_QUOTE.quote_id%TYPE,
                            p_line_cd GIPI_QUOTE.line_cd%TYPE,
                            p_subline_cd GIPI_QUOTE.subline_cd%TYPE)
  RETURN quote_en_deductible_tab PIPELINED;

FUNCTION get_en_quote_wc(p_quote_id GIPI_QUOTE.quote_id%TYPE)
  RETURN quote_en_wc_tab PIPELINED;

END POPULATE_EN_QUOTE_PKG;
/


