CREATE OR REPLACE PACKAGE CPI.giac_payt_requests_dtl_pkg
AS
   TYPE giac_payt_requests_dtl_type2 IS RECORD (
      req_dtl_no           giac_payt_requests_dtl.req_dtl_no%TYPE,
      gprq_ref_id          giac_payt_requests_dtl.gprq_ref_id%TYPE,
      payee_class_cd       giac_payt_requests_dtl.payee_class_cd%TYPE,
      payt_req_flag        giac_payt_requests_dtl.payt_req_flag%TYPE,
      payee_cd             giac_payt_requests_dtl.payee_cd%TYPE,
      payee                giac_payt_requests_dtl.payee%TYPE,
      currency_cd          giac_payt_requests_dtl.currency_cd%TYPE,
      payt_amt             giac_payt_requests_dtl.payt_amt%TYPE,
      tran_id              giac_payt_requests_dtl.tran_id%TYPE,
      cpi_rec_no           giac_payt_requests_dtl.cpi_rec_no%TYPE,
      cpi_branch_cd        giac_payt_requests_dtl.cpi_branch_cd%TYPE,
      particulars          giac_payt_requests_dtl.particulars%TYPE,
      user_id              giac_payt_requests_dtl.user_id%TYPE,
      last_update          giac_payt_requests_dtl.last_update%TYPE,
      cancel_by            giac_payt_requests_dtl.cancel_by%TYPE,
      cancel_date          giac_payt_requests_dtl.cancel_date%TYPE,
      dv_fcurrency_amt     giac_payt_requests_dtl.dv_fcurrency_amt%TYPE,
      currency_rt          giac_payt_requests_dtl.currency_rt%TYPE,
      comm_tag             giac_payt_requests_dtl.comm_tag%TYPE,
      replenish_id         giac_payt_requests_dtl.replenish_id%TYPE,
      dsp_fshort_name      giis_currency.short_name%TYPE,
      dsp_short_name       giac_parameters.param_value_v%TYPE,
      mean_payt_req_flag   cg_ref_codes.rv_meaning%TYPE,
      nbt_replenish_no     VARCHAR2 (32000),
      nbt_replenish_amt    giac_replenish_dv.replenishment_amt%TYPE,
      acct_ent_exist     varchar2(1),
      str_last_update   varchar2(30)
   );

   TYPE giac_payt_requests_dtl_tab2 IS TABLE OF giac_payt_requests_dtl_type2;

   TYPE giac_payt_req_dtl_type IS RECORD (
      ref_id           giac_payt_requests.ref_id%TYPE,
      payee_class_cd   giac_payt_requests_dtl.payee_class_cd%TYPE,
      payee_cd         giac_payt_requests_dtl.payee_cd%TYPE,
      payee            giac_payt_requests_dtl.payee%TYPE,
      payt_amt         giac_payt_requests_dtl.payt_amt%TYPE,
      particulars      giac_payt_requests_dtl.particulars%TYPE,
      payt_req_flag    giac_payt_requests_dtl.payt_req_flag%TYPE,
      claim_id         giac_inw_claim_payts.claim_id%TYPE,
      advice_id        giac_inw_claim_payts.advice_id%TYPE,
      csr_no           VARCHAR2 (100)
   );

   TYPE giac_payt_req_dtl_tab IS TABLE OF giac_payt_req_dtl_type;

   FUNCTION get_payt_req_dtl_list (
      p_claim_id    giac_inw_claim_payts.claim_id%TYPE,
      p_advice_id   giac_inw_claim_payts.advice_id%TYPE
   )
      RETURN giac_payt_req_dtl_tab PIPELINED;

   FUNCTION get_giac_payt_requests_dtl (
      p_ref_id   giac_payt_requests_dtl.gprq_ref_id%TYPE
   )
      RETURN giac_payt_requests_dtl_tab2 PIPELINED;

   PROCEDURE set_payt_request_dtl (
      p_payt_request_dtl   giac_payt_requests_dtl%ROWTYPE
   );
   
    PROCEDURE giacs016_grqd_pre_insert (
   p_ref_id giac_payt_requests.ref_id%TYPE,
      p_fund_cd     giac_payt_requests.fund_cd%TYPE,
      p_branch_cd   giac_payt_requests.branch_cd%TYPE,
       p_user_id           giac_payt_requests.user_id%TYPE,
       p_label varchar2,
      p_workflow_msg out varchar2,
      p_msg_alert out varchar2,
	   v_tran_id       OUT   giac_payt_requests_dtl.tran_id%TYPE
   );

   PROCEDURE insert_into_acctrans (
      p_fund_cd           giac_payt_requests.fund_cd%TYPE,
      p_branch_cd         giac_payt_requests.branch_cd%TYPE,
      p_user_id  giac_payt_requests.user_id%TYPE,
      v_tran_id       OUT   giac_payt_requests_dtl.tran_id%TYPE
   );
END giac_payt_requests_dtl_pkg;
/


