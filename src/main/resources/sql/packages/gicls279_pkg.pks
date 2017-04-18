CREATE OR REPLACE PACKAGE CPI.GICLS279_PKG
/*  Created by : Windell Valle
 *  Date Created: 06/06/13
 *  Reference By: GICLS279
 *  Description: Package for Claim Listing Per Block
 */
AS
   TYPE clm_list_per_block_type IS RECORD (
      claim_id            GICL_FIRE_DTL.claim_id%TYPE,
      item_no             VARCHAR2 (10),
      item_title          GICL_FIRE_DTL.item_title%TYPE,
      claim_number        VARCHAR (50),
      loss_res_amt        VARCHAR (50),
      loss_paid_amt       VARCHAR (50),
      exp_res_amt         VARCHAR (50),
      exp_paid_amt        VARCHAR (50),
      tot_loss_res_amt    VARCHAR (50),
      tot_loss_paid_amt   VARCHAR (50),
      tot_exp_res_amt     VARCHAR (50),
      tot_exp_paid_amt    VARCHAR (50),
      policy_no           VARCHAR (50),
      assd_name           GICL_CLAIMS.assured_name%TYPE,
      clm_stat_desc       GIIS_CLM_STAT.clm_stat_desc%TYPE,
      loss_date           GICL_CLAIMS.loss_date%TYPE,
      clm_file_date       GICL_CLAIMS.clm_file_date%TYPE,
      line_cd             GICL_CLAIMS.line_cd%TYPE,
      subline_cd          GICL_CLAIMS.subline_cd%TYPE,
      iss_cd              GICL_CLAIMS.iss_cd%TYPE,
      issue_yy            GICL_CLAIMS.issue_yy%TYPE,
      pol_seq_no          GICL_CLAIMS.pol_seq_no%TYPE,
      renew_no            GICL_CLAIMS.renew_no%TYPE,
      clm_yy              GICL_CLAIMS.clm_yy%TYPE,
      clm_seq_no          GICL_CLAIMS.clm_seq_no%TYPE,
      pol_iss_cd          GICL_CLAIMS.pol_iss_cd%TYPE,
      --
      block_id            GIIS_BLOCK.block_id%TYPE
      
   );
    
   TYPE clm_list_per_block_tab IS TABLE OF clm_list_per_block_type;
   
   TYPE block_list_type IS RECORD (
      block_no            GIIS_BLOCK.block_no%TYPE,
      block_desc          GIIS_BLOCK.block_desc%TYPE
   
   );
   
   TYPE block_list_tab IS TABLE OF block_list_type;
   
   FUNCTION get_clm_list_per_block ( 
      p_user_id                 GIIS_USERS.user_id%TYPE,
      p_district_no             GIIS_BLOCK.district_no%TYPE,
      p_block_no                GIIS_BLOCK.block_no%TYPE,
      p_search_by               VARCHAR2,
      p_as_of_date              VARCHAR2,
      p_from_date               VARCHAR2,   
      p_to_date                 VARCHAR2
   )
      RETURN clm_list_per_block_tab PIPELINED;

   FUNCTION validate_district_per_block(
      p_block_no           GIIS_BLOCK.block_no%TYPE,
      p_district           GIIS_BLOCK.district_desc%TYPE)
   RETURN VARCHAR2;

   FUNCTION validate_block_per_block(
      p_block        GIIS_BLOCK.block_desc%TYPE)
   RETURN VARCHAR2;
   
   FUNCTION get_block_by_district(
      p_district_no       GIIS_BLOCK.district_no%TYPE)
   RETURN block_list_tab PIPELINED;
END;
/


