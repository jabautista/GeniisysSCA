CREATE OR REPLACE PACKAGE CPI.giclr251b_pkg
AS
   TYPE report_type IS RECORD (
      policy_no         VARCHAR2 (100),
      claim_no          VARCHAR2 (100),
      free_text         VARCHAR2 (32767),
      dsp_loss_date     DATE,
      clm_file_date     DATE,
      clm_stat_desc     VARCHAR2 (50),
      loss_reserve      NUMBER (16, 2),
      expense_reserve   NUMBER (16, 2),
      losses_paid       NUMBER (16, 2),
      expenses_paid     NUMBER (16, 2),
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      date_as_of        VARCHAR2(100),
      date_from         VARCHAR2(100),
      date_to           VARCHAR2(100)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giclr251b_report (
      p_free_text       VARCHAR2,
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/


