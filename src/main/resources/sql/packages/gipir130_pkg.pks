CREATE OR REPLACE PACKAGE CPI.gipir130_pkg
AS
   TYPE group_one_type IS RECORD (
      line_name      giis_line.line_name%TYPE,
      subline_name   giis_subline.subline_name%TYPE,
      line_cd        gipi_polbasic.line_cd%TYPE,
      subline_cd     gipi_polbasic.subline_cd%TYPE,
      iss_cd         gipi_polbasic.iss_cd%TYPE,
      issue_yy       gipi_polbasic.issue_yy%TYPE,
      pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      renew_no       gipi_polbasic.renew_no%TYPE,
      endt_iss_cd    gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy        gipi_polbasic.endt_yy%TYPE,
      endt_seq_no    gipi_polbasic.endt_seq_no%TYPE,
      assd_name      giis_assured.assd_name%TYPE,
      eff_date       giuw_pol_dist.eff_date%TYPE,
      expiry_date    giuw_pol_dist.expiry_date%TYPE,
      dist_no        giuw_pol_dist.dist_no%TYPE,
      policy_no      VARCHAR2 (100),
      endt_no        VARCHAR2 (100),
      duration       VARCHAR2 (100)
   );

   TYPE group_one_tab IS TABLE OF group_one_type;

   FUNCTION get_group_one (p_dist_no VARCHAR2)
      RETURN group_one_tab PIPELINED;

   TYPE group_two_type IS RECORD (
      dist_seq_no               giuw_policyds.dist_seq_no%TYPE,
      tsi_amt                   giuw_policyds.tsi_amt%TYPE,
      currency                  giis_currency.currency_desc%TYPE,
      prem_amt                  giuw_policyds.prem_amt%TYPE,
      display_peril_breakdown   VARCHAR2 (1)
   );

   TYPE group_two_tab IS TABLE OF group_two_type;

   FUNCTION get_group_two (p_dist_no VARCHAR2)
      RETURN group_two_tab PIPELINED;

   TYPE group_three_type IS RECORD (
      trty_name    giis_dist_share.trty_name%TYPE,
      dist_spct    giuw_policyds_dtl.dist_spct%TYPE,
      dist_spct1   giuw_policyds_dtl.dist_spct1%TYPE,
      dist_prem    giuw_policyds_dtl.dist_prem%TYPE,
      dist_tsi     giuw_policyds_dtl.dist_tsi%TYPE
   );

   TYPE group_three_tab IS TABLE OF group_three_type;

   FUNCTION get_group_three (p_dist_no VARCHAR2, p_dist_seq_no VARCHAR2)
      RETURN group_three_tab PIPELINED;

   TYPE group_four_type IS RECORD (
      ri_sname        giis_reinsurer.ri_sname%TYPE,
      line_cd         giri_binder.line_cd%TYPE,
      binder_yy       giri_binder.binder_yy%TYPE,
      binder_seq_no   giri_binder.binder_seq_no%TYPE,
      ri_shr_pct      giri_frps_ri.ri_shr_pct%TYPE,
      ri_tsi_amt      giri_frps_ri.ri_tsi_amt%TYPE,
      ri_shr_pct2     giri_frps_ri.ri_shr_pct2%TYPE,
      ri_prem_amt     giri_frps_ri.ri_prem_amt%TYPE,
      ri_comm_rt      giri_frps_ri.ri_comm_rt%TYPE,
      ri_comm_amt     giri_frps_ri.ri_comm_amt%TYPE,
      ri_comm_vat     giri_frps_ri.ri_comm_vat%TYPE,
      binder_no       VARCHAR2 (50),
      net_due         NUMBER
   );

   TYPE group_four_tab IS TABLE OF group_four_type;

   FUNCTION get_group_four (p_dist_no VARCHAR2, p_dist_seq_no VARCHAR2)
      RETURN group_four_tab PIPELINED;

   TYPE group_five_type IS RECORD (
      row_count     NUMBER                            := 1,
      peril_sname   giis_peril.peril_sname%TYPE,
      trty_name     giis_dist_share.trty_name%TYPE,
      dist_tsi1     giuw_perilds_dtl.dist_tsi%TYPE,
      dist_tsi2     giuw_perilds_dtl.dist_tsi%TYPE,
      dist_tsi3     giuw_perilds_dtl.dist_tsi%TYPE,
      dist_tsi4     giuw_perilds_dtl.dist_tsi%TYPE,
      dist_total_tsi1 giuw_perilds_dtl.dist_tsi%TYPE,
      dist_total_tsi2 giuw_perilds_dtl.dist_tsi%TYPE,
      dist_total_tsi3 giuw_perilds_dtl.dist_tsi%TYPE,
      dist_total_tsi4 giuw_perilds_dtl.dist_tsi%TYPE,
      dist_prem1    giuw_perilds_dtl.dist_prem%TYPE,
      dist_prem2    giuw_perilds_dtl.dist_prem%TYPE,
      dist_prem3    giuw_perilds_dtl.dist_prem%TYPE,
      dist_prem4    giuw_perilds_dtl.dist_prem%TYPE
   );

   TYPE group_five_tab IS TABLE OF group_five_type;

   FUNCTION get_group_five (p_dist_no VARCHAR2, p_dist_seq_no VARCHAR2)
      RETURN group_five_tab PIPELINED;

   TYPE col_type IS RECORD (
      row_count    NUMBER                           := 1,
      share_cd1    giis_dist_share.share_cd%TYPE,
      trty_name1   giis_dist_share.trty_name%TYPE,
      share_cd2    giis_dist_share.share_cd%TYPE,
      trty_name2   giis_dist_share.trty_name%TYPE,
      share_cd3    giis_dist_share.share_cd%TYPE,
      trty_name3   giis_dist_share.trty_name%TYPE,
      share_cd4    giis_dist_share.share_cd%TYPE,
      trty_name4   giis_dist_share.trty_name%TYPE
   );

   TYPE col_tab IS TABLE OF col_type;

   FUNCTION get_col_tab (p_dist_no VARCHAR2, p_dist_seq_no VARCHAR2)
      RETURN col_tab PIPELINED;
END;
/
