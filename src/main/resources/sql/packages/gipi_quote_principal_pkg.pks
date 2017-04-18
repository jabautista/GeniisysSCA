CREATE OR REPLACE PACKAGE CPI.gipi_quote_principal_pkg
AS
   TYPE principal_dtls_type IS RECORD (
      quote_id             gipi_quote_principal.quote_id%TYPE,
      principal_cd         gipi_quote_principal.principal_cd%TYPE,
      engg_basic_infonum   gipi_quote_principal.engg_basic_infonum%TYPE,
      subcon_sw            gipi_quote_principal.subcon_sw%TYPE,
      principal_name       giis_eng_principal.principal_name%TYPE,
      principal_type       giis_eng_principal.principal_type%TYPE
   );

   TYPE principal_listing_tab IS TABLE OF principal_dtls_type;

   FUNCTION get_principal_listing (
      p_quote_id         gipi_quote_principal.quote_id%TYPE,
      p_principal_type   giis_eng_principal.principal_type%TYPE
   )
      RETURN principal_listing_tab PIPELINED;

   PROCEDURE save_principal_dtls (
      p_quote_id             gipi_quote_principal.quote_id%TYPE,
      p_principal_cd         gipi_quote_principal.principal_cd%TYPE,
      p_engg_basic_infonum   gipi_quote_principal.engg_basic_infonum%TYPE,
      p_subcon_sw            gipi_quote_principal.subcon_sw%TYPE,
      p_orig_principal_cd    gipi_quote_principal.principal_cd%TYPE
   );

   PROCEDURE delete_principal (
      p_quote_id       gipi_quote_principal.quote_id%TYPE,
      p_principal_cd   gipi_quote_principal.principal_cd%TYPE
   );
   
   FUNCTION get_gipi_quote_principal_list (
      p_quote_id         gipi_quote_principal.quote_id%TYPE
   )
      RETURN principal_listing_tab PIPELINED;
   
   PROCEDURE set_gipi_quote_principal (
      p_quote_id             gipi_quote_principal.quote_id%TYPE,
      p_principal_cd         gipi_quote_principal.principal_cd%TYPE,
      p_engg_basic_infonum   gipi_quote_principal.engg_basic_infonum%TYPE,
      p_subcon_sw            gipi_quote_principal.subcon_sw%TYPE
   );
   
END gipi_quote_principal_pkg;
/


