CREATE OR REPLACE PACKAGE CPI.giis_grp_hist_pkg
AS
   TYPE grp_hist IS RECORD (
      hist_id         giis_user_grp_hist.hist_id%TYPE,
      old_user_grp    giis_user_grp_hist.old_user_grp%TYPE,
      old_user_desc   giis_user_grp_hdr.user_grp_desc%TYPE,
      new_user_grp    giis_user_grp_hist.new_user_grp%TYPE,
      new_user_desc   giis_user_grp_hdr.user_grp_desc%TYPE,
      last_update     giis_user_grp_hist.last_update%TYPE,
      last_update_char VARCHAR2(30)
   );

   TYPE grp_hist_tab IS TABLE OF grp_hist;

   FUNCTION get_user_history (
      p_user_id        giis_user_grp_hist.userid%TYPE,
      p_hist_id        giis_user_grp_hist.hist_id%TYPE,
      p_old_user_grp   giis_user_grp_hist.old_user_grp%TYPE,
      p_new_user_grp   giis_user_grp_hist.new_user_grp%TYPE
   )
      RETURN grp_hist_tab PIPELINED;
END giis_grp_hist_pkg;
/


