CREATE OR REPLACE PACKAGE CPI.QUOTE_REPORTS_PA_PKG AS

/******************************************************************************
   NAME:       QUOTE_REPORTS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        4/19/2011   Windell Valle    Created this package.
******************************************************************************/

TYPE quote_pa_details_type IS RECORD(
       assd_name        giis_assured.assd_name%TYPE,
       assd_add1        VARCHAR2(50),
       assd_add2        VARCHAR2(50),
       assd_add3        VARCHAR2(50),
       address          VARCHAR2(200),
       HEADER           gipi_quote.HEADER%TYPE,
       footer           gipi_quote.footer%TYPE,
       accept_dt        VARCHAR2(50),
       valid            VARCHAR2(30):= ' ',
       incept           VARCHAR2(30):= ' ',
       expiry           VARCHAR2(30):= ' ',
       line_cd          gipi_quote.LINE_CD%TYPE,
       subline_cd       gipi_quote.subline_cd%TYPE,
       line_name        giis_line.LINE_NAME%TYPE,
       subline_name     giis_subline.SUBLINE_NAME%TYPE,
       remarks          gipi_quote.remarks%TYPE,
       iss_cd           gipi_quote.iss_cd%TYPE,
       loc_add          VARCHAR2(200),
       item_no          VARCHAR2(50),
       item_title       VARCHAR2(200),
       tsi_amt          VARCHAR2(200),
       tot_amt          VARCHAR2(200),
       prem_amt         gipi_quote.prem_amt%TYPE,           -- bmq
       logo_file        GIIS_PARAMETERS.param_value_v%TYPE
);
TYPE quote_pa_details_tab IS TABLE OF quote_pa_details_type;


TYPE accident_signatory_type IS RECORD(
 sig_name                giis_signatory_names.signatory%TYPE,
 sig_des                 giis_signatory_names.designation%TYPE
);
TYPE accident_signatory_tab IS TABLE OF accident_signatory_type;


TYPE quote_pa_items_type IS RECORD(
 item_no                gipi_quote_item.item_no%TYPE,
 item_title             gipi_quote_item.item_title%TYPE
);
TYPE quote_pa_items_tab IS TABLE OF quote_pa_items_type;


TYPE quote_pa_perils_type IS RECORD(
  peril_name    giis_peril.peril_lname%TYPE,
  tsi_amt       gipi_quote_itmperil.tsi_amt%TYPE,
  prem_amt      gipi_quote_itmperil.prem_amt%TYPE,
  short_name    giis_currency.short_name%TYPE
);
TYPE quote_pa_perils_tab IS TABLE OF quote_pa_perils_type;


TYPE quote_pa_clauses_type IS RECORD(
  wc_title      gipi_quote_wc.wc_title%TYPE
);
TYPE quote_pa_clauses_tab IS TABLE OF quote_pa_clauses_type;


TYPE quote_pa_tax_type IS RECORD(
  tax_desc      giis_tax_charges.tax_desc%TYPE,
  tax_amt       gipi_quote_invoice.tax_amt%TYPE,
  prem_amt      gipi_quote_invoice.prem_amt%TYPE,
  short_name    giis_currency.short_name%TYPE
);
TYPE quote_pa_tax_tab IS TABLE OF quote_pa_tax_type;


FUNCTION get_quote_details_pa_ucpb(p_quote_id NUMBER) RETURN quote_pa_details_tab PIPELINED;

FUNCTION get_accident_signatory(p_quote_id NUMBER, p_iss_cd VARCHAR2) RETURN accident_signatory_tab PIPELINED;

FUNCTION get_quote_items_pa_ucpb(p_quote_id NUMBER) RETURN quote_pa_items_tab PIPELINED;

FUNCTION get_quote_perils_pa_ucpb(p_quote_id NUMBER, p_item_no NUMBER) RETURN quote_pa_perils_tab PIPELINED;

FUNCTION get_quote_clauses_pa_ucpb(p_quote_id NUMBER) RETURN quote_pa_clauses_tab PIPELINED;

FUNCTION get_quote_tax_pa_ucpb(p_quote_id NUMBER) RETURN quote_pa_tax_tab PIPELINED;
    
END QUOTE_REPORTS_PA_PKG;
/


