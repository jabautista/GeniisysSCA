CREATE OR REPLACE PACKAGE CPI.giclr546b_pkg
AS
   TYPE giclr546b_type IS RECORD (
      clm_stat_cd     VARCHAR2 (2),
      clm_stat_desc   VARCHAR2 (30),
      claim_id        NUMBER (12),
      policy_number   VARCHAR2 (250),
      assured_name    VARCHAR2 (500),
      intm_no         NUMBER (12),
      pol_iss_cd      VARCHAR2 (2),
      pol_eff_date    DATE,
      dsp_loss_date   DATE,
      clm_file_date   DATE,
      comp_name       VARCHAR2 (200),
      comp_add        VARCHAR2 (200),
      title           VARCHAR2 (50),
      as_date         VARCHAR2 (50),
      flag            VARCHAR2 (10),
      clm_func        VARCHAR2 (20),
      peril_cd        NUMBER (5),
      loss_amt        NUMBER (16, 2),
      RETENTION       NUMBER (16, 2),
      treaty          NUMBER (16, 2),
      facultative     NUMBER (16, 2),
      xol             NUMBER (16, 2)
   );

   TYPE giclr546b_tab IS TABLE OF giclr546b_type;

   TYPE giclr546b_claim_type IS RECORD (
      claim_id        NUMBER (12),
      policy_number   VARCHAR2 (250)
   );

   TYPE giclr546b_claim_tab IS TABLE OF giclr546b_claim_type;

   FUNCTION get_giclr546b_records (
      p_clmstat_cd     VARCHAR2,
      p_clmstat_type   VARCHAR2,
      p_end_dt         VARCHAR2,
      p_issue_yy       NUMBER,
      p_line_cd        VARCHAR2,
      p_loss_exp       VARCHAR2,
      p_pol_iss_cd     VARCHAR2,
      p_pol_seq_no     NUMBER,
      p_renew_no       NUMBER,
      p_start_dt       VARCHAR2,
      p_subline_cd     VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN giclr546b_tab PIPELINED;

   FUNCTION get_giclr546b_claim (
      p_clmstat_cd      VARCHAR2,
      p_clmstat_type    VARCHAR2,
      p_end_dt          VARCHAR2,
      p_issue_yy        NUMBER,
      p_line_cd         VARCHAR2,
      p_loss_exp        VARCHAR2,
      p_pol_iss_cd      VARCHAR2,
      p_pol_seq_no      NUMBER,
      p_renew_no        NUMBER,
      p_start_dt        VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_user_id         VARCHAR2
     
   )
      RETURN giclr546b_claim_tab PIPELINED;
END;
/


