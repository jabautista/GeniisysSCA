CREATE OR REPLACE PACKAGE CPI.CSV_CLM_PER_MAKE_GICLR263
AS
   TYPE get_giclr263_type IS RECORD (
      make                     GIIS_MC_MAKE.MAKE%TYPE,
      company                  GIIS_MC_CAR_COMPANY.CAR_COMPANY%TYPE,
      claim_number             VARCHAR2 (50),
      policy_number            VARCHAR2 (50),
      assured                  GICL_CLAIMS.ASSURED_NAME%TYPE,
      loss_date                GICL_CLAIMS.LOSS_DATE%TYPE,
      file_date                GICL_CLAIMS.CLM_FILE_DATE%TYPE,
      item                     VARCHAR2 (200),
      plate                    GICL_MOTOR_CAR_DTL.PLATE_NO%TYPE,
      loss_reserve             NUMBER (16,2),
      losses_paid              NUMBER (16,2),
      expense_reserve          NUMBER (16,2),      
      expenses_paid            NUMBER (16,2)
   );

   TYPE get_giclr263_tab IS TABLE OF get_giclr263_type;
   FUNCTION csv_giclr263(
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

