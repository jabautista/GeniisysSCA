CREATE OR REPLACE PACKAGE BODY CPI.giis_eng_principal_pkg
AS
   FUNCTION get_principal_dtls (
      p_principal_type   giis_eng_principal.principal_type%TYPE,
	  p_subline_cd   	 giis_eng_principal.subline_cd%TYPE
   )
      RETURN principal_dtls_tab PIPELINED
   IS
      v_principal   principal_dtls_type;
   BEGIN
      FOR i IN (SELECT principal_cd principal_cd, principal_name,
                       principal_type
                  FROM giis_eng_principal
                 WHERE principal_type = p_principal_type
				   AND subline_cd = p_subline_cd
				 ORDER BY principal_name)
      LOOP
         v_principal.principal_cd := i.principal_cd;
         v_principal.principal_name := i.principal_name;
         v_principal.principal_type := i.principal_type;
		 PIPE ROW(v_principal);
      END LOOP;
   END get_principal_dtls;
END giis_eng_principal_pkg;
/


