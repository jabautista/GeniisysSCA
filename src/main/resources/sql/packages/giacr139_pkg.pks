CREATE OR REPLACE PACKAGE CPI.giacr139_pkg
AS
   TYPE giacr139_records_type IS RECORD (
      exist                VARCHAR2 (1),
      dummy_group          VARCHAR2 (10),
      iss_cd               VARCHAR2 (20),
      orig_iss_cd          giac_dtl_distribution_ext.iss_cd%TYPE,
      line_cd              VARCHAR2 (20),
      orig_line_cd         giac_dtl_distribution_ext.line_cd%TYPE,
      line_name            giac_dtl_distribution_ext.line_name%TYPE,
      subline_cd           VARCHAR2 (20),
      orig_subline_cd      giac_dtl_distribution_ext.subline_cd%TYPE,
      subline_name         giac_dtl_distribution_ext.subline_name%TYPE,
      policy_id            giac_dtl_distribution_ext.policy_id%TYPE,
      pol_name             giac_dtl_distribution_ext.pol_name%TYPE,
      dist_seq_no          giac_dtl_distribution_ext.dist_seq_no%TYPE,
      dist_no              giac_dtl_distribution_ext.dist_no%TYPE,
      trty_name1           giac_dtl_distribution_ext.trty_name%TYPE,
      trty_name2           giac_dtl_distribution_ext.trty_name%TYPE,
      trty_name3           giac_dtl_distribution_ext.trty_name%TYPE,
      trty_name4           giac_dtl_distribution_ext.trty_name%TYPE,
      trty_name5           giac_dtl_distribution_ext.trty_name%TYPE,
      trty_name6           giac_dtl_distribution_ext.trty_name%TYPE,
      trty_name7           giac_dtl_distribution_ext.trty_name%TYPE,
      trty_name8           giac_dtl_distribution_ext.trty_name%TYPE,
      trty_name9           giac_dtl_distribution_ext.trty_name%TYPE,
      share_cd1            giac_dtl_distribution_ext.share_cd%TYPE,
      share_cd2            giac_dtl_distribution_ext.share_cd%TYPE,
      share_cd3            giac_dtl_distribution_ext.share_cd%TYPE,
      share_cd4            giac_dtl_distribution_ext.share_cd%TYPE,
      share_cd5            giac_dtl_distribution_ext.share_cd%TYPE,
      share_cd6            giac_dtl_distribution_ext.share_cd%TYPE,
      share_cd7            giac_dtl_distribution_ext.share_cd%TYPE,
      share_cd8            giac_dtl_distribution_ext.share_cd%TYPE,
      share_cd9            giac_dtl_distribution_ext.share_cd%TYPE,
      prem1                NUMBER (20, 2),
      prem2                NUMBER (20, 2),
      prem3                NUMBER (20, 2),
      prem4                NUMBER (20, 2),
      prem5                NUMBER (20, 2),
      prem6                NUMBER (20, 2),
      prem7                NUMBER (20, 2),
      prem8                NUMBER (20, 2),
      prem9                NUMBER (20, 2),
      tsi1                 NUMBER (20, 2),
      tsi2                 NUMBER (20, 2),
      tsi3                 NUMBER (20, 2),
      tsi4                 NUMBER (20, 2),
      tsi5                 NUMBER (20, 2),
      tsi6                 NUMBER (20, 2),
      tsi7                 NUMBER (20, 2),
      tsi8                 NUMBER (20, 2),
      tsi9                 NUMBER (20, 2),
      cf_company           VARCHAR2 (500),
      cf_company_address   VARCHAR2 (500),
      cf_from_date         VARCHAR2 (50),
      cf_to_date           VARCHAR2 (50)
   );

   TYPE giacr139_records_tab IS TABLE OF giacr139_records_type;

   TYPE v_type IS RECORD (
      trty_name   giac_dtl_distribution_ext.trty_name%TYPE,
      share_cd    giac_dtl_distribution_ext.share_cd%TYPE
   );

   TYPE v_tab IS TABLE OF v_type;

   FUNCTION get_giacr139_records (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_line_cd     giis_line.line_cd%TYPE,
      p_date_from   DATE,
      p_date_to     DATE,
      p_user_id     giis_users.user_name%TYPE
   )
      RETURN giacr139_records_tab PIPELINED;

   FUNCTION get_total (
      p_iss_cd       giis_issource.iss_cd%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_date_from    DATE,
      p_date_to      DATE,
      p_user_id      giis_users.user_name%TYPE,
      p_policy_id    giac_dtl_distribution_ext.policy_id%TYPE,
      p_iss_cd2      giis_issource.iss_cd%TYPE,
      p_line_cd2     giac_dtl_distribution_ext.line_cd%TYPE,
      p_subline_cd   giac_dtl_distribution_ext.subline_cd%TYPE,
      p_list         v_tab,
      p_return       VARCHAR2
   )
      RETURN NUMBER;
END;
/


