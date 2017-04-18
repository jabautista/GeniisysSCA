CREATE OR REPLACE PACKAGE CPI.giacs350_pkg
AS
   TYPE rec_type IS RECORD (
      rep_cd        giac_eom_rep.rep_cd%TYPE,
      rep_title     giac_eom_rep.rep_title%TYPE,
      remarks       giac_eom_rep.remarks%TYPE,
      user_id       giac_eom_rep.user_id%TYPE,
      last_update   VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_rep_cd      giac_eom_rep.rep_cd%TYPE,
      p_rep_title   giac_eom_rep.rep_title%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE val_add_rec (p_rep_cd giac_eom_rep.rep_cd%TYPE);

   PROCEDURE val_del_rec (p_rep_cd giac_eom_rep.rep_cd%TYPE);

   PROCEDURE del_rec (p_rep_cd giac_eom_rep.rep_cd%TYPE);

   PROCEDURE set_rec (p_rec giac_eom_rep%ROWTYPE);
END;
/


