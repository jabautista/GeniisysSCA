CREATE OR REPLACE PACKAGE CPI.Giis_Currency_Pkg AS

  TYPE currency_list_type IS RECORD
    (main_currency_cd          GIIS_CURRENCY.main_currency_cd%TYPE,
     currency_desc             GIIS_CURRENCY.currency_desc%TYPE,
     currency_rt               GIIS_CURRENCY.currency_rt%TYPE,
     short_name                   GIIS_CURRENCY.short_name%TYPE);
  
  TYPE currency_list_tab IS TABLE OF currency_list_type;
  
  TYPE giis_currency_cur IS REF CURSOR RETURN currency_list_type;
  
  TYPE default_currency_type IS RECORD
    (currency_cd       GIIS_CURRENCY.main_currency_cd%TYPE,
     currency_desc     GIIS_CURRENCY.currency_desc%TYPE,
     currency_rate     GIIS_CURRENCY.currency_rt%TYPE);
     
  TYPE default_currency_tab IS TABLE OF default_currency_type;
  
  TYPE dcb_currency_lov_type IS RECORD (
       short_name           GIIS_CURRENCY.short_name%TYPE,
     currency_desc       GIIS_CURRENCY.currency_desc%TYPE,
     main_currency_cd  GIIS_CURRENCY.main_currency_cd%TYPE,
     currency_rt       GIAC_COLLECTION_DTL.currency_rt%TYPE,
     curr_rt           VARCHAR2(15)
  );
  
  TYPE dcb_currency_lov_tab IS TABLE OF dcb_currency_lov_type;
        
  FUNCTION get_currency_list RETURN currency_list_tab PIPELINED;
  
  FUNCTION get_currency_by_premseqno(p_iss_cd gipi_invoice.iss_cd%TYPE,
                                          p_prem_seq_no gipi_invoice.PREM_SEQ_NO%TYPE) RETURN  currency_list_tab PIPELINED;
  
  PROCEDURE get_currency_dtl(p_currency_cd GIIS_CURRENCY.main_currency_cd%TYPE,
                               p_main_currency_cd OUT GIIS_CURRENCY.main_currency_cd%TYPE,
                             p_currency_desc OUT GIIS_CURRENCY.currency_desc%TYPE,
                             p_currency_rt OUT GIIS_CURRENCY.currency_rt%TYPE,
                             p_short_name OUT GIIS_CURRENCY.short_name%TYPE);
  
  FUNCTION get_default_currency RETURN default_currency_tab PIPELINED;
  
    FUNCTION get_default_currency2 RETURN VARCHAR2;
  
    FUNCTION GET_ITEM_SHORT_NAME (p_extract_id IN GIXX_INVOICE.extract_id%TYPE)
    RETURN VARCHAR;
    
    FUNCTION GET_ITEM_SHORT_NAME2 (
        p_extract_id IN GIXX_INVOICE.extract_id%TYPE,
        p_item_no IN GIXX_ITEM.item_no%TYPE)
    RETURN VARCHAR;
    
    FUNCTION get_pol_doc_short_name(p_currency_cd IN GIXX_ORIG_INVOICE.currency_cd%TYPE)
    RETURN VARCHAR2;
    
    FUNCTION get_pol_doc_short_name2(p_extract_id IN GIXX_INVOICE.extract_id%TYPE)
    RETURN VARCHAR2;
    
    TYPE currency_list_type2 IS RECORD
    (main_currency_cd          GIIS_CURRENCY.main_currency_cd%TYPE,
     currency_desc             GIIS_CURRENCY.currency_desc%TYPE,
     currency_rt               GIIS_CURRENCY.currency_rt%TYPE,
     short_name                   GIIS_CURRENCY.short_name%TYPE,
     currency_desc2            GIIS_CURRENCY.currency_desc%TYPE);
  
  TYPE currency_list_tab2 IS TABLE OF currency_list_type2;
    
    /* CREATED BY ANTHONY SANTOS SEPT 16, 2010
    *  GET CURRENCY DETAILS FOR TRANSBASIC INFO
    */
    FUNCTION get_trans_basic_currency_dtls(p_gacc_tran_id giac_order_of_payts.gacc_tran_id%TYPE)
    RETURN currency_list_tab2 PIPELINED;
    
    PROCEDURE validate_currency_code (
        p_claim_id             IN  gicl_claims.claim_id%TYPE,
        p_collection_amt       IN  giac_loss_recoveries.collection_amt%TYPE,
        p_currency_cd          IN  giac_loss_recoveries.currency_cd%TYPE,
        p_convert_rate         OUT giac_loss_recoveries.convert_rate%TYPE,
        p_dsp_currency_desc    OUT giis_currency.currency_desc%TYPE,
        p_foreign_curr_amt     OUT giac_loss_recoveries.foreign_curr_amt%TYPE,
        p_msg_alert            OUT VARCHAR2                       
        );
        
    FUNCTION get_currency_lov(p_keyword   VARCHAR2) RETURN currency_list_tab PIPELINED;
    
    FUNCTION get_pack_item_short_name (p_extract_id IN GIXX_PACK_INVOICE.extract_id%TYPE)
      RETURN VARCHAR;
      
    FUNCTION get_dcb_currency_lov (p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
                                     p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
                                     p_dcb_no           giac_acctrans.tran_class_no%TYPE,
                                     p_dcb_date         VARCHAR2,
                                     p_pay_mode          giac_dcb_bank_dep.pay_mode%TYPE,
                                   p_keyword          VARCHAR)
      RETURN dcb_currency_lov_tab PIPELINED;
      
    FUNCTION get_currency_lov_by_short_name(p_short_name  GIIS_CURRENCY.short_name%TYPE)
      RETURN currency_list_tab PIPELINED;
        
    FUNCTION get_currency_rt_by_shortname(p_short_name  GIIS_CURRENCY.short_name%TYPE)    return GIIS_CURRENCY.currency_rt%TYPE;
    
    TYPE giacs035_curr_type IS RECORD (
        short_name     giis_currency.short_name%TYPE,
        currency_rt    giis_currency.currency_rt%TYPE,
        currency_cd    giis_currency.main_currency_cd%TYPE
    );
    
    TYPE giacs035_curr_tab IS TABLE OF giacs035_curr_type;
    
    FUNCTION get_giacs035currency_lov (
        p_module_id      giis_modules.module_id%TYPE,
        p_user_id        giis_users.user_id%TYPE,
        p_keyword        VARCHAR2,
        p_short_name     giis_currency.short_name%TYPE
    )
      RETURN giacs035_curr_tab PIPELINED;
--------------------------------------------------------------------       
   TYPE GIACS035_CURRENY_LOV_TYPE IS RECORD ( -- dren 07.16.2015 : SR 0017729 - Added GIACS035_CURRENY_LOV - Start
        SHORT_NAME                  GIIS_CURRENCY.SHORT_NAME%TYPE,
        CURRENCY_DESC               GIIS_CURRENCY.CURRENCY_DESC%TYPE,
        CURRENCY_RT                 VARCHAR2 (100),        
        MAIN_CURRENCY_CD            GIIS_CURRENCY.MAIN_CURRENCY_CD%TYPE    
   );

   TYPE GIACS035_CURRENY_LOV_TAB IS TABLE OF GIACS035_CURRENY_LOV_TYPE;
   FUNCTION GET_GIACS035_CURRENY_LOV ( 
        P_SEARCH                    VARCHAR2,
        P_GIBR_BRANCH_CD            GIAC_ORDER_OF_PAYTS.GIBR_BRANCH_CD%TYPE,
        P_GFUN_FUND_CD              GIAC_ORDER_OF_PAYTS.GIBR_GFUN_FUND_CD%TYPE,
        P_DSP_DCB_DATE              VARCHAR2, 
        P_PAY_MODE                  GIAC_COLLECTION_DTL.PAY_MODE%TYPE,
        P_DCB_NO                    GIAC_ORDER_OF_PAYTS.DCB_NO%TYPE
   ) 
   RETURN GIACS035_CURRENY_LOV_TAB PIPELINED;   -- dren 07.16.2015 : SR 0017729 - Added GIACS035_CURRENY_LOV - End  
      
END Giis_Currency_Pkg;
/


