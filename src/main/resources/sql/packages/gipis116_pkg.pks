CREATE OR REPLACE PACKAGE CPI.GIPIS116_PKG
AS
   TYPE motor_car_inquiry_type IS RECORD (
      plate_no            gipi_vehicle.plate_no%TYPE,
      assignee            gipi_vehicle.assignee%TYPE,
      model_year          gipi_vehicle.model_year%TYPE,
      make                gipi_vehicle.make%TYPE,
      mot_type            gipi_vehicle.mot_type%TYPE,
      repair_lim          gipi_vehicle.repair_lim%TYPE,
      color               gipi_vehicle.color%TYPE,
      coc_seq_no          gipi_vehicle.coc_seq_no%TYPE,
      serial_no           gipi_vehicle.serial_no%TYPE,
      motor_no            gipi_vehicle.motor_no%TYPE,
      policy_id           gipi_vehicle.policy_id%TYPE,
      item_no             gipi_vehicle.item_no%TYPE,
      subline_cd          gipi_vehicle.subline_cd%TYPE,
      subline_type_cd     gipi_vehicle.subline_type_cd%TYPE,
      acquired_from       gipi_vehicle.acquired_from%TYPE,
      series_cd           gipi_vehicle.series_cd%TYPE,
      type_of_body_cd     gipi_vehicle.type_of_body_cd%TYPE,
      basic_color_cd      gipi_vehicle.basic_color_cd%TYPE,
      mv_file_no          gipi_vehicle.mv_file_no%TYPE,
      coc_serial_no       gipi_vehicle.coc_serial_no%TYPE,
      coc_yy              gipi_vehicle.coc_yy%TYPE,
      car_company_cd      gipi_vehicle.car_company_cd%TYPE,
      no_of_pass          gipi_vehicle.no_of_pass%TYPE,
      dsp_engine_series   giis_mc_eng_series.engine_series%TYPE,
      dsp_type_of_body    giis_type_of_body.type_of_body%TYPE,
      dsp_subline_type    giis_mc_subline_type.subline_type_desc%TYPE,
      dsp_mot_type_desc   giis_motortype.motor_type_desc%TYPE,
      dsp_basic_color     giis_mc_color.basic_color%TYPE,
      dsp_car_company     giis_mc_car_company.car_company%TYPE,
      nbt_incept_date     gipi_polbasic.incept_date%TYPE,
      nbt_eff_date        gipi_polbasic.eff_date%TYPE,
      nbt_issue_date      gipi_polbasic.issue_date%TYPE,
      item_title          gipi_item.item_title%TYPE,
      from_date           gipi_item.from_date%TYPE,
      TO_DATE             gipi_item.TO_DATE%TYPE,
      ann_prem_amt        gipi_item.ann_prem_amt%TYPE,
      ann_tsi_amt         gipi_item.ann_tsi_amt%TYPE,
      policy_no           VARCHAR2 (60),
      endt_no             VARCHAR2 (60),
      assured             giis_assured.assd_name%TYPE,
      paid_tag            VARCHAR2 (1),
      claim_tag           VARCHAR2 (1),
      cred_branch         VARCHAR2 (2) 
   );

   TYPE motor_car_inquiry_tab IS TABLE OF motor_car_inquiry_type;

   FUNCTION get_motor_car_inquiry_records (
      p_cred_branch   gipi_polbasic.cred_branch%TYPE,
      p_search_by     NUMBER,
      p_as_of_date    VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_user_id       VARCHAR2,
      p_policy_id     VARCHAR2, -- Added by Apollo Cruz 7.14.2014
      p_item_no       VARCHAR2  -- will be used when called in GIPIS100
   )
      RETURN motor_car_inquiry_tab PIPELINED;
END GIPIS116_PKG;
/


