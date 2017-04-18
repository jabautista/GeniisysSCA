CREATE OR REPLACE PACKAGE CPI.giclr217_pkg
AS
   TYPE giclr217_type IS RECORD (
      range_from      NUMBER (16, 2),
      range_to        NUMBER (16, 2),
      line_cd         VARCHAR2 (2),
      peril_cd        NUMBER (5),
      sum_insured     NUMBER (16, 2),
      loss            NUMBER (16, 2),
      cnt_clm         NUMBER (5),
      peril_name      VARCHAR2 (20),
      flag            VARCHAR2 (10),
      comp_name       VARCHAR2 (100),
      title           VARCHAR2 (200),
      heading         VARCHAR2 (200),
      heading2        VARCHAR2 (200),
      line_name       VARCHAR2 (100),
      starting_date   VARCHAR2 (100),
      ending_date     VARCHAR2 (100)
   );

   TYPE giclr217_tab IS TABLE OF giclr217_type;

   FUNCTION get_giclr217_record (
      p_claim_date       VARCHAR2,
      p_ending_date      VARCHAR2,
      p_extract          NUMBER,
      p_line             VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_param_date       VARCHAR2,
      p_starting_date    VARCHAR2,
      p_subline          VARCHAR2,
      p_user             VARCHAR2
   )
      RETURN giclr217_tab PIPELINED;
END;
/


