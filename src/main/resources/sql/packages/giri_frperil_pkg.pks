CREATE OR REPLACE PACKAGE CPI.giri_frperil_pkg
AS
PROCEDURE CREATE_GIRI_FRPERIL_GIRIS026 (
	  p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE
);

    PROCEDURE CREATE_GIRI_FRPERIL_GIUTS021 (p_line_cd     IN giri_distfrps.line_cd%TYPE,
                                   p_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                                   p_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE);
END;
/


