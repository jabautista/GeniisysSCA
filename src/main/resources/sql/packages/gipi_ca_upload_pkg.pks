CREATE OR REPLACE PACKAGE CPI.gipi_ca_upload_pkg
AS
   FUNCTION validate_ca_upload (p_filename gipi_ca_upload.filename%TYPE)
      RETURN VARCHAR2;

   PROCEDURE set_gipi_ca_upload (
      p_upload_no   gipi_ca_upload.upload_no%TYPE,
      p_filename    gipi_ca_upload.filename%TYPE,
      p_user_id     gipi_ca_upload.user_id%TYPE
   );

   PROCEDURE set_gipi_ca_upload_error (
      p_upload_no                gipi_ca_error_log.upload_no%TYPE,
      p_filename                 gipi_ca_error_log.filename%TYPE,
      p_user_id                  gipi_ca_error_log.user_id%TYPE,
      p_item_no                  gipi_ca_error_log.item_no%TYPE,
      p_item_title               gipi_ca_error_log.item_title%TYPE,
      p_currency_cd              gipi_ca_error_log.currency_cd%TYPE,
      p_currency_rt              gipi_ca_error_log.currency_rt%TYPE,
      p_item_desc                gipi_ca_error_log.item_desc%TYPE,
      p_item_desc2               gipi_ca_error_log.item_desc2%TYPE,
      p_location_cd              gipi_ca_error_log.location_cd%TYPE,
      p_region_cd                gipi_ca_error_log.region_cd%TYPE,
      p_location                 gipi_ca_error_log.LOCATION%TYPE,
      p_limit_of_liability       gipi_ca_error_log.limit_of_liability%TYPE,
      p_interest_on_premises     gipi_ca_error_log.interest_on_premises%TYPE,
      p_section_or_hazard_info   gipi_ca_error_log.section_or_hazard_info%TYPE,
      p_conveyance_info          gipi_ca_error_log.conveyance_info%TYPE,
      p_property_no_type         gipi_ca_error_log.property_no_type%TYPE,
      p_property_no              gipi_ca_error_log.property_no%TYPE,
      p_ded_deductible_cd        gipi_ca_error_log.ded_deductible_cd%TYPE,
      p_remarks                  gipi_ca_error_log.remarks%TYPE
   );

   TYPE gipi_ca_error_log_tab IS TABLE OF gipi_ca_error_log%ROWTYPE;

   FUNCTION get_gipi_ca_error_log_list
      RETURN gipi_ca_error_log_tab PIPELINED;
END;
/
