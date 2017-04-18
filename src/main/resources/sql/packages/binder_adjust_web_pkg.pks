CREATE OR REPLACE PACKAGE CPI.BINDER_ADJUST_WEB_PKG
AS
/* Created by Melvin John O. Ostia
** 07172014
**
** Applied by Bonok
** 09.25.2014
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

   PROCEDURE check_dist_exist (p_dist_no giuw_pol_dist.dist_no%TYPE);

   PROCEDURE check_share_percent (p_dist_no giuw_pol_dist.dist_no%TYPE);

   FUNCTION get_local_sw (p_ri_cd giis_reinsurer.ri_cd%TYPE)
      RETURN VARCHAR2;

   PROCEDURE adjust_prem_vat_new (
      p_prem_vat      IN OUT   NUMBER,
      p_ri_cd         IN       NUMBER,
      p_line_cd                giri_wdistfrps.line_cd%TYPE,
      p_frps_yy                giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no            giri_wdistfrps.frps_seq_no%TYPE
   );

   PROCEDURE correct_unrvrsd_bndr_rcrds (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE
   );

   FUNCTION check_if_peril_dist (p_dist_no giri_distfrps.dist_no%TYPE)
      RETURN BOOLEAN;

   PROCEDURE recompute_peril_ri_shr (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE
   );

   PROCEDURE adjust_binder_amounts_old (                        -- renamed procedure to old. REPUBLICFULLWEB 21983
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE,
      p_dist_no       giri_wdistfrps.dist_no%TYPE,
      p_dist_seq_no   giri_wdistfrps.dist_seq_no%TYPE
   );

   PROCEDURE adjust_binder_amounts (                            -- new adjustment procedure . REPUBLICFULLWEB 21983
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE,
      p_dist_no       giri_wdistfrps.dist_no%TYPE,
      p_dist_seq_no   giri_wdistfrps.dist_seq_no%TYPE
   );
   
   PROCEDURE recompute_ri_taxes_and_comm (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE,
      p_iss_cd        gipi_parlist.iss_cd%TYPE,
      p_dist_no       giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE adjust_ri_comm_and_taxes (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE
   );

   PROCEDURE get_ri_taxes_multiplier (
      p_line_cd            IN       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy            IN       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no        IN       giri_wdistfrps.frps_seq_no%TYPE,
      p_iss_cd             IN       gipi_parlist.iss_cd%TYPE,
      p_ri_cd              IN       giis_reinsurer.ri_cd%TYPE,
      p_ri_comm_vat_rate   IN OUT   giis_reinsurer.input_vat_rate%TYPE,
      p_ri_prem_vat_rate   IN OUT   giis_reinsurer.input_vat_rate%TYPE,
      p_prem_tax_rate      IN OUT   giis_reinsurer.int_tax_rt%TYPE,
      p_dist_no            IN       giuw_pol_dist.dist_no%TYPE
   );

   PROCEDURE update_ri_comm (
      p_line_cd       giri_wdistfrps.line_cd%TYPE,
      p_frps_yy       giri_wdistfrps.frps_yy%TYPE,
      p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE
   );

END;
/


