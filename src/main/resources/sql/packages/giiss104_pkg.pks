CREATE OR REPLACE PACKAGE CPI.giiss104_pkg
AS
   TYPE rec_type IS RECORD (
      endt_id       giis_endttext.endt_id%TYPE,
      endt_cd       giis_endttext.endt_cd%TYPE,
      endt_title    giis_endttext.endt_title%TYPE,
      endt_text     giis_endttext.endt_text%TYPE,
      remarks       giis_endttext.remarks%TYPE,
      user_id       giis_endttext.user_id%TYPE,
      last_update   VARCHAR2 (30),
      active_tag    giis_endttext.active_tag%TYPE --carlo 01-26-2017 SR 5915
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_endt_id      giis_endttext.endt_id%TYPE,
      p_endt_cd      giis_endttext.endt_cd%TYPE,
      p_endt_title   giis_endttext.endt_title%TYPE,
      p_endt_text    giis_endttext.endt_text%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE val_add_rec (p_endt_cd giis_endttext.endt_cd%TYPE);

   PROCEDURE set_rec (p_rec giis_endttext%ROWTYPE);

   PROCEDURE del_rec (p_endt_id giis_endttext.endt_id%TYPE);

   PROCEDURE val_del_rec (p_endt_cd giis_endttext.endt_cd%TYPE);
END;
/


