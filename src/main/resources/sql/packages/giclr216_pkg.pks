CREATE OR REPLACE PACKAGE CPI.giclr216_pkg
AS
   TYPE giclr216_type IS RECORD (
      line_cd        VARCHAR2 (2),
      subline_cd     VARCHAR2 (7),
      --modified by gab 03.16.2016
--      range_from     NUMBER (16, 2),
--      range_to       NUMBER (16, 2),
      range_to        VARCHAR2 (100),
      range_from        VARCHAR2 (100),
      --end
      loss_amt       NUMBER (16, 2),
      close_sw       VARCHAR2 (1),
      pol            VARCHAR2 (200),
      clm            VARCHAR2 (200),
      clm_stat_cd    VARCHAR2 (2),
      assured_name   VARCHAR2 (500),
      loss_date      DATE,
      claim_id       NUMBER (12),
      flag           VARCHAR2 (10),
      comp_name      VARCHAR2 (100),
      comp_add       VARCHAR2 (500),
      title          VARCHAR2 (200),
      heading        VARCHAR2 (200),
      line_name      VARCHAR2 (100),
      sub_name       VARCHAR2 (200),
      recovery_id    NUMBER (12),
      rec            VARCHAR2 (200),
      claim_id1      NUMBER (12),
      net_reten      NUMBER (16, 2),
      treaty         NUMBER (16, 2),
      xol            NUMBER (16, 2),
      facultative    NUMBER (16, 2),
      net_ret_rec    NUMBER (16, 2),
      treaty_rec     NUMBER (16, 2),
      xol_rec        NUMBER (16, 2),
      facul_rec      NUMBER (16, 2)
   );

   TYPE giclr216_tab IS TABLE OF giclr216_type;

   FUNCTION get_giclr216_record (
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
      RETURN giclr216_tab PIPELINED;
END;
/


