CREATE OR REPLACE PACKAGE CPI.GICLR209B_PKG
AS
   TYPE giclr209b_type IS RECORD (
      intm_no             VARCHAR2 (10),
      brdrx_record_id     VARCHAR2 (10),
      buss_source         VARCHAR2 (20),
      intm_name           VARCHAR2 (200),
      iss_cd              VARCHAR2 (10),
      iss_name            VARCHAR2 (200),
      subline_cd          VARCHAR2 (20),
      line_cd             VARCHAR2 (20),
      claim_id            VARCHAR2 (20),
      assd_name           VARCHAR2 (500),
      assd_no             VARCHAR2 (20),
      line_name           VARCHAR2 (100),
      claim_no            VARCHAR2 (50),
      policy_no           VARCHAR2 (50),
      clm_file_date       DATE,
      clm_loss_id         VARCHAR2 (20),
      paid_loss           NUMBER (16, 2),
      loss_date           DATE,
      loss_cat_cd         VARCHAR2 (20),
      company_name        VARCHAR2 (200),
      company_address     VARCHAR2 (200),
      title_sw            VARCHAR2 (500),
      date_title          VARCHAR2 (500),
      date_sw             VARCHAR2 (500),
      eff_date            DATE,
      loss_cat_category   VARCHAR2 (200),
      share_type1         NUMBER (16, 2),
      share_type2         NUMBER (16, 2),
      share_type3         NUMBER (16, 2),
      paid                NUMBER (16, 2),
      tran_date           VARCHAR2 (2000),--from 200 modified by aliza g. SR 21495 01/29/2016
      check_no            VARCHAR2 (2000),--from 200 modified by aliza g. SR 21495 01/29/2016
      clm_stat            VARCHAR2 (1000),--from 100 modified by aliza g. SR 21495 01/29/2016
      header_flag         VARCHAR2 (1)
   );

   TYPE giclr209b_tab IS TABLE OF giclr209b_type;

   FUNCTION get_giclr209b_report (
      p_claim_id     NUMBER,
      p_intm_break   NUMBER,
      p_iss_break    NUMBER,
      p_paid_date    VARCHAR2,
      p_session_id   NUMBER,
      p_date_from    VARCHAR2,
      p_date_to      VARCHAR2
   )
      RETURN giclr209b_tab PIPELINED;
END;
/


