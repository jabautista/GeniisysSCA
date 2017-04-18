CREATE OR REPLACE PACKAGE CPI.giris007_pkg
AS
   TYPE giis_dist_share_type IS RECORD (
      line_cd       giis_dist_share.line_cd%TYPE,
      trty_yy       giis_dist_share.trty_yy%TYPE,
      share_cd      giis_dist_share.share_cd%TYPE,
      trty_name     giis_dist_share.trty_name%TYPE,
      eff_date      VARCHAR2 (15),
      expiry_date   VARCHAR2 (15)
   );

   TYPE giis_dist_share_tab IS TABLE OF giis_dist_share_type;

   FUNCTION get_distshare_list (
      p_line_cd         giis_dist_share.line_cd%TYPE,
      p_trty_yy         giis_dist_share.trty_yy%TYPE,
      p_share_cd        giis_dist_share.share_cd%TYPE,
      p_trty_name       giis_dist_share.trty_name%TYPE,
      p_user_id         VARCHAR2,
      p_eff_date        VARCHAR2,
      p_expiry_date     VARCHAR2
   )
      RETURN giis_dist_share_tab PIPELINED;

   TYPE giis_xol_type IS RECORD (
      xol_id          giis_xol.xol_id%TYPE,
      line_cd         giis_xol.line_cd%TYPE,
      xol_yy          giis_xol.xol_yy%TYPE,
      xol_seq_no      giis_xol.xol_seq_no%TYPE,
      xol_trty_name   giis_xol.xol_trty_name%TYPE,
      share_cd        giis_dist_share.share_cd%TYPE,
      layer_no        giis_dist_share.layer_no%TYPE,
      trty_name       giis_dist_share.trty_name%TYPE,
      eff_date        VARCHAR2 (15),
      expiry_date     VARCHAR2 (15),
      xol_treaty      VARCHAR2 (100)
   );

   TYPE giis_xol_tab IS TABLE OF giis_xol_type;

   FUNCTION get_xol_list (
      p_line_cd         giis_xol.line_cd%TYPE,
      p_xol_yy          giis_xol.xol_yy%TYPE,
      p_xol_seq_no      giis_xol.xol_seq_no%TYPE,
      p_layer_no        giis_dist_share.layer_no%TYPE,
      p_xol_trty_name   giis_xol.xol_trty_name%TYPE,
      p_trty_name       giis_dist_share.trty_name%TYPE,
      p_user_id         VARCHAR2,
      p_eff_date        VARCHAR2,
      p_expiry_date     VARCHAR2
   )
      RETURN giis_xol_tab PIPELINED;

   TYPE a6401_type IS RECORD (
      line_cd          giis_trty_peril.line_cd%TYPE,
      trty_seq_no      giis_trty_peril.trty_seq_no%TYPE,
      peril_cd         giis_trty_peril.peril_cd%TYPE,
      dsp_peril_name   giis_peril.peril_name%TYPE,
      trty_com_rt      giis_trty_peril.trty_com_rt%TYPE,
      prof_comm_rt     giis_trty_peril.prof_comm_rt%TYPE,
      remarks          giis_trty_peril.remarks%TYPE,
      user_id          giis_trty_peril.user_id%TYPE,
      last_update      VARCHAR2 (30)
   );

   TYPE a6401_tab IS TABLE OF a6401_type;

   FUNCTION get_a6401_list (
      p_line_cd          giis_dist_share.line_cd%TYPE,
      p_trty_yy          giis_dist_share.trty_yy%TYPE,
      p_share_cd         giis_dist_share.share_cd%TYPE,
      p_peril_cd         giis_trty_peril.peril_cd%TYPE,
      p_peril_name       giis_peril.peril_name%TYPE,
      p_trty_com_rt      giis_trty_peril.trty_com_rt%TYPE,
      p_prof_comm_rt     giis_trty_peril.prof_comm_rt%TYPE
   )
      RETURN a6401_tab PIPELINED;

   TYPE a6401_peril_type IS RECORD (
      peril_cd      giis_peril.peril_cd%TYPE,
      peril_sname   giis_peril.peril_sname%TYPE,
      peril_name    giis_peril.peril_name%TYPE,
      peril_type    giis_peril.peril_type%TYPE
   );

   TYPE a6401_peril_tab IS TABLE OF a6401_peril_type;

   FUNCTION get_a6401_peril_lov (p_line_cd VARCHAR2, p_keyword VARCHAR2)
      RETURN a6401_peril_tab PIPELINED;

   PROCEDURE val_add_a6401_rec (
      p_line_cd    giis_trty_peril.line_cd%TYPE,
      p_trty_yy    giis_dist_share.trty_yy%TYPE,
      p_share_cd   giis_dist_share.share_cd%TYPE,
      p_peril_cd   giis_trty_peril.peril_cd%TYPE
   );

   PROCEDURE set_a6401_rec (p_rec giis_trty_peril%ROWTYPE);

   PROCEDURE del_a6401_rec (
      p_line_cd       giis_trty_peril.line_cd%TYPE,
      p_trty_seq_no   giis_trty_peril.trty_seq_no%TYPE,
      p_peril_cd      giis_trty_peril.peril_cd%TYPE
   );

   FUNCTION get_a6401incall_list (
      p_line_cd    giis_dist_share.line_cd%TYPE,
      p_trty_yy    giis_dist_share.trty_yy%TYPE,
      p_share_cd   giis_dist_share.share_cd%TYPE,
      p_peril_cd   giis_trty_peril.peril_cd%TYPE,
      p_user_id    giis_users.user_id%TYPE
   )
      RETURN a6401_tab PIPELINED;

   TYPE trtyperilxol_type IS RECORD (
      line_cd          giis_trty_peril.line_cd%TYPE,
      trty_seq_no      giis_trty_peril.trty_seq_no%TYPE,
      peril_cd         giis_trty_peril.peril_cd%TYPE,
      dsp_peril_name   giis_peril.peril_name%TYPE,
      trty_com_rt      giis_trty_peril.trty_com_rt%TYPE,
      prof_comm_rt     giis_trty_peril.prof_comm_rt%TYPE,
      remarks          giis_trty_peril.remarks%TYPE,
      user_id          giis_trty_peril.user_id%TYPE,
      last_update      VARCHAR2 (30)
   );

   TYPE trtyperilxol_tab IS TABLE OF trtyperilxol_type;

   FUNCTION get_trtyperilxol_list (
      p_line_cd          giis_xol.line_cd%TYPE,
      p_xol_yy           giis_xol.xol_yy%TYPE,
      p_xol_seq_no       giis_xol.xol_seq_no%TYPE,
      p_share_cd         giis_trty_peril.trty_seq_no%TYPE,
      p_peril_cd         giis_trty_peril.peril_cd%TYPE,
      p_peril_name       giis_peril.peril_name%TYPE,
      p_trty_com_rt      giis_trty_peril.trty_com_rt%TYPE,
      p_prof_comm_rt     giis_trty_peril.prof_comm_rt%TYPE
   )
      RETURN trtyperilxol_tab PIPELINED;

   PROCEDURE val_add_trtyperilxol_rec (
      p_line_cd      giis_xol.line_cd%TYPE,
      p_xol_yy       giis_xol.xol_yy%TYPE,
      p_xol_seq_no   giis_xol.xol_seq_no%TYPE,
      p_peril_cd     giis_trty_peril.peril_cd%TYPE
   );
   
   --nieko 02142017, SR 23828
   PROCEDURE val_add_trtyperilxol_rec2 (
      p_line_cd      giis_xol.line_cd%TYPE,
      p_xol_yy       giis_xol.xol_yy%TYPE,
      p_xol_seq_no   giis_xol.xol_seq_no%TYPE,
      p_peril_cd     giis_trty_peril.peril_cd%TYPE,
      p_share_cd     giis_dist_share.share_cd%TYPE
   );
   --nieko 02142017 end
END;
/
