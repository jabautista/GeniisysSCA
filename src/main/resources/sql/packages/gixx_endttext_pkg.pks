CREATE OR REPLACE PACKAGE CPI.GIXX_ENDTTEXT_PKG AS

    TYPE pol_doc_endttext_type IS RECORD (
        extract_id6         GIXX_ENDTTEXT.extract_id%TYPE,
        endttext_endt_text  GIXX_ENDTTEXT.endt_text01%TYPE
        );
    
    TYPE pol_doc_endttext_tab IS TABLE OF pol_doc_endttext_type;
    
    FUNCTION get_pol_doc_endttext RETURN pol_doc_endttext_tab PIPELINED;

END GIXX_ENDTTEXT_PKG;
/


