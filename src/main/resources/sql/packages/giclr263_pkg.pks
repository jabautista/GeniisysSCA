CREATE OR REPLACE PACKAGE CPI.GICLR263_PKG
AS
   TYPE get_giclr263_type IS RECORD (
      make                     GIIS_MC_MAKE.MAKE%TYPE,
      car_company              GIIS_MC_CAR_COMPANY.CAR_COMPANY%TYPE,
      claim_number             VARCHAR2 (50),
      policy_number            VARCHAR2 (50),
      assured_name             GICL_CLAIMS.ASSURED_NAME%TYPE,
      loss_date                GICL_CLAIMS.LOSS_DATE%TYPE,
      clm_file_date            GICL_CLAIMS.CLM_FILE_DATE%TYPE,
      item                     VARCHAR2 (200),
      plate_no                 GICL_MOTOR_CAR_DTL.PLATE_NO%TYPE,
      cf_loss_reserve          NUMBER (16,2),
      cf_exp_reserve           NUMBER (16,2),
      cf_loss_paid             NUMBER (16,2),
      cf_exp_paid              NUMBER (16,2),
      comp_name                VARCHAR2 (200),
      comp_add                 VARCHAR2 (200),
      date_type                VARCHAR2 (500)
   );

   TYPE get_giclr263_tab IS TABLE OF get_giclr263_type;

   FUNCTION get_giclr263_details (
      p_as_of_fdate            VARCHAR2,
      p_as_of_ldate            VARCHAR2,
      p_comp                   VARCHAR2,
      p_from_fdate             VARCHAR2,
      p_from_ldate             VARCHAR2,
      p_make_cd                VARCHAR2,
      p_to_fdate               VARCHAR2,
      p_to_ldate               VARCHAR2,
      p_user_id                VARCHAR2
      )
      RETURN get_giclr263_tab PIPELINED;
      
END;
/
