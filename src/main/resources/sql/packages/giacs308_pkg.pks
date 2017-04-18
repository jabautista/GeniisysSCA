CREATE OR REPLACE PACKAGE CPI.giacs308_pkg
AS
   TYPE sl_type_type IS RECORD (
      sl_type_cd           giac_sl_types.sl_type_cd%TYPE,
      sl_type_name         giac_sl_types.sl_type_name%TYPE,
      sl_tag               giac_sl_types.sl_tag%TYPE,
      dsp_sl_tag_meaning   cg_ref_codes.rv_meaning%TYPE, 
      os_flag              giac_sl_types.os_flag%TYPE,
      remarks              giac_sl_types.remarks%TYPE,
      user_id              giac_sl_types.user_id%TYPE,
      last_update          VARCHAR2 (30)
   );

   TYPE sl_type_tab IS TABLE OF sl_type_type; 
 
   FUNCTION get_sl_type_list(
      p_sl_type_cd           giac_sl_types.sl_type_cd%TYPE,
      p_sl_type_name         giac_sl_types.sl_type_name%TYPE,
      p_dsp_sl_tag_meaning   cg_ref_codes.rv_meaning%TYPE
   )
      RETURN sl_type_tab PIPELINED;

   PROCEDURE set_sl_type (p_rec giac_sl_types%ROWTYPE);

   PROCEDURE val_delete_sl_type (p_sl_type_cd giac_sl_types.sl_type_cd%TYPE);
   
   PROCEDURE val_add_rec (p_sl_type_cd giac_sl_types.sl_type_cd%TYPE);

   PROCEDURE del_sl_type (p_sl_type_cd giac_sl_types.sl_type_cd%TYPE);
END;
/


