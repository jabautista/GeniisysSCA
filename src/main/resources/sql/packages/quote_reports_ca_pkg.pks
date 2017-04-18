CREATE OR REPLACE PACKAGE CPI.QUOTE_REPORTS_CA_PKG AS
/******************************************************************************
   NAME:       QUOTE_REPORTS_CA_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/1/2010    irwin         1. Created this package.
   1.1        6/6/2011    bhev          1. Added assd_industry (UCPB)
                                        2. Set item_title to varchar2(2051)
******************************************************************************/


----------COMMON------
  TYPE ca_quote_details_type IS RECORD (
       accept_date        varchar2(50), 
       assd_name        giis_assured.assd_name%TYPE,
       assd_add1        VARCHAR2(50),
       assd_add2        VARCHAR2(50),
       assd_add3        VARCHAR2(50),
       quote_num        VARCHAR2(50),
       ITEM_TITLE       VARCHAR2(50),
       subline_cd       GIPI_QUOTE.subline_cd%TYPE,
       line_cd            GIPI_QUOTE.line_cd%TYPE,
       footer            gipi_quote.footer%TYPE,
       HEADER            gipi_quote.HEADER%TYPE,
       incept            VARCHAR2(20)        := ' ',
       expiry            VARCHAR2(20)        := ' ',
       prem_amt         GIPI_QUOTE_ITEM.prem_amt%TYPE,
       prem1            GIPI_QUOTE_ITEM.prem_amt%TYPE,
       remarks          GIPI_QUOTE.remarks%TYPE,
       subline_name        GIIS_SUBLINE.subline_name%TYPE,
       tot_prem         GIPI_QUOTE_ITEM.prem_amt%TYPE,
       tot_prem_seici   VARCHAR2(100),
       tot_tax          gipi_quote_invtax.tax_amt%TYPE,
       print_sw         varchar2(1),
       currency         giis_currency.short_name%TYPE,
       tsi_amt          GIPI_QUOTE_ITEM.tsi_amt%TYPE,
       tsi_amt_seici    VARCHAR2(100),
       warranty         varchar2(5000),
       logo_file        GIIS_PARAMETERS.param_value_v%TYPE);
        
    TYPE ca_quote_details_tab IS TABLE OF ca_quote_details_type;
   
   FUNCTION get_quote_details_ca(p_quote_id NUMBER) RETURN ca_quote_details_tab PIPELINED;
       
 -- get quote item type FROM GIPI QUOTE ITEM TABLE
  TYPE quote_item_type IS RECORD
   (item_title            GIPI_QUOTE_WC.wc_title%TYPE,
    item_title_make        GIPI_QUOTE_WC.wc_title%TYPE,
    item_no                GIPI_QUOTE_ITMPERIL.item_no%TYPE,
    row_num                NUMBER(4),
    coverage_desc        giis_coverage.coverage_desc%TYPE,
    peril_name GIIS_PERIL.peril_name%TYPE,
    peril_lname GIIS_PERIL.peril_lname%TYPE,
    wrd_rate gipi_quote_itmperil.tsi_amt%TYPE);

  TYPE quote_item_tab IS TABLE OF quote_item_type;
  
  
  FUNCTION get_quote_item(p_quote_id NUMBER)
  RETURN quote_item_tab PIPELINED;
  
  --------- get details from gipi_quote_ca_item
  TYPE quote_ca_item_type IS RECORD
    (LOCATION           GIPI_QUOTE_CA_ITEM.LOCATION%TYPE);
 
  TYPE quote_ca_item_tab IS TABLE OF quote_ca_item_type;
 
  FUNCTION get_quote_ca_item(p_quote_id NUMBER, p_item_no NUMBER) 
  RETURN quote_ca_item_tab PIPELINED;
  
  -- get details from perils table
  TYPE quote_peril_item_type IS RECORD
    (line_cd GIPI_QUOTE.line_cd%TYPE,
     peril_name GIIS_PERIL.peril_name%TYPE,
     peril_lname GIIS_PERIL.peril_lname%TYPE,
     tsi_amt gipi_quote_itmperil.tsi_amt%TYPE,
     v_count1 NUMBER);
     
  TYPE quote_peril_item_tab IS TABLE OF quote_peril_item_type;
     
  FUNCTION get_quote_peril_item(p_quote_id NUMBER, p_line_cd GIPI_QUOTE.line_cd%TYPE,  p_item_no NUMBER)
  RETURN quote_peril_item_tab PIPELINED;
  
  --get deduct from gipi_quote_deductibles , giis_deductible_desc ,
  TYPE quote_deductible_item_type IS RECORD (
         ded_title GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
       ded_text GIIS_DEDUCTIBLE_DESC.deductible_text%TYPE,
       deduct            VARCHAR2(32767),
       title            VARCHAR2(32767),
       text                VARCHAR2(32767));
       
  TYPE quote_deductible_item_tab IS TABLE OF quote_deductible_item_type;
  
  FUNCTION get_quote_deductible(p_quote_id NUMBER, p_line_cd GIPI_QUOTE.line_cd%TYPE, p_subline_cd GIPI_QUOTE.subline_cd%TYPE) 
  RETURN quote_deductible_item_tab PIPELINED;
  
  --gget tax
  TYPE quote_invtax_type IS RECORD
   (tax_cd                gipi_quote_invtax.tax_cd%TYPE,
    tax_desc            giis_tax_charges.tax_desc%TYPE,
    tax_amt                gipi_quote_invtax.tax_amt%TYPE);

  TYPE quote_invtax_tab IS TABLE OF quote_invtax_type;
  
  FUNCTION get_ca_quote_invtax(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_invtax_tab PIPELINED;
 
  --WARRAMTY
  TYPE ca_quote_warranty_type IS RECORD (
       print_sw         varchar2(10),
       warranty         varchar2(5000),
       text1            varchar2(5000),
       text2            varchar2(5000),
       text3            varchar2(5000),
       text4            varchar2(5000),
       text5            varchar2(5000),
       text6            varchar2(5000),
       text7            varchar2(5000),
       text8            varchar2(5000),
       text9            varchar2(5000),
       text10            varchar2(5000),
       text11           varchar2(5000),
       text12            varchar2(5000),
       text13           varchar2(5000),
       text14           varchar2(5000),
       text15           varchar2(5000),
       text16          varchar2(5000),
       text17           varchar2(5000),
       warranty_text    varchar2(5000));
        
    TYPE ca_quote_warranty_tab IS TABLE OF ca_quote_warranty_type;

   FUNCTION get_ca_quote_warranty(p_quote_id    GIPI_QUOTE.quote_id%TYPE)
   RETURN ca_quote_warranty_tab PIPELINED; 
   
   TYPE ca_quote_warranty_text_type IS RECORD (
       warranty_text    GIPI_QUOTE_WC.wc_text01%TYPE);
       
   TYPE ca_quote_warranty_text_tab IS TABLE OF ca_quote_warranty_text_type;
    
   FUNCTION get_ca_quote_warranty_text(p_quote_id GIPI_QUOTE.quote_id%TYPE, p_warranty GIPI_QUOTE_WC.wc_text01%TYPE)
   RETURN ca_quote_warranty_text_tab PIPELINED;
   

   
   ------------CIC------------
  
 -- get quote item/peril items
  TYPE quote_item_cic_type IS RECORD
   (item_title            GIPI_QUOTE_WC.wc_title%TYPE,
    item_title_make        GIPI_QUOTE_WC.wc_title%TYPE,
    item_no                GIPI_QUOTE_ITMPERIL.item_no%TYPE,
    row_num                NUMBER(38),
    coverage_desc        giis_coverage.coverage_desc%TYPE,
    ded_title GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
    ded_text GIIS_DEDUCTIBLE_DESC.deductible_text%TYPE,
    peril_name GIIS_PERIL.peril_name%TYPE,
    peril_lname GIIS_PERIL.peril_lname%TYPE,
    item_tsi gipi_quote_itmperil.tsi_amt%TYPE,
    item_peril_tsi gipi_quote_itmperil.tsi_amt%TYPE,
    currency giis_currency.short_name%TYPE);

  TYPE quote_item_cic_tab IS TABLE OF quote_item_cic_type;
  
  
  FUNCTION get_quote_item_cic(p_quote_id NUMBER,  p_subline_cd GIPI_QUOTE.subline_cd%TYPE)
  RETURN quote_item_cic_tab PIPELINED;
  
   TYPE quote_deductible_item_cic_type IS RECORD (
         ded_title GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
       ded_text GIIS_DEDUCTIBLE_DESC.deductible_text%TYPE,
       deduct            VARCHAR2(32767),
       title            VARCHAR2(32767),
       text                VARCHAR2(32767));
 ----- end of cic      
  TYPE quote_deductible_item_cic_tab IS TABLE OF quote_deductible_item_cic_type;
  
  FUNCTION get_quote_deductible_cic(p_quote_id NUMBER, p_subline_cd GIPI_QUOTE.subline_cd%TYPE, p_item_no GIPI_QUOTE_item.item_no%TYPE) 
  RETURN quote_deductible_item_cic_tab PIPELINED;
   
  -----------SEICI(seaboard)------------
  
  ---location
  TYPE quote_ca_item_seici_type IS RECORD
    (col                VARCHAR2(100),
     LOCATION           GIPI_QUOTE_CA_ITEM.LOCATION%TYPE,
     coverage GIPI_QUOTE_CA_ITEM.limit_of_liability%TYPE,
     v_title2           VARCHAR2(100),
     v_title3           VARCHAR2(100));
 
  TYPE quote_ca_item_seici_tab IS TABLE OF quote_ca_item_seici_type;
 
  FUNCTION get_quote_ca_item_seici(p_quote_id NUMBER) 
  RETURN quote_ca_item_seici_tab PIPELINED;
  
  -- DEDUCTIBLE
  
  TYPE quote_deductible_item_sei_type IS RECORD (
         ded_title GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
       ded_text GIIS_DEDUCTIBLE_DESC.deductible_text%TYPE,
       col                  VARCHAR2(100),
       peril_name           VARCHAR2(32767),
       deduct                VARCHAR2(32767),
       v_title6             VARCHAR2(32767),
       text                    VARCHAR2(32767));
       
  TYPE quote_deductible_item_sei_tab IS TABLE OF quote_deductible_item_sei_type;
  
  FUNCTION get_quote_deductible_sei(p_quote_id NUMBER, p_subline_cd GIPI_QUOTE.subline_cd%TYPE) 
  RETURN quote_deductible_item_sei_tab PIPELINED;

TYPE ca_quote_details_ucpb_type IS RECORD (----------------------------------gino
  ASSD_NAME             VARCHAR2(500 BYTE),
  assd_industry         giis_industry.industry_nm%TYPE,             -- bmq 6/6/2011 
  DESIGNATION           VARCHAR2(5 BYTE),
  LOCATION              VARCHAR2(150 BYTE),
  INTEREST_ON_PREMISES  VARCHAR2(500 BYTE),
  TSI_AMT               NUMBER(16,2),
  DEDUCTIBLE_AMT        NUMBER(16,2),
  item_title            VARCHAR2(50),                                    -- bmq  06/06/2011
  prem_amt              gipi_polbasic.prem_amt%TYPE,
  item_desc             VARCHAR2(2000),
  coverage              giis_coverage.coverage_desc%TYPE,   
  VALID_DATE            varchar2(50),
  QUOTE_ID              NUMBER(12),             
  SUBLINE_NAME          VARCHAR2(30 BYTE),
  subline_cd            giis_subline.subline_cd%TYPE,
  ISS_CD                VARCHAR2(2 BYTE),        
  QUOTE_NO              VARCHAR2(67 BYTE),
  HEADER                VARCHAR2(2000 BYTE),
  FOOTER                VARCHAR2(2000 BYTE),
  INCEPT_DATE           varchar2(50),                    
  EXPIRY_DATE           varchar2(50),                   
  ACCEPT_DT             varchar2(50),
  ADDRESS               VARCHAR2(3000 BYTE),
  REMARKS               VARCHAR2(4000 BYTE),
  LINE_CD               VARCHAR2(2 BYTE),
  item_no               gipi_quote_ca_item.item_no%TYPE,
  tsi_amt_per_item      NUMBER(16,2), --added by steven 1.25.2012
  prem_amt_per_item     NUMBER(16,2),
  short_name2			VARCHAR2(10));
  
TYPE ca_quote_details_ucpb_tab IS TABLE OF ca_quote_details_ucpb_type;

FUNCTION get_quote_details_ca_ucpb (p_quote_id NUMBER,p_item_no NUMBER)
   RETURN ca_quote_details_ucpb_tab PIPELINED;

TYPE quote_ca_tax_type IS RECORD(                         
  tax_desc      giis_tax_charges.tax_desc%TYPE,  
  tax_amt       gipi_quote_invoice.tax_amt%TYPE,  
  orig_tax_amt  gipi_quote_invoice.tax_amt%TYPE, --added by steven 1.25.2013
  prem_amt      gipi_quote_invoice.prem_amt%TYPE,  
  short_name    giis_currency.short_name%TYPE,             
  total         NUMBER                               
);                                                              
TYPE quote_ca_tax_tab IS TABLE OF quote_ca_tax_type;  

FUNCTION get_quote_tax_ca_ucpb(p_quote_id NUMBER)
  RETURN quote_ca_tax_tab PIPELINED;
  
TYPE casualty_signatory_type IS RECORD(                         
 sig_name                giis_signatory_names.signatory%TYPE,   
 sig_des                 giis_signatory_names.designation%TYPE                                                          
);                                                              
TYPE casualty_signatory_tab IS TABLE OF casualty_signatory_type;  

  FUNCTION get_casualty_signatory(p_line_cd VARCHAR2, p_iss_cd VARCHAR2)
  RETURN casualty_signatory_tab PIPELINED;

  TYPE quote_peril_item_ucpb_type IS RECORD
    (line_cd        GIPI_QUOTE.line_cd%TYPE,
     peril_name     GIIS_PERIL.peril_name%TYPE,
     peril_lname    GIIS_PERIL.peril_lname%TYPE,
     short_name     giis_currency.short_name%TYPE,
     tsi_amt        VARCHAR2(50)
     );
     
  TYPE quote_peril_item_ucpb_tab IS TABLE OF quote_peril_item_ucpb_type;
     
  FUNCTION get_quote_peril_item_ucpb(p_quote_id NUMBER, p_line_cd GIPI_QUOTE.line_cd%TYPE,  p_item_no NUMBER)
    RETURN quote_peril_item_ucpb_tab PIPELINED;------------------------------------------end gino

  type quote_deductible_ucpb_type is record 
  (
       ded_title            GIIS_DEDUCTIBLE_DESC.deductible_title%type,
       ded_text             GIIS_DEDUCTIBLE_DESC.deductible_text%type,
       item_no              gipi_quote_deductibles.item_no%type,
       peril_cd             gipi_quote_deductibles.peril_cd%type,
       ded_amt              gipi_quote_deductibles.deductible_amt%type,
       ded_rt               gipi_quote_deductibles.deductible_rt%type
       );  
  type quote_deductible_ucpb_tab is table of quote_deductible_ucpb_type;
  
  function get_quote_deductible_ucpb(p_quote_id number, p_item_no number)
    return quote_deductible_ucpb_tab pipelined;
    
END QUOTE_REPORTS_CA_PKG;
/


