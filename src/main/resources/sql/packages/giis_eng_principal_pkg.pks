CREATE OR REPLACE PACKAGE CPI.giis_eng_principal_pkg
AS
   TYPE principal_dtls_type IS RECORD (
      principal_cd     giis_eng_principal.principal_cd%TYPE,
      principal_name   giis_eng_principal.principal_name%TYPE,
      principal_type   giis_eng_principal.principal_type%TYPE
   );

   TYPE principal_dtls_tab IS TABLE OF principal_dtls_type;

   FUNCTION get_principal_dtls (
      p_principal_type   giis_eng_principal.principal_type%TYPE,
	  p_subline_cd   	 giis_eng_principal.subline_cd%TYPE
   )
      RETURN principal_dtls_tab PIPELINED;
END giis_eng_principal_pkg;
/


