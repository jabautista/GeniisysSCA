CREATE OR REPLACE PACKAGE CPI.giiss080_pkg
AS
   TYPE geog_class_type IS RECORD (
      geog_cd           giis_geog_class.geog_cd%TYPE,
      geog_desc         giis_geog_class.geog_desc%TYPE,
      class_type        giis_geog_class.class_type%TYPE,
      mean_class_type   VARCHAR2 (8),
      remarks           giis_geog_class.remarks%TYPE,
      user_id           giis_geog_class.user_id%TYPE,
      last_update       VARCHAR2 (200)
   );

   TYPE geog_class_tab IS TABLE OF geog_class_type;

   FUNCTION show_geog_class
      RETURN geog_class_tab PIPELINED;

   FUNCTION validate_geog_cd_input (p_input_string VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION validate_geog_desc_input (p_input_string VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION validate_before_delete (p_geog_cd VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE set_geog_class (
      p_geog_cd      giis_geog_class.geog_cd%TYPE,
      p_geog_desc    giis_geog_class.geog_desc%TYPE,
      p_class_type   giis_geog_class.class_type%TYPE,
      p_remarks      giis_geog_class.remarks%TYPE
   );

   PROCEDURE delete_in_geog_class (p_geog_cd giis_geog_class.geog_cd%TYPE);
END;
/


