CREATE OR REPLACE PACKAGE CPI.gisms002_pkg
AS
   TYPE rec_type IS RECORD (
      message_cd        gism_message_template.message_cd%TYPE,
      message  	        gism_message_template.message%TYPE,
	  message_type      gism_message_template.message_type%TYPE,
      dsp_message_type  VARCHAR2(100),
      key_word          gism_message_template.key_word%TYPE,
      remarks           gism_message_template.remarks%TYPE,
      user_id           gism_message_template.user_id%TYPE,
      last_update       VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   TYPE reserve_word_rec_type IS RECORD (
      message_cd        gism_reserve_word.message_cd%TYPE,
      reserve_word  	gism_reserve_word.reserve_word%TYPE,
	  reserve_desc      gism_reserve_word.reserve_desc%TYPE,
      remarks           gism_reserve_word.remarks%TYPE
   ); 

   TYPE reserve_word_rec_tab IS TABLE OF reserve_word_rec_type;   

   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED;

   FUNCTION get_reserve_word_rec_list(
      p_message_cd      gism_reserve_word.message_cd%TYPE
   )
      RETURN reserve_word_rec_tab PIPELINED;      

   PROCEDURE set_rec (p_rec gism_message_template%ROWTYPE);

   PROCEDURE del_rec (p_message_cd gism_message_template.message_cd%TYPE);

   PROCEDURE val_del_rec (p_message_cd gism_message_template.message_cd%TYPE);
   
   PROCEDURE val_add_rec(p_message_cd gism_message_template.message_cd%TYPE);
   
END;
/


