CREATE OR REPLACE PACKAGE CPI.gipi_mcacc_pkg
AS
   TYPE vehicle_accessory_type IS RECORD (
      policy_id        gipi_mcacc.policy_id%TYPE,
      item_no          gipi_mcacc.item_no%TYPE,
      acc_amt          gipi_mcacc.acc_amt%TYPE,
      total_acc_amt    gipi_mcacc.acc_amt%TYPE,
      accessory_cd     gipi_mcacc.accessory_cd%TYPE,
      accessory_desc   giis_accessory.accessory_desc%TYPE
   );

   TYPE vehicle_accessory_tab IS TABLE OF vehicle_accessory_type;

   FUNCTION get_vehicle_accessories (
      p_policy_id   gipi_mcacc.policy_id%TYPE,
      p_item_no     gipi_mcacc.item_no%TYPE
   )
      RETURN vehicle_accessory_tab PIPELINED;
END gipi_mcacc_pkg;
/


