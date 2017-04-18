CREATE OR REPLACE PACKAGE CPI.gipir039b_pkg
AS
   TYPE gipir039b_type IS RECORD (
      policy_no           NUMBER (16),
      sum_tsi             NUMBER (21, 2),
      sum_prem_amt        NUMBER (21, 2),
      zone_no             NUMBER (16),
      zone_type           NUMBER (16),
      fi_item_grp         VARCHAR2 (2),
      zone_grp1           VARCHAR2 (2),
      item_grp_name       VARCHAR2 (100),
      zone_grp_name       VARCHAR2 (50),
      not_exist           VARCHAR2 (1),
      sum_tsi_per_zone    NUMBER (21, 2),                   --edgar03/17/2015
      sum_prem_per_zone   NUMBER (21, 2),                   --edgar03/17/2015
      sum_pol_per_zone    NUMBER (21),                      --edgar03/17/2015
      sum_tsi_per_grp     NUMBER (21, 2),                   --edgar03/17/2015
      sum_prem_per_grp    NUMBER (21, 2),                   --edgar03/17/2015
      sum_pol_per_grp     NUMBER (21),                      --edgar03/17/2015
      sum_tsi_zoneno      NUMBER (21, 2),                   --edgar03/17/2015
      sum_prem_zoneno     NUMBER (21, 2),                   --edgar03/17/2015
      sum_pol_zoneno      NUMBER (21),                      --edgar03/17/2015
      total_cnt           NUMBER (21),                      --edgar03/17/2015
      total_tsi           NUMBER (21, 2),                   --edgar03/17/2015
      total_prem          NUMBER (21, 2)                    --edgar03/17/2015
   );

   TYPE gipir039b_tab IS TABLE OF gipir039b_type;

   FUNCTION get_gipir039b (p_zone_type VARCHAR2, p_as_of_sw VARCHAR2)
      RETURN gipir039b_tab PIPELINED;

   TYPE gipir039b_header_type IS RECORD (
      company_name      VARCHAR2 (100),
      company_address   VARCHAR2 (250),
      report_title      VARCHAR2 (200),
      report_date       VARCHAR2 (200),
      report_bus_head   VARCHAR2 (100)
   );

   TYPE gipir039b_header_tab IS TABLE OF gipir039b_header_type;

   FUNCTION get_gipir039b_header (
      p_zone_type    VARCHAR2,
      p_date         VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_bus_cd       VARCHAR2
   )
      RETURN gipir039b_header_tab PIPELINED;

   FUNCTION get_gipir039b_v2 (
      p_zone_type    VARCHAR2,
      p_as_of_sw     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir039b_tab PIPELINED;

   FUNCTION get_gipir039b_2 (
      p_zone_type    VARCHAR2,
      p_as_of_sw     VARCHAR2,
      p_zone_grp     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir039b_tab PIPELINED;

   FUNCTION get_gipir039b_tot_by_zone_grp (
      p_zone_type    VARCHAR2,
      p_as_of_sw     VARCHAR2,
      p_zone_grp     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir039b_tab PIPELINED;

   FUNCTION get_gipir039b_tot_by_item_grp (
      p_zone_type    VARCHAR2,
      p_as_of_sw     VARCHAR2,
      p_zone_grp     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir039b_tab PIPELINED;

   FUNCTION get_gipir039b_tot_by_zone (
      p_zone_type    VARCHAR2,
      p_as_of_sw     VARCHAR2,
      p_zone_grp     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir039b_tab PIPELINED;

   FUNCTION get_gipir039b_summary (
      p_zone_type    VARCHAR2,
      p_as_of_sw     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gipir039b_tab PIPELINED;
END;
/


