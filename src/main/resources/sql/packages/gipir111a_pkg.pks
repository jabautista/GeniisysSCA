CREATE OR REPLACE PACKAGE CPI.gipir111a_pkg
AS
   TYPE gipir111a_type IS RECORD (
      company_name          VARCHAR2 (100),
      company_add           giac_parameters.param_value_v%TYPE,
      exist                 VARCHAR2 (1),
      location_cd           gixx_ca_accum.location_cd%TYPE,
      location_desc         VARCHAR2 (500),
      retention_limit_amt   NUMBER (20, 2),
      treaty_limit_amt      NUMBER (20, 2),
      policy_id             gixx_ca_accum_dist.policy_id%TYPE,
      policy_no             VARCHAR2 (50),
      assured               gixx_ca_accum_dist.assd_name%TYPE,
      LOCATION              gipi_casualty_item.LOCATION%TYPE,
      incept_date           VARCHAR2 (50),
      expiry_date           VARCHAR2 (50),
      tsi_amt               NUMBER (20, 2),
      ret_tsi_amt           NUMBER (20, 2),
      treaty_tsi_amt        NUMBER (20, 2),
      facul_tsi_amt         NUMBER (20, 2),
      item_no               gixx_ca_accum_dist.item_no%TYPE
   );

   TYPE gipir111a_tab IS TABLE OF gipir111a_type;

   FUNCTION populate_gipir111a (
      p_location_cd   VARCHAR2,
      p_eff_tag       VARCHAR2,
      p_expiry_tag    VARCHAR2
   )
      RETURN gipir111a_tab PIPELINED;
END gipir111a_pkg;
/


