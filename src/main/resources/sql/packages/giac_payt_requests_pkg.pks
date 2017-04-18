CREATE OR REPLACE PACKAGE CPI.GIAC_PAYT_REQUESTS_PKG
AS
   TYPE giac_payt_requests_type IS RECORD
   (
      gouc_ouc_id        GIAC_PAYT_REQUESTS.gouc_ouc_id%TYPE,
      ref_id             GIAC_PAYT_REQUESTS.ref_id%TYPE,
      fund_cd            GIAC_PAYT_REQUESTS.fund_cd%TYPE,
      branch_cd          GIAC_PAYT_REQUESTS.branch_cd%TYPE,
      document_cd        GIAC_PAYT_REQUESTS.document_cd%TYPE,
      doc_seq_no         GIAC_PAYT_REQUESTS.doc_seq_no%TYPE, 
      request_date       GIAC_PAYT_REQUESTS.request_date%TYPE,
      line_cd            GIAC_PAYT_REQUESTS.line_cd%TYPE,
      doc_year           GIAC_PAYT_REQUESTS.doc_year%TYPE,
      doc_mm             GIAC_PAYT_REQUESTS.doc_mm%TYPE,
      user_id            GIAC_PAYT_REQUESTS.user_id%TYPE,
      last_update        GIAC_PAYT_REQUESTS.last_update%TYPE,
      cpi_rec_no         GIAC_PAYT_REQUESTS.cpi_rec_no%TYPE,
      cpi_branch_cd      GIAC_PAYT_REQUESTS.cpi_branch_cd%TYPE,
      with_dv            GIAC_PAYT_REQUESTS.with_dv%TYPE,
      create_by          GIAC_PAYT_REQUESTS.create_by%TYPE,
      upload_tag         GIAC_PAYT_REQUESTS.upload_tag%TYPE,
      rf_replenish_tag   GIAC_PAYT_REQUESTS.rf_replenish_tag%TYPE,
      dsp_dept_cd        GIAC_OUCS.ouc_cd%TYPE,
      dsp_fund_desc      GIIS_FUNDS.fund_desc%TYPE,
      dsp_branch_name    giac_branches.branch_name%TYPE,
      dsp_ouc_name       giac_oucs.ouc_name%TYPE
   );

   TYPE giac_payt_requests_tab IS TABLE OF giac_payt_requests_type;

   TYPE clm_payt_req_type IS RECORD
   (
      ref_id         GIAC_PAYT_REQUESTS.ref_id%TYPE,
      request_no     VARCHAR2 (100),
      ouc_name       GIAC_OUCS.ouc_name%TYPE,
      request_date   GIAC_PAYT_REQUESTS.request_date%TYPE,
      payee          GIAC_PAYT_REQUESTS_DTL.payee%TYPE,
      particulars    GIAC_PAYT_REQUESTS_DTL.particulars%TYPE,
      create_by      GIAC_PAYT_REQUESTS.create_by%TYPE,
      status         CG_REF_CODES.rv_meaning%TYPE
   );

   TYPE clm_payt_req_tab IS TABLE OF clm_payt_req_type;

   FUNCTION get_clm_payt_req_listing (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_payt_req_flag   GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,  -- shan 11.04.2014
      p_status          CG_REF_CODES.rv_meaning%TYPE,
      p_payee           GIAC_PAYT_REQUESTS_DTL.payee%TYPE,
      p_request_no      VARCHAR2,
      p_request_date    VARCHAR2,
      p_particulars     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE,
      p_create_by       GIAC_PAYT_REQUESTS.create_by%TYPE,
      p_branch_cd       GIAC_PAYT_REQUESTS.branch_cd%TYPE)
      RETURN clm_payt_req_tab
      PIPELINED;

   FUNCTION get_facul_prem_payt_listing (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_payt_req_flag   GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,  -- shan 11.04.2014
      p_status          CG_REF_CODES.rv_meaning%TYPE,
      p_payee           GIAC_PAYT_REQUESTS_DTL.payee%TYPE,
      p_request_no      VARCHAR2,
      p_request_date    VARCHAR2,
      p_particulars     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE,
      p_create_by       GIAC_PAYT_REQUESTS.create_by%TYPE,
      p_branch_cd       GIAC_PAYT_REQUESTS.branch_cd%TYPE)
      RETURN clm_payt_req_tab
      PIPELINED;

   FUNCTION get_comm_payt_listing (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_payt_req_flag   GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,  -- shan 11.04.2014
      p_status          CG_REF_CODES.rv_meaning%TYPE,
      p_payee           GIAC_PAYT_REQUESTS_DTL.payee%TYPE,
      p_request_no      VARCHAR2,
      p_request_date    VARCHAR2,
      p_particulars     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE,
      p_create_by       GIAC_PAYT_REQUESTS.create_by%TYPE,
      p_branch_cd       GIAC_PAYT_REQUESTS.branch_cd%TYPE)
      RETURN clm_payt_req_tab
      PIPELINED;

   FUNCTION get_other_payt_listing (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_payt_req_flag   GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,  -- shan 11.04.2014
      p_status          CG_REF_CODES.rv_meaning%TYPE,
      p_payee           GIAC_PAYT_REQUESTS_DTL.payee%TYPE,
      p_request_no      VARCHAR2,
      p_request_date    VARCHAR2,
      p_particulars     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE,
      p_create_by       GIAC_PAYT_REQUESTS.create_by%TYPE,
      p_branch_cd       GIAC_PAYT_REQUESTS.branch_cd%TYPE)
      RETURN clm_payt_req_tab
      PIPELINED;

   FUNCTION get_cancel_req_listing (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_payt_req_flag   GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,  -- shan 11.04.2014
      p_status          CG_REF_CODES.rv_meaning%TYPE,
      p_payee           GIAC_PAYT_REQUESTS_DTL.payee%TYPE,
      p_request_no      VARCHAR2,
      p_request_date    VARCHAR2,
      p_particulars     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE,
      p_create_by       GIAC_PAYT_REQUESTS.create_by%TYPE,
      p_branch_cd       GIAC_PAYT_REQUESTS.branch_cd%TYPE)
      RETURN clm_payt_req_tab
      PIPELINED;

   FUNCTION get_giac_payt_requests (p_ref_id GIAC_PAYT_REQUESTS.ref_id%TYPE)
      RETURN giac_payt_requests_tab
      PIPELINED;

   PROCEDURE set_giac_payt_requests (
      p_giac_payt_requests giac_payt_requests%ROWTYPE);

   FUNCTION get_closed_tag (
      p_fund_cd        giac_tran_mm.fund_cd%TYPE,
      p_date        IN giac_acctrans.tran_date%TYPE,
      p_branch_cd      GIAC_PAYT_REQUESTS.branch_cd%TYPE)
      RETURN VARCHAR2;

   PROCEDURE get_fund_branch_desc (
      p_fund_cd         giac_tran_mm.fund_cd%TYPE,
      p_branch_cd       GIAC_PAYT_REQUESTS.branch_cd%TYPE,
      fund_desc     OUT VARCHAR2,
      branch_name   OUT VARCHAR2);


   TYPE POPULATE_CHK_TAGS_type IS RECORD
   (
      var_document_name   GIAC_PAYT_REQ_DOCS.document_name%TYPE,
      var_LINE_CD_TAG     GIAC_PAYT_REQ_DOCS.line_cd_tag%TYPE,
      var_yy_tag          GIAC_PAYT_REQ_DOCS.YY_TAG%TYPE,
      var_mm_TAG          GIAC_PAYT_REQ_DOCS.MM_TAG%TYPE
   );

   TYPE POPULATE_CHK_TAGS_tab IS TABLE OF POPULATE_CHK_TAGS_type;

   FUNCTION POPULATE_CHK_TAGS (
      p_fund_cd        GIAC_PAYT_REQ_DOCS.GIBR_GFUN_FUND_CD%TYPE,
      p_branch_cd      GIAC_PAYT_REQ_DOCS.GIBR_BRANCH_CD%TYPE,
      p_document_cd    GIAC_PAYT_REQ_DOCS.document_cd%TYPE)
      RETURN POPULATE_CHK_TAGS_tab
      PIPELINED;

   PROCEDURE close_disbursement_request (
      p_ref_id             GIAC_PAYT_REQUESTS.ref_id%TYPE,
      p_req_dtl_no         GIAC_PAYT_REQUESTS_dtl.req_dtl_no%TYPE,
      p_tran_id            GIAC_PAYT_REQUESTS_dtl.tran_id%TYPE,
      p_user_id            giac_payt_requests.user_id%TYPE,
      p_document_cd        giac_payt_requests.document_cd%TYPE,
      p_branch_cd          giac_payt_requests.branch_cd%TYPE,
      p_line_cd            giac_payt_requests.line_cd%TYPE,
      p_doc_year           giac_payt_requests.doc_year%TYPE,
      p_doc_mm             giac_payt_requests.doc_mm%TYPE,
      p_doc_seq_no         giac_payt_requests.doc_seq_no%TYPE,
      p_workflow_msg   OUT VARCHAR2,
      p_msg_alert      OUT VARCHAR2);

   PROCEDURE cancel_payment_request (
      p_ref_id     GIAC_PAYT_REQUESTS.ref_id%TYPE,
      p_tran_id    GIAC_PAYT_REQUESTS_dtl.tran_id%TYPE,
	  p_user_id            giac_payt_requests.user_id%TYPE);
   
   -- for GIACS002   
   TYPE payt_line_cd_type IS RECORD (
      line_cd              giac_payt_requests.line_cd%TYPE,
      line_name            giis_line.line_name%TYPE
   );
      
   TYPE payt_line_cd_tab IS TABLE OF payt_line_cd_type;
   
   FUNCTION get_payt_line_cd_list(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_module_id         giis_modules_tran.module_id%TYPE,
        p_user_id           giac_payt_requests.user_id%TYPE
   ) RETURN payt_line_cd_tab PIPELINED;
   
   
   FUNCTION get_doc_yy_list(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_module_id         giis_modules_tran.module_id%TYPE,
        p_user_id           giac_payt_requests.user_id%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE
   ) RETURN giac_payt_requests_tab PIPELINED;
   
   FUNCTION get_doc_mm_list(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_module_id         giis_modules_tran.module_id%TYPE,
        p_user_id           giac_payt_requests.user_id%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE,
        p_doc_year          giac_payt_requests.doc_year%TYPE
   ) RETURN giac_payt_requests_tab PIPELINED;
   
   TYPE payt_disb_type IS RECORD (
        fund_cd                 giac_payt_requests.fund_cd%TYPE,
        doc_seq_no              giac_payt_requests.doc_seq_no%TYPE,
        payt_req_no             VARCHAR2(50),
        document_name           giac_payt_req_docs.document_name%TYPE,
        tran_id                 giac_payt_requests_dtl.tran_id%TYPE,
        ref_id                  giac_payt_requests.ref_id%TYPE,
        req_dtl_no              giac_payt_requests_dtl.req_dtl_no%TYPE,
        request_date            giac_payt_requests.request_date%TYPE,
        gouc_ouc_id             giac_payt_requests.gouc_ouc_id%TYPE,
        ouc_cd                  giac_oucs.ouc_cd%TYPE,
        ouc_name                giac_oucs.ouc_name%TYPE,
        payee_class_cd          giac_payt_requests_dtl.payee_class_cd%TYPE,
        class_desc              giis_payee_class.class_desc%TYPE,
        payee_cd                giac_payt_requests_dtl.payee_cd%TYPE,
        payee                   giac_payt_requests_dtl.payee%TYPE,
        payt_amt                giac_payt_requests_dtl.payt_amt%TYPE,
        particulars             giac_payt_requests_dtl.particulars%TYPE,
        currency_cd             giac_payt_requests_dtl.currency_cd%TYPE,
        currency_desc           giis_currency.currency_desc%TYPE,
        dv_fcurrency_amt        giac_payt_requests_dtl.dv_fcurrency_amt%TYPE,
        currency_rt             giac_payt_requests_dtl.currency_rt%TYPE
   );
   
   TYPE payt_disb_tab IS TABLE OF payt_disb_type;
   
   FUNCTION get_doc_seq_no_list(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_module_id         giis_modules_tran.module_id%TYPE,
        p_user_id           giac_payt_requests.user_id%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE,
        p_doc_year          giac_payt_requests.doc_year%TYPE,
        p_doc_mm            giac_payt_requests.doc_mm%TYPE
   ) RETURN payt_disb_tab PIPELINED;
   
   FUNCTION validate_doc_seq_no(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE,
        p_doc_year          giac_payt_requests.doc_year%TYPE,
        p_doc_mm            giac_payt_requests.doc_mm%TYPE,
        p_doc_seq_no        giac_payt_requests.doc_seq_no%TYPE
   ) RETURN payt_disb_tab PIPELINED;
   
    PROCEDURE validate_payt_line_cd(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE,
        p_line_cd_tag       giac_payt_req_docs.line_cd_tag%TYPE
   );
   
   PROCEDURE validate_doc_yy(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE,
        p_doc_year          giac_payt_requests.doc_year%TYPE,
        p_nbt_yy_tag        giac_payt_req_docs.yy_tag%TYPE
   );
   
   PROCEDURE validate_doc_mm(
        p_fund_cd           giac_payt_requests.fund_cd%TYPE,
        p_branch_cd         giac_payt_requests.branch_cd%TYPE,
        p_document_cd       giac_payt_requests.document_cd%TYPE,
        p_line_cd           giac_payt_requests.line_cd%TYPE,
        p_doc_year          giac_payt_requests.doc_year%TYPE,
        p_doc_mm            giac_payt_requests.doc_mm%TYPE,
        p_nbt_mm_tag        giac_payt_req_docs.yy_tag%TYPE
   );
   
END GIAC_PAYT_REQUESTS_PKG;
/


