CREATE OR REPLACE PACKAGE CPI.gipir924e_pkg
AS
   /*
   **  Created by   :  Alvin Azarraga
   **  Date Created : 06.04.2012
   **  Reference By : GICLR037_RSIC
   **  Description  :
   */
   TYPE get_gipir924e_type IS RECORD (
      line_name        VARCHAR (50),
      subline_name     VARCHAR (50),
      iss_header       VARCHAR (50),
      pol_no           VARCHAR (100),
      pol_flag_str     VARCHAR (100),
      dist_flag        VARCHAR2 (2),
      line_cd          gipi_uwreports_ext.line_cd%TYPE,
      subline_cd       gipi_uwreports_ext.subline_cd%TYPE,
      iss_cd_header    gipi_uwreports_ext.iss_cd%TYPE,
      iss_cd           gipi_uwreports_ext.iss_cd%TYPE,
      issue_yy         gipi_uwreports_ext.issue_yy%TYPE,
      pol_seq_no       gipi_uwreports_ext.pol_seq_no%TYPE,
      renew_no         gipi_uwreports_ext.renew_no%TYPE,
      endt_iss_cd      gipi_uwreports_ext.endt_iss_cd%TYPE,
      endt_yy          gipi_uwreports_ext.endt_yy%TYPE,
      endt_seq_no      gipi_uwreports_ext.endt_seq_no%TYPE,
      issue_date       gipi_uwreports_ext.issue_date%TYPE,
      incept_date      gipi_uwreports_ext.incept_date%TYPE,
      expiry_date      gipi_uwreports_ext.expiry_date%TYPE,
      total_tsi        gipi_uwreports_ext.total_tsi%TYPE,
      total_prem       gipi_uwreports_ext.total_prem%TYPE,
      evatprem         gipi_uwreports_ext.evatprem%TYPE,
      lgt              gipi_uwreports_ext.lgt%TYPE,
      doc_stamp        gipi_uwreports_ext.doc_stamps%TYPE,
      fst              gipi_uwreports_ext.fst%TYPE,
      other_taxes      gipi_uwreports_ext.other_taxes%TYPE,
      total_charges    NUMBER (16, 2),
      total_taxes      NUMBER (16, 2),
      param_date       gipi_uwreports_ext.param_date%TYPE,
      from_date        gipi_uwreports_ext.from_date%TYPE,
      TO_DATE          gipi_uwreports_ext.TO_DATE%TYPE,
      SCOPE            gipi_uwreports_ext.SCOPE%TYPE,
      user_id          gipi_uwreports_ext.user_id%TYPE,
      policy_id        gipi_uwreports_ext.policy_id%TYPE,
      assd_no          gipi_uwreports_ext.assd_no%TYPE,
      spld_date        VARCHAR2 (100),  ---gipi_uwreports_ext.spld_date%TYPE,
      pol_count        NUMBER,
      commission_amt   gipi_comm_invoice.commission_amt%TYPE,
      wholding_tax     gipi_comm_invoice.wholding_tax%TYPE,
      net_comm         gipi_comm_invoice.commission_amt%TYPE,
      policy_id_1      gipi_uwreports_ext.policy_id%TYPE,
      pol_flag         gipi_uwreports_ext.pol_flag%TYPE
   );

   TYPE get_gipir924e_tab IS TABLE OF get_gipir924e_type;

   TYPE cf_special_riskformula_type IS RECORD (
      sr_prem   NUMBER,
      sr_comm   NUMBER,
      fr_prem   NUMBER,
      fr_comm   NUMBER,
      sr_tsi    NUMBER,
      fr_tsi    NUMBER
   );

   TYPE cf_special_riskformula_tab IS TABLE OF cf_special_riskformula_type;

   TYPE populate_gipir924e_type IS RECORD (
      cf_company           VARCHAR2 (100),
      cf_company_address   giis_parameters.param_value_v%TYPE, -- VARCHAR2(100), changed by robert 01.02.14 
      cf_heading3          VARCHAR2 (100),
      sr_prem              NUMBER,
      sr_comm              NUMBER,
      fr_prem              NUMBER,
      fr_comm              NUMBER,
      sr_tsi               NUMBER,
      fr_tsi               NUMBER
   );

   TYPE populate_gipir924e_tab IS TABLE OF populate_gipir924e_type;

   FUNCTION get_gipir924e (
      p_iss_param    NUMBER,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN get_gipir924e_tab PIPELINED;

   FUNCTION cf_pol_flagformula (p_pol_flag cg_ref_codes.rv_low_value%TYPE)
      RETURN CHAR;

   FUNCTION cf_heading3formula(
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN CHAR;

   FUNCTION cf_company_addressformula
      RETURN CHAR;

   FUNCTION cf_companyformula
      RETURN CHAR;

   FUNCTION cf_iss_nameformula (p_iss_cd_header VARCHAR2)
      RETURN CHAR;

   FUNCTION cf_line_nameformula (p_line_cd gipi_uwreports_ext.line_cd%TYPE)
      RETURN CHAR;

   FUNCTION cf_subline_nameformula (
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE
   )
      RETURN CHAR;

   FUNCTION cf_special_riskformula (
      p_iss_param   NUMBER,
      p_iss_cd      gipi_uwreports_ext.iss_cd%TYPE,
      p_line_cd     gipi_uwreports_ext.line_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN cf_special_riskformula_tab PIPELINED;

   FUNCTION cf_policy_noformula (
      p_line_cd       gipi_uwreports_ext.line_cd%TYPE,
      p_subline_cd    gipi_uwreports_ext.subline_cd%TYPE,
      p_iss_cd        gipi_uwreports_ext.iss_cd%TYPE,
      p_issue_yy      gipi_uwreports_ext.issue_yy%TYPE,
      p_pol_seq_no    gipi_uwreports_ext.pol_seq_no%TYPE,
      p_renew_no      gipi_uwreports_ext.renew_no%TYPE,
      p_endt_iss_cd   gipi_uwreports_ext.endt_iss_cd%TYPE,
      p_endt_yy       gipi_uwreports_ext.endt_yy%TYPE,
      p_endt_seq_no   gipi_uwreports_ext.endt_seq_no%TYPE,
      p_policy_id     gipi_uwreports_ext.policy_id%TYPE
   )
      RETURN CHAR;

   FUNCTION populate_gipir924e (
      p_iss_param   NUMBER,
      p_iss_cd      gipi_uwreports_ext.iss_cd%TYPE,
      p_line_cd     gipi_uwreports_ext.line_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN populate_gipir924e_tab PIPELINED;
END gipir924e_pkg;
/


