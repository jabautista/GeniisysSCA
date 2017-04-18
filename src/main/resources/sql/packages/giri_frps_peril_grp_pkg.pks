CREATE OR REPLACE PACKAGE CPI.GIRI_FRPS_PERIL_GRP_PKG AS


  PROCEDURE del_giri_frps_peril_grp(p_frps_seq_no IN GIRI_FRPS_PERIL_GRP.frps_seq_no%TYPE,
                                    p_frps_yy     IN GIRI_FRPS_PERIL_GRP.frps_yy%TYPE);

  PROCEDURE create_frps_peril_grp_giris026
  (
   	  p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE
  );									

END GIRI_FRPS_PERIL_GRP_PKG;
/


