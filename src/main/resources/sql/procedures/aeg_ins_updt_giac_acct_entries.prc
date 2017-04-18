DROP PROCEDURE CPI.AEG_INS_UPDT_GIAC_ACCT_ENTRIES;

CREATE OR REPLACE PROCEDURE CPI.Aeg_Ins_Updt_Giac_Acct_Entries
(p_batch_csr_id   IN      GICL_ACCT_ENTRIES.batch_csr_id%TYPE,
 p_tran_id        IN      GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
 p_fund_cd        IN      GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
 p_iss_cd         IN      GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
 p_user_id        IN      GIIS_USERS.user_id%TYPE)

IS

   /*
   **  Created by   :  Veronica V. Raymundo
   **  Date Created :  12.21.2011
   **  Reference By : (GICLS043 - Batch Claim Settlement Request)
   **  Description  : Executes Aeg_Ins_Updt_Giac_Acct_Entries 
   **                program unit in GICLS043
   **                 
   */

  CURSOR cur_acct_entries is
     SELECT generation_type, gl_acct_id, gl_acct_category, gl_control_acct,
            gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
            gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
            sl_type_cd, SL_CD, sl_source_cd,
            SUM(debit_amt) debit_amt, SUM(credit_amt) credit_amt
       FROM GICL_ACCT_ENTRIES
      WHERE batch_csr_id = p_batch_csr_id
      GROUP BY generation_type, gl_acct_id, gl_acct_category, gl_control_acct,
               gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
               gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
               sl_type_cd, sl_cd, sl_source_cd;

  v_acct_entry_id   GIAC_ACCT_ENTRIES.acct_entry_id%TYPE DEFAULT 0;
  
BEGIN

  FOR al IN cur_acct_entries LOOP
      v_acct_entry_id := v_acct_entry_id + 1;
      INSERT INTO GIAC_ACCT_ENTRIES(gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,            
                                    acct_entry_id, gl_acct_id, gl_acct_category,              
                                    gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,                  
                                    gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,                  
                                    gl_sub_acct_6, gl_sub_acct_7, sl_type_cd, sl_cd, 
                                    sl_source_cd,
                                    debit_amt, credit_amt, generation_type,                
                                    user_id, last_update)
                             VALUES(p_tran_id, p_fund_cd, p_iss_cd, 
                                    v_acct_entry_id, al.gl_acct_id, al.gl_acct_category,
                                    al.gl_control_acct, al.gl_sub_acct_1, al.gl_sub_acct_2,
                                    al.gl_sub_acct_3, al.gl_sub_acct_4, al.gl_sub_acct_5,
                                    al.gl_sub_acct_6, al.gl_sub_acct_7, al.sl_type_cd, al.sl_cd,
                                    al.sl_source_cd,
                                    al.debit_amt, al.credit_amt, al.generation_type,
                                    p_user_id, SYSDATE);
  END LOOP;

END;
/


