CREATE OR REPLACE PACKAGE CPI.giiss094_pkg
AS
   TYPE rec_type IS RECORD (
      ca_trty_type   giis_ca_trty_type.ca_trty_type%TYPE,
      trty_sname     giis_ca_trty_type.trty_sname%TYPE,
      trty_lname     giis_ca_trty_type.trty_lname%TYPE,
      remarks        giis_ca_trty_type.remarks%TYPE,
      user_id        giis_ca_trty_type.user_id%TYPE,
      last_update    VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_ca_trty_type   giis_ca_trty_type.ca_trty_type%TYPE,
      p_trty_sname     giis_ca_trty_type.trty_sname%TYPE,
      p_trty_lname     giis_ca_trty_type.trty_lname%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_ca_trty_type%ROWTYPE);

   PROCEDURE del_rec (p_ca_trty_type giis_ca_trty_type.ca_trty_type%TYPE);

   PROCEDURE val_add_rec (p_ca_trty_type giis_ca_trty_type.ca_trty_type%TYPE);
END;
/


