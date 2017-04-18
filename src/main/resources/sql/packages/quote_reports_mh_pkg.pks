CREATE OR REPLACE PACKAGE CPI.QUOTE_REPORTS_MH_PKG AS
/******************************************************************************
   NAME:       QUOTE_REPORTS_MH_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        4/28/2011   Windel Valle     Created this package.
******************************************************************************/

   TYPE mh_quote_details_type IS RECORD(
       quote_no         varchar2(50),
       assd_name        giis_assured.assd_name%TYPE,
       assd_add         varchar2(300),
       assd_add1        varchar2(50),
       assd_add2        varchar2(50),
       assd_add3        varchar2(50),
       incept           varchar2(30),
       expiry           varchar2(30),
       accept_dt        varchar2(30),
       remarks          varchar2(4000),
       HEADER            gipi_quote.HEADER%TYPE,
       footer            gipi_quote.footer%TYPE,
       iss_cd           varchar2(5),
       line_cd          varchar2(5),
       subline_cd       varchar2(10),
       subline_name     varchar2(500),
       user_id          varchar2(30),
       logo_file        GIIS_PARAMETERS.param_value_v%TYPE,
       peril            varchar2(1000),
       item_no          number
       );
  TYPE mh_quote_details_tab IS TABLE OF mh_quote_details_type;


    --* Currency short name
  TYPE mh_curr_type IS RECORD (
          currency_name  giis_currency.short_name%TYPE
       );
  TYPE mh_curr_tab IS TABLE OF mh_curr_type;
  --* Currency short name


  --* Vessel
  TYPE mh_vessel_type IS RECORD (
          vessel_name  varchar2(200),
       vessel_type  varchar2(200),
       year_built   number,
       gross_ton    number,
       tsi_amt      varchar2(50),
       short_name  giis_currency.short_name%TYPE
       );
  TYPE mh_vessel_tab IS TABLE OF mh_vessel_type;
  --* Vessel


  --# TSI
  TYPE mh_tsi_type IS RECORD (
          tsi_amt  	 VARCHAR2(25),
		  short_name VARCHAR2(10)--added by steven 1.26.2013
       );
  TYPE mh_tsi_tab IS TABLE OF mh_tsi_type;
  --# TSI


  --* Items
  TYPE mh_items_type IS RECORD(
       item_title            varchar2(50)
       );
  TYPE mh_items_tab IS TABLE OF mh_items_type;
  --* Items


  --# Premium
  TYPE mh_prem_type IS RECORD(
       prem_amt_chr         VARCHAR2(25),
	   short_name 			VARCHAR2(10)--added by steven 1.26.2013
       );
  TYPE mh_prem_tab IS TABLE OF mh_prem_type;
  --# Premium


  --* Deductibles
  TYPE mh_deductible_type IS RECORD (
     deductible_text       VARCHAR2(1000),
     peril_name            varchar2(1000),
     peril_ded             VARCHAR2(2000),
     peril_cd               varchar2(5)
     );
  TYPE mh_deductible_tab IS TABLE OF mh_deductible_type;
  --* Deductibles


  --# Clauses
  TYPE mh_wc_type IS RECORD (
        wc_title            VARCHAR2(100)
     );
  TYPE mh_wc_tab IS TABLE OF mh_wc_type;
  --# Clauses


  --# Geographical Limit
  TYPE mh_geo_lim_type IS RECORD (
        geog_limit            VARCHAR2(100)
     );
  TYPE mh_geo_lim_tab IS TABLE OF mh_geo_lim_type;
  --# Geographical Limit


  --# Peril Rate
  TYPE mh_peril_rate_type IS RECORD (
        peril_rate   VARCHAR2(100)
     );
  TYPE mh_peril_rate_tab IS TABLE OF mh_peril_rate_type;
  --# Peril Rate


  --# Signatory
  TYPE hull_signatory_type IS RECORD(
     sig_name                giis_signatory_names.signatory%TYPE,
     sig_des                 giis_signatory_names.designation%TYPE,
     sig_sw                  giis_signatory.current_signatory_sw%TYPE,
     sig_remarks             VARCHAR2(1000)
  );
  TYPE hull_signatory_tab IS TABLE OF hull_signatory_type;
  --# Signatory



  FUNCTION get_curr_mh(p_quote_id NUMBER) RETURN mh_curr_tab PIPELINED;
  FUNCTION get_signatory_mh(p_quote_id NUMBER, p_iss_cd VARCHAR2) RETURN hull_signatory_tab PIPELINED;

  --* SEICI Functions
  FUNCTION get_quote_details_mh_seici(p_quote_id NUMBER) RETURN mh_quote_details_tab PIPELINED;
  FUNCTION get_vessel_mh_seici(p_quote_id NUMBER) RETURN mh_vessel_tab PIPELINED;
  FUNCTION get_tsi_mh_seici(p_quote_id NUMBER) RETURN mh_tsi_tab PIPELINED;
  FUNCTION get_items_mh_seici(p_quote_id NUMBER) RETURN mh_items_tab PIPELINED;
  FUNCTION get_prem_mh_seici(p_quote_id NUMBER) RETURN mh_prem_tab PIPELINED;
  FUNCTION get_deductible_mh_seici(p_quote_id NUMBER, p_line_cd VARCHAR2, p_subline_cd VARCHAR2) RETURN mh_deductible_tab PIPELINED;
  FUNCTION get_wc_mh_seici(p_quote_id NUMBER) RETURN mh_wc_tab PIPELINED;
  --* SEICI Functions

  --/* UCPB Functions
  FUNCTION get_quote_details_mh_ucpb(p_quote_id NUMBER) RETURN mh_quote_details_tab PIPELINED;
  FUNCTION get_vessel_mh_ucpb(p_quote_id NUMBER) RETURN mh_vessel_tab PIPELINED;
  FUNCTION get_tsi_mh_ucpb(p_quote_id NUMBER) RETURN mh_tsi_tab PIPELINED;
  FUNCTION get_geo_lim_mh_ucpb(p_quote_id NUMBER) RETURN mh_geo_lim_tab PIPELINED;
  FUNCTION get_deductible_mh_ucpb(p_quote_id NUMBER, p_line_cd VARCHAR2, p_subline_cd VARCHAR2) RETURN mh_deductible_tab PIPELINED;
  FUNCTION get_peril_rate_mh_ucpb(p_quote_id NUMBER, p_line_cd VARCHAR2, p_subline_cd VARCHAR2) RETURN mh_peril_rate_tab PIPELINED;
  FUNCTION get_wc_mh_ucpb(p_quote_id NUMBER) RETURN mh_wc_tab PIPELINED;
   FUNCTION get_prem_mh_ucpb(p_quote_id NUMBER) RETURN mh_prem_tab PIPELINED;
  /*FUNCTION get_items_mh_ucpb(p_quote_id NUMBER) RETURN mh_items_tab PIPELINED;


  --* UCPB Functions --*/

END QUOTE_REPORTS_MH_PKG;
/


