CREATE OR REPLACE PACKAGE CPI.GIPIR929A_MX_PKG
AS
   TYPE get_report_data_type IS RECORD (
      ri_cd                gipi_uwreports_inw_ri_ext.ri_cd%TYPE,
      ri_name              gipi_uwreports_inw_ri_ext.ri_name%TYPE,
      line_cd              gipi_uwreports_inw_ri_ext.line_cd%TYPE,
      line_name            gipi_uwreports_inw_ri_ext.line_name%TYPE,
      subline_cd           gipi_uwreports_inw_ri_ext.subline_cd%TYPE,
      subline_name         gipi_uwreports_inw_ri_ext.subline_name%TYPE,
      iss_cd               gipi_uwreports_inw_ri_ext.cred_branch%TYPE,
      total_tsi            gipi_uwreports_inw_ri_ext.total_tsi%TYPE,
      total_prem           gipi_uwreports_inw_ri_ext.total_prem%TYPE,
      param_date           gipi_uwreports_inw_ri_ext.param_date%TYPE,
      from_date            gipi_uwreports_inw_ri_ext.from_date%TYPE,
      TO_DATE              gipi_uwreports_inw_ri_ext.TO_DATE%TYPE,
      SCOPE                gipi_uwreports_inw_ri_ext.SCOPE%TYPE,
      user_id              gipi_uwreports_inw_ri_ext.user_id%TYPE,
      total                NUMBER,
      polcount             NUMBER,
      commission           gipi_uwreports_inw_ri_ext.ri_comm_amt%TYPE,
      ri_comm_vat          gipi_uwreports_inw_ri_ext.ri_comm_vat%TYPE,
      policy_label         VARCHAR2 (100),
      from_dt              gipi_uwreports_dist_peril_ext.from_date1%TYPE,
      to_dt                gipi_uwreports_dist_peril_ext.to_date1%TYPE,
      cf_company_name      VARCHAR2 (150),
      cf_company_address   VARCHAR2 (500),
      cf_heading3          VARCHAR2 (150),
      cf_based_on          VARCHAR2 (100),
      cf_iss_name          giis_issource.iss_name%TYPE,
      cf_iss_header        VARCHAR2 (100)
   );

   TYPE get_report_data_tab IS TABLE OF get_report_data_type;

   TYPE get_taxes_type IS RECORD (
      ri_cd                gipi_uwreports_inw_ri_ext.ri_cd%TYPE,
      line_cd              gipi_uwreports_inw_ri_ext.line_cd%TYPE,
      subline_cd           gipi_uwreports_inw_ri_ext.subline_cd%TYPE,
      iss_cd               gipi_uwreports_inw_ri_ext.cred_branch%TYPE,
      tax_amt              NUMBER (12, 2),
      tax_cd               giis_tax_charges.tax_cd%TYPE,
      tax_name             giis_tax_charges.tax_desc%TYPE,
      ri_name              gipi_uwreports_inw_ri_ext.ri_name%TYPE,
      line_name            gipi_uwreports_inw_ri_ext.line_name%TYPE,
      subline_name         gipi_uwreports_inw_ri_ext.subline_name%TYPE,
      total                NUMBER,
      commission           gipi_uwreports_inw_ri_ext.ri_comm_amt%TYPE,
      ri_comm_vat          gipi_uwreports_inw_ri_ext.ri_comm_vat%TYPE,
      polcount             NUMBER,
      total_tsi            gipi_uwreports_inw_ri_ext.total_tsi%TYPE,
      total_prem           gipi_uwreports_inw_ri_ext.total_prem%TYPE,
      v_count              NUMBER,
      v_reference          NUMBER,
      v_tax_count          NUMBER,
      v_ri_count           NUMBER
   );

   TYPE get_taxes_tab IS TABLE OF get_taxes_type;

   TYPE get_header_type IS RECORD (
      tax_cd               giis_tax_charges.tax_cd%TYPE,
      tax_name             giis_tax_charges.tax_desc%TYPE
   );

   TYPE get_header_tab IS TABLE OF get_header_type;

   FUNCTION get_report_data (
      P_RI_CD              gipi_uwreports_inw_ri_ext.ri_cd%TYPE,
      P_ISS_CD             gipi_uwreports_ext.iss_cd%TYPE,
      P_LINE_CD            gipi_uwreports_ext.line_cd%TYPE,
      P_SUBLINE_CD         gipi_uwreports_ext.subline_cd%TYPE,
      P_SCOPE              gipi_uwreports_ext.SCOPE%TYPE,
      P_USER_ID            gipi_uwreports_ext.user_id%TYPE
   )
      RETURN get_report_data_tab PIPELINED;

   FUNCTION get_taxes (
      P_RI_CD              gipi_uwreports_inw_ri_ext.ri_cd%TYPE,
      P_ISS_CD             gipi_uwreports_ext.iss_cd%TYPE,
      P_ISS_PARAM          NUMBER,
      P_LINE_CD            gipi_uwreports_ext.line_cd%TYPE,
      P_SUBLINE_CD         gipi_uwreports_ext.subline_cd%TYPE,
      P_SCOPE              gipi_uwreports_ext.SCOPE%TYPE,
      P_USER_ID            gipi_uwreports_ext.user_id%TYPE
   )
      RETURN get_taxes_tab PIPELINED;

   FUNCTION get_header
      RETURN get_header_tab PIPELINED;
END GIPIR929A_MX_PKG;
/


