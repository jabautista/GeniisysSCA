CREATE OR REPLACE PACKAGE CPI.GIPIR194_PKG
AS
   /* 
   * Created by : Bonok
   * Date Created : 10.11.2013
   * Reference By : GIPIR194
   */ 
   
   TYPE gipir194_type IS RECORD(
      item_title           gipi_item.item_title%TYPE,
      plate_no             gipi_vehicle.plate_no%TYPE,
      motor_no             gipi_vehicle.motor_no%TYPE,
      serial_no            gipi_vehicle.motor_no%TYPE,
      assd_no              gipi_polbasic.assd_no%TYPE,
      tsi_amt              gipi_polbasic.tsi_amt%TYPE,
      prem_amt             gipi_polbasic.prem_amt%TYPE,
      policy_id            gipi_polbasic.policy_id%TYPE,
      mot_type             gipi_vehicle.mot_type%TYPE,
      subline_cd           gipi_vehicle.subline_cd%TYPE,
      policy_no            VARCHAR2(50),
      incept_date          gipi_polbasic.incept_date%TYPE,
      expiry_date          gipi_polbasic.expiry_date%TYPE,
      motor_type           VARCHAR2(25),
      assd_name            giis_assured.assd_name%TYPE,
      company_name         giis_parameters.param_value_v%TYPE,
      company_address      giis_parameters.param_value_v%TYPE
   );

   TYPE gipir194_tab IS TABLE OF gipir194_type;
   
   FUNCTION get_gipir194_details(
      p_mot_type     gipi_vehicle.mot_type%TYPE,
      p_subline_cd   gipi_vehicle.subline_cd%TYPE,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_date_type    VARCHAR2,
      p_user_id      giis_users.user_id%TYPE
   ) RETURN gipir194_tab PIPELINED;
END;
/


