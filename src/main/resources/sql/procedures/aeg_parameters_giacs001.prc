DROP PROCEDURE CPI.AEG_PARAMETERS_GIACS001;

CREATE OR REPLACE PROCEDURE CPI.aeg_parameters_giacs001 (
   p_tran_id             giac_acctrans.tran_id%TYPE,
   p_branch_cd           giac_acct_entries.gacc_gibr_branch_cd%TYPE,
   p_fund_cd             giac_acct_entries.gacc_gfun_fund_cd%TYPE,
   p_module_name         giac_modules.module_name%TYPE,
   p_user_id             giis_users.user_id%TYPE,
   p_sl_cd               giac_acct_entries.sl_cd%TYPE,
   p_sl_type_cd          giac_acct_entries.sl_type_cd%TYPE,
   p_message       OUT   VARCHAR2
)
IS
   CURSOR pr_cur
   IS
      SELECT amount, pay_mode, dcb_bank_cd, dcb_bank_acct_cd
        FROM giac_collection_dtl
       WHERE 1 = 1
         AND gacc_tran_id = p_tran_id
         AND pay_mode NOT IN ('PDC', 'CMI', 'CW');

   CURSOR pr_cur_pdc
   IS
      SELECT amount, pay_mode
        FROM giac_collection_dtl
       WHERE gacc_tran_id = p_tran_id AND pay_mode = 'PDC';

   CURSOR pr_cur_cmi
   IS
      SELECT amount, pay_mode
        FROM giac_collection_dtl
       WHERE gacc_tran_id = p_tran_id AND pay_mode = 'CMI';

   CURSOR pr_cur_cw
   IS
      SELECT amount, pay_mode
        FROM giac_collection_dtl
       WHERE gacc_tran_id = p_tran_id AND pay_mode = 'CW';

   v_module_id   giac_modules.module_id%TYPE;
   v_gen_type    giac_modules.generation_type%TYPE;
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

   delete_acct_entries_giacs001 (p_tran_id, v_gen_type);

   FOR pr_rec IN pr_cur
   LOOP
      aeg_create_cib_giacs001 (pr_rec.dcb_bank_cd,
                               pr_rec.dcb_bank_acct_cd,
                               pr_rec.amount,
                               v_gen_type,
                               p_tran_id,
                               p_branch_cd,
                               p_fund_cd,
                               p_message
                              );
   END LOOP;

   FOR pr_rec_pdc IN pr_cur_pdc
   LOOP
      create_acct_entries_giacs001 (v_module_id,
                                    2,
                                    pr_rec_pdc.amount,
                                    v_gen_type,
                                    p_branch_cd,
                                    p_fund_cd,
                                    p_tran_id,
                                    p_user_id,
                                    p_sl_cd,
                                    p_sl_type_cd,
                                    p_message
                                   );
   END LOOP;

   FOR pr_rec_cmi IN pr_cur_cmi
   LOOP
      create_acct_entries_giacs001 (v_module_id,
                                    3,
                                    pr_rec_cmi.amount,
                                    v_gen_type,
                                    p_branch_cd,
                                    p_fund_cd,
                                    p_tran_id,
                                    p_user_id,
                                    p_sl_cd,
                                    p_sl_type_cd,
                                    p_message
                                   );
   END LOOP;

   FOR pr_rec_cw IN pr_cur_cw
   LOOP
      create_acct_entries_giacs001 (v_module_id,
                                    4,
                                    pr_rec_cw.amount,
                                    v_gen_type,
                                    p_branch_cd,
                                    p_fund_cd,
                                    p_tran_id,
                                    p_user_id,
                                    p_sl_cd,
                                    p_sl_type_cd,
                                    p_message
                                   );
   END LOOP;
END;
/


