CREATE OR REPLACE PACKAGE CPI.giclr266a_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      intm              VARCHAR2 (100),
      claim_id          NUMBER (10),
      recovery_id       NUMBER (10),
      claim_number      VARCHAR2 (50),
      policy_number     VARCHAR2 (50),
      --assured_name      VARCHAR2 (200),
      assured_name      giis_assured.assd_name%TYPE, -- bonok :: 05.14.2013
      dsp_loss_date     DATE,
      recovery_number   VARCHAR2 (50),
      recovery_type     VARCHAR2 (50),
      recovery_status   VARCHAR2 (50),
      recoverable_amt   NUMBER (16, 2),
      recovered_amt     NUMBER (16, 2),
      date_as_of        VARCHAR2 (100),
      date_from         VARCHAR2 (100),
      date_to           VARCHAR2 (100),
      payor1                 VARCHAR2 (200), --Dren Niebres SR-5370 05.10.2016
      payor_recovered_amt1   NUMBER (16, 2) --Dren Niebres SR-5370 05.10.2016
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giclr266a_report (
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_intm_no         NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2   
   )
      RETURN report_tab PIPELINED;

   /*TYPE payor_type IS RECORD (
      payor                 VARCHAR2 (200),
      payor_recovered_amt   NUMBER (16, 2)
   );

   TYPE payor_tab IS TABLE OF payor_type;

   FUNCTION get_payor (p_claim_id NUMBER, p_recovery_id NUMBER)
      RETURN payor_tab PIPELINED;*/ --Dren Niebres SR-5370 05.10.2016
END;
/


