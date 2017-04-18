DROP PROCEDURE CPI.COPY_POL_WINSTALLMENT_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_winstallment_2(
    p_item_grp        IN gipi_winvoice.item_grp%TYPE,
    p_old_prem_seq_no IN gipi_inv_tax.prem_seq_no%TYPE,
    p_prem_amt        IN gipi_installment.prem_amt%TYPE,
    p_diff_days       IN NUMBER,
    p_proc_iss_cd     IN gipi_installment.iss_cd%TYPE,
    p_prem_seq_no     IN gipi_installment.prem_seq_no%TYPE
) 
IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
  v_prem_amt   gipi_installment.prem_amt%TYPE;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_winstallment program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Installment info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  FOR A IN (SELECT item_grp,inst_no,
                   share_pct,tax_amt,prem_amt,(due_date+p_diff_days) due_date 
              FROM gipi_installment
             WHERE item_grp =  p_item_grp
               AND prem_seq_no = p_old_prem_seq_no
               AND iss_cd  = p_proc_iss_cd)
  LOOP            
    v_prem_amt := p_prem_amt * a.share_pct;
    INSERT INTO gipi_installment
                (iss_cd,prem_seq_no,item_grp,inst_no,share_pct,
                  tax_amt,prem_amt,due_date) 
         VALUES (p_proc_iss_cd,p_prem_seq_no,a.item_grp,a.inst_no,
                 a.share_pct,a.tax_amt,v_prem_amt,a.due_date);     
  END LOOP;               
           
END;
/


