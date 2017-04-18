CREATE OR REPLACE PACKAGE BODY CPI.gisms003_pkg
AS
   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.group_cd, a.group_name, a.table_name, a.pk_column,
                       a.type_column, a.type_value, a.key_word, a.bday_column,
                       a.name_column, a.cp_column, a.globe_column, a.smart_column,
                       a.sun_column, a.user_id, a.last_update
                  FROM gism_recipient_group a
               )                   
      LOOP
         v_rec.group_cd     := i.group_cd;
         v_rec.group_name   := i.group_name;
		 v_rec.table_name   := i.table_name;
         v_rec.pk_column    := i.pk_column;
         v_rec.type_column  := i.type_column;
         v_rec.type_value   := i.type_value;
         v_rec.key_word     := i.key_word;
         v_rec.bday_column  := i.bday_column;
         v_rec.name_column  := i.name_column;
         v_rec.cp_column    := i.cp_column;
         v_rec.globe_column := i.globe_column;
         v_rec.smart_column := i.smart_column;
         v_rec.sun_column   := i.sun_column;
         v_rec.user_id      := i.user_id;
         v_rec.last_update  := TO_CHAR (i.last_update, 'MM-DD-YYYY');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_table_rec_list
      RETURN rec_table_tab PIPELINED
   IS 
      v_rec   rec_table_type;
   BEGIN
      FOR i IN (SELECT a.table_name
                  FROM all_tables a
                 WHERE table_name LIKE 'G%'
               )                   
      LOOP
         v_rec.table_name     := i.table_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION get_column_rec_list(
      p_table_name      all_tables.table_name%TYPE
   )
      RETURN rec_column_tab PIPELINED
   IS 
      v_rec   rec_column_type;
   BEGIN
      FOR i IN (SELECT a.column_name
                  FROM all_tab_columns a
                 WHERE table_name = p_table_name
               )                   
      LOOP
         v_rec.column_name     := i.column_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
            
   PROCEDURE set_rec (p_rec gism_recipient_group%ROWTYPE)
   IS
   BEGIN
      MERGE INTO gism_recipient_group
         USING DUAL
         ON (group_cd = p_rec.group_cd)
         WHEN NOT MATCHED THEN
            INSERT (group_cd, group_name, table_name, pk_column,
                    type_column, type_value, key_word, bday_column,
                    name_column, cp_column, globe_column, smart_column,
                    sun_column, user_id, last_update)
            VALUES (p_rec.group_cd, p_rec.group_name, p_rec.table_name, p_rec.pk_column,
                    p_rec.type_column, p_rec.type_value, p_rec.key_word, p_rec.bday_column,
                    p_rec.name_column, p_rec.cp_column, p_rec.globe_column, p_rec.smart_column,
                    p_rec.sun_column, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET group_name = p_rec.group_name, table_name = p_rec.table_name, pk_column = p_rec.pk_column,
                   type_column = p_rec.type_column, type_value = p_rec.type_value, key_word = p_rec.key_word, bday_column = p_rec.bday_column,
                   name_column = p_rec.name_column, cp_column = p_rec.cp_column, globe_column = p_rec.globe_column, smart_column = p_rec.smart_column,
                   sun_column = p_rec.sun_column,user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_group_cd gism_recipient_group.group_cd%TYPE)
   AS
   BEGIN
      DELETE FROM gism_recipient_group
            WHERE group_cd = p_group_cd;
   END;

   PROCEDURE val_del_rec (p_group_cd gism_recipient_group.group_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
    null;
   END;
   
   PROCEDURE val_add_rec (p_group_cd gism_recipient_group.group_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
    null;
   END;
END;
/


