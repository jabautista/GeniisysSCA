CREATE OR REPLACE PACKAGE CPI.gipis901_firestat_pkg
AS
   PROCEDURE extract_fire_stat (
      p_fire_stat    IN       VARCHAR2,
      p_date_rb      IN       VARCHAR2,
      p_date         IN       VARCHAR2,
      p_date_from    IN       VARCHAR2,
      p_date_to      IN       VARCHAR2,
      p_as_of_date   IN       VARCHAR2,
      p_bus_cd       IN       NUMBER,
      p_zone         IN       VARCHAR2,
      p_zone_type    IN       VARCHAR2,
      p_risk_cnt     IN       VARCHAR2,
      p_incl_endt    IN       VARCHAR2,
      p_incl_exp     IN       VARCHAR2,
      p_peril_type   IN       VARCHAR2,
      p_user         IN       VARCHAR2,
      p_cnt          OUT      NUMBER
   );

   TYPE fire_tariff_master_type IS RECORD (
      tarf_cd     giis_tariff.tarf_cd%TYPE,
      tarf_desc   giis_tariff.tarf_desc%TYPE
   );

   TYPE fire_tariff_master_tab IS TABLE OF fire_tariff_master_type;

   FUNCTION populate_fire_tariff_master (
      p_user_id     gixx_firestat_summary_dtl.user_id%TYPE,
      p_as_of_sw    gixx_firestat_summary_dtl.as_of_sw%TYPE,
      p_zone_type   gipi_firestat_extract_dtl.zone_type%TYPE
   )
      RETURN fire_tariff_master_tab PIPELINED;

   TYPE fire_tariff_detail_type IS RECORD (
      policy_no   VARCHAR2 (100),
      assd_no     gixx_firestat_summary_dtl.assd_no%TYPE,
      assd_name   VARCHAR2 (1000),
      tarf_cd     gixx_firestat_summary_dtl.tarf_cd%TYPE,
      tsi_amt     NUMBER (21, 2),
      prem_amt    NUMBER (21, 2),
      user_id     gixx_firestat_summary_dtl.user_id%TYPE
   );

   TYPE fire_tariff_detail_tab IS TABLE OF fire_tariff_detail_type;

   FUNCTION populate_fire_tariff_detail (
      p_user_id     gixx_firestat_summary_dtl.user_id%TYPE,
      p_as_of_sw    gixx_firestat_summary_dtl.as_of_sw%TYPE,
      p_tarf_cd     gixx_firestat_summary_dtl.tarf_cd%TYPE,
      p_zone_type   gipi_firestat_extract_dtl.zone_type%TYPE
   )
      RETURN fire_tariff_detail_tab PIPELINED;

   TYPE fire_zone_master_type IS RECORD (
      line_cd          gipi_firestat_extract_dtl.line_cd%TYPE,
      line_name        giis_line.line_name%TYPE,
      share_cd         gipi_firestat_extract_dtl.share_cd%TYPE,
      share_name       giis_dist_share.trty_name%TYPE,
      share_tsi_amt    NUMBER (21, 2),
      share_prem_amt   NUMBER (21, 2),
      as_of_sw         gipi_firestat_extract_dtl.as_of_sw%TYPE
   );

   TYPE fire_zone_master_tab IS TABLE OF fire_zone_master_type;

   FUNCTION populate_fire_zone_master (
      p_user_id      gixx_firestat_summary_dtl.user_id%TYPE,
      p_as_of_sw     gixx_firestat_summary_dtl.as_of_sw%TYPE,
      p_line_cd_fi   VARCHAR2,
      p_zone_type    VARCHAR2
   )
      RETURN fire_zone_master_tab PIPELINED;

   TYPE fire_zone_detail_type IS RECORD (
      share_cd         gipi_firestat_zone_dtl_v.share_cd%TYPE,
      share_name       giis_dist_share.trty_name%TYPE,
      assd_name        gipi_firestat_zone_dtl_v.assd_name%TYPE,
      policy_no        gipi_firestat_zone_dtl_v.policy_no%TYPE,
      share_tsi_amt    gipi_firestat_zone_dtl_v.share_tsi_amt%TYPE,
      share_prem_amt   gipi_firestat_zone_dtl_v.share_prem_amt%TYPE,
      as_of_sw         gipi_firestat_zone_dtl_v.as_of_sw%TYPE,
      user_id          gipi_firestat_zone_dtl_v.user_id%TYPE,
      line_cd          gipi_firestat_extract_dtl.line_cd%TYPE
   );

   TYPE fire_zone_detail_tab IS TABLE OF fire_zone_detail_type;

   FUNCTION populate_fire_zone_detail (
      p_user_id      gixx_firestat_summary_dtl.user_id%TYPE,
      p_as_of_sw     gixx_firestat_summary_dtl.as_of_sw%TYPE,
      p_line_cd_fi   VARCHAR2,
      p_share_cd     gipi_firestat_zone_dtl_v.share_cd%TYPE,
      p_line_cd      gipi_firestat_extract_dtl.line_cd%TYPE,
      p_zone_type    gipi_firestat_extract_dtl.zone_type%TYPE
   )
      RETURN fire_zone_detail_tab PIPELINED;

   TYPE fire_com_accum_master_type IS RECORD (
      zone_group       giis_flood_zone.zone_grp%TYPE,
      nbt_zone_grp     VARCHAR2 (100),                      --edgar 04/1/2015
      share_cd         giis_dist_share.share_cd%TYPE,
      dist_share       cg_ref_codes.rv_meaning%TYPE,
      share_type       cg_ref_codes.rv_low_value%TYPE,
      acct_trty_type   cg_ref_codes.rv_low_value%TYPE
   );

   TYPE fire_com_accum_master_tab IS TABLE OF fire_com_accum_master_type;

   FUNCTION populate_fire_com_accum_master (
      p_as_of_sw    VARCHAR2,
      p_zone_type   gipi_firestat_extract_dtl.zone_type%TYPE,
      p_user_id     gipi_firestat_extract_dtl.user_id%TYPE
   )
      RETURN fire_com_accum_master_tab PIPELINED;

   TYPE fire_com_accum_detail_type IS RECORD (
      zone_group   giis_flood_zone.zone_grp%TYPE,
      zone_type    gipi_firestat_extract_dtl.zone_type%TYPE,
      zone_no      gipi_firestat_extract_dtl.zone_no%TYPE,
      share_cd     gipi_firestat_extract_dtl.share_cd%TYPE,
      as_of_sw     gipi_firestat_extract_dtl.as_of_sw%TYPE,
      policy_no    VARCHAR2 (100),
      line_cd      gipi_polbasic.line_cd%TYPE,
      subline_cd   gipi_polbasic.subline_cd%TYPE,
      iss_cd       gipi_polbasic.iss_cd%TYPE,
      issue_yy     gipi_polbasic.issue_yy%TYPE,
      pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      renew_no     gipi_polbasic.renew_no%TYPE,
      tsi_amt_b    NUMBER (21, 2),
      prem_amt_b   NUMBER (21, 2),
      tsi_amt_c    NUMBER (21, 2),
      prem_amt_c   NUMBER (21, 2),
      tsi_amt_l    NUMBER (21, 2),
      prem_amt_l   NUMBER (21, 2)
   );

   TYPE fire_com_accum_detail_tab IS TABLE OF fire_com_accum_detail_type;

   FUNCTION populate_fire_com_accum_detail (
      p_zone             VARCHAR2,
      p_as_of_sw         VARCHAR2,
      p_zone_grp         giis_eqzone.zone_grp%TYPE,
      p_nbt_zone_grp     VARCHAR2,
      p_zone_type        gipi_firestat_extract_dtl.zone_type%TYPE,
      p_share_cd         gipi_firestat_extract_dtl.share_cd%TYPE,
      p_user_id          gipi_firestat_extract_dtl.user_id%TYPE,
      p_share_type       giis_dist_share.share_type%TYPE,
      p_acct_trty_type   giis_dist_share.acct_trty_type%TYPE
   )
      RETURN fire_com_accum_detail_tab PIPELINED;

   PROCEDURE fire_com_accum_dtl_post_query (
      p_zone_type        IN       NUMBER,
      p_as_of_sw         IN       VARCHAR2,
      p_nbt_zone_grp     IN       VARCHAR2,
      p_zone_no          IN       gipi_firestat_extract_dtl.zone_no%TYPE,
      p_share_cd         IN       gipi_firestat_extract_dtl.share_cd%TYPE,
      p_line_cd          IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd       IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd           IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy         IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no       IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no         IN       gipi_polbasic.renew_no%TYPE,
      p_user_id          IN       VARCHAR2,
      p_sum_tsi_amt_b    OUT      NUMBER,
      p_sum_prem_amt_b   OUT      NUMBER,
      p_sum_tsi_amt_c    OUT      NUMBER,
      p_sum_prem_amt_c   OUT      NUMBER,
      p_sum_tsi_amt_l    OUT      NUMBER,
      p_sum_prem_amt_l   OUT      NUMBER
   );

   TYPE risk_line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE risk_line_lov_tab IS TABLE OF risk_line_lov_type;

   PROCEDURE check_fire_stat (
      p_fire_stat    IN       VARCHAR2,
      p_date_rb      IN       VARCHAR2,
      p_date         IN       VARCHAR2,
      p_date_from    IN       VARCHAR2,
      p_date_to      IN       VARCHAR2,
      p_as_of_date   IN       VARCHAR2,
      p_bus_cd       IN       NUMBER,
      p_zone         IN       VARCHAR2,
      p_zone_type    IN       VARCHAR2,
      p_risk_cnt     IN       VARCHAR2,
      p_incl_endt    IN       VARCHAR2,
      p_incl_exp     IN       VARCHAR2,
      p_peril_type   IN       VARCHAR2,
      p_user         IN       VARCHAR2,
      p_cnt          OUT      NUMBER
   );

   PROCEDURE validate_before_extract ( --edgar 04/27/2015 FULL WEB SR 4322
      p_fire_stat    IN       VARCHAR2,
      p_date_rb      IN       VARCHAR2,
      p_date         IN       VARCHAR2,
      p_date_from    IN       VARCHAR2,
      p_date_to      IN       VARCHAR2,
      p_as_of_date   IN       VARCHAR2,
      p_bus_cd       IN       NUMBER,
      p_zone         IN       VARCHAR2,
      p_zone_type    IN       VARCHAR2,
      p_risk_cnt     IN       VARCHAR2,
      p_incl_endt    IN       VARCHAR2,
      p_incl_exp     IN       VARCHAR2,
      p_peril_type   IN       VARCHAR2,
      p_user         IN       VARCHAR2,
      p_msg_alert    OUT      VARCHAR2
   );   
END gipis901_firestat_pkg;
/

CREATE OR REPLACE PUBLIC SYNONYM gipis901_firestat_pkg FOR cpi.gipis901_firestat_pkg; --edgar 04/27/2015 FULL WEB SR 4322

/