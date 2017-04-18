CREATE OR REPLACE PACKAGE CPI.gipir037_pkg
AS
   TYPE gipir037_type IS RECORD (
      zone_no         VARCHAR2 (2),
      share_tsi_amt   NUMBER (16, 2),
      rv_meaning      VARCHAR2 (100),
      header          VARCHAR2 (200),
      flag            VARCHAR2 (10),
      comp_name       VARCHAR2 (100),
      comp_add        VARCHAR2 (500),
      header_func     VARCHAR2 (100),
      bus_cd          VARCHAR2 (1000),
      date_type       VARCHAR2 (100),
      period_end      VARCHAR2 (100),
      period_start    VARCHAR2 (100),
      expired_as_of   VARCHAR2 (100),
      tsi_tot         VARCHAR2 (1),
      prem_tot        VARCHAR2 (1)
   );

   TYPE gipir037_tab IS TABLE OF gipir037_type;

   TYPE gipir037_zone_type IS RECORD (
      zone_no   VARCHAR2 (2),
      tsi       NUMBER (16, 2),
      prem      NUMBER (16, 2)
   );

   TYPE gipir037_zone_tab IS TABLE OF gipir037_zone_type;

   TYPE gipir037_zone2_type IS RECORD (
      zone_no2   VARCHAR2 (2),
      tsi1       NUMBER (16, 2),
      prem1      NUMBER (16, 2)
   );

   TYPE gipir037_zone2_tab IS TABLE OF gipir037_zone2_type;

   TYPE gipir037_zone3_type IS RECORD (
      zone_no3   VARCHAR2 (2),
      tsi2       NUMBER (16, 2),
      prem2      NUMBER (16, 2)
   );

   TYPE gipir037_zone3_tab IS TABLE OF gipir037_zone3_type;

   TYPE gipir037_zone4_type IS RECORD (
      zone_no4   VARCHAR2 (2),
      tsi3       NUMBER (16, 2),
      prem3      NUMBER (16, 2)
   );

   TYPE gipir037_zone4_tab IS TABLE OF gipir037_zone4_type;

   TYPE gipir037_rv1_type IS RECORD (
      rv_meaning1      VARCHAR2 (100),
      share_tsi_amt    NUMBER (16, 2),
      share_prem_amt   NUMBER (16, 2)
   );

   TYPE gipir037_rv1_tab IS TABLE OF gipir037_rv1_type;

   TYPE gipir037_rv2_type IS RECORD (
      rv_meaning2       VARCHAR2 (100),
      share_tsi_amt1    NUMBER (16, 2),
      share_prem_amt1   NUMBER (16, 2)
   );

   TYPE gipir037_rv2_tab IS TABLE OF gipir037_rv2_type;

   TYPE gipir037_rv3_type IS RECORD (
      rv_meaning3       VARCHAR2 (100),
      share_tsi_amt2    NUMBER (16, 2),
      share_prem_amt2   NUMBER (16, 2)
   );

   TYPE gipir037_rv3_tab IS TABLE OF gipir037_rv3_type;

   TYPE gipir037_rv4_type IS RECORD (
      rv_meaning4       VARCHAR2 (100),
      share_tsi_amt3    NUMBER (16, 2),
      share_prem_amt3   NUMBER (16, 2)
   );

   TYPE gipir037_rv4_tab IS TABLE OF gipir037_rv4_type;
   
   -- added by jhing 03.21.2015 
   TYPE gipir037_recdtl_type IS RECORD (
      zone_type         gipi_firestat_extract_dtl.zone_type%TYPE ,
      zone_no           gipi_firestat_extract_dtl.zone_no%TYPE ,
      zone_grp          giis_flood_zone.zone_grp%TYPE ,
      zone_grp_desc     cg_ref_codes.rv_meaning%TYPE ,
      line_cd           giis_dist_share.line_cd%TYPE ,
      share_cd          giis_dist_share.share_cd%TYPE ,
      share_type        giis_dist_share.share_type%TYPE ,
      share_tsi_amt     NUMBER (18, 2) ,
      share_prem_amt    NUMBER (18, 2)      
   );
   
   TYPE gipir037_recdtl_tab IS TABLE OF gipir037_recdtl_type;
    
   
   TYPE gipir037_byzone_type IS RECORD (
      zone_no           VARCHAR2(50) ,
      gross_tsi_amt     NUMBER (18, 2) ,
      net_ret_tsi_amt   NUMBER (18, 2) ,   
      facul_tsi_amt     NUMBER (18, 2) ,    
      treaty_tsi_amt    NUMBER (18, 2) ,
      gross_prem_amt    NUMBER (18, 2) ,     
      net_ret_prem_amt  NUMBER (18, 2) , 
      facul_prem_amt    NUMBER (18, 2) , 
      treaty_prem_amt   NUMBER (18, 2)                         
   );
   
   TYPE gipir037_byzone_type_tab IS TABLE OF gipir037_byzone_type;   
   
   
   TYPE gipir037_byzgrp_type IS RECORD (
      zone_group          cg_ref_codes.rv_meaning%TYPE , 
      gross_tsi_amt       NUMBER (18, 2) ,
      net_ret_tsi_amt     NUMBER (18, 2) ,   
      facul_tsi_amt       NUMBER (18, 2) ,    
      treaty_tsi_amt      NUMBER (18, 2) ,
      gross_prem_amt      NUMBER (18, 2) ,     
      net_ret_prem_amt    NUMBER (18, 2) , 
      facul_prem_amt      NUMBER (18, 2) , 
      treaty_prem_amt     NUMBER (18, 2)                         
   );
   
   TYPE gipir037_byzgrp_type_tab IS TABLE OF gipir037_byzgrp_type;     
   

   FUNCTION get_gipir037_record (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_date_type       VARCHAR2,
      p_inc_endt        VARCHAR2,
      p_inc_exp         VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_tab PIPELINED;

   FUNCTION get_gipir037_zone (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2,
      p_zone_no         VARCHAR2
   )
      RETURN gipir037_zone_tab PIPELINED;

   FUNCTION get_gipir037_zone2 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2,
      p_zone_no         VARCHAR2
   )
      RETURN gipir037_zone2_tab PIPELINED;

   FUNCTION get_gipir037_zone3 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2,
      p_zone_no         VARCHAR2
   )
      RETURN gipir037_zone3_tab PIPELINED;

   FUNCTION get_gipir037_zone4 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2,
      p_zone_no         VARCHAR2
   )
      RETURN gipir037_zone4_tab PIPELINED;

   FUNCTION get_gipir037_rv1 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_rv1_tab PIPELINED;

   FUNCTION get_gipir037_rv2 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_rv2_tab PIPELINED;

   FUNCTION get_gipir037_rv3 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_rv3_tab PIPELINED;

   FUNCTION get_gipir037_rv4 (
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_rv4_tab PIPELINED;
      
   -- jhing 03.31.2015 added program unit for the revision of firestat reports
   
   FUNCTION get_gipir037_recdtl   (
      p_as_of_sw        VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,      
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   ) RETURN gipir037_recdtl_tab PIPELINED; 
   
   FUNCTION get_gipir037_byzone_record (
      p_as_of_sw        VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_byzone_type_tab PIPELINED;   
      
   
   FUNCTION get_gipir037_byzgrp_record (
      p_as_of_sw        VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_byzgrp_type_tab PIPELINED;  

   FUNCTION get_gipir037_v2_record (
      p_as_of_sw        VARCHAR2,
      p_bus_cd          NUMBER,
      p_expired_as_of   VARCHAR2,
      p_period_end      VARCHAR2,
      p_period_start    VARCHAR2,
      p_date_type       VARCHAR2,
      p_inc_endt        VARCHAR2,
      p_inc_exp         VARCHAR2,
      p_zonetype        VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN gipir037_tab PIPELINED;            
      
END GIPIR037_PKG ;
/


CREATE OR REPLACE PUBLIC SYNONYM GIPIR037_PKG FOR CPI.GIPIR037_PKG ; --edgar 05/22/2015 FULL WEB SR 4437

/ 