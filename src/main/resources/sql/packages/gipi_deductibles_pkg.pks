CREATE OR REPLACE PACKAGE CPI.gipi_deductibles_pkg
AS
   TYPE deductibles_type IS RECORD (
      aggregate_sw           gipi_deductibles.aggregate_sw%TYPE,
      ceiling_sw             gipi_deductibles.ceiling_sw%TYPE,
      deductible_rt          gipi_deductibles.deductible_rt%TYPE,
      deductible_amt         gipi_deductibles.deductible_amt%TYPE,
      deductible_text        gipi_deductibles.deductible_text%TYPE,
      ded_deductible_cd      gipi_deductibles.ded_deductible_cd%TYPE,
      deductible_title       giis_deductible_desc.deductible_title%TYPE,
      total_deductible_amt   gipi_deductibles.deductible_amt%TYPE
   );

   TYPE deductibles_tab IS TABLE OF deductibles_type;

   FUNCTION get_deductibles (p_policy_id gipi_ves_air.policy_id%TYPE)
      RETURN deductibles_tab PIPELINED;

      TYPE item_deductible_type IS RECORD (
      policy_id              gipi_deductibles.policy_id%TYPE,
      item_no                gipi_deductibles.item_no%TYPE,
      ceiling_sw             gipi_deductibles.ceiling_sw%TYPE,
      ded_line_cd            gipi_deductibles.ded_line_cd%TYPE,
      aggregate_sw           gipi_deductibles.aggregate_sw%TYPE,
      deductible_rt          gipi_deductibles.deductible_rt%TYPE,
      deductible_text        gipi_deductibles.deductible_text%TYPE,
      ded_subline_cd         gipi_deductibles.ded_subline_cd%TYPE,
      deductible_amt         gipi_deductibles.deductible_amt%TYPE,
      total_deductible_amt   gipi_deductibles.deductible_amt%TYPE,
      ded_deductible_cd      gipi_deductibles.ded_deductible_cd%TYPE,
      deductible_name        giis_deductible_desc.deductible_title%TYPE,
      item_title             gipi_item.item_title%TYPE
   );

   TYPE item_deductible_tab IS TABLE OF item_deductible_type;

   FUNCTION get_item_deductibles (
      p_policy_id   gipi_deductibles.policy_id%TYPE,
      p_item_no     gipi_deductibles.item_no%TYPE
   )
      RETURN item_deductible_tab PIPELINED;
      
   FUNCTION get_gipis100_deductibles (
      p_policy_id   gipi_deductibles.policy_id%TYPE
   )
      RETURN item_deductible_tab PIPELINED;
     
     
     
END gipi_deductibles_pkg;
/


