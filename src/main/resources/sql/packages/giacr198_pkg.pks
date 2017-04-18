CREATE OR REPLACE PACKAGE CPI.giacr198_pkg
AS
   TYPE giacr198_type IS RECORD (
      p_cred_iss      VARCHAR2 (300),
      iss_name        VARCHAR2 (20),
      line_cd         VARCHAR2 (2),
      line_name       VARCHAR2 (20),
      subline_cd      VARCHAR2 (7),
      subline_name    VARCHAR2 (30),
      policy_no       VARCHAR2 (40),
      peril_sname     VARCHAR2 (200),
      f_nr_dist_tsi   NUMBER (16, 2),
      f_tr_dist_tsi   NUMBER (16, 2),
      f_fa_dist_tsi   NUMBER (16, 2),
      nr_peril_tsi    NUMBER (16, 2),
      nr_peril_prem   NUMBER (16, 2),
      tr_peril_tsi    NUMBER (16, 2),
      tr_peril_prem   NUMBER (16, 2),
      fa_peril_tsi    NUMBER (16, 2),
      fa_peril_prem   NUMBER (16, 2),
      comp_name       VARCHAR2 (500),
      comp_add        VARCHAR2 (500),
      title           VARCHAR2 (75),
      as_date         VARCHAR2 (250),
      flag            VARCHAR2 (10),
      peril_type      VARCHAR2 (3),
      peril_cd        NUMBER (5)
   );

   TYPE giacr198_tab IS TABLE OF giacr198_type;

   TYPE giacr198_q1_type IS RECORD (
      p_cred_iss      VARCHAR2 (300),
      line_cd         VARCHAR2 (2),
      subline_cd      VARCHAR2 (7),
      peril_sname     VARCHAR2 (200),
      f_nr_dist_tsi   NUMBER (16, 2),
      f_tr_dist_tsi   NUMBER (16, 2),
      f_fa_dist_tsi   NUMBER (16, 2),
      nr_peril_tsi    NUMBER (16, 2),
      nr_peril_prem   NUMBER (16, 2),
      tr_peril_tsi    NUMBER (16, 2),
      tr_peril_prem   NUMBER (16, 2),
      fa_peril_tsi    NUMBER (16, 2),
      fa_peril_prem   NUMBER (16, 2),
      peril_cd        NUMBER (5),
      peril_sname2    VARCHAR2 (200)
   );

   TYPE giacr198_q1_tab IS TABLE OF giacr198_q1_type;

   TYPE giacr198_q3_type IS RECORD (
      p_cred_iss      VARCHAR2 (300),
      line_cd         VARCHAR2 (2),
      peril_sname2    VARCHAR2 (200),
      peril_sname     VARCHAR2 (200),
      f_nr_dist_tsi   NUMBER (16, 2),
      f_tr_dist_tsi   NUMBER (16, 2),
      f_fa_dist_tsi   NUMBER (16, 2),
      nr_peril_tsi    NUMBER (16, 2),
      nr_peril_prem   NUMBER (16, 2),
      tr_peril_tsi    NUMBER (16, 2),
      tr_peril_prem   NUMBER (16, 2),
      fa_peril_tsi    NUMBER (16, 2),
      fa_peril_prem   NUMBER (16, 2),
      peril_cd        NUMBER (5)
   );

   TYPE giacr198_q3_tab IS TABLE OF giacr198_q3_type;

   TYPE giacr198_q4_type IS RECORD (
      p_cred_iss      VARCHAR2 (300),
      peril_sname     VARCHAR2 (200),
      f_nr_dist_tsi   NUMBER (16, 2),
      f_tr_dist_tsi   NUMBER (16, 2),
      f_fa_dist_tsi   NUMBER (16, 2),
      nr_peril_tsi    NUMBER (16, 2),
      nr_peril_prem   NUMBER (16, 2),
      tr_peril_tsi    NUMBER (16, 2),
      tr_peril_prem   NUMBER (16, 2),
      fa_peril_tsi    NUMBER (16, 2),
      fa_peril_prem   NUMBER (16, 2)
   );

   TYPE giacr198_q4_tab IS TABLE OF giacr198_q4_type;

   TYPE giacr198_q5_type IS RECORD (
      peril_sname     VARCHAR2 (200),
      f_nr_dist_tsi   NUMBER (16, 2),
      f_tr_dist_tsi   NUMBER (16, 2),
      f_fa_dist_tsi   NUMBER (16, 2),
      nr_peril_tsi    NUMBER (16, 2),
      nr_peril_prem   NUMBER (16, 2),
      tr_peril_tsi    NUMBER (16, 2),
      tr_peril_prem   NUMBER (16, 2),
      fa_peril_tsi    NUMBER (16, 2),
      fa_peril_prem   NUMBER (16, 2)
   );

   TYPE giacr198_q5_tab IS TABLE OF giacr198_q5_type;

   FUNCTION get_giacr198_record (
      p_cred_iss    VARCHAR2,
      p_from_date   VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_toggle      VARCHAR2,
      p_to_date     VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr198_tab PIPELINED;

   FUNCTION get_giacr198_q1 (
      p_cred_iss    VARCHAR2,
      p_from_date   VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_toggle      VARCHAR2,
      p_to_date     VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr198_q1_tab PIPELINED;

   FUNCTION get_giacr198_q3 (
      p_cred_iss    VARCHAR2,
      p_from_date   VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_toggle      VARCHAR2,
      p_to_date     VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr198_q3_tab PIPELINED;

   FUNCTION get_giacr198_q4 (
      p_cred_iss    VARCHAR2,
      p_from_date   VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_toggle      VARCHAR2,
      p_to_date     VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr198_q4_tab PIPELINED;

   FUNCTION get_giacr198_q5 (
      p_cred_iss    VARCHAR2,
      p_from_date   VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line_cd     VARCHAR2,
      p_toggle      VARCHAR2,
      p_to_date     VARCHAR2,
      p_user        VARCHAR2
   )
      RETURN giacr198_q5_tab PIPELINED;
END;
/


