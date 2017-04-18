CREATE OR REPLACE PACKAGE BODY CPI.gipi_casualty_personnel_pkg
AS

   /*
   **  Created by   : Moses Calma
   **  Date Created : June  17 , 2011
   **  Reference By : (GIPIS100 - Policy Information/Item additional information)
   **  Description  : Retrieves personnel information for a given casualty item
   */
   FUNCTION get_casualty_item_personnel (
      p_policy_id   gipi_casualty_personnel.policy_id%TYPE,
      p_item_no     gipi_casualty_personnel.item_no%TYPE
   )
      RETURN casualty_item_personnel_tab PIPELINED
   IS
      v_casualty_item_personnel   casualty_item_personnel_type;
   BEGIN
      FOR i IN (SELECT policy_id, item_no, NAME, remarks, capacity_cd,
                       include_tag, personnel_no, amount_covered
                  FROM gipi_casualty_personnel
                 WHERE policy_id = p_policy_id AND item_no = p_item_no)
      LOOP
         v_casualty_item_personnel.policy_id := i.policy_id;
         v_casualty_item_personnel.item_no := i.item_no;
         v_casualty_item_personnel.NAME := i.NAME;
         v_casualty_item_personnel.remarks := i.remarks;
         v_casualty_item_personnel.capacity_cd := i.capacity_cd;
         v_casualty_item_personnel.include_tag := i.include_tag;
         v_casualty_item_personnel.personnel_no := i.personnel_no;
         v_casualty_item_personnel.amount_covered := i.amount_covered;
         PIPE ROW (v_casualty_item_personnel);
      END LOOP;
   END get_casualty_item_personnel;

END gipi_casualty_personnel_pkg;
/


