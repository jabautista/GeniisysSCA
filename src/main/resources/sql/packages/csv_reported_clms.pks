CREATE OR REPLACE PACKAGE CPI.CSV_REPORTED_CLMS AS
/* Modified by Edison 02.29.2012
** Chaned PROCEDURE to FUNCTION
** Added TYPE rec_type IS RECORD to create a table using the records
** found in the function*/

--GICLR540
TYPE giclr540_rec_type IS RECORD(line_name      giis_line.line_name%TYPE,
                                 claim_no       varchar(100),
                                 policy_no      varchar(100),
                                 assured_name   gicl_claims.assured_name%TYPE,
                                 intm_name      giis_intermediary.intm_name%TYPE,
                                 pol_eff_date   gicl_claims.pol_eff_date%TYPE,
                                 dsp_loss_date  gicl_claims.dsp_loss_date%TYPE,
                                 clm_file_date  gicl_claims.clm_file_date%TYPE,
                                 status         VARCHAR(100),
                                 peril_sname    giis_peril.peril_sname%TYPE,
                                 loss_amt       gicl_clm_res_hist.loss_reserve%TYPE,
                                 net_ret        gicl_loss_exp_ds.SHR_LE_NET_AMT%TYPE,
                                 trty           gicl_loss_exp_ds.SHR_LE_NET_AMT%TYPE,
                                 xol            gicl_loss_exp_ds.SHR_LE_NET_AMT%TYPE,
                                 facul          gicl_loss_exp_ds.SHR_LE_NET_AMT%TYPE); 
TYPE giclr540_type IS TABLE OF giclr540_rec_type;
  
--GICLR541
TYPE giclr541_rec_type IS RECORD(line_name      giis_line.line_name%TYPE,
                                 cnt            NUMBER(8),
                                 loss_amt_line  GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE,
                                 net_ret_line   GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
                                 trty_line      GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
                                 xol_line       GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
                                 facul_line     GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE);
TYPE giclr541_type IS TABLE OF giclr541_rec_type; 

--GICLR544
TYPE giclr544_rec_type IS RECORD(branch          GIIS_ISSOURCE.ISS_NAME%TYPE,
                                 line_name       GIIS_LINE.LINE_NAME%TYPE,
                                 claim_no        VARCHAR2(100),
                                 policy_no       VARCHAR2(100),
                                 assured_name    GIIS_ASSURED.ASSD_NAME%TYPE,
                                 intm            VARCHAR2(300),
                                 pol_eff_date    DATE,
                                 dsp_loss_date   DATE,
                                 clm_file_date   DATE,
                                 status          VARCHAR2(100),
                                 peril_sname     giis_peril.peril_sname%TYPE,
                                 loss_amt        GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE,
                                 net_ret         GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
                                 trty            GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
                                 xol             GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
                                 facul           GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
                                 payee_type      VARCHAR2(2));
TYPE giclr544_type IS TABLE OF giclr544_rec_type;

--giclr544b
TYPE giclr544b_rec_type IS RECORD(branch         GIIS_ISSOURCE.ISS_NAME%TYPE,
                                  cnt            NUMBER(8),
                                  loss_amt_line  GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE,
                                  net_ret_line   GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
                                  trty_line      GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
                                  xol_line       GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
                                  facul_line     GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE);
TYPE giclr544b_type IS TABLE OF giclr544b_rec_type;

--giclr543
TYPE giclr543_rec_type IS RECORD(intm_type          VARCHAR2(50),
                                 intm_name          giis_intermediary.intm_name%TYPE,
                                 subagent_name      VARCHAR2(1000),
                                 claim_no           VARCHAR2(100),
                                 policy_no          VARCHAR2(100),
                                 assured_name       GIIS_ASSURED.assd_name%TYPE,
                                 pol_eff_date       DATE,
                                 dsp_loss_date      DATE,
                                 clm_file_date      DATE,
                                 status             VARCHAR(100),
                                 peril_sname        GIIS_PERIL.peril_name%TYPE,
                                 loss_amt           GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE,
                                 net_ret            GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
                                 trty               GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
                                 xol                GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
                                 facul              GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE);
TYPE giclr543_type IS TABLE OF giclr543_rec_type;  

   --kenneth SR 17610 08122015
   TYPE giclr542b_rec_type IS RECORD(
      assured        VARCHAR2(600),
      cnt            NUMBER(8),
      loss_amt       GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE,
      net_ret        GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
      trty           GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
      xol            GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
      facul          GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE);
   TYPE giclr542b_type IS TABLE OF giclr542b_rec_type;  
   
   --kenneth SR 17610 08122015
   TYPE giclr542_rec_type IS RECORD(
      assured        VARCHAR2(600),
      claim_no       VARCHAR2(100),
      policy_no      VARCHAR2(100),
      cf_intm        VARCHAR2 (1000),
      eff_date       VARCHAR2(50),
      loss_date      VARCHAR2(50),
      file_date      VARCHAR2(50),
      status         VARCHAR2(50),
      peril_sname    giis_peril.peril_sname%TYPE,
      claim_amt       GICL_CLM_RES_HIST.LOSS_RESERVE%TYPE,
      net_ret        GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
      trty           GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
      xol            GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
      facul          GICL_RESERVE_DS.SHR_LOSS_RES_AMT%TYPE,
      payee_type     VARCHAR2(1)
   );
   TYPE giclr542_type IS TABLE OF giclr542_rec_type;

  FUNCTION CSV_GICLR540(p_line_cd        VARCHAR2,
                         p_iss_cd         VARCHAR2,
                         p_start_dt       DATE,
                         p_end_dt         DATE,
                         p_loss_exp       VARCHAR2)
                      --   p_file_name      VARCHAR2)
                         RETURN giclr540_type PIPELINED;--added 02.29.2012
  FUNCTION CSV_GICLR541(p_line_cd        VARCHAR2,
                         p_iss_cd         VARCHAR2,
                         p_start_dt       DATE,
                         p_end_dt         DATE,
                         p_loss_exp       VARCHAR2)
                        -- p_file_name      VARCHAR2) 
                         RETURN giclr541_type PIPELINED;--added 02.29.2012
  FUNCTION CSV_GICLR544(p_line_cd        VARCHAR2,
                         p_iss_cd         VARCHAR2,
                         p_start_dt       DATE,
                         p_end_dt         DATE,
                         p_loss_exp       VARCHAR2)
                      --   p_file_name      VARCHAR2) 
                         RETURN giclr544_type PIPELINED;--added 02.29.2012
  FUNCTION CSV_GICLR544B(p_line_cd        VARCHAR2,
                         p_iss_cd         VARCHAR2,
                         p_start_dt       DATE,
                         p_end_dt         DATE,
                         p_loss_exp       VARCHAR2)
                         -- p_file_name      VARCHAR2) 
                          RETURN giclr544B_type PIPELINED;--added 02.29.2012                          
  FUNCTION CSV_GICLR543(p_intm_no        NUMBER,
                         p_start_dt       DATE,
                         p_end_dt         DATE,
                         p_loss_exp       VARCHAR2)
                      --   p_file_name      VARCHAR2)
                         RETURN giclr543_type PIPELINED; 

   --kenneth SR 17610 08122015
   FUNCTION CSV_GICLR542B(
      p_assd_no    NUMBER,
      p_assured    VARCHAR2,
      p_end_dt     VARCHAR2,
      p_iss_cd     VARCHAR2,
      p_line_cd    VARCHAR2,
      p_loss_exp   VARCHAR2,
      p_start_dt   VARCHAR2,
      p_user_id    VARCHAR2
   ) 
   RETURN giclr542B_type PIPELINED;
   
   --kenneth SR 17610 08122015
   FUNCTION CSV_GICLR542(
      p_assd_no    NUMBER,
      p_assured    VARCHAR2,
      p_branch_cd  VARCHAR2,
      p_end_dt     VARCHAR2,
      p_iss_cd     VARCHAR2,
      p_line_cd    VARCHAR2,
      p_loss_exp   VARCHAR2,
      p_start_dt   VARCHAR2,
      p_user_id    VARCHAR2
   ) 
   RETURN giclr542_type PIPELINED;
                         
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
END;
--end of modification Edison 02.29.2012
/


