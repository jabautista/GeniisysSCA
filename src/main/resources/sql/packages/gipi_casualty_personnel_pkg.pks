CREATE OR REPLACE PACKAGE CPI.gipi_casualty_personnel_pkg
AS
   TYPE casualty_item_personnel_type IS RECORD (
      policy_id        gipi_casualty_personnel.policy_id%TYPE,
      item_no          gipi_casualty_personnel.item_no%TYPE,
      NAME             gipi_casualty_personnel.NAME%TYPE,
      remarks          gipi_casualty_personnel.remarks%TYPE,
      capacity_cd      gipi_casualty_personnel.capacity_cd%TYPE,
      include_tag      gipi_casualty_personnel.include_tag%TYPE,
      personnel_no     gipi_casualty_personnel.personnel_no%TYPE,
      amount_covered   gipi_casualty_personnel.amount_covered%TYPE
   );

   TYPE casualty_item_personnel_tab IS TABLE OF casualty_item_personnel_type;

   FUNCTION get_casualty_item_personnel (
      p_policy_id   gipi_casualty_personnel.policy_id%TYPE,
      p_item_no     gipi_casualty_personnel.item_no%TYPE
   )
      RETURN casualty_item_personnel_tab PIPELINED;
END gipi_casualty_personnel_pkg;
/


