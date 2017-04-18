CREATE OR REPLACE PACKAGE CPI.GICLS264_PKG
AS
   TYPE clm_list_per_color_type IS RECORD (
      claim_id            GICL_MOTOR_CAR_DTL.claim_id%TYPE,
      item_no             VARCHAR2 (10),
      item_title          GICL_MOTOR_CAR_DTL.item_title%TYPE,
      plate_no            GICL_MOTOR_CAR_DTL.plate_no%TYPE,
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
      pol_iss_cd          GICL_CLAIMS.pol_iss_cd%TYPE
      
   );

   TYPE clm_list_per_color_tab IS TABLE OF clm_list_per_color_type;
   
   TYPE color_list_type IS RECORD(
      color_cd        GIIS_MC_COLOR.color_cd%TYPE,
      color           GIIS_MC_COLOR.color%TYPE,
      basic_color_cd  GIIS_MC_COLOR.basic_color_cd%TYPE,
      basic_color     GIIS_MC_COLOR.basic_color%TYPE
   );
  
   TYPE color_list_tab IS TABLE OF color_list_type;

   FUNCTION get_clm_list_per_color ( 
      p_user_id                 GIIS_USERS.user_id%TYPE,
      p_color_cd                GICL_MOTOR_CAR_DTL.color_cd%TYPE,
      p_basic_color_cd          GICL_MOTOR_CAR_DTL.basic_color_cd%TYPE,
      p_search_by               VARCHAR2,
      p_as_of_date              VARCHAR2,
      p_from_date               VARCHAR2,   
      p_to_date                 VARCHAR2
   )
      RETURN clm_list_per_color_tab PIPELINED;
      
   FUNCTION validate_color_per_color(
      p_basic_color_cd     GIIS_MC_COLOR.basic_color_cd%TYPE,
      p_color              GIIS_MC_COLOR.color%TYPE)
   RETURN VARCHAR2;

   FUNCTION validate_basic_color_per_color(
      p_basic_color        GIIS_MC_COLOR.basic_color%TYPE)
   RETURN VARCHAR2;
        
END;
/


