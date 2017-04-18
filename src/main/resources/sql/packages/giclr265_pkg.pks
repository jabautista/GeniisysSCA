CREATE OR REPLACE PACKAGE CPI.giclr265_pkg
AS
   TYPE populate_report_type IS RECORD (
      cargo_class          VARCHAR2 (350),
      cargo_type           VARCHAR2 (350),
      item_no              gicl_cargo_dtl.item_no%TYPE,
      claim_id             gicl_cargo_dtl.claim_id%TYPE,
      item_no_item_title   VARCHAR2 (300),
      claim_number         VARCHAR2 (30),
      policy_number        VARCHAR2 (30),
      assured_name         gicl_claims.assured_name%TYPE,
      date_type            VARCHAR (200),
      system_date          VARCHAR2 (100),
      system_time          VARCHAR2 (100),
      company_name         giis_parameters.param_value_v%TYPE,
      company_address      giis_parameters.param_value_v%TYPE
   );

   TYPE populate_report_tab IS TABLE OF populate_report_type;

   TYPE populate_report_items_type IS RECORD (
      lossres    gicl_clm_reserve.loss_reserve%TYPE,
      losspaid   gicl_clm_reserve.loss_reserve%TYPE,
      expres     gicl_clm_reserve.loss_reserve%TYPE,
      exppaid    gicl_clm_reserve.loss_reserve%TYPE
   );

   TYPE populate_report_items_tab IS TABLE OF populate_report_items_type;

   FUNCTION populate_giclr265 (
      p_as_of_date       VARCHAR2,
      p_cargo_class_cd   giis_cargo_class.cargo_class_cd%TYPE,
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


