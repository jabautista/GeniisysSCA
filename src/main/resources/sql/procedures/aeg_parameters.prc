DROP PROCEDURE CPI.AEG_PARAMETERS;

CREATE OR REPLACE PROCEDURE CPI.aeg_parameters (
   p_tran_id          IN   giac_acctrans.tran_id%TYPE,
   p_batch_dv_id           giac_batch_dv.batch_dv_id%TYPE,
   p_ri_iss_cd        IN   gicl_claims.iss_cd%TYPE,
   p_branch_cd        IN   giac_acctrans.gibr_branch_cd%TYPE,
   p_iss_cd           IN   giac_acctrans.gibr_branch_cd%TYPE,
   p_branch_sl_type        VARCHAR2,
   p_fund_cd               giac_acctrans.gfun_fund_cd%TYPE,
   p_user_id               giac_acct_entries.user_id%TYPE
)
IS
/*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  12.26.2011
   **  Reference By : (GICLS086 - Special Claim Settlement Request)
   **  Description  : Executes aeg_parameters
   **                program unit in GICLS086
   **
   */
   v_branch_acct   giis_issource.acct_iss_cd%TYPE;
   v_module_id     giac_modules.module_id%TYPE;
   v_gen_type      giac_modules.generation_type%TYPE;

   /*comment out and replaced by MAC 11/12/2013
   CURSOR paid_cur
   IS
      /*SELECT   SUM (paid_amt) paid_amt,
               branch_cd                         --jen.090605 added branch cd
          FROM giac_batch_dv_dtl
         WHERE batch_dv_id = p_batch_dv_id AND branch_cd = p_branch_cd
      GROUP BY branch_cd;
	  SELECT   SUM (a.paid_amt) paid_amt,  --added by steven 1.26.2012 added convert_rate for foreign currency. Base on SR 0012036.
				a.branch_cd, b.convert_rate
          	FROM giac_batch_dv_dtl a,giac_batch_dv b
         		WHERE a.batch_dv_id = p_batch_dv_id AND a.branch_cd = p_branch_cd
          			AND b.batch_dv_id(+) = a.batch_dv_id
      			GROUP BY a.branch_cd,b.convert_rate;

   CURSOR paid_br_cur
   IS
      /*SELECT   SUM (paid_amt) paid_amt, branch_cd
          FROM giac_batch_dv_dtl
         WHERE batch_dv_id = p_batch_dv_id
           --AND branch_cd NOT IN (p_branch_cd, p_ri_iss_cd) replaced by: Nica 11.27.2012
		  AND branch_cd NOT IN (p_iss_cd, p_ri_iss_cd)
      GROUP BY branch_cd;
		SELECT   SUM (a.paid_amt) paid_amt, a.branch_cd, b.convert_rate --added by steven 1.26.2012 added convert_rate for foreign currency. Base on SR 0012036.
        	FROM giac_batch_dv_dtl a,giac_batch_dv b
        		WHERE a.batch_dv_id = p_batch_dv_id
           			--AND branch_cd NOT IN (p_branch_cd, p_ri_iss_cd) replaced by: Nica 11.27.2012
					AND a.branch_cd NOT IN (p_iss_cd, p_ri_iss_cd)
					AND b.batch_dv_id(+) = a.batch_dv_id
      			GROUP BY a.branch_cd,b.convert_rate;*/
   
   --convert paid amount to local currency and round it off before inserting to GIAC_ACCT_ENTRIES to prevent discrep in BCS Accounting Entries by MAC 11/12/2013             
   CURSOR paid_cur IS 
    SELECT SUM(ROUND(a.paid_amt * b.convert_rate, 2)) paid_amt, a.branch_cd, 1 convert_rate 
      FROM giac_batch_dv_dtl a, giac_batch_dv b
     WHERE a.batch_dv_id = p_batch_dv_id
       AND a.branch_cd = p_branch_cd
       AND a.batch_dv_id = b.batch_dv_id
     GROUP BY a.branch_cd;
  
  --convert paid amount to local currency and round it off before inserting to GIAC_ACCT_ENTRIES to prevent discrep in BCS Accounting Entries by MAC 11/12/2013
  CURSOR paid_br_cur IS
    SELECT SUM(ROUND(a.paid_amt * b.convert_rate, 2)) paid_amt, a.branch_cd, 1 convert_rate 
      FROM giac_batch_dv_dtl a, giac_batch_dv b
     WHERE a.batch_dv_id = p_batch_dv_id
       AND a.branch_cd NOT IN (p_iss_cd, p_ri_iss_cd)
       AND a.batch_dv_id = b.batch_dv_id
     GROUP BY a.branch_cd;             
                
BEGIN
   BEGIN
      SELECT module_id, generation_type
        INTO v_module_id, v_gen_type
        FROM giac_modules
       WHERE module_name = 'GIACS086';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error ('-20001', 'No data found in GIAC MODULES.');
         RETURN;
   END;

   /*
   ** Call the deletion of accounting entry procedure.
   */
   --
   aeg_delete_acct_entries (p_tran_id, p_branch_cd, v_gen_type);

   --IF p_branch_cd = 'HO' replaced by: Nica 11.27.2012
   IF p_iss_cd = 'HO'
   THEN
      IF p_branch_cd <> p_iss_cd
      THEN                                                         --due to..
         FOR paid_rec IN paid_cur
         LOOP
            branch_sl_cd (paid_rec.branch_cd, v_branch_acct);
            aeg_create_acct_entries_086 (v_module_id,
                                         1,
                                         p_branch_cd,
                                         p_iss_cd,      ---kung san idi2sburse
                                         v_branch_acct,
                                         paid_rec.paid_amt,
                                         v_gen_type,
                                         p_tran_id,
                                         p_branch_sl_type,
                                         p_fund_cd,
                                         p_user_id,
										 paid_rec.convert_rate
                                        );
         END LOOP;
      ELSIF p_branch_cd = p_iss_cd
      THEN                                                          --due from
         FOR paid_br_rec IN paid_br_cur
         LOOP
            --BRANCH_SL_CD (paid_br_rec.branch_cd, v_branch_acct);
            branch_sl_cd (p_iss_cd, v_branch_acct);
            aeg_create_acct_entries_086 (v_module_id,
                                         2,
                                         p_branch_cd,
                                         paid_br_rec.branch_cd,
                                         v_branch_acct,
                                         paid_br_rec.paid_amt,
                                         v_gen_type,
                                         p_tran_id,
                                         p_branch_sl_type,
                                         p_fund_cd,
                                         p_user_id,
										 paid_br_rec.convert_rate
                                        );
         END LOOP;
      END IF;
   ELSIF p_iss_cd <> 'HO'
   THEN
      IF p_branch_cd <> p_iss_cd
      THEN                                                         --due to..
         FOR paid_rec IN paid_cur
         LOOP
            branch_sl_cd (paid_rec.branch_cd, v_branch_acct);
            aeg_create_acct_entries_086 (v_module_id,
                                         3,
                                         p_branch_cd,
                                         p_iss_cd,      ---kung san idi2sburse
                                         v_branch_acct,
                                         paid_rec.paid_amt,
                                         v_gen_type,
                                         p_tran_id,
                                         p_branch_sl_type,
                                         p_fund_cd,
                                         p_user_id,
										 paid_rec.convert_rate
                                        );
         END LOOP;
      ELSIF p_branch_cd = p_iss_cd
      THEN                                                          --due from
         FOR paid_br_rec IN paid_br_cur
         LOOP
            --BRANCH_SL_CD (paid_br_rec.branch_cd, v_branch_acct);
            branch_sl_cd (p_iss_cd, v_branch_acct);
            aeg_create_acct_entries_086 (v_module_id,
                                         4,
                                         p_branch_cd,
                                         paid_br_rec.branch_cd,
                                         v_branch_acct,
                                         paid_br_rec.paid_amt,
                                         v_gen_type,
                                         p_tran_id,
                                         p_branch_sl_type,
                                         p_fund_cd,
                                         p_user_id,
										 paid_br_rec.convert_rate
                                        );
         END LOOP;
      END IF;
   END IF;
END;
/


