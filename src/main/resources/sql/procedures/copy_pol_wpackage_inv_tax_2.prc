DROP PROCEDURE CPI.COPY_POL_WPACKAGE_INV_TAX_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wpackage_inv_tax_2(
    p_item_grp      IN gipi_invoice.item_grp%TYPE,
    p_new_policy_id IN gipi_package_inv_tax.policy_id%TYPE,
    p_proc_iss_cd   IN gipi_package_inv_tax.iss_cd%TYPE,
    p_prem_seq_no   IN gipi_package_inv_tax.prem_seq_no%TYPE,
    p_old_pol_id    IN gipi_package_inv_tax.policy_id%TYPE
) 
IS
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wpackage_inv_tax program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Package Bill Tax info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  INSERT INTO gipi_package_inv_tax
   (policy_id,item_grp,line_cd,iss_cd,prem_seq_no,prem_amt,tax_amt,
    other_charges)
  SELECT p_new_policy_id,item_grp,line_cd,p_proc_iss_cd,
         p_prem_seq_no,prem_amt,tax_amt,other_charges
    FROM gipi_package_inv_tax
   WHERE policy_id = p_old_pol_id
     AND item_grp =  p_item_grp;
END;
/


