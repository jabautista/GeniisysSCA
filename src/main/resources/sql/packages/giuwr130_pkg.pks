CREATE OR REPLACE PACKAGE CPI.giuwr130_pkg
AS
   TYPE giuwr130_policy_no_type IS RECORD (
      cf_company_name   VARCHAR2 (100),
      cf_header         VARCHAR2 (50),
      cf_header2        VARCHAR2 (50),
      cf_header3        VARCHAR2 (50),
      cf_final_header   VARCHAR2 (100),
      policy_no         VARCHAR2 (100),
      endt_no           VARCHAR2 (50),
      dist_no           VARCHAR2 (50),
      eff_date          VARCHAR2 (50),
      expiry_date       VARCHAR2 (50),
      dist_eff_date     VARCHAR2 (50), --added by robert SR 5290 01.29.2016
      dist_exp_date     VARCHAR2 (50), --added by robert SR 5290 01.29.2016
      policy_id         gipi_polbasic.policy_id%TYPE,
      dist_tsi          giuw_policyds_dtl.dist_tsi%TYPE,
      dist_prem         giuw_policyds_dtl.dist_prem%TYPE,
      dist_spct         giuw_policyds_dtl.dist_spct%TYPE,
      dist_spct1        giuw_policyds_dtl.dist_spct1%TYPE,
      dist_seq_no       VARCHAR2 (50),
      cf_treaty_name    VARCHAR2 (100),
      print_details     VARCHAR2 (1)    -- shan 05.13.2014
   );

   TYPE giuwr130_policy_no_tab IS TABLE OF giuwr130_policy_no_type;

   FUNCTION get_giuwr130_policy (
      p_dist_flag   giuw_pol_dist.dist_no%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giuwr130_policy_no_tab PIPELINED;

   TYPE giuwr130_dist_seq_no_type IS RECORD (
      dist_seq_no   VARCHAR2 (50),
      dist_no       VARCHAR2 (50)
   );

   TYPE giuwr130_dist_seq_no_tab IS TABLE OF giuwr130_dist_seq_no_type;

   FUNCTION get_giuwr130_dist_seq_no (
      p_dist_flag   VARCHAR2,
      p_user_id     VARCHAR2,
      p_dist_no     VARCHAR2
   )
      RETURN giuwr130_dist_seq_no_tab PIPELINED;

   TYPE giuwr130_share_cd_type IS RECORD (
      cf_treaty_name   VARCHAR2 (100),
      dist_tsi         giuw_policyds_dtl.dist_tsi%TYPE,
      dist_prem        giuw_policyds_dtl.dist_prem%TYPE,
      dist_spct        giuw_policyds_dtl.dist_spct%TYPE,
      dist_spct1       giuw_policyds_dtl.dist_spct1%TYPE
   );

   TYPE giuwr130_share_cd_tab IS TABLE OF giuwr130_share_cd_type;

   FUNCTION get_giuwr130_share_cd (
      p_dist_flag     VARCHAR2,
      p_user_id       VARCHAR2,
      p_dist_no       VARCHAR2,
      p_dist_seq_no   VARCHAR2
   )
      RETURN giuwr130_share_cd_tab PIPELINED;
END;
/


