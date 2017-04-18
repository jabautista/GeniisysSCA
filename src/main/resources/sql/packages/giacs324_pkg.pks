CREATE OR REPLACE PACKAGE CPI.giacs324_pkg
AS
   TYPE rec_type IS RECORD (
      bank_cd          giac_banks.bank_cd%TYPE,
      bank_name        giac_banks.bank_name%TYPE,
      bank_sname       giac_banks.bank_sname%TYPE,
      bank_tran_cd     giac_bank_book_tran.bank_tran_cd%TYPE,
      bank_tran_desc   giac_bank_book_tran.bank_tran_desc%TYPE,
      book_tran_cd     giac_bank_book_tran.book_tran_cd%TYPE,
      book_tran_desc   giac_bank_book_tran.book_tran_desc%TYPE,
      remarks          giac_bank_book_tran.remarks%TYPE,
      user_id          giac_bank_book_tran.user_id%TYPE,
      last_update      VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_bank_cd          giac_banks.bank_cd%TYPE,
      p_bank_tran_cd     giac_bank_book_tran.bank_tran_cd%TYPE,
      p_bank_tran_desc   giac_bank_book_tran.bank_tran_desc%TYPE,
      p_book_tran_cd     giac_bank_book_tran.book_tran_cd%TYPE,
      p_book_tran_desc   giac_bank_book_tran.book_tran_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   TYPE bank_cd_lov_type IS RECORD (
      bank_cd      giac_banks.bank_cd%TYPE,
      bank_sname   giac_banks.bank_sname%TYPE,
      bank_name    giac_banks.bank_name%TYPE
   );

   TYPE bank_cd_lov_tab IS TABLE OF bank_cd_lov_type;

   FUNCTION get_bankcd_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN bank_cd_lov_tab PIPELINED;

   TYPE booktrancd_lov_type IS RECORD (
      tran_code          cg_ref_codes.rv_low_value%TYPE,
      book_transaction   cg_ref_codes.rv_meaning%TYPE
   );

   TYPE booktrancd_lov_tab IS TABLE OF booktrancd_lov_type;

   FUNCTION get_booktrancd_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN booktrancd_lov_tab PIPELINED;

   PROCEDURE val_add_rec (
      p_bank_cd        giac_banks.bank_cd%TYPE,
      p_bank_tran_cd   giac_bank_book_tran.bank_tran_cd%TYPE,
      p_book_tran_cd   giac_bank_book_tran.book_tran_cd%TYPE
   );

   PROCEDURE set_rec (p_rec giac_bank_book_tran%ROWTYPE);

   PROCEDURE del_rec (
      p_bank_cd        giac_banks.bank_cd%TYPE,
      p_bank_tran_cd   giac_bank_book_tran.bank_tran_cd%TYPE
   );

   PROCEDURE val_booktrancd_rec (
      p_book_tran_cd   giac_bank_book_tran.book_tran_cd%TYPE
   );
END;
/


