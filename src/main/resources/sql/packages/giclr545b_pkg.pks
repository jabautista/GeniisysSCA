CREATE OR REPLACE PACKAGE CPI.giclr545b_pkg
AS
   TYPE giclr545b_record_type IS RECORD (
      clm_stat_cd       gicl_claims.clm_stat_cd%TYPE,
      clm_stat_desc     giis_clm_stat.clm_stat_desc%TYPE,
      claim_id          gicl_claims.claim_id%TYPE,
      claim_number      VARCHAR (50),
      policy_number     VARCHAR (50),
      assured_name      gicl_claims.assured_name%TYPE,
      intm_no           gicl_claims.intm_no%TYPE,
      pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
      pol_eff_date      gicl_claims.pol_eff_date%TYPE,
      dsp_loss_date     gicl_claims.dsp_loss_date%TYPE,
      clm_file_date     gicl_claims.clm_file_date%TYPE,
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      title             VARCHAR2 (50),
      cf_date           VARCHAR2 (50),
      mjm               VARCHAR2 (1),
      cf_clm_amt        VARCHAR2 (30)
   );

   TYPE giclr545b_record_tab IS TABLE OF giclr545b_record_type;

   TYPE peril_record_type IS RECORD (
      claim_id        gicl_item_peril.claim_id%TYPE,
      peril_cd        giis_peril.peril_cd%TYPE,
      loss_amt        NUMBER,
      RETENTION       NUMBER,
      treaty          NUMBER,
      xol             NUMBER,
      facul           NUMBER,
      clm_stat_cd     gicl_claims.clm_stat_cd%TYPE,
      clm_stat_desc   giis_clm_stat.clm_stat_desc%TYPE
   );

   TYPE peril_record_tab IS TABLE OF peril_record_type;

   FUNCTION get_giclr545b_record (
      p_clm_stat_cd     VARCHAR2,
      p_clm_stat_type   VARCHAR2,
      p_start_dt        DATE,
      p_end_dt          DATE,
      p_loss_exp        VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN giclr545b_record_tab PIPELINED;

   FUNCTION get_peril_record (
      p_claim_id        gicl_claims.claim_id%TYPE,
      p_loss_exp        VARCHAR2,
      p_clm_stat_cd     gicl_claims.clm_stat_cd%TYPE,
      p_user_id         VARCHAR2,
      p_clm_stat_type   VARCHAR2,
      p_start_dt        DATE,
      p_end_dt          DATE
   )
      RETURN peril_record_tab PIPELINED;
END;
/


