CREATE OR REPLACE PACKAGE CPI.GICLS057_PKG
AS
/* Created by : John Dolon
 * Date Created: 09.09.2013
 * Reference By: GICLS057 - Catastrophic Event Inquiry
 *
*/
   TYPE cat_lov_type IS RECORD (
      catastrophic_cd   VARCHAR2(10),
      catastrophic_desc VARCHAR2(50)
      );
      
   TYPE cat_lov_tab IS TABLE OF cat_lov_type;
   
   FUNCTION get_cat_lov
    RETURN cat_lov_tab PIPELINED;
   
   TYPE line_lov_type IS RECORD (
      line_cd           VARCHAR2(2),
      line_name         VARCHAR2(20)
   );
   
   TYPE line_lov_tab IS TABLE OF line_lov_type;
   
   FUNCTION get_line_lov (
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
   RETURN line_lov_tab PIPELINED;
   
   TYPE branch_lov_type IS RECORD (
      iss_cd           VARCHAR2(2),
      iss_name         VARCHAR2(20)   
   );
   
   TYPE branch_lov_tab IS TABLE OF branch_lov_type;
   
   FUNCTION get_branch_lov (
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
   RETURN branch_lov_tab PIPELINED;
   
   TYPE loss_cat_lov_type IS RECORD (
      loss_cat_cd      VARCHAR2(2),
      loss_cat_des     VARCHAR2(25)  
   );
   
   TYPE loss_cat_lov_tab IS TABLE OF loss_cat_lov_type;
   
   FUNCTION get_loss_cat_lov (
      p_line_cd     VARCHAR2
   )
   RETURN loss_cat_lov_tab PIPELINED;
   
   TYPE province_lov_type IS RECORD (
      province_cd      VARCHAR2(6),
      province_desc    VARCHAR2(25)  
   );
   
   TYPE province_lov_tab IS TABLE OF province_lov_type;
   
   FUNCTION get_province_lov
    RETURN province_lov_tab PIPELINED;
    
   TYPE city_lov_type IS RECORD (
      city_cd      VARCHAR2(6),
      city         VARCHAR2(40)  
   );
   
   TYPE city_lov_tab IS TABLE OF city_lov_type;
   
   FUNCTION get_city_lov(
      p_province_cd     VARCHAR2
   )
   RETURN city_lov_tab PIPELINED;
   
   TYPE district_lov_type IS RECORD (
      district_no      VARCHAR2(6),
      district_desc    VARCHAR2(40)  
   );
   
   TYPE district_lov_tab IS TABLE OF district_lov_type;
   
   FUNCTION get_district_lov(
      p_province_cd     VARCHAR2,
      p_city_cd         VARCHAR2
   )
   RETURN district_lov_tab PIPELINED;
   
   TYPE block_lov_type IS RECORD (
      block_no      VARCHAR2(6),
      block_desc    VARCHAR2(40)  
   );
   
   TYPE block_lov_tab IS TABLE OF block_lov_type;
   
   FUNCTION get_block_lov(
      p_province_cd     VARCHAR2,
      p_city_cd         VARCHAR2,
      p_district_cd     VARCHAR2
   )
   RETURN block_lov_tab PIPELINED;
   
   PROCEDURE validate_gicls057_cat_cd(
      p_catastrophic_cd   IN OUT VARCHAR2,
      p_catastrophic_desc IN OUT VARCHAR2
   );
   
   PROCEDURE validate_gicls057_line_cd(
      p_line_cd   IN OUT GIIS_LINE.line_cd%TYPE,
      p_line_name IN OUT GIIS_LINE.line_name%TYPE
   );
   
   PROCEDURE validate_gicls057_branch_cd(
      p_iss_cd   IN OUT VARCHAR2,
      p_iss_name IN OUT VARCHAR2
   );
   
   TYPE gicls057_table_type IS RECORD (
      line_cd           VARCHAR2(2),
      claim_no          VARCHAR2(30),
      policy_no         VARCHAR2(50),
      loss_cat_cd       VARCHAR2(2),
      loss_cat_des      VARCHAR2(25),
      assd_no           NUMBER(12),
      assd_name         VARCHAR2(500),
      in_hou_adj        VARCHAR2(8),
      catastrophic_cd   NUMBER(5),
      catastrophic_desc VARCHAR2(50),
      loss_date         DATE,
      location          VARCHAR2(200),
      clm_stat_cd       VARCHAR2(2),
      clm_stat_desc     VARCHAR2(30),
      province_cd       VARCHAR2(6),
      province          VARCHAR2(400),
      city_cd           VARCHAR2(6),
      city              VARCHAR2(40),
      district_no       VARCHAR2(6),
      district_desc     VARCHAR2(40),
      block_no          VARCHAR2(6),
      block_desc        VARCHAR2(40),
      loss_res_amt      NUMBER(16,2),
      loss_pd_amt       NUMBER(16,2),
      exp_res_amt       NUMBER(16,2),
      exp_pd_amt        NUMBER(16,2),
      net_res_amt       NUMBER(16,2),
      trty_res_amt      NUMBER(16,2),
      np_trty_res_amt   NUMBER(16,2),
      facul_res_amt     NUMBER(16,2),
      net_pd_amt        NUMBER(16,2),
      trty_pd_amt       NUMBER(16,2),
      np_trty_pd_amt    NUMBER(16,2),
      facul_pd_amt      NUMBER(16,2),
      group_sw          VARCHAR2(1)
      );
      
   TYPE gicls057_table_tab IS TABLE OF gicls057_table_type;
   
   FUNCTION get_gicls057_table(
       p_selection             VARCHAR2,
       p_catastrophic_cd       VARCHAR2,
       p_line_cd               VARCHAR2,
       p_iss_cd                VARCHAR2,
       p_location              VARCHAR2,
       p_loss_cat_cd           VARCHAR2,
       p_province_cd           VARCHAR2,
       p_city_cd               VARCHAR2,
       p_district_no           VARCHAR2,
       p_block_no              VARCHAR2,
       p_from_date             VARCHAR2,
       p_to_date               VARCHAR2
   )
   RETURN gicls057_table_tab PIPELINED;
END;
/


