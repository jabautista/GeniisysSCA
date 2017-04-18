CREATE OR REPLACE PACKAGE CPI.GICLR209LE_PKG
AS
   TYPE giclr209le_type IS RECORD (
      intm_no                   VARCHAR2 (10),
      company_name              VARCHAR2 (200),
      company_address           VARCHAR2 (200),
      title_sw                  VARCHAR2 (500),
      date_title                VARCHAR2 (500),
      date_sw                   VARCHAR2 (500),
      paid_expense              NUMBER (16,2),
      buss_source               VARCHAR2 (20),
      intm_name                 VARCHAR2 (200),
      iss_cd                    VARCHAR2 (10),
      iss_name                  VARCHAR2 (200),
      subline_cd                VARCHAR2 (20),
      line_cd                   VARCHAR2 (20),
      claim_id                  VARCHAR2 (20),
      assd_name                 VARCHAR2 (500),
      assd_no                   VARCHAR2 (20),
      line_name                 VARCHAR2 (100),
      claim_no                  VARCHAR2 (50),
      policy_no                 VARCHAR2 (50),
      clm_file_date             DATE,
      clm_loss_id               VARCHAR2 (20),
      paid_loss                 NUMBER (16,2),
      loss_date                 DATE,
      loss_cat_cd               VARCHAR2 (20),
      eff_date                  DATE,
      expiry_date               DATE,
      loss_cat_category         VARCHAR2 (200),
      tran_date_loss            VARCHAR2 (200),
      tran_date_expense         VARCHAR2 (200),
      clm_stat                  VARCHAR2 (200),
      item_no                   NUMBER (20),
      grouped_item_no           NUMBER (20),
      peril_cd                  NUMBER (20),
      cf_share_type1_LOSS       NUMBER (16,2),
      cf_share_type1_EXPENSE    NUMBER (16,2),
      cf_share_type2_LOSS       NUMBER (16,2),
      cf_share_type2_EXPENSE    NUMBER (16,2),
      cf_share_type3_LOSS       NUMBER (16,2),
      cf_share_type3_EXPENSE    NUMBER (16,2),
      cf_share_type4_LOSS       NUMBER (16,2),
      cf_share_type4_EXPENSE    NUMBER (16,2),
      intm_ri                   VARCHAR2 (800),
      pol_iss_cd                VARCHAR2 (10),
      loc                       VARCHAR2 (200),
      item_name                 VARCHAR2 (200),
      peril                     VARCHAR2 (200),
      tsi_amt                   NUMBER (16,2),
      recoverable_loss          NUMBER (16,2),
      recoverable_expense       NUMBER (16,2),
      flag                      VARCHAR2(2)
   );

   TYPE giclr209le_tab IS TABLE OF giclr209le_type;

   FUNCTION get_giclr209le_report (
      p_claim_id        NUMBER,
      p_intm_break      NUMBER,
      p_iss_break       NUMBER,
      p_paid_date       VARCHAR2,
      p_session_id      NUMBER,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr209le_tab PIPELINED;
      
END;
/


