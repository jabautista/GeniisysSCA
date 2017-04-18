CREATE OR REPLACE PACKAGE CPI.gicl_reqd_docs_pkg
AS
/******************************************************************************
   NAME:       GICL_REQD_DOCS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/5/2011    Irwin Tabisora  1. Created this package.
******************************************************************************/
   TYPE gicl_reqd_docs_type IS RECORD (
      clm_doc_cd      gicl_reqd_docs.clm_doc_cd%TYPE,
      clm_doc_desc    VARCHAR2 (1000),
      doc_sbmttd_dt   VARCHAR2 (10),
      doc_cmpltd_dt   VARCHAR2 (10),
      rcvd_by         gicl_reqd_docs.rcvd_by%TYPE,
      frwd_by         giis_issource.iss_name%TYPE, --gicl_reqd_docs.frwd_by%TYPE, edited by steven 11.13.2012
      frwd_fr         gicl_reqd_docs.frwd_fr%TYPE,
      remarks         gicl_reqd_docs.remarks%TYPE,
      user_id         gicl_reqd_docs.user_id%TYPE,
      last_update     gicl_reqd_docs.last_update%TYPE,
      lastupdate      VARCHAR2 (30)
   );

   TYPE gicl_reqd_docs_tab IS TABLE OF gicl_reqd_docs_type;

   FUNCTION get_document_listing (p_claim_id gicl_reqd_docs.claim_id%TYPE)
      RETURN gicl_reqd_docs_tab PIPELINED;

   PROCEDURE save_reqd_docs (
      p_claim_id        gicl_reqd_docs.claim_id%TYPE,
      p_clm_doc_cd      gicl_reqd_docs.clm_doc_cd%TYPE,
      p_line_cd         gicl_reqd_docs.line_cd%TYPE,
      p_subline_cd      gicl_reqd_docs.subline_cd%TYPE,
      p_iss_cd          gicl_reqd_docs.iss_cd%TYPE,
      p_doc_sbmttd_dt   gicl_reqd_docs.doc_sbmttd_dt%TYPE,
      p_doc_cmpltd_dt   gicl_reqd_docs.doc_cmpltd_dt%TYPE,
      p_rcvd_by         gicl_reqd_docs.rcvd_by%TYPE,
      p_frwd_by         gicl_reqd_docs.frwd_by%TYPE,
      p_frwd_fr         gicl_reqd_docs.frwd_fr%TYPE,
      p_remarks         gicl_reqd_docs.remarks%TYPE,
      p_user_id         gicl_reqd_docs.user_id%TYPE
   );

   PROCEDURE del_reqd_docs (
      p_claim_id     gicl_reqd_docs.claim_id%TYPE,
      p_clm_doc_cd   gicl_reqd_docs.clm_doc_cd%TYPE
   );

   TYPE pre_print_type IS RECORD (
      send_to_cd       giis_payee_class.class_desc%TYPE,
      address          VARCHAR2 (175),
      attention        VARCHAR2 (270),
      beginning_text   giis_document.text%TYPE,
      ending_text      giis_document.text%TYPE
   );

   TYPE pre_print_tab IS TABLE OF pre_print_type;

   FUNCTION get_pre_print_details (p_assured_name VARCHAR2, p_call_out VARCHAR2)
      RETURN pre_print_tab PIPELINED;
      
    FUNCTION validate_clm_req_docs(p_claim_id       gicl_claims.claim_id%TYPE)
    RETURN VARCHAR2;
          
END gicl_reqd_docs_pkg;
/


