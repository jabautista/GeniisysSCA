CREATE OR REPLACE PACKAGE CPI.gipir923e_pkg
AS
   TYPE report_type IS RECORD (
      iss_cd                         gipi_uwreports_ext.iss_cd%TYPE,
      cf_iss_name                    VARCHAR (200),
      cf_iss_title                   VARCHAR (200),
      line_cd                        gipi_uwreports_ext.line_cd%TYPE,
      cf_line_name                   VARCHAR (200),
      subline_cd                     gipi_uwreports_ext.subline_cd%TYPE,
      cf_subline_name                VARCHAR (200),
      iss_cd_header                  gipi_uwreports_ext.cred_branch%TYPE,
      total_charges                  NUMBER,
      total_taxes                    NUMBER,
      dist_flag                      VARCHAR (200),
      pol_count                      NUMBER,
      spld_date                      VARCHAR (200),
      assd_no                        gipi_uwreports_ext.assd_no%TYPE,
      issue_yy                       gipi_uwreports_ext.issue_yy%TYPE,
      pol_seq_no                     gipi_uwreports_ext.pol_seq_no%TYPE,
      renew_no                       gipi_uwreports_ext.renew_no%TYPE,
      endt_iss_cd                    gipi_uwreports_ext.endt_iss_cd%TYPE,
      endt_yy                        gipi_uwreports_ext.endt_yy%TYPE,
      endt_seq_no                    gipi_uwreports_ext.endt_seq_no%TYPE,
      issue_date                     gipi_uwreports_ext.issue_date%TYPE,
      incept_date                    gipi_uwreports_ext.incept_date%TYPE,
      expiry_date                    gipi_uwreports_ext.expiry_date%TYPE,
      total_tsi                      gipi_uwreports_ext.total_tsi%TYPE,
      total_prem                     gipi_uwreports_ext.total_prem%TYPE,
      param_date                     gipi_uwreports_ext.param_date%TYPE,
      from_date                      gipi_uwreports_ext.from_date%TYPE,
      TO_DATE                        gipi_uwreports_ext.TO_DATE%TYPE,
      SCOPE                          gipi_uwreports_ext.SCOPE%TYPE,
      user_id                        gipi_uwreports_ext.user_id%TYPE,
      policy_id                      gipi_uwreports_ext.policy_id%TYPE,
      cf_policy_no                   VARCHAR (200),
      cf_assd_name                   VARCHAR (200),
      cf_company                     VARCHAR2 (200),
      cf_company_address             VARCHAR2 (500),
      cf_heading3                    VARCHAR2 (200),
      cf_based_on                    VARCHAR2 (200),
      cf_sysdate                     DATE,
      cf_1                           NUMBER,
      cf_total_prem                  NUMBER,
      cf_distributed_total           NUMBER,
      cf_undistributed_total         NUMBER,
      cf_count                       NUMBER,
      cf_count_distributed_total     NUMBER,
      cf_count_undistributed_total   NUMBER,
      cf_spoiled                     NUMBER,
      cf_param_v                     VARCHAR2 (200),
      
      evatprem                       NUMBER,
      lgt                            NUMBER,
      doc_stamps                     NUMBER,
      fst                            NUMBER, 
      other_taxes                    NUMBER,
      other_charges                  NUMBER            
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION populate_gipir923e (
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      -- p_from_date    gipi_uwreports_ext.from_date%TYPE,
      -- p_to_date      gipi_uwreports_ext.TO_DATE%TYPE,
      p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN report_tab PIPELINED;

   FUNCTION cf_iss_title (p_iss_param gipi_uwreports_ext.iss_cd%TYPE)
      RETURN CHAR;

   FUNCTION cf_iss_name (p_iss_cd gipi_uwreports_ext.iss_cd%TYPE)
      RETURN CHAR;

   FUNCTION cf_line_name (p_line_cd giis_line.line_cd%TYPE)
      RETURN CHAR;

   FUNCTION cf_subline_name (
      p_subline_cd   giis_subline.subline_cd%TYPE,
      p_line_cd      giis_subline.line_cd%TYPE
   )
      RETURN CHAR;

   FUNCTION cf_assd_name (p_assd_no giis_assured.assd_no%TYPE)
      RETURN CHAR;

   FUNCTION cf_policy_no (
      p_line_cd       gipi_uwreports_ext.line_cd%TYPE,
      p_subline_cd    gipi_uwreports_ext.subline_cd%TYPE,
      p_iss_cd        gipi_uwreports_ext.iss_cd%TYPE,
      p_issue_yy      gipi_uwreports_ext.issue_yy%TYPE,
      p_pol_seq_no    gipi_uwreports_ext.pol_seq_no%TYPE,
      p_renew_no      gipi_uwreports_ext.renew_no%TYPE,
      p_endt_seq_no   gipi_uwreports_ext.endt_seq_no%TYPE,
      p_endt_iss_cd   gipi_uwreports_ext.endt_iss_cd%TYPE,
      p_endt_yy       gipi_uwreports_ext.endt_yy%TYPE,
      p_policy_id     gipi_uwreports_ext.policy_id%TYPE
   )
      RETURN CHAR;

FUNCTION cf_based_on (
      p_user_id   gipi_uwreports_ext.user_id%TYPE,
      p_scope     gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN CHAR;

   FUNCTION cf_company (
      p_user_id   gipi_uwreports_ext.user_id%TYPE,
      p_scope     gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN CHAR;

   FUNCTION cf_company_address (
      p_user_id   gipi_uwreports_ext.user_id%TYPE,
      p_scope     gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN CHAR;

   FUNCTION cf_heading3 (p_user_id gipi_uwreports_ext.user_id%TYPE)
      RETURN CHAR;

  FUNCTION cf_1 (
      p_user_id      gipi_uwreports_ext.user_id%TYPE,
      p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN NUMBER;

   FUNCTION cf_spoiled (
      p_user_id      gipi_uwreports_ext.user_id%TYPE,
      p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE
   )
      RETURN NUMBER;
END gipir923e_pkg;
/


