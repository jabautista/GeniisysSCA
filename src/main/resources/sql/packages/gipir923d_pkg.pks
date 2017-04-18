CREATE OR REPLACE PACKAGE CPI.gipir923d_pkg
AS
   TYPE get_data_type IS RECORD (
      iss_cd            gipi_uwreports_ext.iss_cd%TYPE,
      line_cd           gipi_uwreports_ext.line_cd%TYPE,
      subline_cd        gipi_uwreports_ext.subline_cd%TYPE,
      policy_id         gipi_uwreports_ext.policy_id%TYPE,
      issue_yy          gipi_uwreports_ext.issue_yy%TYPE,
      pol_seq_no        gipi_uwreports_ext.pol_seq_no%TYPE,
      renew_no          gipi_uwreports_ext.renew_no%TYPE,
      endt_iss_cd       gipi_uwreports_ext.endt_iss_cd%TYPE,
      endt_yy           gipi_uwreports_ext.endt_yy%TYPE,
      endt_seq_no       gipi_uwreports_ext.endt_seq_no%TYPE,
      issue_date        gipi_uwreports_ext.issue_date%TYPE,
      incept_date       gipi_uwreports_ext.incept_date%TYPE,
      expiry_date       gipi_uwreports_ext.expiry_date%TYPE,
      total_tsi         gipi_uwreports_ext.total_tsi%TYPE,
      total_prem        gipi_uwreports_ext.total_prem%TYPE,
      evatprem          gipi_uwreports_ext.evatprem%TYPE,
      lgt               gipi_uwreports_ext.lgt%TYPE,
      doc_stamp         gipi_uwreports_ext.doc_stamps%TYPE,
      fst               gipi_uwreports_ext.fst%TYPE,
      other_taxes       gipi_uwreports_ext.other_taxes%TYPE,
      param_date        gipi_uwreports_ext.param_date%TYPE,
      from_date         gipi_uwreports_ext.from_date%TYPE,
      TO_DATE           gipi_uwreports_ext.TO_DATE%TYPE,
      SCOPE             gipi_uwreports_ext.SCOPE%TYPE,
      user_id           gipi_uwreports_ext.user_id%TYPE,
      assd_no           gipi_uwreports_ext.assd_no%TYPE,
      policy_no         VARCHAR2 (100),
      total_charges     NUMBER (10, 2),
      iss_cd_head       VARCHAR2 (100),
      acctg_seq         NUMBER,
      acct_ent_date     VARCHAR2 (50),
      cf_heading        VARCHAR2 (100),
      cf_company        VARCHAR2 (50),
      cf_comaddress     VARCHAR2 (100),
      cf_assd_aname     VARCHAR2 (50),
      cf_based_on       VARCHAR2 (50),
      cf_iss_name       VARCHAR2 (50),
      cf_iss_title      VARCHAR2 (50),
      cf_line_name      VARCHAR2 (50),
      cf_subline_name   VARCHAR2 (50),
      cf_assd_name      GIIS_ASSURED.assd_name%TYPE -- marco - 02.05.2013 - modified data type
   );

   TYPE gipir923d_tab IS TABLE OF get_data_type;

   FUNCTION get_dt (
      p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
      p_scope        gipi_uwreports_ext.SCOPE%TYPE,
      p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
      p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
     -- p_from_date    gipi_uwreports_ext.from_date%TYPE,
     -- p_to_date      gipi_uwreports_ext.TO_DATE%TYPE,
      p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
      p_user_id      gipi_uwreports_ext.user_id%TYPE
   )
      RETURN gipir923d_tab PIPELINED;
END;
/


