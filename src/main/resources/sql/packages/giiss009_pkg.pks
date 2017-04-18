CREATE OR REPLACE PACKAGE CPI.giiss009_pkg
AS
   TYPE giis_currency_rec_type IS RECORD (
      main_currency_cd   giis_currency.main_currency_cd%TYPE,
      currency_desc      giis_currency.currency_desc%TYPE,
      currency_rt        giis_currency.currency_rt%TYPE,
      short_name         giis_currency.short_name%TYPE,
      user_id            giis_currency.user_id%TYPE,
      last_update        VARCHAR2 (50),
      remarks            giis_currency.remarks%TYPE
   );

   TYPE giis_currency_rec_tab IS TABLE OF giis_currency_rec_type;

   FUNCTION get_currency_list
      RETURN giis_currency_rec_tab PIPELINED;

   FUNCTION validate_delete_currency (
      p_main_currency_cd   giis_currency.main_currency_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION validate_main_currency_cd (
      p_main_currency_cd   giis_currency.main_currency_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION validate_short_name (p_short_name giis_currency.short_name%TYPE)
      RETURN VARCHAR2;

   FUNCTION validate_currency_desc (
      p_currency_desc   giis_currency.currency_desc%TYPE
   )
      RETURN VARCHAR2;

   PROCEDURE delete_giis_currency (
      p_main_currency_cd   giis_currency.main_currency_cd%TYPE
   );

   PROCEDURE set_giis_currency (p_currency giis_currency%ROWTYPE);

   FUNCTION get_all_main_currency_cd
      RETURN giis_currency_rec_tab PIPELINED;

   FUNCTION get_all_short_name
      RETURN giis_currency_rec_tab PIPELINED;

   FUNCTION get_all_currency_desc
      RETURN giis_currency_rec_tab PIPELINED;

   PROCEDURE val_del_rec (p_main_currency_cd giis_currency.main_currency_cd%TYPE);
END;
/


