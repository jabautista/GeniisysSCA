CREATE OR REPLACE PACKAGE CPI.giac_replenish_dv_pkg
IS
   /**
       Package created by Irwin C. Tabisora
       DATE: Nov. 6, 2012
   */
   TYPE giac_replenish_dv_type IS RECORD (
      replenish_id         giac_replenish_dv.replenish_id%TYPE,
      branch_cd            giac_replenish_dv.branch_cd%TYPE,
      replenish_seq_no     giac_replenish_dv.replenish_seq_no%TYPE,
      revolving_fund_amt   giac_replenish_dv.revolving_fund_amt%TYPE,
      replenishment_amt    giac_replenish_dv.replenishment_amt%TYPE,
      replenish_tran_id    giac_replenish_dv.replenish_tran_id%TYPE,
      create_by            giac_replenish_dv.create_by%TYPE,
      create_date          giac_replenish_dv.create_date%TYPE,
      str_create_date      VARCHAR2 (30),
      replenish_year       giac_replenish_dv.replenish_year%TYPE,
      replenish_no         VARCHAR2 (100)
   );

   TYPE giac_replenish_dv_tab IS TABLE OF giac_replenish_dv_type;

   TYPE giacs016_rf_detail_type IS RECORD (
      dsp_dv_pref          giac_disb_vouchers.dv_pref%TYPE,
      dsp_dv_no            giac_disb_vouchers.dv_no%TYPE,
      dsp_branch_cd        giac_replenish_dv.branch_cd%TYPE,
      dsp_check_pref_suf   giac_chk_disbursement.check_pref_suf%TYPE,
      dsp_check_no         giac_chk_disbursement.check_no%TYPE,
      dsp_document_cd      giac_payt_requests.document_cd%TYPE,
      dsp_req_branch       giac_payt_requests.branch_cd%TYPE,
      dsp_line_cd          giac_payt_requests.line_cd%TYPE,
      dsp_doc_year         giac_payt_requests.doc_year%TYPE,
      dsp_doc_mm           giac_payt_requests.doc_mm%TYPE,
      dsp_doc_seq_no       giac_payt_requests.doc_seq_no%TYPE,
      dsp_payee            giac_chk_disbursement.payee%TYPE,
      dsp_particulars      giac_disb_vouchers.particulars%TYPE,
      dsp_amount           giac_replenish_dv_dtl.amount%TYPE,
      dv_tran_id           giac_replenish_dv_dtl.dv_tran_id%TYPE,
      check_item_no        giac_replenish_dv_dtl.CHECK_ITEM_NO%TYPE,    -- shan 10.09.2014
      dsp_include_tag      VARCHAR2 (1)
   );

   TYPE giacs016_rf_detail_tab IS TABLE OF giacs016_rf_detail_type;

   FUNCTION get_replinish_no_lov (p_find_text VARCHAR2)
      RETURN giac_replenish_dv_tab PIPELINED;

   FUNCTION get_giacs016_rf_detail_list (
      p_replenish_id   giac_replenish_dv.replenish_id%TYPE,
      p_find_text      VARCHAR2
   )
      RETURN giacs016_rf_detail_tab PIPELINED;

   PROCEDURE get_rf_detail_amounts (
      p_replenish_id                giac_replenish_dv_dtl.replenish_id%TYPE,
      v_dsp_requested_amt     OUT   giac_replenish_dv_dtl.amount%TYPE,
      v_dsp_disapproved_amt   OUT   giac_replenish_dv_dtl.amount%TYPE,
      v_dsp_approved_amt      OUT   giac_replenish_dv_dtl.amount%TYPE
   );

   PROCEDURE update_include_tag (
      p_replenish_id   giac_replenish_dv_dtl.replenish_id%TYPE,
      p_dv_tran_id     giac_replenish_dv_dtl.dv_tran_id%TYPE,
      p_check_item_no  giac_replenish_dv_dtl.CHECK_ITEM_NO%TYPE,    -- shan 10.03.2014
      p_include_tag    giac_replenish_dv_dtl.include_tag%TYPE
   );
   
   PROCEDURE giacs016_acct_ent_post_query (
       p_replenish_id           giac_batch_dv.tran_id%TYPE,
      p_total_debit    OUT   NUMBER,
      p_total_credit   OUT   NUMBER
   );
END;
/


