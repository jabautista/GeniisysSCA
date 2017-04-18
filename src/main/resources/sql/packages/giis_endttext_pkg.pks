CREATE OR REPLACE PACKAGE CPI.giis_endttext_Pkg AS

    TYPE giis_endttext_type IS RECORD (
		endt_cd		giis_endttext.endt_cd%TYPE,
		--endt_title	CLOB,--giis_endttext.endt_title%TYPE,
		--endt_text	CLOB--giis_endttext.endt_text%TYPE
		endt_title	giis_endttext.endt_title%TYPE,
		endt_text	giis_endttext.endt_text%TYPE
     );
     
    TYPE giis_endttext_tab IS TABLE OF giis_endttext_type; 
     
    FUNCTION get_endttext_list (p_keyword        VARCHAR2)
      RETURN giis_endttext_tab PIPELINED;
         
END giis_endttext_Pkg;
/


