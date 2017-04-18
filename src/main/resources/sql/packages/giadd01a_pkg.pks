CREATE OR REPLACE PACKAGE CPI.GIADD01A_PKG
AS
   
   TYPE get_giadd01a_type IS RECORD (
        company_address         VARCHAR2(200),
        company_name            VARCHAR2(200),
        request_date            VARCHAR2(200),
        tran_id                 GIAC_ACCT_ENTRIES.GACC_TRAN_ID%type,
        payee                   giac_payt_requests_dtl.PAYEE%type,
        payt_amt                giac_payt_requests_dtl.PAYT_AMT%type,
        particulars             giac_payt_requests_dtl.PARTICULARS%type,
        request_no              VARCHAR2(200),
        ouc_name                GIAC_OUCS.OUC_NAME%type,
        create_by               giis_users.USER_ID%type,
        currency_cd             giac_payt_requests_dtl.CURRENCY_CD%type,
        gacc_tran_id            GIAC_ACCT_ENTRIES.GACC_TRAN_ID%type,
        acct_entry_id           giac_acct_entries.ACCT_ENTRY_ID%type,
        gl_acct_id              giac_acct_entries.GL_ACCT_ID%type,
        sl_name                 giac_sl_lists.sl_name%type,
        acct_code               VARCHAR2(200),
        credit                  giac_acct_entries.CREDIT_AMT%type,
        debit                   giac_acct_entries.DEBIT_AMT%type,
        deb_cre                 giac_acct_entries.DEBIT_AMT%type,
        treasurer_name          giis_signatory_names.SIGNATORY%type,
        rsic_logo               VARCHAR2 (1000),
        gl_acct_sname           giac_chart_of_accts.GL_ACCT_SNAME%type     
        
   );
   TYPE get_giadd01a_payt_request_tab IS TABLE OF get_giadd01a_type;
   
   TYPE get_giadd01a_op_signatory_type IS RECORD (
        report_no               giac_documents.report_no%type,
        item_no                 giac_rep_signatory.item_no%type,
        c_label                 giac_rep_signatory.label%type,
        signatory               giis_signatory_names.SIGNATORY%type,
        designation             giis_signatory_names.DESIGNATION%type,     
        branch_cd               giac_documents.branch_cd%type,
        document_cd             giac_documents.DOCUMENT_CD%type

    );

   TYPE get_giadd01a_op_signatory_tab IS TABLE OF get_giadd01a_op_signatory_type;
   
   TYPE get_giadd01a_ap_signatory_type IS RECORD (
        d_report_no             giac_documents.report_no%type,
        d_item_no               giac_rep_signatory.item_no%type,
        d_label                 giac_rep_signatory.label%type,
        d_signatory             giis_signatory_names.SIGNATORY%type,
        d_designation           giis_signatory_names.DESIGNATION%type,
        d_branch_cd             giac_documents.branch_cd%type,
        d_documentation_cd      giac_documents.DOCUMENT_CD%type
      
   );
   
   TYPE get_giadd01a_ap_signatory_tab IS TABLE OF get_giadd01a_ap_signatory_type;


    FUNCTION get_payt_request(
          p_tran_id       GIAC_ACCT_ENTRIES.GACC_GFUN_FUND_CD%Type
    )
   
   RETURN get_giadd01a_payt_request_tab PIPELINED;

  FUNCTION get_op_signatory(
          p_report_id     GIIS_REPORTS.REPORT_ID%Type,
          p_branch_cd     GIAC_DOCUMENTS.BRANCH_CD%Type,
          p_document_cd   GIAC_DOCUMENTS.DOCUMENT_CD%Type,
          p_create_by     GIIS_USERS.USER_ID%Type
        )
   
   RETURN get_giadd01a_op_signatory_tab PIPELINED;
     FUNCTION get_ap_signatory(
          p_report_id     GIIS_REPORTS.REPORT_ID%Type,
          p_branch_cd     GIAC_DOCUMENTS.BRANCH_CD%Type,
          p_document_cd   GIAC_DOCUMENTS.DOCUMENT_CD%Type
        )
   
   RETURN get_giadd01a_ap_signatory_tab PIPELINED;
END;
/


