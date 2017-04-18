CREATE OR REPLACE PACKAGE CPI.giclr219_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company       VARCHAR2 (50),
      cf_com_address   VARCHAR2 (200),
      cf_date          VARCHAR2 (50),
      claim_number     VARCHAR2 (26),
      loa_number       VARCHAR2 (23),
      date_generated   DATE,
      loss_amount      NUMBER (38, 5),
      payee            VARCHAR2 (552),
      v_print          VARCHAR2 (8)
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_details (
      p_start_dt      VARCHAR2,
      p_end_dt        VARCHAR2,
      p_as_of_dt      VARCHAR2,
      p_branch_cd     VARCHAR2,
      p_subline_cd    VARCHAR2,
      p_choice_date   VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_details_tab PIPELINED;
END;
/


