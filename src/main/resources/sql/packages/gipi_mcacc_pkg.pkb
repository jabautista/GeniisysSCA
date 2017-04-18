CREATE OR REPLACE PACKAGE BODY CPI.gipi_mcacc_pkg
AS


   /*
   **  Created by   :  Moses Calma
   **  Date Created : June 6, 2011
   **  Reference By : (GIPIS100 - Policy Information)
   **  Description  : Retrieves accessories of a given item(vehicle)
   */
   FUNCTION get_vehicle_accessories (
      p_policy_id   gipi_mcacc.policy_id%TYPE,
      p_item_no     gipi_mcacc.item_no%TYPE
   )
      RETURN vehicle_accessory_tab PIPELINED
   IS
      v_vehicle_accessory   vehicle_accessory_type;
   BEGIN
      FOR i IN (SELECT policy_id, item_no, accessory_cd, acc_amt
                  FROM gipi_mcacc
                 WHERE policy_id = p_policy_id AND item_no = p_item_no)
      LOOP
         v_vehicle_accessory.policy_id := i.policy_id;
         v_vehicle_accessory.item_no := i.item_no;
         v_vehicle_accessory.accessory_cd := i.accessory_cd;
         v_vehicle_accessory.acc_amt := i.acc_amt;

         BEGIN
            SELECT accessory_desc
              INTO v_vehicle_accessory.accessory_desc
              FROM giis_accessory
             WHERE accessory_cd = i.accessory_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_vehicle_accessory.accessory_desc := '';
         END;

         SELECT SUM (acc_amt)
           INTO v_vehicle_accessory.total_acc_amt
           FROM gipi_mcacc
          WHERE policy_id = i.policy_id AND item_no = i.item_no;

         PIPE ROW (v_vehicle_accessory);
      END LOOP;
   END get_vehicle_accessories;
   
END gipi_mcacc_pkg;
/


