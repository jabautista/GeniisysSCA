CREATE OR REPLACE PACKAGE CPI.csv_uw_genstat_rep
AS
   TYPE dynamic_csv_rec_type IS RECORD(rec VARCHAR2(32767)); --Added by Jerome Bautista SR 21338 02.03.2016
   
   TYPE dynamic_csv_rec_tab IS TABLE OF dynamic_csv_rec_type; --Added by Jerome Bautista SR 21338 02.03.2016
   
   TYPE gipir037_rec_type IS RECORD (
      start_date         VARCHAR2 (100),
      end_date           VARCHAR2 (100),
      as_of_date         VARCHAR2 (100),
      zone_type          cg_ref_codes.rv_meaning%TYPE,
      zone_no            VARCHAR (50),
      division           cg_ref_codes.rv_meaning%TYPE,
      gross_tsi_amt      NUMBER (18, 2),
      gross_prem_amt     NUMBER (18, 2),
      net_ret_tsi_amt    NUMBER (18, 2),
      net_ret_prem_amt   NUMBER (18, 2),
      facul_tsi_amt      NUMBER (18, 2),
      facul_prem_amt     NUMBER (18, 2),
      treaty_tsi_amt     NUMBER (18, 2),
      treaty_prem_amt    NUMBER (18, 2)
   );

   TYPE gipir037_type IS TABLE OF gipir037_rec_type;

   TYPE csv_dynamicsql IS RECORD (
      query1   VARCHAR2 (4000),
      query2   VARCHAR2 (4000),
      query3   VARCHAR2 (4000),
      query4   VARCHAR2 (4000),
      query5   VARCHAR2 (4000),
      query6   VARCHAR2 (4000),
      query7   VARCHAR2 (4000),
      query8   VARCHAR2 (4000)
   );

   TYPE csv_dynamicsql_tab IS TABLE OF csv_dynamicsql;

   TYPE gipir037a_base_tbl_rec IS RECORD (
      zone_no             gipi_firestat_extract_dtl_vw.zone_no%TYPE,
      zone_grp            gipi_firestat_extract_dtl_vw.zone_grp%TYPE,
      risk_cnt            NUMBER (16),
      gross_sum_insured   NUMBER (30, 2),
      gross_premium       NUMBER (30, 2)
   );

   TYPE gipir037a_base_tab IS TABLE OF gipir037a_base_tbl_rec;

   --FUNCTION CSV_GIPIR037B
   TYPE gipir037b_rec_type IS RECORD (
      period                    VARCHAR (2000),
      zone_desc                 VARCHAR (2000),
      distribution_share_name   giis_dist_share.trty_name%TYPE,
      assured_name              giis_assured.assd_name%TYPE,
      policy_no                 VARCHAR2 (100),
      share_tsi_amt             NUMBER (18, 2),
      share_prem_amt            NUMBER (18, 2)
   );

   TYPE gipir037b_type IS TABLE OF gipir037b_rec_type;

   --FUNCTION CSV_GIPIR037C
   TYPE gipir037c_rec_type IS RECORD (
      period           VARCHAR (2000),
      zone_desc        VARCHAR (2000),
      tariff_cd        giis_tariff.tarf_cd%TYPE,
      tariff_desc      giis_tariff.tarf_desc%TYPE,
      policy_no        VARCHAR2 (100),
      assured_name     giis_assured.assd_name%TYPE,
      share_tsi_amt    NUMBER (18, 2),
      share_prem_amt   NUMBER (18, 2)
   );

   TYPE gipir037c_type IS TABLE OF gipir037c_rec_type;

   --FUNCTION CSV_GIPIR038A - CSV_GIPIR038C
   TYPE gipir038_rec_type IS RECORD (
      period                  VARCHAR2 (2000),
      zone_type               cg_ref_codes.rv_meaning%TYPE,
      eq_zone_type            cg_ref_codes.rv_low_value%TYPE,
      eq_zone_type_desc       VARCHAR (2000),
      tariff_interpretation   VARCHAR2 (2000),
      policy_cnt              NUMBER,
      aggr_sum_insured        NUMBER (16, 2),
      aggr_prem_amt           NUMBER (16, 2)
   );

   TYPE gipir038_type IS TABLE OF gipir038_rec_type;

   -- FUNCTION CSV_GIPIR039A
   TYPE gipir039a_rec_type IS RECORD (
      period               VARCHAR2 (2000),
      zone_type            cg_ref_codes.rv_meaning%TYPE,
      zone_grp             cg_ref_codes.rv_meaning%TYPE,
      zone_no              cg_ref_codes.rv_meaning%TYPE,
      policy_no            VARCHAR2 (100),
      bldg_risk_cnt         NUMBER (16, 2),
      bldg_tsi             NUMBER (30, 2),
      bldg_prem_amt        NUMBER (30, 2),
      contents_risk_cnt     NUMBER (16, 2),
      content_tsi          NUMBER (30, 2),
      content_prem_amt     NUMBER (30, 2),
      lossprofit_risk_cnt   NUMBER (16, 2),
      loss_tsi             NUMBER (30, 2),
      loss_prem_amt        NUMBER (30, 2),
      total_risk_cnt        NUMBER (16, 2),
      total_tsi            NUMBER (30, 2),
      total_prem           NUMBER (30, 2)
   );

   TYPE gipir039a_type IS TABLE OF gipir039a_rec_type;

   -- FUNCTION CSV_GIPIR039B
   TYPE gipir039b_rec_type IS RECORD (
      period             VARCHAR (2000),
      zone_grp           cg_ref_codes.rv_meaning%TYPE,        --VARCHAR (10),
      zone_no            VARCHAR (10),
      bldg_pol_cnt       NUMBER,
      bldg_tot_tsi       NUMBER (30, 2),                         -- from 16,2
      bldg_tot_prem      NUMBER (30, 2),                         -- from 16,2
      content_pol_cnt    NUMBER,
      content_tot_tsi    NUMBER (30, 2),                         -- from 16,2
      content_tot_prem   NUMBER (30, 2),                         -- from 16,2
      loss_pol_cnt       NUMBER,
      loss_tot_tsi       NUMBER (30, 2),                         -- from 16,2
      loss_tot_prem      NUMBER (30, 2),                         -- from 16,2
      tot_pol_cnt        NUMBER,
      total_tsi          NUMBER (30, 2),                         -- from 16,2
      total_prem         NUMBER (30, 2)                          -- from 16,2
   );

   TYPE gipir039b_type IS TABLE OF gipir039b_rec_type;

   -- FUNCTION CSV_GIPIR039D
   TYPE gipir039d_rec_type IS RECORD (
      period             VARCHAR2 (2000),
      zone_no            VARCHAR2 (10),
      occ_cd             VARCHAR2 (10),
      occupancy          VARCHAR (100),
      risk               NUMBER,
      bldg_exposure      NUMBER (16, 2),
      bldg_prem          NUMBER (16, 2),
      content_exposure   NUMBER (16, 2),
      content_prem       NUMBER (16, 2),
      loss_exposure      NUMBER (16, 2),
      loss_prem          NUMBER (16, 2),
      gross_exposure     NUMBER (16, 2),
      gross_prem         NUMBER (16, 2),
      ret_exposure       NUMBER (16, 2),
      ret_prem           NUMBER (16, 2),
      treaty_exposure    NUMBER (16, 2),
      treaty_prem        NUMBER (16, 2),
      facul_exposure     NUMBER (16, 2),
      facul_prem         NUMBER (16, 2)
   );

   TYPE gipir039d_type IS TABLE OF gipir039d_rec_type;

   TYPE gipir039e_rec_type IS RECORD (
      period                    VARCHAR2 (2000),
      zone_type                 cg_ref_codes.rv_meaning%TYPE,
      dist_grp_shr_name         VARCHAR2 (2000),
      zone_grp                  cg_ref_codes.rv_meaning%TYPE,
      occupancy                 giis_fire_occupancy.occupancy_desc%TYPE,
      zone_no                   VARCHAR2 (50),
      policy_no                 VARCHAR2 (100),
      bldg_risk_cnt             NUMBER (16),
      bldg_insured_amt          NUMBER (30, 2),
      bldg_premium              NUMBER (30, 2),
      contents_risk_cnt         NUMBER (16),
      contents_insured_amt      NUMBER (30, 2),
      contents_premium          NUMBER (30, 2),
      loss_of_profit_risk_cnt   NUMBER (16),
      loss_of_profit_tsi        NUMBER (30, 2),
      loss_of_profit_premium    NUMBER (30, 2),
      total_risk_cnt            NUMBER (16),
      total_sum_insured         NUMBER (30, 2),
      total_premium             NUMBER (30, 2)
   );

   TYPE gipir039e_type IS TABLE OF gipir039e_rec_type;

   TYPE gipir039h_rec_type IS RECORD (
      zone_type                    cg_ref_codes.rv_meaning%TYPE,
      zone_grp                     cg_ref_codes.rv_meaning%TYPE,
      zone_no                      VARCHAR2 (50),
      occupancy                    giis_fire_occupancy.occupancy_desc%TYPE,
      policy_no                    VARCHAR2 (100),
      item_no                      gipi_fireitem.item_no%TYPE,
      block_id                     gipi_fireitem.block_id%TYPE,
      risk_cd                      gipi_fireitem.risk_cd%TYPE,
      dist_share_name              giis_dist_share.trty_name%TYPE,
      bldg_sum_insured             NUMBER (30, 2),
      bldg_premium_amt             NUMBER (30, 2),
      contents_sum_insured         NUMBER (30, 2),
      contents_premium_amt         NUMBER (30, 2),
      loss_of_profit_sum_insured   NUMBER (30, 2),
      loss_of_profit_prem_amt      NUMBER (30, 2),
      total_sum_insured            NUMBER (30, 2),
      total_premium_amt            NUMBER (30, 2)
   );

   TYPE gipir039h_tab IS TABLE OF gipir039h_rec_type;

   -- added by jhing 03.21.2015
   TYPE gipir037_recdtl_type IS RECORD (
      zone_type        gipi_firestat_extract_dtl.zone_type%TYPE,
      zone_no          gipi_firestat_extract_dtl.zone_no%TYPE,
      zone_grp         giis_flood_zone.zone_grp%TYPE,
      zone_grp_desc    cg_ref_codes.rv_meaning%TYPE,
      line_cd          giis_dist_share.line_cd%TYPE,
      share_cd         giis_dist_share.share_cd%TYPE,
      share_type       giis_dist_share.share_type%TYPE,
      share_tsi_amt    NUMBER (18, 2),
      share_prem_amt   NUMBER (18, 2)
   );

   TYPE gipir037_recdtl_tab IS TABLE OF gipir037_recdtl_type;

   FUNCTION get_gipir037_recdtl (
      p_as_of_sw        VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_recdtl_tab PIPELINED;

   FUNCTION get_gipir037a_core_rec (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_risk_cnt        VARCHAR2
   )
      RETURN gipir037a_base_tab PIPELINED;

   FUNCTION get_gipir037a_dynsql (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_risk_cnt        VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED;

   FUNCTION csv_gipir037 (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir037_type PIPELINED;

   FUNCTION csv_gipir037b (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir037b_type PIPELINED;

   FUNCTION csv_gipir037c (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir037c_type PIPELINED;

   FUNCTION csv_gipir038c (
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir038_type PIPELINED;

   FUNCTION get_gipir038c_dynsql (
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN csv_dynamicsql_tab PIPELINED;

   FUNCTION csv_gipir039a (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_risk_cnt        VARCHAR2 
   )
      RETURN gipir039a_type PIPELINED;

   FUNCTION csv_gipir039b_old (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_table           VARCHAR2,
      p_column          VARCHAR2
   )
      RETURN gipir039b_type PIPELINED;

   FUNCTION csv_gipir039b (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_table           VARCHAR2,
      p_column          VARCHAR2
   )
      RETURN gipir039b_type PIPELINED;

   FUNCTION csv_gipir039d (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_table           VARCHAR2,
      p_column          VARCHAR2,
      p_by_count        VARCHAR2
   )
      RETURN gipir039d_type PIPELINED;

   FUNCTION get_gipir039d_dynsql (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user_id         giis_users.user_id%TYPE,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_risk_cnt        VARCHAR2
   )
      --RETURN csv_dynamicsql_tab PIPELINED; --Commented and replaced by Jerome Bautista SR 21338 02.04.2016
      RETURN dynamic_csv_rec_tab PIPELINED;

   FUNCTION csv_gipir039e (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user_id         VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_print_sw        VARCHAR2,
      p_trty_type_cd    VARCHAR2,
      p_risk_cnt        VARCHAR2
   )
      RETURN gipir039e_type PIPELINED;

   FUNCTION csv_gipir039h (
      p_starting_date   VARCHAR2,
      p_ending_date     VARCHAR2,
      p_user            VARCHAR2,
      p_as_of_sw        VARCHAR2,
      p_zone_type       VARCHAR2,
      p_expired_as_of   VARCHAR2
   )
      RETURN gipir039h_tab PIPELINED;
   FUNCTION escape_string (p_string VARCHAR2) --Added by Jerome Bautista SR 21338 02.04.2016
      RETURN VARCHAR2;
END csv_uw_genstat_rep;
/

CREATE OR REPLACE PUBLIC SYNONYM csv_uw_genstat_rep FOR cpi.csv_uw_genstat_rep; --edgar 05/22/2015 SR 4318

/