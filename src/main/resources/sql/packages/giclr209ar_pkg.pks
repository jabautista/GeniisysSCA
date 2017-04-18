CREATE OR REPLACE PACKAGE CPI.giclr209ar_pkg
AS
   TYPE giclr209ar_type IS RECORD (
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
      paid_loss           NUMBER (16,2),
      loss_date           DATE,
      loss_cat_cd         VARCHAR2 (20),
      company_name        VARCHAR2 (200),
      company_address     VARCHAR2 (200),
      title_sw            VARCHAR2 (500),
      date_title          VARCHAR2 (500),
      date_sw             VARCHAR2 (500),
      eff_date            DATE,
      loss_cat_category   VARCHAR2 (200),
      share_type1         NUMBER (16,2),
      share_type2         NUMBER (16,2),
      share_type3         NUMBER (16,2),
      paid                NUMBER (16,2),
      tran_date           VARCHAR2 (200),
      check_no            VARCHAR2 (200),
      clm_stat            VARCHAR2 (100),
      flag              VARCHAR2 (2)
   );

   TYPE giclr209ar_tab IS TABLE OF giclr209ar_type;

   FUNCTION get_giclr209ar_report (
      p_claim_id        NUMBER,
      p_intm_break      NUMBER,
      p_iss_break       NUMBER,
      p_paid_date       VARCHAR2,
      p_session_id      NUMBER,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr209ar_tab PIPELINED;
      
   FUNCTION get_clm_stat(
      p_claim_id        NUMBER,
      p_claim_loss_id   VARCHAR2,
      p_brdrx_id        NUMBER,
      p_session_id      NUMBER
   )  
      RETURN VARCHAR;
END;
/


