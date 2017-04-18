CREATE OR REPLACE PACKAGE CPI.GIISS213_PKG
AS
   TYPE rec_type IS RECORD (
      line_cd          giis_peril_group.line_cd%TYPE,
      peril_grp_cd     giis_peril_group.peril_grp_cd%TYPE,
      peril_grp_desc   giis_peril_group.peril_grp_desc%TYPE,
      user_id          giis_peril_group.user_id%TYPE,
      remarks          giis_peril_group.remarks%TYPE,
      last_update      VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   TYPE line_rec_type IS RECORD (
      line_cd     giis_peril_group.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_rec_tab IS TABLE OF line_rec_type;

   TYPE peril_rec_type IS RECORD (
      peril_cd     giis_peril.peril_cd%TYPE,
      peril_name   giis_peril.peril_name%TYPE
   );

   TYPE peril_rec_tab IS TABLE OF peril_rec_type;

   TYPE attach_peril_rec_type IS RECORD (
      line_cd          giis_peril_group.line_cd%TYPE,
      peril_grp_cd     giis_peril_group.peril_grp_cd%TYPE,
      peril_grp_desc   giis_peril_group.peril_grp_desc%TYPE,
      peril_cd         giis_peril.peril_cd%TYPE,
      peril_name       giis_peril.peril_name%TYPE,
      user_id          giis_peril_group.user_id%TYPE,
      remarks          giis_peril_group.remarks%TYPE,
      last_update      VARCHAR2 (30)
   );

   TYPE attach_peril_rec_tab IS TABLE OF attach_peril_rec_type;

   FUNCTION get_rec_list (p_line_cd giis_peril_group.line_cd%TYPE)
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_peril_group%ROWTYPE);

   PROCEDURE del_rec (
      p_line_cd        giis_peril_group.line_cd%TYPE,
      p_peril_grp_cd   giis_peril_group.peril_grp_cd%TYPE
   );

   PROCEDURE val_del_rec (
      p_line_cd        giis_peril_group.line_cd%TYPE,
      p_peril_grp_cd   giis_peril_group.peril_grp_cd%TYPE
   );

   PROCEDURE val_add_rec (
      p_line_cd        giis_peril_group.line_cd%TYPE,
      p_peril_grp_cd   giis_peril_group.peril_grp_cd%TYPE
   );

   FUNCTION get_line_rec_list (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_rec_tab PIPELINED;

   FUNCTION get_peril_rec_list (p_line_cd giis_peril_group.line_cd%TYPE)
      RETURN peril_rec_tab PIPELINED;

   FUNCTION get_attached_peril_rec_list (
      p_line_cd        giis_peril_group.line_cd%TYPE,
      p_peril_grp_cd   giis_peril_group.peril_grp_cd%TYPE
   )
      RETURN attach_peril_rec_tab PIPELINED;

   PROCEDURE set_peril_rec (p_rec giis_peril_group_dtl%ROWTYPE);

   PROCEDURE del_peril_rec (
      p_line_cd        giis_peril_group.line_cd%TYPE,
      p_peril_grp_cd   giis_peril_group.peril_grp_cd%TYPE,
      p_peril_cd       giis_peril_group_dtl.peril_cd%TYPE
   );
END GIISS213_PKG;
/


