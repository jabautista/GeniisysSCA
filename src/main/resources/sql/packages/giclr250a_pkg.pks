CREATE OR REPLACE PACKAGE CPI.giclr250a_pkg
AS
   TYPE giclr250a_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      policy_number     VARCHAR (100),
      assured_name      GICL_CLAIMS.ASSURED_NAME%TYPE, -- changed by robert from VARCHAR2 (200), 10.02.2013
      claim_number      VARCHAR2 (100),
      dsp_loss_date     DATE,
      recovery_number   VARCHAR2 (100),
      stat_desc         VARCHAR2 (100),
      recovery_type     VARCHAR2 (100),
      recoverable_amt   NUMBER (16, 2),
      recovered_amt     NUMBER (16, 2),
      payor             VARCHAR2 (600), -- changed by robert from VARCHAR2 (200), 10.02.2013
      payor_rec_amt     NUMBER (16, 2),
      date_as_of        VARCHAR2 (100),
      date_from         VARCHAR2 (100),
      date_to           VARCHAR2 (100)
   );

   TYPE giclr250a_tab IS TABLE OF giclr250a_type;

   FUNCTION get_giclr250a_report (
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
      RETURN giclr250a_tab PIPELINED;
END;
/


