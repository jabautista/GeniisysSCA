CREATE OR REPLACE PACKAGE CPI.giclr213_pkg
AS
   TYPE giclr213_record_type IS RECORD (
      line_cd           gicl_loss_profile.line_cd%TYPE,
      total_tsi_amt     gicl_loss_profile.total_tsi_amt%TYPE,
      gross_loss        NUMBER,
      --modified by gab 03.15.2016
--      range_from      gicl_loss_profile.range_from%TYPE,
--      range_to        gicl_loss_profile.range_to%TYPE,
      range_to        VARCHAR2 (100),
      range_from        VARCHAR2 (100),
      --end
      policy_count      gicl_loss_profile.policy_count%TYPE,
      net_retention     gicl_loss_profile.net_retention%TYPE,
      nr_tsi            gicl_loss_profile.net_retention_tsi%TYPE,
      secnr_tsi         gicl_loss_profile.sec_net_retention_tsi%TYPE,
      secnr_loss        gicl_loss_profile.sec_net_retention_loss%TYPE,
      facultative       gicl_loss_profile.facultative%TYPE,
      facultative_tsi   gicl_loss_profile.facultative_tsi%TYPE,
      treaty            gicl_loss_profile.treaty%TYPE,
      treaty1_loss      gicl_loss_profile.treaty1_loss%TYPE,
      treaty2_loss      gicl_loss_profile.treaty2_loss%TYPE,
      treaty3_loss      gicl_loss_profile.treaty3_loss%TYPE,
      treaty4_loss      gicl_loss_profile.treaty4_loss%TYPE,
      treaty5_loss      gicl_loss_profile.treaty5_loss%TYPE,
      treaty6_loss      gicl_loss_profile.treaty6_loss%TYPE,
      treaty7_loss      gicl_loss_profile.treaty7_loss%TYPE,
      treaty8_loss      gicl_loss_profile.treaty8_loss%TYPE,
      treaty9_loss      gicl_loss_profile.treaty9_loss%TYPE,
      treaty10_loss     gicl_loss_profile.treaty10_loss%TYPE,
      nr_cnt            gicl_loss_profile.net_retention_cnt%TYPE,
      facultative_cnt   gicl_loss_profile.facultative_cnt%TYPE,
      quota_share       gicl_loss_profile.quota_share%TYPE,
      qs_tsi            gicl_loss_profile.quota_share_tsi%TYPE,
      cf_treaty1        VARCHAR2 (70),
      cf_treaty2        VARCHAR2 (70),
      cf_treaty3        VARCHAR2 (70),
      cf_treaty4        VARCHAR2 (70),
      cf_treaty5        VARCHAR2 (70),
      cf_treaty6        VARCHAR2 (70),
      cf_treaty7        VARCHAR2 (70),
      cf_treaty8        VARCHAR2 (70),
      cf_treaty9        VARCHAR2 (70),
      cf_treaty10       VARCHAR2 (70),
      sec_net_amt       NUMBER,
      treaty1_amt       NUMBER,
      treaty2_amt       NUMBER,
      treaty3_amt       NUMBER,
      treaty4_amt       NUMBER,
      treaty5_amt       NUMBER,
      treaty6_amt       NUMBER,
      treaty7_amt       NUMBER,
      treaty8_amt       NUMBER,
      treaty9_amt       NUMBER,
      treaty10_amt      NUMBER,
      quota_sh          NUMBER,
      company_name      VARCHAR2 (100),
      title             VARCHAR2 (200),
      heading1          VARCHAR2 (100),
      heading2          VARCHAR2 (100),
      cf_from           VARCHAR2 (1000),
      cf_to             NUMBER (16, 2),
      cf_line           VARCHAR (50),
      mjm               VARCHAR2 (1),
      cf_range          VARCHAR2 (100) --gab
   );

   TYPE giclr213_record_tab IS TABLE OF giclr213_record_type;

   FUNCTION get_giclr213_record (
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
      RETURN giclr213_record_tab PIPELINED;
END;
/


