CREATE OR REPLACE PACKAGE BODY CPI.gipi_quote_principal_pkg
AS
   /* CREATED BY TONIO APRIL 16, 2011
     MODULE GIIMM010
   */
   FUNCTION get_principal_listing (
      p_quote_id         gipi_quote_principal.quote_id%TYPE,
      p_principal_type   giis_eng_principal.principal_type%TYPE
   )
      RETURN principal_listing_tab PIPELINED
   IS
      v_principal   principal_dtls_type;
   BEGIN
      FOR i IN (SELECT   gpp.quote_id, gpp.principal_cd,
                         gpp.engg_basic_infonum, gpp.subcon_sw,
                         gpe.principal_name
                    FROM gipi_quote_principal gpp, giis_eng_principal gpe
                   WHERE gpp.principal_cd IN (
                                      SELECT principal_cd
                                        FROM giis_eng_principal
                                       WHERE principal_type =
                                                             p_principal_type)
                     AND gpp.quote_id = p_quote_id
                     AND gpe.principal_cd = gpp.principal_cd
                ORDER BY gpp.principal_cd)
      LOOP
         v_principal.quote_id := i.quote_id;
         v_principal.principal_cd := i.principal_cd;
         v_principal.engg_basic_infonum := i.engg_basic_infonum;
         v_principal.subcon_sw := i.subcon_sw;
         v_principal.principal_name := i.principal_name;
         PIPE ROW (v_principal);
      END LOOP;
   END get_principal_listing;

   PROCEDURE save_principal_dtls (
      p_quote_id             gipi_quote_principal.quote_id%TYPE,
      p_principal_cd         gipi_quote_principal.principal_cd%TYPE,
      p_engg_basic_infonum   gipi_quote_principal.engg_basic_infonum%TYPE,
      p_subcon_sw            gipi_quote_principal.subcon_sw%TYPE,
      p_orig_principal_cd    gipi_quote_principal.principal_cd%TYPE
   )
   IS
   BEGIN
      /*
         MERGE INTO gipi_quote_principal
            USING DUAL
            ON (quote_id = p_quote_id)
            WHEN NOT MATCHED THEN
               INSERT (quote_id, principal_cd, engg_basic_infonum, subcon_sw)
               VALUES (p_quote_id, p_principal_cd, p_engg_basic_infonum,
                       p_subcon_sw)
            WHEN MATCHED THEN
               UPDATE
                  SET principal_cd = p_principal_cd,
                      engg_basic_infonum = p_engg_basic_infonum,
                      subcon_sw = p_subcon_sw
               ;*/
      UPDATE gipi_quote_principal
         SET principal_cd = p_principal_cd,
             engg_basic_infonum = p_engg_basic_infonum,
             subcon_sw = p_subcon_sw
       WHERE quote_id = p_quote_id AND principal_cd = p_orig_principal_cd;

      IF SQL%NOTFOUND
      THEN
         INSERT INTO gipi_quote_principal
              VALUES (p_quote_id, p_principal_cd, p_engg_basic_infonum,
                      p_subcon_sw);
      END IF;
   END save_principal_dtls;

   PROCEDURE delete_principal (
      p_quote_id       gipi_quote_principal.quote_id%TYPE,
      p_principal_cd   gipi_quote_principal.principal_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM gipi_quote_principal
            WHERE quote_id = p_quote_id AND principal_cd = p_principal_cd;
   END;

   FUNCTION get_gipi_quote_principal_list (
      p_quote_id         gipi_quote_principal.quote_id%TYPE
   )
      RETURN principal_listing_tab PIPELINED
   IS
      v_principal   principal_dtls_type;
   BEGIN
      FOR i IN (SELECT   gpp.quote_id, gpp.principal_cd,
                         gpp.engg_basic_infonum, gpp.subcon_sw,
                         gpe.principal_name, gpe.principal_type
                    FROM gipi_quote_principal gpp, giis_eng_principal gpe
                   WHERE gpp.quote_id = p_quote_id
                     AND gpe.principal_cd = gpp.principal_cd
                ORDER BY gpp.principal_cd)
      LOOP
         v_principal.quote_id := i.quote_id;
         v_principal.principal_cd := i.principal_cd;
         v_principal.engg_basic_infonum := i.engg_basic_infonum;
         v_principal.subcon_sw := i.subcon_sw;
         v_principal.principal_name := i.principal_name;
         v_principal.principal_type := i.principal_type;
         PIPE ROW (v_principal);
      END LOOP;
   END get_gipi_quote_principal_list;


   PROCEDURE set_gipi_quote_principal (
      p_quote_id             gipi_quote_principal.quote_id%TYPE,
      p_principal_cd         gipi_quote_principal.principal_cd%TYPE,
      p_engg_basic_infonum   gipi_quote_principal.engg_basic_infonum%TYPE,
      p_subcon_sw            gipi_quote_principal.subcon_sw%TYPE)

      IS

   BEGIN
        MERGE INTO gipi_quote_principal
        USING DUAL
        ON (quote_id = p_quote_id
            AND engg_basic_infonum = p_engg_basic_infonum
            AND principal_cd = p_principal_cd)
        WHEN NOT MATCHED THEN
           INSERT (quote_id, principal_cd, engg_basic_infonum, subcon_sw)
           VALUES (p_quote_id, p_principal_cd, p_engg_basic_infonum,
                   p_subcon_sw)
        WHEN MATCHED THEN
           UPDATE
              SET subcon_sw = p_subcon_sw;
   END;
END gipi_quote_principal_pkg;
/


