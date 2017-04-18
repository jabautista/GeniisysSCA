CREATE OR REPLACE PACKAGE CPI.giiss055_pkg
AS
   TYPE subline_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE subline_tab IS TABLE OF subline_type;

   TYPE motor_type_type IS RECORD (
      type_cd           giis_motortype.type_cd%TYPE,
      motor_type_desc   giis_motortype.motor_type_desc%TYPE,
      subline_cd        giis_motortype.subline_cd%TYPE,
      unladen_wt        giis_motortype.unladen_wt%TYPE,
      motor_type_rate   giis_motortype.motor_type_rate%TYPE,
      remarks           giis_motortype.remarks%TYPE,
      user_id           giis_motortype.user_id%TYPE,
      last_update       VARCHAR (200)
   );

   TYPE motor_type_tab IS TABLE OF motor_type_type;

   FUNCTION get_subline (p_user_id VARCHAR2)
      RETURN subline_tab PIPELINED;

   FUNCTION get_motor_type (p_subline_cd VARCHAR2)
      RETURN motor_type_tab PIPELINED;

   FUNCTION validate_giiss055_motor_type (
      p_type_cd      VARCHAR2,
      p_subline_cd   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION chk_delete_giiss055_motor_type (
      p_type_cd      VARCHAR2,
      p_subline_cd   VARCHAR2
   )
      RETURN VARCHAR2;

   PROCEDURE set_motor_type (
      p_subline_cd        giis_motortype.subline_cd%TYPE,
      p_type_cd           giis_motortype.type_cd%TYPE,
      p_motor_type_desc   giis_motortype.motor_type_desc%TYPE,
      p_unladen_wt        giis_motortype.unladen_wt%TYPE,
      p_remarks           giis_motortype.remarks%TYPE
   );

   PROCEDURE delete_in_motor_type (
      p_subline_cd   giis_motortype.subline_cd%TYPE,
      p_type_cd      giis_motortype.type_cd%TYPE
   );
END;
/


