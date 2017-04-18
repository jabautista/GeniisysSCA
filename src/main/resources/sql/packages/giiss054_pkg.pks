CREATE OR REPLACE PACKAGE CPI.giiss054_pkg
AS
   TYPE rec_type IS RECORD (
      tariff_zone        giis_tariff_zone.tariff_zone%TYPE,
      tariff_zone_desc   giis_tariff_zone.tariff_zone_desc%TYPE,
      line_cd            giis_tariff_zone.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_cd         giis_tariff_zone.subline_cd%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      tarf_cd            giis_tariff_zone.tarf_cd%TYPE,
      tarf_desc          giis_tariff.tarf_desc%TYPE,
      remarks            giis_tariff_zone.remarks%TYPE,
      user_id            giis_tariff_zone.user_id%TYPE,
      last_update        VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   TYPE get_line_lov_type IS RECORD (
      line_cd     giis_tariff_zone.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE get_line_lov_tab IS TABLE OF get_line_lov_type;

   TYPE get_subline_lov_type IS RECORD (
      subline_cd     giis_tariff_zone.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE get_subline_lov_tab IS TABLE OF get_subline_lov_type;

   TYPE get_tarf_lov_type IS RECORD (
      tarf_cd     giis_tariff.tarf_cd%TYPE,
      tarf_desc   giis_tariff.tarf_desc%TYPE
   );

   TYPE get_tarf_lov_tab IS TABLE OF get_tarf_lov_type;

   FUNCTION get_rec_list (
      p_tariff_zone        giis_tariff_zone.tariff_zone%TYPE,
      p_tariff_zone_desc   giis_tariff_zone.tariff_zone_desc%TYPE,
      p_line_cd            giis_tariff_zone.line_cd%TYPE,
      p_subline_cd         giis_tariff_zone.subline_cd%TYPE,
      p_user_id            VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   FUNCTION get_line_lov (p_user_id VARCHAR2)
      RETURN get_line_lov_tab PIPELINED;

   FUNCTION get_subline_lov (p_line_cd VARCHAR2)
      RETURN get_subline_lov_tab PIPELINED;

   FUNCTION get_tarf_lov
      RETURN get_tarf_lov_tab PIPELINED;

   PROCEDURE val_add_rec (p_tariff_zone giis_tariff_zone.tariff_zone%TYPE);

   PROCEDURE val_del_rec (p_tariff_zone giis_tariff_zone.tariff_zone%TYPE);

   PROCEDURE set_rec (p_rec giis_tariff_zone%ROWTYPE);

   PROCEDURE del_rec (p_tariff_zone giis_tariff_zone.tariff_zone%TYPE);

   FUNCTION check_giiss054_user_access (p_user_id VARCHAR2)
      RETURN NUMBER;
END;
/


