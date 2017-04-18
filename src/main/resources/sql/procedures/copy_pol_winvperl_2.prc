CREATE OR REPLACE PROCEDURE CPI.copy_pol_winvperl_2(
    p_item_grp          IN gipi_winvperl.item_grp%TYPE,
    p_old_prem_seq_no   IN gipi_inv_tax.prem_seq_no%TYPE,
    p_proc_iss_cd       IN gipi_invperil.iss_cd%TYPE,
    p_proc_line_cd      IN giex_dep_perl.line_cd%TYPE,
    p_old_pol_id        IN gipi_itmperil.policy_id%TYPE,
    p_prem_seq_no       IN gipi_invperil.prem_seq_no%TYPE
) 
IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
  v_tsi_amt           gipi_invperil.tsi_amt%TYPE  := 0;
  v_prem_amt          gipi_invperil.prem_amt%TYPE := 0;
  perl_tsi_amt        gipi_invperil.tsi_amt%TYPE;
  perl_prem_amt       gipi_invperil.prem_amt%TYPE;
  
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_winvperl program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Bill peril info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  -- edited by grace to add computation of depreciation 07.15.2010
  FOR inv IN ( SELECT peril_cd, item_grp, ri_comm_amt, ri_comm_rt
                 FROM gipi_invperil 
                WHERE iss_cd = p_proc_iss_cd
                  AND prem_seq_no = p_old_prem_seq_no
                  AND item_grp = p_item_grp)
  LOOP
      FOR x IN (
              SELECT NVL(A.prem_amt,0) prem_amt,
                     NVL(A.tsi_amt,0) tsi_amt, a.prem_rt,
                     A.item_no, A.line_cd --benjo 11.24.2016 SR-5621
                FROM GIPI_ITMPERIL A, GIPI_ITEM b
               WHERE A.policy_id   = b.policy_id
                 AND A.item_no     = b.item_no
                 AND b.item_grp    = p_item_grp
                 AND a.peril_cd    = inv.peril_cd
                 AND a.policy_id   = p_old_pol_id
                 )
      LOOP        
        /*FOR z IN (  SELECT rate                
                      FROM giex_dep_perl b
                     WHERE b.line_cd  = p_proc_line_cd
                       AND b.peril_cd = inv.peril_cd
                       AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y')
          LOOP            
            perl_tsi_amt  := x.tsi_amt - (x.tsi_amt * z.rate/100);             
            perl_prem_amt := ROUND((perl_tsi_amt * (x.prem_rt/100)),2);
          END LOOP;*/ --benjo 11.24.2016 SR-5621 comment out
          
            /* benjo 11.24.2016 SR-5621 */
            perl_tsi_amt := x.tsi_amt;
            compute_depreciation_amounts (p_old_pol_id, x.item_no, x.line_cd, inv.peril_cd, perl_tsi_amt);
            perl_prem_amt := perl_tsi_amt * (x.prem_rt/100);
            /* end SR-5621 */
            
            v_tsi_amt     := v_tsi_amt + nvl(perl_tsi_amt, x.tsi_amt) ;
            v_prem_amt    := v_prem_amt + nvl(perl_prem_amt, x.prem_amt);
            perl_tsi_amt  := NULL;             
            perl_prem_amt := NULL;             
          END LOOP;  
         
      INSERT INTO gipi_invperil
                 (iss_cd,prem_seq_no,peril_cd,tsi_amt,prem_amt,item_grp,ri_comm_amt,
                  ri_comm_rt)
          VALUES (p_proc_iss_cd,p_prem_seq_no, inv.peril_cd, v_tsi_amt, v_prem_amt, inv.item_grp, 
                  inv.ri_comm_amt, inv.ri_comm_rt);    
  END LOOP;
END;
/


