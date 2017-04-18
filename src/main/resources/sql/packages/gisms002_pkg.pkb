CREATE OR REPLACE PACKAGE BODY CPI.gisms002_pkg
AS
   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.message_cd, a.message, a.message_type, a.key_word,
	  				   DECODE(a.message_type, 'S', 'System Messages','U','User Defined') dsp_message_type,
                       a.remarks, a.user_id, a.last_update
                  FROM gism_message_template a
                 ORDER BY a.message_cd
                   )                   
      LOOP
         v_rec.message_cd := i.message_cd;
         v_rec.message := i.message;
		 v_rec.message_type := i.message_type;
         v_rec.dsp_message_type := i.dsp_message_type;
         v_rec.key_word := i.key_word;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_reserve_word_rec_list(
      p_message_cd      gism_reserve_word.message_cd%TYPE
   )
      RETURN reserve_word_rec_tab PIPELINED
   IS 
      v_rec   reserve_word_rec_type;
   BEGIN
      FOR i IN (SELECT a.message_cd, a.reserve_word, a.reserve_desc, a.remarks
                  FROM gism_reserve_word a
                 WHERE UPPER(a.message_cd) LIKE UPPER(NVL(p_message_cd,'%'))  
                 ORDER BY a.message_cd
                   )                   
      LOOP
         v_rec.message_cd := i.message_cd;
         v_rec.reserve_word := i.reserve_word;
		 v_rec.reserve_desc := i.reserve_desc;
         v_rec.remarks := i.remarks;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
         
   PROCEDURE set_rec (p_rec gism_message_template%ROWTYPE)
   IS
   BEGIN
      MERGE INTO gism_message_template
         USING DUAL
         ON (message_cd = p_rec.message_cd
             AND message_type = p_rec.message_type
             AND key_word = p_rec.key_word)
         WHEN NOT MATCHED THEN
            INSERT (message_cd, message, message_type, key_word, remarks, user_id, last_update)
            VALUES (p_rec.message_cd, p_rec.message, p_rec.message_type, p_rec.key_word, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET message = p_rec.message,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_message_cd gism_message_template.message_cd%TYPE)
   AS
   BEGIN
      DELETE FROM gism_message_template
            WHERE message_cd = p_message_cd;
   END;

   PROCEDURE val_del_rec (p_message_cd gism_message_template.message_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
    null;
   END;
   
   PROCEDURE val_add_rec (p_message_cd gism_message_template.message_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
    null;
   END;
END;
/


