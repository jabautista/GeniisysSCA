CREATE OR REPLACE PACKAGE CPI.gipi_mortgagee_pkg
AS
   TYPE mortgagee_type IS RECORD (
      policy_id    gipi_mortgagee.policy_id%TYPE,
      mortg_cd     gipi_mortgagee.mortg_cd%TYPE,
      amount       gipi_mortgagee.amount%TYPE,
      item_no      gipi_mortgagee.item_no%TYPE,
      iss_cd       gipi_mortgagee.iss_cd%TYPE,
      remarks      gipi_mortgagee.remarks%TYPE,
      delete_sw    gipi_mortgagee.delete_sw%TYPE,
      mortg_name   giis_mortgagee.mortg_name%TYPE,
      sum_amount   gipi_mortgagee.amount%TYPE
   );

   TYPE mortgagee_tab IS TABLE OF mortgagee_type;
   
  FUNCTION get_mortgagee(p_policy_id    gipi_mortgagee.policy_id%TYPE)
  
    RETURN mortgagee_tab PIPELINED;
    
  TYPE item_mortgagee_type IS RECORD (
      policy_id             gipi_mortgagee.policy_id%TYPE,
      item_no               gipi_mortgagee.item_no%TYPE,
      mortg_cd              gipi_mortgagee.mortg_cd%TYPE,
      iss_cd                gipi_mortgagee.iss_cd%TYPE,
      amount                gipi_mortgagee.amount%TYPE,
      remarks               gipi_mortgagee.remarks%TYPE,
      delete_sw             gipi_mortgagee.delete_sw%TYPE,
      item_no_display       gipi_mortgagee.item_no%TYPE,
      total_mortgagee_amt   gipi_mortgagee.amount%TYPE,
      delete_sw_display     gipi_mortgagee.delete_sw%TYPE,
      mortg_name            giis_mortgagee.mortg_name%TYPE,
      total_amount          gipi_mortgagee.amount%TYPE
   );

   TYPE item_mortgagee_tab IS TABLE OF item_mortgagee_type;

   FUNCTION get_item_mortgagees (
      p_policy_id   gipi_mortgagee.policy_id%TYPE,
      p_item_no     gipi_mortgagee.item_no%TYPE
   )
      RETURN item_mortgagee_tab PIPELINED;
      
   FUNCTION get_gipis100_mortgagees (
      p_policy_id   gipi_mortgagee.policy_id%TYPE
   )
      RETURN item_mortgagee_tab PIPELINED;
    
   FUNCTION get_mortgagee_del_sw(p_policy_id    gipi_mortgagee.policy_id%TYPE,
                                 p_mortg_cd VARCHAR2
                                )
    RETURN mortgagee_tab PIPELINED;
END gipi_mortgagee_pkg;
/
