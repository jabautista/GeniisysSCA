CREATE OR REPLACE PACKAGE CPI.gipis212_pkg
AS
   TYPE grouped_item_type IS RECORD (
      item_no			   gipi_grouped_items.item_no%TYPE, --added by robert SR 5157 12.22.15 
	  grouped_item_no	   gipi_grouped_items.grouped_item_no%TYPE, --added by robert SR 5157 12.22.15 
	  grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE,
      policy_id            gipi_polbasic.policy_id%TYPE,
      control_type_cd      gipi_grouped_items.control_type_cd%TYPE,
      control_type_desc    giis_control_type.control_type_desc%TYPE, --added by robert SR 5157 12.22.15 
      control_cd           gipi_grouped_items.control_cd%TYPE,
      ref_pol_no           gipi_polbasic.ref_pol_no%TYPE,
      assd_no              gipi_polbasic.assd_no%TYPE,
      assd_name            giis_assured.assd_name%TYPE,
      delete_sw            gipi_grouped_items.delete_sw%TYPE
   );

   TYPE grouped_item_tab IS TABLE OF grouped_item_type;

   FUNCTION get_grouped_items (
      p_line_cd              gipi_polbasic.line_cd%TYPE,
      p_subline_cd           gipi_polbasic.subline_cd%TYPE,
      p_iss_cd               gipi_polbasic.iss_cd%TYPE,
      p_issue_yy             VARCHAR2,
      p_pol_seq_no           VARCHAR2,
      p_renew_no             VARCHAR2,
      p_grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE,
      p_control_type_cd      VARCHAR2,
      p_control_type_desc    VARCHAR2, --added by robert SR 5157 12.22.15 
      p_control_cd           gipi_grouped_items.control_cd%TYPE,
      p_policy_id            gipi_polbasic.policy_id%TYPE
   )
      RETURN grouped_item_tab PIPELINED;

   TYPE grouped_item_dtl_type IS RECORD (
      endt              VARCHAR2 (50),
      eff_date          VARCHAR2 (50),
      item_no           VARCHAR2 (100),
      grouped_item_no   VARCHAR2 (100),
      line_cd           gipi_polbasic.line_cd%TYPE,
      policy_id         gipi_polbasic.policy_id%TYPE,
      tsi_amt           gipi_polbasic.tsi_amt%TYPE,
      prem_amt          gipi_polbasic.prem_amt%TYPE,
      package_cd        giis_package_benefit.package_cd%TYPE,
      delete_sw         gipi_grouped_items.delete_sw%TYPE
   );

   TYPE grouped_item_dtl_tab IS TABLE OF grouped_item_dtl_type;

   FUNCTION get_grouped_items_dtl (
      p_policy_id            VARCHAR2,
      p_grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE,
      p_endt                 VARCHAR2,
      p_item_no              VARCHAR2,
      p_grouped_item_no      VARCHAR2,
      p_package_cd           giis_package_benefit.package_cd%TYPE
   )
      RETURN grouped_item_dtl_tab PIPELINED;

   TYPE policy_no_lov_type IS RECORD (
      policy_no    VARCHAR2 (100),
      policy_id    gipi_polbasic.policy_id%TYPE,
      ref_pol_no   gipi_polbasic.ref_pol_no%TYPE,
      assd_name    giis_assured.assd_name%TYPE,
      line_cd      gipi_polbasic.line_cd%TYPE,
      subline_cd   gipi_polbasic.subline_cd%TYPE,
      iss_cd       gipi_polbasic.iss_cd%TYPE,
      issue_yy     gipi_polbasic.issue_yy%TYPE,
      pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      renew_no     gipi_polbasic.renew_no%TYPE
   );

   TYPE policy_no_lov_tab IS TABLE OF policy_no_lov_type;

   FUNCTION get_policyno_lov (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_user_id      giis_users.user_id%TYPE
   )
      RETURN policy_no_lov_tab PIPELINED;

   TYPE coverage_dtls_type IS RECORD (
      policy_id         gipi_itmperil_grouped.policy_id%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      prem_rt           gipi_itmperil_grouped.prem_rt%TYPE,
      tsi_amt           gipi_itmperil_grouped.tsi_amt%TYPE,
      prem_amt          gipi_itmperil_grouped.prem_amt%TYPE,
      aggregate_sw      gipi_itmperil_grouped.aggregate_sw%TYPE,
      base_amt          gipi_itmperil_grouped.base_amt%TYPE,
      no_of_days        gipi_itmperil_grouped.no_of_days%TYPE,
      grouped_item_no   gipi_itmperil_grouped.grouped_item_no%TYPE,
      item_no           gipi_itmperil_grouped.item_no%TYPE,
      line_cd           giis_peril.line_cd%TYPE
   );

   TYPE coverage_dtls_tab IS TABLE OF coverage_dtls_type;

   FUNCTION get_coverage_dtls (
      p_policy_id         gipi_itmperil_grouped.policy_id%TYPE,
      p_grouped_item_no   gipi_itmperil_grouped.grouped_item_no%TYPE,
      p_item_no           gipi_itmperil_grouped.item_no%TYPE,
      p_line_cd           giis_peril.line_cd%TYPE,
      p_peril_name        giis_peril.peril_name%TYPE
   )
      RETURN coverage_dtls_tab PIPELINED;
END;
/


