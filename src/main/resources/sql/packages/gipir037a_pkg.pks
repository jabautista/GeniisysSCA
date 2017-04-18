CREATE OR REPLACE PACKAGE CPI.gipir037a_pkg
AS
   TYPE gipir037a_type IS RECORD (
      extract_dt       DATE,
      header           VARCHAR2 (200),
      zone_no          VARCHAR2 (2),
      no_of_risk       NUMBER (4),
      share_cd         NUMBER (3),
      share_tsi_amt    NUMBER (21, 2),
      share_prem_amt   NUMBER (21, 2),
      share_type       VARCHAR2 (1),
      trty_name        VARCHAR2 (30),
      zone_class       VARCHAR2 (100),
      flag             VARCHAR2 (10),
      comp_name        VARCHAR2 (100),
      comp_add         VARCHAR2 (500),
      header_func      VARCHAR2 (100),
      bus_cd           VARCHAR2 (1000),
      period_end       VARCHAR2 (100),
      period_start     VARCHAR2 (100),
      expired_as_of    VARCHAR2 (100),
      zone_desc        VARCHAR2 (500),
      zone_risk        NUMBER (10),
      row_from         NUMBER (10),                        --edgar 04/15/2015
      row_to           NUMBER (10)                               --04/15/2015
   );

   TYPE gipir037a_tab IS TABLE OF gipir037a_type;

   TYPE gipir037a_distr_type IS RECORD (
      zone_no          giis_typhoon_zone.typhoon_zone%TYPE,
      zone_type        gipi_firestat_extract_dtl.zone_type%TYPE,
      line_cd          gipi_firestat_extract_dtl.line_cd%TYPE,
      share_cd         giis_dist_share.share_cd%TYPE,
      share_tsi_amt    NUMBER (21, 2),
      share_prem_amt   NUMBER (21, 2),
      share_type       giis_dist_share.share_type%TYPE,
      trty_name        giis_dist_share.trty_name%TYPE,
      zone_class       cg_ref_codes.rv_meaning%TYPE
   );

   TYPE gipir037a_distr_type_tab IS TABLE OF gipir037a_distr_type;

   TYPE gipir037a_q3_type IS RECORD (
      zone_class            VARCHAR2 (100),
      zone_risk             NUMBER (4),
      zone_share_cd         NUMBER (3),
      zone_share_tsi_amt    NUMBER (21, 2),
      zone_share_prem_amt   NUMBER (21, 2),
      zone_trty_name        VARCHAR2 (30),
      no_risks              NUMBER (12),
      cp_zone_share_prem    NUMBER (21, 2),
      share_tsi_amt         NUMBER (21, 2),
      share_prem_amt        NUMBER (21, 2),
      ROWCOUNT              NUMBER (10)
   );

   TYPE gipir037a_q3_tab IS TABLE OF gipir037a_q3_type;

   TYPE gipir037a_q3_b_type IS RECORD (
      zone_grp              giis_typhoon_zone.zone_grp%TYPE,
      zone_class            cg_ref_codes.rv_meaning%TYPE,
      zone_line_cd          giis_dist_share.line_cd%TYPE,
      zone_share_cd         giis_dist_share.share_cd%TYPE,
      zone_share_tsi_amt    NUMBER (21, 2),
      zone_share_prem_amt   NUMBER (21, 2),
      zone_trty_name        giis_dist_share.trty_name%TYPE,
      ROWCOUNT              NUMBER (10)
   );

   TYPE gipir037a_q3_b_tab IS TABLE OF gipir037a_q3_b_type;

   TYPE gipir037a_q2_type IS RECORD (
      extract_dt1       DATE,
      header1           VARCHAR2 (200),
      zone_type1        NUMBER (1),
      zone_no1          VARCHAR2 (2),
      no_of_risk1       NUMBER (4),
      share_cd1         NUMBER (3),
      share_tsi_amt1    NUMBER (21, 2),
      share_prem_amt1   NUMBER (21, 2),
      share_type1       VARCHAR2 (1),
      trty_name1        VARCHAR2 (30),
      e_zone_desc       VARCHAR2 (500),
      e_zone_risk       NUMBER (10)
   );

   TYPE gipir037a_q2_tab IS TABLE OF gipir037a_q2_type;

   TYPE get_maint_zones_rec_type IS RECORD (
      zone_type       gipi_firestat_extract_dtl.zone_type%TYPE,
      zone_no         gipi_firestat_extract_dtl.zone_no%TYPE,
      zone_desc       VARCHAR2 (1000),
      zone_grp        giis_typhoon_zone.zone_grp%TYPE,
      zone_grp_desc   cg_ref_codes.rv_meaning%TYPE
   );

   TYPE get_maint_zones_rec_type_tab IS TABLE OF get_maint_zones_rec_type;

--   TYPE get_firestat_dtl_rec_type IS RECORD (
--     zone_type              gipi_firestat_extract_dtl.zone_type%TYPE ,
--     zone_no                gipi_firestat_extract_dtl.zone_no%TYPE ,
--     zone_desc              VARCHAR2(1000) ,
--     zone_grp               giis_typhoon_zone.zone_grp%TYPE ,
--     zone_grp_desc          cg_ref_codes.rv_meaning%TYPE ,
--     policy_no              VARCHAR2(100)    ,
--     line_cd                gipi_polbasic.line_cd%TYPE ,
--     subline_cd             gipi_polbasic.subline_cd%TYPE ,
--     iss_cd                 gipi_polbasic.iss_cd%TYPE ,
--     issue_yy               gipi_polbasic.issue_yy%TYPE ,
--     pol_seq_no             gipi_polbasic.pol_seq_no%TYPE ,
--     renew_no               gipi_polbasic.renew_no%TYPE ,
--     risk_rec               VARCHAR2(100 ) ,
--     fr_item_grp            gipi_firestat_extract_dtl.fr_item_grp%TYPE ,
--     occupancy_cd           gipi_firestat_extract_dtl.occupancy_cd%TYPE ,
--     share_cd               giis_dist_share.share_cd%TYPE ,
--     share_type             giis_dist_share.share_type%TYPE ,
--     dist_share_name        giis_dist_share.trty_name%TYPE ,
--     acct_trty_type         giis_dist_share.acct_trty_type%TYPE ,
--     acct_trty_type_sname   giis_ca_trty_type.trty_sname%TYPE ,
--     acct_trty_type_lname   giis_ca_trty_type.trty_lname%TYPE
--   );
   FUNCTION get_gipir037a_record (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2                            --edgar 03/13/2015
   )
      RETURN gipir037a_tab PIPELINED;

   FUNCTION get_gipir037a_b_record (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2                            --edgar 03/13/2015
   )
      RETURN gipir037a_tab PIPELINED;

   FUNCTION get_gipir037a_distr_record (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2,
      p_zone_no         gipi_firestat_extract_dtl.zone_no%TYPE
   )
      RETURN gipir037a_distr_type_tab PIPELINED;

   FUNCTION get_gipir037a_v2_record (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2                            --edgar 03/13/2015
   )
      RETURN gipir037a_tab PIPELINED;

   FUNCTION get_gipir037a_q3 (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2                            --edgar 03/16/2015
   )
      RETURN gipir037a_q3_tab PIPELINED;

   FUNCTION get_gipir037a_q3_v2 (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2
   )
      RETURN gipir037a_q3_tab PIPELINED;

   FUNCTION get_gipir037a_q2 (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2,
      p_risk_cnt        VARCHAR2                            --edgar 03/16/2015
   )
      RETURN gipir037a_q2_tab PIPELINED;

   FUNCTION get_gipir037a_q3_2 (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2
   )
      RETURN gipir037a_q3_tab PIPELINED;

   FUNCTION get_gipir037a_q3_2_b (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_user            VARCHAR2,
      p_zonetype        VARCHAR2
   )
      RETURN gipir037a_q3_b_tab PIPELINED;

   -- jhing 03.22.2015 added new program units
   FUNCTION get_maintained_zones (
      p_zone_type   gipi_firestat_extract_dtl.zone_type%TYPE
   )
      RETURN get_maint_zones_rec_type_tab PIPELINED;
END;
/


