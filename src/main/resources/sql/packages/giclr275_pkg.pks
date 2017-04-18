CREATE OR REPLACE PACKAGE CPI.GICLR275_pkg
AS
   TYPE GICLR275_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      date_type         VARCHAR2 (100)
   );

   TYPE GICLR275_tab IS TABLE OF GICLR275_type;

    FUNCTION populate_GICLR275 (
          P_FROM_DATE       VARCHAR2,
          P_TO_DATE         VARCHAR2,
          P_AS_OF_DATE      VARCHAR2,
          P_FROM_LDATE      VARCHAR2,
          P_TO_LDATE        VARCHAR2,
          P_AS_OF_LDATE     VARCHAR2
        )
      RETURN GICLR275_tab PIPELINED;

   TYPE GICLR275_details_type IS RECORD (
      motcar_comp_cd    gicl_motor_car_dtl.motcar_comp_cd%TYPE,
      make_cd           gicl_motor_car_dtl.make_cd%TYPE,
      car_company       giis_mc_car_company.car_company%TYPE,
      make              giis_mc_make.make%TYPE,
      model_year        gicl_motor_car_dtl.model_year%TYPE,
      loss_exp_cd       giis_loss_exp.loss_exp_cd%TYPE,
      loss_exp_desc     giis_loss_exp.loss_exp_desc %TYPE,
      item_no           gicl_clm_loss_exp.item_no%TYPE,
      hist_seq_no       gicl_clm_loss_exp.hist_seq_no%TYPE,
      ded_base_amt      gicl_loss_exp_dtl.ded_base_amt%TYPE,
      user_id           gicl_loss_exp_dtl.user_id%TYPE,
      claim_number      VARCHAR2 (30),
      policy_number     VARCHAR2 (30),
      class_desc        giis_payee_class.class_desc%TYPE,
      payee_last_name   giis_payees.payee_last_name%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      loss_date         gicl_claims.loss_date%TYPE,
      clm_file_date     gicl_claims.clm_file_date%TYPE,
      clm_stat_desc     giis_clm_stat.clm_stat_desc%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      last_update       gicl_loss_exp_dtl.last_update%TYPE,
      le_stat_desc      gicl_le_stat.le_stat_desc%TYPE
   );

   TYPE GICLR275_details_tab IS TABLE OF GICLR275_details_type;

 FUNCTION populate_GICLR275_details (
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
   
END GICLR275_pkg;
/


