CREATE OR REPLACE PACKAGE CPI.giclr214_pkg
AS
   TYPE giclr214_type IS RECORD (
      line_cd           VARCHAR2 (2),
      subline_cd        VARCHAR2 (7),
      range_from1       VARCHAR2 (100),
      range_to1         NUMBER (16, 2),
      policy_count      NUMBER (6),
      total_tsi_amt     NUMBER (20, 2),
      gross_loss        NUMBER (16, 2),
      net_retention     NUMBER (16, 2),
      nr_tsi            NUMBER (16, 2),
      secnr_tsi         NUMBER (16, 2),
      secnr_loss        NUMBER (16, 2),
      facultative       NUMBER (16, 2),
      facultative_tsi   NUMBER (16, 2),
      treaty            NUMBER (16, 2),
      treaty_tsi        NUMBER (16, 2),
      treaty1_loss      NUMBER (12, 2),
      treaty2_loss      NUMBER (12, 2),
      treaty2_tsi       NUMBER (16, 2),
      treaty3_loss      NUMBER (12, 2),
      treaty3_tsi       NUMBER (16, 2),
      treaty4_loss      NUMBER (12, 2),
      treaty4_tsi       NUMBER (16, 2),
      treaty5_loss      NUMBER (12, 2),
      treaty5_tsi       NUMBER (16, 2),
      treaty6_loss      NUMBER (12, 2),
      treaty6_tsi       NUMBER (16, 2),
      treaty7_loss      NUMBER (12, 2),
      treaty7_tsi       NUMBER (16, 2),
      treaty8_loss      NUMBER (12, 2),
      treaty8_tsi       NUMBER (16, 2),
      treaty9_loss      NUMBER (12, 2),
      treaty9_tsi       NUMBER (16, 2),
      treaty10_loss     NUMBER (12, 2),
      treaty10_tsi      NUMBER (16, 2),
      treaty1_cd        NUMBER (3),
      treaty2_cd        NUMBER (3),
      treaty3_cd        NUMBER (3),
      treaty4_cd        NUMBER (3),
      treaty5_cd        NUMBER (3),
      treaty6_cd        NUMBER (3),
      treaty7_cd        NUMBER (3),
      treaty8_cd        NUMBER (3),
      treaty9_cd        NUMBER (3),
      treaty10_cd       NUMBER (3),
      nr_cnt            NUMBER (6),
      facultative_cnt   NUMBER (6),
      treaty_cnt        NUMBER (6),
      treaty2_cnt       NUMBER (6),
      treaty3_cnt       NUMBER (6),
      treaty4_cnt       NUMBER (6),
      treaty5_cnt       NUMBER (6),
      treaty6_cnt       NUMBER (6),
      treaty7_cnt       NUMBER (6),
      treaty8_cnt       NUMBER (6),
      treaty9_cnt       NUMBER (6),
      treaty10_cnt      NUMBER (6),
      quota_share       NUMBER (16, 2),
      qs_tsi            NUMBER (16, 2),
      flag              VARCHAR2 (10),
      comp_name         VARCHAR2 (100),
      title             VARCHAR2 (200),
      heading           VARCHAR2 (100),
      heading2          VARCHAR2 (100),
      linecd            VARCHAR2 (10),
      line_name         VARCHAR2 (20),
      subline_name      VARCHAR2 (50),
      range_to          VARCHAR2 (50),
      range_from        VARCHAR2 (50),
      sec_netret_func   NUMBER (22),
      treaty1_func      VARCHAR2 (500),
      treaty2_func      VARCHAR2 (500),
      treaty3_func      VARCHAR2 (500),
      treaty4_func      VARCHAR2 (500),
      treaty5_func      VARCHAR2 (500),
      treaty6_func      VARCHAR2 (500),
      treaty7_func      VARCHAR2 (500),
      treaty8_func      VARCHAR2 (500),
      treaty9_func      VARCHAR2 (500),
      treaty10_func     VARCHAR2 (500),
      trty1_amt_func    NUMBER (22),
      trty2_amt_func    NUMBER (22),
      trty3_amt_func    NUMBER (22),
      trty4_amt_func    NUMBER (22),
      trty5_amt_func    NUMBER (22),
      trty6_amt_func    NUMBER (22),
      trty7_amt_func    NUMBER (22),
      trty8_amt_func    NUMBER (22),
      trty9_amt_func    NUMBER (22),
      trty10_amt_func   NUMBER (22),
      quota_sh          NUMBER (20),
      cf_range          VARCHAR2 (100) --gab
   );

   TYPE giclr214_tab IS TABLE OF giclr214_type;

   FUNCTION get_giclr214_record (
      p_claim_date       VARCHAR2,
      p_ending_date      VARCHAR2,
      p_extract          NUMBER,
      p_line             VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_param_date       VARCHAR2,
      p_starting_date    VARCHAR2,
      p_subline          VARCHAR2,
      p_user             VARCHAR2
   )
      RETURN giclr214_tab PIPELINED;
END;
/


