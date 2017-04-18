CREATE OR REPLACE PACKAGE CPI.giacs313_pkg
AS
   TYPE giis_user_type IS RECORD (
      giac_user_id   giis_users.user_id%TYPE,
      user_name      giis_users.user_name%TYPE
   );

   TYPE giis_user_tab IS TABLE OF giis_user_type;

   TYPE rec_type IS RECORD (
      giac_user_id   giac_users.user_id%TYPE,
      user_name      giac_users.user_name%TYPE,
      designation    giac_users.designation%TYPE,
      active_dt      VARCHAR2 (30),
      inactive_dt    VARCHAR2 (30),
      active_tag     giac_users.active_tag%TYPE,
      remarks        giac_users.remarks%TYPE,
      user_id        giac_users.tran_user_id%TYPE,
      last_update    VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_giis_users
      RETURN giis_user_tab PIPELINED;

   FUNCTION get_rec_list (
      p_giac_user_id   giac_users.user_id%TYPE,
      p_user_name      giac_users.user_name%TYPE,
      p_designation    giac_users.designation%TYPE,
      p_active_dt      VARCHAR2,
      p_inactive_dt    VARCHAR2,
      p_active_tag     VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giac_users%ROWTYPE);

   PROCEDURE del_rec (p_giac_user_id giac_users.user_id%TYPE);

   PROCEDURE val_del_rec (p_giac_user_id giac_users.user_id%TYPE);

   PROCEDURE val_add_rec (p_giac_user_id giac_users.user_id%TYPE);
END;
/


