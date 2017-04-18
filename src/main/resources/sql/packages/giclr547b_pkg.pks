CREATE OR REPLACE PACKAGE CPI.giclr547b_pkg
AS
   TYPE giclr547b_type IS RECORD (
      clm_stat_cd          VARCHAR2 (2),
      clm_stat_desc        VARCHAR2 (30),
      claim_id             NUMBER (12),
      assured_name         VARCHAR2 (500),
      intm_no              NUMBER (12),
      pol_iss_cd           VARCHAR2 (2),
      pol_eff_date         DATE,
      dsp_loss_date        DATE,
      clm_file_date        DATE,
      grouped_item_title   VARCHAR2 (50),
      control_cd           VARCHAR2 (50),
      control_type_cd      NUMBER (5),
      item_no              NUMBER (9),
      comp_name            VARCHAR2 (200),
      comp_add             VARCHAR2 (200),
      title                VARCHAR2 (50),
      as_date              VARCHAR2 (50),
      flag                 VARCHAR2 (10),
      clm_func             VARCHAR2 (20),
      peril_cd             NUMBER (5),
      loss_amt             NUMBER (16, 2),
      RETENTION            NUMBER (16, 2),
      treaty               NUMBER (16, 2),
      facultative          NUMBER (16, 2),
      xol                  NUMBER (16, 2)
   );

   TYPE giclr547b_tab IS TABLE OF giclr547b_type;

   FUNCTION get_giclr547b_records (
      p_clmstat_cd           VARCHAR2,
      p_clmstat_type         VARCHAR2,
      p_control_cd           VARCHAR2,
      p_control_type_cd      VARCHAR2,
      p_end_dt               VARCHAR2,
      p_grouped_item_title   VARCHAR2,
      p_loss_exp             VARCHAR2,
      p_start_dt             VARCHAR2,
      p_user_id              VARCHAR2
   )
      RETURN giclr547b_tab PIPELINED;

   FUNCTION get_giclr547b_total (
      p_clmstat_cd           VARCHAR2,
      p_clmstat_type         VARCHAR2,
      p_control_cd           VARCHAR2,
      p_control_type_cd      VARCHAR2,
      p_end_dt               VARCHAR2,
      p_grouped_item_title   VARCHAR2,
      p_loss_exp             VARCHAR2,
      p_start_dt             VARCHAR2,
      p_user_id              VARCHAR2
   )
      RETURN giclr547b_tab PIPELINED;
            
END;
/


