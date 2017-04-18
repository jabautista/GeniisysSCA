CREATE OR REPLACE PACKAGE CPI.gipis194_pkg
AS
   /*
   * Created by : Bonok
   * Date Created : 10.09.2013
   * Reference By : GIPIS194 - POLICY LISTING PER MOTOR TYPE
   */
   TYPE motor_type_type IS RECORD (
      motor_type_desc   giis_motortype.motor_type_desc%TYPE,
      subline_cd        gipi_vehicle.subline_cd%TYPE,
      mot_type          gipi_vehicle.mot_type%TYPE
   );

   TYPE motor_type_tab IS TABLE OF motor_type_type;

   FUNCTION get_motor_type_lov
      RETURN motor_type_tab PIPELINED;

   TYPE subline_cd_type IS RECORD (
      subline_cd   gipi_vehicle.subline_cd%TYPE
   );

   TYPE subline_cd_tab IS TABLE OF subline_cd_type;

   FUNCTION get_subline_cd_lov (
      p_nbt_motor_desc   giis_motortype.motor_type_desc%TYPE,
      p_keyword          VARCHAR2
   )
      RETURN subline_cd_tab PIPELINED;

   TYPE motor_type_list_type IS RECORD (
      item_no       gipi_item.item_no%TYPE,
      item_title    gipi_item.item_title%TYPE,
      plate_no      gipi_vehicle.plate_no%TYPE,
      motor_no      gipi_vehicle.motor_no%TYPE,
      serial_no     gipi_vehicle.serial_no%TYPE,
      tsi_amt       gipi_item.tsi_amt%TYPE,
      prem_amt      gipi_item.prem_amt%TYPE,
      policy_no     VARCHAR2 (50),
      assured       giis_assured.assd_name%TYPE,
      eff_date      gipi_polbasic.eff_date%TYPE,
      incept_date   gipi_polbasic.incept_date%TYPE,
      issue_date    gipi_polbasic.issue_date%TYPE,
      expiry_date   gipi_polbasic.expiry_date%TYPE,
      cred_branch   gipi_polbasic.cred_branch%TYPE,
      line_cd       gipi_polbasic.line_cd%TYPE,
      iss_cd        gipi_polbasic.iss_cd%TYPE
   );

   TYPE motor_type_list_tab IS TABLE OF motor_type_list_type;

   FUNCTION get_motor_type_list (
      p_mot_type     gipi_vehicle.mot_type%TYPE,
      p_subline_cd   gipi_vehicle.subline_cd%TYPE,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_date_type    VARCHAR2
   )
      RETURN motor_type_list_tab PIPELINED;
END;
/


