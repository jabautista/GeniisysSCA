CREATE OR REPLACE PACKAGE CPI.giri_binder_peril_pkg
AS
PROCEDURE create_binder_peril_giris026 (
      p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE
   );
   
   PROCEDURE CREATE_BINDER_PERIL_GIUTS021 (p_line_cd     IN giri_distfrps.line_cd%TYPE,
                                           p_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                                           p_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE);
END;
/


