CREATE OR REPLACE PACKAGE CPI.giclr211_pkg
AS
   TYPE giclr211_record_type IS RECORD (
   --modified by gab 03.15.2016
--      range_from      gicl_loss_profile.range_from%TYPE,
--      range_to        gicl_loss_profile.range_to%TYPE,
--end
      range_to        VARCHAR2 (100),
      range_from        VARCHAR2 (100),
      line_cd         gicl_loss_profile.line_cd%TYPE,
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
      total_label     VARCHAR (20),
      cf_line         VARCHAR (50),
      mjm             VARCHAR2 (1)
   );

   TYPE giclr211_record_tab IS TABLE OF giclr211_record_type;

   FUNCTION get_giclr211_record (
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
      RETURN giclr211_record_tab PIPELINED;
END;
/


