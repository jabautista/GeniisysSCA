CREATE OR REPLACE PACKAGE CPI.giiss048_pkg
AS
   TYPE rec_type IS RECORD (
      air_type_cd     giis_air_type.air_type_cd%TYPE,
      air_desc        giis_air_type.air_desc%TYPE,
      remarks         giis_air_type.remarks%TYPE,
      user_id         giis_air_type.user_id%TYPE,
      last_update     VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list 
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_air_type%ROWTYPE);

   PROCEDURE del_rec (p_air_type_cd giis_air_type.air_type_cd%TYPE);

   FUNCTION val_del_rec (p_air_type_cd giis_air_type.air_type_cd%TYPE)
   RETURN VARCHAR2;
   
   PROCEDURE val_add_rec(p_air_type_cd giis_air_type.air_type_cd%TYPE);
   
END;
/


