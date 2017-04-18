CREATE OR REPLACE PACKAGE CPI.gipir039a_pkg
AS
   TYPE gipir039a_type IS RECORD (
      company_name   VARCHAR2 (100),
      company_add    giac_parameters.param_value_v%TYPE,
      title          VARCHAR2 (200),
      date_title     VARCHAR2 (100),
      policy_id      gipi_firestat_extract_dtl.policy_id%TYPE,
      zone_grp       VARCHAR2 (100),
      zone_no        VARCHAR2(2),--gipi_firestat_extract_dtl.zone_no%TYPE, --edgar 03/26/2015
      zone_type      gipi_firestat_extract_dtl.zone_type%TYPE,
      policy_no      VARCHAR2 (50),
      total_tsi      NUMBER (18, 2), --edgar 03/26/2015
      total_prem     NUMBER (18, 2), --edgar 03/26/2015
      fi_item_grp    gipi_firestat_extract_dtl.fi_item_grp%TYPE,
      exist          VARCHAR2 (1),
      zone_grp_desc  VARCHAR2(100), --edgar 03/25/2015
      item_grp_name  VARCHAR2 (100), --edgar 03/26/2015
      policy_cnt     NUMBER
   );

   TYPE gipir039a_tab IS TABLE OF gipir039a_type;

   TYPE fi_item_grp_type IS RECORD (
      fi_item_grp   VARCHAR2 (100),
      fi_item_grp_desc   VARCHAR2 (100) --edgar 03/26/2015
   );

   TYPE fi_item_grp_tab IS TABLE OF fi_item_grp_type;

   TYPE fire_stat_dtl_crosstab_type IS RECORD (
      policy_id     gipi_firestat_extract_dtl.policy_id%TYPE,
      zone_grp      VARCHAR2 (100),
      zone_no       gipi_firestat_extract_dtl.zone_no%TYPE,
      zone_type     gipi_firestat_extract_dtl.zone_type%TYPE,
      policy_no     VARCHAR2 (50),
      total_tsi     NUMBER (18, 2), --edgar 03/25/2015
      total_prem    NUMBER (18, 2), --edgar 03/25/2015
      fi_item_grp   gipi_firestat_extract_dtl.fi_item_grp%TYPE,
      fi_item_grp_desc   VARCHAR2 (100) --edgar 03/26/2015
   );

   TYPE fire_stat_dtl_crosstab_tab IS TABLE OF fire_stat_dtl_crosstab_type;

   TYPE gipir039a_recap_type IS RECORD (
      cf_bldg_pol           NUMBER,
      cf_content_pol        NUMBER,
      cf_loss_pol           NUMBER,
      cf_grnd_pol           NUMBER,
      cf_bldg_tsi_amt       NUMBER,
      cf_content_tsi_amt    NUMBER,
      cf_loss_tsi_amt       NUMBER,
      cf_grnd_tsi_amt       NUMBER,
      cf_bldg_prem_amt      NUMBER,
      cf_content_prem_amt   NUMBER,
      cf_loss_prem_amt      NUMBER,
      cf_grnd_prem_amt      NUMBER
   );

   TYPE gipir039a_recap_tab IS TABLE OF gipir039a_recap_type;

   FUNCTION populate_gipir039a (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2
   )
      RETURN gipir039a_tab PIPELINED;

   FUNCTION get_fi_item_grp (
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2
   )
      RETURN fi_item_grp_tab PIPELINED;

   FUNCTION get_fire_stat_dtl_crosstab (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_zone_grp    VARCHAR2,
      p_policy_id   gipi_firestat_extract_dtl.policy_id%TYPE
   )
      RETURN fire_stat_dtl_crosstab_tab PIPELINED;

   FUNCTION populate_gipir039a_recap (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gipir039a_recap_tab PIPELINED;

   FUNCTION get_cf_pol_cnt (
      v_fi_item_grp   VARCHAR2,
      p_zone_type     NUMBER,
      p_as_of_sw      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION get_cf_tsi_amt (
      v_fi_item_grp   VARCHAR2,
      p_zone_type     NUMBER,
      p_as_of_sw      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN NUMBER;

   FUNCTION get_cf_prem_amt (
      v_fi_item_grp   VARCHAR2,
      p_zone_type     NUMBER,
      p_as_of_sw      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN NUMBER;

/*Added new functions: Edgar 03/25/2015
**Description : to correct queries and improve performance by getting values from the new view gipi_firestat_extract_dtl_vw
*/
   FUNCTION populate_gipir039a_v2 (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_risk_cnt    VARCHAR2
   )
      RETURN gipir039a_tab PIPELINED;     
      
   FUNCTION get_fi_item_grp_v2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_zone_grp    VARCHAR2
   )
      RETURN fi_item_grp_tab PIPELINED;   
      
   FUNCTION get_fire_stat_dtl_crosstab_v2 (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_zone_grp    VARCHAR2,
      p_policy_no   VARCHAR2,
      p_zone_no     VARCHAR2,
      p_risk_cnt    VARCHAR2
   )
      RETURN fire_stat_dtl_crosstab_tab PIPELINED;  
      
   FUNCTION get_fire_stat_dtl_crosstab_v3 (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_zone_grp    VARCHAR2,
      p_policy_no   VARCHAR2,
      p_zone_no     VARCHAR2,
      p_risk_cnt    VARCHAR2
   )
      RETURN gipir039a_tab PIPELINED;    
      
   FUNCTION get_fire_stat_dtl_sub_tot (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_zone_grp    VARCHAR2,
      p_risk_cnt    VARCHAR2
   )
      RETURN gipir039a_tab PIPELINED;   
      
   FUNCTION get_fire_stat_dtl_grand_tot (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_risk_cnt    VARCHAR2
   )
      RETURN gipir039a_tab PIPELINED;   
      
   FUNCTION populate_gipir039a_recap_v2 (
      p_zone_type   NUMBER,
      p_date        VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2,
      p_risk_cnt    VARCHAR2
   )
      RETURN gipir039a_recap_tab PIPELINED;                     
END gipir039a_pkg;
/


