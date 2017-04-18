CREATE OR REPLACE PACKAGE CPI.GICLS263_PKG
AS
   TYPE get_make_lov_type IS RECORD (
      make_cd                  GIIS_MC_MAKE.MAKE_CD%TYPE,
      make                     GIIS_MC_MAKE.MAKE%TYPE,
      car_company              GIIS_MC_CAR_COMPANY.CAR_COMPANY%TYPE,
      car_company_cd           GIIS_MC_CAR_COMPANY.CAR_COMPANY_CD%TYPE                 
   );

   TYPE get_make_lov_tab IS TABLE OF get_make_lov_type;

   FUNCTION get_make_lov_list (
      p_user_id                VARCHAR2
      )
      RETURN get_make_lov_tab PIPELINED;
      
   TYPE get_make_details_type IS RECORD (
      claim_id                 GICL_MOTOR_CAR_DTL.claim_id%TYPE,
      item_no                  VARCHAR2 (10),
      item_title               GICL_MOTOR_CAR_DTL.item_title%TYPE,
      plate_no                 GICL_MOTOR_CAR_DTL.plate_no%TYPE,
      claim_number             VARCHAR (50),
      loss_res_amt             VARCHAR (50),
      loss_paid_amt            VARCHAR (50),
      exp_res_amt              VARCHAR (50),
      exp_paid_amt             VARCHAR (50),     
      policy_no                VARCHAR (50),
      assd_name                GICL_CLAIMS.assured_name%TYPE,
      clm_stat_desc            GIIS_CLM_STAT.clm_stat_desc%TYPE,
      loss_date                GICL_CLAIMS.loss_date%TYPE,
      clm_file_date            GICL_CLAIMS.clm_file_date%TYPE,
      line_cd                  GICL_CLAIMS.line_cd%TYPE,
      subline_cd               GICL_CLAIMS.subline_cd%TYPE,
      iss_cd                   GICL_CLAIMS.iss_cd%TYPE,
      issue_yy                 GICL_CLAIMS.issue_yy%TYPE,
      pol_seq_no               GICL_CLAIMS.pol_seq_no%TYPE,
      renew_no                 GICL_CLAIMS.renew_no%TYPE,
      clm_yy                   GICL_CLAIMS.clm_yy%TYPE,
      clm_seq_no               GICL_CLAIMS.clm_seq_no%TYPE,
      pol_iss_cd               GICL_CLAIMS.pol_iss_cd%TYPE
   );

   TYPE get_make_details_tab IS TABLE OF get_make_details_type;

   FUNCTION get_make_details (
      p_make_cd                NUMBER,
      p_car_company_cd         NUMBER,
      p_user_id                GIIS_USERS.user_id%TYPE,
      p_search_by              VARCHAR2,
      p_as_of_date             VARCHAR2,
      p_from_date              VARCHAR2,   
      p_to_date                VARCHAR2
      )
      RETURN get_make_details_tab PIPELINED;

END;
/


