CREATE OR REPLACE PACKAGE CPI.QUOTE_REPORTS_MN_PKG AS
/******************************************************************************
   NAME:       QUOTE_REPORTS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        5/20/2010   Whofeih          1. Created this package.
******************************************************************************/

  TYPE mn_quote_details_type IS RECORD(
       eta              varchar2(30),
       etd              varchar2(30),
       assd_name        giis_assured.assd_name%TYPE,
       assd_add         varchar2(200), --* Added by Windell ON May 9, 2011
       assd_add1        varchar2(50),
       assd_add2        varchar2(50),
       assd_add3        varchar2(50),
       title            varchar2(30),
       title1           varchar2(30),
       title2           varchar2(30),
       title3           varchar2(30),
       title4           varchar2(30),
       title5           varchar2(30),
       title6           varchar2(30),
       title7           varchar2(30),
       title8           varchar2(30),
       title9           varchar2(30),
       title10          varchar2(30),
       title11          varchar2(30),
       attn_name        varchar2(50),
       position         varchar2(50),
       item             varchar2(50),
       incept           varchar2(30),
       expiry           varchar2(30),
       accept_dt        varchar2(30),
       remarks          varchar2(4000),
       carrier          varchar2(50),
       tsi              varchar2(25),
       origin           varchar2(50),
       destination      varchar2(50),
       prem_rt          varchar2(25),
       prem_amt         varchar2(25),
       taxes            varchar2(50),
       tax_amt          varchar2(25),
       tot_prem         varchar2(25),
       tot_amt          varchar2(25),
       ded_title        varchar2(50),
       ded_amt          varchar2(25),
       ded_rt           varchar2(12),
       deduct           varchar2(25),
       ded_txt          varchar2(2000),
       print_sw         varchar2(1),
       signatory        varchar2(50),
       designation      varchar2(50),
       quote_no         varchar2(50),
       line_cd            varchar2(5),
       subline_cd        varchar2(10),
       subline_name        varchar2(2000), --* Revised by Windell ON May 9, 2011; Changed from giis_subline.subline_name%type, 
       iss_cd           varchar2(5),    --* Added by Windell ON May 9, 2011
       user_id          varchar2(30),
       /*warranty         varchar2(5000),
       warranty_title1  varchar2(5000),
       warranty_title2  varchar2(5000),
       warranty_title3  varchar2(5000),
       warranty_title4  varchar2(5000),
       warranty_title5  varchar2(5000),
       warranty_title6  varchar2(5000),
       warranty_title7  varchar2(5000),
       warranty_title8  varchar2(5000),
       warranty_title9  varchar2(5000),
       warranty_title10 varchar2(5000),
       warranty_title11 varchar2(5000),
       warranty_title12 varchar2(5000),
       warranty_title13 varchar2(5000),
       warranty_title14 varchar2(5000),
       warranty_title15 varchar2(5000),
       warranty_title16 varchar2(5000),
       warranty_title17 varchar2(5000),*/
       peril            varchar2(50),
       currency_name    giis_currency.short_name%TYPE,
       doc_name         giis_parameters.param_value_v%TYPE,
         prem_amt1        number,
         count            number,
         count1           number,
       tot_tax          number,
         RECORD            number,
         item_no            number,    
         tsi_amt            VARCHAR2(20),        
         end_remarks        varchar2(25),
         period           VARCHAR2(50),
       temp_directory   VARCHAR2(32767),
       temp_dest        VARCHAR2(32767),
       contact            VARCHAR2(100),
       HEADER            gipi_quote.HEADER%TYPE,
       footer            gipi_quote.footer%TYPE,
       n                varchar2(10),
       M                number,
       logo_file        GIIS_PARAMETERS.param_value_v%TYPE,
       vessel_name      giis_vessel.vessel_name%TYPE,
       valid_days       VARCHAR2(100));

  TYPE mn_quote_details_tab IS TABLE OF mn_quote_details_type;
  
  TYPE mn_deductible_type IS RECORD (
         deduct            VARCHAR2(32767),
       title            VARCHAR2(32767),
       text                VARCHAR2(32767));
       
  TYPE mn_deductible_tab IS TABLE OF mn_deductible_type;
  
  /* FLT */       
  FUNCTION get_quote_details_mn_flt(p_quote_id NUMBER) RETURN mn_quote_details_tab PIPELINED;
  
  FUNCTION compute_total_prem_due(p_quote_id NUMBER, p_line_cd VARCHAR2) RETURN NUMBER;
  
  FUNCTION get_deductibles_mn_flt(p_quote_id NUMBER, p_line_cd VARCHAR2, p_subline_cd VARCHAR2) RETURN mn_deductible_tab PIPELINED;
  /* end of FLT */
  
  /* FGIC */
  FUNCTION get_quote_details_mn_fgic(p_quote_id NUMBER) RETURN mn_quote_details_tab PIPELINED;
  /* end of FGIC */
  
  /* CIC */
  FUNCTION get_quote_details_mn_cic(p_quote_id NUMBER) RETURN mn_quote_details_tab PIPELINED;
  /* end of CIC */
  
  /* SB */
  FUNCTION get_quote_details_mn_seici(p_quote_id NUMBER) RETURN mn_quote_details_tab PIPELINED;
  /* end of SB */
  
  /* UAC*/
  FUNCTION get_quote_details_mn_uac(p_quote_id NUMBER) RETURN mn_quote_details_tab PIPELINED;
  /* end of UAC */


/*****************ADDED*BY*WINDELL***********05*09*2011**************MARINECARGOQUOTE***********/    
/*   Added by    : Windell Valle
**   Date Created: May 09, 2011
**   Last Revised: May 09, 2011
**   Description : Marine Cargo Quote
**   Client(s)   : UCPB,...
*/
 
   --/* Items
  TYPE mn_items_type IS RECORD(
       item_title            varchar2(50),
       item_desc             gipi_quote_item.item_desc%TYPE   
       );
  TYPE mn_items_tab IS TABLE OF mn_items_type;
  --* Items */
  
  --* Currency short name
  TYPE mn_curr_type IS RECORD (
          currency_name  giis_currency.short_name%TYPE
       );       
  TYPE mn_curr_tab IS TABLE OF mn_curr_type;
  --* Currency short name
  
  --# Signatory
  TYPE marine_signatory_type IS RECORD(                         
     sig_name                giis_signatory_names.signatory%TYPE,   
     sig_des                 giis_signatory_names.designation%TYPE,
     sig_sw                  giis_signatory.current_signatory_sw%TYPE,
     sig_remarks             VARCHAR2(1000)                                                         
  );                                                              
  TYPE marine_signatory_tab IS TABLE OF marine_signatory_type;  
  --# Signatory
    
  --# Geographical Limit
  TYPE mn_geo_lim_type IS RECORD (
        geog_limit            VARCHAR2(500)
     );       
  TYPE mn_geo_lim_tab IS TABLE OF mn_geo_lim_type; 
  --# Geographical Limit
  
  --# TSI
  TYPE mn_tsi_type IS RECORD (
  		  short_name   giis_currency.short_name%TYPE, --added by steven 1.24.2013
          tsi_amt_chr  varchar2(25)
       );    
  TYPE mn_tsi_tab IS TABLE OF mn_tsi_type;
  --# TSI

  --* Deductibles
  TYPE mn_deductibles_type IS RECORD (
        deductible_text       VARCHAR2(1000)
     );       
  TYPE mn_deductibles_tab IS TABLE OF mn_deductibles_type;
  --* Deductibles

  --# Peril Rate
  TYPE mn_peril_type IS RECORD (
     item_no      gipi_quote_item.item_no%TYPE,
     peril_name   varchar2(1000),
        peril_rate   VARCHAR2(100)
     );       
  TYPE mn_peril_tab IS TABLE OF mn_peril_type; 
  --# Peril Rate

  --# Clauses
  TYPE mn_wc_type IS RECORD (
        wc_title            VARCHAR2(100)
     );       
  TYPE mn_wc_tab IS TABLE OF mn_wc_type; 
  --# Clauses  
  
  --/* UCPB Functions
  FUNCTION get_quote_details_mn_ucpb(p_quote_id NUMBER) RETURN mn_quote_details_tab PIPELINED;  
  FUNCTION get_curr_mn(p_quote_id NUMBER) RETURN mn_curr_tab PIPELINED; 
  FUNCTION get_signatory_mn(p_quote_id NUMBER, p_iss_cd VARCHAR2) RETURN marine_signatory_tab PIPELINED; 
  FUNCTION get_tsi_mn_ucpb(p_quote_id NUMBER) RETURN mn_tsi_tab PIPELINED;  
  FUNCTION get_geo_lim_mn_ucpb(p_quote_id NUMBER) RETURN mn_geo_lim_tab PIPELINED; 
  FUNCTION get_deductible_mn_ucpb(p_quote_id NUMBER, p_line_cd VARCHAR2, p_subline_cd VARCHAR2) RETURN mn_deductibles_tab PIPELINED;
  FUNCTION get_peril_mn_ucpb(p_quote_id NUMBER) RETURN mn_peril_tab PIPELINED;
  FUNCTION get_wc_mn_ucpb(p_quote_id NUMBER) RETURN mn_wc_tab PIPELINED; 
  FUNCTION get_items_mn_ucpb(p_quote_id NUMBER) RETURN mn_items_tab PIPELINED; 
  --* UCPB Functions --*/
/*****************ADDED*BY*WINDELL***********05*09*2011**************MARINECARGOQUOTE***********/   
  
END QUOTE_REPORTS_MN_PKG;
/


