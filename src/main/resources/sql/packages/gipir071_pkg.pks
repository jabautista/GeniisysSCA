CREATE OR REPLACE PACKAGE CPI.gipir071_pkg
AS
   TYPE gipir071_type IS RECORD (
      policy_id      NUMBER (12),
      subline_cd     VARCHAR2 (7),
      subline_name   VARCHAR2 (30),
      vessel_cd      VARCHAR2 (6),
      vessel_name    VARCHAR2 (30),
      policy_no      VARCHAR2 (30),
      assd_no        NUMBER (12),
      assd_name      VARCHAR2 (500),
      share_cd       NUMBER (3),
      trty_name      VARCHAR2 (30),
      dist_tsi       NUMBER (16, 2),
      dist_prem      NUMBER (16, 2),
      flag           VARCHAR2 (10),
      comp_name      VARCHAR2 (100),
      comp_add       VARCHAR2 (500)
   );

   TYPE gipir071_tab IS TABLE OF gipir071_type;

   FUNCTION get_gipir071_record (
      p_ending_date     VARCHAR2,
      p_extract_id      NUMBER,
      p_starting_date   VARCHAR2
   )
      RETURN gipir071_tab PIPELINED;
END;
/


