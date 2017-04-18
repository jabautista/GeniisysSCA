CREATE OR REPLACE PACKAGE CPI.QUOTE_REPORTS_AH_PKG AS
   
   TYPE quote_ah_type IS RECORD
   (
    quote_no             VARCHAR2(50),
    assd_name            GIIS_ASSURED.assd_name%TYPE,
    address1             varchar2(200),
    address2             varchar2(200),
    address3             varchar2(200),
    incept_date          varchar2(50),
    incept_date1         varchar2(50),
    expiry_date1         varchar2(50),
    expiry_date          varchar2(50),
    header               GIPI_QUOTE.header%TYPE,
    footer               GIPI_QUOTE.footer%TYPE,
    accept_dt            GIPI_QUOTE.accept_dt%TYPE,
    incept_tag           GIPI_QUOTE.incept_tag%TYPE, 
    expiry_tag           GIPI_QUOTE.expiry_tag%TYPE,
    tsi_amt              varchar2(50),
    remarks              GIPI_QUOTE.remarks%TYPE,
    line_cd              GIPI_QUOTE.line_cd%TYPE,
    subline_cd           GIPI_QUOTE.subline_cd%TYPE,          
    title                varchar2(50),
    title1               varchar2(50),
    occupation           varchar2(50),
    title2               varchar2(50),
    destination          varchar2(200),
    title3               varchar2(50),
    no_of_persons        varchar2(50),
    position             varchar2(50),
    title4               varchar2(50),
    prem_amt             GIPI_QUOTE_ITEM.tsi_amt%TYPE,
    total                varchar2(100),
    wc_title             gipi_quote_wc.wc_title%TYPE,
    user_id              varchar2(50)

	);

  TYPE quote_ah_tab IS TABLE OF quote_ah_type;

  FUNCTION get_ah_quote(p_quote_id		GIPI_QUOTE.quote_id%TYPE) 
    RETURN quote_ah_tab PIPELINED;
    
    
   TYPE ah_quote_invtax_type is RECORD(
   
   tax_desc             GIIS_TAX_CHARGES.tax_desc%TYPE,
   tax_amt_num          GIPI_QUOTE_INVTAX.tax_amt%TYPE,
   tax_amt              varchar2(200)   
   
   );
   TYPE ah_quote_invtax_tab IS TABLE OF ah_quote_invtax_type;     

  FUNCTION get_ah_quote_invtax(p_quote_id  GIPI_QUOTE.quote_id%TYPE)    
     RETURN ah_quote_invtax_tab PIPELINED; 

  TYPE ah_quote_perils_type IS RECORD(
  
  peril_name           varchar2(2000),
  tsi_amt              varchar2(200)
  );
  TYPE ah_quote_perils_tab IS TABLE OF ah_quote_perils_type;

  FUNCTION get_ah_quote_perils(p_quote_id  GIPI_QUOTE.quote_id%TYPE)    
     RETURN ah_quote_perils_tab PIPELINED; 
     
  
  TYPE ah_quote_warranty_type IS RECORD(
  
  wc_title             varchar2(2000),
  print_sw             GIPI_QUOTE_WC.print_sw%TYPE
  );
  TYPE ah_quote_warranty_tab IS TABLE OF ah_quote_warranty_type;
  
  FUNCTION get_ah_quote_warranty(p_quote_id    GIPI_QUOTE.quote_id%TYPE)
     RETURN ah_quote_warranty_tab PIPELINED;   

END QUOTE_REPORTS_AH_PKG;
/


