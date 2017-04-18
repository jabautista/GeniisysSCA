CREATE OR REPLACE PACKAGE CPI.giclr544b_pkg
AS
   TYPE giclr544b_type IS RECORD (
      line_cd         VARCHAR2 (2),
      line_cd1        VARCHAR2 (2),
      iss_cd          VARCHAR2 (2),
      claim_no        VARCHAR2 (250),
      policy_no       VARCHAR2 (250),
      dsp_loss_date   DATE,
      clm_file_date   DATE,
      pol_eff_date    DATE,
      subline_cd      VARCHAR2 (7),
      pol_iss_cd      VARCHAR2 (2),
      issue_yy        NUMBER (2),
      pol_seq_no      NUMBER (7),
      renew_no        NUMBER (2),
      assured_name    VARCHAR2 (500),
      claim_id        NUMBER (12),
      claim_id1       NUMBER (12),
      clm_stat_cd     VARCHAR2 (2),
      old_stat_cd     VARCHAR2 (2),
      close_date      DATE,
      flag            VARCHAR2 (50),
      comp_name       VARCHAR2 (200),
      comp_add        VARCHAR2 (200),
      title           VARCHAR2 (50),
      as_date         VARCHAR2 (50),
      branch_name     VARCHAR2 (20),
      clm_func        VARCHAR2 (20),
      peril_cd        NUMBER (5),
      peril_sname     VARCHAR2 (5),
      loss_amt        NUMBER (16, 2),
      RETENTION       NUMBER (16, 2),
      treaty          NUMBER (16, 2),
      facultative     NUMBER (16, 2),
      xol             NUMBER (16, 2)
   );

   TYPE giclr544b_tab IS TABLE OF giclr544b_type;

   TYPE giclr544b_claim_type IS RECORD (
      line_cd         VARCHAR2 (2),
      iss_cd          VARCHAR2 (2),
      claim_no        VARCHAR2 (250),
      policy_no       VARCHAR2 (250),
      dsp_loss_date   DATE,
      clm_file_date   DATE,
      pol_eff_date    DATE,
      subline_cd      VARCHAR2 (7),
      pol_iss_cd      VARCHAR2 (2),
      issue_yy        NUMBER (2),
      pol_seq_no      NUMBER (7),
      renew_no        NUMBER (2),
      assured_name    VARCHAR2 (500),
      claim_id        NUMBER (12),
      clm_stat_cd     VARCHAR2 (2),
      old_stat_cd     VARCHAR2 (2),
      close_date      DATE
   );

   TYPE giclr544b_claim_tab IS TABLE OF giclr544b_claim_type;

   FUNCTION get_giclr544b_records (
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_end_dt      VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_line        VARCHAR2,
      p_line_cd     VARCHAR2,
      p_loss_exp    VARCHAR2,
      p_start_dt    VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giclr544b_tab PIPELINED;

   FUNCTION get_giclr544b_claim (
      p_claim_id    NUMBER,
      p_branch_cd   VARCHAR2,
      p_line_cd     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_start_dt    VARCHAR2,
      p_end_dt      VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giclr544b_claim_tab PIPELINED;
END;
/


