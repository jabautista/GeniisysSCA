CREATE OR REPLACE PACKAGE CPI.get_cg_ref_codes
AS
   TYPE cg_ref_codes_list_type IS RECORD (
      rv_low_value    VARCHAR2 (240),
      rv_high_value   VARCHAR2 (240),
      rv_meaning      VARCHAR2 (100)
   );

   TYPE cg_ref_codes_list_tab IS TABLE OF cg_ref_codes_list_type;

   FUNCTION display_ref_codes (p_table_name VARCHAR2, p_column_name VARCHAR2)
      RETURN cg_ref_codes_list_tab PIPELINED;
END;
/


