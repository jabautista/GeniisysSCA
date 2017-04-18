CREATE OR REPLACE PACKAGE CPI.gicls100_pkg
AS
   TYPE rec_type IS RECORD (
      rec_stat_cd     giis_recovery_status.rec_stat_cd%TYPE,
      rec_stat_desc   giis_recovery_status.rec_stat_desc%TYPE,
      remarks         giis_recovery_status.remarks%TYPE,
      user_id         giis_recovery_status.user_id%TYPE,
      last_update     VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_rec_stat_cd     giis_recovery_status.rec_stat_cd%TYPE,
      p_rec_stat_desc   giis_recovery_status.rec_stat_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_recovery_status%ROWTYPE);

   PROCEDURE del_rec (p_rec_stat_cd giis_recovery_status.rec_stat_cd%TYPE);

   PROCEDURE val_del_rec (p_rec_stat_cd giis_recovery_status.rec_stat_cd%TYPE);

   PROCEDURE val_add_rec (
      p_rec_stat_cd     giis_recovery_status.rec_stat_cd%TYPE,
      p_rec_stat_desc   giis_recovery_status.rec_stat_desc%TYPE
   );
END;
/


