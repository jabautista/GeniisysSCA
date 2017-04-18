CREATE OR REPLACE PACKAGE CPI.giiss091_pkg
AS
   TYPE rec_type IS RECORD (
      line_cd       giis_policy_type.line_cd%TYPE,
      type_cd       giis_policy_type.type_cd%TYPE,
      type_desc     giis_policy_type.type_desc%TYPE,
      remarks       giis_policy_type.remarks%TYPE,
      user_id       giis_policy_type.user_id%TYPE,
      last_update   VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_line_cd     giis_policy_type.line_cd%TYPE,
      p_type_cd     giis_policy_type.type_cd%TYPE,
      p_type_desc   giis_policy_type.type_desc%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE val_add_rec (
      p_line_cd   giis_policy_type.line_cd%TYPE,
      p_type_cd   giis_policy_type.type_cd%TYPE,
      p_type_desc   giis_policy_type.type_desc%TYPE
   );

   PROCEDURE val_del_rec (
      p_line_cd   giis_policy_type.line_cd%TYPE,
      p_type_cd   giis_policy_type.type_cd%TYPE
   );

   PROCEDURE set_rec (
      p_rec             giis_policy_type%ROWTYPE,
      p_dummy_line_cd   giis_policy_type.line_cd%TYPE
   );

   PROCEDURE del_rec (
      p_line_cd   giis_policy_type.line_cd%TYPE,
      p_type_cd   giis_policy_type.type_cd%TYPE
   );

   PROCEDURE val_type_desc (p_type_desc giis_policy_type.type_desc%TYPE);
   
   FUNCTION get_all_line_type_cd RETURN rec_tab PIPELINED;
   
   FUNCTION get_all_type_desc RETURN rec_tab PIPELINED;
END;
/


