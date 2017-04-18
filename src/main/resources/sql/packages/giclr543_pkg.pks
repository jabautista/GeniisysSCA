CREATE OR REPLACE PACKAGE CPI.giclr543_pkg
AS
   TYPE parent_record_type IS RECORD (
      line_cd           gicl_claims.line_cd%TYPE,
      iss_cd            gicl_claims.iss_cd%TYPE,
      claim_no          VARCHAR (50),
      policy_no         VARCHAR (50),
      dsp_loss_date     gicl_claims.dsp_loss_date%TYPE,
      clm_file_date     gicl_claims.clm_file_date%TYPE,
      pol_eff_date      gicl_claims.pol_eff_date%TYPE,
      subline_cd        gicl_claims.subline_cd%TYPE,
      pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
      issue_yy          gicl_claims.issue_yy%TYPE,
      pol_seq_no        gicl_claims.pol_seq_no%TYPE,
      renew_no          gicl_claims.renew_no%TYPE,
      assd_no           gicl_claims.assd_no%TYPE,
      parent_no         gicl_basic_intm_v1.intrmdry_intm_no%TYPE,
      parent_name       gicl_basic_intm_v1.intm_name%TYPE,
      intm_type         gicl_basic_intm_v1.intm_type%TYPE,
      claim_id          gicl_claims.claim_id%TYPE,
      clm_stat_cd       gicl_claims.clm_stat_cd%TYPE,
      old_stat_cd       gicl_claims.old_stat_cd%TYPE,
      close_date        gicl_claims.close_date%TYPE,
      company_name      VARCHAR2 (100),
      company_address   VARCHAR2 (200),
      title             VARCHAR (50),
      cf_date           VARCHAR (50),
      intm_desc         VARCHAR (50),
      cf_parent         VARCHAR (255),
      assd_name         VARCHAR (500),
      status            VARCHAR (50),
      cf_clm_amt        VARCHAR (50),
      v_print           VARCHAR (8)
   );

   TYPE parent_record_tab IS TABLE OF parent_record_type;

   TYPE claims_record_type IS RECORD (
        line_cd          gicl_claims.line_cd%TYPE,
        iss_cd           gicl_claims.iss_cd%TYPE,
        claim_no         VARCHAR (50),
        policy_no        VARCHAR (50),
        dsp_loss_date    gicl_claims.dsp_loss_date%TYPE,
        clm_file_date    gicl_claims.clm_file_date%TYPE,
        pol_eff_date     gicl_claims.pol_eff_date%TYPE,
        subline_cd       gicl_claims.subline_cd%TYPE,
        pol_iss_cd       gicl_claims.pol_iss_cd%TYPE,
        issue_yy         gicl_claims.issue_yy%TYPE,
        pol_seq_no       gicl_claims.pol_seq_no%TYPE,
        renew_no         gicl_claims.renew_no%TYPE,
        assd_no          gicl_claims.assd_no%TYPE,
        parent_no        gicl_basic_intm_v1.intrmdry_intm_no%TYPE,
        parent_name      gicl_basic_intm_v1.intm_name%TYPE,
        parent_intm_no   NUMBER,
        claim_id         gicl_claims.claim_id%TYPE,
        clm_stat_cd      gicl_claims.clm_stat_cd%TYPE,
        old_stat_cd      gicl_claims.old_stat_cd%TYPE,
        close_date       gicl_claims.close_date%TYPE,
        sub_name         VARCHAR (255),
        assd_name        VARCHAR (500),
        status           VARCHAR (50)
     );

     TYPE claims_record_tab IS TABLE OF claims_record_type; 
     
   TYPE peril_record_type IS RECORD (
      peril_cd                 giis_peril.peril_cd%TYPE,
      peril_sname              giis_peril.peril_sname%TYPE,
      claim_id                 gicl_item_peril.claim_id%TYPE,
      line_cd                  giis_peril.line_cd%TYPE,
      parent_loss_amt          NUMBER,
      parent_exp_amt           NUMBER,
      parent_retention         NUMBER,
      parent_exp_retention     NUMBER,
      parent_treaty            NUMBER,
      parent_exp_treaty        NUMBER,
      parent_xol               NUMBER,
      parent_exp_xol           NUMBER,
      parent_facultative       NUMBER,
      parent_exp_facultative   NUMBER
   );

   TYPE peril_record_tab IS TABLE OF peril_record_type;

   FUNCTION get_parent_record (
      p_start_dt       DATE,
      p_end_dt         DATE,
      p_intm_no        VARCHAR2,
      p_intermediary   VARCHAR2,
      p_loss_exp       VARCHAR2,
      p_intm_type      VARCHAR2,
      p_subagent       VARCHAR2,
      p_iss_cd         VARCHAR2,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN parent_record_tab PIPELINED;

  FUNCTION get_claims_record (
      p_start_dt       DATE,
      p_end_dt         DATE,
      p_intm_no        VARCHAR2,
      p_intermediary   VARCHAR2,
      p_loss_exp       VARCHAR2,
      p_intm_type      VARCHAR2,
      p_subagent       VARCHAR2,
      p_iss_cd         VARCHAR2,
      p_line_cd        VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN claims_record_tab PIPELINED; 
   FUNCTION get_peril_record (
      p_line_cd       VARCHAR2,
      p_claim_id      NUMBER,
      p_clm_stat_cd   VARCHAR2,
      p_loss_exp      VARCHAR2
   )
      RETURN peril_record_tab PIPELINED;
END;
/
