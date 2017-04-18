CREATE OR REPLACE PACKAGE CPI.giclr251c_pkg
AS
   TYPE giclr251c_report_type IS RECORD (
      claim_id          gicl_claims.claim_id%TYPE,
      claim_no          VARCHAR2 (200),
      policy_no         VARCHAR2 (200),
      --free_text         VARCHAR2 (200),
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      date_as_of        VARCHAR2(100),
      date_from         VARCHAR2(100),
      date_to           VARCHAR2(100)
   );

   TYPE giclr251c_report_tab IS TABLE OF giclr251c_report_type;

   FUNCTION get_giclr251c_report (
      p_free_text       VARCHAR2,
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN giclr251c_report_tab PIPELINED;

   TYPE giclr251c_details_type IS RECORD (
      free_text         VARCHAR2 (32767),
      dsp_loss_date     DATE,
      recovery_id       NUMBER (12),
      recovery_no       VARCHAR2 (100),
      rec_type_desc     giis_recovery_type.rec_type_desc%TYPE,
      recoverable_amt   NUMBER (16, 2),
      recovered_amt     NUMBER (16, 2),
      lawyer_cd         VARCHAR2 (100),
      recovery_type     VARCHAR2 (100),
      recovery_status   VARCHAR2 (100)
   );

   TYPE giclr251c_details_tab IS TABLE OF giclr251c_details_type;

   FUNCTION get_giclr251c_details (
      p_free_text   VARCHAR2,
      p_claim_id    NUMBER,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN giclr251c_details_tab PIPELINED;

   TYPE giclr251c_payor_details_type IS RECORD (
      payor           VARCHAR2 (600), -- changed by robert from 200 01.06.2014
      recovered_amt   NUMBER (16, 2)
   );

   TYPE giclr251c_payor_details_tab IS TABLE OF giclr251c_payor_details_type;

   FUNCTION get_giclr251c_payor_details (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_recovery_id   gicl_clm_recovery.recovery_id%TYPE
   )
      RETURN giclr251c_payor_details_tab PIPELINED;
END;
/


