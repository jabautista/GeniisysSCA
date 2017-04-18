CREATE OR REPLACE PACKAGE CPI.giclr264_pkg
IS
   TYPE header_type IS RECORD (
      comp_name      giis_parameters.param_value_v%TYPE,
      comp_address   giis_parameters.param_value_v%TYPE,
      date_type      VARCHAR2 (100)
   );

   TYPE header_tab IS TABLE OF header_type;

   FUNCTION get_header (
      p_search_by    NUMBER,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN header_tab PIPELINED;

   TYPE details_type IS RECORD (
      claim_id          gicl_claims.claim_id%TYPE,
      color_cd          gicl_motor_car_dtl.color_cd%TYPE,
      color             VARCHAR2 (70),
      basic_color       VARCHAR2 (70),
      claim_number      VARCHAR2 (50),
      policy_number     VARCHAR2 (50),
      assd_name         giis_assured.assd_name%TYPE,
      item_title        VARCHAR2 (70),
      plate_no          gicl_motor_car_dtl.plate_no%TYPE,
      dsp_loss_date     gicl_claims.dsp_loss_date%TYPE,
      expenses_paid     NUMBER,
      expense_reserve   NUMBER,
      losses_paid       NUMBER,
      loss_reserve      NUMBER
   );

   TYPE details_tab IS TABLE OF details_type;

   FUNCTION get_details (
      p_color_cd         giis_mc_color.color_cd%TYPE,
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE,
      p_user_id          giis_users.user_id%TYPE,
      p_search_by        NUMBER,
      p_as_of_date       VARCHAR2,
      p_from_date        VARCHAR2,
      p_to_date          VARCHAR2
   )
      RETURN details_tab PIPELINED;
END giclr264_pkg;
/


