CREATE OR REPLACE PACKAGE CPI.CSV_CLM_PER_VESSEL_GICLR262
IS
   TYPE giclr262_pkg_details_type IS RECORD (
      vessel            VARCHAR2 (50),
      claim_number      VARCHAR2 (30),
      policy_number     VARCHAR2 (30),
      assured           VARCHAR2 (1001),
      item_title        VARCHAR2 (40),
      loss_date         VARCHAR2 (40),
      claim_file_date   VARCHAR2 (40),
      loss_reserve      NUMBER,
      losses_paid       NUMBER,
      expense_reserve   NUMBER,
      expenses_paid     NUMBER
   );

   TYPE giclr262_pkg_details_tab IS TABLE OF giclr262_pkg_details_type;

   FUNCTION csv_giclr262 (
      p_vessel_cd     giis_vessel.vessel_cd%TYPE,
      p_as_of_date    VARCHAR2,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_as_of_ldate   VARCHAR2,
      p_from_ldate    VARCHAR2,
      p_to_ldate      VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN giclr262_pkg_details_tab PIPELINED;
END CSV_CLM_PER_VESSEL_GICLR262;
/


