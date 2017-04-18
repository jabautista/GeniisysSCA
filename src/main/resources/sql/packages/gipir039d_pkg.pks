CREATE OR REPLACE PACKAGE CPI.gipir039d_pkg
AS
   TYPE gipir039d_record_type IS RECORD (
      zone_no            gipi_firestat_extract_dtl.zone_no%TYPE,
      occupancy_cd       gipi_firestat_extract_dtl.occupancy_cd%TYPE,
      occ_code           VARCHAR (50),
      per_count          NUMBER,
      company_name       giac_parameters.param_value_v%TYPE,--VARCHAR2 (100), benjo 10.06.2015 GENQA-SR-5025
      company_address    giac_parameters.param_value_v%TYPE,--VARCHAR2 (100), benjo 10.06.2015 GENQA-SR-5025
      title              VARCHAR2 (200),
      date_title         VARCHAR2 (100),
      date_type          VARCHAR2 (100),
      cf_line            VARCHAR (100),
      mjm                VARCHAR2 (1),
      total_tsi          NUMBER (18, 2),                   --edgar 03/30/2015
      total_prem         NUMBER (18, 2),                   --edgar 03/30/2015
      fi_item_grp        VARCHAR2 (1),                     --edgar 03/30/2015
      fi_item_grp_desc   VARCHAR2 (100),                   --edgar 03/30/2015
      share_cd           NUMBER (18),                      --edgar 03/30/2015
      share_name         VARCHAR2 (100),                   --edgar 03/30/2015
      count_rownum       NUMBER                            --benjo 04/13/2015
      --added parameters : edgar 05/22/2015 SR 4318 
      ,row_from           NUMBER,
      row_to             NUMBER
   );

   TYPE gipir039d_record_tab IS TABLE OF gipir039d_record_type;

   TYPE fi_item_grp2_type IS RECORD (
      fi_item_grp   VARCHAR2 (50)
   );

   TYPE fi_item_grp2_tab IS TABLE OF fi_item_grp2_type;

   TYPE description_type IS RECORD (
      num           NUMBER (20),
      description   VARCHAR2 (50)
   );

   TYPE description_tab IS TABLE OF description_type;

   TYPE fi_item_details_type IS RECORD (
      fi_item_grp    VARCHAR2 (50),
      occupancy_cd   gipi_firestat_extract_dtl.occupancy_cd%TYPE,
      occ_code       VARCHAR2 (50),
      zone_no        gipi_firestat_extract_dtl.zone_no%TYPE,
      per_count      VARCHAR2 (50),
      total_tsi      gipi_firestat_extract_dtl.share_tsi_amt%TYPE,
      total_prem     gipi_firestat_extract_dtl.share_prem_amt%TYPE
   );

   TYPE fi_item_details_tab IS TABLE OF fi_item_details_type;

   TYPE share_details_type IS RECORD (
      num            NUMBER (20),
      description    VARCHAR2 (50),
      occupancy_cd   gipi_firestat_extract_dtl.occupancy_cd%TYPE,
      occ_code       VARCHAR2 (50),
      zone_no        gipi_firestat_extract_dtl.zone_no%TYPE,
      per_count      VARCHAR2 (50),
      total_tsi      gipi_firestat_extract_dtl.share_tsi_amt%TYPE,
      total_prem     gipi_firestat_extract_dtl.share_prem_amt%TYPE
   );

   TYPE share_details_tab IS TABLE OF share_details_type;

   TYPE fi_item_totals_type IS RECORD (
      fi_item_grp    VARCHAR2 (50),
      occupancy_cd   gipi_firestat_extract_dtl.occupancy_cd%TYPE,
      occ_code       VARCHAR2 (50),
      zone_no        gipi_firestat_extract_dtl.zone_no%TYPE,
      total_tsi      gipi_firestat_extract_dtl.share_tsi_amt%TYPE,
      total_prem     gipi_firestat_extract_dtl.share_prem_amt%TYPE
   );

   TYPE fi_item_totals_tab IS TABLE OF fi_item_totals_type;

   TYPE share_totals_type IS RECORD (
      num            NUMBER (20),
      description    VARCHAR2 (50),
      occupancy_cd   gipi_firestat_extract_dtl.occupancy_cd%TYPE,
      occ_code       VARCHAR2 (50),
      zone_no        gipi_firestat_extract_dtl.zone_no%TYPE,
      total_tsi      gipi_firestat_extract_dtl.share_tsi_amt%TYPE,
      total_prem     gipi_firestat_extract_dtl.share_prem_amt%TYPE
   );

   TYPE share_totals_tab IS TABLE OF share_totals_type;

   TYPE fi_item_grand_totals IS RECORD (
      policy_count   NUMBER,
      total_tsi      NUMBER,
      total_prem     NUMBER
   );

   TYPE fi_item_grand_totals_tab IS TABLE OF fi_item_grand_totals;

   TYPE gross_grand_totals IS RECORD (
      total_tsi    NUMBER,
      total_prem   NUMBER
   );

   TYPE gross_grand_totals_tab IS TABLE OF gross_grand_totals;

   TYPE share_grand_totals IS RECORD (
      total_tsi    NUMBER,
      total_prem   NUMBER
   );

   TYPE share_grand_totals_tab IS TABLE OF share_grand_totals;

   FUNCTION get_gipir039d_record (
      p_zone_type   NUMBER,
      p_column      VARCHAR2,
      p_table       VARCHAR2,
      p_date        VARCHAR2,
      p_as_of       VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_by_count    VARCHAR2,
      p_where       VARCHAR2,
      p_inc_exp     VARCHAR2,
      p_inc_endt    VARCHAR2,
      p_date_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gipir039d_record_tab PIPELINED;

   FUNCTION get_fi_item_grp2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN fi_item_grp2_tab PIPELINED;

   FUNCTION get_description_record (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN description_tab PIPELINED;

   FUNCTION get_fi_item_details (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2
   )
      RETURN fi_item_details_tab PIPELINED;

   FUNCTION get_share_details (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2
   )
      RETURN share_details_tab PIPELINED;

   FUNCTION get_fi_item_totals (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN fi_item_totals_tab PIPELINED;

   FUNCTION get_share_totals (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN share_totals_tab PIPELINED;

   FUNCTION get_fi_item_grand_totals (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN fi_item_grand_totals_tab PIPELINED;

   FUNCTION get_gross_grand_totals (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gross_grand_totals_tab PIPELINED;

   FUNCTION get_share_grand_totals (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN share_grand_totals_tab PIPELINED;

   --Added by Pol Cruz 01.26.2015
   FUNCTION get_fi_item_details2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2,
      p_table       VARCHAR2,
      p_column      VARCHAR2,
      p_zone_no     VARCHAR2,
      p_occ_code    VARCHAR2
   )
      RETURN fi_item_details_tab PIPELINED;

   TYPE fi_item_totals2_type IS RECORD (
      per_count    NUMBER,
      total_tsi    NUMBER,
      total_prem   NUMBER
   );

   TYPE fi_item_totals2_tab IS TABLE OF fi_item_totals2_type;

   FUNCTION get_fi_item_totals2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2,
      p_table       VARCHAR2,
      p_column      VARCHAR2,
      p_zone_no     VARCHAR2
   )
      RETURN fi_item_totals2_tab PIPELINED;

   FUNCTION get_share_details2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2,
      p_table       VARCHAR2,
      p_column      VARCHAR2,
      p_zone_no     VARCHAR2,
      p_occ_code    VARCHAR2
   )
      RETURN share_details_tab PIPELINED;

   FUNCTION get_share_details2_totals (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2,
      p_table       VARCHAR2,
      p_column      VARCHAR2,
      p_zone_no     VARCHAR2
   )
      RETURN fi_item_totals2_tab PIPELINED;

   FUNCTION get_fi_item_grand_totals2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2,
      p_table       VARCHAR2,
      p_column      VARCHAR2
   )
      RETURN fi_item_totals2_tab PIPELINED;

   FUNCTION get_share_grand_totals2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_by_count    VARCHAR2,
      p_table       VARCHAR2,
      p_column      VARCHAR2
   )
      RETURN fi_item_totals2_tab PIPELINED;

   FUNCTION get_gipir039d_record_v2 (
      p_zone_type   NUMBER,
      p_column      VARCHAR2,
      p_table       VARCHAR2,
      p_date        VARCHAR2,
      p_as_of       VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_by_count    VARCHAR2,
      p_where       VARCHAR2,
      p_inc_exp     VARCHAR2,
      p_inc_endt    VARCHAR2,
      p_date_type   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gipir039d_record_tab PIPELINED;

   FUNCTION get_fi_item_grp2_v2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2
   )
      RETURN fi_item_grp2_tab PIPELINED;

   FUNCTION get_description_record_v2 (
      p_zone_type   NUMBER,
      p_as_of_sw    VARCHAR2,
      p_user_id     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of       VARCHAR2
   )
      RETURN description_tab PIPELINED;

   FUNCTION get_fi_item_details2_v2 (
      p_zone_type   NUMBER,
      p_as_of       VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_by_count    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gipir039d_record_tab PIPELINED;

   FUNCTION get_fi_share_details2_v2 (
      p_zone_type   NUMBER,
      p_as_of       VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_by_count    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gipir039d_record_tab PIPELINED;
   --added function for single query to be used in entire report : edgar 05/22/2015 SR 4318   
   FUNCTION get_fi_gipir039D_details (
      p_zone_type   NUMBER,
      p_as_of       VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_as_of_sw    VARCHAR2,
      p_by_count    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN gipir039d_record_tab PIPELINED;      
END;
/

CREATE OR REPLACE PUBLIC SYNONYM gipir039d_pkg FOR cpi.gipir039d_pkg;--edgar 05/22/2015 SR 4318  