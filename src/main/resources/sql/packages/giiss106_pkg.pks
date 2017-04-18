CREATE OR REPLACE PACKAGE CPI.giiss106_pkg
AS
   TYPE line_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_tab IS TABLE OF line_type;

   FUNCTION get_line_lov (p_user_id VARCHAR2)
      RETURN line_tab PIPELINED;

   TYPE motortype_type IS RECORD (
      type_cd           giis_motortype.type_cd%TYPE,
      motor_type_desc   giis_motortype.motor_type_desc%TYPE
   );

   TYPE motortype_tab IS TABLE OF motortype_type;

   FUNCTION get_motortype_lov (p_subline_cd VARCHAR2)
      RETURN motortype_tab PIPELINED;

   TYPE tariff_hdr_type IS RECORD (
      tariff_cd            giis_tariff_rates_hdr.tariff_cd%TYPE,
      line_cd              giis_tariff_rates_hdr.line_cd%TYPE,
      line_name            giis_line.line_name%TYPE,
      subline_cd           giis_tariff_rates_hdr.subline_cd%TYPE,
      subline_name         giis_subline.subline_name%TYPE,
      peril_cd             giis_tariff_rates_hdr.peril_cd%TYPE,
      peril_name           giis_peril.peril_name%TYPE,
      subline_type_cd      giis_tariff_rates_hdr.subline_type_cd%TYPE,
      subline_type_desc    giis_mc_subline_type.subline_type_desc%TYPE,
      motortype_cd         giis_tariff_rates_hdr.motortype_cd%TYPE,
      motor_type_desc      giis_motortype.motor_type_desc%TYPE,
      construction_cd      giis_tariff_rates_hdr.construction_cd%TYPE,
      construction_desc    giis_fire_construction.construction_desc%TYPE,
      tariff_zone          giis_tariff_rates_hdr.tariff_zone%TYPE,
      tariff_zone_desc     giis_tariff_zone.tariff_zone_desc%TYPE,
      coverage_cd          giis_tariff_rates_hdr.coverage_cd%TYPE,
      coverage_desc        giis_coverage.coverage_desc%TYPE,
      tarf_cd              giis_tariff_rates_hdr.tarf_cd%TYPE,
      tarf_desc            giis_tariff.tarf_desc%TYPE,
      default_prem_tag     giis_tariff_rates_hdr.default_prem_tag%TYPE,
      remarks              giis_tariff_rates_hdr.remarks%TYPE,
      user_id              giis_tariff_rates_hdr.user_id%TYPE,
      last_update          VARCHAR2 (30),
      rec_exist            VARCHAR2 (1),
      tariff_dtl_cd        giis_tariff_rates_dtl.tariff_dtl_cd%TYPE,
      si_deductible        giis_tariff_rates_dtl.si_deductible%TYPE,
      fixed_premium        giis_tariff_rates_dtl.fixed_premium%TYPE,
      excess_rate          giis_tariff_rates_dtl.excess_rate%TYPE,
      loading_rate         giis_tariff_rates_dtl.loading_rate%TYPE,
      discount_rate        giis_tariff_rates_dtl.discount_rate%TYPE,
      additional_premium   giis_tariff_rates_dtl.additional_premium%TYPE,
      tariff_rate          giis_tariff_rates_dtl.tariff_rate%TYPE,
      remarks_2            giis_tariff_rates_dtl.remarks%TYPE,
      user_id_2            giis_tariff_rates_dtl.user_id%TYPE,
      last_update_2        VARCHAR2 (30)
   );

   TYPE tariff_hdr_tab IS TABLE OF tariff_hdr_type;

   FUNCTION get_tariff_hdr_list (p_module_id VARCHAR2, p_user_id VARCHAR2)
      RETURN tariff_hdr_tab PIPELINED;

   PROCEDURE val_add_rec_hdr (
      p_line_cd           giis_tariff_rates_hdr.line_cd%TYPE,
      p_subline_cd        giis_tariff_rates_hdr.subline_cd%TYPE,
      p_peril_cd          giis_tariff_rates_hdr.peril_cd%TYPE,
      p_tariff_zone       giis_tariff_rates_hdr.tariff_zone%TYPE,
      p_coverage_cd       giis_tariff_rates_hdr.coverage_cd%TYPE,
      p_subline_type_cd   giis_tariff_rates_hdr.subline_type_cd%TYPE,
      p_motortype_cd      giis_tariff_rates_hdr.motortype_cd%TYPE,
      p_tarf_cd           giis_tariff_rates_hdr.tarf_cd%TYPE,
      p_construction_cd   giis_tariff_rates_hdr.construction_cd%TYPE
   );

   PROCEDURE val_del_rec_hdr (
      p_tariff_cd   giis_tariff_rates_hdr.tariff_cd%TYPE
   );

   PROCEDURE set_rec_hdr (
      p_tariff_cd            IN OUT   giis_tariff_rates_hdr.tariff_cd%TYPE,
      p_line_cd              IN       giis_tariff_rates_hdr.line_cd%TYPE,
      p_subline_cd           IN       giis_tariff_rates_hdr.subline_cd%TYPE,
      p_peril_cd             IN       giis_tariff_rates_hdr.peril_cd%TYPE,
      p_tariff_zone          IN       giis_tariff_rates_hdr.tariff_zone%TYPE,
      p_coverage_cd          IN       giis_tariff_rates_hdr.coverage_cd%TYPE,
      p_subline_type_cd      IN       giis_tariff_rates_hdr.subline_type_cd%TYPE,
      p_motortype_cd         IN       giis_tariff_rates_hdr.motortype_cd%TYPE,
      p_tarf_cd              IN       giis_tariff_rates_hdr.tarf_cd%TYPE,
      p_construction_cd      IN       giis_tariff_rates_hdr.construction_cd%TYPE,
      p_default_prem_tag     IN       giis_tariff_rates_hdr.default_prem_tag%TYPE,
      p_remarks              IN       giis_tariff_rates_hdr.remarks%TYPE,
      p_user_id              IN       giis_tariff_rates_hdr.user_id%TYPE,
      p_remarks2             IN       giis_tariff_rates_dtl.remarks%TYPE,
      p_fixed_premium        IN       giis_tariff_rates_dtl.fixed_premium%TYPE,
      p_si_deductible        IN       giis_tariff_rates_dtl.si_deductible%TYPE,
      p_excess_rate          IN       giis_tariff_rates_dtl.excess_rate%TYPE,
      p_loading_rate         IN       giis_tariff_rates_dtl.loading_rate%TYPE,
      p_discount_rate        IN       giis_tariff_rates_dtl.discount_rate%TYPE,
      p_tariff_rate          IN       giis_tariff_rates_dtl.tariff_rate%TYPE,
      p_additional_premium   IN       giis_tariff_rates_dtl.additional_premium%TYPE,
      p_tariff_dtl_cd        IN OUT   giis_tariff_rates_dtl.tariff_dtl_cd%TYPE
   );

   PROCEDURE del_rec_hdr (p_tariff_cd giis_tariff_rates_hdr.tariff_cd%TYPE);

   TYPE tariff_fixed_si_type IS RECORD (
      tariff_cd       giis_tariff_rates_dtl.tariff_cd%TYPE,
      tariff_dtl_cd   giis_tariff_rates_dtl.tariff_dtl_cd%TYPE,
      fixed_si        giis_tariff_rates_dtl.fixed_si%TYPE,
      fixed_premium   giis_tariff_rates_dtl.fixed_premium%TYPE,
      higher_range    giis_tariff_rates_dtl.higher_range%TYPE,
      lower_range     giis_tariff_rates_dtl.lower_range%TYPE,
      remarks         giis_tariff_rates_dtl.remarks%TYPE,
      user_id         giis_tariff_rates_dtl.user_id%TYPE,
      last_update     VARCHAR2 (30)
   );

   TYPE tariff_fixed_si_tab IS TABLE OF tariff_fixed_si_type;

   FUNCTION get_fixed_si_list (
      p_tariff_cd   giis_tariff_rates_hdr.tariff_cd%TYPE
   )
      RETURN tariff_fixed_si_tab PIPELINED;

   PROCEDURE val_add_fixed_si_rec (
      p_tariff_cd       giis_tariff_rates_dtl.tariff_cd%TYPE,
      p_tariff_dtl_cd   giis_tariff_rates_dtl.tariff_dtl_cd%TYPE,
      p_fixed_si        giis_tariff_rates_dtl.fixed_si%TYPE
   );

   TYPE tariff_with_comp_type IS RECORD (
      tariff_cd            giis_tariff_rates_dtl.tariff_cd%TYPE,
      tariff_dtl_cd        giis_tariff_rates_dtl.tariff_dtl_cd%TYPE,
      fixed_premium        giis_tariff_rates_dtl.fixed_premium%TYPE,
      si_deductible        giis_tariff_rates_dtl.si_deductible%TYPE,
      excess_rate          giis_tariff_rates_dtl.excess_rate%TYPE,
      loading_rate         giis_tariff_rates_dtl.loading_rate%TYPE,
      discount_rate        giis_tariff_rates_dtl.discount_rate%TYPE,
      additional_premium   giis_tariff_rates_dtl.additional_premium%TYPE,
      tariff_rate          giis_tariff_rates_dtl.tariff_rate%TYPE,
      remarks              giis_tariff_rates_dtl.remarks%TYPE,
      user_id              giis_tariff_rates_dtl.user_id%TYPE,
      last_update          VARCHAR2 (30)
   );

   TYPE tariff_with_comp_tab IS TABLE OF tariff_with_comp_type;

   FUNCTION get_with_comp_dtl (
      p_tariff_cd   giis_tariff_rates_hdr.tariff_cd%TYPE
   )
      RETURN tariff_with_comp_tab PIPELINED;

   TYPE tariff_fixed_prem_type IS RECORD (
      tariff_cd       giis_tariff_rates_dtl.tariff_cd%TYPE,
      tariff_dtl_cd   giis_tariff_rates_dtl.tariff_dtl_cd%TYPE,
      fixed_premium   giis_tariff_rates_dtl.fixed_premium%TYPE,
      tariff_rate     giis_tariff_rates_dtl.tariff_rate%TYPE,
      remarks         giis_tariff_rates_dtl.remarks%TYPE,
      user_id         giis_tariff_rates_dtl.user_id%TYPE,
      last_update     VARCHAR2 (30)
   );

   TYPE tariff_fixed_prem_tab IS TABLE OF tariff_fixed_prem_type;

   FUNCTION get_fixed_prem_dtl (
      p_tariff_cd   giis_tariff_rates_hdr.tariff_cd%TYPE
   )
      RETURN tariff_fixed_prem_tab PIPELINED;

   PROCEDURE set_rec_dtl (p_rec giis_tariff_rates_dtl%ROWTYPE);

   PROCEDURE del_rec_dtl (
      p_tariff_cd       giis_tariff_rates_dtl.tariff_cd%TYPE,
      p_tariff_dtl_cd   giis_tariff_rates_dtl.tariff_dtl_cd%TYPE
   );

   PROCEDURE val_add_rec_dtl (
      p_tariff_cd            giis_tariff_rates_dtl.tariff_cd%TYPE,
      p_higher_range         giis_tariff_rates_dtl.higher_range%TYPE,
      p_lower_range          giis_tariff_rates_dtl.lower_range%TYPE,
      p_tariff_rate          giis_tariff_rates_dtl.tariff_rate%TYPE,
      p_additional_premium   giis_tariff_rates_dtl.additional_premium%TYPE
   );
END giiss106_pkg;
/


