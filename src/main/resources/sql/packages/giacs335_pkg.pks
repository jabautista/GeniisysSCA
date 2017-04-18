CREATE OR REPLACE PACKAGE CPI.GIACS335_PKG
AS
   TYPE rec_type IS RECORD (
      rep_cd          giac_soa_title.rep_cd%TYPE,
      col_no          giac_soa_title.col_no%TYPE,
      col_title       giac_soa_title.col_title%TYPE,
      remarks         giac_soa_title.remarks%TYPE,
      user_id         giac_soa_title.user_id%TYPE,
      last_update     VARCHAR2(30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list 
      RETURN rec_tab PIPELINED;
   PROCEDURE set_rec (p_rec giac_soa_title%ROWTYPE);
   
   PROCEDURE del_rec (p_rep_cd giac_soa_title.rep_cd%TYPE, p_col_no giac_soa_title.col_no%TYPE);

   FUNCTION val_del_rec (p_rep_cd giac_soa_title.rep_cd%TYPE)
   RETURN VARCHAR2;
   
   FUNCTION val_add_rec(p_rep_cd giac_soa_title.rep_cd%TYPE, p_col_no giac_soa_title.col_no%TYPE)
   RETURN VARCHAR2;
   
   TYPE giacs335_lov_type IS RECORD (
       rv_low_value     cg_ref_codes.rv_low_value%TYPE,
       rv_meaning       cg_ref_codes.rv_meaning%TYPE
   ); 

   TYPE giacs335_lov_tab IS TABLE OF giacs335_lov_type;
   
   FUNCTION get_giacs335_lov
   RETURN giacs335_lov_tab PIPELINED;
   
   PROCEDURE validate_rep_cd(
        p_rep_cd   IN OUT VARCHAR2
    );
   
END;
/


