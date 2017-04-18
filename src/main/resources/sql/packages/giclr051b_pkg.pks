CREATE OR REPLACE PACKAGE CPI.giclr051b_pkg
AS
   TYPE giclr051b_record_type IS RECORD (
      advice_id       NUMBER (12),
      line            VARCHAR2 (200),
      claim_id        NUMBER (12),
      claim_number    VARCHAR2 (200),
      policy_number   VARCHAR2 (200),
      assured_name    VARCHAR2 (500),
      advice_no       VARCHAR2 (200),
      trty_name       VARCHAR2 (30),
      share_type      VARCHAR2 (1),
      share_cd        NUMBER (3),
      clm_stat_cd     VARCHAR2 (2),
      in_hou_adj      VARCHAR2 (8),
      flag            VARCHAR2 (50),
      company_name    VARCHAR2 (200),
      company_add     VARCHAR2 (350),
      line_name       VARCHAR2 (20),
      status          VARCHAR2 (50),
      paid_shr_amt    NUMBER (16, 2),
      net_shr_amt     NUMBER (16, 2),
      adv_shr_amt     NUMBER (16, 2)
   );

   TYPE giclr051b_record_tab IS TABLE OF giclr051b_record_type;

   TYPE giclr051b_subreport_type IS RECORD (
      advice_id       NUMBER (12),
      line            VARCHAR2 (200),
      claim_id        NUMBER (12),
      claim_number    VARCHAR2 (200),
      policy_number   VARCHAR2 (200),
      assured_name    VARCHAR2 (500),
      advice_no       VARCHAR2 (200),
      trty_name       VARCHAR2 (30),
      share_type      VARCHAR2 (1),
      share_cd        NUMBER (3),
      clm_stat_cd     VARCHAR2 (2),
      in_hou_adj      VARCHAR2 (8),
      flag            VARCHAR2 (50),
      company_name    VARCHAR2 (200),
      company_add     VARCHAR2 (350),
      line_name       VARCHAR2 (20),
      status          VARCHAR2 (50),
      paid_shr_amt    NUMBER (16, 2),
      net_shr_amt     NUMBER (16, 2),
      adv_shr_amt     NUMBER (16, 2)
   );

   TYPE giclr051b_subreport_tab IS TABLE OF giclr051b_subreport_type;

   FUNCTION get_giclr051b_records (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN giclr051b_record_tab PIPELINED;

   FUNCTION get_giclr051b_subreport (
      p_line_cd         VARCHAR2,
      p_user_id         VARCHAR2,
      p_claim_id        NUMBER,
      p_policy_number   VARCHAR2
   )  RETURN giclr051b_subreport_tab PIPELINED;
END;
/


