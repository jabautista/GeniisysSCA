CREATE OR REPLACE PACKAGE BODY CPI.GIIS_REQUIRED_DOCS_PKG AS

/*
**  Created by		: Bryan Joseph Abuluyan
**  Date Created 	: 03.04.2010
**  Reference By 	: (GIPIS029- Required Documents Submitted
**  Description 	: For addition of new documents submitted
*/
  FUNCTION get_required_docs_list(p_line_cd    GIIS_REQUIRED_DOCS.line_cd%TYPE,
  		   						  p_subline_cd GIIS_REQUIRED_DOCS.subline_cd%TYPE)
    RETURN req_docs_tab PIPELINED IS
	v_doc  				req_docs_type;
  BEGIN
    FOR i IN (SELECT *
	            FROM (SELECT a.doc_cd, a.doc_name
		  	 	        FROM GIIS_REQUIRED_DOCS a
    			            --,GIPI_WPOLBAS b
			           WHERE a.valid_flag 		= 'Y'
			             AND a.effectivity_date <= SYSDATE
				       	 AND a.line_cd 			= p_line_cd
				 		 AND a.subline_cd 		= p_subline_cd
			           UNION
			          SELECT a.doc_cd, a.doc_name
		  	 	        FROM GIIS_REQUIRED_DOCS a
    			            --,GIPI_WPOLBAS b
			           WHERE a.valid_flag 		= 'Y'
			             AND a.effectivity_date <= SYSDATE
				         AND a.line_cd 			= p_line_cd
				         AND a.subline_cd IS NULL)
			   ORDER BY UPPER(doc_name))
	LOOP
	  v_doc.doc_cd	 			  := i.doc_cd;
	  v_doc.doc_name			  := i.doc_name;
	  PIPE ROW(v_doc);
	END LOOP;
  END get_required_docs_list;

END GIIS_REQUIRED_DOCS_PKG;
/


