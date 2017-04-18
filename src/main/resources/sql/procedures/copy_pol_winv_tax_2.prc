DROP PROCEDURE CPI.COPY_POL_WINV_TAX_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_winv_tax_2(
    p_item_grp        IN gipi_winv_tax.item_grp%TYPE,
    p_old_prem_seq_no IN gipi_inv_tax.prem_seq_no%TYPE,
    p_proc_iss_cd     IN gipi_inv_tax.iss_cd%TYPE,
    p_prem_seq_no     IN gipi_inv_tax.prem_seq_no%TYPE
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
  **  Description  : copy_pol_winv_tax program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Tax info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  -- edited by grace to add computation of depreciation for taxes 07.15.2010
  FOR A IN (
            SELECT iss_cd,tax_cd,line_cd,item_grp,tax_id,
                   tax_allocation,fixed_tax_allocation,rate
              FROM gipi_inv_tax
             WHERE item_grp = p_item_grp 
               AND prem_seq_no = p_old_prem_seq_no
               AND iss_cd = p_proc_iss_cd)
  LOOP             
    FOR x IN (
             SELECT tax_amt 
               FROM giex_invtax
              WHERE iss_cd      = a.iss_cd
                AND prem_seq_no = p_old_prem_seq_no 
                AND tax_cd      = a.tax_cd
                AND tax_id      = a.tax_id)
    LOOP            
      INSERT INTO gipi_inv_tax
                  (prem_seq_no,iss_cd,tax_cd,tax_amt,line_cd,item_grp,tax_id,
                  tax_allocation,fixed_tax_allocation,rate)
           VALUES (p_prem_seq_no,a.iss_cd, a.tax_cd, x.tax_amt, a.line_cd, a.item_grp, a.tax_id,
                  a.tax_allocation, a.fixed_tax_allocation, a.rate);
    END LOOP;
  END LOOP;  
END;
/


