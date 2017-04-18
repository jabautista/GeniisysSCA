CREATE OR REPLACE PACKAGE CPI.giis_fbndr_seq_pkg
AS
PROCEDURE update_fbndr_seq_giris026 (
      p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE
   );
   
   PROCEDURE get_parameters_giuts004(
        p_line_cd       IN      giis_fbndr_seq.line_cd%TYPE,
        p_year          OUT     NUMBER,
        p_binder_id     OUT     giri_frps_ri.fnl_binder_id%TYPE,
        p_fbndr_seq_no  OUT     giis_fbndr_seq.fbndr_seq_no%TYPE
   ); 
END;
/


