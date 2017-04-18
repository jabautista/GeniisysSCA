CREATE OR REPLACE PACKAGE CPI.gicl_clm_docs_pkg
AS
/******************************************************************************
   NAME:       gicl_clm_docs_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/9/2011   Irwin Tabisora 1. Created this package.
******************************************************************************/
   TYPE gicl_clm_docs_type IS RECORD (
      clm_doc_cd     gicl_clm_docs.clm_doc_cd%TYPE,
      clm_doc_desc   gicl_clm_docs.clm_doc_desc%TYPE
   );

   TYPE gicl_clm_docs_tab IS TABLE OF gicl_clm_docs_type;

   FUNCTION get_gicl_clm_docs (
      p_line_cd      gicl_clm_docs.line_cd%TYPE,
      p_subline_cd   gicl_clm_docs.subline_cd%TYPE,
      p_claim_id     gicl_claims.claim_id%type,
      p_find_text varchar2
   )
      RETURN gicl_clm_docs_tab PIPELINED;
END gicl_clm_docs_pkg;
/


