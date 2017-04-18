CREATE OR REPLACE PACKAGE CPI.giac_batch_dv_pkg
AS
/******************************************************************************
   NAME:       GIAC_BATCH_DV
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/8/2011   Irwin Tabisora   Special Claim Settlement Requuest package. Module Id: GIAC086
******************************************************************************/
   TYPE giac_batch_dv_type IS RECORD (
      batch_dv_id       giac_batch_dv.batch_dv_id%TYPE,
      fund_cd           giac_batch_dv.fund_cd%TYPE,
      branch_cd         giac_batch_dv.branch_cd%TYPE,
      batch_year        giac_batch_dv.batch_year%TYPE,
      batch_mm          giac_batch_dv.batch_mm%TYPE,
      batch_seq_no      giac_batch_dv.batch_seq_no%TYPE,
      batch_date        VARCHAR (10),
      batch_flag        giac_batch_dv.batch_flag%TYPE,
      payee_class_cd    giac_batch_dv.payee_class_cd%TYPE,
      payee_cd          giac_batch_dv.payee_cd%TYPE,
      particulars       giac_batch_dv.particulars%TYPE,
      tran_id           giac_batch_dv.tran_id%TYPE,
      paid_amt          giac_batch_dv.paid_amt%TYPE,
      fcurr_amt         giac_batch_dv.fcurr_amt%TYPE,
      currency_cd       giac_batch_dv.currency_cd%TYPE,
      convert_rate      giac_batch_dv.convert_rate%TYPE,
      user_id           giac_batch_dv.user_id%TYPE,
      last_update       giac_batch_dv.last_update%TYPE,
      payee_remarks     giac_batch_dv.payee_remarks%TYPE,
      dsp_payee         VARCHAR2(600), --marco - 05.06.2013 - modified length
      dsp_currency      giis_currency.currency_desc%TYPE,
      batch_no          VARCHAR (100),
      dsp_payee_class   giis_payee_class.class_desc%TYPE,
      print_dtl_sw      VARCHAR2 (1)
   );

   TYPE giac_batch_dv_tab IS TABLE OF giac_batch_dv_type;

   FUNCTION get_special_csr_listing (
      p_fund_cd           giac_batch_dv.fund_cd%TYPE,
      p_branch_cd         giac_batch_dv.branch_cd%TYPE,
      p_batch_year        giac_batch_dv.batch_year%TYPE,
      p_batch_mm          giac_batch_dv.batch_mm%TYPE,
      p_batch_seq_no      giac_batch_dv.batch_seq_no%TYPE,
      p_batch_date        VARCHAR2,
      p_user_id           VARCHAR2,
      p_dsp_payee_class   giis_payee_class.class_desc%TYPE,
      p_particulars       giac_batch_dv.particulars%TYPE,
      p_fcurr_amt         giac_batch_dv.fcurr_amt%TYPE,
      p_paid_amt          giac_batch_dv.paid_amt%TYPE,
      p_dsp_currency      VARCHAR2,
      p_claim_id          gicl_claims.claim_id%type
   )
      RETURN giac_batch_dv_tab PIPELINED;

   FUNCTION get_giac_batch_dv (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN giac_batch_dv_tab PIPELINED;

   PROCEDURE set_giac_batch_dv (
      p_payee_class_cd    IN       giac_batch_dv.payee_class_cd%TYPE,
      p_payee_cd                   giac_batch_dv.payee_cd%TYPE,
      p_particulars                giac_batch_dv.particulars%TYPE,
      p_total_paid_amt             giac_batch_dv.paid_amt%TYPE,
      p_total_fcurr_amt            giac_batch_dv.fcurr_amt%TYPE,
      p_currency_cd                giac_batch_dv.currency_cd%TYPE,
      p_convert_rate               giac_batch_dv.convert_rate%TYPE,
      p_payee_ramarks              giac_batch_dv.payee_remarks%TYPE,
      p_iss_cd                     gicl_advice.iss_cd%TYPE,
      p_fund_cd                    giac_parameters.param_value_v%TYPE,
      p_batch_dv_id       OUT      giac_batch_dv.batch_dv_id%TYPE,
      p_msg_alert         OUT      VARCHAR2,
      p_document_cd       OUT      VARCHAR2,
      p_gouc_ouc_id       OUT      giac_oucs.ouc_id%TYPE,
      p_ref_id            OUT      giac_payt_requests.ref_id%TYPE,
      p_doc_year          OUT      giac_payt_requests.doc_year%TYPE,
      p_doc_mm            OUT      giac_payt_requests.doc_mm%TYPE,
      p_doc_seq_no        OUT      NUMBER
   );

   PROCEDURE add_payment_request_details (
      p_particulars       IN OUT   VARCHAR2,
      p_batch_dv_id                giac_batch_dv.batch_dv_id%TYPE,
      p_user_id                    giac_batch_dv.user_id%TYPE,
      p_fund_cd                    giac_parameters.param_value_v%TYPE,
      p_iss_cd                     gicl_advice.iss_cd%TYPE,
      p_payee                      VARCHAR2,
      p_payee_cd                   giac_batch_dv.payee_cd%TYPE,
      p_payee_class_cd             giac_batch_dv.payee_class_cd%TYPE,
      p_payee_remarks              VARCHAR2,
      p_currency_cd                gicl_advice.currency_cd%TYPE,
      p_total_paid_amt             giac_batch_dv.paid_amt%TYPE,
      p_total_fcurr_amt            giac_batch_dv.fcurr_amt%TYPE,
      p_convert_rate               giac_batch_dv.convert_rate%TYPE,
      v_ref_id                     giac_payt_requests.ref_id%TYPE,
      v_dv_tran_id        OUT      giac_acctrans.tran_id%TYPE,
      v_jv_tran_id        OUT      giac_acctrans.tran_id%TYPE,
      v_ri_iss_cd         OUT      VARCHAR2,
      v_check             OUT      VARCHAR2
   );

   PROCEDURE add_direct_claim_payments (
      p_payee_cd                  giac_batch_dv.payee_cd%TYPE,
      p_payee_class_cd            giac_batch_dv.payee_class_cd%TYPE,
      p_claim_id                  gicl_advice.claim_id%TYPE,
      p_advice_id                 gicl_advice.advice_id%TYPE,
      p_paid_amt                  gicl_advice.paid_amt%TYPE,
      p_iss_cd                    gicl_advice.iss_cd%TYPE,
      p_conv_rt                   gicl_advice.convert_rate%TYPE,
      p_convert_rate              gicl_advice.convert_rate%TYPE,
      p_clm_loss_id               giac_batch_dv_dtl.clm_loss_id%TYPE,
      p_net_amt                   gicl_advice.net_amt%TYPE,
      p_currency_cd               gicl_advice.currency_cd%TYPE,
      p_payee_type                giac_direct_claim_payts.payee_type%TYPE,
      p_ri_iss_cd                 gicl_advice.iss_cd%TYPE,
      p_dv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_jv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_msg_alert        OUT      VARCHAR2,
      p_workflow_msgr    OUT      VARCHAR2,
      p_user_id          IN       VARCHAR2
   );
   
   PROCEDURE add_direct_claim_payments_2 (
      p_payee_cd                  giac_batch_dv.payee_cd%TYPE,
      p_payee_class_cd            giac_batch_dv.payee_class_cd%TYPE,
      p_claim_id                  gicl_advice.claim_id%TYPE,
      p_advice_id                 gicl_advice.advice_id%TYPE,
      p_paid_amt                  gicl_advice.paid_amt%TYPE,
      p_iss_cd                    gicl_advice.iss_cd%TYPE,
      p_conv_rt                   gicl_advice.convert_rate%TYPE,
      p_convert_rate              gicl_advice.convert_rate%TYPE,
      p_clm_loss_id               giac_batch_dv_dtl.clm_loss_id%TYPE,
      p_net_amt                   gicl_advice.net_amt%TYPE,
      p_currency_cd               gicl_advice.currency_cd%TYPE,
      p_payee_type                giac_direct_claim_payts.payee_type%TYPE,
      p_ri_iss_cd                 gicl_advice.iss_cd%TYPE,
      p_dv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_jv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_item_no          IN       NUMBER,
      p_msg_alert        OUT      VARCHAR2,
      p_workflow_msgr    OUT      VARCHAR2,
      p_user_id          IN       VARCHAR2
   );

   PROCEDURE add_direct_claim_payments_3 (
      p_payee_cd                  giac_batch_dv.payee_cd%TYPE,
      p_payee_class_cd            giac_batch_dv.payee_class_cd%TYPE,
      p_claim_id                  gicl_advice.claim_id%TYPE,
      p_advice_id                 gicl_advice.advice_id%TYPE,
      p_paid_amt                  gicl_advice.paid_amt%TYPE,
      p_iss_cd                    gicl_advice.iss_cd%TYPE,
      p_conv_rt                   gicl_advice.convert_rate%TYPE,
      p_convert_rate              gicl_advice.convert_rate%TYPE,
      p_clm_loss_id               giac_batch_dv_dtl.clm_loss_id%TYPE,
      p_net_amt                   gicl_advice.net_amt%TYPE,
      p_currency_cd               gicl_advice.currency_cd%TYPE,
      p_payee_type                giac_direct_claim_payts.payee_type%TYPE,
      p_ri_iss_cd                 gicl_advice.iss_cd%TYPE,
      p_dv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_jv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_item_no          IN       NUMBER,
      p_batch_id         IN       giac_batch_dv.batch_dv_id%TYPE,
      p_msg_alert        OUT      VARCHAR2,
      p_workflow_msgr    OUT      VARCHAR2,
      p_user_id          IN       VARCHAR2
   );

   PROCEDURE cancel_giac_batch (
      p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE,
      p_tran_id       giac_batch_dv.tran_id%TYPE
   );

   PROCEDURE giacs086_acct_ent_post_query (
      tran_id                giac_batch_dv.tran_id%TYPE,
      branch_cd              giac_batch_dv.branch_cd%TYPE,
      p_total_debit    OUT   NUMBER,
      p_total_credit   OUT   NUMBER
   );
    
   FUNCTION get_scsr_no(p_batch_dv_id GIAC_BATCH_DV.batch_dv_id%TYPE)
     RETURN VARCHAR2;    
     
   FUNCTION giac_batch_dv_giacs086(
         p_claim_id    giac_batch_dv_dtl.claim_id%TYPE
   )
   RETURN giac_batch_dv_tab PIPELINED;
   
   PROCEDURE validate_advice(
      p_advice_id gicl_advice.advice_id%TYPE,
      p_message OUT VARCHAR2
   );
   
   PROCEDURE add_claim_payments (
      p_payee_cd                  giac_batch_dv.payee_cd%TYPE,
      p_payee_class_cd            giac_batch_dv.payee_class_cd%TYPE,
      p_claim_id                  gicl_advice.claim_id%TYPE,
      p_advice_id                 gicl_advice.advice_id%TYPE,
      p_paid_amt                  gicl_advice.paid_amt%TYPE,
      p_iss_cd                    gicl_advice.iss_cd%TYPE,
      p_conv_rt                   gicl_advice.convert_rate%TYPE,
      p_convert_rate              gicl_advice.convert_rate%TYPE,
      p_clm_loss_id               giac_batch_dv_dtl.clm_loss_id%TYPE,
      p_net_amt                   gicl_advice.net_amt%TYPE,
      p_currency_cd               gicl_advice.currency_cd%TYPE,
      p_payee_type                giac_direct_claim_payts.payee_type%TYPE,
      p_ri_iss_cd                 gicl_advice.iss_cd%TYPE,
      p_dv_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_user_id          IN       VARCHAR2
   );
   
   PROCEDURE insert_giac_taxes_wheld (
      p_claim_id                  gicl_advice.claim_id%TYPE,
      p_advice_id                 gicl_advice.advice_id%TYPE,
      p_iss_cd                    gicl_advice.iss_cd%TYPE,
      p_ri_iss_cd                 gicl_advice.iss_cd%TYPE,
      p_batch_id         IN       giac_batch_dv.batch_dv_id%TYPE,
      p_msg_alert        OUT      VARCHAR2,
      p_workflow_msgr    OUT      VARCHAR2,
      p_user_id          IN       VARCHAR2
   );
   
END giac_batch_dv_pkg;
/
