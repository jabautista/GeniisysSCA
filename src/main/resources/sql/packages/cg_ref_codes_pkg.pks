CREATE OR REPLACE PACKAGE CPI.cg_ref_codes_pkg
AS
   TYPE cg_ref_codes_list_type IS RECORD (
      rv_low_value   cg_ref_codes.rv_low_value%TYPE,
      rv_meaning     cg_ref_codes.rv_meaning%TYPE
   );

   TYPE cg_ref_codes_list_tab IS TABLE OF cg_ref_codes_list_type;

   FUNCTION get_cg_ref_codes_list (p_rv_domain cg_ref_codes.rv_domain%TYPE)
      RETURN cg_ref_codes_list_tab PIPELINED;

/*  FUNCTION get_cg_ref_codes_list3
 *  REMARKS: ORDER BY rv_low_value
 *  BY: Christian 03/13/13     */
   FUNCTION get_cg_ref_codes_list3 (p_rv_domain cg_ref_codes.rv_domain%TYPE)
      RETURN cg_ref_codes_list_tab PIPELINED;

   FUNCTION get_rv_meaning (p_rv_domain VARCHAR2, p_rv_low_value VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION get_rv_meaning1 (p_rv_domain VARCHAR2, p_rv_low_value VARCHAR2)
      RETURN VARCHAR2;

/********************************** FUNCTION 1 ************************************
  MODULE:  GIPIS002
  RECORD GROUP NAME: CGDV$B540_POL_FLAG
***********************************************************************************/
   FUNCTION get_policy_status_list
      RETURN cg_ref_codes_list_tab PIPELINED;

/********************************** FUNCTION 2************************************
  MODULE:  GIACS001
  RECORD GROUP NAME: PAYMENT_MODE
  BY: TONIO 06/22/2010
***********************************************************************************/
   FUNCTION get_payment_mode_list
      RETURN cg_ref_codes_list_tab PIPELINED;

/********************************** FUNCTION 3************************************
  MODULE:  GIACS001
  RECORD GROUP NAME: CHECK_CLASS
  BY: TONIO 06/22/2010
***********************************************************************************/
   FUNCTION get_check_class_list
      RETURN cg_ref_codes_list_tab PIPELINED;

/********************************** FUNCTION 4************************************
  MODULE:  GIACS026
  RECORD GROUP NAME: CGDV$GCBA_TRANSACTION_TYPE
  BY: TONIO 07/26/2010
***********************************************************************************/
   FUNCTION get_transaction_type_list
      RETURN cg_ref_codes_list_tab PIPELINED;

/********************************** FUNCTION 4************************************
  MODULE:  GIACS026
  RECORD GROUP NAME: CGDV$GCBA_TRANSACTION_TYPE
  BY: TONIO 07/26/2010
***********************************************************************************/
   FUNCTION get_transaction_type_listing (
      p_rvdomain   cg_ref_codes.rv_domain%TYPE
   )
      RETURN cg_ref_codes_list_tab PIPELINED;

   FUNCTION get_cg_ref_codes_list2 (p_rv_domain cg_ref_codes.rv_domain%TYPE)
      RETURN cg_ref_codes_list_tab PIPELINED;

   FUNCTION get_cg_ref_cd_ordby_val (p_rv_domain cg_ref_codes.rv_domain%TYPE)
      RETURN cg_ref_codes_list_tab PIPELINED;

   PROCEDURE cgdv$chk_char_ref_codes (
      p_value     IN OUT   VARCHAR2               /* Value to be validated  */
                                   ,
      p_meaning   IN OUT   VARCHAR2               /* Domain meaning         */
                                   ,
      p_domain    IN       VARCHAR2
   );

   FUNCTION get_tran_flag_mean (p_tran_flag giac_acctrans.tran_flag%TYPE)
      RETURN VARCHAR2;

     /********************************** FUNCTION 2************************************
     MODULE:  GIACS035
     RECORD GROUP NAME: PAY_MODE
     BY: EMMAN 04/05/2011
   ***********************************************************************************/
   FUNCTION get_dcb_pay_mode_list (
      p_gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      p_gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      p_dcb_no           giac_order_of_payts.dcb_no%TYPE,
      p_dcb_date         VARCHAR2,
      p_keyword          VARCHAR2
   )
      RETURN cg_ref_codes_list_tab PIPELINED;

    /********************************** FUNCTION 3************************************
    MODULE:  GIACS035
    RECORD GROUP NAME: CHECK_CLASS
    BY: Emman 04/20/2011
   ***********************************************************************************/
   FUNCTION get_check_class_list2
      RETURN cg_ref_codes_list_tab PIPELINED;

   /**
   ** MODULE: GIACS002
   **  RECORD GROUP NAME: CGDV$GCHD_CHECK_CLASS
   */
   FUNCTION get_check_class_list3
      RETURN cg_ref_codes_list_tab PIPELINED;

    /**
   ** MODULE: GIACS002
   **  RECORD GROUP NAME: CGDV$GCHD_CHECK_STAT
   */
   FUNCTION get_check_stat_list
      RETURN cg_ref_codes_list_tab PIPELINED;

   FUNCTION validate_memo_type (p_memo_type VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION fetch_status_list(p_keyword VARCHAR2)
      RETURN cg_ref_codes_list_tab PIPELINED;

   FUNCTION get_giacs127_tran_class_list
      RETURN cg_ref_codes_list_tab PIPELINED;

   FUNCTION validate_giacs127_tran_class (
      p_rv_low_value   VARCHAR2,
      p_chk_include    VARCHAR2
   )
      RETURN VARCHAR2;

   TYPE giacs127_jv_tran_type IS RECORD (
      jv_tran_cd     giac_jv_trans.jv_tran_cd%TYPE,
      jv_tran_desc   giac_jv_trans.jv_tran_desc%TYPE
   );

   TYPE giacs127_jv_tran_tab IS TABLE OF giacs127_jv_tran_type;

   FUNCTION get_giacs127_jv_tran
      RETURN giacs127_jv_tran_tab PIPELINED;

   FUNCTION validate_giacs127_jv_tran (p_jv_tran_cd VARCHAR2)
      RETURN VARCHAR2;

   TYPE giacs060_tran_class_type IS RECORD (
      tran_class    VARCHAR2 (1000),
      description   VARCHAR2 (1000)
   );

   TYPE giacs060_tran_class_tab IS TABLE OF giacs060_tran_class_type;

   FUNCTION get_giacs060_tran_class
      RETURN giacs060_tran_class_tab PIPELINED;

   FUNCTION get_giacs601_transactions
      RETURN cg_ref_codes_list_tab PIPELINED;

   FUNCTION get_giiss080_class_type_lov
      RETURN cg_ref_codes_list_tab PIPELINED;
      
   FUNCTION get_giiss053_zone_grp_lov
      RETURN cg_ref_codes_list_tab PIPELINED;
--------------------------------------------------------------------- Dren Niebres 10.03.2016 SR-4572 : Added LOV for GIACS605 Transaction
   TYPE GIACS605_TRANSACTION_LOV_TYPE IS RECORD (
      RV_LOW_VALUE      CG_REF_CODES.RV_LOW_VALUE%TYPE,
      RV_MEANING        CG_REF_CODES.RV_MEANING%TYPE
   ); 
   TYPE GIACS605_TRANSACTION_LOV_TAB IS TABLE OF GIACS605_TRANSACTION_LOV_TYPE;  
--------------------------------------------------------------------- Dren Niebres 10.03.2016 SR-4573 : Added LOV for GIACS606 Transaction
   TYPE GIACS606_TRANSACTION_LOV_TYPE IS RECORD (
      RV_LOW_VALUE      CG_REF_CODES.RV_LOW_VALUE%TYPE,
      RV_MEANING        CG_REF_CODES.RV_MEANING%TYPE
   ); 
   TYPE GIACS606_TRANSACTION_LOV_TAB IS TABLE OF GIACS606_TRANSACTION_LOV_TYPE;       
--------------------------------------------------------------------- Dren Niebres 10.03.2016 SR-4573 : Added LOV for GIACS606 Status
   TYPE GIACS606_STATUS_LOV_TYPE IS RECORD (
      RV_LOW_VALUE      CG_REF_CODES.RV_LOW_VALUE%TYPE,
      RV_MEANING        CG_REF_CODES.RV_MEANING%TYPE
   ); 
   TYPE GIACS606_STATUS_LOV_TAB IS TABLE OF GIACS606_STATUS_LOV_TYPE;  
   FUNCTION GET_GIACS605_TRANSACTION_LOV ( --Dren Niebres 10.03.2016 SR-4572 : Added LOV for GIACS605 Transaction     
        P_SEARCH        VARCHAR2
   ) 
      RETURN GIACS605_TRANSACTION_LOV_TAB PIPELINED;        
   FUNCTION GET_GIACS606_TRANSACTION_LOV ( --Dren Niebres 10.03.2016 SR-4573 : Added LOV for GIACS606 Transaction
        P_SEARCH        VARCHAR2
   ) 
      RETURN GIACS606_TRANSACTION_LOV_TAB PIPELINED;       
   FUNCTION GET_GIACS606_STATUS_LOV ( --Dren Niebres 10.03.2016 SR-4573 : Added LOV for GIACS606 Status
        P_SEARCH                VARCHAR2,
        P_TRANSACTION_TYPE      GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE 
   ) 
      RETURN GIACS606_STATUS_LOV_TAB PIPELINED; 
            
   --added by carlo rubenecia 04.15.2016 SR 5490--start
   TYPE code_list_type IS RECORD(
        rv_meaning         CG_REF_CODES.rv_meaning%TYPE
    );  
   TYPE code_list_tab IS TABLE OF code_list_type;
   
   FUNCTION get_code_list
      RETURN code_list_tab PIPELINED;
   --added by carlo rubenecia 04.15.2016 SR 5490--end      
      
END cg_ref_codes_pkg;
/
