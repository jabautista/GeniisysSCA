CREATE OR REPLACE PACKAGE CPI.gipir923c_pkg 
AS
/* ******************************************************** **
** Created By: Benjo Brito
** Date Created: 06.25.2015
** GENQA-AFPGEN-IMPLEM-SR-4616 : UW-SPECS-2015-054-FULLWEB
** ******************************************************** */
   TYPE get_details_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      report_title      VARCHAR2 (200),
      based_on          VARCHAR2 (200),
      heading           VARCHAR2 (150),
      branch_cd         giis_issource.iss_cd%TYPE,
      branch_name       giis_issource.iss_name%TYPE,
      line_cd           giis_line.line_cd%TYPE,
      line_name         giis_line.line_name%TYPE,
      subline_cd        giis_subline.subline_cd%TYPE,
      subline_name      giis_subline.subline_name%TYPE,
      acct_seq          NUMBER (6),
      acct_ent_date     VARCHAR2 (50),
      policy_id         NUMBER (12),
      policy_no         VARCHAR2 (100),
      assd_name         giis_assured.assd_name%TYPE,
      issue_date        VARCHAR2 (50),
      incept_date       VARCHAR2 (50),
      expiry_date       VARCHAR2 (50),
      spld_date         VARCHAR2 (50),
      total_tsi         NUMBER (16, 2),
      total_prem        NUMBER (16, 2),
      evatprem          NUMBER (12, 2),
      lgt               NUMBER (12, 2),
      doc_stamps        NUMBER (12, 2),
      fst               NUMBER (12, 2),
      other_charges     NUMBER (12, 2),
      total_amt         NUMBER (16, 2),
      pol_count         NUMBER (12)
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_report_details (
      p_tab          VARCHAR2,
      p_iss_param    NUMBER,
      p_scope        NUMBER,
      p_line_cd      VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_user_id      VARCHAR2,
      p_reinstated VARCHAR2 
   )
      RETURN get_details_tab PIPELINED;

   FUNCTION get_date_format (p_date DATE)
      RETURN VARCHAR2;
   FUNCTION check_unique_policy(pol_id_i gipi_uwreports_ext.policy_id%TYPE,pol_id_j gipi_uwreports_ext.policy_id%TYPE) 
        RETURN CHAR; 
END gipir923c_pkg;
/
