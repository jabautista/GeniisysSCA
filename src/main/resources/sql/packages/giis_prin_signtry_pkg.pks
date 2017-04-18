CREATE OR REPLACE PACKAGE CPI.giis_prin_signtry_pkg
AS
   TYPE prin_signtry_list_type IS RECORD (
      prin_signor   giis_prin_signtry.prin_signor%TYPE,
      designation   giis_prin_signtry.designation%TYPE,
      prin_id       giis_prin_signtry.prin_id%TYPE
   );

   TYPE prin_signtry_list_tab IS TABLE OF prin_signtry_list_type;

   FUNCTION get_signtry_list (p_assd_no giis_prin_signtry.assd_no%TYPE)
      RETURN prin_signtry_list_tab PIPELINED;

   FUNCTION get_prin_signor (p_prin_id giis_prin_signtry.prin_id%TYPE)
      RETURN prin_signtry_list_tab PIPELINED;

   TYPE principal_signatories_type IS RECORD (
      prin_signor             giis_prin_signtry.prin_signor%TYPE,
      designation             giis_prin_signtry.designation%TYPE,
      prin_id                 giis_prin_signtry.prin_id%TYPE,
      res_cert                giis_prin_signtry.res_cert%TYPE,
      issue_place             giis_prin_signtry.issue_place%TYPE,
      issue_date              VARCHAR2 (10),
      --giis_prin_signtry.issue_date%TYPE
      user_id                 giis_prin_signtry.user_id%TYPE,
      last_update             VARCHAR2 (30),
      remarks                 giis_prin_signtry.remarks%TYPE,
      address                 giis_prin_signtry.address%TYPE,
      control_type_cd         giis_prin_signtry.control_type_cd%TYPE,
      control_type_desc       giis_control_type.control_type_desc%TYPE,
      bond_sw                 giis_prin_signtry.bond_sw%TYPE,
      indem_sw                giis_prin_signtry.indem_sw%TYPE,
      ack_sw                  giis_prin_signtry.ack_sw%TYPE,
      cert_sw                 giis_prin_signtry.cert_sw%TYPE,
      ri_sw                   giis_prin_signtry.ri_sw%TYPE
   );

   TYPE principal_signatories_tab IS TABLE OF principal_signatories_type;

   PROCEDURE set_principal_signatory (
      p_prin_signor       giis_prin_signtry.prin_signor%TYPE,
      p_designation       giis_prin_signtry.designation%TYPE,
      p_prin_id           giis_prin_signtry.prin_id%TYPE,
      p_res_cert          giis_prin_signtry.res_cert%TYPE,
      p_issue_place       giis_prin_signtry.issue_place%TYPE,
      p_issue_date        VARCHAR2,        --giis_prin_signtry.issue_date%TYPE
      p_user_id           giis_prin_signtry.user_id%TYPE,
      p_remarks           giis_prin_signtry.remarks%TYPE,
      p_address           giis_prin_signtry.address%TYPE,
      p_assd_no           giis_prin_signtry.assd_no%TYPE,
      p_control_type_cd   giis_prin_signtry.control_type_cd%TYPE,
      p_bond_sw           giis_prin_signtry.bond_sw%TYPE,
      p_indem_sw          giis_prin_signtry.indem_sw%TYPE,
      p_ack_sw            giis_prin_signtry.ack_sw%TYPE,
      p_cert_sw           giis_prin_signtry.cert_sw%TYPE,
      p_ri_sw             giis_prin_signtry.ri_sw%TYPE
   );

   FUNCTION get_principal_signatories (
      p_assd_no   giis_prin_signtry.assd_no%TYPE
   )
      RETURN principal_signatories_tab PIPELINED;

   FUNCTION validate_ctc_no (p_res_cert giis_prin_signtry.res_cert%TYPE)
      RETURN VARCHAR2;

   FUNCTION validate_ctc_no2 (
      p_id1         giis_prin_signtry.prin_id%TYPE,
      p_id2         giis_cosignor_res.cosign_id%TYPE,
      p_res_cert1   giis_prin_signtry.res_cert%TYPE,
      p_res_cert2   giis_cosignor_res.cosign_res_no%TYPE
   )
      RETURN VARCHAR2;

   --added by steven 05.26.2014
   TYPE control_type_list_type IS RECORD (
      control_type_cd     giis_control_type.control_type_cd%TYPE,
      control_type_desc   giis_control_type.control_type_desc%TYPE
   );

   TYPE control_type_list_tab IS TABLE OF control_type_list_type;

   TYPE assured_names_list_type IS RECORD (
      assd_name             giis_assured.assd_name%TYPE,
      assd_no               giis_assured.assd_no%TYPE,
      mail_addr1            giis_assured.mail_addr1%TYPE,
      mail_addr2            giis_assured.mail_addr2%TYPE,
      mail_addr3            giis_assured.mail_addr3%TYPE,
      designation           giis_assured.designation%TYPE,
      active_tag            giis_assured.active_tag%TYPE,
      user_id               giis_assured.user_id%TYPE,
      industry_nm           giis_industry.industry_nm%TYPE,
      industry_cd           giis_industry.industry_cd%TYPE,
      birthdate             giis_assd_ind_info.birthdate%TYPE,
      corp_tag              cg_ref_codes.rv_meaning%TYPE,
      control_type_cd       giis_assured.control_type_cd%TYPE,
      control_type_desc     giis_control_type.control_type_desc%TYPE,
      def_control_type_cd     giis_prin_signtry.control_type_cd%TYPE,
      def_control_type_desc   giis_control_type.control_type_desc%TYPE,
      principal_res_no      giis_principal_res.principal_res_no%TYPE,
      principal_res_date    VARCHAR (30),
      principal_res_place   giis_principal_res.principal_res_place%TYPE
   );

   TYPE assured_names_list_tab IS TABLE OF assured_names_list_type;

   FUNCTION get_control_type_lov (p_keyword VARCHAR2)
      RETURN control_type_list_tab PIPELINED;

   FUNCTION get_assured (p_assd_no giis_assured.assd_no%TYPE)
      RETURN assured_names_list_tab PIPELINED;
END giis_prin_signtry_pkg;
/


