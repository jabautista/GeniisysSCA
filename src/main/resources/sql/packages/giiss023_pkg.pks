CREATE OR REPLACE PACKAGE CPI.GIISS023_PKG
AS
   TYPE rec_type IS RECORD (
      position_cd     giis_position.position_cd%TYPE,
      position        giis_position.position%TYPE,
      remarks         giis_position.remarks%TYPE,
      user_id         giis_position.user_id%TYPE,
      last_update     VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list 
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_position%ROWTYPE);

   PROCEDURE del_rec (p_position_cd giis_position.position_cd%TYPE);

   FUNCTION val_del_rec (p_position_cd giis_position.position_cd%TYPE)
   RETURN VARCHAR2;
   
   PROCEDURE val_add_rec(p_position giis_position.position%TYPE, p_position_cd giis_position.position_cd%TYPE);
   
END;
/


