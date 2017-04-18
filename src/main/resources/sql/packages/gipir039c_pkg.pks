CREATE OR REPLACE PACKAGE CPI.gipir039c_pkg
AS
   TYPE gipir039c_dtls_type IS RECORD (
      cf_company_name      VARCHAR2 (500),
      cf_company_address   VARCHAR2 (500),
      cf_rep_title         VARCHAR2 (200),
      cf_date_title        VARCHAR2 (100),
      policy_no1           VARCHAR2 (100),
      zone_no              gipi_firestat_extract_dtl.zone_no%TYPE,
      zone_type            gipi_firestat_extract_dtl.zone_type%TYPE,
      zone_grp1            giis_flood_zone.zone_grp%TYPE,
      policy_id            gipi_polbasic.policy_id%TYPE,
      zone_grp             giis_flood_zone.zone_grp%TYPE,
      cf_zone_grp          VARCHAR2 (20)
   );

   TYPE gipir039c_dtls_tab IS TABLE OF gipir039c_dtls_type;

   FUNCTION get_gipir039c_dtls (
      as_of_sw      VARCHAR2,
      p_as_of       DATE,
      p_column      VARCHAR2,
      p_date        VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE,
      p_table       VARCHAR2,
      p_zone_type   VARCHAR2
   )
      RETURN gipir039c_dtls_tab PIPELINED;

   TYPE gipir039c_title_type IS RECORD (
      fi_item_grp   VARCHAR2 (50)
   );

   TYPE gipir039c_title_tab IS TABLE OF gipir039c_title_type;

   FUNCTION get_gipir039c_title
      RETURN gipir039c_title_tab PIPELINED;

   TYPE gipi039c_figrp_amt IS RECORD (
      policy_id     gipi_polbasic.policy_id%TYPE,
      fi_item_grp   VARCHAR2 (50),
      share_tsi     gipi_firestat_extract_dtl.share_tsi_amt%TYPE,
      share_prem    gipi_firestat_extract_dtl.share_prem_amt%TYPE,
      zone_grp      VARCHAR2 (50)
   );

   TYPE gipi039c_figrp_amt_tab IS TABLE OF gipi039c_figrp_amt;

   FUNCTION get_figrp_amt (
      p_policy_id   gipi_polbasic.policy_id%TYPE,
      p_column      gipi_firestat_extract_dtl.zone_no%TYPE,
      p_table       VARCHAR2
   )
      RETURN gipi039c_figrp_amt_tab PIPELINED;

   FUNCTION get_figrp_amt_total (
      p_item_grp   VARCHAR2,
      p_column     gipi_firestat_extract_dtl.zone_no%TYPE,
      p_table      VARCHAR2
   )
      RETURN gipi039c_figrp_amt_tab PIPELINED;

   FUNCTION get_figrp_amt_gtotal (
      p_item_grp    VARCHAR2,
      p_column      gipi_firestat_extract_dtl.zone_no%TYPE,
      p_table       VARCHAR2,
      as_of_sw      VARCHAR2,
      p_zone_type   VARCHAR2
   )
      RETURN gipi039c_figrp_amt_tab PIPELINED;

   TYPE gipir039c_recap_dtl IS RECORD (
      cf_bldg_pol_cnt       NUMBER (16, 2),
      cf_content_pol_cnt    NUMBER (16, 2),
      cf_loss_pol_cnt       NUMBER (16, 2),
      cf_bldg_tsi_amt       NUMBER (16, 2),
      cf_content_tsi_amt    NUMBER (16, 2),
      cf_loss_tsi_amt       NUMBER (16, 2),
      cf_bldg_prem_amt      NUMBER (16, 2),
      cf_content_prem_amt   NUMBER (16, 2),
      cf_loss_prem_amt      NUMBER (16, 2),
      cf_grand_pol_cnt      NUMBER (16, 2),
      cf_grand_tsi_amt      NUMBER (16, 2),
      cf_grand_prem_amt     NUMBER (16, 2)
   );

   TYPE gipir039c_recap_dtl_tab IS TABLE OF gipir039c_recap_dtl;

   FUNCTION get_recap_dtl (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN gipir039c_recap_dtl_tab PIPELINED;

   FUNCTION get_cf_bldg_pol_cnt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_cf_content_pol_cnt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_cf_loss_pol_cnt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_cf_bldg_tsi_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_cf_content_tsi_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_cf_loss_tsi_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_cf_bldg_prem_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_cf_content_prem_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_cf_loss_prem_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_cf_grand_pol_cnt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_cf_grand_tsi_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER;

   FUNCTION get_cf_grand_prem_amt (as_of_sw VARCHAR2, p_zone_type VARCHAR2)
      RETURN NUMBER;
END;
/


