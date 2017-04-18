CREATE OR REPLACE PACKAGE CPI.giclr257a_pkg
AS
   TYPE report_type IS RECORD (
      claim_no          VARCHAR2 (100),
      policy_no         VARCHAR2 (100),
      assured_name      GICL_CLAIMS.ASSURED_NAME%TYPE,
      clm_stat_cd       GICL_CLAIMS.CLM_STAT_CD%TYPE,
      clm_stat_desc     VARCHAR2(100),
      loss_date         VARCHAR2(20),
      clm_file_date     VARCHAR2(20),
      priv_adj_cd       GICL_CLM_ADJUSTER.PRIV_ADJ_CD%TYPE,
      assign_date       VARCHAR2(20),
      complt_date       GICL_CLM_ADJUSTER.COMPLT_DATE%TYPE,
      payee_no          VARCHAR2 (200),
      private_adjuster  GIIS_ADJUSTER.PAYEE_NAME%TYPE,
      payee_name        VARCHAR2 (200),
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      days_outstanding  VARCHAR2 (100),
      date_type         VARCHAR2 (150),
      paid_amt          NUMBER (16,2)
   );
   
   TYPE report_tab IS TABLE OF report_type;

  FUNCTION get_giclr_257_a_report (
      p_user_id         VARCHAR2,
      p_payee_no        VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_as_of_date      VARCHAR2,
      p_from_ldate      VARCHAR2,
      p_to_ldate        VARCHAR2,
      p_as_of_ldate     VARCHAR2,
      p_from_adate      VARCHAR2,
      p_to_adate        VARCHAR2,
      p_as_of_adate     VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/


