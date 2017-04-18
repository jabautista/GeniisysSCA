CREATE OR REPLACE PACKAGE CPI.giac_collection_dtl_pkg 
AS
   TYPE giac_collection_dtl_type IS RECORD (
      fc_gross_amt            GIAC_COLLECTION_DTL.fc_gross_amt%TYPE,
      fcurrency_amt            GIAC_COLLECTION_DTL.fcurrency_amt%TYPE,
      gross_amt                GIAC_COLLECTION_DTL.gross_amt%TYPE,
      amount                GIAC_COLLECTION_DTL.amount%TYPE
   );
   
   TYPE giac_collection_dtl_tab IS TABLE OF giac_collection_dtl_type;
   
   PROCEDURE set_giac_collection_dtl (
      v_gacc_tran_id        giac_collection_dtl.gacc_tran_id%TYPE,
      v_item_no                giac_collection_dtl.item_no%TYPE,
      v_currency_cd         giac_collection_dtl.currency_cd%TYPE,
      v_currency_rt         giac_collection_dtl.currency_rt%TYPE,
      v_pay_mode            giac_collection_dtl.pay_mode%TYPE,
      v_amount              giac_collection_dtl.amount%TYPE,
      v_check_date          giac_collection_dtl.check_date%TYPE,
      v_check_no            giac_collection_dtl.check_no%TYPE,
      v_particulars         giac_collection_dtl.particulars%TYPE,
      v_bank_cd             giac_collection_dtl.bank_cd%TYPE,
      v_check_class         giac_collection_dtl.check_class%TYPE,
      v_fcurrency_amt       giac_collection_dtl.fcurrency_amt%TYPE,
      v_gross_amt           giac_collection_dtl.gross_amt%TYPE,
      v_commission_amt      giac_collection_dtl.commission_amt%TYPE,
      v_vat_amt                giac_collection_dtl.vat_amt%TYPE,
      v_fc_gross_amt        giac_collection_dtl.fc_gross_amt%TYPE,
      v_fc_comm_amt            giac_collection_dtl.fc_comm_amt%TYPE,
      v_fc_tax_amt          giac_collection_dtl.fc_tax_amt%TYPE,
      v_dcb_bank_cd         giac_collection_dtl.dcb_bank_cd%TYPE,
      v_dcb_bank_acct_cd    giac_collection_dtl.dcb_bank_acct_cd%TYPE,
      v_due_dcb_no          giac_collection_dtl.due_dcb_no%TYPE,
      v_due_dcb_date        giac_collection_dtl.due_dcb_date%TYPE,
      v_cm_tran_id          giac_collection_dtl.cm_tran_id%TYPE  -- added by: Nica 05.15.2013 AC-SPECS-2012-155
   );
   
   PROCEDURE delete_giac_collection_dtl(
         v_gacc_tran_id        giac_collection_dtl.gacc_tran_id%TYPE,
      v_item_no                giac_collection_dtl.item_no%TYPE
   );
   
   FUNCTION get_giac_collection_dtl (
         p_tran_id      giac_collection_dtl.gacc_tran_id%TYPE
   ) RETURN giac_collection_dtl_tab PIPELINED;
   
   
   
   /*************** GET COLLECTION DETAILS *****************/       
   
   TYPE giac_colln_dtl_type IS RECORD (
      gacc_tran_id        giac_collection_dtl.gacc_tran_id%TYPE,
      item_no             giac_collection_dtl.item_no%TYPE,
      currency_cd         giac_collection_dtl.currency_cd%TYPE,
      currency_rt         giac_collection_dtl.currency_rt%TYPE,
      pay_mode            giac_collection_dtl.pay_mode%TYPE,
      amount              giac_collection_dtl.amount%TYPE,
      check_date          giac_collection_dtl.check_date%TYPE,
      check_no            giac_collection_dtl.check_no%TYPE,
      particulars         giac_collection_dtl.particulars%TYPE,
      bank_cd             giac_collection_dtl.bank_cd%TYPE,
      check_class         giac_collection_dtl.check_class%TYPE,
      fcurrency_amt       giac_collection_dtl.fcurrency_amt%TYPE,
      gross_amt           giac_collection_dtl.gross_amt%TYPE,
      intm_no             giac_collection_dtl.intm_no%TYPE,
      commission_amt      giac_collection_dtl.commission_amt%TYPE,
      vat_amt             giac_collection_dtl.vat_amt%TYPE,
      fc_gross_amt        giac_collection_dtl.fc_gross_amt%TYPE,
      fc_comm_amt         giac_collection_dtl.fc_comm_amt%TYPE,
      fc_tax_amt          giac_collection_dtl.fc_tax_amt%TYPE,
      bank_name           giac_banks.bank_name%TYPE,
      dcb_bank_name       giac_banks.bank_name%TYPE,
      currency            giis_currency.short_name%TYPE,
      dcb_bank_cd         giac_collection_dtl.dcb_bank_cd%TYPE,
      dcb_bank_acct_cd    giac_collection_dtl.dcb_bank_acct_cd%TYPE,
      cm_tran_id          giac_collection_dtl.cm_tran_id%TYPE, -- added by: Nica 05.15.2013 AC-SPECS-2012-155
      item_id             giac_pdc_checks.item_id%TYPE, --added by john 12.5.2014
      pdc_id              giac_collection_dtl.pdc_id%TYPE --added by john 6.3.2015
   );
   
   TYPE giac_colln_dtl_tab IS TABLE OF giac_colln_dtl_type;
   
   FUNCTION get_giac_colln_dtl (
         p_tran_id      giac_collection_dtl.gacc_tran_id%TYPE
   ) RETURN giac_colln_dtl_tab PIPELINED;
   
   
   
      TYPE giac_colln_dtl_rep_type IS RECORD (
      gacc_tran_id                   giac_collection_dtl.gacc_tran_id%TYPE,
      pay_mode                      giac_collection_dtl.pay_mode%TYPE,
      amount                          giac_collection_dtl.amount%TYPE,
      check_date                      giac_collection_dtl.check_date%TYPE,
      check_no                         giac_collection_dtl.check_no%TYPE,
      bank_cd                           giac_collection_dtl.bank_cd%TYPE,
      gross_amt                       giac_collection_dtl.gross_amt%TYPE,
      commission_amt              giac_collection_dtl.commission_amt%TYPE,
      bank_name                     giac_banks.bank_name%TYPE,
      COUNT_PAYMODE_CHK     VARCHAR2(1)
   );
   
   TYPE giac_colln_dtl_rep_tab IS TABLE OF giac_colln_dtl_rep_type;
   
   
   FUNCTION get_giac_collection_dtl_rep (   --Added by Alfred 03/04/2011
      p_cp_check_title         giac_collection_dtl.check_no%TYPE,
      p_cp_credit_title         giac_collection_dtl.check_no%TYPE,
      p_gross_tag               GIAC_ORDER_OF_PAYTS.GROSS_TAG%TYPE,
      p_cp_sum                  varchar2,
      p_tran_id                   giac_collection_dtl.gacc_tran_id%TYPE
   )
    RETURN giac_colln_dtl_rep_tab PIPELINED;
      
   PROCEDURE insert_giac_pdc_checks(
        p_rec   giac_pdc_checks%ROWTYPE
   );
   
   /*PROCEDURE update_giacs025_currency(
        p_gacc_tran_id  giac_collection_dtl.gacc_tran_id%TYPE
   );*/
   
   PROCEDURE delete_giac_pdc_checks(
         p_item_id        giac_pdc_checks.item_id%TYPE
   );
-------------------------------------------------------------------- 
   TYPE GIACS035_PAY_MODE_LOV_TYPE IS RECORD ( -- dren 07.16.2015 : SR 0017729 - Added GIACS035_PAY_MODE_LOV - Start
        PAY_MODE                    GIAC_COLLECTION_DTL.PAY_MODE%TYPE,
        RV_MEANING                  CG_REF_CODES.RV_MEANING%TYPE
   );

   TYPE GIACS035_PAY_MODE_LOV_TAB IS TABLE OF GIACS035_PAY_MODE_LOV_TYPE;
   FUNCTION GET_GIACS035_PAY_MODE_LOV ( 
        P_SEARCH                    VARCHAR2,
        P_GIBR_BRANCH_CD            GIAC_ORDER_OF_PAYTS.GIBR_BRANCH_CD%TYPE,
        P_GFUN_FUND_CD              GIAC_ORDER_OF_PAYTS.GIBR_GFUN_FUND_CD%TYPE,
        P_DSP_DCB_DATE              VARCHAR2, 
        P_DCB_NO                    GIAC_ORDER_OF_PAYTS.DCB_NO%TYPE
   ) 
   RETURN GIACS035_PAY_MODE_LOV_TAB PIPELINED;  -- dren 07.16.2015 : SR 0017729 - Added GIACS035_PAY_MODE_LOV - End    

END giac_collection_dtl_pkg;
/