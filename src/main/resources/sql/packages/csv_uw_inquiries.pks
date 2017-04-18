CREATE OR REPLACE PACKAGE CPI.csv_uw_inquiries
AS
   /*
   * Created by : Alejandro Burgos
   * Date Created : 02.04.2016
   */
   
   TYPE gipir198_type IS RECORD (
      line              VARCHAR2 (24),
      par_number        VARCHAR2 (50),
      assured_name      giis_assured.assd_name%TYPE,
      incept_date       VARCHAR2 (50),
      expiry_date       VARCHAR2 (50),
      covernote_expiry  VARCHAR2 (50),
      tsi_amount        gixx_covernote_exp.tsi_amt%TYPE,
      premium_amount    gixx_covernote_exp.prem_amt%TYPE
   );

   TYPE gipir198_tab IS TABLE OF gipir198_type;

   FUNCTION get_gipir198 (
      p_starting_date   DATE,
      p_ending_date     DATE,
      p_user_id         giis_users.user_id%TYPE
   )
      RETURN gipir198_tab PIPELINED;

   TYPE gipir192_type IS RECORD (
      make          VARCHAR2 (50),
      company       VARCHAR2 (100),
      policy_no     VARCHAR2 (100),
      assured_name  VARCHAR2 (500),
      incept_date   DATE,
      expiry_date   DATE,
      item_title    VARCHAR2 (50),
      plate_no      VARCHAR2 (10),
      engine_no     VARCHAR2 (20),
      serial_no     VARCHAR2 (25),
      tsi_amount    NUMBER (16, 2),
      prem_amount   NUMBER (16, 2)
   );

   TYPE gipir192_tab IS TABLE OF gipir192_type;

   FUNCTION get_gipir192 (
       p_make_cd               VARCHAR2,
       p_company_cd            VARCHAR2,
       p_search_by             VARCHAR2,
       p_as_of_date            VARCHAR2,
       p_from_date             VARCHAR2,
       p_to_date               VARCHAR2,
       p_user_id               VARCHAR2,
       p_cred_branch           VARCHAR2
   )
      RETURN gipir192_tab PIPELINED;  
 
   --Carlo Rubenecia SR-5325 06/21/2016 -START   
   TYPE report_type IS RECORD (
      plate_no      gipi_vehicle.plate_no%TYPE,
      policy_no     VARCHAR2 (100),
      assd_name     giis_assured.assd_name%TYPE,
      incept_date   gipi_polbasic.incept_date%TYPE,
      expiry_date   gipi_polbasic.expiry_date%TYPE,
      item          VARCHAR2 (60),
      make          gipi_vehicle.make%TYPE,
      motor_no      gipi_vehicle.motor_no%TYPE,
      serial_no     gipi_vehicle.serial_no%TYPE,
      tsi_amt       VARCHAR2(50),
      prem_amt      VARCHAR2(50)
   );

   TYPE report_tab IS TABLE OF report_type;
   
   FUNCTION get_gipir193 (
        p_plate_no      GIPI_VEHICLE.PLATE_NO%type,
        p_cred_branch   GIPI_POLBASIC.CRED_BRANCH%type,
        p_date_type     VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_user_id       VARCHAR2    
   )
      RETURN report_tab PIPELINED;   
   --Carlo Rubenecia SR-5325 06/21/2016 -END
      
	 --Added by Carlo Rubenecia SR-5326 06.22.2016 --START
   TYPE gipir194_type IS RECORD (
      motor_type    VARCHAR2 (25),
      subline_cd    gipi_vehicle.subline_cd%TYPE,
      policy_no     VARCHAR2 (50),
      assd_name     giis_assured.assd_name%TYPE,
      incept_date   VARCHAR2(50),
      expiry_date   VARCHAR2(50),
      item_title    gipi_item.item_title%TYPE,
      plate_no      gipi_vehicle.plate_no%TYPE,
      motor_no      gipi_vehicle.motor_no%TYPE,
      serial_no     gipi_vehicle.motor_no%TYPE,
      tsi_amt       VARCHAR2(50),
      prem_amt      VARCHAR2(50)
   );

   TYPE gipir194_tab IS TABLE OF gipir194_type;

   FUNCTION get_gipir194 (
      p_mot_type     gipi_vehicle.mot_type%TYPE,
      p_subline_cd   gipi_vehicle.subline_cd%TYPE,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_date_type    VARCHAR2,
      p_user_id      giis_users.user_id%TYPE
   )
      RETURN gipir194_tab PIPELINED;     
   --Added by Carlo Rubenecia SR-5326 06.22.2016 --END
   
	  --Added by Carlo Rubenecia SR-5328 06.22.2016  -- START
   TYPE gipir206_type IS RECORD (
      policy_no      VARCHAR2 (100),
      assured        VARCHAR2 (500),
      incept_date    VARCHAR2 (25),
      plate_no       gipi_vehicle.plate_no%TYPE,
      serial_no      gipi_vehicle.serial_no%TYPE,
      company_make   VARCHAR2 (150),
      ctpl_premium   VARCHAR2(50)
   );

   TYPE gipir206_tab IS TABLE OF gipir206_type;   

   FUNCTION get_gipir206 (
      p_cred_branch        GIPI_POLBASIC.cred_branch%TYPE,
      p_as_of_date         VARCHAR2,
      p_from_date          VARCHAR2,
      p_to_date            VARCHAR2,
      p_plate_ending       VARCHAR2,
      p_date_basis         VARCHAR2,
      p_date_range         VARCHAR2,
      p_reinsurance        VARCHAR2,
      p_module_id          GIIS_MODULES.module_id%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
      RETURN gipir206_tab PIPELINED;     
   --Added by Carlo Rubenecia SR 5328 06.22.2016  -- END 
END;
/
