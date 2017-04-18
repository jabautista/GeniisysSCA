CREATE OR REPLACE PACKAGE CPI.gisms003_pkg
AS
   TYPE rec_type IS RECORD (
      group_cd      gism_recipient_group.group_cd%TYPE,
      group_name	gism_recipient_group.group_name%TYPE,
	  table_name    gism_recipient_group.table_name%TYPE,
      pk_column     gism_recipient_group.pk_column%TYPE,
      type_column   gism_recipient_group.type_column%TYPE,
      type_value    gism_recipient_group.type_value%TYPE,
      key_word      gism_recipient_group.key_word%TYPE,
      bday_column   gism_recipient_group.bday_column%TYPE,
      name_column   gism_recipient_group.name_column%TYPE,
      cp_column     gism_recipient_group.cp_column%TYPE,
      globe_column  gism_recipient_group.globe_column%TYPE,
      smart_column  gism_recipient_group.smart_column%TYPE,
      sun_column    gism_recipient_group.sun_column%TYPE,
      user_id       gism_recipient_group.user_id%TYPE,
      last_update   VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type; 

   TYPE rec_table_type IS RECORD (
      table_name      all_tables.table_name%TYPE
   ); 

   TYPE rec_table_tab IS TABLE OF rec_table_type;  
   
   TYPE rec_column_type IS RECORD (
      column_name      all_tab_columns.column_name%TYPE
   ); 

   TYPE rec_column_tab IS TABLE OF rec_column_type;      

   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED;  

   FUNCTION get_table_rec_list
      RETURN rec_table_tab PIPELINED;

   FUNCTION get_column_rec_list(
      p_table_name      all_tables.table_name%TYPE
   )
      RETURN rec_column_tab PIPELINED;                      

   PROCEDURE set_rec (p_rec gism_recipient_group%ROWTYPE);

   PROCEDURE del_rec (p_group_cd gism_recipient_group.group_cd%TYPE);

   PROCEDURE val_del_rec (p_group_cd gism_recipient_group.group_cd%TYPE);
   
   PROCEDURE val_add_rec(p_group_cd gism_recipient_group.group_cd%TYPE);
   
END;
/


