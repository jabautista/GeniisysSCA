CREATE OR REPLACE PACKAGE CPI.QUOTE_REPORTS_SU_PKG AS

  /*    Created by: BRYAN JOSEPH ABULUYAN
   *    Date: March 8, 2011
   */
  TYPE quote_su_type IS RECORD(
    quote_no            VARCHAR2(50),
    assd_name           GIPI_QUOTE.assd_name%TYPE,
    assd_add1           GIPI_QUOTE.address1%TYPE,
    assd_add2           GIPI_QUOTE.address2%TYPE,
    assd_add3           GIPI_QUOTE.address3%TYPE,
    bond_dtl            GIPI_QUOTE_BOND_BASIC.bond_dtl%TYPE,
    expiry_dt           VARCHAR2(20),
    expiry_tag          GIPI_QUOTE.expiry_tag%TYPE,
    footer              GIPI_QUOTE.footer%TYPE,
    HEADER              GIPI_QUOTE.HEADER%TYPE,
    incept_dt           VARCHAR2(20),
    incept_tag          GIPI_QUOTE.incept_tag%TYPE,
    logo_file           GIIS_PARAMETERS.param_value_v%TYPE,
    obligee_name        GIIS_OBLIGEE.obligee_name%TYPE,
    prem_amt            GIPI_QUOTE.prem_amt%TYPE,
    short_name          GIIS_CURRENCY.short_name%TYPE,
    subline_name        GIIS_SUBLINE.subline_name%TYPE,
    today               VARCHAR2(20),
    total_premium       GIPI_QUOTE.prem_amt%TYPE,
    tsi_amt             GIPI_QUOTE.tsi_amt%TYPE,
    user_id             GIIS_USERS.user_id%TYPE,
    accept_dt           VARCHAR2(50), --* Added by Windell; April 25, 2011; For UCPB
    tsi_amt_str         VARCHAR2(200), --* Added by Windell; April 25, 2011; For UCPB
    total_premium_str   VARCHAR2(200), --* Added by Windell; April 25, 2011; For UCPB
    tax_amt            gipi_quote_invoice.tax_amt%TYPE,
    period                VARCHAR2(32767));

  TYPE quote_su_tab IS TABLE OF quote_su_type;
  
  /*Added by   : Gelo Paragas
  **Date       : Feb. 7, 2013
  **Description: For PhilFire
  */
   TYPE quote_su_type_philfire IS RECORD(
    quote_no            VARCHAR2(50),
    assd_name           GIPI_QUOTE.assd_name%TYPE,
    assd_add1           GIPI_QUOTE.address1%TYPE,
    assd_add2           GIPI_QUOTE.address2%TYPE,
    assd_add3           GIPI_QUOTE.address3%TYPE,
    bond_dtl            GIPI_QUOTE_BOND_BASIC.bond_dtl%TYPE,
    expiry_dt           VARCHAR2(20),
    expiry_tag          GIPI_QUOTE.expiry_tag%TYPE,
    footer              GIPI_QUOTE.footer%TYPE,
    HEADER              GIPI_QUOTE.HEADER%TYPE,
    incept_dt           VARCHAR2(20),
    incept_tag          GIPI_QUOTE.incept_tag%TYPE,
    logo_file           GIIS_PARAMETERS.param_value_v%TYPE,
    obligee_name        GIIS_OBLIGEE.obligee_name%TYPE,
    prem_amt            GIPI_QUOTE_ITEM.PREM_AMT%TYPE,
    short_name          GIIS_CURRENCY.short_name%TYPE,
    subline_name        GIIS_SUBLINE.subline_name%TYPE,
    today               VARCHAR2(20),
    total_premium       GIPI_QUOTE.prem_amt%TYPE,
    tsi_amt             GIPI_QUOTE_ITEM.TSI_AMT%TYPE,
    user_id             GIIS_USERS.user_id%TYPE,
    accept_dt           VARCHAR2(50), 
    tsi_amt_str         VARCHAR2(200), 
    total_premium_str   VARCHAR2(200), 
    tax_amt            gipi_quote_invoice.tax_amt%TYPE,
    period                VARCHAR2(32767));

  TYPE quote_su_tab_philfire IS TABLE OF quote_su_type_philfire;
  

  FUNCTION get_su_quote(p_quote_id GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_su_tab PIPELINED;
    
  FUNCTION get_su_quote_ucpb(p_quote_id      GIPI_QUOTE.quote_id%TYPE) --added by steven 01.25.2013 for UCPB
    RETURN quote_su_tab PIPELINED;
  FUNCTION get_su_quote_philfire(p_quote_id      GIPI_QUOTE.quote_id%TYPE) --added by gelo 02.7.2013 for PHILFIRE
    RETURN quote_su_tab_philfire PIPELINED;

END QUOTE_REPORTS_SU_PKG;
/


