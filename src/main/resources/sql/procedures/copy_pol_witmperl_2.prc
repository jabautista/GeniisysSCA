CREATE OR REPLACE PROCEDURE CPI.copy_pol_witmperl_2(
    p_proc_line_cd      gipi_itmperil.line_cd%TYPE,
    p_old_pol_id        gipi_itmperil.policy_id%TYPE,
    p_new_policy_id     gipi_itmperil.policy_id%TYPE
) 
IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
  v_tsi_amt        gipi_itmperil.tsi_amt%TYPE;
  v_prem_amt       gipi_itmperil.prem_amt%TYPE;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_witmperl program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Item peril info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  -- edited by grace to add computation of depreciation 07.15.2010
  FOR perl IN (
    SELECT  line_cd,item_no,peril_cd,tsi_amt,ann_prem_amt prem_amt,
               ann_tsi_amt,ann_prem_amt,NVL(rec_flag,'A') rec_flag,comp_rem,discount_sw,tarf_cd,
            prem_rt,ri_comm_rate,ri_comm_amt,prt_flag,as_charge_sw
      FROM gipi_itmperil
     WHERE line_cd = p_proc_line_cd 
       AND policy_id = p_old_pol_id)
  LOOP    
  
      v_tsi_amt  := perl.tsi_amt;             
      v_prem_amt := perl.prem_amt;       
  
      /*FOR a IN (
      SELECT rate                
            FROM giex_dep_perl b
           WHERE b.line_cd  = perl.line_cd
             AND b.peril_cd = perl.peril_cd
             AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y')
      LOOP            
        v_tsi_amt  := v_tsi_amt - (v_tsi_amt * a.rate/100);             
          v_prem_amt := ROUND((v_tsi_amt * (perl.prem_rt/100)),2);
      END LOOP;*/ --benjo 11.24.2016 SR-5621 comment out
          
      /* benjo 11.24.2016 SR-5621 */
      compute_depreciation_amounts (p_old_pol_id, perl.item_no, perl.line_cd, perl.peril_cd, v_tsi_amt);
      v_prem_amt := v_tsi_amt * (perl.prem_rt/100);
      /* end SR-5621 */
                     
    INSERT INTO gipi_itmperil
             (policy_id,line_cd,item_no,peril_cd,tsi_amt,prem_amt,
              ann_tsi_amt,ann_prem_amt,rec_flag,comp_rem,discount_sw,tarf_cd,
              prem_rt,ri_comm_rate,ri_comm_amt,prt_flag,as_charge_sw)
     VALUES  (p_new_policy_id, perl.line_cd, perl.item_no, perl.peril_cd, v_tsi_amt, v_prem_amt,
              v_tsi_amt, v_prem_amt, perl.rec_flag, perl.comp_rem, perl.discount_sw, perl.tarf_cd,
              perl.prem_rt, perl.ri_comm_rate, perl.ri_comm_amt, perl.prt_flag, perl.as_charge_sw);          
 
   END LOOP;
   copy_pol_wdiscount_perils_2(p_old_pol_id, p_new_policy_id);
END;
/


