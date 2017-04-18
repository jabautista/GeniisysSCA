CREATE OR REPLACE PACKAGE CPI.gipir923a_pkg
AS
   TYPE report_type IS RECORD (
      assd_name      /* gipi_uwreports_intm_ext.assd_name%TYPE*/ VARCHAR2(2000) ,  -- jhing 08.13.2015 FGICWEB 17728 changed type to varchar. Will display concatenation of assd_no and assd_name AFPGEN 19428 / FGIC 17728
      doc_stamps      gipi_uwreports_intm_ext.doc_stamps%TYPE,
      endt_iss_cd     gipi_uwreports_intm_ext.endt_iss_cd%TYPE,
      endt_seq_no     gipi_uwreports_intm_ext.endt_seq_no%TYPE,
      endt_yy         gipi_uwreports_intm_ext.endt_yy%TYPE,
      evatprem        gipi_uwreports_intm_ext.evatprem%TYPE,
      expiry_date     gipi_uwreports_intm_ext.expiry_date%TYPE,
      fst             gipi_uwreports_intm_ext.fst%TYPE,
      incept_date     gipi_uwreports_intm_ext.incept_date%TYPE,
      iss_cd          gipi_uwreports_intm_ext.iss_cd%TYPE,
      issue_date      gipi_uwreports_intm_ext.issue_date%TYPE,
      issue_yy        gipi_uwreports_intm_ext.issue_yy%TYPE,
      lgt             gipi_uwreports_intm_ext.lgt%TYPE,
      line_cd         gipi_uwreports_intm_ext.line_cd%TYPE,
      line_name       gipi_uwreports_intm_ext.line_name%TYPE,
      other_taxes     gipi_uwreports_intm_ext.other_taxes%TYPE,
      pol_seq_no      gipi_uwreports_intm_ext.pol_seq_no%TYPE,
      policy_id       gipi_uwreports_intm_ext.policy_id%TYPE,
      policy_no       VARCHAR2 (4000),
      renew_no        gipi_uwreports_intm_ext.renew_no%TYPE,
      subline_cd      gipi_uwreports_intm_ext.subline_cd%TYPE,
      subline_name    gipi_uwreports_intm_ext.subline_name%TYPE,
      total_charges   NUMBER,
      total_prem      gipi_uwreports_intm_ext.total_prem%TYPE,
      total_tsi       gipi_uwreports_intm_ext.total_tsi%TYPE,
      cf_iss_name     VARCHAR2 (50),
      cf_iss_header   /*VARCHAR2 (20)*/  VARCHAR2 (50), --benjo 09.18.2015 FGIC-SR-17728
      pol_count       NUMBER
   );

   TYPE report_tab IS TABLE OF report_type;

   TYPE header_type IS RECORD (
      cf_company           VARCHAR2 (150),
      cf_company_address   VARCHAR2 (500),
      cf_heading3          VARCHAR2 (150),
      cf_based_on          VARCHAR2 (100)
   );

   TYPE header_tab IS TABLE OF header_type;

   FUNCTION get_header_gipr923a (
      p_scope     gipi_uwreports_intm_ext.SCOPE%TYPE,
      p_user_id   gipi_uwreports_intm_ext.user_id%TYPE
   )
      RETURN header_tab PIPELINED;

   FUNCTION populate_gipir923a (
      p_iss_param    gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_user_id      gipi_uwreports_intm_ext.user_id%TYPE,
      p_iss_cd       gipi_uwreports_intm_ext.iss_cd%TYPE,
      p_line_cd      gipi_uwreports_intm_ext.line_cd%TYPE,
      p_subline_cd   gipi_uwreports_intm_ext.subline_cd%TYPE,
      p_assd_no      gipi_uwreports_intm_ext.assd_no%TYPE,
      p_intm_no      gipi_uwreports_intm_ext.intm_no%TYPE,
      p_scope        gipi_uwreports_intm_ext.SCOPE%TYPE
   )
      RETURN report_tab PIPELINED;

   FUNCTION cf_iss_nameformula (p_iss_cd giis_issource.iss_cd%TYPE)
      RETURN CHAR;

   FUNCTION cf_iss_headerformula (
      p_iss_param   gipi_uwreports_intm_ext.iss_cd%TYPE
   )
      RETURN CHAR;

   FUNCTION cf_based_onformula (
      p_user_id   gipi_uwreports_intm_ext.user_id%TYPE,
      p_scope     gipi_uwreports_intm_ext.SCOPE%TYPE
   )
      RETURN CHAR;

   FUNCTION cf_companyformula
      RETURN CHAR;

   FUNCTION cf_company_addressformula
      RETURN CHAR;

   FUNCTION cf_heading3formula (
      p_user_id   gipi_uwreports_intm_ext.user_id%TYPE
   )
      RETURN CHAR;
    FUNCTION check_unique_policy(pol_id_i GIPI_UWREPORTS_INTM_EXT.policy_id%TYPE,pol_id_j GIPI_UWREPORTS_INTM_EXT.policy_id%TYPE) 
        RETURN CHAR;
END gipir923a_pkg;
/
