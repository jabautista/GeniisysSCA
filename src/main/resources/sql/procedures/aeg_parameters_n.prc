DROP PROCEDURE CPI.AEG_PARAMETERS_N;

CREATE OR REPLACE PROCEDURE CPI.aeg_parameters_n (
   p_module_nm                   giac_modules.module_name%TYPE,
   p_transaction_type            giac_direct_prem_collns.transaction_type%TYPE,
   p_iss_cd                      giac_direct_prem_collns.b140_iss_cd%TYPE,
   p_bill_no                     giac_direct_prem_collns.b140_prem_seq_no%TYPE,
   p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
   p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
   p_giop_gacc_tran_id           giac_acct_entries.gacc_tran_id%TYPE,
   p_item_no               OUT   NUMBER,
   p_msg_alert             OUT   VARCHAR2
)
IS
   v_rec_gross_tag   VARCHAR2 (1);
   c                 NUMBER                              := 0;
   v_assd_no         gipi_parlist.assd_no%TYPE;
   v_module_id       giac_modules.module_id%TYPE;
   v_gen_type        giac_modules.generation_type%TYPE;
   v_item_no_2       NUMBER;
BEGIN
dbms_output.put_line('here b.1');
   BEGIN
      SELECT module_id, generation_type
        INTO v_module_id, v_gen_type
        FROM giac_modules
       WHERE module_name = p_module_nm;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_msg_alert := ('No data found in GIAC MODULES.');
   END;

   /* Call the deletion of accounting entry procedure. */
   aeg_delete_acct_entries_n (v_gen_type, p_giop_gacc_tran_id);

   /*
   **  For PREMIUM RECEIVABLES...
   */
   FOR pr_rec IN (SELECT   c.transaction_type, c.b140_iss_cd iss_cd,
                           c.b140_prem_seq_no bill_no, a.line_cd, a.assd_no,
                           a.type_cd, a.par_id,
                           SUM (c.collection_amt) collection_amt,
                           SUM (c.premium_amt) premium_amt,
                           SUM (c.tax_amt) tax_amt
                      FROM gipi_polbasic a,
                           gipi_invoice b,
                           giac_direct_prem_collns c
                     WHERE 1 = 1                    
                       AND a.policy_id = b.policy_id
                                                    
                       AND a.iss_cd = c.b140_iss_cd 
                       AND c.b140_iss_cd =
                                       c.b140_iss_cd
                                                    
                       AND b.iss_cd = c.b140_iss_cd 
                       AND b.prem_seq_no =
                                  c.b140_prem_seq_no
                                                    
                       AND c.gacc_tran_id = p_giop_gacc_tran_id
                  GROUP BY c.b140_iss_cd,
                           c.b140_prem_seq_no,
                           a.line_cd,
                           a.assd_no,
                           a.type_cd,
                           c.transaction_type,
                           a.par_id)
   LOOP
      /* Call the accounting entry generation procedure. */
	  dbms_output.put_line('here 1.1');
      v_item_no_2 := 5;

      BEGIN                                          
         IF pr_rec.transaction_type IN (3, 4)
         THEN
		 	 dbms_output.put_line('here 1.2');
            p_item_no := v_item_no_2;
         ELSE
		 	 dbms_output.put_line('here 1.3');
            p_item_no := p_item_no;
         END IF;
      END;

      -- to determine whether there should only be one acctg entry for premium and tax
      -- or separate acctg entries respectively.
      v_rec_gross_tag := giacp.v ('PREM_REC_GROSS_TAG');

      IF pr_rec.assd_no IS NULL
      THEN
         BEGIN
            SELECT assd_no
              INTO v_assd_no
              FROM gipi_parlist
             WHERE par_id = pr_rec.par_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_msg_alert :=
                     pr_rec.iss_cd
                  || '-'
                  || TO_CHAR (pr_rec.bill_no)
                  || ' has no assured.';
         END;
      END IF;

      IF v_rec_gross_tag = 'Y'
      THEN    
	  		 dbms_output.put_line('here 1.3.1');                                      
         aeg_create_acct_entries_n (NVL (pr_rec.assd_no, v_assd_no),
                                    v_module_id,
                                    p_item_no,
                                    pr_rec.iss_cd,
                                    pr_rec.bill_no,
                                    pr_rec.line_cd,
                                    pr_rec.type_cd,
                                    pr_rec.collection_amt,
                                    v_gen_type,
                                    p_msg_alert,
                                    p_giop_gacc_branch_cd,
                                    p_giop_gacc_fund_cd,
                                    p_giop_gacc_tran_id
                                   );
      ELSE
	  dbms_output.put_line('here 1.4');
         aeg_create_acct_entries_n (NVL (pr_rec.assd_no, v_assd_no),
                                    v_module_id,
                                    p_item_no,
                                    pr_rec.iss_cd,
                                    pr_rec.bill_no,
                                    pr_rec.line_cd,
                                    pr_rec.type_cd,
                                    pr_rec.premium_amt,
                                    v_gen_type,
                                    p_msg_alert,
                                    p_giop_gacc_branch_cd,
                                    p_giop_gacc_fund_cd,
                                    p_giop_gacc_tran_id
                                   );

         IF pr_rec.tax_amt != 0
         THEN
		 dbms_output.put_line('here 1.5');
            FOR rec IN (SELECT   b160_tax_cd tax_cd, SUM (tax_amt) tax_amt
                            FROM giac_tax_collns
                           WHERE b160_prem_seq_no = pr_rec.bill_no
                             AND b160_iss_cd = pr_rec.iss_cd
                             AND gacc_tran_id = p_giop_gacc_tran_id
                        GROUP BY b160_tax_cd)
            LOOP
               aeg_create_acct_entries_tax_n (rec.tax_cd,
                                              rec.tax_amt,
                                              v_gen_type,
                                              p_msg_alert,
                                              p_giop_gacc_branch_cd,
                                              p_giop_gacc_fund_cd,
                                              p_giop_gacc_tran_id
                                             );
            END LOOP;                                            -- end of rec
         END IF;                                      -- end of pr_rec.tax_amt
      END IF;                                        -- end of v_rec_gross_tag

      c := c + 1;
   END LOOP;
END aeg_parameters_n;
/


