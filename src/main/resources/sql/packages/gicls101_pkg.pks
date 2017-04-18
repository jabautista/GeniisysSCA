CREATE OR REPLACE PACKAGE CPI.gicls101_pkg
AS
   TYPE rec_type IS RECORD (
      rec_type_cd     giis_recovery_type.rec_type_cd%TYPE,
      rec_type_desc   giis_recovery_type.rec_type_desc%TYPE,
      remarks         giis_recovery_type.remarks%TYPE,
      user_id         giis_recovery_type.user_id%TYPE,
      last_update     VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_rec_type_cd     giis_recovery_type.rec_type_cd%TYPE,
      p_rec_type_desc   giis_recovery_type.rec_type_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_recovery_type%ROWTYPE);

   PROCEDURE del_rec (p_rec_type_cd giis_recovery_type.rec_type_cd%TYPE);

   PROCEDURE val_del_rec (p_rec_type_cd giis_recovery_type.rec_type_cd%TYPE);

   PROCEDURE val_add_rec (p_rec_type_cd giis_recovery_type.rec_type_cd%TYPE);
END;
/


