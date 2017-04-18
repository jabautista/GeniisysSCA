CREATE OR REPLACE PACKAGE CPI.CSV_CLM_PER_MC_RPL_GICLR275
AS
    /*
    **  Created by        : carlo de guzman SR 5409
    */
   TYPE GICLR275_details_type IS RECORD (
      car_company       VARCHAR2(100),
      make              VARCHAR2(100),
      model_year        gicl_motor_car_dtl.model_year%TYPE,
      parts             VARCHAR2(100),
      claim_number      VARCHAR2 (30),
      policy_number     VARCHAR2 (30),
      assured           giis_assured.assd_name%TYPE,
      loss_date         VARCHAR2(10),
      file_date         VARCHAR2(10),
      claim_status      giis_clm_stat.clm_stat_desc%TYPE,
      item              gicl_clm_loss_exp.item_no%TYPE,
      peril             giis_peril.peril_name%TYPE,
      payee             VARCHAR2(500),
      hist_no           gicl_clm_loss_exp.hist_seq_no%TYPE,
      status            gicl_le_stat.le_stat_desc%TYPE,
      amount            VARCHAR2 (50),
      user_id           gicl_loss_exp_dtl.user_id%TYPE,
      last_update       VARCHAR2(10)
      
   );

   TYPE GICLR275_details_tab IS TABLE OF GICLR275_details_type;

 FUNCTION csv_giclr275 (
      P_FROM_DATE       VARCHAR2,
      P_TO_DATE         VARCHAR2,
      P_AS_OF_DATE      VARCHAR2,
      P_FROM_LDATE      VARCHAR2,
      P_TO_LDATE        VARCHAR2,
      P_AS_OF_LDATE     VARCHAR2,
      P_MOTCAR_COMP_CD  gicl_motor_car_dtl.motcar_comp_cd%TYPE,
      P_MAKE_CD         gicl_motor_car_dtl.make_cd%TYPE,
      P_MODEL_YEAR      gicl_motor_car_dtl.model_year%TYPE,
      P_LOSS_EXP_CD     VARCHAR2,
      P_USER_ID         VARCHAR2
    )
      RETURN GICLR275_details_tab PIPELINED;
   
END CSV_CLM_PER_MC_RPL_GICLR275;
/
