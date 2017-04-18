CREATE OR REPLACE PACKAGE BODY CPI.GIIS_DOCUMENT_PKG AS

  FUNCTION get_doc_text(p_title     GIIS_DOCUMENT.title%TYPE)
    RETURN VARCHAR2 IS
    v_text      VARCHAR2(2000);
  BEGIN
    FOR i IN (SELECT text
	 	        FROM giis_document
	 	       WHERE title = p_title)
    LOOP
      v_text := i.text;
    END LOOP;
    RETURN v_text;
  END get_doc_text;
  
  /*
  **  Created by   : Marco Paolo Rebong
  **  Date Created : November 19,2012
  **  Reference By : GIPIS090, GIPIS091
  **  Description  : checks if Print Premium Details should be displayed
  */
  FUNCTION check_print_premium_details(
    p_line_cd       GIIS_DOCUMENT.line_cd%TYPE
  )
    RETURN VARCHAR2
  IS
    v_text          GIIS_DOCUMENT.text%TYPE := NULL;
  BEGIN
    FOR i IN(SELECT text
               FROM GIIS_DOCUMENT a, GIIS_LINE b
              WHERE a.line_cd = NVL(b.menu_line_cd, b.line_cd)
                AND b.line_cd = p_line_cd
                AND a.report_id IN ('AVIATION','ACCIDENT','CASUALTY','ENGINEERING','FIRE','MOTORCAR','MARINE_HULL','MARINE_CARGO','PACKAGE')
                AND a.title = 'ALLOW_PRINT_PREMIUM_DETAILS')
    LOOP
        v_text := i.text;
    END LOOP;
    RETURN v_text;
  END;
  
  /*
  **  Created by   : Marco Paolo Rebong
  **  Date Created : November 20,2012
  **  Reference By : GIPIS090, GIPIS091, GIPIS900
  **  Description  : 
  */
  FUNCTION get_doc_text2(
    p_line_cd       GIIS_DOCUMENT.line_cd%TYPE,
    p_report_id     GIIS_DOCUMENT.report_id%TYPE,
    p_title         GIIS_DOCUMENT.title%TYPE
  )
    RETURN VARCHAR2
  IS
    v_text          GIIS_DOCUMENT.text%TYPE := NULL;
  BEGIN
    FOR i IN(SELECT text
               FROM GIIS_DOCUMENT a, GIIS_LINE b
              WHERE a.line_cd = nvl(b.menu_line_cd,b.line_cd)
                AND b.line_cd = p_line_cd
                AND a.report_id = p_report_id
                AND a.title = p_title)
    LOOP
        v_text := i.text;
    END LOOP;
    RETURN v_text;
  END;

END GIIS_DOCUMENT_PKG;
/


