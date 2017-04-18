CREATE OR REPLACE PACKAGE CPI.adjust_binder_pkg
AS
/* Created by Edgar base on Melvin's package in CS
** 09/24/2014
*/
   PROCEDURE offset_adjustment_pkg (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE
   );

   PROCEDURE adjust_ri_shr_pct (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE,
      p_dist_no       giri_wdistfrps.dist_no%TYPE,
      p_dist_seq_no   giri_wdistfrps.dist_seq_no%TYPE
   );

   PROCEDURE adjust_binder_amounts (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE,
      p_dist_no       giri_wdistfrps.dist_no%TYPE,
      p_dist_seq_no   giri_wdistfrps.dist_seq_no%TYPE
   );

   PROCEDURE adjust_ri_comm_and_taxes (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE
   );
   
   FUNCTION check_if_peril_dist (p_dist_no giri_distfrps.dist_no%TYPE)
      RETURN BOOLEAN;   

END;
/


