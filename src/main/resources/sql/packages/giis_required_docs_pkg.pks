CREATE OR REPLACE PACKAGE CPI.GIIS_REQUIRED_DOCS_PKG AS

  TYPE req_docs_type IS RECORD (
	doc_cd			GIIS_REQUIRED_DOCS.doc_cd%TYPE,
	doc_name		GIIS_REQUIRED_DOCS.doc_name%TYPE
  );

  TYPE req_docs_tab IS TABLE OF req_docs_type;
  
  FUNCTION get_required_docs_list(p_line_cd   GIIS_REQUIRED_DOCS.line_cd%TYPE,
  		   						  p_subline_cd GIIS_REQUIRED_DOCS.subline_cd%TYPE) 
    RETURN req_docs_tab PIPELINED;  

END GIIS_REQUIRED_DOCS_PKG;
/


