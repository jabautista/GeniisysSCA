CREATE OR REPLACE PACKAGE CPI.giclr212_pkg
AS
   TYPE giclr212_record_type IS RECORD (
      line_cd         gicl_loss_profile.line_cd%TYPE,
      subline_cd      GICL_LOSS_PROFILE.SUBLINE_CD%TYPE,
      --modified by gab 03.15.2016
--      range_from      gicl_loss_profile.range_from%TYPE,
--      range_to        gicl_loss_profile.range_to%TYPE,
      range_to        VARCHAR2 (100),
      range_from        VARCHAR2 (100),
      --end
      policy_count    gicl_loss_profile.policy_count%TYPE,
      net_retention   gicl_loss_profile.net_retention%TYPE,
      quota_share     gicl_loss_profile.quota_share%TYPE,
      treaty          gicl_loss_profile.treaty%TYPE,
      total_tsi_amt   gicl_loss_profile.total_tsi_amt%TYPE,
      facultative     gicl_loss_profile.facultative%TYPE,
      gross_loss      NUMBER,
      xol_treaty      gicl_loss_profile.xol_treaty%TYPE,
      company_name    VARCHAR2 (100),
      title           VARCHAR2 (200),
      heading1        VARCHAR2 (100),
      heading2        VARCHAR2 (100),
      line_name       VARCHAR2 (20),
      cf_from         VARCHAR2 (1000),
      cf_to           NUMBER (16, 2),
      cf_line         VARCHAR (50),
      cf_subline      VARCHAR (100),
      mjm             VARCHAR2 (1)
   );

   TYPE giclr212_record_tab IS TABLE OF giclr212_record_type;
   
   FUNCTION get_giclr212_record (
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
      RETURN giclr212_record_tab PIPELINED;
END;
/


