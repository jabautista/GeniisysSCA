CREATE OR REPLACE PACKAGE CPI.giclr250_pkg
AS
   TYPE giclr250_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      policy_number     VARCHAR2 (100),
      assured_name      GICL_CLAIMS.ASSURED_NAME%TYPE, -- changed by robert from VARCHAR2 (200), 10.02.2013
      claim_number      VARCHAR2 (200),
      dsp_loss_date     DATE,
      clm_file_date     DATE,
      claim_status      VARCHAR2 (100),
      loss_reserve      NUMBER (16, 2),
      losses_paid       NUMBER (16, 2),
      expense_reserve   NUMBER (16, 2),
      expenses_paid     NUMBER (16, 2),
      date_as_of        VARCHAR2 (100),
      date_from         VARCHAR2 (100),
      date_to           VARCHAR2 (100)
   );

   TYPE giclr250_tab IS TABLE OF giclr250_type;

   FUNCTION get_giclr250_report (
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_line_cd         VARCHAR2,
      p_subline_cd      VARCHAR2,
      p_pol_iss_cd      VARCHAR2,
      p_issue_yy        NUMBER,
      p_pol_seq_no      NUMBER,
      p_renew_no        NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr250_tab PIPELINED;
END;
/


