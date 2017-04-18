CREATE OR REPLACE PACKAGE CPI.giclr218_pkg
AS
   TYPE giclr218_record_type IS RECORD (
      range_from        gicl_loss_profile.range_from%TYPE,
      range_to          gicl_loss_profile.range_to%TYPE,
      line_cd           gicl_loss_profile_ext2.line_cd%TYPE,
      block_id          gicl_loss_profile_ext2.block_id%TYPE,
      risk_cd           gicl_loss_profile_ext2.risk_cd%TYPE,
      sum_insured       gicl_loss_profile_ext2.tsi_amt%TYPE,
      loss              gicl_loss_profile_ext3.loss_amt%TYPE,
      cnt_clm           gicl_loss_profile_ext.cnt_clm%TYPE,
      risk_desc         giis_risks.risk_desc%TYPE,
      company_name      VARCHAR2 (100),
      title             VARCHAR2 (200),
      heading1          VARCHAR2 (100),
      heading2          VARCHAR2 (100),
      cf_line           VARCHAR (100),
      mjm               VARCHAR2 (1)
   );

   TYPE giclr218_record_tab IS TABLE OF giclr218_record_type;

   FUNCTION get_giclr218_record (
      p_line_cd          VARCHAR2,
      p_starting_date    DATE,
      p_ending_date      DATE,
      p_user_id          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_param_date       VARCHAR2,
      p_claim_date       VARCHAR2,
      p_loss_date_from   DATE,
      p_loss_date_to     DATE,
      p_extract          NUMBER
   )
      RETURN giclr218_record_tab PIPELINED;
END;
/


