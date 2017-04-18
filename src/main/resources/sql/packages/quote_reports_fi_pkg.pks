CREATE OR REPLACE PACKAGE CPI.QUOTE_REPORTS_FI_PKG AS

/******************************************************************************
   NAME:       QUOTE_REPORTS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        5/31/2010   rencela          Created this package.
******************************************************************************/

TYPE quote_fi_details_type IS RECORD(
       assd_name        giis_assured.assd_name%TYPE,
       assd_add1        VARCHAR2(50),
       assd_add2        VARCHAR2(50),
       assd_add3        VARCHAR2(50),
       footer            gipi_quote.footer%TYPE,
       HEADER            gipi_quote.HEADER%TYPE,
       incept            VARCHAR2(30),
       expiry            VARCHAR2(30),
       line_cd            gipi_quote.LINE_CD%TYPE,
       subline_cd        gipi_quote.subline_cd%TYPE,
       accept_dt        VARCHAR2(50),
       remarks            gipi_quote.remarks%TYPE,
       logo_file        GIIS_PARAMETERS.param_value_v%TYPE,
       iss_cd           gipi_quote.iss_cd%TYPE, --* Added by Windell; For UCPB; April 15, 2011
       loc_add          VARCHAR2(200),          --* Added by Windell; For UCPB; April 15, 2011
       item_title       VARCHAR2(200),          --* Added by Windell; For UCPB; April 15, 2011
       tsi_amt          VARCHAR2(200),          --* Added by Windell; For UCPB; April 15, 2011
       tot_amt          VARCHAR2(200),          --* Added by Windell; For UCPB; April 15, 2011
       occupancy_desc   GIIS_FIRE_OCCUPANCY.occupancy_desc%TYPE
);

TYPE quote_fi_details_tab IS TABLE OF quote_fi_details_type;

TYPE quote_fi_item_details_type IS RECORD(
     v_title            VARCHAR2(200),--GIPI_QUOTE_WC.wc_title%TYPE,
     v_colon            VARCHAR2(100),
     v_value            VARCHAR2(2000),
     v_currency         VARCHAR2(100),--GIIS_CURRENCY.short_name%TYPE,
     v_amount            VARCHAR2(200),
     v_prem                NUMBER(15,2),
     v_prem_currency    VARCHAR2(10)
);

TYPE quote_fi_item_tab IS TABLE OF quote_fi_item_details_type;


TYPE warranty_text_type IS RECORD(
    warranty_title        GIPI_QUOTE_WC.WC_TITLE%TYPE,
    TEXT1                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT2                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT3                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT4                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT5                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT6                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT7                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT8                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT9                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT10                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT11                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT12                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT13                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT14                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT15                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT16                GIPI_QUOTE_WC.WC_TEXT01%TYPE,
    TEXT17                GIPI_QUOTE_WC.WC_TEXT01%TYPE
  );

  TYPE warranty_text_tab IS TABLE OF warranty_text_type;

  TYPE fire_signatory_type IS RECORD(                            --********************
    sig_name                giis_signatory_names.signatory%TYPE,   --* Added by Windell *
    sig_des                giis_signatory_names.designation%TYPE  --* April 15, 2011    *
  );                                                             --* UCPB             *

  TYPE fire_signatory_tab IS TABLE OF fire_signatory_type;       --********************

  TYPE quote_fi_itemperil_type IS RECORD
   (item_no                VARCHAR2(20),
    peril_name             giis_peril.PERIL_NAME%TYPE,
    peril_lname            giis_peril.PERIL_LNAME%TYPE,
    prem_amt               gipi_quote_itmperil.prem_amt%TYPE,
    tsi_amt                gipi_quote_itmperil.tsi_amt%TYPE,
    short_name             giis_currency.short_name%TYPE);
   
  TYPE quote_fi_itemperil_tab IS TABLE OF quote_fi_itemperil_type;

  FUNCTION get_quote_details_fi_cic(p_quote_id NUMBER) RETURN quote_fi_details_tab PIPELINED;

  FUNCTION get_quote_details_fi_cic_items(p_quote_id NUMBER) RETURN quote_fi_item_tab PIPELINED;

  FUNCTION get_quote_details_fi_fpac(p_quote_id NUMBER) RETURN quote_fi_details_tab PIPELINED;

  FUNCTION get_quote_details_fi_ucpb(p_quote_id NUMBER) RETURN quote_fi_details_tab PIPELINED; --* Added by Windell; For UCPB; April 15, 2011

  TYPE loc_risk_type IS RECORD(
     LOC_RISK       VARCHAR2(500)
  );

  TYPE loc_risk_tab IS TABLE OF loc_risk_type;  -- test

  FUNCTION get_quote_loc_risk(p_quote_id NUMBER, p_item_no NUMBER) RETURN loc_risk_tab PIPELINED;--VARCHAR2;

  FUNCTION get_fire_occupancy(p_quote_id NUMBER) RETURN VARCHAR2;

  FUNCTION get_warranty_text(p_quote_id NUMBER, a_line_cd VARCHAR2) RETURN warranty_text_tab PIPELINED;

  FUNCTION get_fire_signatory(p_quote_id NUMBER, p_iss_cd VARCHAR2) RETURN fire_signatory_tab PIPELINED; --* Added by Windell; For UCPB; April 15, 2011

  FUNCTION get_fi_quote_itemperil(p_quote_id        GIPI_QUOTE.quote_id%TYPE)
    RETURN quote_fi_itemperil_tab PIPELINED;

END QUOTE_REPORTS_FI_PKG;
/


