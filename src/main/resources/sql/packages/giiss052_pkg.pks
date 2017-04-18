CREATE OR REPLACE PACKAGE CPI.giiss052_pkg
AS
   TYPE typhoon_zone_type IS RECORD (
      typhoon_zone        giis_typhoon_zone.typhoon_zone%TYPE,
      typhoon_zone_desc   giis_typhoon_zone.typhoon_zone_desc%TYPE,
      user_id             giis_typhoon_zone.user_id%TYPE,
      last_update         VARCHAR2 (200),
      remarks             giis_typhoon_zone.remarks%TYPE,
      zone_grp            giis_typhoon_zone.zone_grp%TYPE,
      zone_grp_desc       cg_ref_codes.rv_meaning%TYPE
   );

   TYPE typhoon_zone_tab IS TABLE OF typhoon_zone_type;

   TYPE zone_group_lov_type IS RECORD (
      zone_grp        cg_ref_codes.rv_low_value%TYPE,
      zone_grp_desc   cg_ref_codes.rv_meaning%TYPE
   );

   TYPE zone_group_lov_tab IS TABLE OF zone_group_lov_type;

   FUNCTION show_typhoon_zone
      RETURN typhoon_zone_tab PIPELINED;

   FUNCTION validate_typhoon_zone_input (
      p_txt_field      VARCHAR2,
      p_input_string   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION validate_delete_typhoon_zone (p_typhoon_zone VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION show_zone_group_lov
      RETURN zone_group_lov_tab PIPELINED;

   PROCEDURE set_typhoon_zone (
      p_typhoon_zone        giis_typhoon_zone.typhoon_zone%TYPE,
      p_zone_grp            giis_typhoon_zone.zone_grp%TYPE,
      p_typhoon_zone_desc   giis_typhoon_zone.typhoon_zone_desc%TYPE,
      p_remarks             giis_typhoon_zone.remarks%TYPE
   );

   PROCEDURE delete_in_typhoon_zone (
      p_typhoon_zone   giis_typhoon_zone.typhoon_zone%TYPE
   );
END;
/


