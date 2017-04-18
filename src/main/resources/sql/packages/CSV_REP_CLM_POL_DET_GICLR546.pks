CREATE OR REPLACE PACKAGE cpi.csv_rep_clm_pol_det_giclr546
AS
   TYPE loss_report_type IS RECORD (
      policy_number             VARCHAR2 (100),
      claim_number              VARCHAR2 (100),
      intermediary_cedant       VARCHAR2 (240),
      eff_date                  VARCHAR2 (20),
      loss_date                 VARCHAR2 (20),
      file_date                 VARCHAR2 (20),
      status                    giis_clm_stat.clm_stat_desc%TYPE,
      peril                     giis_peril.peril_name%TYPE,
      loss_amount               VARCHAR2 (20),
      RETENTION                 VARCHAR2 (20),
      proportional_treaty       VARCHAR2 (20),
      non_proportional_treaty   VARCHAR2 (20),
      facultative               VARCHAR2 (20)
   );

   TYPE loss_report_tab IS TABLE OF loss_report_type;

   TYPE expense_report_type IS RECORD (
      policy_number             VARCHAR2 (100),
      claim_number              VARCHAR2 (100),
      intermediary_cedant       VARCHAR2 (240),
      eff_date                  VARCHAR2 (20),
      loss_date                 VARCHAR2 (20),
      file_date                 VARCHAR2 (20),
      status                    giis_clm_stat.clm_stat_desc%TYPE,
      peril                     giis_peril.peril_name%TYPE,
      expense_amount            VARCHAR2 (20),
      RETENTION                 VARCHAR2 (20),
      proportional_treaty       VARCHAR2 (20),
      non_proportional_treaty   VARCHAR2 (20),
      facultative               VARCHAR2 (20)
   );

   TYPE expense_report_tab IS TABLE OF expense_report_type;

   TYPE claim_report_type IS RECORD (
      policy_number             VARCHAR2 (100),
      claim_number              VARCHAR2 (100),
      intermediary_cedant       VARCHAR2 (240),
      eff_date                  VARCHAR2 (20),
      loss_date                 VARCHAR2 (20),
      file_date                 VARCHAR2 (20),
      status                    giis_clm_stat.clm_stat_desc%TYPE,
      peril                     giis_peril.peril_name%TYPE,
      claim_amount              VARCHAR2 (20),
      RETENTION                 VARCHAR2 (20),
      proportional_treaty       VARCHAR2 (20),
      non_proportional_treaty   VARCHAR2 (20),
      facultative               VARCHAR2 (20)
   );

   TYPE claim_report_tab IS TABLE OF claim_report_type;

   FUNCTION csv_giclr546_l (
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
      RETURN loss_report_tab PIPELINED;

   FUNCTION csv_giclr546_e (
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
      RETURN expense_report_tab PIPELINED;

   FUNCTION csv_giclr546_le (
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
      RETURN claim_report_tab PIPELINED;
END;
/