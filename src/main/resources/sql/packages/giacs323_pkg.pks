CREATE OR REPLACE PACKAGE CPI.giacs323_pkg
AS
   TYPE rec_type IS RECORD (
      jv_tran_cd     giac_jv_trans.jv_tran_cd%TYPE,
      jv_tran_desc  giac_jv_trans.jv_tran_desc%TYPE,
      jv_tran_tag   giac_jv_trans.jv_tran_tag%TYPE,
      remarks     giac_jv_trans.remarks%TYPE,
      user_id     giac_jv_trans.user_id%TYPE,
      last_update VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_jv_tran_cd     giac_jv_trans.jv_tran_cd%TYPE,
      p_jv_tran_desc  giac_jv_trans.jv_tran_desc%TYPE,
      p_jv_tran_tag   giac_jv_trans.jv_tran_tag%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giac_jv_trans%ROWTYPE);

   PROCEDURE del_rec (p_jv_tran_cd giac_jv_trans.jv_tran_cd%TYPE);

   PROCEDURE val_del_rec (p_jv_tran_cd giac_jv_trans.jv_tran_cd%TYPE);
   
   PROCEDURE val_add_rec(p_jv_tran_cd giac_jv_trans.jv_tran_cd%TYPE);
   
END;
/


