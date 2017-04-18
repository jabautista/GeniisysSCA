CREATE OR REPLACE PACKAGE CPI.GIPIR206_PKG
AS

   TYPE gipir206_type IS RECORD(
      company_name            GIIS_PARAMETERS.param_value_v%TYPE,
      company_address         GIIS_PARAMETERS.param_value_v%TYPE,
      coverage                VARCHAR2(150),
      policy_id               GIPI_POLBASIC.policy_id%TYPE,
      policy_no               VARCHAR2(25),
      assd_name               GIIS_ASSURED.assd_name%TYPE,
      item_no                 GIPI_VEHICLE.item_no%TYPE,
      incept_date             VARCHAR2(25),
      plate_no                GIPI_VEHICLE.plate_no%TYPE,
      serial_no               GIPI_VEHICLE.serial_no%TYPE,
      co_make                 VARCHAR2(150),
      ctpl                    GIPI_ITMPERIL.prem_amt%TYPE
   );
   TYPE gipir206_tab IS TABLE OF gipir206_type;

   FUNCTION get_gipir206_details(
      p_as_of_date            VARCHAR2,
      p_from_date             VARCHAR2,
      p_to_date               VARCHAR2,
      p_plate_ending          VARCHAR2,
      p_plate                 VARCHAR2,
      p_range                 VARCHAR2,
      p_reinsurance           VARCHAR2,
      p_date_basis            VARCHAR2,
      p_module_id             GIIS_MODULES.module_id%TYPE,
      p_user_id               GIIS_USERS.user_id%TYPE,
      p_cred_branch           GIPI_POLBASIC.cred_branch%TYPE --SR 5328 06.22.2016
   )
     RETURN gipir206_tab PIPELINED;
     
   FUNCTION get_gipir206_incept_date(
      p_policy_id             GIPI_POLBASIC.policy_id%TYPE
   )
     RETURN VARCHAR2;

END GIPIR206_PKG;
/


