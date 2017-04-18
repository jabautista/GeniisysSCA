CREATE OR REPLACE PACKAGE CPI.QUOTE_REPORTS_EN_PKG AS
/******************************************************************************
   NAME:       QUOTE_REPORTS_EN_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/1/2010             1. Created this package.
******************************************************************************/

TYPE en_quote_details_type IS RECORD (
    assd_name                giis_assured.assd_name%TYPE,
    assd_add1                varchar2(50),
    assd_add2                varchar2(50),
    assd_add3                varchar2(50),
    agent_name               varchar2(50),
    subline_cd               varchar2(25),
    subline_name             varchar2(50),    
    incept                   varchar2(30),
    expiry                   varchar2(30),
    accept_dt                varchar2(30),   
    prem_amt1                number(16,2),     
    tax                      varchar2(30),
    tot_amt                     number(16,2),   
    quote_num                varchar2(50),
    item_no                  number,   
    doc_name                 giis_parameters.param_value_v%TYPE,   
    --end_remarks                 varchar2(25),    
    end_remarks                 gipi_quote.remarks%TYPE,--(gino) 5.13.11
    HEADER                     gipi_quote.HEADER%TYPE,
    footer                     gipi_quote.footer%TYPE,
    item                     varchar2(50),    
    item_title               varchar2(50),
    peril                    varchar2(50), 
    peril1                   varchar2(50),     
    tsi                      varchar2(25),     
    n                         varchar2(50),
    itemno                   varchar2(50),  
    M                         number,
    dash                     varchar2(3),
    business                 varchar2(300),
    site                     varchar2(300),  
    taxes                     varchar2(30),
    tax_amt                     varchar2(25),
    tax_cd                   varchar2(25),
    ded_title                varchar2(50),
    ded_amt                  varchar2(25),
    ded_rt                   varchar2(25),
    deduct                   varchar2(25),
    ded_txt                  varchar2(2000),
    warranty                 varchar2(5000),
    warranty_text            varchar2(5000),
    logo_file                GIIS_PARAMETERS.param_value_v%TYPE,
    valid_date               varchar2(15),                             ---------------------------
    line_cd                  varchar2(2),                              ---------------------------
    iss_cd                   varchar2(2),                              ---added by gino 5.13.11---
    signatory                giis_signatory_names.signatory%TYPE,      ---------------------------
    designation              giis_signatory_names.designation%TYPE,    ---------------------------
    duration                 number,                                   --------5.16.11------------
    short_name               giis_currency.short_name%TYPE,
    warranty_cd              giis_warrcla.main_wc_cd%type,
    tsi_amt1                 number(16,2) 
);
  
    TYPE en_quote_details_tab IS TABLE OF en_quote_details_type;
   
FUNCTION get_en_quote_details (p_quote_id GIPI_QUOTE.quote_id%TYPE) RETURN en_quote_details_tab PIPELINED;


    TYPE en_quote_item_tab IS TABLE OF en_quote_details_type;
   
FUNCTION get_en_quote_item (p_quote_id GIPI_QUOTE.quote_id%TYPE) RETURN en_quote_item_tab PIPELINED;


    TYPE en_quote_item_cic_tab IS TABLE OF en_quote_details_type;
   
FUNCTION get_en_quote_item_cic (p_quote_id GIPI_QUOTE.quote_id%TYPE) RETURN en_quote_item_cic_tab PIPELINED;


    TYPE en_quote_business_tab IS TABLE OF en_quote_details_type;

FUNCTION get_en_quote_business (p_quote_id GIPI_QUOTE.quote_id%TYPE) RETURN en_quote_business_tab PIPELINED;


    TYPE en_quote_item_peril_tab IS TABLE OF en_quote_details_type;

FUNCTION get_en_quote_item_peril (p_quote_id GIPI_QUOTE.quote_id%TYPE, p_item_no GIPI_QUOTE_ITEM.item_no%TYPE) RETURN en_quote_item_peril_tab PIPELINED;


    TYPE en_quote_peril_cic_tab IS TABLE OF en_quote_details_type;

FUNCTION get_en_quote_peril_cic (p_quote_id GIPI_QUOTE.quote_id%TYPE, p_item_no GIPI_QUOTE_ITEM.item_no%TYPE) RETURN en_quote_peril_cic_tab PIPELINED;


    TYPE en_quote_tax_tab IS TABLE OF en_quote_details_type;

FUNCTION get_en_quote_tax (p_quote_id GIPI_QUOTE.quote_id%TYPE) RETURN en_quote_tax_tab PIPELINED;


    TYPE en_quote_deductible_tab IS TABLE OF en_quote_details_type;

FUNCTION get_en_quote_deductible (p_quote_id GIPI_QUOTE.quote_id%TYPE, p_subline_cd GIPI_QUOTE.subline_cd%TYPE) RETURN en_quote_deductible_tab PIPELINED;


    TYPE en_quote_warranty_tab IS TABLE OF en_quote_details_type;

FUNCTION get_en_quote_warranty (p_quote_id GIPI_QUOTE.quote_id%TYPE) RETURN en_quote_warranty_tab PIPELINED;


    TYPE en_quote_warranty_text_tab IS TABLE OF en_quote_details_type;

FUNCTION get_en_quote_warranty_text (p_quote_id GIPI_QUOTE.quote_id%TYPE, p_warranty GIPI_QUOTE_WC.wc_title%TYPE) RETURN en_quote_warranty_text_tab PIPELINED;


    TYPE en_quote_peril_seici_tab IS TABLE OF en_quote_details_type;

FUNCTION get_en_quote_peril_seici (p_quote_id GIPI_QUOTE.quote_id%TYPE) RETURN en_quote_peril_seici_tab PIPELINED;

END QUOTE_REPORTS_EN_PKG;
/


