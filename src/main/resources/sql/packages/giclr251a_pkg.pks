CREATE OR REPLACE PACKAGE CPI.giclr251a_pkg
AS
   TYPE giclr251a_report_type IS RECORD (
      claim_number      VARCHAR2 (50),
      policy_number     VARCHAR2 (50),
      dsp_loss_date     DATE,
      assured_name      gicl_claims.assured_name%TYPE,
      recovery_number   VARCHAR2 (50),
      recovery_type     VARCHAR2 (50),
      recovery_status   VARCHAR2 (50),
      recoverable_amt   NUMBER (16, 2),
      recovered_amt     NUMBER (16, 2),
      claim_id          NUMBER (12),
      recovery_id       NUMBER (12),
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      date_as_of        VARCHAR2 (100),
      date_from         VARCHAR2 (100),
      date_to           VARCHAR2 (100)
   );

   TYPE giclr251a_report_tab IS TABLE OF giclr251a_report_type;

   FUNCTION get_giclr251a_report (
      p_assd_no         NUMBER,
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr251a_report_tab PIPELINED;

   TYPE giclr251a_payor_details_type IS RECORD (
      payor           VARCHAR2 (200),
      recovered_amt   NUMBER (16, 2)
   );

   TYPE giclr251a_payor_details_tab IS TABLE OF giclr251a_payor_details_type;

   FUNCTION get_giclr251a_payor_details (
      p_claim_id      NUMBER,
      p_recovery_id   NUMBER
   )
      RETURN giclr251a_payor_details_tab PIPELINED;
END;
/


