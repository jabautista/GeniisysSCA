CREATE OR REPLACE PACKAGE CPI.CSV_CLM_PER_COLOR_GICLR264
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
  

   TYPE get_giclr264_type IS RECORD (
      color             VARCHAR2 (70),
      basic_color       VARCHAR2 (70),
      claim_number      VARCHAR2 (50),
      policy_number     VARCHAR2 (50),
      assd_name         giis_assured.assd_name%TYPE,
      item_title        VARCHAR2 (70),
      plate_no          gicl_motor_car_dtl.plate_no%TYPE,
      loss_reserve      NUMBER,
      losses_paid       NUMBER,
      expense_reserve   NUMBER,
      expenses_paid     NUMBER
     
    
      
   );

   TYPE get_giclr264_tab IS TABLE OF get_giclr264_type;

   FUNCTION get_giclr264(
      p_color_cd         giis_mc_color.color_cd%TYPE,
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE,
      p_user_id          giis_users.user_id%TYPE,
      p_search_by        NUMBER,
      p_as_of_date       VARCHAR2,
      p_from_date        VARCHAR2,
      p_to_date          VARCHAR2
   )
      RETURN get_giclr264_tab PIPELINED;
END CSV_CLM_PER_COLOR_GICLR264;
/
