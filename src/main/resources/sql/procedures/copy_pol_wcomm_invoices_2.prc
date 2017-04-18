DROP PROCEDURE CPI.COPY_POL_WCOMM_INVOICES_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wcomm_invoices_2(
    p_new_policy_id     IN  gipi_invoice.policy_id%TYPE,
    p_old_pol_id        IN  gipi_invoice.policy_id%TYPE
)
IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wcomm_invoices program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Bill Commission...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;    
  FOR A IN (SELECT iss_cd,prem_seq_no,item_grp
              FROM gipi_invoice
             WHERE policy_id = p_new_policy_id) 
  LOOP
    FOR A2 IN (SELECT prem_seq_no 
                 FROM gipi_invoice
                WHERE policy_id = p_old_pol_id
                  AND item_grp = a.item_grp) 
    LOOP        
      INSERT INTO gipi_comm_invoice
             (policy_id,intrmdry_intm_no,iss_cd,prem_seq_no,share_percentage,
              premium_amt,commission_amt,wholding_tax,bond_rate, parent_intm_no)
       SELECT p_new_policy_id,intrmdry_intm_no,A.iss_cd,A.prem_seq_no,
              share_percentage,premium_amt,commission_amt,wholding_tax,bond_rate,parent_intm_no
         FROM gipi_comm_invoice
        WHERE policy_id = p_old_pol_id
          AND prem_seq_no  =  A2.prem_seq_no;
           copy_pol_wcomm_inv_perils_2(A.iss_cd,A.prem_seq_no,A2.prem_seq_no,p_new_policy_id,p_old_pol_id);
    END LOOP;
  END LOOP;
END;
/


