CREATE OR REPLACE PACKAGE BODY CPI.gipi_ca_upload_pkg
AS
   FUNCTION validate_ca_upload (p_filename gipi_ca_upload.filename%TYPE)
      RETURN VARCHAR2
   IS
      v_exist   BOOLEAN         := FALSE;
      v_msg     VARCHAR2 (4000) := '';
   BEGIN
      FOR a IN (SELECT 1
                  FROM gipi_ca_upload
                 WHERE filename LIKE p_filename)
      LOOP
         v_exist := TRUE;
      END LOOP;

      IF v_exist
      THEN
         v_msg := 'This file has already been uploaded';
      END IF;

      RETURN v_msg;
   END;

   PROCEDURE set_gipi_ca_upload (
      p_upload_no   gipi_ca_upload.upload_no%TYPE,
      p_filename    gipi_ca_upload.filename%TYPE,
      p_user_id     gipi_ca_upload.user_id%TYPE
   )
   IS
   BEGIN
      MERGE INTO gipi_ca_upload
         USING DUAL
         ON (upload_no = p_upload_no AND p_filename = p_filename)
         WHEN NOT MATCHED THEN
            INSERT (upload_no, filename, upload_date, user_id, last_update)
            VALUES (p_upload_no, p_filename, SYSDATE, p_user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET upload_date = SYSDATE, user_id = NVL (p_user_id, USER),
                   last_update = SYSDATE
            ;
   END set_gipi_ca_upload;

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
   )
   IS
   BEGIN
      INSERT INTO gipi_ca_error_log
                  (upload_no, filename, user_id, item_no,
                   item_title, currency_cd, currency_rt, item_desc,
                   item_desc2, location_cd, region_cd, LOCATION,
                   limit_of_liability, interest_on_premises,
                   section_or_hazard_info, conveyance_info,
                   property_no_type, property_no, ded_deductible_cd,
                   date_uploaded, remarks
                  )
           VALUES (p_upload_no, p_filename, p_user_id, p_item_no,
                   p_item_title, p_currency_cd, p_currency_rt, p_item_desc,
                   p_item_desc2, p_location_cd, p_region_cd, p_location,
                   p_limit_of_liability, p_interest_on_premises,
                   p_section_or_hazard_info, p_conveyance_info,
                   p_property_no_type, p_property_no, p_ded_deductible_cd,
                   SYSDATE, p_remarks
                  );
   END set_gipi_ca_upload_error;

   FUNCTION get_gipi_ca_error_log_list
      RETURN gipi_ca_error_log_tab PIPELINED
   IS
      v_ca_error_log   gipi_ca_error_log%ROWTYPE;
   BEGIN
      FOR a IN (SELECT upload_no, filename, item_no, item_title, LOCATION,
                       user_id, date_uploaded, remarks
                  FROM gipi_ca_error_log
              ORDER BY upload_no DESC)
      LOOP
         v_ca_error_log.upload_no := a.upload_no;
         v_ca_error_log.filename := a.filename;
         v_ca_error_log.item_no := a.item_no;
         v_ca_error_log.item_title := a.item_title;
         v_ca_error_log.LOCATION := a.LOCATION;
         v_ca_error_log.user_id := a.user_id;
         v_ca_error_log.date_uploaded := a.date_uploaded;
         v_ca_error_log.remarks := a.remarks;
         PIPE ROW (v_ca_error_log);
      END LOOP;

      RETURN;
   END;
END gipi_ca_upload_pkg;
/
