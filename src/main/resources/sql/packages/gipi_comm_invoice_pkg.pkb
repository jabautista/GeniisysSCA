CREATE OR REPLACE PACKAGE BODY CPI.GIPI_COMM_INVOICE_PKG
AS

   /*
   **  Created by    : Andrew Robes
   **  Date Created  : 11.22.2011
   **  Reference By  : GIACS090
   **  Description   : Procedure to retrieve the first intm_no and intm_name of a given policy
   */
  PROCEDURE get_comm_invoice_intm(p_policy_id  IN GIPI_POLBASIC.policy_id%TYPE,
                                  p_intm_no   OUT GIIS_INTERMEDIARY.intm_no%TYPE,
                                  p_intm_name OUT GIIS_INTERMEDIARY.intm_name%TYPE)
  IS
  BEGIN
    FOR intm IN (
      SELECT z.intm_no, z.intm_name
        FROM gipi_comm_invoice y
            ,giis_intermediary z
       WHERE y.policy_id = p_policy_id
         AND y.intrmdry_intm_no = z.intm_no)
    LOOP
      p_intm_no := intm.intm_no;
      p_intm_name := intm.intm_name;
      EXIT;
    END LOOP;
  END get_comm_invoice_intm;

END GIPI_COMM_INVOICE_PKG;
/


