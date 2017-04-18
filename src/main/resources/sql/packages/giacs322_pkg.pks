CREATE OR REPLACE PACKAGE CPI.GIACS322_PKG
AS
   TYPE rec_type IS RECORD (
      fund_cd         giac_doc_sequence.fund_cd%TYPE,
      branch_cd       giac_doc_sequence.branch_cd%TYPE,
      doc_name        giac_doc_sequence.doc_name%TYPE,
      doc_seq_no      giac_doc_sequence.doc_seq_no%TYPE,
      doc_pref_suf    giac_doc_sequence.doc_pref_suf%TYPE,
      approved_series giac_doc_sequence.approved_series%TYPE,
      remarks         giac_doc_sequence.remarks%TYPE,
      user_id         giac_doc_sequence.user_id%TYPE,
      last_update     VARCHAR2(30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list(
       p_fund_cd    VARCHAR2,
       p_branch_cd  VARCHAR2
   )
      RETURN rec_tab PIPELINED;
   PROCEDURE set_rec (p_rec GIAC_DOC_SEQUENCE%ROWTYPE);
   
   PROCEDURE del_rec (p_fund_cd    GIAC_DOC_SEQUENCE.fund_cd%TYPE, 
                    p_branch_cd  GIAC_DOC_SEQUENCE.branch_cd%TYPE,
                    p_doc_name   GIAC_DOC_SEQUENCE.doc_name%TYPE);

   FUNCTION val_del_rec (p_rep_cd giac_soa_title.rep_cd%TYPE)
   RETURN VARCHAR2;
   
   FUNCTION val_add_rec(
            p_fund_cd    GIAC_DOC_SEQUENCE.fund_cd%TYPE,          
            p_branch_cd  GIAC_DOC_SEQUENCE.branch_cd%TYPE,
            p_doc_name   GIAC_DOC_SEQUENCE.doc_name%TYPE
   )
   RETURN VARCHAR2;
   
   TYPE giacs322_company_lov_type IS RECORD (
       fund_cd     giis_funds.fund_cd%TYPE,
       fund_desc   giis_funds.fund_desc%TYPE
   ); 

   TYPE giacs322_company_lov_tab IS TABLE OF giacs322_company_lov_type;
   
   FUNCTION get_giacs322_company_lov(
        p_search        VARCHAR2
   )
   RETURN giacs322_company_lov_tab PIPELINED;
   
   TYPE giacs322_branch_lov_type IS RECORD (
       branch_cd     giac_branches.branch_cd%TYPE,
       branch_name   giac_branches.branch_name%TYPE
   ); 

   TYPE giacs322_branch_lov_tab IS TABLE OF giacs322_branch_lov_type;
   
   FUNCTION get_giacs322_branch_lov(
        p_fund_cd       VARCHAR2,
        p_search        VARCHAR2,
        p_user          VARCHAR2
   )
   RETURN giacs322_branch_lov_tab PIPELINED;

END;
/


