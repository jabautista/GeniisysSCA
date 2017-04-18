CREATE OR REPLACE PACKAGE CPI.giclr544_pkg
AS
   TYPE giclr544_type IS RECORD (
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
      close_date      DATE,
      flag            VARCHAR2 (50),
      comp_name       VARCHAR2 (200),
      comp_add        VARCHAR2 (200),
      title           VARCHAR2 (50),
      as_date         VARCHAR2 (50),
      branch_name     VARCHAR2 (20),
      line_name       VARCHAR2 (20),
      intm            VARCHAR2 (240),
      clm_stat        VARCHAR2 (50),
      clm_func        VARCHAR2 (20)
   );

   TYPE giclr544_tab IS TABLE OF giclr544_type;
--added by MarkS 11.23.2016 SR5844 OPTIMIZATION 
-------------------------------------------------   
   TYPE giclr544_type2 IS RECORD ( --added by MarkS 11.23.2016 SR5844 OPTIMIZATION 
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
      close_date      DATE,
      flag            VARCHAR2 (50),
      comp_name       VARCHAR2 (200),
      comp_add        VARCHAR2 (200),
      title           VARCHAR2 (50),
      as_date         VARCHAR2 (50),
      branch_name     VARCHAR2 (20),
      line_name       VARCHAR2 (20),
      intm            VARCHAR2 (240),
      clm_stat        VARCHAR2 (50),
      clm_func        VARCHAR2 (20),
      payee_type      VARCHAR2(2),
      branch          GIIS_ISSOURCE.ISS_NAME%TYPE,
      status          VARCHAR2(100),
      peril_sname     giis_peril.peril_sname%TYPE,
      loss_amt        GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE,
      net_ret         NUMBER (16, 2),
      trty            NUMBER (16, 2),
      xol             NUMBER (16, 2),
      facul           NUMBER (16, 2),
      exp_loss_amt    NUMBER (16, 2),
      exp_net_ret     NUMBER (16, 2),
      exp_trty        NUMBER (16, 2),
      exp_xol         NUMBER (16, 2),
      exp_facul       NUMBER (16, 2) 
   );

   TYPE giclr544_tab2 IS TABLE OF giclr544_type2; --added by MarkS 11.23.2016 SR5844 OPTIMIZATION 
-------------------------------------------------   
--END by MarkS 11.23.2016 SR5844 OPTIMIZATION  
   TYPE giclr544_peril_type IS RECORD (
      iss_cd            VARCHAR2 (2),
      line_cd           VARCHAR2 (2),
      clm_stat_cd       VARCHAR2 (2),
      claim_id          NUMBER (12),
      peril_cd          NUMBER (5),
      peril_sname       VARCHAR2 (5),
      loss_amt          NUMBER (16, 2),
      exp_amt           NUMBER (16, 2),
      RETENTION         NUMBER (16, 2),
      exp_retention     NUMBER (16, 2),
      treaty            NUMBER (16, 2),
      exp_treaty        NUMBER (16, 2),
      xol               NUMBER (16, 2),
      exp_sol           NUMBER (16, 2),
      facultative       NUMBER (16, 2),
      exp_facultative   NUMBER (16, 2)
   );

   TYPE giclr544_peril_tab IS TABLE OF giclr544_peril_type;

   TYPE giclr544_line_tot_type IS RECORD (
      count_claim_id    NUMBER (10),
      claim_no          VARCHAR2 (250),
      policy_no         VARCHAR2 (250),
      dsp_loss_date     DATE,
      clm_file_date     DATE,
      pol_eff_date      DATE,
      subline_cd        VARCHAR2 (7),
      pol_iss_cd        VARCHAR2 (2),
      issue_yy          NUMBER (2),
      pol_seq_no        NUMBER (7),
      renew_no          NUMBER (2),
      assured_name      VARCHAR2 (500),
      old_stat_cd       VARCHAR2 (2),
      close_date        DATE,
      branch_name       VARCHAR2 (20),
      line_name         VARCHAR2 (20),
      intm              VARCHAR2 (240),
      clm_stat          VARCHAR2 (50),
      iss_cd            VARCHAR2 (2),
      line_cd           VARCHAR2 (2),
      line_cd2          VARCHAR2 (2),
      clm_stat_cd       VARCHAR2 (2),
      claim_id          NUMBER (12),
      claim_id2         NUMBER (12),
      peril_cd          NUMBER (5),
      peril_sname       VARCHAR2 (5),
      loss_amt          NUMBER (16, 2),
      exp_amt           NUMBER (16, 2),
      RETENTION         NUMBER (16, 2),
      exp_retention     NUMBER (16, 2),
      treaty            NUMBER (16, 2),
      exp_treaty        NUMBER (16, 2),
      xol               NUMBER (16, 2),
      exp_sol           NUMBER (16, 2),
      facultative       NUMBER (16, 2),
      exp_facultative   NUMBER (16, 2)
   );

   TYPE giclr544_line_tot_tab IS TABLE OF giclr544_line_tot_type;

   FUNCTION get_giclr544_records (
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
      RETURN giclr544_tab PIPELINED;
--added by MarkS 11.23.2016 SR5844 OPTIMIZATION 
-------------------------------------------------
FUNCTION get_giclr544_records2 (
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
      RETURN giclr544_tab2 PIPELINED;
-------------------------------------------------   
--END by MarkS 11.23.2016 SR5844 OPTIMIZATION          
   FUNCTION get_giclr544_peril_records (
      p_claim_id      NUMBER,
      p_line_cd       VARCHAR2,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN giclr544_peril_tab PIPELINED;

   FUNCTION get_giclr544_line_tot (
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
      RETURN giclr544_line_tot_tab PIPELINED;
--added by MarkS 11.23.2016 SR5844 OPTIMIZATION 
-------------------------------------------------
    FUNCTION AMOUNT_PER_SHARE_TYPE(p_claim_id     gicl_claims.claim_id%TYPE,
                                 p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
                                 p_share_type   gicl_loss_exp_ds.share_type%TYPE,
                                 p_loss_exp     VARCHAR2,
                                 p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE)
                                 RETURN NUMBER;     
    FUNCTION get_loss_amt(p_claim_id     gicl_claims.claim_id%TYPE,
                        p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
                        p_loss_exp     VARCHAR2,
                        p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE)
                        RETURN NUMBER; 
    FUNCTION get_amount_per_item_peril(p_claim_id     gicl_claims.claim_id%TYPE,
                                     p_item_no      gicl_loss_exp_ds.item_no%TYPE,
                                     p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
                                     p_share_type   gicl_loss_exp_ds.share_type%TYPE,
                                     p_loss_exp     VARCHAR2,
                                     p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE)
                                     RETURN NUMBER;
    FUNCTION get_loss_amount_per_item_peril(p_claim_id     gicl_claims.claim_id%TYPE,
                                          p_item_no      gicl_loss_exp_ds.item_no%TYPE,
                                          p_peril_cd     gicl_loss_exp_ds.peril_cd%TYPE,
                                          p_loss_exp     VARCHAR2,
                                          p_clm_stat_cd  gicl_claims.clm_stat_cd%TYPE)
                                          RETURN NUMBER; 
-------------------------------------------------   
--END by MarkS 11.23.2016 SR5844 OPTIMIZATION        
END;
/