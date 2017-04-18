CREATE OR REPLACE PACKAGE CPI.giacs307_pkg
AS
   TYPE rec_type IS RECORD (
      bank_cd     giac_banks.bank_cd%TYPE,
      bank_sname  giac_banks.bank_sname%TYPE,
      bank_name   giac_banks.bank_name%TYPE,
      remarks     giac_banks.remarks%TYPE,
      user_id     giac_banks.user_id%TYPE,
      last_update VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_bank_cd     giac_banks.bank_cd%TYPE,
      p_bank_sname  giac_banks.bank_sname%TYPE,
      p_bank_name   giac_banks.bank_name%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giac_banks%ROWTYPE);

   PROCEDURE del_rec (p_bank_cd giac_banks.bank_cd%TYPE);

   PROCEDURE val_del_rec (p_bank_cd giac_banks.bank_cd%TYPE);
   
   PROCEDURE val_add_rec(p_bank_cd giac_banks.bank_cd%TYPE);
   
END;
/


