CREATE OR REPLACE PACKAGE CPI.giacr275_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      date_parameter    VARCHAR2 (200),
      from_to_date      VARCHAR2 (100),
      iss_title         VARCHAR2 (200),
      iss_title1        VARCHAR2 (200),
      intm_type         VARCHAR2 (200),
      intm_name         gixx_intm_prod_ext.intm_name%TYPE,
      line_name         giis_line.line_name%TYPE,
      prem_amt          gixx_intm_prod_ext.prem_amt%TYPE,
      line_prem_amt     gixx_intm_prod_ext.prem_amt%TYPE,
      iss_prem_amt      gixx_intm_prod_ext.prem_amt%TYPE,
      agent_code        VARCHAR2 (100),
      intm_no           VARCHAR2 (100),
      line_cd           gixx_intm_prod_ext.line_cd%TYPE,
      iss_cd            gixx_intm_prod_ext.iss_cd%TYPE,
      share_type        gixx_intm_prod_ext.share_type%TYPE,
      share_name        VARCHAR2 (200),
      line_iss_cd       gixx_intm_prod_ext.iss_cd%TYPE,
      line_share_type   gixx_intm_prod_ext.share_type%TYPE,
      line_share_name   VARCHAR2 (200),
      line_intm_no      gixx_intm_prod_ext.line_cd%TYPE
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giacr_275_report (
      p_date_param   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_intm_no      VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN report_tab PIPELINED;

   TYPE giacr275_type IS RECORD (
      share_name_title   VARCHAR2 (200),
      ca_trty_type       giis_ca_trty_type.ca_trty_type%TYPE,
      share_type_title   giis_dist_share.share_type%TYPE
   );

   TYPE giacr275_tab IS TABLE OF giacr275_type;

   FUNCTION get_giacr_275_dtls
      RETURN giacr275_tab PIPELINED;

   FUNCTION get_giacr_275_agent (
      p_intm_no      VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_line_cd      VARCHAR2,
      p_user_id      VARCHAR2,
      p_share_type   VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/


