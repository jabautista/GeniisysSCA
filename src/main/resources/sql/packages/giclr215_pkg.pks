CREATE OR REPLACE PACKAGE CPI.giclr215_pkg
AS
   TYPE giclr215_record_type IS RECORD (
      --modified by gab 03.15.2016
--      range_from      gicl_loss_profile.range_from%TYPE,
--      range_to        gicl_loss_profile.range_to%TYPE,
      range_to        VARCHAR2 (100),
      range_from        VARCHAR2 (100),
      --end
      tsi_amt           gicl_loss_profile_ext2.tsi_amt%TYPE,
      line_cd           gicl_loss_profile.line_cd%TYPE,
      subline_cd        gicl_loss_profile.subline_cd%TYPE,
      policy_no         VARCHAR (50),
      claim_no          VARCHAR (50),
      clm_stat_cd       gicl_claims.clm_stat_cd%TYPE,
      assured_name      gicl_claims.assured_name%TYPE,
      clm_file_date     gicl_claims.clm_file_date%TYPE,
      loss_date         gicl_claims.loss_date%TYPE,
      claim_id          gicl_claims.claim_id%TYPE,
      company_name      VARCHAR2 (100),
      company_address   VARCHAR2 (100),
      title             VARCHAR2 (200),
      heading1          VARCHAR2 (100),
      heading2          VARCHAR2 (100),
      cf_line           VARCHAR (100),
      cf_subline        VARCHAR (100),
      net_retention     NUMBER,
      treaty            NUMBER,
      xol               NUMBER,
      facul             NUMBER,
      gross_loss        NUMBER,
      mjm               VARCHAR2 (1)
   );

   TYPE giclr215_record_tab IS TABLE OF giclr215_record_type;

   TYPE recovery_record_type IS RECORD (
      recovery_id         gicl_clm_recovery.recovery_id%TYPE,
      claim_id            gicl_clm_recovery.claim_id%TYPE,
      rec                 VARCHAR2 (50),
      rec_net_retention   NUMBER,
      rec_treaty          NUMBER,
      rec_xol             NUMBER,
      rec_facul           NUMBER,
      rec_gross_loss      NUMBER
   );

   TYPE recovery_record_tab IS TABLE OF recovery_record_type;

   FUNCTION get_giclr215_record (
      p_line_cd          VARCHAR2,
      p_starting_date    DATE,
      p_ending_date      DATE,
      p_user_id          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_param_date       VARCHAR2,
      p_claim_date       VARCHAR2,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_extract          NUMBER,
      p_loss_sw          VARCHAR2
   )
      RETURN giclr215_record_tab PIPELINED;

   FUNCTION get_recovery_record (
      p_claim_id         NUMBER,
      p_loss_sw          VARCHAR2,
      p_clm_file_date    DATE,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_loss_date        DATE,
      p_line_cd          VARCHAR2
   )
      RETURN recovery_record_tab PIPELINED;
END;
/


