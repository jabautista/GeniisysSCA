CREATE OR REPLACE PACKAGE CPI.giiss108_pkg
AS
   
   TYPE rec_type IS RECORD(
      control_type_cd         giis_control_type.control_type_cd%TYPE,
      control_type_desc       giis_control_type.control_type_desc%TYPE,
      remarks                 giis_control_type.remarks%TYPE,
      user_id                 giis_control_type.user_id%TYPE,
      last_update             VARCHAR2(50)
   ); 
   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list(
      p_control_type_cd       giis_control_type.control_type_cd%TYPE,
      p_control_type_desc     giis_control_type.control_type_desc%TYPE
   )
     RETURN rec_tab PIPELINED;

   PROCEDURE set_rec(
      p_rec                   giis_control_type%ROWTYPE
   );

   PROCEDURE del_rec(
      p_control_type_cd       giis_control_type.control_type_cd%TYPE
   );
   
   PROCEDURE val_add_rec(
      p_old_value             giis_control_type.control_type_desc%TYPE,
      p_control_type_desc     giis_control_type.control_type_desc%TYPE
   );
   
   PROCEDURE val_del_rec(
      p_control_type_cd       giis_control_type.control_type_cd%TYPE
   );
   
END;
/


