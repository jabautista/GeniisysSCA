CREATE OR REPLACE PACKAGE CPI.quote_reports_av_pkg
AS
/******************************************************************************
   NAME:       QUOTE_REPORTS_AV_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        6/10/2010    Tonio           Created this package.
******************************************************************************/
--SEICI
   TYPE av_quote_details_type IS RECORD (
      v_quote_num    VARCHAR2 (50)                 := ' ',
      --v_attn_name           VARCHAR2(50)   := ' ',
      --v_signatory           VARCHAR2(50)   := ' ',
      --v_company             VARCHAR2(200)  := ' ',
      --v_fax                   VARCHAR2(50) := ' ',
      v_accept_dt    VARCHAR2 (50)                 := ' ',
      v_valid_dt     VARCHAR2 (50)                 := ' ',
      v_header       gipi_quote.header%TYPE,
      v_assd_name    giis_assured.assd_name%TYPE   := ' ',
      v_last_name    VARCHAR2 (200)                := ' ',
      v_quote_id     gipi_quote.quote_id%TYPE,
      v_line_cd      gipi_quote.line_cd%TYPE,
      v_subline_cd   gipi_quote.subline_cd%TYPE,
      v_footer       gipi_quote.footer%TYPE,
      v_itag         VARCHAR2 (1),
      v_etag         VARCHAR2 (1),
      v_incept       VARCHAR2 (30),
      v_expiry       VARCHAR2 (30),
      v_tprem        VARCHAR2 (4000),
      v_prem_total   VARCHAR2 (4000),
      v_remarks      VARCHAR2 (32767)              := NULL,
      logo_file         VARCHAR2 (32767),
      v_no_of_days     VARCHAR2(32767)
   );

   TYPE quote_av_details_tab IS TABLE OF av_quote_details_type;

   FUNCTION get_quote_av_details (p_quote_id NUMBER)
      RETURN quote_av_details_tab PIPELINED;

   TYPE av_peril_details_type IS RECORD (
      peril_name   VARCHAR2 (32767) := NULL,
      tsi          VARCHAR2 (4000)  := NULL,
      prem         VARCHAR2 (4000)  := NULL,
      short_name   VARCHAR2 (10)    := NULL
   );

   TYPE quote_av_perildetails_tab IS TABLE OF av_peril_details_type;

   FUNCTION get_peril_details (p_quote_id NUMBER)
      RETURN quote_av_perildetails_tab PIPELINED;

   TYPE av_aircraft_details_type IS RECORD (
      aircraft        VARCHAR2 (32767) := NULL,
      air_type        VARCHAR2 (32767) := NULL,
      no_pass         VARCHAR2 (32767) := NULL,
      rpc_no          VARCHAR2 (32767) := NULL,
      no_crew         VARCHAR2 (1000)  := NULL,
      qualification   VARCHAR2 (32767) := NULL,
      purpose         VARCHAR2 (32767) := NULL,
      item_desc       VARCHAR2 (32767) := NULL,
      geog_limit      VARCHAR2 (32767) := NULL
   );

   TYPE quote_av_aircraft_details_tab IS TABLE OF av_aircraft_details_type;

   FUNCTION get_aircraft_details (p_quote_id NUMBER)
      RETURN quote_av_aircraft_details_tab PIPELINED;

   TYPE av_deductible_details_type IS RECORD (
      deductible_title   giis_deductible_desc.deductible_title%TYPE,
      deductible_text    giis_deductible_desc.deductible_text%TYPE
   );

   TYPE quote_av_deduct_details_tab IS TABLE OF av_deductible_details_type;

   FUNCTION get_deductible_details (p_quote_id NUMBER)
      RETURN quote_av_deduct_details_tab PIPELINED;

   TYPE av_wc_details_type IS RECORD (
      wc_title   gipi_quote_wc.wc_title%TYPE
   );

   TYPE quote_av_wc_details_tab IS TABLE OF av_wc_details_type;

   FUNCTION get_wc_title (p_quote_id NUMBER)
      RETURN quote_av_wc_details_tab PIPELINED;

   TYPE av_invoice_details_type IS RECORD (
      tprem        VARCHAR2 (4000)                 := NULL,
      short_name   giis_currency.short_name%TYPE
   );

   TYPE quote_av_invoice_details_tab IS TABLE OF av_invoice_details_type;

   FUNCTION get_invoice_details (p_quote_id NUMBER)
      RETURN quote_av_invoice_details_tab PIPELINED;

--END SEICI--

   --PNBGEN--
   TYPE av_quote_details_pnbgen_type IS RECORD (
      line_name       giis_line.line_name%TYPE,
      quote_no        VARCHAR2 (30),
      assd            VARCHAR2 (3000),
      header          gipi_quote.header%TYPE,
      footer          gipi_quote.footer%TYPE,
      incept          VARCHAR2 (100),
      expiry          VARCHAR2 (100),
      DURATION        VARCHAR2 (200),
      valid           VARCHAR2 (30),
      acct_of_cd      gipi_quote.acct_of_cd%TYPE,
      acct_of_cd_sw   gipi_quote.acct_of_cd_sw%TYPE,
      quote_id        gipi_quote.quote_id%TYPE,
      address         VARCHAR2 (200),
      remarks         gipi_quote.remarks%TYPE,
      line_cd         giis_line.line_cd%TYPE,
      iss_cd          giis_issource.iss_cd%TYPE,
      user_name       giis_users.user_name%TYPE,
      mortgagee       giis_mortgagee.mortg_name%TYPE,
      sig_name        GIIS_SIGNATORY_NAMES.signatory%TYPE,
      sig_des          GIIS_SIGNATORY_NAMES.designation%TYPE,
      logo_file       VARCHAR2 (32767) 
   );

   TYPE quote_av_details_pnbgen_tab IS TABLE OF av_quote_details_pnbgen_type;

   FUNCTION get_quote_details_pnbgen (p_quote_id NUMBER)
      RETURN quote_av_details_pnbgen_tab PIPELINED;

   TYPE av_peril_details_pnbgen_type IS RECORD (
      peril           VARCHAR2 (32767) := NULL,
      peril_remarks   VARCHAR2 (32767) := NULL
   );

   TYPE peril_av_details_tab IS TABLE OF av_peril_details_pnbgen_type;

   FUNCTION get_peril_details_pnbgen (p_quote_id NUMBER)
      RETURN peril_av_details_tab PIPELINED;

   TYPE av_deduct_details_pnbgen_type IS RECORD (
      deductible_text   VARCHAR2 (32767) := NULL
   );

   TYPE deductible_av_details_tab IS TABLE OF av_deduct_details_pnbgen_type;

   FUNCTION get_deductible_details_pnbgen (p_quote_id NUMBER)
      RETURN deductible_av_details_tab PIPELINED;

   TYPE av_item_details_pnbgen_type IS RECORD (
      item        VARCHAR2 (32767) := NULL,
      detail      VARCHAR2 (32767) := NULL,
      item_desc   VARCHAR2 (32767) := NULL
   );

   TYPE item_av_details_tab IS TABLE OF av_item_details_pnbgen_type;

   FUNCTION get_item_details_pnbgen (p_quote_id NUMBER)
      RETURN item_av_details_tab PIPELINED;

   TYPE av_wc_details_pnbgen_type IS RECORD (
      warrcla   VARCHAR2 (32767) := NULL
   );

   TYPE wc_av_details_tab IS TABLE OF av_wc_details_pnbgen_type;

   FUNCTION get_wc_details_pnbgen (p_quote_id NUMBER)
      RETURN wc_av_details_tab PIPELINED;

   TYPE av_premium_details_pnbgen_type IS RECORD (
      premium       VARCHAR2 (200),
      tax_desc   giis_tax_charges.tax_desc%TYPE,
      tax_amt    gipi_quote_invtax.tax_amt%TYPE,
      tot_amt    VARCHAR2 (32767)                 := NULL
   );

   TYPE premium_av_details_tab IS TABLE OF av_premium_details_pnbgen_type;

   FUNCTION get_premium_details_pnbgen (p_quote_id NUMBER)
      RETURN premium_av_details_tab PIPELINED;
--END PNBGEN--
END quote_reports_av_pkg;
/


