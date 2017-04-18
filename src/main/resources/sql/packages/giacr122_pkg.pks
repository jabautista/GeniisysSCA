CREATE OR REPLACE PACKAGE CPI.giacr122_pkg
AS
   TYPE giacr122_dtls_type IS RECORD (
      report_title        VARCHAR2 (200),
      report_date_title   VARCHAR2 (200),
      cf_co_name          VARCHAR2 (100),
      cf_co_address       VARCHAR2 (100),
      cf_toggle           VARCHAR2 (40),
      acct_ent_date       giac_prodrep_peril_ext.acct_ent_date%TYPE,
      line_name           giis_line.line_name%TYPE,
      subline_cd          giis_subline.subline_cd%TYPE,
      policy_no           giac_prodrep_peril_ext.policy_no%TYPE,
      net_ret_tsi         giac_prodrep_peril_ext.nr_dist_tsi%TYPE,
      net_ret_prem        giac_prodrep_peril_ext.nr_dist_prem%TYPE,
      treaty_tsi          giac_prodrep_peril_ext.tr_dist_tsi%TYPE,
      treaty_prem         giac_prodrep_peril_ext.tr_dist_prem%TYPE,
      facultative_tsi     giac_prodrep_peril_ext.fa_dist_tsi%TYPE,
      facultative_prem    giac_prodrep_peril_ext.fa_dist_prem%TYPE,
      total_tsi           giac_prodrep_peril_ext.fa_dist_tsi%TYPE,
      total_prem          giac_prodrep_peril_ext.fa_dist_prem%TYPE,
      line_cd             giis_line.line_cd%TYPE
   );

   TYPE giacr122_dtls_tab IS TABLE OF giacr122_dtls_type;

   FUNCTION get_giacr122_dtls (
      p_from_date    DATE,
      p_to_date      DATE,
      p_iss_cd       giis_issource.iss_cd%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_toggle       VARCHAR2,
      p_user         giis_users.user_id%TYPE,
      p_subline_cd   giis_subline.subline_cd%TYPE
   )
      RETURN giacr122_dtls_tab PIPELINED;
END;
/


