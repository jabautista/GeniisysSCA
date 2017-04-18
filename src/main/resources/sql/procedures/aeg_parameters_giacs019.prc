DROP PROCEDURE CPI.AEG_PARAMETERS_GIACS019;

CREATE OR REPLACE PROCEDURE CPI.aeg_parameters_giacs019 (
   p_tran_id       giac_acctrans.tran_id%TYPE,
   p_module_name   giac_modules.module_name%TYPE,
   p_gacc_branch_cd    giac_acctrans.gibr_branch_cd%TYPE,
   p_gacc_fund_cd      giac_acctrans.gfun_fund_cd%TYPE,
   p_gacc_tran_id      giac_order_of_payts.gacc_tran_id%TYPE,
   p_message   OUT varchar2
)
IS
   v_due_to_ri_local     giac_outfacul_prem_payts.disbursement_amt%TYPE;
   v_due_to_ri_foreign   giac_outfacul_prem_payts.disbursement_amt%TYPE;
   v_prem_vat            giri_binder.ri_prem_vat%TYPE;
   v_comm_vat            giri_binder.ri_comm_vat%TYPE;
   v_wholding_vat        giri_binder.ri_wholding_vat%TYPE;
   v_module_id			 giac_modules.module_id%TYPE;
   v_gen_type			 giac_modules.generation_type%TYPE;
   v_sl_cd				 giac_acct_entries.sl_CD%TYPE;

   CURSOR pr_cur
   IS
      SELECT b.a180_ri_cd, c.line_cd, a.type_cd, b.disbursement_amt,
             g.local_foreign_sw,
               (  (c.ri_prem_amt * e.currency_rt)
                + (NVL (c.ri_prem_vat, 0) * e.currency_rt)
               )
             - (  (NVL (c.ri_comm_amt, 0) * e.currency_rt)
                + (NVL (c.ri_comm_vat, 0) * e.currency_rt)
               ) due_to_ri_local,         
               (  (c.ri_prem_amt * e.currency_rt)
                + (NVL (c.ri_prem_vat, 0) * e.currency_rt)
               )
             - (  (NVL (c.ri_comm_amt, 0) * e.currency_rt)
                + (NVL (c.ri_comm_vat, 0) * e.currency_rt)
                + (NVL (c.ri_wholding_vat, 0) * e.currency_rt)
               ) due_to_ri_foreign,       
             (NVL (c.ri_prem_vat, 0) * e.currency_rt) ri_prem_vat,
             (NVL (c.ri_comm_vat, 0) * e.currency_rt) ri_comm_vat,
             (NVL (c.ri_wholding_vat, 0) * e.currency_rt) ri_wholding_vat
        FROM gipi_polbasic a,
             giac_outfacul_prem_payts b,
             giri_binder c,
             giri_frps_ri d,
             giri_distfrps e,
             giuw_pol_dist f,
             giis_reinsurer g  
       WHERE a.policy_id = f.policy_id
         AND b.a180_ri_cd = g.ri_cd                         
         AND c.ri_cd = g.ri_cd                               
         AND d.ri_cd = g.ri_cd                               
         AND f.dist_no = e.dist_no
         AND e.line_cd = d.line_cd
         AND e.frps_yy = d.frps_yy
         AND e.frps_seq_no = d.frps_seq_no
         AND d.ri_cd = c.ri_cd
         AND d.fnl_binder_id = c.fnl_binder_id
         AND d.line_cd = c.line_cd
         AND c.ri_cd = b.a180_ri_cd
         AND c.fnl_binder_id = b.d010_fnl_binder_id
         AND b.gacc_tran_id = p_tran_id
         AND f.dist_flag NOT IN (4, 5);
BEGIN
   BEGIN
      SELECT module_id, generation_type
        INTO v_module_id, v_gen_type
        FROM giac_modules
       WHERE module_name = p_module_name;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_message := 'No data found in GIAC MODULES.';
   END;

   BEGIN
      SELECT param_value_v
        INTO v_sl_cd
        FROM giac_parameters
       WHERE param_name = 'RI_SL_CD';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_message := 'No data found in GIAC PARAMETERS.';
   END;


   AEG_Delete_Acct_Ent_GIACS019(p_tran_id,  v_gen_type);			


   FOR pr_rec IN pr_cur
   LOOP
      pr_rec.disbursement_amt := NVL (pr_rec.disbursement_amt, 0);

      IF pr_rec.local_foreign_sw = 'L'
      THEN
         v_due_to_ri_local :=
              pr_rec.due_to_ri_local
            * (pr_rec.disbursement_amt / pr_rec.due_to_ri_local);
         v_prem_vat :=
              pr_rec.ri_prem_vat
            * (pr_rec.disbursement_amt / pr_rec.due_to_ri_local);
         v_comm_vat :=
              pr_rec.ri_comm_vat
            * (pr_rec.disbursement_amt / pr_rec.due_to_ri_local);
      ELSE
         v_due_to_ri_foreign :=
              pr_rec.due_to_ri_foreign
            * (pr_rec.disbursement_amt / pr_rec.due_to_ri_foreign);
         v_prem_vat :=
              pr_rec.ri_prem_vat
            * (pr_rec.disbursement_amt / pr_rec.due_to_ri_foreign);
         v_comm_vat :=
              pr_rec.ri_comm_vat
            * (pr_rec.disbursement_amt / pr_rec.due_to_ri_foreign);
         v_wholding_vat :=
              pr_rec.ri_wholding_vat
            * (pr_rec.disbursement_amt / pr_rec.due_to_ri_foreign);
      END IF;

      IF pr_rec.local_foreign_sw = 'L'
      THEN
         aeg_create_acct_ent_giacs019 (pr_rec.a180_ri_cd,
                                  v_module_id,
                                  1,
                                  NULL,
                                  NULL,
                                  pr_rec.line_cd,
                                  pr_rec.type_cd,    
                                  v_due_to_ri_local,      
                                  v_gen_type,
								  p_gacc_branch_cd,
   								  p_gacc_fund_cd,
   								  p_gacc_tran_id,
								  p_message
                                 );
      END IF;

      IF pr_rec.local_foreign_sw IN ('A', 'F')
      THEN
         aeg_create_acct_ent_giacs019 (pr_rec.a180_ri_cd,
                                  v_module_id,
                                  1,
                                  NULL,
                                  NULL,
                                  pr_rec.line_cd,
                                  pr_rec.type_cd,    
                                  v_due_to_ri_local,      
                                  v_gen_type,
								  p_gacc_branch_cd,
   								  p_gacc_fund_cd,
   								  p_gacc_tran_id,
								  p_message
                                 );
      END IF;

      IF (v_comm_vat IS NOT NULL AND v_comm_vat <> 0)
      THEN

         IF NVL (giacp.v ('DEF_RI_VAT_ENTRY'), 'Y') = 'Y'
         THEN             
            aeg_create_acct_ent_giacs019 (pr_rec.a180_ri_cd,
                                  v_module_id,
                                  2,
                                  NULL,
                                  NULL,
                                  pr_rec.line_cd,
                                  pr_rec.type_cd,    
                                  v_due_to_ri_local,      
                                  v_gen_type,
								  p_gacc_branch_cd,
   								  p_gacc_fund_cd,
   								  p_gacc_tran_id,
								  p_message
                                 );
         END IF;


         IF NVL (giacp.v ('DEF_RI_VAT_ENTRY'), 'Y') = 'Y'
         THEN                 
            aeg_create_acct_ent_giacs019 (pr_rec.a180_ri_cd,
                                  v_module_id,
                                  3,
                                  NULL,
                                  NULL,
                                  pr_rec.line_cd,
                                  pr_rec.type_cd,    
                                  v_due_to_ri_local,      
                                  v_gen_type,
								  p_gacc_branch_cd,
   								  p_gacc_fund_cd,
   								  p_gacc_tran_id,
								  p_message
                                 );
         END IF;
      END IF;

      IF (v_prem_vat IS NOT NULL AND v_prem_vat <> 0)
      THEN
         IF NVL (giacp.v ('DEF_RI_VAT_ENTRY'), 'Y') = 'Y'
         THEN                
            IF pr_rec.local_foreign_sw = 'L'
            THEN
               aeg_create_acct_ent_giacs019 (pr_rec.a180_ri_cd,
                                  v_module_id,
                                  4,
                                  NULL,
                                  NULL,
                                  pr_rec.line_cd,
                                  pr_rec.type_cd,    
                                  v_due_to_ri_local,      
                                  v_gen_type,
								  p_gacc_branch_cd,
   								  p_gacc_fund_cd,
   								  p_gacc_tran_id,
								  p_message
                                 );
            END IF;
         END IF;

         IF NVL (giacp.v ('DEF_RI_VAT_ENTRY'), 'Y') = 'Y'
         THEN           
            IF pr_rec.local_foreign_sw = 'L'
            THEN
               aeg_create_acct_ent_giacs019 (pr_rec.a180_ri_cd,
                                  v_module_id,
                                  5,
                                  NULL,
                                  NULL,
                                  pr_rec.line_cd,
                                  pr_rec.type_cd,    
                                  v_due_to_ri_local,      
                                  v_gen_type,
								  p_gacc_branch_cd,
   								  p_gacc_fund_cd,
   								  p_gacc_tran_id,
								  p_message
                                 );
            END IF;
         END IF;
      END IF;

      IF (v_wholding_vat IS NOT NULL AND v_wholding_vat <> 0)
      THEN
         IF NVL (giacp.v ('DEF_RI_VAT_ENTRY'), 'Y') = 'Y'
         THEN 
            IF pr_rec.local_foreign_sw IN ('A', 'F')
            THEN
               aeg_create_acct_ent_giacs019 (pr_rec.a180_ri_cd,
                                  v_module_id,
                                  6,
                                  NULL,
                                  NULL,
                                  pr_rec.line_cd,
                                  pr_rec.type_cd,    
                                  v_due_to_ri_local,      
                                  v_gen_type,
								  p_gacc_branch_cd,
   								  p_gacc_fund_cd,
   								  p_gacc_tran_id,
								  p_message
                                 );
            END IF;
         END IF;

         IF pr_rec.local_foreign_sw IN ('A', 'F')
         THEN
            aeg_create_acct_ent_giacs019 (pr_rec.a180_ri_cd,
                                  v_module_id,
                                  7,
                                  NULL,
                                  NULL,
                                  pr_rec.line_cd,
                                  pr_rec.type_cd,    
                                  v_due_to_ri_local,      
                                  v_gen_type,
								  p_gacc_branch_cd,
   								  p_gacc_fund_cd,
   								  p_gacc_tran_id,
								  p_message
                                 );
         END IF;

         IF NVL (giacp.v ('DEF_RI_VAT_ENTRY'), 'Y') = 'Y'
         THEN                
            IF pr_rec.local_foreign_sw IN ('A', 'F')
            THEN
               aeg_create_acct_ent_giacs019 (pr_rec.a180_ri_cd,
                                  v_module_id,
                                  8,
                                  NULL,
                                  NULL,
                                  pr_rec.line_cd,
                                  pr_rec.type_cd,    
                                  v_due_to_ri_local,      
                                  v_gen_type,
								  p_gacc_branch_cd,
   								  p_gacc_fund_cd,
   								  p_gacc_tran_id,
								  p_message
                                 );
            END IF;
         END IF;

         IF pr_rec.local_foreign_sw IN ('A', 'F')
         THEN
            aeg_create_acct_ent_giacs019 (pr_rec.a180_ri_cd,
                                  v_module_id,
                                  9,
                                  NULL,
                                  NULL,
                                  pr_rec.line_cd,
                                  pr_rec.type_cd,    
                                  v_due_to_ri_local,      
                                  v_gen_type,
								  p_gacc_branch_cd,
   								  p_gacc_fund_cd,
   								  p_gacc_tran_id,
								  p_message
                                 );
         END IF;
      END IF;
   END LOOP;
END;
/


