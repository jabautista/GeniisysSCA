CREATE OR REPLACE PACKAGE CPI.giclr266_pkg
AS
   TYPE report_type IS RECORD (
      line_cd           VARCHAR (10),
      claim_id          NUMBER (12),
      claim_number      VARCHAR2 (100),
      policy_number     VARCHAR2 (100),
      --assured_name      VARCHAR2 (200),
      assured_name      giis_assured.assd_name%TYPE, -- bonok :: 05.14.2013
      loss_date         DATE,
      clm_file_date     DATE,
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      date_as_of        VARCHAR2 (100),
      date_from         VARCHAR2 (100),
      date_to           VARCHAR2 (100),
      intm VARCHAR2(200)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giclr266_report (
      p_module_id       VARCHAR2,
      p_user_id         VARCHAR2,
      p_intm_no         NUMBER,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN report_tab PIPELINED;

   TYPE item_type IS RECORD (
      item_no      NUMBER (9),
      item_title   VARCHAR2 (200)
   );

   TYPE item_tab IS TABLE OF item_type;

   FUNCTION get_item (p_intm_no NUMBER, p_claim_id NUMBER)
      RETURN item_tab PIPELINED;

   TYPE details_type IS RECORD (
      peril             VARCHAR2 (100),
      shr_intm_pct      gicl_intm_itmperil.shr_intm_pct%TYPE,
      loss_reserve      NUMBER (16, 2),
      losses_paid       NUMBER (16, 2),
      expense_reserve   NUMBER (16, 2),
      expenses_paid     NUMBER (16, 2)
   );

   TYPE details_tab IS TABLE OF details_type;

   FUNCTION get_details (
      p_intm_no NUMBER,
      p_claim_id   NUMBER,
      p_line_cd    VARCHAR
   )
      RETURN details_tab PIPELINED;
--   TYPE item_type IS RECORD (
--      item              VARCHAR (200),
--      peril             VARCHAR2 (100),
--      shr_intm_pct      NUMBER (12, 9),
--      loss_reserve      NUMBER (16, 2),
--      losses_paid       NUMBER (16, 2),
--      expense_reserve   NUMBER (16, 2),
--      expenses_paid     NUMBER (16, 2)
--   );

--   TYPE item_tab IS TABLE OF item_type;

--   FUNCTION get_item (p_claim_id NUMBER)
--      RETURN item_tab PIPELINED;
END;
/


