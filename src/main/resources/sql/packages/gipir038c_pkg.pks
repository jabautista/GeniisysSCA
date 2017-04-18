CREATE OR REPLACE PACKAGE CPI.gipir038c_pkg
AS
   TYPE report_type IS RECORD (
      company_name      giis_parameters.param_value_v%TYPE,
      company_address   giis_parameters.param_value_v%TYPE,
      cf_title          VARCHAR2 (120),
      cf_header         VARCHAR2 (100),
      eq_zone_type      cg_ref_codes.rv_meaning%TYPE,
      cf_count          NUMBER (16),
      tariff            VARCHAR2 (100),
      sum_tsi_amt       NUMBER (30, 2),
      sum_prem_amt      NUMBER (30, 2),
      print_details     VARCHAR2 (1),
      zone_type_eq      cg_ref_codes.rv_low_value%TYPE
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION populate_report (
      p_zone_type       giis_peril.zone_type%TYPE,
      p_as_of_sw        VARCHAR2,
      p_expired_as_of   VARCHAR2,
      p_period_start    VARCHAR2,
      p_period_end      VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN report_tab PIPELINED;
END gipir038c_pkg;
/


