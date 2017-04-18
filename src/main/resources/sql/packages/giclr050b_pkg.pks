CREATE OR REPLACE PACKAGE CPI.giclr050b_pkg
AS
   TYPE giclr050b_record_type IS RECORD (
      line               VARCHAR2 (200),
      claim_number       VARCHAR2 (200),
      policy_number      VARCHAR2 (200),
      clm_stat_cd        VARCHAR2 (2),
      in_hou_adj         VARCHAR2 (8),
      assured_name       VARCHAR2 (500),
      grp_seq_no         NUMBER (4),
      claim_id           NUMBER (12),
      line_cd            VARCHAR2 (2),
      item_no            NUMBER (9),
      peril_cd           NUMBER (5),
      hist_seq_no        NUMBER (3),
      trty_name          VARCHAR2 (30),
      item               VARCHAR2 (100),
      company_name       VARCHAR2 (200),
      company_add        VARCHAR2 (350),
      stat_desc          VARCHAR2 (500),
      peril_sname        VARCHAR2 (500),
      shr_loss_res_amt   NUMBER (16, 2),
      exp_shr_amt        NUMBER (16, 2),
      flag               VARCHAR2 (50)
   );

   TYPE giclr050b_record_tab IS TABLE OF giclr050b_record_type;

   TYPE giclr050b_subreport_type IS RECORD (
      line               VARCHAR2 (200),
      claim_number       VARCHAR2 (200),
      policy_number      VARCHAR2 (200),
      clm_stat_cd        VARCHAR2 (2),
      in_hou_adj         VARCHAR2 (8),
      assured_name       VARCHAR2 (500),
      grp_seq_no         NUMBER (4),
      claim_id           NUMBER (12),
      line_cd            VARCHAR2 (2),
      item_no            NUMBER (9),
      peril_cd           NUMBER (5),
      hist_seq_no        NUMBER (3),
      trty_name          VARCHAR2 (30),
      item               VARCHAR2 (100),
      company_name       VARCHAR2 (200),
      company_add        VARCHAR2 (350),
      stat_desc          VARCHAR2 (500),
      peril_sname        VARCHAR2 (500),
      shr_loss_res_amt   NUMBER (16, 2),
      exp_shr_amt        NUMBER (16, 2),
      flag               VARCHAR2 (50)
   );

   TYPE giclr050b_subreport_tab IS TABLE OF giclr050b_subreport_type;

   FUNCTION get_giclr050b_records (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN giclr050b_record_tab PIPELINED;

   FUNCTION get_giclr050b_subreport (
      p_line_cd         VARCHAR2,
      p_user_id         VARCHAR2,
      p_claim_id        NUMBER,
      p_policy_number   VARCHAR2
   ) RETURN giclr050b_subreport_tab PIPELINED;
   
   
END;
/


