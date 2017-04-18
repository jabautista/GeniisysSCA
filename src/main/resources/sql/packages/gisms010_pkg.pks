CREATE OR REPLACE PACKAGE CPI.gisms010_pkg
AS
   TYPE rec_type IS RECORD (
      keyword           gism_user_route.keyword%TYPE,
      remarks           gism_user_route.remarks%TYPE,
      validate_pin      gism_user_route.validate_pin%TYPE,
      pin_sw            gism_user_route.pin_sw%TYPE,
      restrict_number   gism_user_route.restrict_number%TYPE,
      number_sw         gism_user_route.number_sw%TYPE,
      valid_sw          gism_user_route.valid_sw%TYPE,
      user_id           gism_user_route.user_id%TYPE,
      last_update       VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_keyword           gism_user_route.keyword%TYPE,
      p_remarks           gism_user_route.remarks%TYPE,
      p_validate_pin      gism_user_route.validate_pin%TYPE,
      p_restrict_number   gism_user_route.restrict_number%TYPE,
      p_valid_sw          gism_user_route.valid_sw%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec gism_user_route%ROWTYPE);
END;
/


