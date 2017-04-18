CREATE OR REPLACE PACKAGE CPI.gipi_quote_mort_pkg
AS
   TYPE gipi_quote_mort_type IS RECORD (
      quote_id      gipi_quote_mortgagee.quote_id%TYPE,
      iss_cd        gipi_quote_mortgagee.iss_cd%TYPE,
      item_no       gipi_quote_mortgagee.item_no%TYPE,
      mortg_cd      gipi_quote_mortgagee.mortg_cd%TYPE,
      mortg_name    giis_mortgagee.mortg_name%TYPE,
      amount        gipi_quote_mortgagee.amount%TYPE,
      remarks       gipi_quote_mortgagee.remarks%TYPE,
      last_update   gipi_quote_mortgagee.last_update%TYPE,
      user_id       gipi_quote_mortgagee.user_id%TYPE
   );

   TYPE gipi_quote_mort_tab IS TABLE OF gipi_quote_mort_type;

   FUNCTION get_gipi_quote_mort (p_quote_id gipi_quote.quote_id%TYPE)
      RETURN gipi_quote_mort_tab PIPELINED;

   FUNCTION get_gipi_quote_level_mort (p_quote_id gipi_quote.quote_id%TYPE)
      RETURN gipi_quote_mort_tab PIPELINED;

   FUNCTION get_pack_quotations_mortgagee (
      p_pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE
   )
      RETURN gipi_quote_mort_tab PIPELINED;

   PROCEDURE set_gipi_quote_mort (
      p_gipi_quote_mort   IN   gipi_quote_mortgagee%ROWTYPE
   );

   PROCEDURE update_gipi_quote_mort (
      p_gipi_quote_mort   IN   gipi_quote_mortgagee%ROWTYPE,
      p_old_morgt_cd           gipi_quote_mortgagee.mortg_cd%TYPE
   );

   PROCEDURE del_gipi_quote_mort (
      p_quote_id   gipi_quote.quote_id%TYPE,
      p_iss_cd     gipi_quote_mortgagee.iss_cd%TYPE,
      p_item_no    gipi_quote_mortgagee.item_no%TYPE,
      p_mortg_cd   gipi_quote_mortgagee.mortg_cd%TYPE
   );

   PROCEDURE del_all_gipi_quote_mort (
      p_quote_id   gipi_quote.quote_id%TYPE,
      p_item_no    gipi_quote_mortgagee.item_no%TYPE
   );
END gipi_quote_mort_pkg;
/


