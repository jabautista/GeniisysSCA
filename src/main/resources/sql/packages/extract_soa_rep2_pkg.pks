CREATE OR REPLACE PACKAGE CPI.extract_soa_rep2_pkg
IS
   v_true    NUMBER DEFAULT 1;
   v_false   NUMBER DEFAULT 0;

   TYPE rec IS RECORD (
      policy_id       gipi_polbasic.policy_id%TYPE,
      policy_no       VARCHAR2 (50),
      assd_no         gipi_parlist.assd_no%TYPE,
      cred_branch     gipi_polbasic.cred_branch%TYPE,
      line_cd         gipi_polbasic.line_cd%TYPE,
      subline_cd      gipi_polbasic.subline_cd%TYPE,
      iss_cd          gipi_polbasic.iss_cd%TYPE,
      issue_yy        gipi_polbasic.issue_yy%TYPE,
      renew_no        gipi_polbasic.renew_no%TYPE,
      pol_seq_no      gipi_polbasic.pol_seq_no%TYPE,
      line_name       giis_line.line_name%TYPE,
      acct_ent_date   gipi_polbasic.acct_ent_date%TYPE,
      ref_pol_no      gipi_polbasic.ref_pol_no%TYPE,
      incept_date     gipi_polbasic.incept_date%TYPE,
      issue_date      gipi_polbasic.issue_date%TYPE,
      spld_date       gipi_polbasic.spld_date%TYPE,
      pol_flag        gipi_polbasic.pol_flag%TYPE,
      eff_date        gipi_polbasic.eff_date%TYPE,
      expiry_date     gipi_polbasic.expiry_date%TYPE,
      policy_id2      gipi_polbasic.policy_id%TYPE,
      assd_no2        gipi_parlist.assd_no%TYPE,
      assd_name      giis_assured.assd_name%TYPE,
      reg_policy_sw   gipi_polbasic.reg_policy_sw%TYPE,
      endt_type       gipi_polbasic.endt_type%TYPE,
      spld_acct_ent_date  gipi_polbasic.SPLD_ACCT_ENT_DATE%TYPE -- shan 12.09.2014
   );

   TYPE tab IS TABLE OF rec;

   FUNCTION get_list (
      p_date_as_of       DATE DEFAULT NULL,
      p_book_tag         VARCHAR2 DEFAULT NULL,
      p_incep_tag        VARCHAR2 DEFAULT NULL,
      p_issue_tag        VARCHAR2 DEFAULT NULL,
      p_rep_date         VARCHAR2 DEFAULT NULL,
      p_book_date_fr     DATE DEFAULT NULL,
      p_book_date_to     DATE DEFAULT NULL,
      p_incept_date_fr   DATE DEFAULT NULL,
      p_incept_date_to   DATE DEFAULT NULL,
      p_issue_date_fr    DATE DEFAULT NULL,
      p_issue_date_to    DATE DEFAULT NULL,
      p_special_pol      VARCHAR2 DEFAULT NULL,
      p_branch_param     VARCHAR2 DEFAULT NULL
   )
      RETURN tab PIPELINED;

   FUNCTION validates (
      p_date_as_of       DATE DEFAULT NULL,
      p_book_tag         VARCHAR2 DEFAULT NULL,
      p_incep_tag        VARCHAR2 DEFAULT NULL,
      p_issue_tag        VARCHAR2 DEFAULT NULL,
      p_rep_date         VARCHAR2 DEFAULT NULL,
      p_acct_ent_date    DATE DEFAULT NULL,
      p_book_date_fr     DATE DEFAULT NULL,
      p_book_date_to     DATE DEFAULT NULL,
      p_incept_date      DATE DEFAULT NULL,
      p_incept_date_fr   DATE DEFAULT NULL,
      p_incept_date_to   DATE DEFAULT NULL,
      p_issue_date_fr    DATE DEFAULT NULL,
      p_issue_date_to    DATE DEFAULT NULL,
      p_special_pol      VARCHAR2 DEFAULT NULL,
      p_branch_param     VARCHAR2 DEFAULT NULL,
      p_issue_date       DATE DEFAULT NULL
   )
      RETURN NUMBER;
END;
/


