CREATE OR REPLACE PACKAGE CPI.CSV_CLM_PER_CARGO_GICLR265
AS
   TYPE populate_report_type IS RECORD (
      cargo_class          VARCHAR2 (350),
      cargo_type           VARCHAR2 (350),
      claim_number         VARCHAR2 (30),
      policy_number        VARCHAR2 (30),
      assured       gicl_claims.assured_name%TYPE,
      item_number_item_title   VARCHAR2 (300),
      loss_reserve    gicl_clm_reserve.loss_reserve%TYPE,
      losses_paid   gicl_clm_reserve.loss_reserve%TYPE,
      expense_reserve     gicl_clm_reserve.loss_reserve%TYPE,
      expenses_paid    gicl_clm_reserve.loss_reserve%TYPE
      
   );

   TYPE populate_report_tab IS TABLE OF populate_report_type;

   TYPE populate_report_items_type IS RECORD (
      lossres    gicl_clm_reserve.loss_reserve%TYPE,
      losspaid   gicl_clm_reserve.loss_reserve%TYPE,
      expres     gicl_clm_reserve.loss_reserve%TYPE,
      exppaid    gicl_clm_reserve.loss_reserve%TYPE
   );

   TYPE populate_report_items_tab IS TABLE OF populate_report_items_type;

   FUNCTION csv_giclr265(
      p_as_of_date       VARCHAR2,
      p_cargo_class_cd      giis_cargo_class.cargo_class_cd%TYPE,
      p_cargo_type       giis_cargo_type.cargo_type%TYPE,
      p_as_of_ldate      VARCHAR2,
      p_from_date        VARCHAR2,
      p_from_ldate       VARCHAR2,
      p_to_date          VARCHAR2,
      p_to_ldate         VARCHAR2,
      p_user_id          VARCHAR2
   )
      RETURN populate_report_tab PIPELINED;

   FUNCTION populate_giclr265items (p_claim_id gicl_cargo_dtl.claim_id%TYPE)
      RETURN populate_report_items_tab PIPELINED;
END;
/
