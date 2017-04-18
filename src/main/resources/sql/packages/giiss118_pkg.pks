CREATE OR REPLACE PACKAGE CPI.giiss118_pkg
AS
   TYPE rec_type IS RECORD (
      group_cd     giis_group.group_cd%TYPE,
      group_desc  giis_group.group_desc%TYPE,
      remarks     giis_group.remarks%TYPE,
      user_id     giis_group.user_id%TYPE,
      last_update VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_group_cd     giis_group.group_cd%TYPE,
      p_group_desc  giis_group.group_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_group%ROWTYPE);

   PROCEDURE del_rec (p_group_cd VARCHAR2);

   PROCEDURE val_del_rec (p_group_cd giis_group.group_cd%TYPE);
   
   PROCEDURE val_add_rec(p_group_cd giis_group.group_cd%TYPE);
   
END;
/


