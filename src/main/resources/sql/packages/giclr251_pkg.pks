CREATE OR REPLACE PACKAGE CPI.giclr251_pkg
AS
   TYPE report_type IS RECORD (
      assd_no           VARCHAR2 (10),
      assured_name      gicl_claims.assured_name%TYPE,
      policy_no         VARCHAR2 (50),
      claim_no          VARCHAR2 (50),
      dsp_loss_date     DATE,
      clm_file_date     DATE,
      clm_stat_desc     VARCHAR2 (100),
      loss_reserve      NUMBER (16, 2),
      losses_paid       NUMBER (16, 2),
      expense_reserve   NUMBER (16, 2),
      expenses_paid     NUMBER (16, 2),
      company_name      VARCHAR2 (500),
      company_address   VARCHAR2 (500),
      date_as_of        VARCHAR2(100),
      date_from         VARCHAR2(100),
      date_to           VARCHAR2(100)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giclr251_report (
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_assd_no         NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to     VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/


