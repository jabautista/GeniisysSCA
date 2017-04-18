CREATE OR REPLACE PACKAGE BODY CPI.giac_acct_entries_pkg
AS
   /*
   **  Created by   :  Emman
   **  Date Created :  08.20.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Executes procedure AEG_DELETE_ACCT_ENTRIES on GIACS026
   **                Delete all records existing in GIAC_ACCT_ENTRIES table having the same
   **            tran_id as :GLOBAL.cg$giop_gacc_tran_id.
   */
   PROCEDURE aeg_delete_acct_entries (
      p_gacc_tran_id    giac_prem_deposit.gacc_tran_id%TYPE,
      p_item_gen_type   giac_modules.generation_type%TYPE
   )
   IS
      dummy   VARCHAR2 (1);

      CURSOR ae
      IS
         SELECT '1'
           FROM giac_acct_entries
          WHERE gacc_tran_id = p_gacc_tran_id
            AND generation_type = p_item_gen_type;
   BEGIN
      OPEN ae;

      FETCH ae
       INTO dummy;

      IF dummy = '1'
      THEN
         DELETE FROM giac_acct_entries
               WHERE gacc_tran_id = p_gacc_tran_id
                 AND generation_type = p_item_gen_type;
      END IF;
   END;

   /*
   **  Created by   :  Emman
   **  Date Created :  08.20.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Executes procedure AEG_INSERT_UPDATE_ACCT_ENTRIES on GIACS026
   **                This procedure determines whether the records will be updated or inserted
   **            in GIAC_ACCT_ENTRIES.
   */
   PROCEDURE aeg_insert_update_acct_entries (
      p_gacc_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd          giac_acctrans.gfun_fund_cd%TYPE,
      p_gacc_tran_id          giac_acctrans.tran_id%TYPE,
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
      iuae_sl_source_cd       giac_acct_entries.sl_source_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE
   )
   IS
      iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
      iuae_count           NUMBER;
   BEGIN
      SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gacc_gibr_branch_cd = p_gacc_branch_cd
         AND gacc_gfun_fund_cd = p_gacc_fund_cd
         AND gacc_tran_id = p_gacc_tran_id
         AND NVL (sl_cd, 0) = NVL (iuae_sl_cd, NVL (sl_cd, 0))
         AND generation_type = iuae_generation_type
         AND gl_acct_id = iuae_gl_acct_id;

      BEGIN
         SELECT NVL (COUNT (*), 0)
           INTO iuae_count
           FROM giac_acct_entries
          WHERE gacc_gibr_branch_cd = p_gacc_branch_cd
            AND gacc_gfun_fund_cd = p_gacc_fund_cd
            AND gacc_tran_id = p_gacc_tran_id
            AND NVL (sl_cd, 0) = NVL (iuae_sl_cd, NVL (sl_cd, 0))
            AND generation_type = iuae_generation_type
            AND gl_acct_category = iuae_gl_acct_category
            AND gl_control_acct = iuae_gl_control_acct
            AND gl_sub_acct_1 = iuae_gl_sub_acct_1
            AND gl_sub_acct_2 = iuae_gl_sub_acct_2
            AND gl_sub_acct_3 = iuae_gl_sub_acct_3
            AND gl_sub_acct_4 = iuae_gl_sub_acct_4
            AND gl_sub_acct_5 = iuae_gl_sub_acct_5
            AND gl_sub_acct_6 = iuae_gl_sub_acct_6
            AND gl_sub_acct_7 = iuae_gl_sub_acct_7
            AND sl_cd = iuae_sl_cd
            AND gl_acct_id = iuae_gl_acct_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            iuae_count := 0;
      END;

      IF NVL (iuae_count, 0) = 0
      THEN
         iuae_acct_entry_id := NVL (iuae_acct_entry_id, 0) + 1;

         INSERT INTO giac_acct_entries
                     (gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                      acct_entry_id, gl_acct_id,
                      gl_acct_category, gl_control_acct,
                      gl_sub_acct_1, gl_sub_acct_2,
                      gl_sub_acct_3, gl_sub_acct_4,
                      gl_sub_acct_5, gl_sub_acct_6,
                      gl_sub_acct_7, sl_cd, debit_amt,
                      sl_type_cd, sl_source_cd, credit_amt,
                      generation_type,
                      user_id, last_update
                     )
              VALUES (p_gacc_tran_id, p_gacc_fund_cd, p_gacc_branch_cd,
                      iuae_acct_entry_id, iuae_gl_acct_id,
                      iuae_gl_acct_category, iuae_gl_control_acct,
                      iuae_gl_sub_acct_1, iuae_gl_sub_acct_2,
                      iuae_gl_sub_acct_3, iuae_gl_sub_acct_4,
                      iuae_gl_sub_acct_5, iuae_gl_sub_acct_6,
                      iuae_gl_sub_acct_7, iuae_sl_cd, iuae_debit_amt,
                      iuae_sl_type_cd, iuae_sl_source_cd, iuae_credit_amt,
                      iuae_generation_type,
                      NVL (giis_users_pkg.app_user, USER), SYSDATE
                     );
      ELSE
         UPDATE giac_acct_entries
            SET debit_amt = debit_amt + iuae_debit_amt,
                credit_amt = credit_amt + iuae_credit_amt
          WHERE NVL (sl_cd, 0) = NVL (iuae_sl_cd, NVL (sl_cd, 0))
            AND generation_type = iuae_generation_type
            AND gl_acct_id = iuae_gl_acct_id
            AND gacc_gibr_branch_cd = p_gacc_branch_cd
            AND gacc_gfun_fund_cd = p_gacc_fund_cd
            AND gacc_tran_id = p_gacc_tran_id;
      END IF;
   END aeg_insert_update_acct_entries;

   /*
   **  Created by   :  Emman
   **  Date Created :  09.30.2010
   **  Reference By : (GIACS020 - Comm Payts)
   **  Description  : Executes procedure AEG_INSERT_UPDATE_ACCT_ENTRIES on GIACS020
   */
   PROCEDURE giacs020_aeg_ins_upd_acct_ents (
      p_gacc_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd          giac_acctrans.gfun_fund_cd%TYPE,
      p_gacc_tran_id          giac_acctrans.tran_id%TYPE,
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
      iuae_sl_source_cd       giac_acct_entries.sl_source_cd%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE
   )
   IS
      iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
   BEGIN
      SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gl_sub_acct_1 = iuae_gl_sub_acct_1
         AND gl_sub_acct_2 = iuae_gl_sub_acct_2
         AND gl_sub_acct_3 = iuae_gl_sub_acct_3
         AND gl_sub_acct_4 = iuae_gl_sub_acct_4
         AND gl_sub_acct_5 = iuae_gl_sub_acct_5
         AND gl_sub_acct_6 = iuae_gl_sub_acct_6
         AND gl_sub_acct_7 = iuae_gl_sub_acct_7
         AND NVL (sl_cd, 1) = NVL (iuae_sl_cd, 1)
         AND generation_type = iuae_generation_type
         AND NVL (gl_acct_id, gl_acct_id) = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = p_gacc_branch_cd
         AND gacc_gfun_fund_cd = p_gacc_fund_cd
         AND gacc_tran_id = p_gacc_tran_id;

      IF NVL (iuae_acct_entry_id, 0) = 0
      THEN
         iuae_acct_entry_id := NVL (iuae_acct_entry_id, 0) + 1;

         INSERT INTO giac_acct_entries
                     (gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                      acct_entry_id, gl_acct_id,
                      gl_acct_category, gl_control_acct,
                      gl_sub_acct_1, gl_sub_acct_2,
                      gl_sub_acct_3, gl_sub_acct_4,
                      gl_sub_acct_5, gl_sub_acct_6,
                      gl_sub_acct_7, sl_type_cd, sl_source_cd, sl_cd,
                      debit_amt, credit_amt, generation_type,
                      user_id, last_update
                     )
              VALUES (p_gacc_tran_id, p_gacc_fund_cd, p_gacc_branch_cd,
                      iuae_acct_entry_id, iuae_gl_acct_id,
                      iuae_gl_acct_category, iuae_gl_control_acct,
                      iuae_gl_sub_acct_1, iuae_gl_sub_acct_2,
                      iuae_gl_sub_acct_3, iuae_gl_sub_acct_4,
                      iuae_gl_sub_acct_5, iuae_gl_sub_acct_6,
                      iuae_gl_sub_acct_7, iuae_sl_type_cd, '1', iuae_sl_cd,
                      iuae_debit_amt, iuae_credit_amt, iuae_generation_type,
                      NVL (giis_users_pkg.app_user, USER), SYSDATE
                     );
      ELSE
         UPDATE giac_acct_entries
            SET debit_amt = iuae_debit_amt + debit_amt,
                credit_amt = iuae_credit_amt + credit_amt
          WHERE gl_sub_acct_1 = iuae_gl_sub_acct_1
            AND gl_sub_acct_2 = iuae_gl_sub_acct_2
            AND gl_sub_acct_3 = iuae_gl_sub_acct_3
            AND gl_sub_acct_4 = iuae_gl_sub_acct_4
            AND gl_sub_acct_5 = iuae_gl_sub_acct_5
            AND gl_sub_acct_6 = iuae_gl_sub_acct_6
            AND gl_sub_acct_7 = iuae_gl_sub_acct_7
            AND NVL (sl_cd, 1) = NVL (iuae_sl_cd, 1)
            AND generation_type = iuae_generation_type
            AND NVL (gl_acct_id, gl_acct_id) = iuae_gl_acct_id
            AND gacc_gibr_branch_cd = p_gacc_branch_cd
            AND gacc_gfun_fund_cd = p_gacc_fund_cd
            AND gacc_tran_id = p_gacc_tran_id;
      END IF;
   END giacs020_aeg_ins_upd_acct_ents;

   /*
   **  Created by   :  Emman
   **  Date Created :  08.20.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Executes procedure AEG_CREATE_ACCT_ENTRIES on GIACS026
   **                This procedure handles the creation of accounting entries per transaction.
   */
   PROCEDURE aeg_create_acct_entries (
      p_gacc_branch_cd           giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd             giac_acctrans.gfun_fund_cd%TYPE,
      p_gacc_tran_id             giac_acctrans.tran_id%TYPE,
      aeg_collection_amt         giac_bank_collns.collection_amt%TYPE,
      aeg_gen_type               giac_acct_entries.generation_type%TYPE,
      aeg_module_id              giac_modules.module_id%TYPE,
      aeg_item_no                giac_module_entries.item_no%TYPE,
      aeg_sl_cd                  giac_acct_entries.sl_cd%TYPE,
      aeg_sl_type_cd             giac_acct_entries.sl_type_cd%TYPE,
      aeg_sl_source_cd           giac_acct_entries.sl_source_cd%TYPE,
      p_message            OUT   VARCHAR2
   )
   IS
      ws_gl_acct_category     giac_acct_entries.gl_acct_category%TYPE;
      ws_gl_control_acct      giac_acct_entries.gl_control_acct%TYPE;
      ws_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      ws_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      ws_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      ws_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      ws_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      ws_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_pol_type_tag         giac_module_entries.pol_type_tag%TYPE;
      ws_intm_type_level      giac_module_entries.intm_type_level%TYPE;
      ws_old_new_acct_level   giac_module_entries.old_new_acct_level%TYPE;
      ws_line_dep_level       giac_module_entries.line_dependency_level%TYPE;
      ws_dr_cr_tag            giac_module_entries.dr_cr_tag%TYPE;
      ws_acct_intm_cd         giis_intm_type.acct_intm_cd%TYPE;
      ws_line_cd              giis_line.line_cd%TYPE;
      ws_iss_cd               gipi_polbasic.iss_cd%TYPE;
      ws_old_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_new_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      pt_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      pt_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      pt_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      pt_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      pt_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_debit_amt            giac_acct_entries.debit_amt%TYPE;
      ws_credit_amt           giac_acct_entries.credit_amt%TYPE;
      ws_gl_acct_id           giac_acct_entries.gl_acct_id%TYPE;
      ws_sl_cd                giac_acct_entries.sl_cd%TYPE;
   BEGIN
      p_message := 'SUCCESS';

      /**************************************************************************
      *                                                                         *
      * Populate the GL Account Code used in every transactions.                *
      *                                                                         *
      **************************************************************************/
      BEGIN
         SELECT        gl_acct_category, gl_control_acct,
                       gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                       gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                       gl_sub_acct_7, pol_type_tag,
                       intm_type_level, old_new_acct_level,
                       dr_cr_tag, line_dependency_level
                  INTO ws_gl_acct_category, ws_gl_control_acct,
                       ws_gl_sub_acct_1, ws_gl_sub_acct_2, ws_gl_sub_acct_3,
                       ws_gl_sub_acct_4, ws_gl_sub_acct_5, ws_gl_sub_acct_6,
                       ws_gl_sub_acct_7, ws_pol_type_tag,
                       ws_intm_type_level, ws_old_new_acct_level,
                       ws_dr_cr_tag, ws_line_dep_level
                  FROM giac_module_entries
                 WHERE module_id = aeg_module_id AND item_no = aeg_item_no
         FOR UPDATE OF gl_sub_acct_1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message := 'No data found in giac_module_entries.';
            RETURN;
      END;

      /**************************************************************************
      *                                                                         *
      * Check if the acctg code exists in GIAC_CHART_OF_ACCTS TABLE.            *
      *                                                                         *
      **************************************************************************/
      IF aeg_collection_amt > 0
      THEN
         ws_debit_amt := 0;
         ws_credit_amt := ABS (aeg_collection_amt);
      ELSE
         ws_debit_amt := ABS (aeg_collection_amt);
         ws_credit_amt := 0;
      END IF;

      /****************************************************************************
      *                                                                           *
      * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      *                                                                           *
      ****************************************************************************/
      BEGIN
         SELECT DISTINCT (gl_acct_id)
                    INTO ws_gl_acct_id
                    FROM giac_chart_of_accts
                   WHERE gl_acct_category = ws_gl_acct_category
                     AND gl_control_acct = ws_gl_control_acct
                     AND gl_sub_acct_1 = ws_gl_sub_acct_1
                     AND gl_sub_acct_2 = ws_gl_sub_acct_2
                     AND gl_sub_acct_3 = ws_gl_sub_acct_3
                     AND gl_sub_acct_4 = ws_gl_sub_acct_4
                     AND gl_sub_acct_5 = ws_gl_sub_acct_5
                     AND gl_sub_acct_6 = ws_gl_sub_acct_6
                     AND gl_sub_acct_7 = ws_gl_sub_acct_7;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message :=
                  'GL account code '
               || TO_CHAR (ws_gl_acct_category)
               || '-'
               || TO_CHAR (ws_gl_control_acct, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_1, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_2, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_3, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_4, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_5, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_6, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_7, '09')
               || ' does not exist in Chart of Accounts (Giac_Acctrans).';
            RETURN;
      END;

      BEGIN
         SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
                gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                gl_acct_id
           INTO ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                ws_gl_sub_acct_2, ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                ws_gl_sub_acct_5, ws_gl_sub_acct_6, ws_gl_sub_acct_7,
                ws_gl_acct_id
           FROM giac_chart_of_accts
          WHERE gl_acct_id = ws_gl_acct_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message :=
                  'GL account code '
               || TO_CHAR (ws_gl_acct_category)
               || '-'
               || TO_CHAR (ws_gl_control_acct, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_1, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_2, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_3, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_4, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_5, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_6, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_7, '09')
               || ' does not exist in Chart of Accounts (Giac_Acctrans).';
            RETURN;
      END;

      aeg_insert_update_acct_entries (p_gacc_branch_cd,
                                      p_gacc_fund_cd,
                                      p_gacc_tran_id,
                                      ws_gl_acct_category,
                                      ws_gl_control_acct,
                                      ws_gl_sub_acct_1,
                                      ws_gl_sub_acct_2,
                                      ws_gl_sub_acct_3,
                                      ws_gl_sub_acct_4,
                                      ws_gl_sub_acct_5,
                                      ws_gl_sub_acct_6,
                                      ws_gl_sub_acct_7,
                                      aeg_sl_cd,
                                      aeg_sl_type_cd,
                                      aeg_sl_source_cd,
                                      aeg_gen_type,
                                      ws_gl_acct_id,
                                      ws_debit_amt,
                                      ws_credit_amt
                                     );
   END aeg_create_acct_entries;

   /*
   **  Created by   :  Emman
   **  Date Created :  08.20.2010
   **  Reference By : (GIACS026 - Premium Deposit)
   **  Description  : Executes procedure AEG_PARAMETERS on GIACS026
   */
   PROCEDURE aeg_parameters (
      p_gacc_branch_cd           giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd             giac_acctrans.gfun_fund_cd%TYPE,
      p_gacc_tran_id             giac_acctrans.tran_id%TYPE,
      p_module_name              giac_modules.module_name%TYPE,
      p_dep_flag                 giac_prem_deposit.dep_flag%TYPE,
      p_b140_iss_cd              giac_prem_deposit.b140_iss_cd%TYPE,
      p_b140_prem_seq_no         giac_prem_deposit.b140_prem_seq_no%TYPE,
      p_message            OUT   VARCHAR2
   )
   IS
      v_debit_amt        giac_acct_entries.debit_amt%TYPE;
      v_credit_amt       giac_acct_entries.credit_amt%TYPE;
      ws_sl_cd           giac_acct_entries.sl_cd%TYPE;
      ws_sl_type_cd      giac_acct_entries.sl_type_cd%TYPE;
      ws_sl_source_cd    giac_acct_entries.sl_source_cd%TYPE     := 1;
      -- 1 if sl_cd is from giac_sl_list and 2 if from giis_payees
      loc_flag           giac_acctrans.tran_flag%TYPE;
      loc_tag            giac_prem_deposit.or_print_tag%TYPE;
      v_sl_type_cd       giac_acct_entries.sl_type_cd%TYPE;
      v_assd             giis_assured.assd_no%TYPE;
      v_acct_line_cd     giis_line.acct_line_cd%TYPE;
      v_parent_intm_no   giis_intermediary.parent_intm_no%TYPE;
      v_module_id        giac_modules.module_id%TYPE;
      v_gen_type         giac_modules.generation_type%TYPE;
      v_item_no          giac_bank_collns.item_no%TYPE           := 1;

      CURSOR prem_deposit_cur
      IS
         SELECT collection_amt, ri_cd, assd_no, transaction_type, intm_no,
                comm_rec_no
           FROM giac_prem_deposit
          WHERE gacc_tran_id = p_gacc_tran_id;

      CURSOR sl_type_cur
      IS
         SELECT sl_type_cd
           FROM giac_sl_types
          WHERE sl_type_name = 'ASSURED';
   BEGIN
      p_message := 'SUCCESS';

      BEGIN
         OPEN sl_type_cur;

         FETCH sl_type_cur
          INTO ws_sl_type_cd;

         CLOSE sl_type_cur;

         SELECT module_id, generation_type
           INTO v_module_id, v_gen_type
           FROM giac_modules
          WHERE module_name = p_module_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message := 'No data found in GIAC MODULES.';
            RETURN;
      END;

      /*
      ** Call the deletion of accounting entry procedure.
      */
      --
      --
      aeg_delete_acct_entries (p_gacc_tran_id, v_gen_type);

      --
      --
      FOR prem_deposit_rec IN prem_deposit_cur
      LOOP
         IF prem_deposit_rec.comm_rec_no IS NULL
         THEN
            IF prem_deposit_rec.ri_cd IS NULL
            THEN
               v_item_no := 1;
               ws_sl_cd := prem_deposit_rec.assd_no;
            ELSE
               v_item_no := 2;
               ws_sl_cd := prem_deposit_rec.assd_no;
            END IF;
         ELSE
            IF p_dep_flag = 3
            THEN
               IF prem_deposit_rec.transaction_type = 4
               THEN
                  v_item_no := 3;
               ELSIF prem_deposit_rec.transaction_type = 2
               THEN
                  v_item_no := 4;
               END IF;

               FOR g IN (SELECT sl_type_cd
                           FROM giac_module_entries
                          WHERE module_id = v_module_id
                                AND item_no = v_item_no)
               LOOP
                  v_sl_type_cd := g.sl_type_cd;
               END LOOP;
            END IF;

            FOR p IN (SELECT a.assd_no, d.acct_line_cd
                        FROM gipi_polbasic a, gipi_invoice b, giis_line d
                       WHERE a.policy_id = b.policy_id
                         AND a.assd_no = prem_deposit_rec.assd_no
                         AND a.line_cd = d.line_cd
                         AND b.iss_cd = p_b140_iss_cd
                         AND b.prem_seq_no = p_b140_prem_seq_no)
            LOOP
               v_assd := p.assd_no;
               v_acct_line_cd := p.acct_line_cd;
            END LOOP;

            /* get SL for overdraft comm entry */
            IF v_sl_type_cd = giacp.v ('LINE_SL_TYPE')
            THEN
               ws_sl_cd := v_acct_line_cd;
            ELSIF v_sl_type_cd = giacp.v ('ASSD_SL_TYPE')
            THEN
               ws_sl_cd := v_assd;
            ELSIF v_sl_type_cd = giacp.v ('INTM_SL_TYPE')
            THEN
               BEGIN
                  SELECT a.parent_intm_no
                    INTO v_parent_intm_no
                    FROM giis_intermediary a
                   WHERE a.intm_no = prem_deposit_rec.intm_no;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_parent_intm_no := NULL;
               END;

               IF v_parent_intm_no IS NOT NULL
               THEN
                  ws_sl_cd := v_parent_intm_no;
               ELSE
                  ws_sl_cd := prem_deposit_rec.intm_no;
               END IF;
            ELSE
               ws_sl_cd := NULL;
            END IF;
         END IF;

         /*
         ** Call the accounting entry generation procedure.
         */
         aeg_create_acct_entries (p_gacc_branch_cd,
                                  p_gacc_fund_cd,
                                  p_gacc_tran_id,
                                  prem_deposit_rec.collection_amt,
                                  v_gen_type,
                                  v_module_id,
                                  v_item_no,
                                  ws_sl_cd,
                                  ws_sl_type_cd,
                                  ws_sl_source_cd,
                                  p_message
                                 );
      END LOOP;
   END aeg_parameters;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.13.2010
   **  Reference By : (GIACS008 - Inward Facultative Premium Collections)
   **  Description  : AEG_Check_Level PROGRAM UNIT
   */
   PROCEDURE aeg_check_level (
      cl_level       IN       NUMBER,
      cl_value       IN       NUMBER,
      cl_sub_acct1   IN OUT   NUMBER,
      cl_sub_acct2   IN OUT   NUMBER,
      cl_sub_acct3   IN OUT   NUMBER,
      cl_sub_acct4   IN OUT   NUMBER,
      cl_sub_acct5   IN OUT   NUMBER,
      cl_sub_acct6   IN OUT   NUMBER,
      cl_sub_acct7   IN OUT   NUMBER
   )
   IS
   BEGIN
      ---msg_alert('AEG CHECK LEVEL...','I',FALSE);
      IF cl_level = 1
      THEN
         cl_sub_acct1 := cl_value;
      ELSIF cl_level = 2
      THEN
         cl_sub_acct2 := cl_value;
      ELSIF cl_level = 3
      THEN
         cl_sub_acct3 := cl_value;
      ELSIF cl_level = 4
      THEN
         cl_sub_acct4 := cl_value;
      ELSIF cl_level = 5
      THEN
         cl_sub_acct5 := cl_value;
      ELSIF cl_level = 6
      THEN
         cl_sub_acct6 := cl_value;
      ELSIF cl_level = 7
      THEN
         cl_sub_acct7 := cl_value;
      END IF;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.13.2010
   **  Reference By : (GIACS008 - Inward Facultative Premium Collections)
   **  Description  : AEG_Check_Chart_Of_Accts PROGRAM UNIT
   */
   PROCEDURE aeg_check_chart_of_accts (
      cca_gl_acct_category            giac_acct_entries.gl_acct_category%TYPE,
      cca_gl_control_acct             giac_acct_entries.gl_control_acct%TYPE,
      cca_gl_sub_acct_1               giac_acct_entries.gl_sub_acct_1%TYPE,
      cca_gl_sub_acct_2               giac_acct_entries.gl_sub_acct_2%TYPE,
      cca_gl_sub_acct_3               giac_acct_entries.gl_sub_acct_3%TYPE,
      cca_gl_sub_acct_4               giac_acct_entries.gl_sub_acct_4%TYPE,
      cca_gl_sub_acct_5               giac_acct_entries.gl_sub_acct_5%TYPE,
      cca_gl_sub_acct_6               giac_acct_entries.gl_sub_acct_6%TYPE,
      cca_gl_sub_acct_7               giac_acct_entries.gl_sub_acct_7%TYPE,
      cca_gl_acct_id         IN OUT   giac_chart_of_accts.gl_acct_id%TYPE,
      p_msg_alert            OUT      VARCHAR2
   )
   IS
   BEGIN
      SELECT DISTINCT (gl_acct_id)
                 INTO cca_gl_acct_id
                 FROM giac_chart_of_accts
                WHERE gl_acct_category = cca_gl_acct_category
                  AND gl_control_acct = cca_gl_control_acct
                  AND gl_sub_acct_1 = cca_gl_sub_acct_1
                  AND gl_sub_acct_2 = cca_gl_sub_acct_2
                  AND gl_sub_acct_3 = cca_gl_sub_acct_3
                  AND gl_sub_acct_4 = cca_gl_sub_acct_4
                  AND gl_sub_acct_5 = cca_gl_sub_acct_5
                  AND gl_sub_acct_6 = cca_gl_sub_acct_6
                  AND gl_sub_acct_7 = cca_gl_sub_acct_7;
                  
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_msg_alert :=
               'GL account code '
            || TO_CHAR (cca_gl_acct_category)
            || '-'
            || TO_CHAR (cca_gl_control_acct, '09')
            || '-'
            || TO_CHAR (cca_gl_sub_acct_1, '09')
            || '-'
            || TO_CHAR (cca_gl_sub_acct_2, '09')
            || '-'
            || TO_CHAR (cca_gl_sub_acct_3, '09')
            || '-'
            || TO_CHAR (cca_gl_sub_acct_4, '09')
            || '-'
            || TO_CHAR (cca_gl_sub_acct_5, '09')
            || '-'
            || TO_CHAR (cca_gl_sub_acct_6, '09')
            || '-'
            || TO_CHAR (cca_gl_sub_acct_7, '09')
            || ' does not exist in Chart of Accounts (Giac_Acctrans).';

            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#'||p_msg_alert); --marco - 04.20.2013 - added to prevent process from continuing
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.13.2010
   **  Reference By : (GIACS008 - Inward Facultative Premium Collections)
   **  Description  : AEG_Insert_Update_Acct_Entries PROGRAM UNIT
   */
   PROCEDURE insert_update_acct_entries (
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
      p_gacc_branch_cd        giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gacc_fund_cd          giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_tran_id          giac_acct_entries.gacc_tran_id%TYPE,
      p_user_id               giis_users.user_id%TYPE
   )
   IS
      iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
   BEGIN
      SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gacc_gibr_branch_cd = p_gacc_branch_cd
         AND gacc_gfun_fund_cd = p_gacc_fund_cd
         AND gacc_tran_id = p_gacc_tran_id
         AND NVL(sl_cd,0) = NVL(iuae_sl_cd,0) --mikel 09.09.2015; added NVL FGIC 20143
         AND generation_type = iuae_generation_type
         AND gl_acct_id = iuae_gl_acct_id;

      IF NVL (iuae_acct_entry_id, 0) = 0
      THEN
         iuae_acct_entry_id := NVL (iuae_acct_entry_id, 0) + 1;

         INSERT INTO giac_acct_entries
                     (gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                      acct_entry_id, gl_acct_id,
                      gl_acct_category, gl_control_acct,
                      gl_sub_acct_1, gl_sub_acct_2,
                      gl_sub_acct_3, gl_sub_acct_4,
                      gl_sub_acct_5, gl_sub_acct_6,
                      gl_sub_acct_7, sl_cd, debit_amt,
                      credit_amt, generation_type, user_id,
                      last_update, sl_type_cd, sl_source_cd
                     )
              VALUES (p_gacc_tran_id, p_gacc_fund_cd, p_gacc_branch_cd,
                      iuae_acct_entry_id, iuae_gl_acct_id,
                      iuae_gl_acct_category, iuae_gl_control_acct,
                      iuae_gl_sub_acct_1, iuae_gl_sub_acct_2,
                      iuae_gl_sub_acct_3, iuae_gl_sub_acct_4,
                      iuae_gl_sub_acct_5, iuae_gl_sub_acct_6,
                      iuae_gl_sub_acct_7, iuae_sl_cd, iuae_debit_amt,
                      iuae_credit_amt, iuae_generation_type, p_user_id,
                      SYSDATE, iuae_sl_type_cd, 1
                     );
      ELSE
         UPDATE giac_acct_entries
            SET debit_amt = debit_amt + iuae_debit_amt,
                credit_amt = credit_amt + iuae_credit_amt
          WHERE NVL(sl_cd, 0) = NVL(iuae_sl_cd, 0) --mikel 09.09.2015; added NVL FGIC 20143
            AND generation_type = iuae_generation_type
            AND gl_acct_id = iuae_gl_acct_id
            AND gacc_gibr_branch_cd = p_gacc_branch_cd
            AND gacc_gfun_fund_cd = p_gacc_fund_cd
            AND gacc_tran_id = p_gacc_tran_id;
      END IF;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.13.2010
   **  Reference By : (GIACS008 - Inward Facultative Premium Collections)
   **  Description  : AEG_Create_Acct_Entries PROGRAM UNIT
   */
   PROCEDURE aeg_create_acct_entries2 (
      aeg_sl_cd                giac_acct_entries.sl_cd%TYPE,
      aeg_module_id            giac_module_entries.module_id%TYPE,
      aeg_item_no              giac_module_entries.item_no%TYPE,
      aeg_iss_cd               giac_direct_prem_collns.b140_iss_cd%TYPE,
      aeg_bill_no              giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      aeg_line_cd              giis_line.line_cd%TYPE,
      aeg_type_cd              gipi_polbasic.type_cd%TYPE,
      aeg_acct_amt             giac_direct_prem_collns.collection_amt%TYPE,
      aeg_gen_type             giac_acct_entries.generation_type%TYPE,
      p_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_tran_id           giac_acct_entries.gacc_tran_id%TYPE,
      p_user_id                giis_users.user_id%TYPE,
      p_msg_alert        OUT   VARCHAR2
   )
   IS
      ws_gl_acct_category     giac_acct_entries.gl_acct_category%TYPE;
      ws_gl_control_acct      giac_acct_entries.gl_control_acct%TYPE;
      ws_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      ws_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      ws_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      ws_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      ws_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      ws_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_pol_type_tag         giac_module_entries.pol_type_tag%TYPE;
      ws_intm_type_level      giac_module_entries.intm_type_level%TYPE;
      ws_old_new_acct_level   giac_module_entries.old_new_acct_level%TYPE;
      ws_line_dep_level       giac_module_entries.line_dependency_level%TYPE;
      ws_dr_cr_tag            giac_module_entries.dr_cr_tag%TYPE;
      ws_sl_cd                giac_acct_entries.sl_cd%TYPE;
      ws_sl_type_cd           giac_acct_entries.sl_type_cd%TYPE;
      ws_acct_intm_cd         giis_intm_type.acct_intm_cd%TYPE;
      ws_line_cd              giis_line.line_cd%TYPE;
      ws_iss_cd               gipi_polbasic.iss_cd%TYPE;
      ws_old_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_new_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE       := 0;
      pt_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE       := 0;
      pt_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE       := 0;
      pt_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE       := 0;
      pt_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE       := 0;
      pt_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE       := 0;
      pt_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE       := 0;
      ws_debit_amt            giac_acct_entries.debit_amt%TYPE;
      ws_credit_amt           giac_acct_entries.credit_amt%TYPE;
      ws_gl_acct_id           giac_acct_entries.gl_acct_id%TYPE;
      v_msg_alert             VARCHAR2 (3200);
   BEGIN
      --msg_alert('AEG CREATE ACCT ENTRIES...','I',FALSE);

      /**************************************************************************
      *                                                                         *
      * Populate the GL Account Code used in every transactions.                *
      *                                                                         *
      **************************************************************************/
      BEGIN
         SELECT        gl_acct_category, gl_control_acct,
                       gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                       gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                       gl_sub_acct_7, pol_type_tag,
                       intm_type_level, old_new_acct_level,
                       dr_cr_tag, line_dependency_level, sl_type_cd
                  INTO ws_gl_acct_category, ws_gl_control_acct,
                       ws_gl_sub_acct_1, ws_gl_sub_acct_2, ws_gl_sub_acct_3,
                       ws_gl_sub_acct_4, ws_gl_sub_acct_5, ws_gl_sub_acct_6,
                       ws_gl_sub_acct_7, ws_pol_type_tag,
                       ws_intm_type_level, ws_old_new_acct_level,
                       ws_dr_cr_tag, ws_line_dep_level, ws_sl_type_cd
                  FROM giac_module_entries
                 WHERE module_id = aeg_module_id AND item_no = aeg_item_no
         FOR UPDATE OF gl_sub_acct_1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_msg_alert :=
                        NVL ('item_no' || TO_CHAR (aeg_item_no), v_msg_alert);
            p_msg_alert := 'No data found in giac_module_entriesssss.';
            RETURN;
      END;

      /**************************************************************************
      *                                                                         *
      * Validate the INTM_TYPE_LEVEL value which indicates the segment of the   *
      * GL account code that holds the intermediary type.                       *
      *                                                                         *
      **************************************************************************/
      IF ws_intm_type_level != 0
      THEN
         BEGIN
            SELECT DISTINCT (c.acct_intm_cd)
                       INTO ws_acct_intm_cd
                       FROM gipi_comm_invoice a,
                            giis_intermediary b,
                            giis_intm_type c
                      WHERE a.intrmdry_intm_no = b.intm_no
                        AND b.intm_type = c.intm_type
                        AND a.iss_cd = aeg_iss_cd
                        AND a.prem_seq_no = aeg_bill_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_msg_alert := 'No data found in giis_intm_type.';
               RETURN;
         END;

         aeg_check_level (ws_intm_type_level,
                          ws_acct_intm_cd,
                          ws_gl_sub_acct_1,
                          ws_gl_sub_acct_2,
                          ws_gl_sub_acct_3,
                          ws_gl_sub_acct_4,
                          ws_gl_sub_acct_5,
                          ws_gl_sub_acct_6,
                          ws_gl_sub_acct_7
                         );
      END IF;

      /**************************************************************************
      *                                                                         *
      * Validate the LINE_DEPENDENCY_LEVEL value which indicates the segment of *
      * the GL account code that holds the line number.                         *
      *                                                                         *
      **************************************************************************/
      IF ws_line_dep_level != 0
      THEN
         BEGIN
            SELECT acct_line_cd
              INTO ws_line_cd
              FROM giis_line
             WHERE line_cd = aeg_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_msg_alert := 'No data found in giis_line.';
               RETURN;
         END;

         aeg_check_level (ws_line_dep_level,
                          ws_line_cd,
                          ws_gl_sub_acct_1,
                          ws_gl_sub_acct_2,
                          ws_gl_sub_acct_3,
                          ws_gl_sub_acct_4,
                          ws_gl_sub_acct_5,
                          ws_gl_sub_acct_6,
                          ws_gl_sub_acct_7
                         );
      END IF;

      /**************************************************************************
      *                                                                         *
      * Validate the OLD_NEW_ACCT_LEVEL value which indicates the segment of    *
      * the GL account code that holds the old and new account values.          *
      *                                                                         *
      **************************************************************************/
      IF ws_old_new_acct_level != 0
      THEN
         BEGIN
            SELECT param_value_v
              INTO ws_iss_cd
              FROM giac_parameters
             WHERE param_name = 'OLD_ISS_CD';

            SELECT param_value_n
              INTO ws_old_acct_cd
              FROM giac_parameters
             WHERE param_name = 'OLD_ACCT_CD';

            SELECT param_value_n
              INTO ws_new_acct_cd
              FROM giac_parameters
             WHERE param_name = 'NEW_ACCT_CD';

            IF aeg_iss_cd = ws_iss_cd
            THEN
               aeg_check_level (ws_old_new_acct_level,
                                ws_old_acct_cd,
                                ws_gl_sub_acct_1,
                                ws_gl_sub_acct_2,
                                ws_gl_sub_acct_3,
                                ws_gl_sub_acct_4,
                                ws_gl_sub_acct_5,
                                ws_gl_sub_acct_6,
                                ws_gl_sub_acct_7
                               );
            ELSE
               aeg_check_level (ws_old_new_acct_level,
                                ws_new_acct_cd,
                                ws_gl_sub_acct_1,
                                ws_gl_sub_acct_2,
                                ws_gl_sub_acct_3,
                                ws_gl_sub_acct_4,
                                ws_gl_sub_acct_5,
                                ws_gl_sub_acct_6,
                                ws_gl_sub_acct_7
                               );
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_msg_alert := 'No data found in giac_parameters.';
               RETURN;
         END;
      END IF;

      /**************************************************************************
      *                                                                         *
      * Check the POL_TYPE_TAG which indicates if the policy type GL code       *
      * segments will be attached to this GL account.                           *
      *                                                                         *
      **************************************************************************/
      IF ws_pol_type_tag = 'Y'
      THEN
         BEGIN
            SELECT NVL (gl_sub_acct_1, 0), NVL (gl_sub_acct_2, 0),
                   NVL (gl_sub_acct_3, 0), NVL (gl_sub_acct_4, 0),
                   NVL (gl_sub_acct_5, 0), NVL (gl_sub_acct_6, 0),
                   NVL (gl_sub_acct_7, 0)
              INTO pt_gl_sub_acct_1, pt_gl_sub_acct_2,
                   pt_gl_sub_acct_3, pt_gl_sub_acct_4,
                   pt_gl_sub_acct_5, pt_gl_sub_acct_6,
                   pt_gl_sub_acct_7
              FROM giac_policy_type_entries
             WHERE line_cd = aeg_line_cd AND type_cd = aeg_type_cd;

            IF pt_gl_sub_acct_1 != 0
            THEN
               ws_gl_sub_acct_1 := pt_gl_sub_acct_1;
            END IF;

            IF pt_gl_sub_acct_2 != 0
            THEN
               ws_gl_sub_acct_2 := pt_gl_sub_acct_2;
            END IF;

            IF pt_gl_sub_acct_3 != 0
            THEN
               ws_gl_sub_acct_3 := pt_gl_sub_acct_3;
            END IF;

            IF pt_gl_sub_acct_4 != 0
            THEN
               ws_gl_sub_acct_4 := pt_gl_sub_acct_4;
            END IF;

            IF pt_gl_sub_acct_5 != 0
            THEN
               ws_gl_sub_acct_5 := pt_gl_sub_acct_5;
            END IF;

            IF pt_gl_sub_acct_6 != 0
            THEN
               ws_gl_sub_acct_6 := pt_gl_sub_acct_6;
            END IF;

            IF pt_gl_sub_acct_7 != 0
            THEN
               ws_gl_sub_acct_7 := pt_gl_sub_acct_7;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_msg_alert := 'No data found in giac_policy_type_entries.';
               RETURN;
         END;
      END IF;

      /**************************************************************************
      *                                                                         *
      * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
      *                                                                         *
      **************************************************************************/
      aeg_check_chart_of_accts (ws_gl_acct_category,
                                ws_gl_control_acct,
                                ws_gl_sub_acct_1,
                                ws_gl_sub_acct_2,
                                ws_gl_sub_acct_3,
                                ws_gl_sub_acct_4,
                                ws_gl_sub_acct_5,
                                ws_gl_sub_acct_6,
                                ws_gl_sub_acct_7,
                                ws_gl_acct_id,
                                v_msg_alert
                               );

      IF v_msg_alert IS NOT NULL
      THEN
         p_msg_alert := v_msg_alert;
         RETURN;
      END IF;

      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/
      IF aeg_acct_amt > 0
      THEN
         IF ws_dr_cr_tag = 'D'
         THEN
            ws_debit_amt := ABS (aeg_acct_amt);
            ws_credit_amt := 0;
         ELSE
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_acct_amt);
         END IF;
      ELSIF aeg_acct_amt < 0
      THEN
         IF ws_dr_cr_tag = 'D'
         THEN
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_acct_amt);
         ELSE
            ws_debit_amt := ABS (aeg_acct_amt);
            ws_credit_amt := 0;
         END IF;
      END IF;

        /****************************************************************************
        *                                                                           *
        * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
        * same transaction id.  Insert the record if it does not exists else update *
        * the existing record.                                                      *
        *                                                                           *
        ****************************************************************************/
      --msg_alert('tst', 'i', false);
      insert_update_acct_entries (ws_gl_acct_category,
                                  ws_gl_control_acct,
                                  ws_gl_sub_acct_1,
                                  ws_gl_sub_acct_2,
                                  ws_gl_sub_acct_3,
                                  ws_gl_sub_acct_4,
                                  ws_gl_sub_acct_5,
                                  ws_gl_sub_acct_6,
                                  ws_gl_sub_acct_7,
                                  aeg_sl_cd,
                                  ws_sl_type_cd,
                                  aeg_gen_type,
                                  ws_gl_acct_id,
                                  ws_debit_amt,
                                  ws_credit_amt,
                                  p_gacc_branch_cd,
                                  p_gacc_fund_cd,
                                  p_gacc_tran_id,
                                  p_user_id
                                 );

      <<exit>>
      p_msg_alert := NVL (v_msg_alert, v_msg_alert);
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.13.2010
   **  Reference By : (GIACS008 - Inward Facultative Premium Collections)
   **  Description  : aeg_parameters PROGRAM UNIT
   */
   PROCEDURE aeg_parameters2 (
      aeg_tran_id              giac_acctrans.tran_id%TYPE,
      aeg_module_nm            giac_modules.module_name%TYPE,
      aeg_sl_type_cd1          giac_parameters.param_name%TYPE,
      aeg_sl_type_cd2          giac_parameters.param_name%TYPE,
      p_gen_type               giac_acct_entries.generation_type%TYPE,
      p_module_id              giac_modules.module_id%TYPE,
      p_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_user_id                giis_users.user_id%TYPE,
      p_msg_alert        OUT   VARCHAR2
   )
   IS
      /* parameter inwprem_take_up was added*/
      /* modified by judyann 10312006
      ** removed giac_aging_ri_soa_details in select,
      ** since problem occurs when payment being made is for an installment
      */
      CURSOR pr_cur
      IS
         SELECT c.b140_iss_cd iss_cd, c.collection_amt,
                c.b140_prem_seq_no bill_no, a.line_cd,
                DECODE (aeg_sl_type_cd1,
                        'ASSD_SL_TYPE', a.assd_no,
                        'RI_SL_TYPE', c.a180_ri_cd,
                        'LINE_SL_TYPE', h.acct_line_cd
                       ) sl_cd,
                a.type_cd, c.tax_amount, c.comm_vat
           FROM gipi_polbasic a,
                gipi_invoice b,
                giac_inwfacul_prem_collns c,
                giis_line h
          WHERE a.policy_id = b.policy_id
            AND b.iss_cd = c.b140_iss_cd
            AND b.prem_seq_no = c.b140_prem_seq_no
            AND c.gacc_tran_id = aeg_tran_id
            AND a.line_cd = h.line_cd;

      /*cursor for the premium_amt entries*/
      CURSOR premium_cur
      IS
         SELECT c.b140_iss_cd iss_cd,
                (c.premium_amt + c.tax_amount) premium_amt,
                c.b140_prem_seq_no bill_no, a.line_cd,
                DECODE (aeg_sl_type_cd1,
                        'ASSD_SL_TYPE', a.assd_no,
                        'RI_SL_TYPE', c.a180_ri_cd,
                        'LINE_SL_TYPE', h.acct_line_cd
                       ) sl_cd,
                a.type_cd
           FROM gipi_polbasic a,
                gipi_invoice b,
                giac_inwfacul_prem_collns c,
                giis_line h
          WHERE a.policy_id = b.policy_id
            AND b.iss_cd = c.b140_iss_cd
            AND b.prem_seq_no = c.b140_prem_seq_no
            AND c.gacc_tran_id = aeg_tran_id
            AND a.line_cd = h.line_cd;

      /*cursor for the comm_amt entries*/
      CURSOR commission_cur
      IS
         SELECT c.b140_iss_cd iss_cd, c.comm_amt, c.b140_prem_seq_no bill_no,
                a.line_cd,
                DECODE (aeg_sl_type_cd2,
                        'ASSD_SL_TYPE', a.assd_no,
                        'RI_SL_TYPE', c.a180_ri_cd,
                        'LINE_SL_TYPE', h.acct_line_cd
                       ) sl_cd,
                a.type_cd
           FROM gipi_polbasic a,
                gipi_invoice b,
                giac_inwfacul_prem_collns c,
                giis_line h
          WHERE a.policy_id = b.policy_id
            AND b.iss_cd = c.b140_iss_cd
            AND b.prem_seq_no = c.b140_prem_seq_no
            AND c.gacc_tran_id = aeg_tran_id
            AND a.line_cd = h.line_cd
            AND c.comm_amt != 0;

      negative_one        NUMBER                               := -1;
      v_inwprem_take_up   giac_parameters.param_value_v%TYPE;
      v_item_no           giac_module_entries.item_no%TYPE     := 1;
      v_item_no2          giac_module_entries.item_no%TYPE     := 2;
      v_msg_alert         VARCHAR2 (32000);
   BEGIN
      giac_acct_entries_pkg.aeg_delete_acct_entries (aeg_tran_id, p_gen_type);
      v_inwprem_take_up := giacp.v ('INWPREM_TAKE_UP');

      IF v_inwprem_take_up = 1
      THEN
         BEGIN
            FOR pr_rec IN pr_cur
            LOOP
               aeg_create_acct_entries2 (pr_rec.sl_cd,
                                         p_module_id,
                                         v_item_no,
                                         pr_rec.iss_cd,
                                         pr_rec.bill_no,
                                         pr_rec.line_cd,
                                         pr_rec.type_cd,
                                         pr_rec.collection_amt,
                                         p_gen_type,
                                         p_gacc_branch_cd,
                                         p_gacc_fund_cd,
                                         aeg_tran_id,
                                         p_user_id,
                                         v_msg_alert
                                        );

               IF v_msg_alert IS NOT NULL
               THEN
                  GOTO EXIT;
               END IF;

               IF NVL (giacp.v ('DEF_RI_VAT_ENTRY'), 'Y') = 'Y'
               THEN
                  IF pr_rec.tax_amount <> 0
                  THEN
                     FOR tax_rec IN 3 .. 4
                     LOOP
                        aeg_create_acct_entries2 (pr_rec.sl_cd,
                                                  p_module_id,
                                                  tax_rec,
                                                  pr_rec.iss_cd,
                                                  pr_rec.bill_no,
                                                  pr_rec.line_cd,
                                                  pr_rec.type_cd,
                                                  pr_rec.tax_amount,
                                                  p_gen_type,
                                                  p_gacc_branch_cd,
                                                  p_gacc_fund_cd,
                                                  aeg_tran_id,
                                                  p_user_id,
                                                  v_msg_alert
                                                 );

                        IF v_msg_alert IS NOT NULL
                        THEN
                           GOTO EXIT;
                        END IF;
                     END LOOP;
                  END IF;

                  IF pr_rec.comm_vat <> 0
                  THEN
                     FOR comm_vat_rec IN 5 .. 6
                     LOOP
                        aeg_create_acct_entries2 (pr_rec.sl_cd,
                                                  p_module_id,
                                                  comm_vat_rec,
                                                  pr_rec.iss_cd,
                                                  pr_rec.bill_no,
                                                  pr_rec.line_cd,
                                                  pr_rec.type_cd,
                                                  pr_rec.comm_vat,
                                                  p_gen_type,
                                                  p_gacc_branch_cd,
                                                  p_gacc_fund_cd,
                                                  aeg_tran_id,
                                                  p_user_id,
                                                  v_msg_alert
                                                 );

                        IF v_msg_alert IS NOT NULL
                        THEN
                           GOTO EXIT;
                        END IF;
                     END LOOP;
                  END IF;
               END IF;
            --v--
            END LOOP;
         END;
      ELSE
         IF v_inwprem_take_up = 2
         THEN
            BEGIN
               FOR premium_rec IN premium_cur
               LOOP
                  aeg_create_acct_entries2 (premium_rec.sl_cd,
                                            p_module_id,
                                            v_item_no,
                                            premium_rec.iss_cd,
                                            premium_rec.bill_no,
                                            premium_rec.line_cd,
                                            premium_rec.type_cd,
                                            premium_rec.premium_amt,
                                            p_gen_type,
                                            p_gacc_branch_cd,
                                            p_gacc_fund_cd,
                                            aeg_tran_id,
                                            p_user_id,
                                            v_msg_alert
                                           );

                  IF v_msg_alert IS NOT NULL
                  THEN
                     GOTO EXIT;
                  END IF;
               END LOOP;

               FOR commission_rec IN commission_cur
               LOOP
                  aeg_create_acct_entries2 (commission_rec.sl_cd,
                                            p_module_id,
                                            v_item_no2,
                                            commission_rec.iss_cd,
                                            commission_rec.bill_no,
                                            commission_rec.line_cd,
                                            commission_rec.type_cd,
                                            commission_rec.comm_amt,
                                            p_gen_type,
                                            p_gacc_branch_cd,
                                            p_gacc_fund_cd,
                                            aeg_tran_id,
                                            p_user_id,
                                            v_msg_alert
                                           );

                  IF v_msg_alert IS NOT NULL
                  THEN
                     GOTO EXIT;
                  END IF;
               END LOOP;
               
               --mikel 08.22.2016; PFIC SR 5597
               FOR pr_rec IN pr_cur
               LOOP
                    IF pr_rec.comm_vat <> 0 THEN 
                       FOR comm_vat_rec IN 6 .. 6
                       LOOP
                            aeg_create_acct_entries2 (pr_rec.sl_cd,
                            p_module_id,
                            comm_vat_rec,
                            pr_rec.iss_cd,
                            pr_rec.bill_no,
                            pr_rec.line_cd,
                            pr_rec.type_cd,
                            pr_rec.comm_vat,
                            p_gen_type,
                            p_gacc_branch_cd,
                            p_gacc_fund_cd,
                            aeg_tran_id,
                            p_user_id,
                            v_msg_alert
                            );

                           IF v_msg_alert IS NOT NULL
                              THEN
                                GOTO EXIT;
                           END IF;
                       END LOOP; 
                    END IF;   
               END LOOP;            
            END;
         END IF;
      END IF;

      <<exit>>
      p_msg_alert := NVL (v_msg_alert, v_msg_alert);
   END;

   /*
   **  Created by   :  Tonio
   **  Date Created :  08.21.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure AEG_DELETE_ACCT_ENTRIES_Y on GIACS007
   **                Delete all records existing in GIAC_ACCT_ENTRIES table having the same
   **            tran_id as p_gacc_tran_id.
   */
   PROCEDURE aeg_delete_acct_entries_y (
      p_gacc_tran_id         giac_prem_deposit.gacc_tran_id%TYPE,
      p_module_name          giac_modules.module_name%TYPE,
      p_module_id      OUT   giac_modules.module_id%TYPE,
      p_gen_type       OUT   giac_modules.generation_type%TYPE
   )
   IS
      dummy   VARCHAR2 (1);

      CURSOR ae
      IS
         SELECT '1'
           FROM giac_acct_entries
          WHERE gacc_tran_id = p_gacc_tran_id
            AND generation_type = (SELECT generation_type
                                     FROM giac_modules
                                    WHERE module_name = p_module_name);
   BEGIN
      BEGIN
         SELECT module_id, generation_type
           INTO p_module_id, p_gen_type
           FROM giac_modules
          WHERE module_name = p_module_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (20001, 'No data found in GIAC MODULES.');
      END;

      OPEN ae;

      FETCH ae
       INTO dummy;

      IF dummy IS NOT NULL
      THEN
         DELETE FROM giac_acct_entries
               WHERE gacc_tran_id = p_gacc_tran_id
                 AND generation_type = p_gen_type;
      END IF;
   END;

   PROCEDURE giacs020_overdraft_comm_entry (
      p_gacc_branch_cd   IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd     IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_gacc_tran_id     IN       giac_comm_payts.gacc_tran_id%TYPE,
      p_iss_cd           IN       giac_comm_payts.iss_cd%TYPE,
      p_prem_seq_no      IN       giac_comm_payts.prem_seq_no%TYPE,
      p_intm_no          IN       giac_comm_payts.intm_no%TYPE,
      p_record_no        IN       giac_comm_payts.record_no%TYPE,
      p_disb_comm        IN       giac_comm_payts.disb_comm%TYPE,
      p_drv_comm_amt     IN       NUMBER,
      p_currency_cd      IN       giac_comm_payts.currency_cd%TYPE,
      p_convert_rate     IN       giac_comm_payts.convert_rate%TYPE,
      p_message          OUT      VARCHAR2
   )
   IS
      v_gl_acct_category        giac_acct_entries.gl_acct_category%TYPE;
      v_gl_control_acct         giac_acct_entries.gl_control_acct%TYPE;
      v_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
      v_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
      v_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
      v_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
      v_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
      v_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
      v_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
      v_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
      v_debit_amt               giac_acct_entries.debit_amt%TYPE         := 0;
      v_credit_amt              giac_acct_entries.credit_amt%TYPE        := 0;
      v_acct_entry_id           giac_acct_entries.acct_entry_id%TYPE;
      v_gen_type                giac_modules.generation_type%TYPE;
      v_gl_acct_id              giac_chart_of_accts.gl_acct_id%TYPE;
      v_sl_type_cd              giac_module_entries.sl_type_cd%TYPE;
      v_intm_type_level         giac_module_entries.intm_type_level%TYPE;
      v_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
      v_diff_comm               giac_comm_payts.comm_amt%TYPE;
                                                         -- judyann 06142006;
      -- difference between computed net comm and actual disbursed comm
      v_assd                    giac_prem_deposit.assd_no%TYPE;
      v_assured                 giis_assured.assd_name%TYPE;
      --giac_prem_deposit.assured_name%type; to prevent ora-06502 issa06.12.2007
      v_line                    giac_prem_deposit.line_cd%TYPE;
      v_subline                 giac_prem_deposit.subline_cd%TYPE;
      v_iss                     giac_prem_deposit.iss_cd%TYPE;
      v_issue_yy                giac_prem_deposit.issue_yy%TYPE;
      v_pol_seq                 giac_prem_deposit.pol_seq_no%TYPE;
      v_renew_no                giac_prem_deposit.renew_no%TYPE;
      v_item_no                 giac_prem_deposit.item_no%TYPE;
      o_sl_cd                   giac_acct_entries.sl_cd%TYPE;
      v_parent_intm_no          giis_intermediary.parent_intm_no%TYPE;
      v_acct_line_cd            giis_line.acct_line_cd%TYPE;
      v_gen_type2               giac_modules.generation_type%TYPE;
      v_pd_exist                VARCHAR2 (1);
      v_comm_diff               giac_comm_payts.comm_amt%TYPE;
      v_item_diff               giac_module_entries.item_no%TYPE;
   BEGIN
      FOR j IN (SELECT '1' exist
                  FROM giac_prem_deposit
                 WHERE gacc_tran_id = p_gacc_tran_id
                   AND b140_iss_cd = p_iss_cd
                   AND b140_prem_seq_no = p_prem_seq_no
                   AND intm_no = p_intm_no
                   AND comm_rec_no = p_record_no)
      LOOP
         v_pd_exist := j.exist;
      END LOOP;

      IF p_disb_comm IS NOT NULL
      THEN
         v_diff_comm := NVL (p_drv_comm_amt, 0) - p_disb_comm;
      ELSE
         v_diff_comm := 0;
      END IF;

      -- GET_PREMDEP_ITEM_NO
      BEGIN
         SELECT NVL (MAX (item_no), 0) + 1
           INTO v_item_no
           FROM giac_prem_deposit
          WHERE gacc_tran_id = p_gacc_tran_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_item_no := 1;
      END;

      FOR p IN (SELECT a.assd_no, c.assd_name, a.line_cd, a.subline_cd,
                       a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                       d.acct_line_cd
                  FROM gipi_polbasic a,
                       gipi_invoice b,
                       giis_assured c,
                       giis_line d
                 WHERE a.policy_id = b.policy_id
                   AND a.assd_no = c.assd_no
                   AND a.line_cd = d.line_cd
                   AND b.iss_cd = p_iss_cd
                   AND b.prem_seq_no = p_prem_seq_no)
      LOOP
         v_assd := p.assd_no;
         v_assured := p.assd_name;
         v_line := p.line_cd;
         v_subline := p.subline_cd;
         v_iss := p.iss_cd;
         v_issue_yy := p.issue_yy;
         v_pol_seq := p.pol_seq_no;
         v_renew_no := p.renew_no;
         v_acct_line_cd := p.acct_line_cd;
      END LOOP;

      IF v_diff_comm > 0
      THEN
         IF v_pd_exist IS NULL
         THEN
            INSERT INTO giac_prem_deposit
                        (gacc_tran_id, item_no, transaction_type,
                         collection_amt, dep_flag, assd_no, assured_name,
                         b140_iss_cd, b140_prem_seq_no, line_cd, subline_cd,
                         iss_cd, issue_yy, pol_seq_no, renew_no,
                         currency_cd, convert_rate,
                         foreign_curr_amt,
                         colln_dt, or_print_tag, or_tag, comm_rec_no,
                         intm_no, remarks,
                         user_id, last_update
                        )
                 VALUES (p_gacc_tran_id, v_item_no, 1,
                         v_diff_comm, 3, v_assd, v_assured,
                         p_iss_cd, p_prem_seq_no, v_line, v_subline,
                         v_iss, v_issue_yy, v_pol_seq, v_renew_no,
                         p_currency_cd, p_convert_rate,
                         v_diff_comm / NVL (p_convert_rate, 1),
                         TRUNC (SYSDATE), 'N', 'N', p_record_no,
                         p_intm_no, 'For overdraft of commission',
                         NVL (giis_users_pkg.app_user, USER), SYSDATE
                        );
         END IF;
      ELSIF v_diff_comm < 0
      THEN
         IF v_pd_exist IS NULL
         THEN
            INSERT INTO giac_prem_deposit
                        (gacc_tran_id, item_no, transaction_type,
                         collection_amt, dep_flag, assd_no, assured_name,
                         b140_iss_cd, b140_prem_seq_no, line_cd, subline_cd,
                         iss_cd, issue_yy, pol_seq_no, renew_no,
                         currency_cd, convert_rate,
                         foreign_curr_amt,
                         colln_dt, or_print_tag, or_tag, comm_rec_no,
                         intm_no, remarks,
                         user_id, last_update
                        )
                 VALUES (p_gacc_tran_id, v_item_no, 3,
                         v_diff_comm, 3, v_assd, v_assured,
                         p_iss_cd, p_prem_seq_no, v_line, v_subline,
                         v_iss, v_issue_yy, v_pol_seq, v_renew_no,
                         p_currency_cd, p_convert_rate,
                         v_diff_comm / NVL (p_convert_rate, 1),
                         TRUNC (SYSDATE), 'N', 'N', p_record_no,
                         p_intm_no, 'For overdraft of commission',
                         NVL (giis_users_pkg.app_user, USER), SYSDATE
                        );
         END IF;
      END IF;

      FOR c IN (SELECT iss_cd, prem_seq_no, intm_no,
                       NVL (comm_amt, 0) comm_amt, NVL (wtax_amt, 0) wtax_amt,
                       NVL (input_vat_amt, 0) input_vat_amt,
                       NVL (disb_comm, 0) disb_comm
                  FROM giac_comm_payts
                 WHERE gacc_tran_id = p_gacc_tran_id)
      LOOP
         IF c.disb_comm <> 0
         THEN
            v_comm_diff :=
                    c.disb_comm
                    - (c.comm_amt - c.wtax_amt + c.input_vat_amt);

            IF v_comm_diff > 0
            THEN
               v_item_diff := 3;
            ELSIF v_comm_diff < 0
            THEN
               v_item_diff := 4;
            END IF;

            BEGIN
               SELECT a.gl_acct_category, a.gl_control_acct,
                      NVL (a.gl_sub_acct_1, 0), NVL (a.gl_sub_acct_2, 0),
                      NVL (a.gl_sub_acct_3, 0), NVL (a.gl_sub_acct_4, 0),
                      NVL (a.gl_sub_acct_5, 0), NVL (a.gl_sub_acct_6, 0),
                      NVL (a.gl_sub_acct_7, 0), a.sl_type_cd,
                      NVL (a.intm_type_level, 0), a.dr_cr_tag,
                      b.generation_type, a.gl_acct_category,
                      a.gl_control_acct
                 INTO v_gl_acct_category, v_gl_control_acct,
                      v_gl_sub_acct_1, v_gl_sub_acct_2,
                      v_gl_sub_acct_3, v_gl_sub_acct_4,
                      v_gl_sub_acct_5, v_gl_sub_acct_6,
                      v_gl_sub_acct_7, v_sl_type_cd,
                      v_intm_type_level, v_dr_cr_tag,
                      v_gen_type, v_gl_acct_category,
                      v_gl_control_acct
                 FROM giac_module_entries a, giac_modules b
                WHERE b.module_name = 'GIACS026'
                  AND a.item_no = v_item_diff
                  AND b.module_id = a.module_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  p_message :=
                     'Overdraft Comm - No data found in GIAC_MODULE_ENTRIES.  GIACS026, Item No. 3 and 4';
                  RETURN;
            END;

            giac_acct_entries_pkg.aeg_check_chart_of_accts
                                                          (v_gl_acct_category,
                                                           v_gl_control_acct,
                                                           v_gl_sub_acct_1,
                                                           v_gl_sub_acct_2,
                                                           v_gl_sub_acct_3,
                                                           v_gl_sub_acct_4,
                                                           v_gl_sub_acct_5,
                                                           v_gl_sub_acct_6,
                                                           v_gl_sub_acct_7,
                                                           v_gl_acct_id,
                                                           p_message
                                                          );

            IF v_comm_diff > 0
            THEN
               IF v_dr_cr_tag = 'D'
               THEN
                  v_debit_amt := v_comm_diff;
                  v_credit_amt := 0;
               ELSE
                  v_debit_amt := 0;
                  v_credit_amt := v_comm_diff;
               END IF;
            ELSIF v_comm_diff < 0
            THEN
               IF v_dr_cr_tag = 'D'
               THEN
                  v_debit_amt := v_comm_diff * -1;
                  v_credit_amt := 0;
               ELSE
                  v_debit_amt := 0;
                  v_credit_amt := v_comm_diff * -1;
               END IF;
            END IF;

            FOR g IN (SELECT generation_type
                        FROM giac_modules
                       WHERE module_name = 'GIACS020')
            LOOP
               v_gen_type2 := g.generation_type;
            END LOOP;

            /* get SL for overdraft comm entry */
            IF v_sl_type_cd = giacp.v ('LINE_SL_TYPE')
            THEN
               o_sl_cd := v_acct_line_cd;
            ELSIF v_sl_type_cd = giacp.v ('ASSD_SL_TYPE')
            THEN
               o_sl_cd := v_assd;
            ELSIF v_sl_type_cd = giacp.v ('INTM_SL_TYPE')
            THEN
               BEGIN
                  SELECT a.parent_intm_no
                    INTO v_parent_intm_no
                    FROM giis_intermediary a
                   WHERE a.intm_no = c.intm_no;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_parent_intm_no := NULL;
               END;

               IF v_parent_intm_no IS NOT NULL
               THEN
                  o_sl_cd := v_parent_intm_no;
               ELSE
                  o_sl_cd := c.intm_no;
               END IF;
            ELSE
               o_sl_cd := NULL;
            END IF;

            giac_acct_entries_pkg.giacs020_aeg_ins_upd_acct_ents
                                                          (p_gacc_branch_cd,
                                                           p_gacc_fund_cd,
                                                           p_gacc_tran_id,
                                                           v_gl_acct_category,
                                                           v_gl_control_acct,
                                                           v_gl_sub_acct_1,
                                                           v_gl_sub_acct_2,
                                                           v_gl_sub_acct_3,
                                                           v_gl_sub_acct_4,
                                                           v_gl_sub_acct_5,
                                                           v_gl_sub_acct_6,
                                                           v_gl_sub_acct_7,
                                                           v_sl_type_cd,
                                                           '1',
                                                           o_sl_cd,
                                                           v_gen_type2,
                                                           v_gl_acct_id,
                                                           v_debit_amt,
                                                           v_credit_amt
                                                          );
         END IF;
      END LOOP;
   END giacs020_overdraft_comm_entry;

   /*
   **  Created by   :  Tonio
   **  Date Created :  10.06.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure gen_acct_entr_yon GIACS007
   */
   PROCEDURE gen_acct_entr_y (
      p_gacc_tran_id                giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_module_name                 giac_modules.module_name%TYPE,
      p_item_no               OUT   INTEGER,
      p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE
   )
   IS
   BEGIN
      IF NVL (giacp.v ('PREM_REC_GROSS_TAG'), 'Y') = 'Y'
      THEN
         IF NVL (giacp.v ('ENTER_ADVANCED_PAYT'), 'N') = 'Y'
         THEN
            giac_acct_entries_pkg.aeg_parameters_y_prem_rec
                                                      (p_gacc_tran_id,
                                                       p_module_name,
                                                       p_item_no,
                                                       p_giop_gacc_branch_cd,
                                                       p_giop_gacc_fund_cd
                                                      );
            giac_acct_entries_pkg.aeg_parameters_y_prem_dep
                                                       (p_gacc_tran_id,
                                                        p_module_name,
                                                        p_item_no,
                                                        p_giop_gacc_branch_cd,
                                                        p_giop_gacc_fund_cd
                                                       );
         ELSE
            giac_acct_entries_pkg.aeg_parameters_y (p_gacc_tran_id,
                                                    p_module_name,
                                                    p_item_no,
                                                    p_giop_gacc_branch_cd,
                                                    p_giop_gacc_fund_cd
                                                   );
         END IF;
      END IF;
   END gen_acct_entr_y;

    /*
   **  Created by   :  Tonio
   **  Date Created :  10.06.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure aeg_parameters_y GIACS007
   */
   PROCEDURE aeg_parameters_y (
      aeg_tran_id                   giac_acctrans.tran_id%TYPE,
      aeg_module_nm                 giac_modules.module_name%TYPE,
      p_item_no               OUT   NUMBER,
      p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE
   )
   IS
      CURSOR pr_cur
      IS
/*
     SELECT c.b140_iss_cd iss_cd      , c.collection_amt,
           c.b140_prem_seq_no bill_no, a.line_cd       ,
      d.assd_no                 , a.type_cd
      FROM gipi_polbasic a,
           gipi_invoice  b,
           giac_direct_prem_collns c,
           gipi_parlist d --added by jeannette 09072000
     WHERE a.policy_id    = b.policy_id
       AND b.iss_cd       = c.b140_iss_cd
       AND b.prem_seq_no  = c.b140_prem_seq_no
       AND a.par_id       = d.par_id
       AND c.gacc_tran_id = aeg_tran_id;
*/
         SELECT   c.b140_iss_cd iss_cd, SUM (c.collection_amt)
                                                              collection_amt,
                  c.b140_prem_seq_no bill_no, a.line_cd, d.assd_no,
                  a.type_cd
             FROM gipi_polbasic a,
                  gipi_invoice b,
                  giac_direct_prem_collns c,
                  gipi_parlist d                 --added by jeannette 09072000
            WHERE a.policy_id = b.policy_id
              AND b.iss_cd = c.b140_iss_cd
              AND b.prem_seq_no = c.b140_prem_seq_no
              AND a.par_id = d.par_id
              AND c.gacc_tran_id = aeg_tran_id
         GROUP BY c.b140_iss_cd,
                  c.b140_prem_seq_no,
                  a.line_cd,
                  d.assd_no,
                  a.type_cd;

      CURSOR evat_cur (
         p_iss_cd    gipi_invoice.iss_cd%TYPE,
         p_bill_no   gipi_invoice.prem_seq_no%TYPE
      )
      IS
/*
    SELECT d.tax_amt   tax_amt
      FROM gipi_inv_tax d
       where d.iss_cd = p_iss_cd
       and d.prem_seq_no = p_bill_no
       AND d.tax_cd = variables.evat;
*/

         /*
             SELECT tax_amt
               FROM giac_tax_collns
              WHERE b160_iss_cd = p_iss_cd
                AND b160_prem_seq_no = p_bill_no
                AND gacc_tran_id = aeg_tran_id
                AND b160_tax_cd = variables.evat;
         */
         SELECT   SUM (tax_amt) tax_amt, b160_iss_cd, b160_prem_seq_no
             FROM giac_tax_collns
            WHERE b160_iss_cd = p_iss_cd
              AND b160_prem_seq_no = p_bill_no
              AND gacc_tran_id = aeg_tran_id
              AND b160_tax_cd = giacp.n ('EVAT')
         GROUP BY b160_iss_cd, b160_prem_seq_no
           HAVING NVL (SUM (tax_amt), 0) <> 0;

      --Vincent 03062006: added so as not to generate 0 amt acct entries
      v_module_id   giac_modules.module_id%TYPE;
      v_gen_type    giac_modules.generation_type%TYPE;
      v_sl_type_cd  giac_module_entries.sl_type_cd%TYPE; --added by reymon 11212013
   BEGIN
      BEGIN
         SELECT module_id, generation_type
           INTO v_module_id, v_gen_type
           FROM giac_modules
          WHERE module_name = aeg_module_nm;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20001,
                                     'No data found in GIAC MODULES.');
      END;
      
      BEGIN
          SELECT sl_type_cd
            INTO v_sl_type_cd
            FROM giac_module_entries
           WHERE module_id = v_module_id
             AND item_no = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            v_sl_type_cd := NULL;
      END;

      giac_acct_entries_pkg.aeg_delete_acct_entries_y (aeg_tran_id,
                                                       aeg_module_nm,
                                                       v_module_id,
                                                       v_gen_type
                                                      );

      --
      --
      FOR pr_rec IN pr_cur
      LOOP
         DBMS_OUTPUT.put_line ('here1');
         /*
         ** Call the accounting entry generation procedure.
         */
         --
         --
         DBMS_OUTPUT.put_line (   'pr_rec.assd_no: '
                               || pr_rec.assd_no
                               || ' v_module_id: '
                               || v_module_id
                               || ' p_item_no: '
                               || p_item_no
                              );
         DBMS_OUTPUT.put_line (   'pr_rec.iss_cd: '
                               || pr_rec.iss_cd
                               || ' pr_rec.bill_no: '
                               || pr_rec.bill_no
                               || ' pr_rec.line_cd: '
                               || pr_rec.line_cd
                              );
         DBMS_OUTPUT.put_line (   'pr_rec.type_cd: '
                               || pr_rec.type_cd
                               || ' pr_rec.collection_amt: '
                               || pr_rec.collection_amt
                               || ' v_gen_type: '
                               || v_gen_type
                              );
         DBMS_OUTPUT.put_line (   'p_giop_gacc_branch_cd: '
                               || p_giop_gacc_branch_cd
                               || ' p_giop_gacc_fund_cd: '
                               || p_giop_gacc_fund_cd
                               || ' aeg_tran_id: '
                               || aeg_tran_id
                              );
        
         IF v_sl_type_cd = 1 THEN --added condition for premium receivable sl type reymon 11212013
             giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                          (pr_rec.assd_no,
                                                           v_module_id,
                                                           p_item_no,
                                                           pr_rec.iss_cd,
                                                           pr_rec.bill_no,
                                                           pr_rec.line_cd,
                                                           pr_rec.type_cd,
                                                           pr_rec.collection_amt,
                                                           v_gen_type,
                                                           p_giop_gacc_branch_cd,
                                                           p_giop_gacc_fund_cd,
                                                           aeg_tran_id
                                                          );
         ELSIF v_sl_type_cd = 3 THEN
            FOR i IN (SELECT *
                        FROM TABLE (giac_acct_entries_pkg.intm_rec_computation (pr_rec.iss_cd, pr_rec.bill_no, pr_rec.collection_amt, aeg_tran_id)))
            LOOP
             giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                              (i.sl_cd,
                                                               v_module_id,
                                                               p_item_no,
                                                               pr_rec.iss_cd,
                                                               pr_rec.bill_no,
                                                               pr_rec.line_cd,
                                                               pr_rec.type_cd,
                                                               i.amount,
                                                               v_gen_type,
                                                               p_giop_gacc_branch_cd,
                                                               p_giop_gacc_fund_cd,
                                                               aeg_tran_id
                                                              );
            END LOOP;
         ELSIF v_sl_type_cd = 6 THEN
            FOR i IN (SELECT *
                        FROM TABLE (giac_acct_entries_pkg.peril_rec_computation (pr_rec.iss_cd, pr_rec.bill_no, pr_rec.collection_amt, aeg_tran_id)))
            LOOP
                giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                              (i.sl_cd,
                                                               v_module_id,
                                                               p_item_no,
                                                               pr_rec.iss_cd,
                                                               pr_rec.bill_no,
                                                               pr_rec.line_cd,
                                                               pr_rec.type_cd,
                                                               i.amount,
                                                               v_gen_type,
                                                               p_giop_gacc_branch_cd,
                                                               p_giop_gacc_fund_cd,
                                                               aeg_tran_id
                                                              );
            END LOOP;
         ELSIF v_sl_type_cd IS NULL THEN
             giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                          (NULL,
                                                           v_module_id,
                                                           p_item_no,
                                                           pr_rec.iss_cd,
                                                           pr_rec.bill_no,
                                                           pr_rec.line_cd,
                                                           pr_rec.type_cd,
                                                           pr_rec.collection_amt,
                                                           v_gen_type,
                                                           p_giop_gacc_branch_cd,
                                                           p_giop_gacc_fund_cd,
                                                           aeg_tran_id
                                                          );
         ELSE
             giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                          (pr_rec.assd_no,
                                                           v_module_id,
                                                           p_item_no,
                                                           pr_rec.iss_cd,
                                                           pr_rec.bill_no,
                                                           pr_rec.line_cd,
                                                           pr_rec.type_cd,
                                                           pr_rec.collection_amt,
                                                           v_gen_type,
                                                           p_giop_gacc_branch_cd,
                                                           p_giop_gacc_fund_cd,
                                                           aeg_tran_id
                                                          );         
         END IF;
         --end 11212013
         
         DBMS_OUTPUT.put_line ('here2');

         FOR evat_rec IN evat_cur (pr_rec.iss_cd, pr_rec.bill_no)
         LOOP
            DBMS_OUTPUT.put_line ('here3');

            IF NVL (giacp.v ('OUTPUT_VAT_COLLN_ENTRY'), 'N') = 'Y'
            THEN
               /* from giac_taxes
               AEG_Create_Acct_Entries_tax_N(VARIABLES.evat, EVAT_rec.tax_amt,
                                            VARIABLES.gen_type);
               */

               /* item_no 7 - deferred output vat*/
               giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                      (NULL,
                                                       v_module_id,
                                                       7,
                                                       pr_rec.iss_cd,
                                                       pr_rec.bill_no,
                                                       pr_rec.line_cd,
                                                       pr_rec.type_cd,
                                                       evat_rec.tax_amt,
                                                       v_gen_type,
                                                       p_giop_gacc_branch_cd,
                                                       p_giop_gacc_fund_cd,
                                                       aeg_tran_id
                                                      );
               /* item_no 6 - output vat payable*/
               giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                       (NULL,
                                                        v_module_id,
                                                        6,
                                                        pr_rec.iss_cd,
                                                        pr_rec.bill_no,
                                                        pr_rec.line_cd,
                                                        pr_rec.type_cd,
                                                        evat_rec.tax_amt,
                                                        v_gen_type,
                                                        p_giop_gacc_branch_cd,
                                                        p_giop_gacc_fund_cd,
                                                        aeg_tran_id
                                                       );
            END IF;
         END LOOP;
      END LOOP;
   END aeg_parameters_y;

/*
   **  Created by   :  Tonio
   **  Date Created :  10.06.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure aeg_parameters_y_prem_dep GIACS007
   */
   PROCEDURE aeg_parameters_y_prem_dep (
      aeg_tran_id                   giac_acctrans.tran_id%TYPE,
      aeg_module_nm                 giac_modules.module_name%TYPE,
      p_item_no               OUT   INTEGER,
      p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE
   )
   IS
      CURSOR pr_cur
      IS
         SELECT c.b140_iss_cd iss_cd, c.collection_amt,
                c.b140_prem_seq_no bill_no, a.line_cd, d.assd_no, a.type_cd,
                c.inst_no
           FROM gipi_polbasic a,
                gipi_invoice b,
                giac_direct_prem_collns c,
                gipi_parlist d
          WHERE a.policy_id = b.policy_id
            AND b.iss_cd = c.b140_iss_cd
            AND b.prem_seq_no = c.b140_prem_seq_no
            AND a.par_id = d.par_id
            AND c.gacc_tran_id = aeg_tran_id
            AND EXISTS (
                   SELECT '1'
                     FROM giac_advanced_payt
                    WHERE iss_cd = c.b140_iss_cd
                      AND prem_seq_no = c.b140_prem_seq_no
                      AND inst_no = c.inst_no
                      AND gacc_tran_id = aeg_tran_id);

      CURSOR pd_cur (
         p_iss_cd    gipi_invoice.iss_cd%TYPE,
         p_bill_no   gipi_invoice.prem_seq_no%TYPE,
         p_inst_no   giac_direct_prem_collns.inst_no%TYPE
      )
      IS
         SELECT   SUM (a.tax_amt) tax_amt, a.b160_iss_cd iss_cd,
                  a.b160_prem_seq_no bill_no
             FROM giac_tax_collns a, giac_direct_prem_collns b
            WHERE a.b160_prem_seq_no = b.b140_prem_seq_no
              AND a.inst_no = b.inst_no
              AND a.b160_iss_cd = p_iss_cd
              AND a.b160_prem_seq_no = p_bill_no
              AND a.gacc_tran_id = aeg_tran_id
              AND a.b160_tax_cd = giacp.n ('EVAT')
              AND a.inst_no = p_inst_no
              AND EXISTS (
                     SELECT '1'
                       FROM giac_advanced_payt
                      WHERE iss_cd = b.b140_iss_cd
                        AND prem_seq_no = b.b140_prem_seq_no
                        AND inst_no = b.inst_no
                        AND gacc_tran_id = b.gacc_tran_id)
         GROUP BY a.b160_iss_cd, a.b160_prem_seq_no
           HAVING NVL (SUM (a.tax_amt), 0) <> 0;

      v_module_id   giac_modules.module_id%TYPE;
      v_gen_type    giac_modules.generation_type%TYPE;
   BEGIN
      --
      --
      FOR pr_rec IN pr_cur
      LOOP
         /*
         ** Call the accounting entry generation procedure.
         */
         --
         --
         BEGIN
            SELECT module_id, generation_type
              INTO v_module_id, v_gen_type
              FROM giac_modules
             WHERE module_name = aeg_module_nm;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (20001,
                                        'No data found in GIAC MODULES.'
                                       );
         END;

         p_item_no := 5;
         giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                       (pr_rec.assd_no,
                                                        v_module_id,
                                                        p_item_no,
                                                        pr_rec.iss_cd,
                                                        pr_rec.bill_no,
                                                        pr_rec.line_cd,
                                                        pr_rec.type_cd,
                                                        pr_rec.collection_amt,
                                                        v_gen_type,
                                                        p_giop_gacc_branch_cd,
                                                        p_giop_gacc_fund_cd,
                                                        aeg_tran_id
                                                       );

         FOR vat_rec IN pd_cur (pr_rec.iss_cd, pr_rec.bill_no, pr_rec.inst_no)
         LOOP
            IF NVL (giacp.v ('EVAT_ENTRY_ON_PREM_COLLN'), 'A') = 'B'
            THEN
               -- item_no 8 - vat premium deposits
               giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                      (NULL,
                                                       v_module_id,
                                                       8,
                                                       pr_rec.iss_cd,
                                                       pr_rec.bill_no,
                                                       pr_rec.line_cd,
                                                       pr_rec.type_cd,
                                                       vat_rec.tax_amt,
                                                       v_gen_type,
                                                       p_giop_gacc_branch_cd,
                                                       p_giop_gacc_fund_cd,
                                                       aeg_tran_id
                                                      );
               -- item_no 9 - vat payable
               giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                       (NULL,
                                                        v_module_id,
                                                        9,
                                                        pr_rec.iss_cd,
                                                        pr_rec.bill_no,
                                                        pr_rec.line_cd,
                                                        pr_rec.type_cd,
                                                        vat_rec.tax_amt,
                                                        v_gen_type,
                                                        p_giop_gacc_branch_cd,
                                                        p_giop_gacc_fund_cd,
                                                        aeg_tran_id
                                                       );
            END IF;
         END LOOP;
      END LOOP;
   END aeg_parameters_y_prem_dep;

   /*
   **  Created by   :  Tonio
   **  Date Created :  10.06.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure aeg_parameters_Y_prem_rec GIACS007
   */
   PROCEDURE aeg_parameters_y_prem_rec (
      aeg_tran_id                   giac_acctrans.tran_id%TYPE,
      aeg_module_nm                 giac_modules.module_name%TYPE,
      p_item_no               OUT   NUMBER,
      p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE
   )
   IS
      CURSOR pr_cur
      IS
         SELECT   c.b140_iss_cd iss_cd, SUM (c.collection_amt)
                                                              collection_amt,
                  c.b140_prem_seq_no bill_no, a.line_cd, d.assd_no,
                  a.type_cd
             FROM gipi_polbasic a,
                  gipi_invoice b,
                  giac_direct_prem_collns c,
                  gipi_parlist d
            WHERE a.policy_id = b.policy_id
              AND b.iss_cd = c.b140_iss_cd
              AND b.prem_seq_no = c.b140_prem_seq_no
              AND a.par_id = d.par_id
              AND c.gacc_tran_id = aeg_tran_id
              AND NOT EXISTS (
                     SELECT '1'
                       FROM giac_advanced_payt
                      WHERE iss_cd = c.b140_iss_cd
                        AND prem_seq_no = c.b140_prem_seq_no
                        AND inst_no = c.inst_no
                        AND gacc_tran_id = aeg_tran_id)
         GROUP BY c.b140_iss_cd,
                  c.b140_prem_seq_no,
                  a.line_cd,
                  d.assd_no,
                  a.type_cd;

      CURSOR evat_cur (
         p_iss_cd    gipi_invoice.iss_cd%TYPE,
         p_bill_no   gipi_invoice.prem_seq_no%TYPE
      )
      IS
         SELECT   SUM (tax_amt) tax_amt, b160_iss_cd, b160_prem_seq_no
             FROM giac_tax_collns
            WHERE b160_iss_cd = p_iss_cd
              AND b160_prem_seq_no = p_bill_no
              AND gacc_tran_id = aeg_tran_id
              AND b160_tax_cd = (SELECT giacp.n ('EVAT')
                                   FROM DUAL)
         GROUP BY b160_iss_cd, b160_prem_seq_no
           HAVING NVL (SUM (tax_amt), 0) <> 0;

      --added so as not to generate 0 amt acct entries
      v_module_id   giac_modules.module_id%TYPE;
      v_gen_type    giac_modules.generation_type%TYPE;
      v_sl_type_cd  giac_module_entries.sl_type_cd%TYPE; --added by reymon 11212013
   BEGIN
      BEGIN
         SELECT module_id, generation_type
           INTO v_module_id, v_gen_type
           FROM giac_modules
          WHERE module_name = aeg_module_nm;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (20001, 'No data found in GIAC MODULES.');
      END;
      
      BEGIN
          SELECT sl_type_cd
            INTO v_sl_type_cd
            FROM giac_module_entries
           WHERE module_id = v_module_id
             AND item_no = 1;
      EXCEPTION
         WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
         THEN
            v_sl_type_cd := NULL;
      END;

      FOR pr_rec IN pr_cur
      LOOP
         /*
         ** Call the accounting entry generation procedure.
         */
         --
         --
         p_item_no := 1;
         --resolved problem that prems receivable should not be added to prem deposits in giac_acct_entries
         
         IF v_sl_type_cd = 1 THEN --added condition for premium receivable sl type reymon 11212013
             giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                          (pr_rec.assd_no,
                                                           v_module_id,
                                                           p_item_no,
                                                           pr_rec.iss_cd,
                                                           pr_rec.bill_no,
                                                           pr_rec.line_cd,
                                                           pr_rec.type_cd,
                                                           pr_rec.collection_amt,
                                                           v_gen_type,
                                                           p_giop_gacc_branch_cd,
                                                           p_giop_gacc_fund_cd,
                                                           aeg_tran_id
                                                          );
         ELSIF v_sl_type_cd = 3 THEN
            FOR i IN (SELECT *
                        FROM TABLE (giac_acct_entries_pkg.intm_rec_computation (pr_rec.iss_cd, pr_rec.bill_no, pr_rec.collection_amt, aeg_tran_id)))
            LOOP
             giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                              (i.sl_cd,
                                                               v_module_id,
                                                               p_item_no,
                                                               pr_rec.iss_cd,
                                                               pr_rec.bill_no,
                                                               pr_rec.line_cd,
                                                               pr_rec.type_cd,
                                                               i.amount,
                                                               v_gen_type,
                                                               p_giop_gacc_branch_cd,
                                                               p_giop_gacc_fund_cd,
                                                               aeg_tran_id
                                                              );
            END LOOP;
         ELSIF v_sl_type_cd = 6 THEN
            FOR i IN (SELECT *
                        FROM TABLE (giac_acct_entries_pkg.peril_rec_computation (pr_rec.iss_cd, pr_rec.bill_no, pr_rec.collection_amt, aeg_tran_id)))
            LOOP
                giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                              (i.sl_cd,
                                                               v_module_id,
                                                               p_item_no,
                                                               pr_rec.iss_cd,
                                                               pr_rec.bill_no,
                                                               pr_rec.line_cd,
                                                               pr_rec.type_cd,
                                                               i.amount,
                                                               v_gen_type,
                                                               p_giop_gacc_branch_cd,
                                                               p_giop_gacc_fund_cd,
                                                               aeg_tran_id
                                                              );
            END LOOP;
         ELSIF v_sl_type_cd IS NULL THEN
             giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                          (NULL,
                                                           v_module_id,
                                                           p_item_no,
                                                           pr_rec.iss_cd,
                                                           pr_rec.bill_no,
                                                           pr_rec.line_cd,
                                                           pr_rec.type_cd,
                                                           pr_rec.collection_amt,
                                                           v_gen_type,
                                                           p_giop_gacc_branch_cd,
                                                           p_giop_gacc_fund_cd,
                                                           aeg_tran_id
                                                          );
         ELSE
             giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                          (pr_rec.assd_no,
                                                           v_module_id,
                                                           p_item_no,
                                                           pr_rec.iss_cd,
                                                           pr_rec.bill_no,
                                                           pr_rec.line_cd,
                                                           pr_rec.type_cd,
                                                           pr_rec.collection_amt,
                                                           v_gen_type,
                                                           p_giop_gacc_branch_cd,
                                                           p_giop_gacc_fund_cd,
                                                           aeg_tran_id
                                                          );         
         END IF;
         
         
         FOR evat_rec IN evat_cur (pr_rec.iss_cd, pr_rec.bill_no)
         LOOP
            IF NVL (giacp.v ('OUTPUT_VAT_COLLN_ENTRY'), 'N') = 'Y'
            THEN
               /* from giac_taxes
               AEG_Create_Acct_Entries_tax_N(VARIABLES.evat, EVAT_rec.tax_amt,
                                            VARIABLES.gen_type);
               */

               /* item_no 7 - deferred output vat*/
               giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                      (NULL,
                                                       v_module_id,
                                                       7,
                                                       pr_rec.iss_cd,
                                                       pr_rec.bill_no,
                                                       pr_rec.line_cd,
                                                       pr_rec.type_cd,
                                                       evat_rec.tax_amt,
                                                       v_gen_type,
                                                       p_giop_gacc_branch_cd,
                                                       p_giop_gacc_fund_cd,
                                                       aeg_tran_id
                                                      );
               /* item_no 6 - output vat payable*/
               giac_acct_entries_pkg.aeg_create_acct_entries_y
                                                       (NULL,
                                                        v_module_id,
                                                        6,
                                                        pr_rec.iss_cd,
                                                        pr_rec.bill_no,
                                                        pr_rec.line_cd,
                                                        pr_rec.type_cd,
                                                        evat_rec.tax_amt,
                                                        v_gen_type,
                                                        p_giop_gacc_branch_cd,
                                                        p_giop_gacc_fund_cd,
                                                        aeg_tran_id
                                                       );
            END IF;
         END LOOP;
      END LOOP;
   END aeg_parameters_y_prem_rec;

   /*
   **  Created by   :  Tonio
   **  Date Created :  10.06.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure aeg_create_acct_entries_y GIACS007
   */
   PROCEDURE aeg_create_acct_entries_y (
      aeg_sl_cd               giac_acct_entries.sl_cd%TYPE,
      aeg_module_id           giac_module_entries.module_id%TYPE,
      aeg_item_no             giac_module_entries.item_no%TYPE,
      aeg_iss_cd              giac_direct_prem_collns.b140_iss_cd%TYPE,
      aeg_bill_no             giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      aeg_line_cd             giis_line.line_cd%TYPE,
      aeg_type_cd             gipi_polbasic.type_cd%TYPE,
      aeg_acct_amt            giac_direct_prem_collns.collection_amt%TYPE,
      aeg_gen_type            giac_acct_entries.generation_type%TYPE,
      p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
   )
   IS
      ws_gl_acct_category     giac_acct_entries.gl_acct_category%TYPE;
      ws_gl_control_acct      giac_acct_entries.gl_control_acct%TYPE;
      ws_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      ws_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      ws_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      ws_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      ws_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      ws_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_pol_type_tag         giac_module_entries.pol_type_tag%TYPE;
      ws_intm_type_level      giac_module_entries.intm_type_level%TYPE;
      ws_old_new_acct_level   giac_module_entries.old_new_acct_level%TYPE;
      ws_line_dep_level       giac_module_entries.line_dependency_level%TYPE;
      ws_dr_cr_tag            giac_module_entries.dr_cr_tag%TYPE;
      ws_acct_intm_cd         giis_intm_type.acct_intm_cd%TYPE;
      ws_line_cd              giis_line.line_cd%TYPE;
--  ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
      ws_old_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_new_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      pt_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      pt_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      pt_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      pt_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      pt_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_debit_amt            giac_acct_entries.debit_amt%TYPE;
      ws_credit_amt           giac_acct_entries.credit_amt%TYPE;
      ws_gl_acct_id           giac_acct_entries.gl_acct_id%TYPE;
      ws_sl_type_cd           giac_acct_entries.sl_type_cd%TYPE;
      v_old_iss_cd            giac_direct_prem_collns.b140_iss_cd%TYPE;
   BEGIN
--msg_alert('AEG CREATE ACCT ENTRIES...','I',FALSE);

      /**************************************************************************
      *                                                                         *
      * Populate the GL Account Code used in every transactions.                *
      *                                                                         *
      **************************************************************************/
      BEGIN
         SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
                gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                pol_type_tag, NVL (intm_type_level, 0),
                NVL (old_new_acct_level, 0), dr_cr_tag,
                NVL (line_dependency_level, 0), sl_type_cd
           INTO ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                ws_gl_sub_acct_2, ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                ws_gl_sub_acct_5, ws_gl_sub_acct_6, ws_gl_sub_acct_7,
                ws_pol_type_tag, ws_intm_type_level,
                ws_old_new_acct_level, ws_dr_cr_tag,
                ws_line_dep_level, ws_sl_type_cd
           FROM giac_module_entries
          WHERE module_id = aeg_module_id AND item_no = NVL (aeg_item_no, 1);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20001,
                                     'Geniisys Exception#E#No data found in giac_module_entries.'
                                    );
      END;

      /**************************************************************************
      *                                                                         *
      * Validate the INTM_TYPE_LEVEL value which indicates the segment of the   *
      * GL account code that holds the intermediary type.                       *
      *                                                                         *
      **************************************************************************/
      IF ws_intm_type_level != 0
      THEN
         BEGIN
            SELECT DISTINCT (c.acct_intm_cd)
                       INTO ws_acct_intm_cd
                       FROM gipi_comm_invoice a,
                            giis_intermediary b,
                            giis_intm_type c
                      WHERE a.intrmdry_intm_no = b.intm_no
                        AND b.intm_type = c.intm_type
                        AND a.iss_cd = aeg_iss_cd
                        AND a.prem_seq_no = aeg_bill_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (-20001,
                                        'No data found in giis_intm_type.'
                                       );
         END;

         giac_acct_entries_pkg.aeg_check_level_y (ws_intm_type_level,
                                                  ws_acct_intm_cd,
                                                  ws_gl_sub_acct_1,
                                                  ws_gl_sub_acct_2,
                                                  ws_gl_sub_acct_3,
                                                  ws_gl_sub_acct_4,
                                                  ws_gl_sub_acct_5,
                                                  ws_gl_sub_acct_6,
                                                  ws_gl_sub_acct_7
                                                 );
      END IF;

      /**************************************************************************
      *                                                                         *
      * Validate the LINE_DEPENDENCY_LEVEL value which indicates the segment of *
      * the GL account code that holds the line number.                         *
      *                                                                         *
      **************************************************************************/
      IF ws_line_dep_level != 0
      THEN
         BEGIN
            SELECT acct_line_cd
              INTO ws_line_cd
              FROM giis_line
             WHERE line_cd = aeg_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (-20001,
                                        'No data found in giis_line.');
         END;

         giac_acct_entries_pkg.aeg_check_level_y (ws_line_dep_level,
                                                  ws_line_cd,
                                                  ws_gl_sub_acct_1,
                                                  ws_gl_sub_acct_2,
                                                  ws_gl_sub_acct_3,
                                                  ws_gl_sub_acct_4,
                                                  ws_gl_sub_acct_5,
                                                  ws_gl_sub_acct_6,
                                                  ws_gl_sub_acct_7
                                                 );
      END IF;

      /**************************************************************************
      *                                                                         *
      * Validate the OLD_NEW_ACCT_LEVEL value which indicates the segment of    *
      * the GL account code that holds the old and new account values.          *
      *                                                                         *
      **************************************************************************/
      IF ws_old_new_acct_level != 0
      THEN
         BEGIN
            BEGIN
               SELECT param_value_v
                 INTO v_old_iss_cd
                 FROM giac_parameters
                WHERE param_name = 'OLD_ISS_CD';
            END;

            BEGIN
               SELECT param_value_n
                 INTO ws_old_acct_cd
                 FROM giac_parameters
                WHERE param_name = 'OLD_ACCT_CD';
            END;

            BEGIN
               SELECT param_value_n
                 INTO ws_new_acct_cd
                 FROM giac_parameters
                WHERE param_name = 'NEW_ACCT_CD';
            END;

            IF aeg_iss_cd = v_old_iss_cd
            THEN
               giac_acct_entries_pkg.aeg_check_level_y
                                                      (ws_old_new_acct_level,
                                                       ws_old_acct_cd,
                                                       ws_gl_sub_acct_1,
                                                       ws_gl_sub_acct_2,
                                                       ws_gl_sub_acct_3,
                                                       ws_gl_sub_acct_4,
                                                       ws_gl_sub_acct_5,
                                                       ws_gl_sub_acct_6,
                                                       ws_gl_sub_acct_7
                                                      );
            ELSE
               giac_acct_entries_pkg.aeg_check_level_y
                                                      (ws_old_new_acct_level,
                                                       ws_new_acct_cd,
                                                       ws_gl_sub_acct_1,
                                                       ws_gl_sub_acct_2,
                                                       ws_gl_sub_acct_3,
                                                       ws_gl_sub_acct_4,
                                                       ws_gl_sub_acct_5,
                                                       ws_gl_sub_acct_6,
                                                       ws_gl_sub_acct_7
                                                      );
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (20001,
                                        'No data found in giac_parameters.'
                                       );
         END;
      END IF;

      /**************************************************************************
      *                                                                         *
      * Check the POL_TYPE_TAG which indicates if the policy type GL code       *
      * segments will be attached to this GL account.                           *
      *                                                                         *
      **************************************************************************/
      IF ws_pol_type_tag = 'Y'
      THEN
         BEGIN
            SELECT NVL (gl_sub_acct_1, 0), NVL (gl_sub_acct_2, 0),
                   NVL (gl_sub_acct_3, 0), NVL (gl_sub_acct_4, 0),
                   NVL (gl_sub_acct_5, 0), NVL (gl_sub_acct_6, 0),
                   NVL (gl_sub_acct_7, 0)
              INTO pt_gl_sub_acct_1, pt_gl_sub_acct_2,
                   pt_gl_sub_acct_3, pt_gl_sub_acct_4,
                   pt_gl_sub_acct_5, pt_gl_sub_acct_6,
                   pt_gl_sub_acct_7
              FROM giac_policy_type_entries
             WHERE line_cd = aeg_line_cd AND type_cd = aeg_type_cd;

            IF pt_gl_sub_acct_1 != 0
            THEN
               ws_gl_sub_acct_1 := pt_gl_sub_acct_1;
            END IF;

            IF pt_gl_sub_acct_2 != 0
            THEN
               ws_gl_sub_acct_2 := pt_gl_sub_acct_2;
            END IF;

            IF pt_gl_sub_acct_3 != 0
            THEN
               ws_gl_sub_acct_3 := pt_gl_sub_acct_3;
            END IF;

            IF pt_gl_sub_acct_4 != 0
            THEN
               ws_gl_sub_acct_4 := pt_gl_sub_acct_4;
            END IF;

            IF pt_gl_sub_acct_5 != 0
            THEN
               ws_gl_sub_acct_5 := pt_gl_sub_acct_5;
            END IF;

            IF pt_gl_sub_acct_6 != 0
            THEN
               ws_gl_sub_acct_6 := pt_gl_sub_acct_6;
            END IF;

            IF pt_gl_sub_acct_7 != 0
            THEN
               ws_gl_sub_acct_7 := pt_gl_sub_acct_7;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error
                                (20001,
                                 'No data found in giac_policy_type_entries.'
                                );
         END;
      END IF;

      /**************************************************************************
      *                                                                         *
      * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
      *                                                                         *
      **************************************************************************/
      giac_acct_entries_pkg.aeg_check_chart_of_accts_y (ws_gl_acct_category,
                                                        ws_gl_control_acct,
                                                        ws_gl_sub_acct_1,
                                                        ws_gl_sub_acct_2,
                                                        ws_gl_sub_acct_3,
                                                        ws_gl_sub_acct_4,
                                                        ws_gl_sub_acct_5,
                                                        ws_gl_sub_acct_6,
                                                        ws_gl_sub_acct_7,
                                                        ws_gl_acct_id,
                                                        aeg_iss_cd,
                                                        aeg_bill_no
                                                       );

      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/
      IF ws_dr_cr_tag = 'D'
      THEN
         IF aeg_acct_amt > 0
         THEN
            ws_debit_amt := ABS (aeg_acct_amt);
            ws_credit_amt := 0;
         ELSE
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_acct_amt);
         END IF;
      ELSE
         IF aeg_acct_amt > 0
         THEN
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_acct_amt);
         ELSE
            ws_debit_amt := ABS (aeg_acct_amt);
            ws_credit_amt := 0;
         END IF;
      END IF;

      /****************************************************************************
      *                                                                           *
      * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      *                                                                           *
      ****************************************************************************/
      giac_acct_entries_pkg.aeg_insert_update_acct_y (ws_gl_acct_category,
                                                      ws_gl_control_acct,
                                                      ws_gl_sub_acct_1,
                                                      ws_gl_sub_acct_2,
                                                      ws_gl_sub_acct_3,
                                                      ws_gl_sub_acct_4,
                                                      ws_gl_sub_acct_5,
                                                      ws_gl_sub_acct_6,
                                                      ws_gl_sub_acct_7,
                                                      aeg_sl_cd,
                                                      ws_sl_type_cd,
                                                      aeg_gen_type,
                                                      ws_gl_acct_id,
                                                      ws_debit_amt,
                                                      ws_credit_amt,
                                                      p_giop_gacc_branch_cd,
                                                      p_giop_gacc_fund_cd,
                                                      p_giop_gacc_tran_id
                                                     );
   END aeg_create_acct_entries_y;

   /*
   **  Created by   :  Tonio
   **  Date Created :  10.06.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure aeg_check_level_y GIACS007
   */
   PROCEDURE aeg_check_level_y (
      cl_level       IN       NUMBER,
      cl_value       IN       NUMBER,
      cl_sub_acct1   IN OUT   NUMBER,
      cl_sub_acct2   IN OUT   NUMBER,
      cl_sub_acct3   IN OUT   NUMBER,
      cl_sub_acct4   IN OUT   NUMBER,
      cl_sub_acct5   IN OUT   NUMBER,
      cl_sub_acct6   IN OUT   NUMBER,
      cl_sub_acct7   IN OUT   NUMBER
   )
   IS
   BEGIN
--msg_alert('AEG CHECK LEVEL...','I',FALSE);
      IF cl_level = 1
      THEN
         cl_sub_acct1 := cl_value;
      ELSIF cl_level = 2
      THEN
         cl_sub_acct2 := cl_value;
      ELSIF cl_level = 3
      THEN
         cl_sub_acct3 := cl_value;
      ELSIF cl_level = 4
      THEN
         cl_sub_acct4 := cl_value;
      ELSIF cl_level = 5
      THEN
         cl_sub_acct5 := cl_value;
      ELSIF cl_level = 6
      THEN
         cl_sub_acct6 := cl_value;
      ELSIF cl_level = 7
      THEN
         cl_sub_acct7 := cl_value;
      END IF;
   END aeg_check_level_y;

   /*
   **  Created by   :  Tonio
   **  Date Created :  10.06.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure AEG_Check_Chart_Of_Accts_Y GIACS007
   */
   PROCEDURE aeg_check_chart_of_accts_y (
      cca_gl_acct_category            giac_acct_entries.gl_acct_category%TYPE,
      cca_gl_control_acct             giac_acct_entries.gl_control_acct%TYPE,
      cca_gl_sub_acct_1               giac_acct_entries.gl_sub_acct_1%TYPE,
      cca_gl_sub_acct_2               giac_acct_entries.gl_sub_acct_2%TYPE,
      cca_gl_sub_acct_3               giac_acct_entries.gl_sub_acct_3%TYPE,
      cca_gl_sub_acct_4               giac_acct_entries.gl_sub_acct_4%TYPE,
      cca_gl_sub_acct_5               giac_acct_entries.gl_sub_acct_5%TYPE,
      cca_gl_sub_acct_6               giac_acct_entries.gl_sub_acct_6%TYPE,
      cca_gl_sub_acct_7               giac_acct_entries.gl_sub_acct_7%TYPE,
      cca_gl_acct_id         IN OUT   giac_chart_of_accts.gl_acct_id%TYPE,
      aeg_iss_cd                      giac_direct_prem_collns.b140_iss_cd%TYPE,
      aeg_bill_no                     giac_direct_prem_collns.b140_prem_seq_no%TYPE
   )
   IS
   BEGIN
--msg_alert('AEG CHK CHART OF ACCTS...','I',FALSE);
      SELECT DISTINCT (gl_acct_id)
                 INTO cca_gl_acct_id
                 FROM giac_chart_of_accts
                WHERE gl_acct_category = cca_gl_acct_category
                  AND gl_control_acct = cca_gl_control_acct
                  AND gl_sub_acct_1 = cca_gl_sub_acct_1
                  AND gl_sub_acct_2 = cca_gl_sub_acct_2
                  AND gl_sub_acct_3 = cca_gl_sub_acct_3
                  AND gl_sub_acct_4 = cca_gl_sub_acct_4
                  AND gl_sub_acct_5 = cca_gl_sub_acct_5
                  AND gl_sub_acct_6 = cca_gl_sub_acct_6
                  AND gl_sub_acct_7 = cca_gl_sub_acct_7;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            raise_application_error
               (-20001,
                   'Geniisys Exception#E#GL account code '
                || TO_CHAR (cca_gl_acct_category) 
                || '-'
                || TO_CHAR (cca_gl_control_acct, '09')
                || '-'
                || TO_CHAR (cca_gl_sub_acct_1, '09')
                || '-'
                || TO_CHAR (cca_gl_sub_acct_2, '09')
                || '-'
                || TO_CHAR (cca_gl_sub_acct_3, '09')
                || '-'
                || TO_CHAR (cca_gl_sub_acct_4, '09')
                || '-'
                || TO_CHAR (cca_gl_sub_acct_5, '09')
                || '-'
                || TO_CHAR (cca_gl_sub_acct_6, '09')
                || '-'
                || TO_CHAR (cca_gl_sub_acct_7, '09')
                || ' does not exist in Chart of Accounts (Giac_Acctrans). Bill No : '
                || aeg_iss_cd
                || '-'
                || TO_CHAR (aeg_bill_no)
                || '.'
               );
/*
       aeg_delete_acct_entries;
       delete
         from giac_direct_prem_collns
        where gacc_tran_id = :GLOBAL.cg$giop_gacc_tran_id
          and b140_prem_seq_no = :gdpc.b140_prem_seq_no
          and b140_iss_cd = :gdpc.b140_iss_cd;
       commit;
*/
         END;
   END aeg_check_chart_of_accts_y;

    /*
   **  Created by   :  Tonio
   **  Date Created :  10.06.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure AEG_Insert_Update_Acct_Y GIACS007
   */
   PROCEDURE aeg_insert_update_acct_y (
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
      p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
   )
   IS
      iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
   BEGIN
   -- comment out by andrew - 02.07.2012
      --alfie alfie
--      INSERT INTO hehehe
--           VALUES (5,
--                      iuae_gl_acct_category
--                   || ' '
--                   || iuae_gl_control_acct
--                   || ' '
--                   || iuae_gl_sub_acct_1
--                   || ' '
--                   || iuae_gl_sub_acct_2
--                   || ' '
--                   || iuae_gl_sub_acct_3
--                   || ' '
--                   || iuae_gl_sub_acct_4
--                   || ' '
--                   || iuae_gl_sub_acct_5
--                   || ' '
--                   || iuae_gl_sub_acct_6
--                   || ' '
--                   || iuae_gl_sub_acct_7
--                   || ' '
--                   || iuae_sl_cd
--                   || ' '
--                   || iuae_sl_type_cd
--                   || ' '
--                   || iuae_generation_type
--                   || ' '
--                   || iuae_gl_acct_id
--                   || ' '
--                   || iuae_debit_amt
--                   || ' '
--                   || iuae_credit_amt
--                   || ' '
--                   || p_giop_gacc_branch_cd
--                   || ' '
--                   || p_giop_gacc_fund_cd
--                   || ' '
--                   || p_giop_gacc_tran_id);

      SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gacc_gibr_branch_cd = p_giop_gacc_branch_cd
         AND gacc_gfun_fund_cd = p_giop_gacc_fund_cd
         AND gacc_tran_id = p_giop_gacc_tran_id
         AND NVL (sl_cd, 0) = NVL (iuae_sl_cd, 0)
         --AND sl_cd = iuae_sl_cd
         AND generation_type = iuae_generation_type
         AND NVL (gl_acct_id, gl_acct_id) = iuae_gl_acct_id;

  -- comment out by andrew 02.07.2012
--      INSERT INTO hehehe
--           VALUES (7, 'iuae_acct_Entry_id:' || iuae_acct_entry_id);

      IF NVL (iuae_acct_entry_id, 0) = 0
      THEN
         iuae_acct_entry_id := NVL (iuae_acct_entry_id, 0) + 1;

         INSERT INTO giac_acct_entries
                     (gacc_tran_id, gacc_gfun_fund_cd,
                      gacc_gibr_branch_cd, acct_entry_id,
                      gl_acct_id, gl_acct_category,
                      gl_control_acct, gl_sub_acct_1,
                      gl_sub_acct_2, gl_sub_acct_3,
                      gl_sub_acct_4, gl_sub_acct_5,
                      gl_sub_acct_6, gl_sub_acct_7, sl_cd,
                      sl_type_cd, debit_amt, credit_amt,
                      generation_type,
                      user_id, last_update
                     )
              VALUES (p_giop_gacc_tran_id, p_giop_gacc_fund_cd,
                      p_giop_gacc_branch_cd, iuae_acct_entry_id,
                      iuae_gl_acct_id, iuae_gl_acct_category,
                      iuae_gl_control_acct, iuae_gl_sub_acct_1,
                      iuae_gl_sub_acct_2, iuae_gl_sub_acct_3,
                      iuae_gl_sub_acct_4, iuae_gl_sub_acct_5,
                      iuae_gl_sub_acct_6, iuae_gl_sub_acct_7, iuae_sl_cd,
                      iuae_sl_type_cd, iuae_debit_amt, iuae_credit_amt,
                      iuae_generation_type,
                      NVL (giis_users_pkg.app_user, USER), SYSDATE
                     );
      ELSE
         UPDATE giac_acct_entries
            SET debit_amt = debit_amt + iuae_debit_amt,
                credit_amt = credit_amt + iuae_credit_amt
          WHERE NVL (sl_cd, 0) = NVL (iuae_sl_cd, 0)
            AND generation_type = iuae_generation_type
            AND NVL (gl_acct_id, gl_acct_id) = iuae_gl_acct_id
            AND gacc_gibr_branch_cd = p_giop_gacc_branch_cd
            AND gacc_gfun_fund_cd = p_giop_gacc_fund_cd
            AND gacc_tran_id = p_giop_gacc_tran_id;
      END IF;
   END aeg_insert_update_acct_y;

   /*
   **  Created by   :  Tonio
   **  Date Created :  10.07.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure gen_acct_entr_n GIACS007
   */
   PROCEDURE gen_acct_entr_n (
      p_module_nm                   giac_modules.module_name%TYPE,
      p_transaction_type            giac_direct_prem_collns.transaction_type%TYPE,
      p_iss_cd                      giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_bill_no                     giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id           giac_acct_entries.gacc_tran_id%TYPE,
      p_item_no               OUT   NUMBER
   )
   IS
/* this generates the acct'g entries */
   BEGIN
      IF NVL (giacp.v ('PREM_REC_GROSS_TAG'), 'Y') != 'Y'
      THEN
         aeg_parameters_n (p_module_nm,
                           p_transaction_type,
                           p_iss_cd,
                           p_bill_no,
                           p_giop_gacc_branch_cd,
                           p_giop_gacc_fund_cd,
                           p_giop_gacc_tran_id,
                           p_item_no
                          );
      END IF;
--:nbt.gen_acct_flag := 'N';
   END gen_acct_entr_n;

/*
   **  Created by   :  Tonio
   **  Date Created :  10.07.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure aeg_parameters_n GIACS007
   */
   PROCEDURE aeg_parameters_n (
      p_module_nm                   giac_modules.module_name%TYPE,
      p_transaction_type            giac_direct_prem_collns.transaction_type%TYPE,
      p_iss_cd                      giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_bill_no                     giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id           giac_acct_entries.gacc_tran_id%TYPE,
      p_item_no               OUT   NUMBER
   )
   IS
      v_rec_gross_tag   VARCHAR2 (1);
      c                 NUMBER                              := 0;
      v_assd_no         gipi_parlist.assd_no%TYPE;
      v_module_id       giac_modules.module_id%TYPE;
      v_gen_type        giac_modules.generation_type%TYPE;
      v_item_no_2       NUMBER;
   BEGIN
      BEGIN
         SELECT module_id, generation_type
           INTO v_module_id, v_gen_type
           FROM giac_modules
          WHERE module_name = p_module_nm;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (20001, 'No data found in GIAC MODULES.');
      END;

      /* Call the deletion of accounting entry procedure. */
      giac_acct_entries_pkg.aeg_delete_acct_entries_n (v_gen_type,
                                                       p_giop_gacc_tran_id
                                                      );

      /*
      **  For PREMIUM RECEIVABLES...
      */
      FOR pr_rec IN (SELECT   c.transaction_type, c.b140_iss_cd iss_cd,
                              c.b140_prem_seq_no bill_no, a.line_cd,
                              a.assd_no, a.type_cd, a.par_id,
                              SUM (c.collection_amt) collection_amt,
                              SUM (c.premium_amt) premium_amt,
                              SUM (c.tax_amt) tax_amt
                         FROM gipi_polbasic a,
                              gipi_invoice b,
                              giac_direct_prem_collns c
                        WHERE 1 = 1
                          AND a.policy_id = b.policy_id
                          AND a.iss_cd = c.b140_iss_cd
                          AND c.b140_iss_cd = c.b140_iss_cd
                          AND b.iss_cd = c.b140_iss_cd
                          AND b.prem_seq_no = c.b140_prem_seq_no
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
         v_item_no_2 := 5;

         BEGIN
            IF pr_rec.transaction_type IN (3, 4)
            THEN
               p_item_no := v_item_no_2;
            ELSE
               p_item_no := NVL(p_item_no, 1);
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
                  raise_application_error (20001,
                                              pr_rec.iss_cd
                                           || '-'
                                           || TO_CHAR (pr_rec.bill_no)
                                           || ' has no assured.'
                                          );
            END;
         END IF;

         IF v_rec_gross_tag = 'Y'
         THEN
            giac_acct_entries_pkg.aeg_create_acct_entries_n
                                                      (NVL (pr_rec.assd_no,
                                                            v_assd_no
                                                           ),
                                                       v_module_id,
                                                       p_item_no,
                                                       pr_rec.iss_cd,
                                                       pr_rec.bill_no,
                                                       pr_rec.line_cd,
                                                       pr_rec.type_cd,
                                                       pr_rec.collection_amt,
                                                       v_gen_type,
                                                       p_giop_gacc_branch_cd,
                                                       p_giop_gacc_fund_cd,
                                                       p_giop_gacc_tran_id
                                                      );
         ELSE
            giac_acct_entries_pkg.aeg_create_acct_entries_n
                                                      (NVL (pr_rec.assd_no,
                                                            v_assd_no
                                                           ),
                                                       v_module_id,
                                                       p_item_no,
                                                       pr_rec.iss_cd,
                                                       pr_rec.bill_no,
                                                       pr_rec.line_cd,
                                                       pr_rec.type_cd,
                                                       pr_rec.premium_amt,
                                                       v_gen_type,
                                                       p_giop_gacc_branch_cd,
                                                       p_giop_gacc_fund_cd,
                                                       p_giop_gacc_tran_id
                                                      );

            IF pr_rec.tax_amt != 0
            THEN
               FOR rec IN (SELECT   b160_tax_cd tax_cd, SUM (tax_amt)
                                                                     tax_amt
                               FROM giac_tax_collns
                              WHERE b160_prem_seq_no = pr_rec.bill_no
                                AND b160_iss_cd = pr_rec.iss_cd
                                AND gacc_tran_id = p_giop_gacc_tran_id
                           GROUP BY b160_tax_cd)
               LOOP
                  giac_acct_entries_pkg.aeg_create_acct_entries_tax_n
                                                      (rec.tax_cd,
                                                       rec.tax_amt,
                                                       v_gen_type,
                                                       p_giop_gacc_branch_cd,
                                                       p_giop_gacc_fund_cd,
                                                       p_giop_gacc_tran_id
                                                      );
               END LOOP;                                         -- end of rec
            END IF;                                   -- end of pr_rec.tax_amt
         END IF;                                     -- end of v_rec_gross_tag

         c := c + 1;
      END LOOP;
   END aeg_parameters_n;

/*
   **  Created by   :  Tonio
   **  Date Created :  10.07.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure aeg_delete_acct_entries_n GIACS007
   */
   PROCEDURE aeg_delete_acct_entries_n (
      p_gen_type            giac_modules.generation_type%TYPE,
      p_giop_gacc_tran_id   giac_acct_entries.gacc_tran_id%TYPE
   )
   IS
   BEGIN
---- message('AEG_Delete_Acct_Entries...N');

      /**************************************************************************
      *                                                                         *
      * Delete all records existing in GIAC_ACCT_ENTRIES table having the same  *
      * tran_id as :GLOBAL.cg$giop_gacc_tran_id.                                *
      *                                                                         *
      **************************************************************************/
      FOR ae IN (SELECT 'x'
                   FROM giac_acct_entries
                  WHERE ROWNUM <= 1       -- at least one rec should be check
                    AND generation_type = p_gen_type
                    AND gacc_tran_id = p_giop_gacc_tran_id)
      LOOP
         DELETE FROM giac_acct_entries
               WHERE gacc_tran_id = p_giop_gacc_tran_id
                 AND generation_type = p_gen_type;

         EXIT;
      END LOOP;
   END aeg_delete_acct_entries_n;

/*
   **  Created by   :  Tonio
   **  Date Created :  10.07.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure aeg_create_acct_entries_n GIACS007
   */
   PROCEDURE aeg_create_acct_entries_n (
      aeg_sl_cd               giac_acct_entries.sl_cd%TYPE,
      aeg_module_id           giac_module_entries.module_id%TYPE,
      aeg_item_no             giac_module_entries.item_no%TYPE,
      aeg_iss_cd              giac_direct_prem_collns.b140_iss_cd%TYPE,
      aeg_bill_no             giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      aeg_line_cd             giis_line.line_cd%TYPE,
      aeg_type_cd             gipi_polbasic.type_cd%TYPE,
      aeg_acct_amt            giac_direct_prem_collns.collection_amt%TYPE,
      aeg_gen_type            giac_acct_entries.generation_type%TYPE,
      p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
   )
   IS
      ws_gl_acct_category     giac_acct_entries.gl_acct_category%TYPE;
      ws_gl_control_acct      giac_acct_entries.gl_control_acct%TYPE;
      ws_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      ws_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      ws_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      ws_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      ws_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      ws_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_pol_type_tag         giac_module_entries.pol_type_tag%TYPE;
      ws_intm_type_level      giac_module_entries.intm_type_level%TYPE;
      ws_old_new_acct_level   giac_module_entries.old_new_acct_level%TYPE;
      ws_line_dep_level       giac_module_entries.line_dependency_level%TYPE;
      ws_dr_cr_tag            giac_module_entries.dr_cr_tag%TYPE;
      ws_acct_intm_cd         giis_intm_type.acct_intm_cd%TYPE;
      ws_line_cd              giis_line.line_cd%TYPE;
      ws_old_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_new_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      pt_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      pt_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      pt_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      pt_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      pt_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_debit_amt            giac_acct_entries.debit_amt%TYPE;
      ws_credit_amt           giac_acct_entries.credit_amt%TYPE;
      ws_gl_acct_id           giac_acct_entries.gl_acct_id%TYPE;
      ws_sl_type_cd           giac_acct_entries.sl_type_cd%TYPE;
      v_old_iss_cd            VARCHAR2 (3);
   BEGIN
      /**************************************************************************
      *                                                                         *
      * Populate the GL Account Code used in every transactions.                *
      *                                                                         *
      **************************************************************************/
      BEGIN
         SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
                gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                pol_type_tag, NVL (intm_type_level, 0),
                NVL (old_new_acct_level, 0), dr_cr_tag,
                NVL (line_dependency_level, 0), sl_type_cd
           INTO ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                ws_gl_sub_acct_2, ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                ws_gl_sub_acct_5, ws_gl_sub_acct_6, ws_gl_sub_acct_7,
                ws_pol_type_tag, ws_intm_type_level,
                ws_old_new_acct_level, ws_dr_cr_tag,
                ws_line_dep_level, ws_sl_type_cd
           FROM giac_module_entries
          WHERE module_id = aeg_module_id AND item_no = aeg_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20001,
                                     'Geniisys Exception#E#No data found in giac_module_entries.'
                                    );
      END;

      /**************************************************************************
      *                                                                         *
      * Validate the INTM_TYPE_LEVEL value which indicates the segment of the   *
      * GL account code that holds the intermediary type.                       *
      *                                                                         *
      **************************************************************************/
      IF ws_intm_type_level != 0
      THEN
         BEGIN
            SELECT DISTINCT (c.acct_intm_cd)
                       INTO ws_acct_intm_cd
                       FROM gipi_comm_invoice a,
                            giis_intermediary b,
                            giis_intm_type c
                      WHERE a.intrmdry_intm_no = b.intm_no
                        AND b.intm_type = c.intm_type
                        AND a.iss_cd = aeg_iss_cd
                        AND a.prem_seq_no = aeg_bill_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (20001,
                                        'No data found in giis_intm_type.'
                                       );
         END;

         giac_acct_entries_pkg.aeg_check_level_n (ws_intm_type_level,
                                                  ws_acct_intm_cd,
                                                  ws_gl_sub_acct_1,
                                                  ws_gl_sub_acct_2,
                                                  ws_gl_sub_acct_3,
                                                  ws_gl_sub_acct_4,
                                                  ws_gl_sub_acct_5,
                                                  ws_gl_sub_acct_6,
                                                  ws_gl_sub_acct_7
                                                 );
      END IF;

      /**************************************************************************
      *                                                                         *
      * Validate the LINE_DEPENDENCY_LEVEL value which indicates the segment of *
      * the GL account code that holds the line number.                         *
      *                                                                         *
      **************************************************************************/
      IF ws_line_dep_level != 0
      THEN
         BEGIN
            SELECT acct_line_cd
              INTO ws_line_cd
              FROM giis_line
             WHERE line_cd = aeg_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (20001, 'No data found in giis_line.');
         END;

         giac_acct_entries_pkg.aeg_check_level_n (ws_line_dep_level,
                                                  ws_line_cd,
                                                  ws_gl_sub_acct_1,
                                                  ws_gl_sub_acct_2,
                                                  ws_gl_sub_acct_3,
                                                  ws_gl_sub_acct_4,
                                                  ws_gl_sub_acct_5,
                                                  ws_gl_sub_acct_6,
                                                  ws_gl_sub_acct_7
                                                 );
      END IF;

      /**************************************************************************
      *                                                                         *
      * Validate the OLD_NEW_ACCT_LEVEL value which indicates the segment of    *
      * the GL account code that holds the old and new account values.          *
      *                                                                         *
      **************************************************************************/
      IF ws_old_new_acct_level != 0
      THEN
         BEGIN
            BEGIN
               SELECT param_value_v
                 INTO v_old_iss_cd
                 FROM giac_parameters
                WHERE param_name = 'OLD_ISS_CD';
            END;

            BEGIN
               SELECT param_value_n
                 INTO ws_old_acct_cd
                 FROM giac_parameters
                WHERE param_name = 'OLD_ACCT_CD';
            END;

            BEGIN
               SELECT param_value_n
                 INTO ws_new_acct_cd
                 FROM giac_parameters
                WHERE param_name = 'NEW_ACCT_CD';
            END;

            IF aeg_iss_cd = v_old_iss_cd
            THEN
               giac_acct_entries_pkg.aeg_check_level_n
                                                      (ws_old_new_acct_level,
                                                       ws_old_acct_cd,
                                                       ws_gl_sub_acct_1,
                                                       ws_gl_sub_acct_2,
                                                       ws_gl_sub_acct_3,
                                                       ws_gl_sub_acct_4,
                                                       ws_gl_sub_acct_5,
                                                       ws_gl_sub_acct_6,
                                                       ws_gl_sub_acct_7
                                                      );
            ELSE
               giac_acct_entries_pkg.aeg_check_level_n
                                                      (ws_old_new_acct_level,
                                                       ws_new_acct_cd,
                                                       ws_gl_sub_acct_1,
                                                       ws_gl_sub_acct_2,
                                                       ws_gl_sub_acct_3,
                                                       ws_gl_sub_acct_4,
                                                       ws_gl_sub_acct_5,
                                                       ws_gl_sub_acct_6,
                                                       ws_gl_sub_acct_7
                                                      );
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (20001,
                                        'No data found in giac_parameters.'
                                       );
         END;
      END IF;

      /**************************************************************************
      *                                                                         *
      * Check the POL_TYPE_TAG which indicates if the policy type GL code       *
      * segments will be attached to this GL account.                           *
      *                                                                         *
      **************************************************************************/
      IF ws_pol_type_tag = 'Y'
      THEN
         BEGIN
            SELECT NVL (gl_sub_acct_1, 0), NVL (gl_sub_acct_2, 0),
                   NVL (gl_sub_acct_3, 0), NVL (gl_sub_acct_4, 0),
                   NVL (gl_sub_acct_5, 0), NVL (gl_sub_acct_6, 0),
                   NVL (gl_sub_acct_7, 0)
              INTO pt_gl_sub_acct_1, pt_gl_sub_acct_2,
                   pt_gl_sub_acct_3, pt_gl_sub_acct_4,
                   pt_gl_sub_acct_5, pt_gl_sub_acct_6,
                   pt_gl_sub_acct_7
              FROM giac_policy_type_entries
             WHERE line_cd = aeg_line_cd AND type_cd = aeg_type_cd;

            IF pt_gl_sub_acct_1 != 0
            THEN
               ws_gl_sub_acct_1 := pt_gl_sub_acct_1;
            END IF;

            IF pt_gl_sub_acct_2 != 0
            THEN
               ws_gl_sub_acct_2 := pt_gl_sub_acct_2;
            END IF;

            IF pt_gl_sub_acct_3 != 0
            THEN
               ws_gl_sub_acct_3 := pt_gl_sub_acct_3;
            END IF;

            IF pt_gl_sub_acct_4 != 0
            THEN
               ws_gl_sub_acct_4 := pt_gl_sub_acct_4;
            END IF;

            IF pt_gl_sub_acct_5 != 0
            THEN
               ws_gl_sub_acct_5 := pt_gl_sub_acct_5;
            END IF;

            IF pt_gl_sub_acct_6 != 0
            THEN
               ws_gl_sub_acct_6 := pt_gl_sub_acct_6;
            END IF;

            IF pt_gl_sub_acct_7 != 0
            THEN
               ws_gl_sub_acct_7 := pt_gl_sub_acct_7;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error
                                (20001,
                                 'No data found in giac_policy_type_entries.'
                                );
         END;
      END IF;

  /**************************************************************************
  *                                                                         *
  * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
  *                                                                         *
  **************************************************************************/
--msg_alert(to_char(aeg_bill_no)||'--'||to_char(aeg_acct_amt)||'--'||to_char(ws_gl_sub_acct_1),'I',FALSE);
      giac_acct_entries_pkg.aeg_check_chart_of_accts_n (ws_gl_acct_category,
                                                        ws_gl_control_acct,
                                                        ws_gl_sub_acct_1,
                                                        ws_gl_sub_acct_2,
                                                        ws_gl_sub_acct_3,
                                                        ws_gl_sub_acct_4,
                                                        ws_gl_sub_acct_5,
                                                        ws_gl_sub_acct_6,
                                                        ws_gl_sub_acct_7,
                                                        ws_gl_acct_id
                                                       );

      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *

      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/
      IF ws_dr_cr_tag = 'D'
      THEN
         IF aeg_acct_amt > 0
         THEN
            ws_debit_amt := ABS (aeg_acct_amt);
            ws_credit_amt := 0;
         ELSE
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_acct_amt);
         END IF;
      ELSE
         IF aeg_acct_amt > 0
         THEN
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_acct_amt);
         ELSE
            ws_debit_amt := ABS (aeg_acct_amt);
            ws_credit_amt := 0;
         END IF;
      END IF;

      /****************************************************************************
      *                                                                           *
      * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      *                                                                           *
      ****************************************************************************/
      giac_acct_entries_pkg.aeg_insert_update_acct_n (ws_gl_acct_category,
                                                      ws_gl_control_acct,
                                                      ws_gl_sub_acct_1,
                                                      ws_gl_sub_acct_2,
                                                      ws_gl_sub_acct_3,
                                                      ws_gl_sub_acct_4,
                                                      ws_gl_sub_acct_5,
                                                      ws_gl_sub_acct_6,
                                                      ws_gl_sub_acct_7,
                                                      aeg_sl_cd,
                                                      ws_sl_type_cd,
                                                      aeg_gen_type,
                                                      ws_gl_acct_id,
                                                      ws_debit_amt,
                                                      ws_credit_amt,
                                                      aeg_bill_no,
                                                      p_giop_gacc_branch_cd,
                                                      p_giop_gacc_fund_cd,
                                                      p_giop_gacc_tran_id
                                                     );
   END;

/*
   **  Created by   :  Tonio
   **  Date Created :  10.07.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure AEG_Create_Acct_Entries_tax_N GIACS007
   */
   PROCEDURE aeg_create_acct_entries_tax_n (
      aeg_tax_cd              giac_taxes.tax_cd%TYPE,
      aeg_tax_amt             giac_direct_prem_collns.tax_amt%TYPE,
      aeg_gen_type            giac_acct_entries.generation_type%TYPE,
      p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
   )
   IS
      ws_gl_acct_category     giac_acct_entries.gl_acct_category%TYPE;
      ws_gl_control_acct      giac_acct_entries.gl_control_acct%TYPE;
      ws_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      ws_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      ws_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      ws_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      ws_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      ws_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_pol_type_tag         giac_module_entries.pol_type_tag%TYPE;
      ws_intm_type_level      giac_module_entries.intm_type_level%TYPE;
      ws_old_new_acct_level   giac_module_entries.old_new_acct_level%TYPE;
      ws_line_dep_level       giac_module_entries.line_dependency_level%TYPE;
      ws_dr_cr_tag            giac_module_entries.dr_cr_tag%TYPE;
      ws_acct_intm_cd         giis_intm_type.acct_intm_cd%TYPE;
      ws_line_cd              giis_line.line_cd%TYPE;
      ws_old_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_new_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      pt_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      pt_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      pt_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      pt_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      pt_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_debit_amt            giac_acct_entries.debit_amt%TYPE;
      ws_credit_amt           giac_acct_entries.credit_amt%TYPE;
      ws_gl_acct_id           giac_acct_entries.gl_acct_id%TYPE;
      dummy                   VARCHAR2 (1);
   BEGIN
      /**************************************************************************
      *                                                                         *
      * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
      *                                                                         *
      **************************************************************************/
      SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
             gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
             gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
             gl_acct_id
        INTO ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
             ws_gl_sub_acct_2, ws_gl_sub_acct_3, ws_gl_sub_acct_4,
             ws_gl_sub_acct_5, ws_gl_sub_acct_6, ws_gl_sub_acct_7,
             ws_gl_acct_id
        FROM giac_taxes
       WHERE tax_cd = aeg_tax_cd;

      BEGIN
         SELECT 'x'
           INTO dummy
           FROM giac_chart_of_accts
          WHERE gl_acct_id = ws_gl_acct_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            BEGIN
               raise_application_error
                     (20001,
                         'GL account code '
                      || TO_CHAR (ws_gl_acct_category)
                      || '-'
                      || TO_CHAR (ws_gl_control_acct, '09')
                      || '-'
                      || TO_CHAR (ws_gl_sub_acct_1, '09')
                      || '-'
                      || TO_CHAR (ws_gl_sub_acct_2, '09')
                      || '-'
                      || TO_CHAR (ws_gl_sub_acct_3, '09')
                      || '-'
                      || TO_CHAR (ws_gl_sub_acct_4, '09')
                      || '-'
                      || TO_CHAR (ws_gl_sub_acct_5, '09')
                      || '-'
                      || TO_CHAR (ws_gl_sub_acct_6, '09')
                      || '-'
                      || TO_CHAR (ws_gl_sub_acct_7, '09')
                      || ' does not exist in Chart of Accounts (Giac_Acctrans).'
                     );
            END;
      END;

      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *

      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/
      IF ws_dr_cr_tag = 'D'
      THEN
         IF aeg_tax_amt > 0
         THEN
            ws_debit_amt := ABS (aeg_tax_amt);
            ws_credit_amt := 0;
         ELSE
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_tax_amt);
         END IF;
      ELSE
         IF aeg_tax_amt > 0
         THEN
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_tax_amt);
         ELSE
            ws_debit_amt := ABS (aeg_tax_amt);
            ws_credit_amt := 0;
         END IF;
      END IF;

      /****************************************************************************
      *                                                                           *
      * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      *                                                                           *
      ****************************************************************************/
      giac_acct_entries_pkg.aeg_ins_upd_acct_tax_n (ws_gl_acct_category,
                                                    ws_gl_control_acct,
                                                    ws_gl_sub_acct_1,
                                                    ws_gl_sub_acct_2,
                                                    ws_gl_sub_acct_3,
                                                    ws_gl_sub_acct_4,
                                                    ws_gl_sub_acct_5,
                                                    ws_gl_sub_acct_6,
                                                    ws_gl_sub_acct_7,
                                                    NULL,
                                                    aeg_gen_type,
                                                    ws_gl_acct_id,
                                                    ws_debit_amt,
                                                    ws_credit_amt,
                                                    p_giop_gacc_branch_cd,
                                                    p_giop_gacc_fund_cd,
                                                    p_giop_gacc_tran_id
                                                   );
   END aeg_create_acct_entries_tax_n;

/*
   **  Created by   :  Tonio
   **  Date Created :  10.07.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure aeg_ins_upd_acct_tax_n GIACS007
   */
   PROCEDURE aeg_ins_upd_acct_tax_n (
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
      p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
   )
   IS
      iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
   BEGIN
      SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gacc_gibr_branch_cd = p_giop_gacc_branch_cd
         AND gacc_gfun_fund_cd = p_giop_gacc_fund_cd
         AND gacc_tran_id = p_giop_gacc_tran_id
         AND generation_type = iuae_generation_type
         AND NVL (gl_acct_id, gl_acct_id) = iuae_gl_acct_id;

      IF NVL (iuae_acct_entry_id, 0) = 0
      THEN
         iuae_acct_entry_id := NVL (iuae_acct_entry_id, 0) + 1;

         INSERT INTO giac_acct_entries
                     (gacc_tran_id, gacc_gfun_fund_cd,
                      gacc_gibr_branch_cd, acct_entry_id,
                      gl_acct_id, gl_acct_category,
                      gl_control_acct, gl_sub_acct_1,
                      gl_sub_acct_2, gl_sub_acct_3,
                      gl_sub_acct_4, gl_sub_acct_5,
                      gl_sub_acct_6, gl_sub_acct_7, sl_cd,
                      debit_amt, credit_amt, generation_type,
                      user_id, last_update
                     )
              VALUES (p_giop_gacc_tran_id, p_giop_gacc_fund_cd,
                      p_giop_gacc_branch_cd, iuae_acct_entry_id,
                      iuae_gl_acct_id, iuae_gl_acct_category,
                      iuae_gl_control_acct, iuae_gl_sub_acct_1,
                      iuae_gl_sub_acct_2, iuae_gl_sub_acct_3,
                      iuae_gl_sub_acct_4, iuae_gl_sub_acct_5,
                      iuae_gl_sub_acct_6, iuae_gl_sub_acct_7, iuae_sl_cd,
                      iuae_debit_amt, iuae_credit_amt, iuae_generation_type,
                      NVL (giis_users_pkg.app_user, USER), SYSDATE
                     );
      ELSE
         UPDATE giac_acct_entries
            SET debit_amt = debit_amt + iuae_debit_amt,
                credit_amt = credit_amt + iuae_credit_amt
          WHERE generation_type = iuae_generation_type
            AND NVL (gl_acct_id, gl_acct_id) = iuae_gl_acct_id
            AND gacc_gibr_branch_cd = p_giop_gacc_branch_cd
            AND gacc_gfun_fund_cd = p_giop_gacc_fund_cd
            AND gacc_tran_id = p_giop_gacc_tran_id;
      END IF;
   END aeg_ins_upd_acct_tax_n;

/*
   **  Created by   :  Tonio
   **  Date Created :  10.07.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure AEG_Check_Chart_Of_Accts_N GIACS007
   */
   PROCEDURE aeg_check_chart_of_accts_n (
      cca_gl_acct_category            giac_acct_entries.gl_acct_category%TYPE,
      cca_gl_control_acct             giac_acct_entries.gl_control_acct%TYPE,
      cca_gl_sub_acct_1               giac_acct_entries.gl_sub_acct_1%TYPE,
      cca_gl_sub_acct_2               giac_acct_entries.gl_sub_acct_2%TYPE,
      cca_gl_sub_acct_3               giac_acct_entries.gl_sub_acct_3%TYPE,
      cca_gl_sub_acct_4               giac_acct_entries.gl_sub_acct_4%TYPE,
      cca_gl_sub_acct_5               giac_acct_entries.gl_sub_acct_5%TYPE,
      cca_gl_sub_acct_6               giac_acct_entries.gl_sub_acct_6%TYPE,
      cca_gl_sub_acct_7               giac_acct_entries.gl_sub_acct_7%TYPE,
      cca_gl_acct_id         IN OUT   giac_chart_of_accts.gl_acct_id%TYPE
   )
   IS
   BEGIN
      SELECT DISTINCT (gl_acct_id)
                 INTO cca_gl_acct_id
                 FROM giac_chart_of_accts
                WHERE gl_acct_category = cca_gl_acct_category
                  AND gl_control_acct = cca_gl_control_acct
                  AND gl_sub_acct_1 = cca_gl_sub_acct_1
                  AND gl_sub_acct_2 = cca_gl_sub_acct_2
                  AND gl_sub_acct_3 = cca_gl_sub_acct_3
                  AND gl_sub_acct_4 = cca_gl_sub_acct_4
                  AND gl_sub_acct_5 = cca_gl_sub_acct_5
                  AND gl_sub_acct_6 = cca_gl_sub_acct_6
                  AND gl_sub_acct_7 = cca_gl_sub_acct_7;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            raise_application_error
                     (20001,
                         'GL account code '
                      || TO_CHAR (cca_gl_acct_category)
                      || '-'
                      || TO_CHAR (cca_gl_control_acct, '09')
                      || '-'
                      || TO_CHAR (cca_gl_sub_acct_1, '09')
                      || '-'
                      || TO_CHAR (cca_gl_sub_acct_2, '09')
                      || '-'
                      || TO_CHAR (cca_gl_sub_acct_3, '09')
                      || '-'
                      || TO_CHAR (cca_gl_sub_acct_4, '09')
                      || '-'
                      || TO_CHAR (cca_gl_sub_acct_5, '09')
                      || '-'
                      || TO_CHAR (cca_gl_sub_acct_6, '09')
                      || '-'
                      || TO_CHAR (cca_gl_sub_acct_7, '09')
                      || ' does not exist in Chart of Accounts (Giac_Acctrans).'
                     );
         END;
   END aeg_check_chart_of_accts_n;

/*
   **  Created by   :  Tonio
   **  Date Created :  10.07.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure aeg_insert_update_acct_nGIACS007
   */
   PROCEDURE aeg_insert_update_acct_n (
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
      iuae_bill_no            giac_tax_collns.b160_prem_seq_no%TYPE,
      p_giop_gacc_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_giop_gacc_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_giop_gacc_tran_id     giac_acct_entries.gacc_tran_id%TYPE
   )
   IS
      iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
   BEGIN
      SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gacc_gibr_branch_cd = p_giop_gacc_branch_cd
         AND gacc_gfun_fund_cd = p_giop_gacc_fund_cd
         AND gacc_tran_id = p_giop_gacc_tran_id
         AND sl_cd = iuae_sl_cd
         AND generation_type = iuae_generation_type
         AND NVL (gl_acct_id, gl_acct_id) = iuae_gl_acct_id;

      IF NVL (iuae_acct_entry_id, 0) = 0
      THEN
         iuae_acct_entry_id := NVL (iuae_acct_entry_id, 0) + 1;

         INSERT INTO giac_acct_entries
                     (gacc_tran_id, gacc_gfun_fund_cd,
                      gacc_gibr_branch_cd, acct_entry_id,
                      gl_acct_id, gl_acct_category,
                      gl_control_acct, gl_sub_acct_1,
                      gl_sub_acct_2, gl_sub_acct_3,
                      gl_sub_acct_4, gl_sub_acct_5,
                      gl_sub_acct_6, gl_sub_acct_7, sl_cd,
                      sl_type_cd, debit_amt, credit_amt,
                      generation_type,
                      user_id, last_update
                     )
              VALUES (p_giop_gacc_tran_id, p_giop_gacc_fund_cd,
                      p_giop_gacc_branch_cd, iuae_acct_entry_id,
                      iuae_gl_acct_id, iuae_gl_acct_category,
                      iuae_gl_control_acct, iuae_gl_sub_acct_1,
                      iuae_gl_sub_acct_2, iuae_gl_sub_acct_3,
                      iuae_gl_sub_acct_4, iuae_gl_sub_acct_5,
                      iuae_gl_sub_acct_6, iuae_gl_sub_acct_7, iuae_sl_cd,
                      iuae_sl_type_cd, iuae_debit_amt, iuae_credit_amt,
                      iuae_generation_type,
                      NVL (giis_users_pkg.app_user, USER), SYSDATE
                     );
      ELSE
         UPDATE giac_acct_entries
            SET debit_amt = debit_amt + iuae_debit_amt,
                credit_amt = credit_amt + iuae_credit_amt
          WHERE sl_cd = iuae_sl_cd
            AND generation_type = iuae_generation_type
            AND NVL (gl_acct_id, gl_acct_id) = iuae_gl_acct_id
            AND gacc_gibr_branch_cd = p_giop_gacc_branch_cd
            AND gacc_gfun_fund_cd = p_giop_gacc_fund_cd
            AND gacc_tran_id = p_giop_gacc_tran_id;
      END IF;
   END aeg_insert_update_acct_n;

/*
   **  Created by   :  Tonio
   **  Date Created :  10.07.2010
   **  Reference By : (GIACS007 - Direct Premium Collections)
   **  Description  : Executes procedure aeg_check_level_n GIACS007
   */
   PROCEDURE aeg_check_level_n (
      cl_level       IN       NUMBER,
      cl_value       IN       NUMBER,
      cl_sub_acct1   IN OUT   NUMBER,
      cl_sub_acct2   IN OUT   NUMBER,
      cl_sub_acct3   IN OUT   NUMBER,
      cl_sub_acct4   IN OUT   NUMBER,
      cl_sub_acct5   IN OUT   NUMBER,
      cl_sub_acct6   IN OUT   NUMBER,
      cl_sub_acct7   IN OUT   NUMBER
   )
   IS
   BEGIN
      IF cl_level = 1
      THEN
         cl_sub_acct1 := cl_value;
      ELSIF cl_level = 2
      THEN
         cl_sub_acct2 := cl_value;
      ELSIF cl_level = 3
      THEN
         cl_sub_acct3 := cl_value;
      ELSIF cl_level = 4
      THEN
         cl_sub_acct4 := cl_value;
      ELSIF cl_level = 5
      THEN
         cl_sub_acct5 := cl_value;
      ELSIF cl_level = 6
      THEN
         cl_sub_acct6 := cl_value;
      ELSIF cl_level = 7
      THEN
         cl_sub_acct7 := cl_value;
      END IF;
   END aeg_check_level_n;

   /*
   **  Created by   :  Emman
   **  Date Created :  10.29.2010
   **  Reference By : (GIACS018 - Facul Claim Payts)
   **  Description  : Executes procedure AEG_INSERT_UPDATE_ACCT_ENTRIES on GIACS018
   */
   PROCEDURE aeg_ins_updt_acct_ent_giacs018 (
      p_gacc_tran_id      IN       giac_inw_claim_payts.gacc_tran_id%TYPE,
      p_gacc_branch_cd    IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd      IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_var_module_name   IN       giac_modules.module_name%TYPE,
      p_var_gen_type      IN OUT   giac_modules.generation_type%TYPE,
      p_message           OUT      VARCHAR2
   )
   IS
      CURSOR cur_acct_entries
      IS
         SELECT   generation_type, gl_acct_id, gl_acct_category,
                  gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
                  gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                  gl_sub_acct_7, sl_type_cd, sl_cd, sl_source_cd,
                  SUM (debit_amt) debit_amt, SUM (credit_amt) credit_amt,
                  advice_id, claim_id
             FROM gicl_acct_entries
            WHERE (claim_id, advice_id) IN (
                                          SELECT claim_id, advice_id
                                            FROM giac_inw_claim_payts
                                           WHERE gacc_tran_id =
                                                               p_gacc_tran_id)
         GROUP BY generation_type,
                  gl_acct_id,
                  gl_acct_category,
                  gl_control_acct,
                  gl_sub_acct_1,
                  gl_sub_acct_2,
                  gl_sub_acct_3,
                  gl_sub_acct_4,
                  gl_sub_acct_5,
                  gl_sub_acct_6,
                  gl_sub_acct_7,
                  sl_type_cd,
                  sl_cd,
                  sl_source_cd,
                  advice_id,
                  claim_id;

      v_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
   BEGIN
      p_message := 'SUCCESS';

      BEGIN
         SELECT generation_type
           INTO p_var_gen_type
           FROM giac_modules
          WHERE module_name = p_var_module_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message := 'No data found in GIAC MODULES.';
            RETURN;
      END;

      giac_acct_entries_pkg.aeg_delete_acct_entries (p_gacc_tran_id,
                                                     p_var_gen_type
                                                    );

      BEGIN
         SELECT MAX (acct_entry_id)
           INTO v_acct_entry_id
           FROM giac_acct_entries
          WHERE gacc_tran_id = p_gacc_tran_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_acct_entry_id := 0;
      END;

      FOR al IN cur_acct_entries
      LOOP
         v_acct_entry_id := v_acct_entry_id + 1;

         FOR t IN (SELECT transaction_type
                     FROM giac_inw_claim_payts
                    WHERE gacc_tran_id = p_gacc_tran_id
                      AND claim_id = al.claim_id
                      AND advice_id = al.advice_id)
         LOOP
            IF t.transaction_type = 1
            THEN
               INSERT INTO giac_acct_entries
                           (gacc_tran_id, gacc_gfun_fund_cd,
                            gacc_gibr_branch_cd, acct_entry_id,
                            gl_acct_id, gl_acct_category,
                            gl_control_acct, gl_sub_acct_1,
                            gl_sub_acct_2, gl_sub_acct_3,
                            gl_sub_acct_4, gl_sub_acct_5,
                            gl_sub_acct_6, gl_sub_acct_7,
                            sl_type_cd, sl_cd, sl_source_cd,
                            debit_amt, credit_amt, generation_type,
                            user_id, last_update
                           )
                    VALUES (p_gacc_tran_id, p_gacc_fund_cd,
                            p_gacc_branch_cd, v_acct_entry_id,
                            al.gl_acct_id, al.gl_acct_category,
                            al.gl_control_acct, al.gl_sub_acct_1,
                            al.gl_sub_acct_2, al.gl_sub_acct_3,
                            al.gl_sub_acct_4, al.gl_sub_acct_5,
                            al.gl_sub_acct_6, al.gl_sub_acct_7,
                            al.sl_type_cd, al.sl_cd, al.sl_source_cd,
                            al.debit_amt, al.credit_amt, p_var_gen_type,
                            NVL (giis_users_pkg.app_user, USER), SYSDATE
                           );
            ELSIF t.transaction_type = 2
            THEN
               INSERT INTO giac_acct_entries
                           (gacc_tran_id, gacc_gfun_fund_cd,
                            gacc_gibr_branch_cd, acct_entry_id,
                            gl_acct_id, gl_acct_category,
                            gl_control_acct, gl_sub_acct_1,
                            gl_sub_acct_2, gl_sub_acct_3,
                            gl_sub_acct_4, gl_sub_acct_5,
                            gl_sub_acct_6, gl_sub_acct_7,
                            sl_type_cd, sl_cd, sl_source_cd,
                            debit_amt, credit_amt, generation_type,
                            user_id, last_update
                           )
                    VALUES (p_gacc_tran_id, p_gacc_fund_cd,
                            p_gacc_branch_cd, v_acct_entry_id,
                            al.gl_acct_id, al.gl_acct_category,
                            al.gl_control_acct, al.gl_sub_acct_1,
                            al.gl_sub_acct_2, al.gl_sub_acct_3,
                            al.gl_sub_acct_4, al.gl_sub_acct_5,
                            al.gl_sub_acct_6, al.gl_sub_acct_7,
                            al.sl_type_cd, al.sl_cd, al.sl_source_cd,
                            al.credit_amt, al.debit_amt, p_var_gen_type,
                            NVL (giis_users_pkg.app_user, USER), SYSDATE
                           );
            END IF;
         END LOOP;
      END LOOP;
   END aeg_ins_updt_acct_ent_giacs018;

   /*
   **  Created by   :  D.Alcantara
   **  Date Created :  12.01.2010
   **  Reference By : (GIACS030 - Accounting Entries)
   **  Description  : Retrieves list of accounting entries
   */
   FUNCTION get_acct_entries (
      p_gacc_tran_id   IN   giac_acct_entries.gacc_tran_id%TYPE
   )
      RETURN acct_entries_tab PIPELINED
   IS
      v_entries   acct_entries_type;
   BEGIN
      FOR i IN
         (SELECT   gac.gacc_tran_id, gac.gacc_gfun_fund_cd,
                   gac.gacc_gibr_branch_cd, gac.acct_entry_id,
                   gac.gl_acct_id,
                   LTRIM(TO_CHAR (gac.gl_acct_category, '09')) gl_acct_category,
                   LTRIM(TO_CHAR (gac.gl_control_acct, '09')) gl_control_acct,
                   LTRIM(TO_CHAR (gac.gl_sub_acct_1, '09')) gl_sub_acct_1,
                   LTRIM(TO_CHAR (gac.gl_sub_acct_2, '09')) gl_sub_acct_2,
                   LTRIM(TO_CHAR (gac.gl_sub_acct_3, '09')) gl_sub_acct_3,
                   LTRIM(TO_CHAR (gac.gl_sub_acct_4, '09')) gl_sub_acct_4,
                   LTRIM(TO_CHAR (gac.gl_sub_acct_5, '09')) gl_sub_acct_5,
                   LTRIM(TO_CHAR (gac.gl_sub_acct_6, '09')) gl_sub_acct_6,
                   LTRIM(TO_CHAR (gac.gl_sub_acct_7, '09')) gl_sub_acct_7,
                   gac.sl_cd, gac.debit_amt, gac.credit_amt,
                   gac.generation_type, gac.sl_type_cd, gac.sl_source_cd,
                   gac.remarks, gac.cpi_rec_no, gac.cpi_branch_cd,
                   gac.sap_text, gcoa.gl_acct_name,
                   (giac_sl_lists_pkg.get_sl_name (gac.sl_type_cd, gac.sl_cd)
                   ) sl_name, gac.acct_ref_no, gac.acct_tran_type, gcoa.dr_cr_tag	--acct_ref_no,acct_tran_type,dr_cr_tag - Gzelle 11102015 KB#132 AP/AR ENH
              FROM giac_acct_entries gac, giac_chart_of_accts gcoa
             WHERE gac.gacc_tran_id = p_gacc_tran_id
               AND gac.gl_acct_id = gcoa.gl_acct_id
          ORDER BY gac.acct_entry_id)
/*gac.gl_acct_category, gac.gl_control_acct, gac.gl_sub_acct_1, gac.gl_sub_acct_2, gac.gl_sub_acct_3,
gac.gl_sub_acct_4, gac.gl_sub_acct_5, gac.gl_sub_acct_6, gac.gl_sub_acct_7 */
                  
      LOOP
         v_entries.gacc_tran_id := i.gacc_tran_id;
         v_entries.gacc_gfun_fund_cd := i.gacc_gfun_fund_cd;
         v_entries.gacc_gibr_branch_cd := i.gacc_gibr_branch_cd;
         v_entries.acct_entry_id := i.acct_entry_id;
         v_entries.gl_acct_id := i.gl_acct_id;
         v_entries.gl_acct_category := i.gl_acct_category;
         v_entries.gl_control_acct := i.gl_control_acct;
         v_entries.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_entries.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_entries.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_entries.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_entries.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_entries.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_entries.gl_sub_acct_7 := i.gl_sub_acct_7;
         v_entries.sl_cd := i.sl_cd;
         v_entries.debit_amt := i.debit_amt;
         v_entries.credit_amt := i.credit_amt;
         v_entries.generation_type := i.generation_type;
         v_entries.sl_type_cd := i.sl_type_cd;
         v_entries.sl_source_cd := i.sl_source_cd;
         v_entries.remarks := i.remarks;
         v_entries.cpi_rec_no := i.cpi_rec_no;
         v_entries.cpi_branch_cd := i.cpi_branch_cd;
         v_entries.sap_text := i.sap_text;
         v_entries.gl_acct_name := i.gl_acct_name;
         v_entries.sl_name := i.sl_name;
         v_entries.acct_code := i.gl_acct_category || ' - ' ||i.gl_control_acct || ' - ' || i.gl_sub_acct_1|| ' - ' ||i.gl_sub_acct_2 || ' - ' || i.gl_sub_acct_3 || ' - ' || i.gl_sub_acct_4 || ' - ' || i.gl_sub_acct_5 || ' - ' || i.gl_sub_acct_6 || ' - ' || i.gl_sub_acct_7;
         /*start - Gzelle 11102015 KB#132 AP/AR ENH*/
         BEGIN
            SELECT ledger_cd, subledger_cd, transaction_cd, acct_seq_no
              INTO v_entries.ledger_cd, v_entries.subledger_cd, v_entries.transaction_cd, v_entries.acct_seq_no
              FROM giac_gl_acct_ref_no
             WHERE gacc_tran_id = i.gacc_tran_id 
               AND gl_acct_id = i.gl_acct_id
               AND sl_cd = i.sl_cd
               AND acct_tran_type = i.acct_tran_type;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_entries.ledger_cd      := NULL;
                v_entries.subledger_cd   := NULL;
                v_entries.transaction_cd := NULL;
                v_entries.acct_seq_no    := NULL;
            WHEN TOO_MANY_ROWS THEN
                v_entries.ledger_cd      := NULL;
                v_entries.subledger_cd   := NULL;
                v_entries.transaction_cd := NULL;
                v_entries.acct_seq_no    := NULL;
         END;
         v_entries.acct_tran_type := i.acct_tran_type;
         v_entries.acct_ref_no    := i.acct_ref_no;
         v_entries.dr_cr_tag      := i.dr_cr_tag;
         /*end - Gzelle 11122015 KB#132 AP/AR ENH*/
         PIPE ROW (v_entries);
      END LOOP;

      RETURN;
   END get_acct_entries;

   /*
    **  Created by   :  Emman
    **  Date Created :  12.07.2010
    **  Reference By : (GIACS022 - Other Trans Withholding Tax)
    **  Description  : Executes procedure AEG_INSERT_UPDATE_ACCT_ENTRIES on GIACS022
    */
   PROCEDURE aeg_ins_updt_acct_ent_giacs022 (
      p_gacc_tran_id          giac_taxes_wheld.gacc_tran_id%TYPE,
      p_gacc_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd          giac_acctrans.gfun_fund_cd%TYPE,
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
      iuae_sl_type_cd         giac_taxes_wheld.sl_type_cd%TYPE,
      iuae_sl_cd              giac_taxes_wheld.sl_cd%TYPE
   )
   IS
      iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
      v_sl_source_cd       giac_acct_entries.sl_source_cd%TYPE    := 1;
   BEGIN
      SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gacc_gibr_branch_cd = p_gacc_branch_cd
         AND gacc_gfun_fund_cd = p_gacc_fund_cd
         AND gacc_tran_id = p_gacc_tran_id
         AND gl_acct_category = iuae_gl_acct_category
         AND gl_control_acct = iuae_gl_control_acct
         AND gl_sub_acct_1 = iuae_gl_sub_acct_1
         AND gl_sub_acct_2 = iuae_gl_sub_acct_2
         AND gl_sub_acct_3 = iuae_gl_sub_acct_3
         AND gl_sub_acct_4 = iuae_gl_sub_acct_4
         AND gl_sub_acct_5 = iuae_gl_sub_acct_5
         AND gl_sub_acct_6 = iuae_gl_sub_acct_6
         AND gl_sub_acct_7 = iuae_gl_sub_acct_7
         AND sl_cd = iuae_sl_cd
         AND generation_type = iuae_generation_type;

      -- giac_acct_entries.sl_source_cd is 2 (from payees) for
      -- entries generated by giacs022 otherwise it is 1 (from sl)
      -- as of June 27, 2001, giac_acct_entries.sl_source_cd is always 1
      IF NVL (iuae_acct_entry_id, 0) = 0
      THEN
         iuae_acct_entry_id := NVL (iuae_acct_entry_id, 0) + 1;

         INSERT INTO giac_acct_entries
                     (gacc_tran_id, gacc_gfun_fund_cd, gacc_gibr_branch_cd,
                      acct_entry_id, gl_acct_id,
                      gl_acct_category, gl_control_acct,
                      gl_sub_acct_1, gl_sub_acct_2,
                      gl_sub_acct_3, gl_sub_acct_4,
                      gl_sub_acct_5, gl_sub_acct_6,
                      gl_sub_acct_7, sl_type_cd, sl_cd,
                      sl_source_cd, debit_amt, credit_amt,
                      generation_type,
                      user_id, last_update
                     )
              VALUES (p_gacc_tran_id, p_gacc_fund_cd, p_gacc_branch_cd,
                      iuae_acct_entry_id, iuae_gl_acct_id,
                      iuae_gl_acct_category, iuae_gl_control_acct,
                      iuae_gl_sub_acct_1, iuae_gl_sub_acct_2,
                      iuae_gl_sub_acct_3, iuae_gl_sub_acct_4,
                      iuae_gl_sub_acct_5, iuae_gl_sub_acct_6,
                      iuae_gl_sub_acct_7, iuae_sl_type_cd, iuae_sl_cd,
                      v_sl_source_cd, iuae_debit_amt, iuae_credit_amt,
                      iuae_generation_type,
                      NVL (giis_users_pkg.app_user, USER), SYSDATE
                     );
      ELSE
         UPDATE giac_acct_entries
            SET debit_amt = debit_amt + iuae_debit_amt,
                credit_amt = credit_amt + iuae_credit_amt
          WHERE generation_type = iuae_generation_type
            AND sl_cd = iuae_sl_cd
            AND gl_acct_id = iuae_gl_acct_id
            AND gacc_gibr_branch_cd = p_gacc_branch_cd
            AND gacc_gfun_fund_cd = p_gacc_fund_cd
            AND gacc_tran_id = p_gacc_tran_id;
      END IF;
   END aeg_ins_updt_acct_ent_giacs022;

   /*
    **  Created by   :  Emman
    **  Date Created :  12.07.2010
    **  Reference By : (GIACS022 - Other Trans Withholding Tax)
    **  Description  : Executes procedure AEG_CREATE_ACCT_ENTRIES on GIACS022
    */
   PROCEDURE aeg_create_acc_ent_giacs022 (
      p_gacc_tran_id            giac_taxes_wheld.gacc_tran_id%TYPE,
      p_gacc_branch_cd          giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd            giac_acctrans.gfun_fund_cd%TYPE,
      aeg_module_id             giac_module_entries.module_id%TYPE,
      aeg_item_no               giac_module_entries.item_no%TYPE,
      aeg_acct_amt              giac_taxes_wheld.wholding_tax_amt%TYPE,
      aeg_sl_type_cd            giac_taxes_wheld.sl_type_cd%TYPE,
      aeg_sl_cd                 giac_taxes_wheld.sl_cd%TYPE,
      aeg_gwtx_whtax_id         giac_taxes_wheld.gwtx_whtax_id%TYPE,
      aeg_gen_type              giac_acct_entries.generation_type%TYPE,
      p_message           OUT   VARCHAR2
   )
   IS
      ws_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE;
      ws_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE;
      ws_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE;
      ws_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE;
      ws_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE;
      ws_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE;
      ws_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE;
      ws_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_gl_acct_id         giac_acct_entries.gl_acct_id%TYPE;
      ws_acct_intm_cd       giis_intm_type.acct_intm_cd%TYPE;
      ws_debit_amt          giac_acct_entries.debit_amt%TYPE;
      ws_credit_amt         giac_acct_entries.credit_amt%TYPE;
   BEGIN
      p_message := 'SUCCESS';

      /**************************************************************************
      *                                                                         *
      * Populate the GL Account Code used in every transactions.                *
      *                                                                         *
      **************************************************************************/
      BEGIN
         SELECT a.gl_acct_category, a.gl_control_acct, a.gl_sub_acct_1,
                a.gl_sub_acct_2, a.gl_sub_acct_3, a.gl_sub_acct_4,
                a.gl_sub_acct_5, a.gl_sub_acct_6, a.gl_sub_acct_7,
                a.gl_acct_id
           INTO ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                ws_gl_sub_acct_2, ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                ws_gl_sub_acct_5, ws_gl_sub_acct_6, ws_gl_sub_acct_7,
                ws_gl_acct_id
           FROM giac_chart_of_accts a, giac_wholding_taxes b
          WHERE aeg_gwtx_whtax_id = b.whtax_id AND b.gl_acct_id = a.gl_acct_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message := 'No data found in giac_wholding_taxes.';
            RETURN;
      END;

      /**************************************************************************
      *                                                                         *
      * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
      *                                                                         *
      **************************************************************************/
      giac_acct_entries_pkg.aeg_check_chart_of_accts (ws_gl_acct_category,
                                                      ws_gl_control_acct,
                                                      ws_gl_sub_acct_1,
                                                      ws_gl_sub_acct_2,
                                                      ws_gl_sub_acct_3,
                                                      ws_gl_sub_acct_4,
                                                      ws_gl_sub_acct_5,
                                                      ws_gl_sub_acct_6,
                                                      ws_gl_sub_acct_7,
                                                      ws_gl_acct_id,
                                                      p_message
                                                     );

      IF p_message IS NULL
      THEN
         p_message := 'SUCCESS';
      ELSE
         RETURN;
      END IF;

      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/
      IF aeg_acct_amt > 0
      THEN
         ws_debit_amt := 0;
         ws_credit_amt := ABS (aeg_acct_amt);
      ELSIF aeg_acct_amt < 0
      THEN
         ws_debit_amt := ABS (aeg_acct_amt);
         ws_credit_amt := 0;
      END IF;

      /****************************************************************************
      *                                                                           *
      * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      *                                                                           *
      ****************************************************************************/
      giac_acct_entries_pkg.aeg_ins_updt_acct_ent_giacs022
                                                         (p_gacc_tran_id,
                                                          p_gacc_branch_cd,
                                                          p_gacc_fund_cd,
                                                          ws_gl_acct_category,
                                                          ws_gl_control_acct,
                                                          ws_gl_sub_acct_1,
                                                          ws_gl_sub_acct_2,
                                                          ws_gl_sub_acct_3,
                                                          ws_gl_sub_acct_4,
                                                          ws_gl_sub_acct_5,
                                                          ws_gl_sub_acct_6,
                                                          ws_gl_sub_acct_7,
                                                          aeg_gen_type,
                                                          ws_gl_acct_id,
                                                          ws_debit_amt,
                                                          ws_credit_amt,
                                                          aeg_sl_type_cd,
                                                          aeg_sl_cd
                                                         );
   END aeg_create_acc_ent_giacs022;

   /*
    **  Created by   : Emman
    **  Date Created    : 12.07.2010
    **  Reference By    : (GIACS022 - Other Trans Withholding Tax)
    **  Description  : Executes the procedure AEG_PARAMETERS in the POST-FORMS-COMMIT trigger of GIACS022 module
    */
   PROCEDURE aeg_parameters_giacs022 (
      p_gacc_tran_id      IN       giac_taxes_wheld.gacc_tran_id%TYPE,
      p_gacc_branch_cd    IN       giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd      IN       giac_acctrans.gfun_fund_cd%TYPE,
      p_var_module_name   IN       giac_modules.module_name%TYPE,
      p_message           OUT      VARCHAR2
   )
   IS
      CURSOR pr_cur
      IS
         SELECT wholding_tax_amt, sl_type_cd, sl_cd, gwtx_whtax_id, gen_type
           FROM giac_taxes_wheld
          WHERE gacc_tran_id = p_gacc_tran_id;

      v_module_id   giac_modules.module_id%TYPE;
      v_gen_type    giac_modules.generation_type%TYPE;
      v_item_no     giac_module_entries.item_no%TYPE    := 1;
   BEGIN
      p_message := 'SUCCESS';

      BEGIN
         SELECT module_id, generation_type
           INTO v_module_id, v_gen_type
           FROM giac_modules
          WHERE module_name = p_var_module_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message := 'No data found in GIAC MODULES.';
            RETURN;
      END;

      /*
      ** Call the deletion of accounting entry procedure.
      */
      giac_acct_entries_pkg.aeg_delete_acct_entries (p_gacc_tran_id,
                                                     v_gen_type
                                                    );

      FOR pr_rec IN pr_cur
      LOOP
         IF pr_rec.gen_type = 'P'
         THEN
            IF pr_rec.sl_cd IS NULL
            THEN
               giac_acct_entries_pkg.aeg_create_acc_ent_giacs022
                                                    (p_gacc_tran_id,
                                                     p_gacc_branch_cd,
                                                     p_gacc_fund_cd,
                                                     v_module_id,
                                                     v_item_no,
                                                     pr_rec.wholding_tax_amt,
                                                     pr_rec.sl_type_cd,
                                                     NULL,
                                                     pr_rec.gwtx_whtax_id,
                                                     v_gen_type,
                                                     p_message
                                                    );
            ELSE
               /* Call the accounting entry generation procedure.*/
               giac_acct_entries_pkg.aeg_create_acc_ent_giacs022
                                                    (p_gacc_tran_id,
                                                     p_gacc_branch_cd,
                                                     p_gacc_fund_cd,
                                                     v_module_id,
                                                     v_item_no,
                                                     pr_rec.wholding_tax_amt,
                                                     pr_rec.sl_type_cd,
                                                     pr_rec.sl_cd,
                                                     pr_rec.gwtx_whtax_id,
                                                     v_gen_type,
                                                     p_message
                                                    );
            END IF;
         END IF;
      END LOOP;
   END aeg_parameters_giacs022;

       /*
   **  Created by   :  D.Alcantara
   **  Date Created :  12.08.2010
   **  Reference By : (GIACS030 - Accounting Entries)
   **  Description  : Deletes an accounting entry
   */
   PROCEDURE delete_acct_entry (
      p_gacc_tran_id    IN   giac_acct_entries.gacc_tran_id%TYPE,
      p_acct_entry_id   IN   giac_acct_entries.acct_entry_id%TYPE
   )
   IS
   BEGIN
      DELETE FROM giac_acct_entries
            WHERE acct_entry_id = p_acct_entry_id
              AND gacc_tran_id = p_gacc_tran_id;
   END delete_acct_entry;

       /*
   **  Created by   :  D.Alcantara
   **  Date Created :  12.08.2010
   **  Reference By : (GIACS030 - Accounting Entries)
   **  Description  : Saves an accounting entry
   */
   PROCEDURE save_acct_entry (
      p_gacc_tran_id          giac_acct_entries.gacc_tran_id%TYPE,
      p_gacc_gfun_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_gibr_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_acct_entry_id         NUMBER,
      p_gl_acct_id            giac_acct_entries.gl_acct_id%TYPE,
      p_gl_acct_category      giac_acct_entries.gl_acct_category%TYPE,
      p_gl_control_acct       giac_acct_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1         giac_acct_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2         giac_acct_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3         giac_acct_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4         giac_acct_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5         giac_acct_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6         giac_acct_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7         giac_acct_entries.gl_sub_acct_7%TYPE,
      p_sl_cd                 giac_acct_entries.sl_cd%TYPE,
      p_debit_amt             giac_acct_entries.debit_amt%TYPE,
      p_credit_amt            giac_acct_entries.credit_amt%TYPE,
      p_generation_type       giac_acct_entries.generation_type%TYPE,
      p_sl_type_cd            giac_acct_entries.sl_type_cd%TYPE,
      p_sl_source_cd          giac_acct_entries.sl_source_cd%TYPE,
      p_remarks               giac_acct_entries.remarks%TYPE,
      p_sap_text              giac_acct_entries.sap_text%TYPE,
      p_user_id               giac_acct_entries.user_id%TYPE,
      p_acct_ref_no           giac_acct_entries.acct_ref_no%TYPE,   --Gzelle 11102015 KB#132 AP/AR ENH 
      p_acct_tran_type        giac_acct_entries.acct_tran_type%TYPE --Gzelle 11102015 KB#132 AP/AR ENH
   )
   IS
      v_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
      v_exists          NUMBER;
   BEGIN
      SELECT NVL (MAX (acct_entry_id), 0) + 1
        INTO v_acct_entry_id
        FROM giac_acct_entries
       WHERE gacc_tran_id = p_gacc_tran_id
         AND acct_entry_id = p_acct_entry_id
         AND gl_acct_id = p_gl_acct_id
         AND sl_cd = p_sl_cd
         AND generation_type = p_generation_type;

      BEGIN
         SELECT acct_entry_id
           INTO v_exists
           FROM giac_acct_entries
          WHERE gacc_tran_id = p_gacc_tran_id
            AND acct_entry_id = p_acct_entry_id
            AND gl_acct_id = p_gl_acct_id
            AND NVL (sl_cd, 0) = NVL (p_sl_cd, 0)
            AND generation_type = p_generation_type;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exists := 0;
      END;

      IF NVL (v_exists, 0) = 0
      THEN
         INSERT INTO giac_acct_entries
                     (gacc_tran_id, gacc_gfun_fund_cd,
                      gacc_gibr_branch_cd, acct_entry_id, gl_acct_id,
                      gl_acct_category, gl_control_acct,
                      gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                      gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                      gl_sub_acct_7, sl_cd, debit_amt, credit_amt,
                      generation_type, sl_type_cd, sl_source_cd,
                      remarks, sap_text, acct_ref_no, acct_tran_type,   --acct_ref_no, acct_tran_type, Gzelle 11102015 KB#132 AP/AR ENH
                      user_id,
                      last_update
                     )
              VALUES (p_gacc_tran_id, p_gacc_gfun_fund_cd,
                      p_gacc_gibr_branch_cd, v_acct_entry_id, p_gl_acct_id,
                      p_gl_acct_category, p_gl_control_acct,
                      p_gl_sub_acct_1, p_gl_sub_acct_2, p_gl_sub_acct_3,
                      p_gl_sub_acct_4, p_gl_sub_acct_5, p_gl_sub_acct_6,
                      p_gl_sub_acct_7, p_sl_cd, p_debit_amt, p_credit_amt,
                      p_generation_type, p_sl_type_cd, p_sl_source_cd,
                      p_remarks, p_sap_text, p_acct_ref_no, p_acct_tran_type,  --acct_ref_no, acct_tran_type, Gzelle 11102015 KB#132 AP/AR ENH
                      NVL (p_user_id, NVL (giis_users_pkg.app_user, USER)),
                      SYSDATE
                     );
      ELSE
         UPDATE giac_acct_entries
            SET remarks = p_remarks,
                sap_text = p_sap_text, --added by c.santos 06.14.2012 - In CS, SAP text is updatable
                debit_amt = p_debit_amt,
                credit_amt = p_credit_amt,
                sl_cd = p_sl_cd
          WHERE gacc_tran_id = p_gacc_tran_id
            AND acct_entry_id = p_acct_entry_id
            AND gl_acct_id = p_gl_acct_id
            AND generation_type = p_generation_type;
      END IF;
   END save_acct_entry;

   PROCEDURE bpc_aeg_create_acct_entries_y (
      aeg_sl_cd              giac_acct_entries.sl_cd%TYPE,
      aeg_module_id          giac_module_entries.module_id%TYPE,
      aeg_item_no            giac_module_entries.item_no%TYPE,
      --aeg_iss_cd             GIAC_DIRECT_PREM_COLLNS.b140_iss_cd%TYPE,
      --aeg_bill_no            GIAC_DIRECT_PREM_COLLNS.b140_prem_seq_no%TYPE,
      --aeg_line_cd            GIIS_LINE.line_cd%TYPE,
      --aeg_type_cd            GIPI_POLBASIC.type_cd%TYPE,
      aeg_acct_amt           giac_direct_prem_collns.collection_amt%TYPE,
      aeg_gen_type           giac_acct_entries.generation_type%TYPE,
      v_message        OUT   VARCHAR2,
      p_gacc_tran_id         NUMBER,
      p_branch_cd            VARCHAR2,
      p_fund_cd              VARCHAR2
   )
   IS
      ws_gl_acct_category     giac_acct_entries.gl_acct_category%TYPE;
      ws_gl_control_acct      giac_acct_entries.gl_control_acct%TYPE;
      ws_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      ws_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      ws_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      ws_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      ws_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      ws_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_pol_type_tag         giac_module_entries.pol_type_tag%TYPE;
      ws_intm_type_level      giac_module_entries.intm_type_level%TYPE;
      ws_old_new_acct_level   giac_module_entries.old_new_acct_level%TYPE;
      ws_line_dep_level       giac_module_entries.line_dependency_level%TYPE;
      ws_dr_cr_tag            giac_module_entries.dr_cr_tag%TYPE;
      ws_acct_intm_cd         giis_intm_type.acct_intm_cd%TYPE;
      ws_line_cd              giis_line.line_cd%TYPE;
      --  ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
      ws_old_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_new_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      pt_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      pt_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      pt_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      pt_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      pt_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_debit_amt            giac_acct_entries.debit_amt%TYPE;
      ws_credit_amt           giac_acct_entries.credit_amt%TYPE;
      ws_gl_acct_id           giac_acct_entries.gl_acct_id%TYPE;
      ws_sl_type_cd           giac_acct_entries.sl_type_cd%TYPE;
   --Vincent 05182006
   BEGIN
      --msg_alert('AEG CREATE ACCT ENTRIES...','I',FALSE);

      /**************************************************************************
      *                                                                         *
      * Populate the GL Account Code used in every transactions.                *
      *                                                                         *
      **************************************************************************/
      BEGIN
         SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
                gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                pol_type_tag, NVL (intm_type_level, 0),
                NVL (old_new_acct_level, 0), dr_cr_tag,
                NVL (line_dependency_level, 0), sl_type_cd  --Vincent 05182006
           INTO ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                ws_gl_sub_acct_2, ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                ws_gl_sub_acct_5, ws_gl_sub_acct_6, ws_gl_sub_acct_7,
                ws_pol_type_tag, ws_intm_type_level,
                ws_old_new_acct_level, ws_dr_cr_tag,
                ws_line_dep_level, ws_sl_type_cd            --Vincent 05182006
           FROM giac_module_entries
          WHERE module_id = aeg_module_id AND item_no = aeg_item_no;
      --FOR UPDATE of gl_sub_acct_1;--Vincent 01302007: comment out, temporary @FGIC user locks
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_message := 'No data found in giac_module_entries.';
      END;

      /**************************************************************************
      *                                                                         *
      * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
      *                                                                         *
      **************************************************************************/
      aeg_check_chart_of_accts (ws_gl_acct_category,
                                ws_gl_control_acct,
                                ws_gl_sub_acct_1,
                                ws_gl_sub_acct_2,
                                ws_gl_sub_acct_3,
                                ws_gl_sub_acct_4,
                                ws_gl_sub_acct_5,
                                ws_gl_sub_acct_6,
                                ws_gl_sub_acct_7,
                                ws_gl_acct_id,
                                --aeg_iss_cd        , aeg_bill_no,
                                v_message
                               );

      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/
      IF ws_dr_cr_tag = 'D'
      THEN
         IF aeg_acct_amt > 0
         THEN
            ws_debit_amt := ABS (aeg_acct_amt);
            ws_credit_amt := 0;
         ELSE
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_acct_amt);
         END IF;
      ELSE
         IF aeg_acct_amt > 0
         THEN
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_acct_amt);
         ELSE
            ws_debit_amt := ABS (aeg_acct_amt);
            ws_credit_amt := 0;
         END IF;
      END IF;

      /****************************************************************************
      *                                                                           *
      * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      *                                                                           *
      ****************************************************************************/
      insert_update_acct_entries (ws_gl_acct_category,
                                  ws_gl_control_acct,
                                  ws_gl_sub_acct_1,
                                  ws_gl_sub_acct_2,
                                  ws_gl_sub_acct_3,
                                  ws_gl_sub_acct_4,
                                  ws_gl_sub_acct_5,
                                  ws_gl_sub_acct_6,
                                  ws_gl_sub_acct_7,
                                  aeg_sl_cd,
                                  ws_sl_type_cd,
                                  aeg_gen_type,
                                  --Vincent 05182006: added ws_sl_type_cd
                                  ws_gl_acct_id,
                                  ws_debit_amt,
                                  ws_credit_amt,
                                  p_branch_cd,
                                  p_fund_cd,
                                  p_gacc_tran_id,
                                  NVL (giis_users_pkg.app_user, USER)
                                 );
   END;

--------------

   /*
   **  Created by      : Veronica V. Raymundo
   **  Date Created  :   December 22, 2010
   **  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
   **  Description   :  Procedure updates either debit_amt or credit_amt depending on
   **                   the value of the collection amount
   */
   PROCEDURE update_acct_entries (
      p_gacc_branch_cd       giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd         giac_acctrans.gfun_fund_cd%TYPE,
      p_gacc_tran_id         giac_acctrans.tran_id%TYPE,
      p_collection_amt       giac_oth_fund_off_collns.collection_amt%TYPE,
      uae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      uae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      uae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      uae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      uae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      uae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      uae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      uae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      uae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE
   )
   IS
   BEGIN
      IF p_collection_amt < 0
      THEN
         UPDATE giac_acct_entries
            SET debit_amt = debit_amt + ABS (p_collection_amt)
          WHERE gacc_gibr_branch_cd = p_gacc_branch_cd
            AND gacc_gfun_fund_cd = p_gacc_fund_cd
            AND gacc_tran_id = p_gacc_tran_id
            AND gl_acct_category = uae_gl_acct_category
            AND gl_control_acct = uae_gl_control_acct
            AND gl_sub_acct_1 = uae_gl_sub_acct_1
            AND gl_sub_acct_2 = uae_gl_sub_acct_2
            AND gl_sub_acct_3 = uae_gl_sub_acct_3
            AND gl_sub_acct_4 = uae_gl_sub_acct_4
            AND gl_sub_acct_5 = uae_gl_sub_acct_5
            AND gl_sub_acct_6 = uae_gl_sub_acct_6
            AND gl_sub_acct_7 = uae_gl_sub_acct_7;
      ELSIF p_collection_amt > 0
      THEN
         UPDATE giac_acct_entries
            SET credit_amt = credit_amt + ABS (p_collection_amt)
          WHERE gacc_gibr_branch_cd = p_gacc_branch_cd
            AND gacc_gfun_fund_cd = p_gacc_fund_cd
            AND gacc_tran_id = p_gacc_tran_id
            AND gl_acct_category = uae_gl_acct_category
            AND gl_control_acct = uae_gl_control_acct
            AND gl_sub_acct_1 = uae_gl_sub_acct_1
            AND gl_sub_acct_2 = uae_gl_sub_acct_2
            AND gl_sub_acct_3 = uae_gl_sub_acct_3
            AND gl_sub_acct_4 = uae_gl_sub_acct_4
            AND gl_sub_acct_5 = uae_gl_sub_acct_5
            AND gl_sub_acct_6 = uae_gl_sub_acct_6
            AND gl_sub_acct_7 = uae_gl_sub_acct_7;
      END IF;
   END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 22, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  This procedure determines whether the records will be updated or inserted
**                   in GIAC_ACCT_ENTRIES.
*/
   PROCEDURE aeg_ins_upd_acct_entr_giacs012 (
      p_gacc_gibr_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gacc_gfun_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_tran_id          giac_acct_entries.gacc_tran_id%TYPE,
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE
   )
   IS
      iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
   BEGIN
      BEGIN
         SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
           INTO iuae_acct_entry_id
           FROM giac_acct_entries
          WHERE gacc_gibr_branch_cd = p_gacc_gibr_branch_cd
            AND gacc_gfun_fund_cd = p_gacc_gfun_fund_cd
            AND gacc_tran_id = p_gacc_tran_id
            AND gl_acct_category = iuae_gl_acct_category
            AND gl_control_acct = iuae_gl_control_acct
            AND gl_sub_acct_1 = iuae_gl_sub_acct_1
            AND gl_sub_acct_2 = iuae_gl_sub_acct_2
            AND gl_sub_acct_3 = iuae_gl_sub_acct_3
            AND gl_sub_acct_4 = iuae_gl_sub_acct_4
            AND gl_sub_acct_5 = iuae_gl_sub_acct_5
            AND gl_sub_acct_6 = iuae_gl_sub_acct_6
            AND gl_sub_acct_7 = iuae_gl_sub_acct_7;

         IF NVL (iuae_acct_entry_id, 0) = 0
         THEN
            iuae_acct_entry_id := NVL (iuae_acct_entry_id, 0) + 1;

            INSERT INTO giac_acct_entries
                        (gacc_tran_id, gacc_gfun_fund_cd,
                         gacc_gibr_branch_cd, acct_entry_id,
                         gl_acct_id, gl_acct_category,
                         gl_control_acct, gl_sub_acct_1,
                         gl_sub_acct_2, gl_sub_acct_3,
                         gl_sub_acct_4, gl_sub_acct_5,
                         gl_sub_acct_6, gl_sub_acct_7, sl_cd,
                         debit_amt, credit_amt,
                         generation_type,
                         user_id, last_update
                        )
                 VALUES (p_gacc_tran_id, p_gacc_gfun_fund_cd,
                         p_gacc_gibr_branch_cd, iuae_acct_entry_id,
                         iuae_gl_acct_id, iuae_gl_acct_category,
                         iuae_gl_control_acct, iuae_gl_sub_acct_1,
                         iuae_gl_sub_acct_2, iuae_gl_sub_acct_3,
                         iuae_gl_sub_acct_4, iuae_gl_sub_acct_5,
                         iuae_gl_sub_acct_6, iuae_gl_sub_acct_7, iuae_sl_cd,
                         iuae_debit_amt, iuae_credit_amt,
                         iuae_generation_type,
                         NVL (giis_users_pkg.app_user, USER), SYSDATE
                        );
         ELSE
            UPDATE giac_acct_entries
               SET debit_amt = debit_amt + iuae_debit_amt,
                   credit_amt = credit_amt + iuae_credit_amt
             WHERE generation_type = iuae_generation_type
               AND gl_acct_id = iuae_gl_acct_id
               AND gacc_gibr_branch_cd = p_gacc_gibr_branch_cd
               AND gacc_gfun_fund_cd = p_gacc_gfun_fund_cd
               AND gacc_tran_id = p_gacc_tran_id;
         END IF;
      END;
   END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 22, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  This procedure handles the creation of accounting entries per transaction.
**
*/
   PROCEDURE aeg_create_acct_entr_giacs012 (
      p_gacc_gibr_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gacc_gfun_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_tran_id                giac_acct_entries.gacc_tran_id%TYPE,
      aeg_module_id                 giac_module_entries.module_id%TYPE,
      aeg_item_no                   giac_module_entries.item_no%TYPE,
      aeg_acct_amt                  giac_direct_prem_collns.collection_amt%TYPE,
      aeg_gen_type                  giac_acct_entries.generation_type%TYPE,
      p_message               OUT   VARCHAR2
   )
   IS
      ws_gl_acct_category     giac_acct_entries.gl_acct_category%TYPE;
      ws_gl_control_acct      giac_acct_entries.gl_control_acct%TYPE;
      ws_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      ws_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      ws_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      ws_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      ws_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      ws_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_pol_type_tag         giac_module_entries.pol_type_tag%TYPE;
      ws_intm_type_level      giac_module_entries.intm_type_level%TYPE;
      ws_old_new_acct_level   giac_module_entries.old_new_acct_level%TYPE;
      ws_line_dep_level       giac_module_entries.line_dependency_level%TYPE;
      ws_dr_cr_tag            giac_module_entries.dr_cr_tag%TYPE;
      ws_acct_intm_cd         giis_intm_type.acct_intm_cd%TYPE;
      ws_line_cd              giis_line.line_cd%TYPE;
      ws_iss_cd               gipi_polbasic.iss_cd%TYPE;
      ws_old_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_new_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      pt_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      pt_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      pt_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      pt_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      pt_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_debit_amt            giac_acct_entries.debit_amt%TYPE;
      ws_credit_amt           giac_acct_entries.credit_amt%TYPE;
      ws_gl_acct_id           giac_acct_entries.gl_acct_id%TYPE;
      ws_sl_cd                giac_acct_entries.sl_cd%TYPE;
   BEGIN
      /**************************************************************************
      *                                                                         *
      * Populate the GL Account Code used in every transactions.                *
      *                                                                         *
      **************************************************************************/
      BEGIN
         p_message := 'SUCCESS';

         SELECT        gl_acct_category, gl_control_acct,
                       gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                       gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                       gl_sub_acct_7, pol_type_tag,
                       intm_type_level, old_new_acct_level,
                       dr_cr_tag, line_dependency_level
                  INTO ws_gl_acct_category, ws_gl_control_acct,
                       ws_gl_sub_acct_1, ws_gl_sub_acct_2, ws_gl_sub_acct_3,
                       ws_gl_sub_acct_4, ws_gl_sub_acct_5, ws_gl_sub_acct_6,
                       ws_gl_sub_acct_7, ws_pol_type_tag,
                       ws_intm_type_level, ws_old_new_acct_level,
                       ws_dr_cr_tag, ws_line_dep_level
                  FROM giac_module_entries
                 WHERE module_id = aeg_module_id AND item_no = 1
         FOR UPDATE OF gl_sub_acct_1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message := 'No data found in giac_module_entries.';
      END;

      /**************************************************************************
      *                                                                         *
      * Validate the  ACCT_BRANCH_CD value which indicates the segment of the   *
      * GL account code that holds the branch code.                             *
      *                                                                         *
      **************************************************************************/
      SELECT acct_branch_cd
        INTO ws_sl_cd
        FROM giac_branches
       WHERE gfun_fund_cd = p_gacc_gfun_fund_cd
         AND branch_cd = p_gacc_gibr_branch_cd;

      /**************************************************************************
      *                                                                         *
      * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
      *                                                                         *
      **************************************************************************/
      giac_acct_entries_pkg.aeg_check_chart_of_accts (ws_gl_acct_category,
                                                      ws_gl_control_acct,
                                                      ws_gl_sub_acct_1,
                                                      ws_gl_sub_acct_2,
                                                      ws_gl_sub_acct_3,
                                                      ws_gl_sub_acct_4,
                                                      ws_gl_sub_acct_5,
                                                      ws_gl_sub_acct_6,
                                                      ws_gl_sub_acct_7,
                                                      ws_gl_acct_id,
                                                      p_message
                                                     );

      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/
      IF ws_dr_cr_tag = 'D'
      THEN
         IF aeg_acct_amt > 0
         THEN
            ws_debit_amt := ABS (aeg_acct_amt);
            ws_credit_amt := 0;
         ELSE
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_acct_amt);
         END IF;
      ELSE
         IF aeg_acct_amt > 0
         THEN
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_acct_amt);
         ELSE
            ws_debit_amt := ABS (aeg_acct_amt);
            ws_credit_amt := 0;
         END IF;
      END IF;

      /****************************************************************************
      *                                                                           *
      * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      *                                                                           *
      ****************************************************************************/
      giac_acct_entries_pkg.aeg_ins_upd_acct_entr_giacs012
                                                       (p_gacc_gibr_branch_cd,
                                                        p_gacc_gfun_fund_cd,
                                                        p_gacc_tran_id,
                                                        ws_gl_acct_category,
                                                        ws_gl_control_acct,
                                                        ws_gl_sub_acct_1,
                                                        ws_gl_sub_acct_2,
                                                        ws_gl_sub_acct_3,
                                                        ws_gl_sub_acct_4,
                                                        ws_gl_sub_acct_5,
                                                        ws_gl_sub_acct_6,
                                                        ws_gl_sub_acct_7,
                                                        ws_sl_cd,
                                                        aeg_gen_type,
                                                        ws_gl_acct_id,
                                                        ws_debit_amt,
                                                        ws_credit_amt
                                                       );
   END;

/*
**  Created by      : Veronica V. Raymundo
**  Date Created  :   December 22, 2010
**  Reference By  :  (GIACS012- OTHER TRANS (Collections for Other Offices))
**  Description   :  This procedure executes procedure AEG_PARAMETERS on GIACS012
**
*/
   PROCEDURE aeg_parameters_giacs012 (
      p_gacc_gibr_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gacc_gfun_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_tran_id                giac_acct_entries.gacc_tran_id%TYPE,
      p_collection_amt              giac_oth_fund_off_collns.collection_amt%TYPE,
      p_item_no                     giac_module_entries.item_no%TYPE,
      p_module_name                 giac_modules.module_name%TYPE,
      p_message               OUT   VARCHAR2
   )
   IS
      v_module_id    giac_modules.module_id%TYPE;
      v_gen_type     giac_modules.generation_type%TYPE;
      v_credit_amt   giac_acct_entries.credit_amt%TYPE;
      v_debit_amt    giac_acct_entries.debit_amt%TYPE;
      v_dummy        VARCHAR2 (1);
   BEGIN
      p_message := 'SUCCESS';

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

      /*
      ** Call the deletion of accounting entry procedure.
      */

      --GIAC_ACCT_ENTRIES_PKG.aeg_delete_acct_entries (p_gacc_tran_id, v_gen_type);

      /*
      ** Call the accounting entry generation procedure.
      */
      BEGIN
         FOR gl_rec IN (SELECT gl_acct_category, gl_control_acct,
                               gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                               gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                               gl_sub_acct_7, pol_type_tag, intm_type_level,
                               old_new_acct_level, dr_cr_tag,
                               line_dependency_level
                          FROM giac_module_entries
                         WHERE module_id = v_module_id AND item_no = 1)
         LOOP
            BEGIN
               SELECT 'x', credit_amt, debit_amt
                 INTO v_dummy, v_credit_amt, v_debit_amt
                 FROM giac_acct_entries
                WHERE gacc_gibr_branch_cd = p_gacc_gibr_branch_cd
                  AND gacc_gfun_fund_cd = p_gacc_gfun_fund_cd
                  AND gacc_tran_id = p_gacc_tran_id
                  AND gl_acct_category = gl_rec.gl_acct_category
                  AND gl_control_acct = gl_rec.gl_control_acct
                  AND gl_sub_acct_1 = gl_rec.gl_sub_acct_1
                  AND gl_sub_acct_2 = gl_rec.gl_sub_acct_2
                  AND gl_sub_acct_3 = gl_rec.gl_sub_acct_3
                  AND gl_sub_acct_4 = gl_rec.gl_sub_acct_4
                  AND gl_sub_acct_5 = gl_rec.gl_sub_acct_5
                  AND gl_sub_acct_6 = gl_rec.gl_sub_acct_6
                  AND gl_sub_acct_7 = gl_rec.gl_sub_acct_7;

               giac_acct_entries_pkg.update_acct_entries
                                                     (p_gacc_gibr_branch_cd,
                                                      p_gacc_gfun_fund_cd,
                                                      p_gacc_tran_id,
                                                      p_collection_amt,
                                                      gl_rec.gl_acct_category,
                                                      gl_rec.gl_control_acct,
                                                      gl_rec.gl_sub_acct_1,
                                                      gl_rec.gl_sub_acct_2,
                                                      gl_rec.gl_sub_acct_3,
                                                      gl_rec.gl_sub_acct_4,
                                                      gl_rec.gl_sub_acct_5,
                                                      gl_rec.gl_sub_acct_6,
                                                      gl_rec.gl_sub_acct_7
                                                     );
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  giac_acct_entries_pkg.aeg_create_acct_entr_giacs012
                                                      (p_gacc_gibr_branch_cd,
                                                       p_gacc_gfun_fund_cd,
                                                       p_gacc_tran_id,
                                                       v_module_id,
                                                       p_item_no,
                                                       p_collection_amt,
                                                       v_gen_type,
                                                       p_message
                                                      );
            END;
         END LOOP;
      END;
   END;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS001
**
*/
   PROCEDURE aeg_delete_entries_rev (
      p_acc_tran_id   giac_acctrans.tran_id%TYPE,
      p_gen_type      giac_modules.generation_type%TYPE
   )
   IS
      dummy   VARCHAR2 (1);

      CURSOR ae
      IS
         SELECT '1'
           FROM giac_acct_entries
          WHERE gacc_tran_id = p_acc_tran_id AND generation_type = p_gen_type;
   BEGIN
      OPEN ae;

      FETCH ae
       INTO dummy;

      IF dummy IS NOT NULL
      THEN
         DELETE FROM giac_acct_entries
               WHERE gacc_tran_id = p_acc_tran_id
                 AND generation_type = p_gen_type;
      END IF;
   END aeg_delete_entries_rev;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS001
**
*/
   PROCEDURE aeg_insert_update_entries_rev (
      iuae_gl_acct_category    giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct     giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1       giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2       giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3       giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4       giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5       giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6       giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7       giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_type_cd          giac_acct_entries.sl_type_cd%TYPE,
      iuae_sl_source_cd        giac_acct_entries.sl_source_cd%TYPE,
      iuae_sl_cd               giac_acct_entries.sl_cd%TYPE,
      iuae_generation_type     giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id          giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt           giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt          giac_acct_entries.credit_amt%TYPE,
      iuae_gibr_gfun_fund_cd   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      iuae_gibr_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
      iuae_acc_tran_id         giac_acctrans.tran_id%TYPE
   )
   IS
      iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
   BEGIN
      SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gl_sub_acct_1 = iuae_gl_sub_acct_1
         AND gl_sub_acct_2 = iuae_gl_sub_acct_2
         AND gl_sub_acct_3 = iuae_gl_sub_acct_3
         AND gl_sub_acct_4 = iuae_gl_sub_acct_4
         AND gl_sub_acct_5 = iuae_gl_sub_acct_5
         AND gl_sub_acct_6 = iuae_gl_sub_acct_6
         AND gl_sub_acct_7 = iuae_gl_sub_acct_7
         AND NVL (sl_cd, 1) = NVL (iuae_sl_cd, 1)
         AND generation_type = iuae_generation_type
         AND NVL (gl_acct_id, gl_acct_id) = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = iuae_gibr_branch_cd
         AND gacc_gfun_fund_cd = iuae_gibr_gfun_fund_cd
         AND gacc_tran_id = iuae_acc_tran_id;

      IF NVL (iuae_acct_entry_id, 0) = 0
      THEN
         iuae_acct_entry_id := NVL (iuae_acct_entry_id, 0) + 1;

         INSERT INTO giac_acct_entries
                     (gacc_tran_id, gacc_gfun_fund_cd,
                      gacc_gibr_branch_cd, acct_entry_id,
                      gl_acct_id, gl_acct_category,
                      gl_control_acct, gl_sub_acct_1,
                      gl_sub_acct_2, gl_sub_acct_3,
                      gl_sub_acct_4, gl_sub_acct_5,
                      gl_sub_acct_6, gl_sub_acct_7,
                      sl_type_cd, sl_source_cd, sl_cd, debit_amt,
                      credit_amt, generation_type,
                      user_id, last_update
                     )
              VALUES (iuae_acc_tran_id, iuae_gibr_gfun_fund_cd,
                      iuae_gibr_branch_cd, iuae_acct_entry_id,
                      iuae_gl_acct_id, iuae_gl_acct_category,
                      iuae_gl_control_acct, iuae_gl_sub_acct_1,
                      iuae_gl_sub_acct_2, iuae_gl_sub_acct_3,
                      iuae_gl_sub_acct_4, iuae_gl_sub_acct_5,
                      iuae_gl_sub_acct_6, iuae_gl_sub_acct_7,
                      iuae_sl_type_cd, '1', iuae_sl_cd, iuae_debit_amt,
                      iuae_credit_amt, iuae_generation_type,
                      NVL (giis_users_pkg.app_user, USER), SYSDATE
                     );
      ELSE
         UPDATE giac_acct_entries
            SET debit_amt = iuae_debit_amt + debit_amt,
                credit_amt = iuae_credit_amt + credit_amt,
                user_id = NVL(giis_users_pkg.app_user, user_id),
                last_update = SYSDATE
          WHERE gl_sub_acct_1 = iuae_gl_sub_acct_1
            AND gl_sub_acct_2 = iuae_gl_sub_acct_2
            AND gl_sub_acct_3 = iuae_gl_sub_acct_3
            AND gl_sub_acct_4 = iuae_gl_sub_acct_4
            AND gl_sub_acct_5 = iuae_gl_sub_acct_5
            AND gl_sub_acct_6 = iuae_gl_sub_acct_6
            AND gl_sub_acct_7 = iuae_gl_sub_acct_7
            AND NVL (sl_cd, 1) = NVL (iuae_sl_cd, 1)
            AND generation_type = iuae_generation_type
            AND NVL (gl_acct_id, gl_acct_id) = iuae_gl_acct_id
            AND gacc_gibr_branch_cd = iuae_gibr_branch_cd
            AND gacc_gfun_fund_cd = iuae_gibr_gfun_fund_cd
            AND gacc_tran_id = iuae_acc_tran_id;
      END IF;
   END aeg_insert_update_entries_rev;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS001
**
*/
   PROCEDURE aeg_parameters_rev (
      p_aeg_tran_id               giac_acctrans.tran_id%TYPE,
      p_aeg_module_nm             giac_modules.module_name%TYPE,
      p_acc_tran_id               giac_acctrans.tran_id%TYPE,
      p_gibr_gfun_fund_cd         giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
      p_message             OUT   VARCHAR2
   )
   IS
      CURSOR colln_cur
      IS
         SELECT   a.assd_no, b.line_cd, SUM (premium_amt + tax_amt) coll_amt
             FROM giac_advanced_payt a, gipi_polbasic b
            WHERE gacc_tran_id = p_aeg_tran_id
              AND a.policy_id = b.policy_id
              AND a.acct_ent_date IS NOT NULL
         GROUP BY a.assd_no, b.line_cd;

      v_module_id   giac_modules.module_id%TYPE;
      v_gen_type    giac_modules.generation_type%TYPE;
   BEGIN
      BEGIN
         SELECT module_id, generation_type
           INTO v_module_id, v_gen_type
           FROM giac_modules
          WHERE module_name = 'GIACB005';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message := 'No data found in GIAC MODULES.';
      END;

      giac_acct_entries_pkg.aeg_delete_entries_rev (p_acc_tran_id, v_gen_type);

      FOR colln_rec IN colln_cur
      LOOP
         giac_acct_entries_pkg.create_rev_entries (colln_rec.assd_no,
                                                   colln_rec.coll_amt,
                                                   colln_rec.line_cd,
                                                   NULL,
                                                   p_aeg_tran_id,
                                                   p_gibr_gfun_fund_cd,
                                                   p_gibr_branch_cd,
                                                   p_acc_tran_id,
                                                   p_message
                                                  );
      END LOOP;
   END aeg_parameters_rev;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS001
**
*/
   PROCEDURE create_rev_entries (
      p_assd_no             IN       gipi_polbasic.assd_no%TYPE,
      p_coll_amt            IN       giac_comm_payts.comm_amt%TYPE,
      p_line_cd             IN       giis_line.line_cd%TYPE,
      p_sl_cd                        giac_acct_entries.sl_cd%TYPE,
      p_gacc_tran_id        IN       giac_order_of_payts.gacc_tran_id%TYPE,
      p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
      p_acc_tran_id                  giac_acctrans.tran_id%TYPE,
      p_message             OUT      VARCHAR2
   )
   IS
      x_intm_no                 giis_intermediary.intm_no%TYPE;
      w_sl_cd                   giac_acct_entries.sl_cd%TYPE;
      y_sl_cd                   giac_acct_entries.sl_cd%TYPE;
      z_sl_cd                   giac_acct_entries.sl_cd%TYPE;
      v_gl_acct_category        giac_acct_entries.gl_acct_category%TYPE;
      v_gl_control_acct         giac_acct_entries.gl_control_acct%TYPE;
      v_gl_sub_acct_1           giac_acct_entries.gl_sub_acct_1%TYPE;
      v_gl_sub_acct_2           giac_acct_entries.gl_sub_acct_2%TYPE;
      v_gl_sub_acct_3           giac_acct_entries.gl_sub_acct_3%TYPE;
      v_gl_sub_acct_4           giac_acct_entries.gl_sub_acct_4%TYPE;
      v_gl_sub_acct_5           giac_acct_entries.gl_sub_acct_5%TYPE;
      v_gl_sub_acct_6           giac_acct_entries.gl_sub_acct_6%TYPE;
      v_gl_sub_acct_7           giac_acct_entries.gl_sub_acct_7%TYPE;
      v_intm_type_level         giac_module_entries.intm_type_level%TYPE;
      v_line_dependency_level   giac_module_entries.line_dependency_level%TYPE;
      v_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE;
      v_debit_amt               giac_acct_entries.debit_amt%TYPE;
      v_credit_amt              giac_acct_entries.credit_amt%TYPE;
      v_acct_entry_id           giac_acct_entries.acct_entry_id%TYPE;
      v_gen_type                giac_modules.generation_type%TYPE;
      v_gl_acct_id              giac_chart_of_accts.gl_acct_id%TYPE;
      v_sl_type_cd              giac_module_entries.sl_type_cd%TYPE;
      v_sl_type_cd2             giac_module_entries.sl_type_cd%TYPE;
      v_sl_type_cd3             giac_module_entries.sl_type_cd%TYPE;
      ws_line_cd                giac_acct_entries.gl_sub_acct_6%TYPE;
      v_gl_intm_no              giac_comm_payts.intm_no%TYPE;
      v_gl_assd_no              gipi_polbasic.assd_no%TYPE;
      v_gl_acct_line_cd         giis_line.acct_line_cd%TYPE;
      ws_acct_intm_cd           giis_intm_type.acct_intm_cd%TYPE;
   BEGIN
      BEGIN
         SELECT a.gl_acct_category, a.gl_control_acct,
                NVL (a.gl_sub_acct_1, 0), NVL (a.gl_sub_acct_2, 0),
                NVL (a.gl_sub_acct_3, 0), NVL (a.gl_sub_acct_4, 0),
                NVL (a.gl_sub_acct_5, 0), NVL (a.gl_sub_acct_6, 0),
                NVL (a.gl_sub_acct_7, 0), NVL (a.intm_type_level, 0),
                a.dr_cr_tag, b.generation_type, a.sl_type_cd,
                a.line_dependency_level
           INTO v_gl_acct_category, v_gl_control_acct,
                v_gl_sub_acct_1, v_gl_sub_acct_2,
                v_gl_sub_acct_3, v_gl_sub_acct_4,
                v_gl_sub_acct_5, v_gl_sub_acct_6,
                v_gl_sub_acct_7, v_intm_type_level,
                v_dr_cr_tag, v_gen_type, v_sl_type_cd,
                v_line_dependency_level
           FROM giac_module_entries a, giac_modules b
          WHERE b.module_name = 'GIACB005'
            AND a.item_no = 1
            AND b.module_id = a.module_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message :=
               'CREATE_REV_ENTRIES - No data found in GIAC_MODULE_ENTRIES.  Item No 1.';
      END;

      giac_acct_entries_pkg.aeg_check_chart_of_accts (v_gl_acct_category,
                                                      v_gl_control_acct,
                                                      v_gl_sub_acct_1,
                                                      v_gl_sub_acct_2,
                                                      v_gl_sub_acct_3,
                                                      v_gl_sub_acct_4,
                                                      v_gl_sub_acct_5,
                                                      v_gl_sub_acct_6,
                                                      v_gl_sub_acct_7,
                                                      v_gl_acct_id,
                                                      p_message
                                                     );

      IF p_coll_amt > 0
      THEN
         IF v_dr_cr_tag = 'D'
         THEN
            v_debit_amt := 0;
            v_credit_amt := p_coll_amt;
         ELSE
            v_debit_amt := p_coll_amt;
            v_credit_amt := 0;
         END IF;
      ELSIF p_coll_amt < 0
      THEN
         IF v_dr_cr_tag = 'D'
         THEN
            v_debit_amt := p_coll_amt * -1;
            v_credit_amt := 0;
         ELSE
            v_debit_amt := 0;
            v_credit_amt := p_coll_amt * -1;
         END IF;
      END IF;

      giac_acct_entries_pkg.insert_update_acct_entries
                                                (v_gl_acct_category,
                                                 v_gl_control_acct,
                                                 v_gl_sub_acct_1,
                                                 v_gl_sub_acct_2,
                                                 v_gl_sub_acct_3,
                                                 v_gl_sub_acct_4,
                                                 v_gl_sub_acct_5,
                                                 v_gl_sub_acct_6,
                                                 v_gl_sub_acct_7,
                                                 p_sl_cd,
                                                 v_sl_type_cd,
                                                 v_gen_type,
                                                 v_gl_acct_id,
                                                 v_debit_amt,
                                                 v_credit_amt,
                                                 p_gibr_branch_cd,
                                                 p_gibr_gfun_fund_cd,
                                                 p_gacc_tran_id,
                                                 NVL (giis_users_pkg.app_user,
                                                      USER
                                                     )
                                                );

      BEGIN
         BEGIN
            SELECT a.gl_acct_category, a.gl_control_acct,
                   NVL (a.gl_sub_acct_1, 0), NVL (a.gl_sub_acct_2, 0),
                   NVL (a.gl_sub_acct_3, 0), NVL (a.gl_sub_acct_4, 0),
                   NVL (a.gl_sub_acct_5, 0), NVL (a.gl_sub_acct_6, 0),
                   NVL (a.gl_sub_acct_7, 0), a.sl_type_cd,
                   NVL (a.line_dependency_level, 0), a.dr_cr_tag,
                   b.generation_type
              INTO v_gl_acct_category, v_gl_control_acct,
                   v_gl_sub_acct_1, v_gl_sub_acct_2,
                   v_gl_sub_acct_3, v_gl_sub_acct_4,
                   v_gl_sub_acct_5, v_gl_sub_acct_6,
                   v_gl_sub_acct_7, v_sl_type_cd,
                   v_line_dependency_level, v_dr_cr_tag,
                   v_gen_type
              FROM giac_module_entries a, giac_modules b
             WHERE b.module_name = 'GIACB005'
               AND a.item_no = 2
               AND b.module_id = a.module_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               p_message :=
                  'COMM PAYABLE PROC - No data found in GIAC_MODULE_ENTRIES.  Item No = 2.';
         END;

         IF v_line_dependency_level != 0
         THEN
            BEGIN
               SELECT acct_line_cd
                 INTO ws_line_cd
                 FROM giis_line
                WHERE line_cd = p_line_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  p_message := 'No data found in giis_line.';
            END;

            giac_acct_entries_pkg.aeg_check_level (v_line_dependency_level,
                                                   ws_line_cd,
                                                   v_gl_sub_acct_1,
                                                   v_gl_sub_acct_2,
                                                   v_gl_sub_acct_3,
                                                   v_gl_sub_acct_4,
                                                   v_gl_sub_acct_5,
                                                   v_gl_sub_acct_6,
                                                   v_gl_sub_acct_7
                                                  );
         END IF;

         giac_acct_entries_pkg.aeg_check_chart_of_accts (v_gl_acct_category,
                                                         v_gl_control_acct,
                                                         v_gl_sub_acct_1,
                                                         v_gl_sub_acct_2,
                                                         v_gl_sub_acct_3,
                                                         v_gl_sub_acct_4,
                                                         v_gl_sub_acct_5,
                                                         v_gl_sub_acct_6,
                                                         v_gl_sub_acct_7,
                                                         v_gl_acct_id,
                                                         p_message
                                                        );

         IF p_coll_amt > 0
         THEN
            IF v_dr_cr_tag = 'D'
            THEN
               v_debit_amt := 0;
               v_credit_amt := p_coll_amt;
            ELSE
               v_debit_amt := p_coll_amt;
               v_credit_amt := 0;
            END IF;
         ELSIF p_coll_amt < 0
         THEN
            IF v_dr_cr_tag = 'D'
            THEN
               v_debit_amt := p_coll_amt * -1;
               v_credit_amt := 0;
            ELSE
               v_debit_amt := 0;
               v_credit_amt := p_coll_amt * -1;
            END IF;
         END IF;

         giac_acct_entries_pkg.aeg_insert_update_entries_rev
                                                         (v_gl_acct_category,
                                                          v_gl_control_acct,
                                                          v_gl_sub_acct_1,
                                                          v_gl_sub_acct_2,
                                                          v_gl_sub_acct_3,
                                                          v_gl_sub_acct_4,
                                                          v_gl_sub_acct_5,
                                                          v_gl_sub_acct_6,
                                                          v_gl_sub_acct_7,
                                                          v_sl_type_cd,
                                                          '1',
                                                          p_assd_no,
                                                          v_gen_type,
                                                          v_gl_acct_id,
                                                          v_debit_amt,
                                                          v_credit_amt,
                                                          p_gibr_gfun_fund_cd,
                                                          p_gibr_branch_cd,
                                                          p_acc_tran_id
                                                         );
      END;
   END create_rev_entries;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS001
**
*/
   PROCEDURE force_close_acct_entries (
      p_gacc_tran_id              giac_order_of_payts.gacc_tran_id%TYPE,
      p_gibr_gfun_fund_cd         giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
      p_item_no                   giac_module_entries.item_no%TYPE,
      p_module_name               VARCHAR2,
      p_message             OUT   VARCHAR2
   )
   IS
      v_module_id          giac_modules.module_id%TYPE;
      v_generation_type    giac_modules.generation_type%TYPE;
      v_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE;
      v_gl_acct_category   giac_module_entries.gl_acct_category%TYPE;
      v_gl_control_acct    giac_module_entries.gl_control_acct%TYPE;
      v_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%TYPE;
      v_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%TYPE;
      v_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%TYPE;
      v_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%TYPE;
      v_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%TYPE;
      v_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%TYPE;
      v_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%TYPE;
      v_sl_type_cd         giac_module_entries.sl_type_cd%TYPE;
      v_balance            giac_acct_entries.debit_amt%TYPE;
      v_debit_amt          giac_acct_entries.debit_amt%TYPE;
      v_credit_amt         giac_acct_entries.credit_amt%TYPE;
      v_acct_entry_id      giac_acct_entries.acct_entry_id%TYPE;
   BEGIN
      FOR ID IN (SELECT module_id, generation_type
                   FROM giac_modules
                  WHERE UPPER (module_name) = p_module_name)
      LOOP
         v_module_id := ID.module_id;
         v_generation_type := ID.generation_type;
         EXIT;
      END LOOP;

      IF v_module_id IS NULL
      THEN
         p_message := 'Cancel OR: Module ID not found.';
      ELSE
         FOR mod_entr IN (SELECT gime.gl_acct_category, gime.gl_control_acct,
                                 gime.gl_sub_acct_1, gime.gl_sub_acct_2,
                                 gime.gl_sub_acct_3, gime.gl_sub_acct_4,
                                 gime.gl_sub_acct_5, gime.gl_sub_acct_6,
                                 gime.gl_sub_acct_7, gime.sl_type_cd,
                                 gcoa.gl_acct_id
                            FROM giac_chart_of_accts gcoa,
                                 giac_modules gimod,
                                 giac_module_entries gime
                           WHERE gcoa.gl_control_acct = gime.gl_control_acct
                             AND gcoa.gl_sub_acct_1 = gime.gl_sub_acct_1
                             AND gcoa.gl_sub_acct_2 = gime.gl_sub_acct_2
                             AND gcoa.gl_sub_acct_3 = gime.gl_sub_acct_3
                             AND gcoa.gl_sub_acct_4 = gime.gl_sub_acct_4
                             AND gcoa.gl_sub_acct_5 = gime.gl_sub_acct_5
                             AND gcoa.gl_sub_acct_6 = gime.gl_sub_acct_6
                             AND gcoa.gl_sub_acct_7 = gime.gl_sub_acct_7
                             AND gcoa.leaf_tag = 'Y'
                             AND gime.item_no = p_item_no
                             AND gimod.module_id = gime.module_id
                             AND gime.module_id = v_module_id)
         LOOP
            v_gl_acct_id := mod_entr.gl_acct_id;
            v_gl_acct_category := mod_entr.gl_acct_category;
            v_gl_control_acct := mod_entr.gl_control_acct;
            v_gl_sub_acct_1 := mod_entr.gl_sub_acct_1;
            v_gl_sub_acct_2 := mod_entr.gl_sub_acct_2;
            v_gl_sub_acct_3 := mod_entr.gl_sub_acct_3;
            v_gl_sub_acct_4 := mod_entr.gl_sub_acct_4;
            v_gl_sub_acct_5 := mod_entr.gl_sub_acct_5;
            v_gl_sub_acct_6 := mod_entr.gl_sub_acct_6;
            v_gl_sub_acct_7 := mod_entr.gl_sub_acct_7;
            EXIT;
         END LOOP;

         IF v_gl_acct_id IS NULL
         THEN
            p_message :=
                  'Cancel OR: Error locating GL acct in '
               || 'module_entries/chart_of_accts.';
         ELSE
            FOR dr_cr IN (SELECT NVL (SUM (debit_amt) - SUM (credit_amt),
                                      0
                                     ) bal
                            FROM giac_acct_entries
                           WHERE gacc_tran_id = p_gacc_tran_id)
            LOOP
               v_balance := dr_cr.bal;
               EXIT;
            END LOOP;

            IF v_balance > 0
            THEN
               v_credit_amt := ABS (v_balance);
               v_debit_amt := 0;
            ELSIF v_balance < 0
            THEN
               v_credit_amt := 0;
               v_debit_amt := ABS (v_balance);
            END IF;

            IF v_balance <> 0
            THEN
               FOR entr_id IN (SELECT NVL (MAX (acct_entry_id),
                                           0
                                          ) acct_entry_id
                                 FROM giac_acct_entries
                                WHERE gacc_gibr_branch_cd = p_gibr_branch_cd
                                  AND gacc_gfun_fund_cd = p_gibr_gfun_fund_cd
                                  AND gacc_tran_id = p_gacc_tran_id
                                  AND NVL (gl_acct_id, gl_acct_id) =
                                                                  v_gl_acct_id
                                  -- grace 02.01.2007 for optimization purpose
                                  AND generation_type = v_generation_type)
               LOOP
                  v_acct_entry_id := entr_id.acct_entry_id;
                  EXIT;
               END LOOP;

               IF NVL (v_acct_entry_id, 0) = 0
               THEN
                  v_acct_entry_id := NVL (v_acct_entry_id, 0) + 1;

                  INSERT INTO giac_acct_entries
                              (gacc_tran_id, gacc_gfun_fund_cd,
                               gacc_gibr_branch_cd, acct_entry_id,
                               gl_acct_id, gl_acct_category,
                               gl_control_acct, gl_sub_acct_1,
                               gl_sub_acct_2, gl_sub_acct_3,
                               gl_sub_acct_4, gl_sub_acct_5,
                               gl_sub_acct_6, gl_sub_acct_7, sl_cd,
                               debit_amt, credit_amt, generation_type,
                               user_id, last_update
                              )
                       VALUES (p_gacc_tran_id, p_gibr_gfun_fund_cd,
                               p_gibr_branch_cd, v_acct_entry_id,
                               v_gl_acct_id, v_gl_acct_category,
                               v_gl_control_acct, v_gl_sub_acct_1,
                               v_gl_sub_acct_2, v_gl_sub_acct_3,
                               v_gl_sub_acct_4, v_gl_sub_acct_5,
                               v_gl_sub_acct_6, v_gl_sub_acct_7, NULL,
                               v_debit_amt, v_credit_amt, v_generation_type,
                               NVL (giis_users_pkg.app_user, USER), SYSDATE
                              );
               ELSE
                  UPDATE giac_acct_entries
                     SET debit_amt = debit_amt + v_debit_amt,
                         credit_amt = credit_amt + v_credit_amt
                   WHERE generation_type = v_generation_type
                     AND NVL (gl_acct_id, gl_acct_id) = v_gl_acct_id
                     -- grace 02.01.2007 for optimization purpose
                     AND gacc_gibr_branch_cd = p_gibr_branch_cd
                     AND gacc_gfun_fund_cd = p_gibr_gfun_fund_cd
                     AND gacc_tran_id = p_gacc_tran_id;
               END IF;                                    -- acct_entry_id = 0
            ELSE
               NULL;
            END IF;                                          -- v_balance <> 0
         END IF;                                         -- gl_acct_id IS NULL
      END IF;                                             -- module_id IS NULL
   END force_close_acct_entries;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS001
**
*/
   PROCEDURE gen_reversing_acct_entries (
      p_gacc_tran_id        giac_order_of_payts.gacc_tran_id%TYPE,
      p_gibr_gfun_fund_cd   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd      giac_order_of_payts.gibr_branch_cd%TYPE,
      p_acc_tran_id         giac_acctrans.tran_id%TYPE
   )
   IS
      CURSOR tr_closed
      IS
         SELECT acct_entry_id, gl_acct_id, gl_acct_category, gl_control_acct,
                gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, sl_cd,
                debit_amt, credit_amt, generation_type, sl_type_cd
           FROM giac_acct_entries
          WHERE gacc_tran_id = p_gacc_tran_id;

      v_debit_amt       giac_acct_entries.debit_amt%TYPE;
      v_credit_amt      giac_acct_entries.credit_amt%TYPE;
      v_debit_amt2      giac_acct_entries.debit_amt%TYPE;
      v_credit_amt2     giac_acct_entries.credit_amt%TYPE;
      v_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
   BEGIN
      FOR tr_closed_rec IN tr_closed
      LOOP
         FOR entr_id IN (SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
                           FROM giac_acct_entries
                          WHERE gacc_gibr_branch_cd = p_gibr_branch_cd
                            AND gacc_gfun_fund_cd = p_gibr_gfun_fund_cd
                            AND gacc_tran_id = p_acc_tran_id
                            AND NVL (gl_acct_id, gl_acct_id) =
                                                      tr_closed_rec.gl_acct_id
                            -- grace 02.01.2007 for optimization purpose
                            AND NVL (sl_cd, 0) =
                                     NVL (tr_closed_rec.sl_cd, NVL (sl_cd, 0))
                            AND NVL (sl_type_cd, '-') =
                                   NVL (tr_closed_rec.sl_type_cd,
                                        NVL (sl_type_cd, '-')
                                       )
                            AND generation_type =
                                                 tr_closed_rec.generation_type)
         LOOP
            v_acct_entry_id := entr_id.acct_entry_id;
            EXIT;
         END LOOP;

         IF NVL (v_acct_entry_id, 0) = 0
         THEN
            v_acct_entry_id := NVL (v_acct_entry_id, 0) + 1;

            INSERT INTO giac_acct_entries
                        (gacc_tran_id, gacc_gfun_fund_cd,
                         gacc_gibr_branch_cd, gl_acct_id,
                         gl_acct_category,
                         gl_control_acct,
                         gl_sub_acct_1,
                         gl_sub_acct_2,
                         gl_sub_acct_3,
                         gl_sub_acct_4,
                         gl_sub_acct_5,
                         gl_sub_acct_6,
                         gl_sub_acct_7, sl_cd,
                         debit_amt, credit_amt,
                         generation_type,
                         user_id, last_update,
                         sl_type_cd
                        )
                 VALUES (p_acc_tran_id, p_gibr_gfun_fund_cd,
                         p_gibr_branch_cd, tr_closed_rec.gl_acct_id,
                         tr_closed_rec.gl_acct_category,
                         tr_closed_rec.gl_control_acct,
                         tr_closed_rec.gl_sub_acct_1,
                         tr_closed_rec.gl_sub_acct_2,
                         tr_closed_rec.gl_sub_acct_3,
                         tr_closed_rec.gl_sub_acct_4,
                         tr_closed_rec.gl_sub_acct_5,
                         tr_closed_rec.gl_sub_acct_6,
                         tr_closed_rec.gl_sub_acct_7, tr_closed_rec.sl_cd,
                         tr_closed_rec.credit_amt, tr_closed_rec.debit_amt,
                         tr_closed_rec.generation_type,
                         NVL (giis_users_pkg.app_user, USER), SYSDATE,
                         tr_closed_rec.sl_type_cd
                        );
         ELSE
            UPDATE giac_acct_entries
               SET debit_amt = debit_amt + tr_closed_rec.credit_amt,
                   credit_amt = credit_amt + tr_closed_rec.debit_amt,
                   user_id = NVL(giis_users_pkg.app_user, user_id),
                   last_update = SYSDATE
             WHERE gacc_gfun_fund_cd = p_gibr_gfun_fund_cd
               AND gacc_gibr_branch_cd = p_gibr_branch_cd
               AND NVL (gl_acct_id, gl_acct_id) = tr_closed_rec.gl_acct_id
               AND gacc_tran_id = p_acc_tran_id
               AND NVL (sl_cd, 0) = NVL (tr_closed_rec.sl_cd, NVL (sl_cd, 0))
               AND NVL (sl_type_cd, '-') =
                         NVL (tr_closed_rec.sl_type_cd, NVL (sl_type_cd, '-'))
               AND generation_type = tr_closed_rec.generation_type;
         END IF;
      END LOOP;
   END gen_reversing_acct_entries;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS001
**
*/
   PROCEDURE insert_acctrans_cap (
      p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
      p_rev_tran_date                giac_acctrans.tran_date%TYPE,
      p_rev_tran_class_no            giac_acctrans.tran_class_no%TYPE,
      p_or_pref_suf         IN OUT   giac_order_of_payts.or_pref_suf%TYPE,
      p_or_no               IN OUT   giac_order_of_payts.or_no%TYPE,
      p_tran_id             IN OUT   giac_acctrans.tran_id%TYPE,
      p_message             OUT      VARCHAR2
   )
   IS
      CURSOR c1
      IS
         SELECT '1'
           FROM giis_funds
          WHERE fund_cd = p_gibr_gfun_fund_cd;

      CURSOR c2
      IS
         SELECT '2'
           FROM giac_branches
          WHERE branch_cd = p_gibr_branch_cd
            AND gfun_fund_cd = p_gibr_gfun_fund_cd;

      v_c1              VARCHAR2 (1);
      v_c2              VARCHAR2 (1);
      v_tran_id         giac_acctrans.tran_id%TYPE;
      v_last_update     giac_acctrans.last_update%TYPE;
      v_user_id         giac_acctrans.user_id%TYPE;
      v_closed_tag      giac_tran_mm.closed_tag%TYPE;
      v_tran_flag       giac_acctrans.tran_flag%TYPE;
      v_tran_class_no   giac_acctrans.tran_class_no%TYPE;
      v_particulars     giac_acctrans.particulars%TYPE;
      v_tran_date       giac_acctrans.tran_date%TYPE;
      v_tran_year       giac_acctrans.tran_year%TYPE;
      v_tran_month      giac_acctrans.tran_month%TYPE;
      v_tran_seq_no     giac_acctrans.tran_seq_no%TYPE;
   BEGIN
      OPEN c1;

      FETCH c1
       INTO v_c1;

      IF c1%NOTFOUND
      THEN
         p_message := 'Invalid company code.';
      ELSE
         OPEN c2;

         FETCH c2
          INTO v_c2;

         IF c2%NOTFOUND
         THEN
            p_message := 'Invalid branch code.';
         END IF;

         CLOSE c2;
      END IF;

      CLOSE c1;

      -- If called by another form, display the corresponding OP
      -- record of the current tran_id when the button OP Info is
      -- pressed.
      BEGIN
         SELECT acctran_tran_id_s.NEXTVAL
           INTO p_tran_id
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message := 'ACCTRAN_TRAN_ID sequence not found.';
      END;

      v_user_id := NVL (giis_users_pkg.app_user, USER);
      v_tran_date := p_rev_tran_date;
      v_tran_class_no := p_rev_tran_class_no;
      v_tran_flag := 'C';
      v_particulars :=
            'To reverse entry for cancelled O.R. No.'
         || p_or_pref_suf
         || ' '
         || TO_CHAR (p_or_no)
         || '.';
      --v_user_id := USER; alfie 04/28/2011
      v_tran_year := TO_NUMBER (TO_CHAR (v_tran_date, 'YYYY'));
      v_tran_month := TO_NUMBER (TO_CHAR (v_tran_date, 'MM'));
      v_tran_seq_no :=
         giac_sequence_generation (p_gibr_gfun_fund_cd,
                                   p_gibr_branch_cd,
                                   'ACCTRAN_TRAN_SEQ_NO',
                                   v_tran_year,
                                   v_tran_month
                                  );

      INSERT INTO giac_acctrans
                  (tran_id, gfun_fund_cd, gibr_branch_cd,
                   tran_date, tran_flag, tran_class, tran_class_no,
                   particulars, tran_year, tran_month, tran_seq_no,
                   user_id, last_update
                  )
           VALUES (p_tran_id, p_gibr_gfun_fund_cd, p_gibr_branch_cd,
                   v_tran_date, v_tran_flag, 'CAP', v_tran_class_no,
                   v_particulars, v_tran_year, v_tran_month, v_tran_seq_no,
                   v_user_id, v_last_update
                  );
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END insert_acctrans_cap;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS001
**
*/
   PROCEDURE insert_into_acct_entries (
      p_gacc_tran_id              giac_order_of_payts.gacc_tran_id%TYPE,
      p_gibr_gfun_fund_cd         giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_gibr_branch_cd            giac_order_of_payts.gibr_branch_cd%TYPE,
      p_acc_tran_id               giac_acctrans.tran_id%TYPE,
      p_item_no                   giac_module_entries.item_no%TYPE,
      p_module_name               VARCHAR2,
      p_message             OUT   VARCHAR2
   )
   IS
      v_tran_flag   giac_acctrans.tran_flag%TYPE;
   BEGIN
      v_tran_flag := get_tran_flag (p_gacc_tran_id);

      IF v_tran_flag IN ('C', 'P')
      THEN
         giac_acct_entries_pkg.gen_reversing_acct_entries
                                                        (p_gacc_tran_id,
                                                         p_gibr_gfun_fund_cd,
                                                         p_gibr_branch_cd,
                                                         p_acc_tran_id
                                                        );
      ELSE
         giac_acct_entries_pkg.force_close_acct_entries (p_gacc_tran_id,
                                                         p_gibr_gfun_fund_cd,
                                                         p_gibr_branch_cd,
                                                         p_item_no,
                                                         p_module_name,
                                                         p_message
                                                        );
         giac_acct_entries_pkg.gen_reversing_acct_entries
                                                         (p_gacc_tran_id,
                                                          p_gibr_gfun_fund_cd,
                                                          p_gibr_branch_cd,
                                                          p_acc_tran_id
                                                         );

         BEGIN
            UPDATE giac_acctrans
               SET tran_flag = 'C'
             WHERE tran_id = p_gacc_tran_id;

            IF SQL%NOTFOUND
            THEN                                          -- IF SQL%FOUND THEN
               p_message := 'Error locating tran_id.';
            END IF;
         END;
      END IF;
   END insert_into_acct_entries;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS019
**
*/
   PROCEDURE aeg_parameters_giacs019 (
      p_tran_id                giac_acctrans.tran_id%TYPE,
      p_module_name            giac_modules.module_name%TYPE,
      p_gacc_branch_cd         giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd           giac_acctrans.gfun_fund_cd%TYPE,
      p_message          OUT   VARCHAR2
   )
   IS
      v_due_to_ri_local     giac_outfacul_prem_payts.disbursement_amt%TYPE;
      v_due_to_ri_foreign   giac_outfacul_prem_payts.disbursement_amt%TYPE;
      v_prem_vat            giri_binder.ri_prem_vat%TYPE;
      v_comm_vat            giri_binder.ri_comm_vat%TYPE;
      v_wholding_vat        giri_binder.ri_wholding_vat%TYPE;
      v_disb_amt            giac_outfacul_prem_payts.disbursement_amt%TYPE;
         v_exist               VARCHAR2 (1);
      v_due_to_ri_local2    giac_outfacul_prem_payts.disbursement_amt%TYPE; --albert 06.25.2013
      v_due_to_ri_foreign2  giac_outfacul_prem_payts.disbursement_amt%TYPE;
      v_comm_amt            giri_binder.ri_comm_amt%TYPE;
      v_module_id           giac_modules.module_id%TYPE;
      v_gen_type            giac_modules.generation_type%TYPE;
      v_sl_cd               giac_acct_entries.sl_cd%TYPE;
      
       -- For Outward Facul Prem Payts
       CURSOR pr_cur
       IS
     -- added by: Nica 06.27.2013 as per judyann 01132012; to handle generation of accounting entries for reversed binders
     -- added by: Nica 06.27.2013 as per mikel 02.09.2012; to handle generation of accounting entries for reused binders to prevent repeating entry.
     -- added by: Nica 06.27.2013 as per ronnie 03.19.2013; to handle generation of accounting entries for reversed and reused binder. 
      SELECT b.a180_ri_cd, c.line_cd, b.disbursement_amt, g.local_foreign_sw,
             ((b.prem_amt) + (NVL (b.prem_vat, 0)))
           - (  (NVL (b.comm_amt, 0))
              + (NVL (b.comm_vat, 0))) due_to_ri_local,
             ((b.prem_amt) + (NVL (b.prem_vat, 0)))
           - (  (NVL (b.comm_amt, 0))
              + (NVL (b.comm_vat, 0))
              + (NVL (b.wholding_vat, 0))
             ) due_to_ri_foreign,                  
             (NVL (b.prem_vat, 0)) ri_prem_vat, (NVL (b.comm_vat, 0)) ri_comm_vat,
             (NVL (b.wholding_vat, 0)) ri_wholding_vat, c.binder_yy,
             c.binder_seq_no,
             -- columns for Due to RI (gross of RI commission) and RI commission
             ((b.prem_amt) + (NVL (b.prem_vat, 0)))
           - (  (NVL (b.comm_vat, 0))) due_to_ri_local2,
             ((b.prem_amt) + (NVL (b.prem_vat, 0)))
           - (  (NVL (b.comm_vat, 0))
              + (NVL (b.wholding_vat, 0))) due_to_ri_foreign2,
             (NVL (b.comm_amt, 0)) ri_comm_amt,
              b.transaction_type transaction_type, b.d010_fnl_binder_id d010_fnl_binder_id
      FROM giac_outfacul_prem_payts b, giri_binder c, giis_reinsurer g
     WHERE b.a180_ri_cd = g.ri_cd                                
       AND c.ri_cd = b.a180_ri_cd
       AND c.fnl_binder_id = b.d010_fnl_binder_id
       AND b.gacc_tran_id = p_tran_id;

      /*CURSOR pr_cur
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
            AND f.dist_flag NOT IN (4, 5);*/
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

      giac_acct_entries_pkg.aeg_delete_acct_ent_giacs019 (p_tran_id,
                                                          v_gen_type
                                                         );

      FOR pr_rec IN pr_cur
      LOOP
         --pr_rec.disbursement_amt := NVL (pr_rec.disbursement_amt, 0);
         --added condition by Edison 06.05.2012
          BEGIN
             SELECT reverse_sw
               INTO v_exist
               FROM giri_distfrps a, giri_frps_ri b
              WHERE a.line_cd = a.line_cd
                AND a.frps_yy = b.frps_yy
                AND a.frps_seq_no = b.frps_seq_no
                AND ri_flag = 4
                AND reverse_sw = 'Y'
                AND fnl_binder_id = pr_rec.d010_fnl_binder_id;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_exist := 'N';
          END;
    
          IF pr_rec.transaction_type = 2
          THEN
             --PR_rec.disbursement_amt changed to v_disb_amt
             IF v_exist = 'Y'
             THEN
                v_disb_amt := NVL (pr_rec.disbursement_amt, 0) * -1;
             ELSE
                v_disb_amt := NVL (pr_rec.disbursement_amt, 0);
             END IF;
          ELSE
             --PR_rec.disbursement_amt changed to v_disb_amt
             v_disb_amt := NVL (pr_rec.disbursement_amt, 0);
          END IF; 
      
         /*IF pr_rec.local_foreign_sw = 'L'
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
         END IF;*/ -- replaced by: Nica 06.27.2013
         
         IF pr_rec.local_foreign_sw = 'L'
          THEN
             v_due_to_ri_local :=
                  pr_rec.due_to_ri_local
                * (                --PR_rec.disbursement_amt changed to v_disb_amt
                   v_disb_amt / pr_rec.due_to_ri_local
                  );
             v_prem_vat :=
                  pr_rec.ri_prem_vat
                * (                --PR_rec.disbursement_amt changed to v_disb_amt
                   v_disb_amt / pr_rec.due_to_ri_local
                  );
             v_comm_vat :=
                  pr_rec.ri_comm_vat
                * (                --PR_rec.disbursement_amt changed to v_disb_amt
                   v_disb_amt / pr_rec.due_to_ri_local
                  );
             v_due_to_ri_local2 :=
                  pr_rec.due_to_ri_local2
                * (v_disb_amt / pr_rec.due_to_ri_local);
             v_comm_amt :=
                  pr_rec.ri_comm_amt
                * (v_disb_amt / pr_rec.due_to_ri_local);
          ELSE
             v_due_to_ri_foreign :=
                  pr_rec.due_to_ri_foreign
                * (                --PR_rec.disbursement_amt changed to v_disb_amt
                   v_disb_amt / pr_rec.due_to_ri_foreign
                  );
             v_prem_vat :=
                  pr_rec.ri_prem_vat
                * (                --PR_rec.disbursement_amt changed to v_disb_amt
                   v_disb_amt / pr_rec.due_to_ri_foreign
                  );
             v_comm_vat :=
                  pr_rec.ri_comm_vat
                * (                --PR_rec.disbursement_amt changed to v_disb_amt
                   v_disb_amt / pr_rec.due_to_ri_foreign
                  );
             v_wholding_vat :=
                  pr_rec.ri_wholding_vat
                * (                --PR_rec.disbursement_amt changed to v_disb_amt
                   v_disb_amt / pr_rec.due_to_ri_foreign
                  );
             v_due_to_ri_foreign2 :=
                  pr_rec.due_to_ri_foreign2
                * (v_disb_amt / pr_rec.due_to_ri_foreign);
             v_comm_amt :=
                  pr_rec.ri_comm_amt
                * (v_disb_amt / pr_rec.due_to_ri_foreign);
         END IF;
         IF pr_rec.local_foreign_sw = 'L'
         THEN
            IF NVL (giacp.v ('COMM_REC_BATCH_TAKEUP'), 'N') = 'Y'
              THEN
              -- accounting entry for RI commission will be made
               IF NVL (giacp.v ('RI_COMM_REC_GROSS_TAG'), 'N') = 'N' THEN--added by steven 09.26.2014
                    giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                              (pr_rec.a180_ri_cd,
                                                               v_module_id,
                                                               1,
                                                               NULL,
                                                               NULL,
                                                               pr_rec.line_cd,
                                                               --pr_rec.type_cd,
                                                               v_due_to_ri_local2,
                                                               v_gen_type,
                                                               p_gacc_branch_cd,
                                                               p_gacc_fund_cd,
                                                               p_tran_id,
                                                               p_message
                                                              );
               ELSE
                    giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                              (pr_rec.a180_ri_cd,
                                                               v_module_id,
                                                               1,
                                                               NULL,
                                                               NULL,
                                                               pr_rec.line_cd,
                                                               --pr_rec.type_cd,
                                                               v_due_to_ri_local2+v_comm_vat,
                                                               v_gen_type,
                                                               p_gacc_branch_cd,
                                                               p_gacc_fund_cd,
                                                               p_tran_id,
                                                               p_message
                                                              );
               END IF;
               
              ELSE
                  giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                          (pr_rec.a180_ri_cd,
                                                           v_module_id,
                                                           1,
                                                           NULL,
                                                           NULL,
                                                           pr_rec.line_cd,
                                                           --pr_rec.type_cd,
                                                           v_due_to_ri_local,
                                                           v_gen_type,
                                                           p_gacc_branch_cd,
                                                           p_gacc_fund_cd,
                                                           p_tran_id,
                                                           p_message
                                                          );
             END IF;
             
         END IF;

         IF pr_rec.local_foreign_sw IN ('A', 'F')
         THEN
            IF NVL (giacp.v ('COMM_REC_BATCH_TAKEUP'), 'N') = 'Y'
             THEN
               IF NVL (giacp.v ('RI_COMM_REC_GROSS_TAG'), 'N') = 'N' THEN--added by steven 09.26.2014
                 giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                          (pr_rec.a180_ri_cd,
                                                           v_module_id,
                                                           1,
                                                           NULL,
                                                           NULL,
                                                           pr_rec.line_cd,
                                                           --pr_rec.type_cd,
                                                           v_due_to_ri_foreign2,
                                                           v_gen_type,
                                                           p_gacc_branch_cd,
                                                           p_gacc_fund_cd,
                                                           p_tran_id,
                                                           p_message
                                                          );
               ELSE        
                 giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                          (pr_rec.a180_ri_cd,
                                                           v_module_id,
                                                           1,
                                                           NULL,
                                                           NULL,
                                                           pr_rec.line_cd,
                                                           --pr_rec.type_cd,
                                                           v_due_to_ri_foreign2+v_comm_vat,
                                                           v_gen_type,
                                                           p_gacc_branch_cd,
                                                           p_gacc_fund_cd,
                                                           p_tran_id,
                                                           p_message
                                                          );                                     
               END IF;
             ELSE
                 giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                          (pr_rec.a180_ri_cd,
                                                           v_module_id,
                                                           1,
                                                           NULL,
                                                           NULL,
                                                           pr_rec.line_cd,
                                                           --pr_rec.type_cd,
                                                           v_due_to_ri_foreign,
                                                           v_gen_type,
                                                           p_gacc_branch_cd,
                                                           p_gacc_fund_cd,
                                                           p_tran_id,
                                                           p_message
                                                          );
             END IF;
         END IF;

         IF (v_comm_vat IS NOT NULL AND v_comm_vat <> 0)
         THEN
             IF NVL (giacp.v ('OUTFACUL_COMM_VAT_ENTRY'), 'DV') = 'DV'
              THEN
              -- entry for output vat will be generated
                  IF NVL (giacp.v ('DEF_RI_VAT_ENTRY'), 'Y') = 'Y'
                THEN
                   giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                              (pr_rec.a180_ri_cd,
                                                               v_module_id,
                                                               2,
                                                               NULL,
                                                               NULL,
                                                               pr_rec.line_cd,
                                                               --pr_rec.type_cd,
                                                               v_comm_vat, --v_due_to_ri_local,// replaced by: nica 06.22.2012
                                                               v_gen_type,
                                                               p_gacc_branch_cd,
                                                               p_gacc_fund_cd,
                                                               p_tran_id,
                                                               p_message
                                                              );
                END IF;
    
                IF NVL (giacp.v ('DEF_RI_VAT_ENTRY'), 'Y') = 'Y'
                THEN
                   giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                              (pr_rec.a180_ri_cd,
                                                               v_module_id,
                                                               3,
                                                               NULL,
                                                               NULL,
                                                               pr_rec.line_cd,
                                                               --pr_rec.type_cd,
                                                               v_comm_vat, --v_due_to_ri_local, // replaced by: Nica
                                                               v_gen_type,
                                                               p_gacc_branch_cd,
                                                               p_gacc_fund_cd,
                                                               p_tran_id,
                                                               p_message
                                                              );
                END IF;
              END IF;   
         
         END IF;

         IF (v_prem_vat IS NOT NULL AND v_prem_vat <> 0)
         THEN
            IF NVL (giacp.v ('DEF_RI_VAT_ENTRY'), 'Y') = 'Y'
            THEN
               IF pr_rec.local_foreign_sw = 'L'
               THEN
                  giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                          (pr_rec.a180_ri_cd,
                                                           v_module_id,
                                                           4,
                                                           NULL,
                                                           NULL,
                                                           pr_rec.line_cd,
                                                           --pr_rec.type_cd,
                                                           v_prem_vat,--v_due_to_ri_local, // replaced by: Nica 06.22.2012
                                                           v_gen_type,
                                                           p_gacc_branch_cd,
                                                           p_gacc_fund_cd,
                                                           p_tran_id,
                                                           p_message
                                                          );
               END IF;
            END IF;

            IF NVL (giacp.v ('DEF_RI_VAT_ENTRY'), 'Y') = 'Y'
            THEN
               IF pr_rec.local_foreign_sw = 'L'
               THEN
                  giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                          (pr_rec.a180_ri_cd,
                                                           v_module_id,
                                                           5,
                                                           NULL,
                                                           NULL,
                                                           pr_rec.line_cd,
                                                           --pr_rec.type_cd,
                                                           v_prem_vat, --v_due_to_ri_local, // replaced by: Nica 06.22.2012
                                                           v_gen_type,
                                                           p_gacc_branch_cd,
                                                           p_gacc_fund_cd,
                                                           p_tran_id,
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
                  giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                          (pr_rec.a180_ri_cd,
                                                           v_module_id,
                                                           6,
                                                           NULL,
                                                           NULL,
                                                           pr_rec.line_cd,
                                                           --pr_rec.type_cd,
                                                           v_wholding_vat, --v_due_to_ri_local, // replaced by: Nica 06.22.2012
                                                           v_gen_type,
                                                           p_gacc_branch_cd,
                                                           p_gacc_fund_cd,
                                                           p_tran_id,
                                                           p_message
                                                          );
               END IF;
            END IF;

            IF pr_rec.local_foreign_sw IN ('A', 'F')
            THEN
               giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                          (pr_rec.a180_ri_cd,
                                                           v_module_id,
                                                           7,
                                                           NULL,
                                                           NULL,
                                                           pr_rec.line_cd,
                                                           --pr_rec.type_cd,
                                                           v_wholding_vat, --v_due_to_ri_local, // replaced by: Nica 06.22.2012
                                                           v_gen_type,
                                                           p_gacc_branch_cd,
                                                           p_gacc_fund_cd,
                                                           p_tran_id,
                                                           p_message
                                                          );
            END IF;

            IF NVL (giacp.v ('DEF_RI_VAT_ENTRY'), 'Y') = 'Y'
            THEN
               IF pr_rec.local_foreign_sw IN ('A', 'F')
               THEN
                  giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                          (pr_rec.a180_ri_cd,
                                                           v_module_id,
                                                           8,
                                                           NULL,
                                                           NULL,
                                                           pr_rec.line_cd,
                                                           --pr_rec.type_cd,
                                                           v_wholding_vat, --v_due_to_ri_local, // replaced by: Nica 06.22.2012
                                                           v_gen_type,
                                                           p_gacc_branch_cd,
                                                           p_gacc_fund_cd,
                                                           p_tran_id,
                                                           p_message
                                                          );
               END IF;
            END IF;

            IF pr_rec.local_foreign_sw IN ('A', 'F')
            THEN
               giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                          (pr_rec.a180_ri_cd,
                                                           v_module_id,
                                                           9,
                                                           NULL,
                                                           NULL,
                                                           pr_rec.line_cd,
                                                           --pr_rec.type_cd,
                                                           v_wholding_vat, --v_due_to_ri_local, // replaced by: Nica 06.22.2012
                                                           v_gen_type,
                                                           p_gacc_branch_cd,
                                                           p_gacc_fund_cd,
                                                           p_tran_id,
                                                           p_message
                                                          );
            END IF;
         END IF;
         
         IF NVL (giacp.v ('COMM_REC_BATCH_TAKEUP'), 'N') = 'Y'
             THEN
             -- accounting entry for RI commission will be made
             IF NVL (giacp.v ('RI_COMM_REC_GROSS_TAG'), 'N') = 'N' THEN--added by steven 09.30.2014
                 giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                      (pr_rec.a180_ri_cd,
                                                       v_module_id,
                                                       10,
                                                       NULL,
                                                       NULL,
                                                       pr_rec.line_cd,
                                                       --pr_rec.type_cd,
                                                       v_comm_amt,
                                                       v_gen_type,
                                                       p_gacc_branch_cd,
                                                       p_gacc_fund_cd,
                                                       p_tran_id,
                                                       p_message
                                                      );
             ELSE        
                 giac_acct_entries_pkg.aeg_create_acct_ent_giacs019
                                                      (pr_rec.a180_ri_cd,
                                                       v_module_id,
                                                       10,
                                                       NULL,
                                                       NULL,
                                                       pr_rec.line_cd,
                                                       --pr_rec.type_cd,
                                                       v_comm_amt+v_comm_vat, 
                                                       v_gen_type,
                                                       p_gacc_branch_cd,
                                                       p_gacc_fund_cd,
                                                       p_tran_id,
                                                       p_message
                                                      );                                     
             END IF;
          END IF;
         
      END LOOP;
   END aeg_parameters_giacs019;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS019
**
*/
   PROCEDURE aeg_create_acct_ent_giacs019 (
      aeg_sl_cd                  giac_acct_entries.sl_cd%TYPE,
      aeg_module_id              giac_module_entries.module_id%TYPE,
      aeg_item_no                giac_module_entries.item_no%TYPE,
      aeg_iss_cd                 giac_ri_req_payt_dtl.iss_cd%TYPE,
      aeg_bill_no                giac_ri_req_payt_dtl.prem_seq_no%TYPE,
      aeg_line_cd                giis_line.line_cd%TYPE,
      --aeg_type_cd                gipi_polbasic.type_cd%TYPE, commented by: Nica 06.27.2013
      aeg_acct_amt               giac_outfacul_prem_payts.disbursement_amt%TYPE,
      aeg_gen_type               giac_acct_entries.generation_type%TYPE,
      aeg_gacc_branch_cd         giac_acctrans.gibr_branch_cd%TYPE,
      aeg_gacc_fund_cd           giac_acctrans.gfun_fund_cd%TYPE,
      aeg_gacc_tran_id           giac_order_of_payts.gacc_tran_id%TYPE,
      aeg_message          OUT   VARCHAR2
   )
   IS
      ws_gl_acct_category     giac_acct_entries.gl_acct_category%TYPE;
      ws_gl_control_acct      giac_acct_entries.gl_control_acct%TYPE;
      ws_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      ws_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      ws_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      ws_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      ws_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      ws_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_pol_type_tag         giac_module_entries.pol_type_tag%TYPE;
      ws_intm_type_level      giac_module_entries.intm_type_level%TYPE;
      ws_old_new_acct_level   giac_module_entries.old_new_acct_level%TYPE;
      ws_line_dep_level       giac_module_entries.line_dependency_level%TYPE;
      ws_dr_cr_tag            giac_module_entries.dr_cr_tag%TYPE;
      ws_acct_intm_cd         giis_intm_type.acct_intm_cd%TYPE;
      ws_line_cd              giis_line.line_cd%TYPE;
      ws_iss_cd               gipi_polbasic.iss_cd%TYPE;
      ws_old_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_new_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      pt_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      pt_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      pt_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      pt_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      pt_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_debit_amt            giac_acct_entries.debit_amt%TYPE;
      ws_credit_amt           giac_acct_entries.credit_amt%TYPE;
      ws_gl_acct_id           giac_acct_entries.gl_acct_id%TYPE;
      ws_sl_type_cd           giac_acct_entries.sl_type_cd%TYPE;
--GIAC_ACCT_ENTRIES.sl_source_cd%type,
--     iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%type      )I
   BEGIN
--msg_alert('AEG CREATE ACCT ENTRIES...','I',FALSE);

      /**************************************************************************
      *                                                                         *
      * Populate the GL Account Code used in every transactions.                *
      *                                                                         *
      **************************************************************************/
      BEGIN
         SELECT        gl_acct_category, gl_control_acct,
                       gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                       gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                       gl_sub_acct_7, pol_type_tag,
                       intm_type_level, old_new_acct_level,
                       dr_cr_tag, line_dependency_level
                  INTO ws_gl_acct_category, ws_gl_control_acct,
                       ws_gl_sub_acct_1, ws_gl_sub_acct_2, ws_gl_sub_acct_3,
                       ws_gl_sub_acct_4, ws_gl_sub_acct_5, ws_gl_sub_acct_6,
                       ws_gl_sub_acct_7, ws_pol_type_tag,
                       ws_intm_type_level, ws_old_new_acct_level,
                       ws_dr_cr_tag, ws_line_dep_level
                  FROM giac_module_entries
                 WHERE module_id = aeg_module_id AND item_no = aeg_item_no
         FOR UPDATE OF gl_sub_acct_1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            aeg_message := 'No data found in giac_module_entries.';
      END;

--IGNORE THESE PARTS FOR NOW (INTM_TYPE, LINE DEP, OLD/NEW ACCT LEVEL)

      /**************************************************************************
  *                                                                         *
  * Validate the INTM_TYPE_LEVEL value which indicates the segment of the   *
  * GL account code that holds the intermediary type.                       *
  *                                                                         *
  **************************************************************************/
/*
      IF ws_intm_type_level != 0 THEN
        BEGIN
          SELECT DISTINCT(c.acct_intm_cd)
            INTO ws_acct_intm_cd
            FROM gipi_comm_invoice a,
                 giis_intermediary b,
                 giis_intm_type c
           WHERE a.intrmdry_intm_no = b.intm_no
             AND b.intm_type        = c.intm_type
             AND a.iss_cd           = aeg_iss_cd
             AND a.prem_seq_no      = aeg_bill_no;
        EXCEPTION
          WHEN no_data_found THEN
            Msg_Alert('No data found in giis_intm_type.','E',true);
        END;
        AEG_Check_Level(ws_intm_type_level, ws_acct_intm_cd , ws_gl_sub_acct_1,
                        ws_gl_sub_acct_2  , ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                        ws_gl_sub_acct_5  , ws_gl_sub_acct_6, ws_gl_sub_acct_7);
      END IF;
*/
  /**************************************************************************
  *                                                                         *
  * Validate the LINE_DEPENDENCY_LEVEL value which indicates the segment of *
  * the GL account code that holds the line number.                         *
  *                                                                         *
  **************************************************************************/
      IF ws_line_dep_level != 0
      THEN
         BEGIN
            SELECT acct_line_cd
              INTO ws_line_cd
              FROM giis_line
             WHERE line_cd = aeg_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               aeg_message := 'No data found in giis_line.';
         END;

         giac_acct_entries_pkg.aeg_check_level (ws_line_dep_level,
                                                ws_line_cd,
                                                ws_gl_sub_acct_1,
                                                ws_gl_sub_acct_2,
                                                ws_gl_sub_acct_3,
                                                ws_gl_sub_acct_4,
                                                ws_gl_sub_acct_5,
                                                ws_gl_sub_acct_6,
                                                ws_gl_sub_acct_7
                                               );
      END IF;

      /**************************************************************************
      *                                                                         *
      * Validate the OLD_NEW_ACCT_LEVEL value which indicates the segment of    *
      * the GL account code that holds the old and new account values.          *
      *                                                                         *
      **************************************************************************/
      IF ws_old_new_acct_level != 0
      THEN
         BEGIN
            BEGIN
               SELECT param_value_v
                 INTO ws_iss_cd
                 FROM giac_parameters
                WHERE param_name = 'OLD_ISS_CD';
            END;

            BEGIN
               SELECT param_value_n
                 INTO ws_old_acct_cd
                 FROM giac_parameters
                WHERE param_name = 'OLD_ACCT_CD';
            END;

            BEGIN
               SELECT param_value_n
                 INTO ws_new_acct_cd
                 FROM giac_parameters
                WHERE param_name = 'NEW_ACCT_CD';
            END;

            IF aeg_iss_cd = ws_iss_cd
            THEN
               giac_acct_entries_pkg.aeg_check_level (ws_old_new_acct_level,
                                                      ws_old_acct_cd,
                                                      ws_gl_sub_acct_1,
                                                      ws_gl_sub_acct_2,
                                                      ws_gl_sub_acct_3,
                                                      ws_gl_sub_acct_4,
                                                      ws_gl_sub_acct_5,
                                                      ws_gl_sub_acct_6,
                                                      ws_gl_sub_acct_7
                                                     );
            ELSE
               giac_acct_entries_pkg.aeg_check_level (ws_old_new_acct_level,
                                                      ws_new_acct_cd,
                                                      ws_gl_sub_acct_1,
                                                      ws_gl_sub_acct_2,
                                                      ws_gl_sub_acct_3,
                                                      ws_gl_sub_acct_4,
                                                      ws_gl_sub_acct_5,
                                                      ws_gl_sub_acct_6,
                                                      ws_gl_sub_acct_7
                                                     );
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               aeg_message := 'No data found in giac_parameters.';
         END;
      END IF;

      /**************************************************************************
      *                                                                         *
      * Check the POL_TYPE_TAG which indicates if the policy type GL code       *
      * segments will be attached to this GL account.                           *
      *                                                                         *
      **************************************************************************/
      /*IF ws_pol_type_tag = 'Y'
      THEN
         BEGIN
            SELECT NVL (gl_sub_acct_1, 0), NVL (gl_sub_acct_2, 0),
                   NVL (gl_sub_acct_3, 0), NVL (gl_sub_acct_4, 0),
                   NVL (gl_sub_acct_5, 0), NVL (gl_sub_acct_6, 0),
                   NVL (gl_sub_acct_7, 0)
              INTO pt_gl_sub_acct_1, pt_gl_sub_acct_2,
                   pt_gl_sub_acct_3, pt_gl_sub_acct_4,
                   pt_gl_sub_acct_5, pt_gl_sub_acct_6,
                   pt_gl_sub_acct_7
              FROM giac_policy_type_entries
             WHERE line_cd = aeg_line_cd AND type_cd = aeg_type_cd;

            IF pt_gl_sub_acct_1 != 0
            THEN
               ws_gl_sub_acct_1 := pt_gl_sub_acct_1;
            END IF;

            IF pt_gl_sub_acct_2 != 0
            THEN
               ws_gl_sub_acct_2 := pt_gl_sub_acct_2;
            END IF;

            IF pt_gl_sub_acct_3 != 0
            THEN
               ws_gl_sub_acct_3 := pt_gl_sub_acct_3;
            END IF;

            IF pt_gl_sub_acct_4 != 0
            THEN
               ws_gl_sub_acct_4 := pt_gl_sub_acct_4;
            END IF;

            IF pt_gl_sub_acct_5 != 0
            THEN
               ws_gl_sub_acct_5 := pt_gl_sub_acct_5;
            END IF;

            IF pt_gl_sub_acct_6 != 0
            THEN
               ws_gl_sub_acct_6 := pt_gl_sub_acct_6;
            END IF;

            IF pt_gl_sub_acct_7 != 0
            THEN
               ws_gl_sub_acct_7 := pt_gl_sub_acct_7;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               aeg_message := 'No data found in giac_policy_type_entries.';
         END;
      END IF;*/

      /**************************************************************************
      *                                                                         *
      * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
      *                                                                         *
      **************************************************************************/
      giac_acct_entries_pkg.aeg_check_chart_of_accts (ws_gl_acct_category,
                                                      ws_gl_control_acct,
                                                      ws_gl_sub_acct_1,
                                                      ws_gl_sub_acct_2,
                                                      ws_gl_sub_acct_3,
                                                      ws_gl_sub_acct_4,
                                                      ws_gl_sub_acct_5,
                                                      ws_gl_sub_acct_6,
                                                      ws_gl_sub_acct_7,
                                                      ws_gl_acct_id,
                                                      aeg_message
                                                     );
                                                     
                                         
      --validate the GL account's SL type if it is for RI.
      giac_acct_entries_pkg.aeg_get_sl_type_leaf_tag (ws_gl_acct_id,
                                                      aeg_sl_cd,
                                                      aeg_message
                                                     );

      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/
      IF ws_dr_cr_tag = 'D'
      THEN
         IF aeg_acct_amt > 0
         THEN
            ws_debit_amt := ABS (aeg_acct_amt);
            ws_credit_amt := 0;
         ELSE
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_acct_amt);
         END IF;
      ELSE
         IF aeg_acct_amt > 0
         THEN
            ws_debit_amt := 0;
            ws_credit_amt := ABS (aeg_acct_amt);
         ELSE
            ws_debit_amt := ABS (aeg_acct_amt);
            ws_credit_amt := 0;
         END IF;
      END IF;

      /****************************************************************************
      *                                                                           *
      * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      *                                                                           *
      ****************************************************************************/
      BEGIN
         SELECT DISTINCT (NVL (gslt_sl_type_cd, ' '))
                    INTO ws_sl_type_cd
                    FROM giac_chart_of_accts
                   WHERE gl_acct_category = ws_gl_acct_category
                     AND gl_control_acct = ws_gl_control_acct
                     AND gl_sub_acct_1 = ws_gl_sub_acct_1
                     AND gl_sub_acct_2 = ws_gl_sub_acct_2
                     AND gl_sub_acct_3 = ws_gl_sub_acct_3
                     AND gl_sub_acct_4 = ws_gl_sub_acct_4
                     AND gl_sub_acct_5 = ws_gl_sub_acct_5
                     AND gl_sub_acct_6 = ws_gl_sub_acct_6
                     AND gl_sub_acct_7 = ws_gl_sub_acct_7;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            aeg_message :=
                  'GL account code '
               || TO_CHAR (ws_gl_acct_category)
               || '-'
               || TO_CHAR (ws_gl_control_acct, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_1, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_2, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_3, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_4, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_5, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_6, '09')
               || '-'
               || TO_CHAR (ws_gl_sub_acct_7, '09')
               || ' does not exist in Chart of Accounts (Giac_Acctrans).';
      END;

      giac_acct_entries_pkg.aeg_ins_upd_acct_ent_giacs019
                                                         (ws_gl_acct_category,
                                                          ws_gl_control_acct,
                                                          ws_gl_sub_acct_1,
                                                          ws_gl_sub_acct_2,
                                                          ws_gl_sub_acct_3,
                                                          ws_gl_sub_acct_4,
                                                          ws_gl_sub_acct_5,
                                                          ws_gl_sub_acct_6,
                                                          ws_gl_sub_acct_7,
                                                          aeg_sl_cd,
                                                          aeg_gen_type,
                                                          ws_gl_acct_id,
                                                          ws_debit_amt,
                                                          ws_credit_amt,
                                                          '1',
                                                          ws_sl_type_cd,
                                                          aeg_gacc_branch_cd,
                                                          aeg_gacc_fund_cd,
                                                          aeg_gacc_tran_id
                                                         );
   END aeg_create_acct_ent_giacs019;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS019
**
*/
   PROCEDURE aeg_ins_upd_acct_ent_giacs019 (
      iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
      iuae_generation_type    giac_acct_entries.generation_type%TYPE,
      iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
      iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
      iuae_sl_source_cd       giac_acct_entries.sl_source_cd%TYPE,
      iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
      iuae_gacc_branch_cd     giac_acctrans.gibr_branch_cd%TYPE,
      iuae_gacc_fund_cd       giac_acctrans.gfun_fund_cd%TYPE,
      iuae_gacc_tran_id       giac_order_of_payts.gacc_tran_id%TYPE
   )
   IS
      iuae_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
   BEGIN
      SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gacc_gibr_branch_cd = iuae_gacc_branch_cd
         AND gacc_gfun_fund_cd = iuae_gacc_fund_cd
         AND gl_acct_id = iuae_gl_acct_id
         AND sl_cd = iuae_sl_cd
         AND generation_type = iuae_generation_type
         AND gacc_tran_id = iuae_gacc_tran_id;

      IF NVL (iuae_debit_amt, 0) = 0 AND NVL (iuae_credit_amt, 0) = 0
      THEN
         NULL;
      ELSE
         IF NVL (iuae_acct_entry_id, 0) = 0
         THEN
            iuae_acct_entry_id := NVL (iuae_acct_entry_id, 0) + 1;

            INSERT INTO giac_acct_entries
                        (gacc_tran_id, gacc_gfun_fund_cd,
                         gacc_gibr_branch_cd, acct_entry_id,
                         gl_acct_id, gl_acct_category,
                         gl_control_acct, gl_sub_acct_1,
                         gl_sub_acct_2, gl_sub_acct_3,
                         gl_sub_acct_4, gl_sub_acct_5,
                         gl_sub_acct_6, gl_sub_acct_7, sl_cd,
                         debit_amt, credit_amt,
                         generation_type,
                         user_id, last_update,
                         sl_type_cd, sl_source_cd
                        )
                 VALUES (iuae_gacc_tran_id, iuae_gacc_fund_cd,
                         iuae_gacc_branch_cd, iuae_acct_entry_id,
                         iuae_gl_acct_id, iuae_gl_acct_category,
                         iuae_gl_control_acct, iuae_gl_sub_acct_1,
                         iuae_gl_sub_acct_2, iuae_gl_sub_acct_3,
                         iuae_gl_sub_acct_4, iuae_gl_sub_acct_5,
                         iuae_gl_sub_acct_6, iuae_gl_sub_acct_7, iuae_sl_cd,
                         iuae_debit_amt, iuae_credit_amt,
                         iuae_generation_type,
                         NVL (giis_users_pkg.app_user, USER), SYSDATE,
                         iuae_sl_type_cd, iuae_sl_source_cd
                        );
         ELSE
            UPDATE giac_acct_entries
               SET debit_amt = debit_amt + iuae_debit_amt,
                   credit_amt = credit_amt + iuae_credit_amt
             WHERE sl_cd = iuae_sl_cd
               AND generation_type = iuae_generation_type
               AND gl_acct_id = iuae_gl_acct_id
               AND gacc_gibr_branch_cd = iuae_gacc_branch_cd
               AND gacc_gfun_fund_cd = iuae_gacc_fund_cd
               AND gacc_tran_id = iuae_gacc_tran_id;
         END IF;
      END IF;
   END aeg_ins_upd_acct_ent_giacs019;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS019
**
*/
   PROCEDURE aeg_delete_acct_ent_giacs019 (
      p_gacc_tran_id   giac_order_of_payts.gacc_tran_id%TYPE,
      p_gen_type       giac_modules.generation_type%TYPE
   )
   IS
      dummy   VARCHAR2 (1);

      CURSOR ae
      IS
         SELECT '1'
           FROM giac_acct_entries
          WHERE gacc_tran_id = p_gacc_tran_id
                AND generation_type = p_gen_type;
   BEGIN
      OPEN ae;

      FETCH ae
       INTO dummy;

      IF SQL%FOUND
      THEN
         DELETE FROM giac_acct_entries
               WHERE gacc_tran_id = p_gacc_tran_id
                 AND generation_type = p_gen_type;
      END IF;
   END aeg_delete_acct_ent_giacs019;

/*
**  Created by      : Anthony Santos
**  Date Created  :   March 18, 2011
**  Reference By  :   GIACS019
**
*/
   PROCEDURE aeg_get_sl_type_leaf_tag (
      p_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      p_sl_cd              giac_acct_entries.sl_cd%TYPE,
      p_message      OUT   VARCHAR2
   )
   IS
      v_sl_type    giac_chart_of_accts.gslt_sl_type_cd%TYPE;
      v_leaf_tag   giac_chart_of_accts.leaf_tag%TYPE;
   BEGIN
      SELECT gslt_sl_type_cd, leaf_tag
        INTO v_sl_type, v_leaf_tag
        FROM giac_chart_of_accts
       WHERE gl_acct_id = p_gl_acct_id;

      IF v_sl_type <> p_sl_cd
      THEN
         p_message :=
               'The SL type of this account(gl_acct_id: '
            || TO_CHAR (p_gl_acct_id)
            || ') '
            || 'does not match that in RI_SL_CD (GIAC PARAMETERS).';
      END IF;

      IF v_leaf_tag = 'N'
      THEN
         p_message :=
               'This account(gl_acct_id: '
            || TO_CHAR (p_gl_acct_id)
            || ') '
            || 'is not a posting account.';
      END IF;
   END aeg_get_sl_type_leaf_tag;

   PROCEDURE aeg_parameters_giacs001 (
      p_tran_id             giac_acctrans.tran_id%TYPE,
      p_branch_cd           giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_fund_cd             giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_module_name         giac_modules.module_name%TYPE,
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
            AND pay_mode NOT IN ('PDC', 'CMI', 'CW', 'RCM'); -- RCM added by: Nica 06.15.2013 AC-SPECS-2012-155

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
          
      --added by: Nica 06.15.2013 AC-SPECS-2012-155
      CURSOR pr_cur_rcm IS
        SELECT SUBSTR (check_no, 0, INSTR (check_no, '-', 1, 1) - 1) memo_type,
               SUBSTR (check_no, INSTR (check_no, '-', 1, 1) + 1, INSTR (check_no, '-', 1)) memo_year,
               SUBSTR (check_no, INSTR (check_no, '-', 1, 2) + 1) memo_seq_no,
               cm_tran_id --marco - 11.13.2014
          FROM giac_collection_dtl
         WHERE gacc_tran_id = p_tran_id
           AND pay_mode = 'RCM';

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

      giac_acct_entries_pkg.delete_acct_entries_giacs001 (p_tran_id,
                                                          v_gen_type
                                                         );
      --giac_op_text_pkg.del_giac_op_text(p_tran_id, v_gen_type); --marco - 12.02.2014 - comment out - FGIC-WEB SR 2592                                                    

      FOR pr_rec IN pr_cur
      LOOP
         giac_acct_entries_pkg.aeg_create_cib_giacs001
                                                    (pr_rec.dcb_bank_cd,
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
         giac_acct_entries_pkg.create_acct_entries_giacs001
                                              (v_module_id,
                                               2,
                                               pr_rec_pdc.amount,
                                               v_gen_type,
                                               p_branch_cd,
                                               p_fund_cd,
                                               p_tran_id,
                                               NVL (giis_users_pkg.app_user,
                                                    USER
                                                   ),
                                               p_sl_cd,
                                               p_sl_type_cd,
                                               p_message
                                              );
      END LOOP;

      FOR pr_rec_cmi IN pr_cur_cmi
      LOOP
         giac_acct_entries_pkg.create_acct_entries_giacs001
                                              (v_module_id,
                                               3,
                                               pr_rec_cmi.amount,
                                               v_gen_type,
                                               p_branch_cd,
                                               p_fund_cd,
                                               p_tran_id,
                                               NVL (giis_users_pkg.app_user,
                                                    USER
                                                   ),
                                               p_sl_cd,
                                               p_sl_type_cd,
                                               p_message
                                              );
      END LOOP;

      FOR pr_rec_cw IN pr_cur_cw
      LOOP
         giac_acct_entries_pkg.create_acct_entries_giacs001
                                              (v_module_id,
                                               4,
                                               pr_rec_cw.amount,
                                               v_gen_type,
                                               p_branch_cd,
                                               p_fund_cd,
                                               p_tran_id,
                                               NVL (giis_users_pkg.app_user,
                                                    USER
                                                   ),
                                               p_sl_cd,
                                               p_sl_type_cd,
                                               p_message
                                              );
      END LOOP;
      
      --added by: Nica 06.15.2013 AC-SPECS-2012-155
      DECLARE
         v_rcm_tran_id                 giac_cm_dm.gacc_tran_id%TYPE;
         v_rcm_local_amount            giac_cm_dm.local_amt%TYPE;
         v_rcm_foreign_amount          giac_cm_dm.amount%TYPE;
         v_currency_cd                 giac_cm_dm.currency_cd%TYPE;
         v_currency_rt                 giac_cm_dm.currency_rt%TYPE;
         v_input_vat_rt                NUMBER := giacp.n('INPUT_VAT_RT')/100;
         v_ri_local_comm_amt           giac_op_text.item_amt%TYPE := 0;
         v_ri_local_comm_vat           giac_op_text.item_amt%TYPE := 0;
         v_ri_foreign_comm_amt         giac_op_text.foreign_curr_amt%TYPE := 0;
         v_ri_foreign_comm_vat         giac_op_text.foreign_curr_amt%TYPE := 0;
         
          --Added by Nica 06.28.2013 AC-SPECS-2013-073_GIACS001
         v_ri_local_rec_comm_vat        giac_op_text.item_amt%TYPE := 0;
         v_ri_local_rec_comm_amt        giac_op_text.item_amt%TYPE := 0; 
         v_ri_foreign_rec_comm_vat     giac_op_text.foreign_curr_amt%TYPE := 0; 
         v_ri_foreign_rec_comm_amt     giac_op_text.foreign_curr_amt%TYPE := 0; 
            
         v_ri_acc_comm_vat             giac_cm_dm.local_amt%TYPE := 0; 
         v_ri_fcomm_vat                giac_cm_dm.local_amt%TYPE := 0;
         --end here Nica 06.28.2013 
         
         --mikel 09.30.2013
         v_dv_tran_id                giac_cm_dm.dv_tran_id%TYPE;
         v_rcm_comm_amt              giac_outfacul_prem_payts.comm_vat%TYPE; 
         v_rcm_comm_vat              giac_outfacul_prem_payts.comm_vat%TYPE := 0;
         
         v_deferred_vat_id           giac_acct_entries.gl_acct_id%TYPE; --added by robert 03.11.14
         
      BEGIN
          
          --to get gl_acct_id of deferred output VAT, added by robert 03.11.14
          BEGIN
           SELECT DISTINCT(gl_acct_id)
             INTO v_deferred_vat_id
             FROM giac_acct_entries a, giac_module_entries b, giac_modules c
            WHERE 1=1
              AND a.gl_acct_category = b.gl_acct_category
              AND a.gl_control_acct = b.gl_control_acct
              AND a.gl_sub_acct_1 = b.gl_sub_acct_1
              AND a.gl_sub_acct_2 = b.gl_sub_acct_2
              AND a.gl_sub_acct_3 = b.gl_sub_acct_3
              AND a.gl_sub_acct_4 = b.gl_sub_acct_4
              AND a.gl_sub_acct_5 = b.gl_sub_acct_5
              AND a.gl_sub_acct_6 = b.gl_sub_acct_6
              AND a.gl_sub_acct_7 = b.gl_sub_acct_7
              AND b.module_id = c.module_id
              AND module_name = p_module_name
              AND item_no = 5;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
            p_message := 'No setup in module entries for Deferred Output VAT';
          END;
          --end of codes robert 03.11.14
         
                    
         FOR pr_rec_rcm IN pr_cur_rcm
         LOOP
            /*SELECT gacc_tran_id, amount, local_amt, currency_cd, currency_rt, dv_tran_id --mikel 09.30.2013; added dv_tran_id
              INTO v_rcm_tran_id, v_rcm_foreign_amount, v_rcm_local_amount, v_currency_cd, v_currency_rt, v_dv_tran_id
              FROM giac_cm_dm
             WHERE memo_type = pr_rec_rcm.memo_type
               AND memo_year = pr_rec_rcm.memo_year
               AND memo_seq_no = pr_rec_rcm.memo_seq_no;
                           
            v_ri_foreign_comm_amt := v_ri_foreign_comm_amt + (v_rcm_foreign_amount / (1 + v_input_vat_rt));
            v_ri_foreign_comm_vat := v_ri_foreign_comm_vat + ((v_rcm_foreign_amount / (1 + v_input_vat_rt)) * v_input_vat_rt);
            --v_ri_local_comm_amt   := v_ri_local_comm_amt + ((v_rcm_foreign_amount * v_currency_rt) / (1 + v_input_vat_rt)); --removed by robert 03.11.14                                
            --v_ri_local_comm_vat   := v_ri_local_comm_vat + (((v_rcm_foreign_amount * v_currency_rt) / (1 + v_input_vat_rt)) * v_input_vat_rt); --removed by robert 03.11.14        
            v_ri_local_comm_amt   := v_ri_local_comm_amt + (ROUND ((v_rcm_foreign_amount / (1 + v_input_vat_rt)), 2) * v_currency_rt);    --added by robert 03.11.14                    
            v_ri_local_comm_vat   := v_ri_local_comm_vat + (ROUND (((v_rcm_foreign_amount / (1 + v_input_vat_rt)) * v_input_vat_rt), 2) * v_currency_rt); --added by robert 03.11.14        
            
            --Added by Nica 06.28.2013 AC-SPECS-2013-073_GIACS001
            v_ri_foreign_rec_comm_vat := v_ri_foreign_rec_comm_vat + (v_rcm_foreign_amount * (nvl(giacp.n('INPUT_VAT_RT'),0)/100));
            v_ri_foreign_rec_comm_amt := v_ri_foreign_rec_comm_amt + v_rcm_foreign_amount;
            --v_ri_local_rec_comm_vat := v_ri_local_rec_comm_vat + ((v_rcm_foreign_amount * v_currency_rt) * (nvl(giacp.n('INPUT_VAT_RT'),0)/100)); --removed by robert 03.11.14
            v_ri_local_rec_comm_vat := v_ri_local_rec_comm_vat + (ROUND ((v_rcm_foreign_amount * (nvl(giacp.n('INPUT_VAT_RT'),0)/100)), 2) * v_currency_rt); --added by robert 03.11.14
            v_ri_local_rec_comm_amt := v_ri_local_rec_comm_amt + (v_rcm_foreign_amount * v_currency_rt);*/
            --end here Nica     
            
            --replaced by john 10.27.2014
            FOR i IN(
                SELECT gacc_tran_id, amount, local_amt, currency_cd, currency_rt, dv_tran_id --mikel 09.30.2013; added dv_tran_id
                       ,ri_comm_amt, ri_comm_vat --mikel 09.24.2015; GENQA RSIC 4984 
                  FROM giac_cm_dm
                 WHERE memo_type = pr_rec_rcm.memo_type
                   AND memo_year = pr_rec_rcm.memo_year
                   AND memo_seq_no = pr_rec_rcm.memo_seq_no
                   AND gacc_tran_id = pr_rec_rcm.cm_tran_id --marco -11.13.2014
            )
            LOOP
                v_rcm_tran_id           := i.gacc_tran_id;
                v_rcm_foreign_amount    := i.amount; 
                v_rcm_local_amount      := i.local_amt;
                v_currency_cd           := i.currency_cd;
                v_currency_rt           := i.currency_rt;
                v_dv_tran_id            := i.dv_tran_id;
                
                v_ri_foreign_comm_amt := v_ri_foreign_comm_amt + (v_rcm_foreign_amount / (1 + v_input_vat_rt));
                v_ri_foreign_comm_vat := v_ri_foreign_comm_vat + ((v_rcm_foreign_amount / (1 + v_input_vat_rt)) * v_input_vat_rt);
                v_ri_local_comm_amt   := v_ri_local_comm_amt + (ROUND ((v_rcm_foreign_amount / (1 + v_input_vat_rt)), 2) * v_currency_rt);                        
                v_ri_local_comm_vat   := v_ri_local_comm_vat + (ROUND (((v_rcm_foreign_amount / (1 + v_input_vat_rt)) * v_input_vat_rt), 2) * v_currency_rt);
                
                v_ri_foreign_rec_comm_vat := v_ri_foreign_rec_comm_vat + (v_rcm_foreign_amount * (nvl(giacp.n('INPUT_VAT_RT'),0)/100));
                v_ri_foreign_rec_comm_amt := v_ri_foreign_rec_comm_amt + v_rcm_foreign_amount;
                v_ri_local_rec_comm_vat := v_ri_local_rec_comm_vat + (ROUND ((v_rcm_foreign_amount * (nvl(giacp.n('INPUT_VAT_RT'),0)/100)), 2) * v_currency_rt);
                v_ri_local_rec_comm_amt := v_ri_local_rec_comm_amt + (v_rcm_foreign_amount * v_currency_rt);
                
                --mikel 09.24.2015; GENQA RSIC 4984 
                v_rcm_comm_amt          := i.ri_comm_amt; 
                v_rcm_comm_vat          := i.ri_comm_vat;
                
            END LOOP;   
           
        --to exclude deferred output tax from rcm entries when parameter CO, --added by robert 03.11.14                    
        IF NVL(giacp.v('OUTFACUL_COMM_VAT_ENTRY'),'DV') = 'CO' THEN
            FOR acc_entries IN (SELECT gl_acct_category, gl_control_acct,
                                   gl_sub_acct_1   , gl_sub_acct_2  ,
                                   gl_sub_acct_3   , gl_sub_acct_4  ,
                                   gl_sub_acct_5   , gl_sub_acct_6  ,
                                   gl_sub_acct_7   , sl_cd          ,
                                   sl_type_cd      , gl_acct_id     ,
                                   debit_amt       , credit_amt
                              FROM giac_acct_entries
                             WHERE gacc_tran_id = v_rcm_tran_id
                               AND gl_acct_id != v_deferred_vat_id)
            LOOP
                giac_acct_entries_pkg.aeg_ins_upd_rcm_entr_giacs001
                 (p_tran_id                    , p_fund_cd                  , p_branch_cd              ,
                  acc_entries.gl_acct_category , acc_entries.gl_control_acct, acc_entries.gl_sub_acct_1,
                  acc_entries.gl_sub_acct_2    , acc_entries.gl_sub_acct_3  , acc_entries.gl_sub_acct_4,
                  acc_entries.gl_sub_acct_5    , acc_entries.gl_sub_acct_6  , acc_entries.gl_sub_acct_7,
                  acc_entries.sl_cd            , v_gen_type                 , acc_entries.sl_type_cd        ,
                  acc_entries.gl_acct_id       , acc_entries.credit_amt     , acc_entries.debit_amt);
            END LOOP;
        ELSE
        -- end robert 03.11.14 
            FOR acc_entries IN (SELECT gl_acct_category    , gl_control_acct    ,
                                       gl_sub_acct_1        , gl_sub_acct_2        ,
                                       gl_sub_acct_3        , gl_sub_acct_4        ,
                                       gl_sub_acct_5        , gl_sub_acct_6        ,
                                       gl_sub_acct_7        , sl_cd                ,
                                       sl_type_cd           , gl_acct_id           ,
                                       debit_amt            , credit_amt
                                  FROM giac_acct_entries
                                 WHERE gacc_tran_id = v_rcm_tran_id)
            LOOP                 
                giac_acct_entries_pkg.aeg_ins_upd_rcm_entr_giacs001
                 (p_tran_id                    , p_fund_cd                  , p_branch_cd              ,
                  acc_entries.gl_acct_category , acc_entries.gl_control_acct, acc_entries.gl_sub_acct_1,
                  acc_entries.gl_sub_acct_2    , acc_entries.gl_sub_acct_3  , acc_entries.gl_sub_acct_4,
                  acc_entries.gl_sub_acct_5    , acc_entries.gl_sub_acct_6  , acc_entries.gl_sub_acct_7,
                  acc_entries.sl_cd            , v_gen_type                 , acc_entries.sl_type_cd        ,
                  acc_entries.gl_acct_id       , acc_entries.credit_amt     , acc_entries.debit_amt);
            END LOOP;
        END IF; --added by rrobert 03.11.14 
        --END LOOP; --mikel 09.09.2015; genqa 4790
         
         --Added by Nica 06.28.2013 AC-SPECS-2013-073_GIACS001
         /*IF NVL(giacp.v('OUTFACUL_COMM_VAT_ENTRY'),'DV') = 'OR' and NVL(giacp.v('COMM_REC_BATCH_TAKEUP'),'N') = 'Y' THEN
                giac_acct_entries_pkg.create_acct_entries_giacs001
                                              (v_module_id,
                                               5,
                                               v_ri_local_rec_comm_vat,
                                               v_gen_type,
                                               p_branch_cd,
                                               p_fund_cd,
                                               p_tran_id,
                                               NVL (giis_users_pkg.app_user,
                                                    USER
                                                   ),
                                               p_sl_cd,
                                               p_sl_type_cd,
                                               p_message
                                              );
                                              
                 giac_acct_entries_pkg.create_acct_entries_giacs001
                                              (v_module_id,
                                               6,
                                               v_ri_local_rec_comm_vat,
                                               v_gen_type,
                                               p_branch_cd,
                                               p_fund_cd,
                                               p_tran_id,
                                               NVL (giis_users_pkg.app_user,
                                                    USER
                                                   ),
                                               p_sl_cd,
                                               p_sl_type_cd,
                                               p_message
                                              );
                                       
         ELSIF NVL(giacp.v('OUTFACUL_COMM_VAT_ENTRY'),'DV') = 'OR' and NVL(giacp.v('COMM_REC_BATCH_TAKEUP'),'N') = 'N' THEN
        
                giac_acct_entries_pkg.create_acct_entries_giacs001
                                              (v_module_id,
                                               5,
                                               v_ri_local_comm_vat,
                                               v_gen_type,
                                               p_branch_cd,
                                               p_fund_cd,
                                               p_tran_id,
                                               NVL (giis_users_pkg.app_user,
                                                    USER
                                                   ),
                                               p_sl_cd,
                                               p_sl_type_cd,
                                               p_message
                                              );
                                              
                 giac_acct_entries_pkg.create_acct_entries_giacs001
                                              (v_module_id,
                                               6,
                                               v_ri_local_comm_vat,
                                               v_gen_type,
                                               p_branch_cd,
                                               p_fund_cd,
                                               p_tran_id,
                                               NVL (giis_users_pkg.app_user,
                                                    USER
                                                   ),
                                               p_sl_cd,
                                               p_sl_type_cd,
                                               p_message
                                              );
          */ --mikel 09.24.2015; GENQA RSIC 4984 - comment out and replaced by codes below
         --start mikel 09.24.2015 
         IF  NVL(giacp.v('OUTFACUL_COMM_VAT_ENTRY'),'DV') = 'OR' THEN
                giac_acct_entries_pkg.create_acct_entries_giacs001
                                              (v_module_id,
                                               5,
                                               v_rcm_comm_vat,
                                               v_gen_type,
                                               p_branch_cd,
                                               p_fund_cd,
                                               p_tran_id,
                                               NVL (giis_users_pkg.app_user,
                                                    USER
                                                   ),
                                               p_sl_cd,
                                               p_sl_type_cd,
                                               p_message
                                              );
                                              
                 giac_acct_entries_pkg.create_acct_entries_giacs001
                                              (v_module_id,
                                               6,
                                               v_rcm_comm_vat,
                                               v_gen_type,
                                               p_branch_cd,
                                               p_fund_cd,
                                               p_tran_id,
                                               NVL (giis_users_pkg.app_user,
                                                    USER
                                                   ),
                                               p_sl_cd,
                                               p_sl_type_cd,
                                               p_message
                                              );
         --end mikel 09.24.2015                                         
         --mikel 09.28.2013  AC-SPECS-2013-090                                              
         ELSIF NVL(giacp.v('OUTFACUL_COMM_VAT_ENTRY'),'DV') = 'CO' THEN
         
           /* removed by robert 03.11.14
            --mikel 09.30.2013 
            SELECT SUM (NVL (c.comm_vat, 0)) comm_vat
              INTO v_rcm_comm_vat
              FROM giac_collection_dtl a, giac_cm_dm b, giac_outfacul_prem_payts c
             WHERE 1 = 1
               AND a.cm_tran_id = b.gacc_tran_id
               AND b.dv_tran_id = c.gacc_tran_id
               AND a.gacc_tran_id = p_tran_id;
             */
             
             -- added by robert 03.11.14
              SELECT SUM (NVL (debit_amt, 0)) - SUM (NVL (credit_amt, 0)) comm_vat
                INTO v_rcm_comm_vat
                FROM giac_acct_entries
               WHERE gacc_tran_id = v_rcm_tran_id
                 AND gl_acct_id = v_deferred_vat_id;
            
             IF v_rcm_comm_vat != 0 THEN --mikel 12.09.2013   
                giac_acct_entries_pkg.create_acct_entries_giacs001
                                              (v_module_id,
                                               6, --changed from 5 to 6 by robert 03.11.14
                                               v_rcm_comm_vat,
                                               v_gen_type,
                                               p_branch_cd,
                                               p_fund_cd,
                                               p_tran_id,
                                               NVL (giis_users_pkg.app_user,
                                                    USER
                                                   ),
                                               p_sl_cd,
                                               p_sl_type_cd,
                                               p_message
                                              );           
             END IF;                                                                    
         END IF;    
        --End here Nica 06.28.13
                            
         DECLARE
                v_exists    NUMBER := 0;
         BEGIN
            SELECT DISTINCT 1
                INTO v_exists
              FROM giac_collection_dtl
             WHERE gacc_tran_id = p_tran_id
               AND pay_mode = 'RCM';
            IF v_exists = 1 THEN
                
                /*IF NVL(giacp.v('COMM_REC_BATCH_TAKEUP'),'N') = 'Y' THEN
                    giac_acct_entries_pkg.ins_rcm_into_op_text_giacs001
                    (p_tran_id              , v_gen_type,
                     v_ri_local_rec_comm_amt, v_ri_local_rec_comm_vat,
                     v_ri_foreign_rec_comm_amt, v_ri_foreign_rec_comm_vat,
                     v_currency_rt);
                ELSE*/ --mikel 09.30.2013
                    /* 
                    giac_acct_entries_pkg.ins_rcm_into_op_text_giacs001
                    (p_tran_id          , v_gen_type,
                     v_ri_local_comm_amt, v_ri_local_comm_vat,
                     v_ri_foreign_comm_amt, v_ri_foreign_comm_vat,
                     v_currency_rt);
                     */ -- removed by robert 03.11.14
                --END IF;
                
                --added by robert 03.11.14
                /*IF NVL(giacp.v('COMM_REC_BATCH_TAKEUP'),'N') = 'Y' THEN
                        IF NVL(giacp.v('OUTFACUL_COMM_VAT_ENTRY'),'DV') = 'CO' THEN
                            giac_acct_entries_pkg.ins_rcm_into_op_text_giacs001
                            (p_tran_id          , v_gen_type,
                             v_ri_local_comm_amt, v_ri_local_comm_vat,
                             v_ri_foreign_comm_amt, v_ri_foreign_comm_vat,
                             v_currency_cd);
                        ELSE
                            giac_acct_entries_pkg.ins_rcm_into_op_text_giacs001
                            (p_tran_id          , v_gen_type,
                             v_ri_local_rec_comm_amt, v_ri_local_rec_comm_vat,
                             v_ri_foreign_rec_comm_amt, v_ri_foreign_rec_comm_vat,
                             v_currency_cd);
                        END IF;
                 ELSE
                        giac_acct_entries_pkg.ins_rcm_into_op_text_giacs001
                        (p_tran_id          , v_gen_type,
                         v_ri_local_comm_amt, v_ri_local_comm_vat,
                         v_ri_foreign_comm_amt, v_ri_foreign_comm_vat,
                         v_currency_cd);
                 END IF;*/ --mikel 09.24.2015; GENQA RSIC 4984 - comment out and replaced by codes below
                --start mikel 09.24.2015
                giac_acct_entries_pkg.ins_rcm_into_op_text_giacs001
                        (p_tran_id          , v_gen_type,
                         v_rcm_comm_amt, v_rcm_comm_vat,
                         v_rcm_comm_amt / v_currency_rt, v_rcm_comm_vat / v_currency_rt,
                         v_currency_cd);
               --end mikel 09.24.2015          
            ELSE
                NULL;
                --end robert 03.11.14
            END IF;
         EXCEPTION
              WHEN NO_DATA_FOUND THEN
                 NULL;
         END;
        END LOOP; --mikel 09.09.2015; genqa 4790            
       END;
      
   END aeg_parameters_giacs001;
   
   /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 06.15.2013
    **  Reference By  : GIACS001- OR Information
    **  Description   : For AC-SPECS-2012-155
    **                  This procedure determines whether the records will be 
    **                  updated or inserted in GIAC_ACCT_ENTRIES. 
    **                  AEG_INSERT_UPDATE_RCM_ENTRIES Program Unit                  
    */

    PROCEDURE aeg_ins_upd_rcm_entr_giacs001
    (p_gacc_tran_id         giac_acct_entries.gacc_tran_id%TYPE,
     p_gacc_fund_cd         giac_acct_entries.gacc_gfun_fund_cd%TYPE,
     p_gacc_branch_cd       giac_acct_entries.gacc_gibr_branch_cd%TYPE,
     iuae_gl_acct_category  giac_acct_entries.gl_acct_category%TYPE,
     iuae_gl_control_acct   giac_acct_entries.gl_control_acct%TYPE,
     iuae_gl_sub_acct_1     giac_acct_entries.gl_sub_acct_1%TYPE,
     iuae_gl_sub_acct_2     giac_acct_entries.gl_sub_acct_2%TYPE,
     iuae_gl_sub_acct_3     giac_acct_entries.gl_sub_acct_3%TYPE,
     iuae_gl_sub_acct_4     giac_acct_entries.gl_sub_acct_4%TYPE,
     iuae_gl_sub_acct_5     giac_acct_entries.gl_sub_acct_5%TYPE,
     iuae_gl_sub_acct_6     giac_acct_entries.gl_sub_acct_6%TYPE,
     iuae_gl_sub_acct_7     giac_acct_entries.gl_sub_acct_7%TYPE,
     iuae_sl_cd             giac_acct_entries.sl_cd%TYPE,
     iuae_generation_type   giac_acct_entries.generation_type%TYPE,
     iuae_sl_type_cd        giac_acct_entries.sl_type_cd%TYPE,
     iuae_gl_acct_id        giac_chart_of_accts.gl_acct_id%TYPE,
     iuae_debit_amt         giac_acct_entries.debit_amt%TYPE,
     iuae_credit_amt        giac_acct_entries.credit_amt%TYPE) IS
          
     iuae_acct_entry_id     giac_acct_entries.acct_entry_id%TYPE;
     
     v_rcm_vat_gl_id        giac_chart_of_accts.gl_acct_id%TYPE; --mikel 09.30.2013
     v_outfaul_comm_vat_entry GIAC_PARAMETERS.param_value_v%TYPE := NVL (giacp.v ('OUTFACUL_COMM_VAT_ENTRY'), 'DV'); --mikel 09.30.2013

    
    BEGIN
    
      SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM GIAC_ACCT_ENTRIES
       WHERE gacc_gibr_branch_cd = p_gacc_branch_cd
         AND gacc_gfun_fund_cd   = p_gacc_fund_cd 
         AND gacc_tran_id        = p_gacc_tran_id 
         AND gl_acct_id          = iuae_gl_acct_id
         AND generation_type     = iuae_generation_type
         AND NVL(sl_cd,0)        = NVL(iuae_sl_cd, 0); --mikel 09.30.2013;
     
       --mikel 09.30.2013 AC-SPECS-2013-092 
       IF v_outfaul_comm_vat_entry = 'CO'
       THEN
          SELECT gl_acct_id
            INTO v_rcm_vat_gl_id
            FROM giac_module_entries a, giac_modules b, giac_chart_of_accts c
           WHERE 1 = 1
             AND a.module_id = b.module_id
             AND b.module_name = 'GIACS071'
             AND a.item_no = 4
             AND a.gl_acct_category = c.gl_acct_category
             AND a.gl_control_acct = c.gl_control_acct
             AND a.gl_sub_acct_1 = c.gl_sub_acct_1
             AND a.gl_sub_acct_2 = c.gl_sub_acct_2
             AND a.gl_sub_acct_3 = c.gl_sub_acct_3
             AND a.gl_sub_acct_4 = c.gl_sub_acct_4
             AND a.gl_sub_acct_5 = c.gl_sub_acct_5
             AND a.gl_sub_acct_6 = c.gl_sub_acct_6
             AND a.gl_sub_acct_7 = c.gl_sub_acct_7;
       END IF;
    
        
      IF nvl(iuae_acct_entry_id,0) = 0 THEN
        iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;
        
        IF v_outfaul_comm_vat_entry != 'CO' 
            OR (v_outfaul_comm_vat_entry = 'CO' AND v_rcm_vat_gl_id != iuae_gl_acct_id) THEN --mikel 09.30.2013
            INSERT INTO GIAC_ACCT_ENTRIES(gacc_tran_id       , gacc_gfun_fund_cd,
                                          gacc_gibr_branch_cd, acct_entry_id    ,
                                          gl_acct_id         , gl_acct_category ,
                                          gl_control_acct    , gl_sub_acct_1    ,
                                          gl_sub_acct_2      , gl_sub_acct_3    ,
                                          gl_sub_acct_4      , gl_sub_acct_5    ,
                                          gl_sub_acct_6      , gl_sub_acct_7    ,
                                          sl_cd              , generation_type  ,
                                          sl_type_cd         , credit_amt       ,
                                          debit_amt          , user_id          ,
                                          last_update)
               VALUES (p_gacc_tran_id                , p_gacc_fund_cd              ,
                       p_gacc_branch_cd              , iuae_acct_entry_id          ,
                       iuae_gl_acct_id               , iuae_gl_acct_category       ,
                       iuae_gl_control_acct          , iuae_gl_sub_acct_1          ,
                       iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3          ,
                       iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5          ,
                       iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7          ,
                       iuae_sl_cd                    , iuae_generation_type        ,
                       iuae_sl_type_cd               , iuae_credit_amt             ,
                       iuae_debit_amt                , NVL(giis_users_pkg.app_user, USER),
                       SYSDATE);            
        END IF; --end mikel 09.30.2013
      ELSE
        UPDATE GIAC_ACCT_ENTRIES
           SET debit_amt  = debit_amt  + iuae_debit_amt,
               credit_amt = credit_amt + iuae_credit_amt
         WHERE generation_type     = iuae_generation_type
           AND gl_acct_id          = iuae_gl_acct_id
           AND gacc_gibr_branch_cd = p_gacc_branch_cd 
           AND gacc_gfun_fund_cd   = p_gacc_fund_cd
           AND gacc_tran_id        = p_gacc_tran_id
           AND NVL(sl_cd,0)        = NVL(iuae_sl_cd, 0); --mikel 09.30.2013;
      END IF;
    END;
    
   /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 06.15.2013
    **  Reference By  : GIACS001- OR Information
    **  Description   : For AC-SPECS-2012-155
    **                  INSERT_INTO_OP_TEXT Program Unit                                    
    */

    PROCEDURE ins_rcm_into_op_text_giacs001 
        (p_gacc_tran_id           giac_op_text.gacc_tran_id%TYPE,
         p_gen_type               giac_modules.generation_type%TYPE,
         p_ri_local_comm_amt      giac_op_text.item_amt%TYPE,
         p_ri_local_comm_vat      giac_op_text.item_amt%TYPE,
         p_ri_foreign_comm_amt    giac_op_text.item_amt%TYPE,
         p_ri_foreign_comm_vat    giac_op_text.item_amt%TYPE,
         p_currency_cd            giac_op_text.currency_cd%TYPE)
    IS
    BEGIN

        /*INSERT INTO GIAC_OP_TEXT
           (gacc_tran_id, item_seq_no, print_seq_no, item_amt,
            item_gen_type, item_text, currency_cd, foreign_curr_amt,
            user_id, last_update)
         VALUES
           (p_gacc_tran_id, 1, 1, p_ri_local_comm_amt,
            p_gen_type, 'RI COMMISSION', p_currency_cd, p_ri_foreign_comm_amt,
            NVL(giis_users_pkg.app_user, USER), SYSDATE);
            
        IF NVL(giacp.v('COMM_REC_BATCH_TAKEUP'),'N') != 'Y' 
           OR NVL (giacp.v ('OUTFACUL_COMM_VAT_ENTRY'), 'DV') = 'CO' THEN --added by mikel 09.30.2013
            INSERT INTO GIAC_OP_TEXT
               (gacc_tran_id, item_seq_no, print_seq_no, item_amt,
                item_gen_type, item_text, currency_cd, foreign_curr_amt,
                user_id, last_update)
             VALUES
               (p_gacc_tran_id, 2, 2, p_ri_local_comm_vat,
                p_gen_type, 'RI COMMISSION VAT', p_currency_cd, p_ri_foreign_comm_vat,
                NVL(giis_users_pkg.app_user, USER), SYSDATE);
        END IF;*/ --mikel 09.09.2015; comment out and replaced by codes below - FGIC 20143
        
      --start mikel 09.04.2015
      MERGE INTO giac_op_text
           USING DUAL
              ON (    gacc_tran_id = p_gacc_tran_id
                  AND item_gen_type = p_gen_type
                  AND item_text = 'RI COMMISSION')
      WHEN NOT MATCHED
      THEN
         INSERT     (gacc_tran_id, item_seq_no, print_seq_no,
                     item_amt, item_gen_type, item_text,
                     currency_cd, foreign_curr_amt, user_id,
                     last_update)
             VALUES (p_gacc_tran_id, 1, 1,
                     p_ri_local_comm_amt, p_gen_type, 'RI COMMISSION',
                     p_currency_cd, p_ri_foreign_comm_amt,
                     NVL (giis_users_pkg.app_user, USER),
                     SYSDATE)
      WHEN MATCHED
      THEN
         UPDATE SET item_amt = item_amt + p_ri_local_comm_amt,
                    foreign_curr_amt = foreign_curr_amt + p_ri_foreign_comm_amt,
                    user_id = NVL (giis_users_pkg.app_user, USER),
                    last_update = SYSDATE;

      /*IF    NVL (giacp.v ('COMM_REC_BATCH_TAKEUP'), 'N') != 'Y'
         OR NVL (giacp.v ('OUTFACUL_COMM_VAT_ENTRY'), 'DV') = 'CO'
      THEN */                                        --added by mikel 09.30.2013
         MERGE INTO giac_op_text
              USING DUAL
                 ON (    gacc_tran_id = p_gacc_tran_id
                     AND item_gen_type = p_gen_type
                     AND item_text = 'RI COMMISSION VAT')
         WHEN NOT MATCHED
         THEN
            INSERT     (gacc_tran_id, item_seq_no, print_seq_no,
                        item_amt, item_gen_type, item_text,
                        currency_cd, foreign_curr_amt, user_id,
                        last_update)
                VALUES (p_gacc_tran_id, 2, 2,
                        p_ri_local_comm_vat, p_gen_type, 'RI COMMISSION VAT',
                        p_currency_cd, p_ri_foreign_comm_vat,
                        NVL (giis_users_pkg.app_user, USER),
                        SYSDATE)
         WHEN MATCHED
         THEN
            UPDATE SET item_amt = item_amt + p_ri_local_comm_vat,
                       foreign_curr_amt = foreign_curr_amt + p_ri_foreign_comm_vat,
                       user_id = NVL (giis_users_pkg.app_user, USER),
                       last_update = SYSDATE;
      --END IF;
      --end mikel
    END;

   PROCEDURE delete_acct_entries_giacs001 (
      p_gacc_tran_id   giac_acct_entries.gacc_tran_id%TYPE,
      p_gen_type       giac_modules.generation_type%TYPE
   )
   IS
      dummy   VARCHAR2 (1);

      CURSOR ae
      IS
         SELECT '1'
           FROM giac_acct_entries
          WHERE gacc_tran_id = p_gacc_tran_id
                AND generation_type = p_gen_type;
   BEGIN
      OPEN ae;

      FETCH ae
       INTO dummy;

      IF SQL%FOUND
      THEN
         /**************************************************************************
         *                                                                         *
         * Delete all records existing in GIAC_ACCT_ENTRIES table having the same  *
         * tran_id as :GLOBAL.cg$giop_gacc_tran_id.                                *
         *                                                                         *
         **************************************************************************/
         DELETE FROM giac_acct_entries
               WHERE gacc_tran_id = p_gacc_tran_id
                 AND generation_type = p_gen_type;
      END IF;
   END delete_acct_entries_giacs001;

   PROCEDURE aeg_create_cib_giacs001 (
      p_bank_cd              giac_banks.bank_cd%TYPE,
      p_bank_acct_cd         giac_bank_accounts.bank_acct_cd%TYPE,
      p_acct_amt             giac_collection_dtl.amount%TYPE,
      p_gen_type             giac_acct_entries.generation_type%TYPE,
      p_gacc_tran_id         giac_acct_entries.gacc_tran_id%TYPE,
      p_branch_cd            giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_fund_cd              giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_message        OUT   VARCHAR2
   )
   IS
      v_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE;
      v_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE;
      v_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE;
      v_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE;
      v_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE;
      v_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE;
      v_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE;
      v_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE;
      v_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE;
      v_dr_cr_tag          giac_chart_of_accts.dr_cr_tag%TYPE;
      v_debit_amt          giac_acct_entries.debit_amt%TYPE;
      v_credit_amt         giac_acct_entries.credit_amt%TYPE;
      v_gl_acct_id         giac_acct_entries.gl_acct_id%TYPE;
      v_sl_cd              giac_acct_entries.sl_cd%TYPE;
      v_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE;
      v_acct_entry_id      giac_acct_entries.acct_entry_id%TYPE;
      v_sl_source_cd       giac_acct_entries.sl_source_cd%TYPE       := '1';
   BEGIN
      BEGIN
         SELECT gl_acct_id, sl_cd
           INTO v_gl_acct_id, v_sl_cd
           FROM giac_bank_accounts
          WHERE bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message :=
                  'No data found in giac_bank_accounts for bank_cd/bank_acct_cd: '
               || p_bank_cd
               || '/'
               || p_bank_acct_cd;
      END;

      BEGIN
         SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
                gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                dr_cr_tag, gslt_sl_type_cd
           INTO v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1,
                v_gl_sub_acct_2, v_gl_sub_acct_3, v_gl_sub_acct_4,
                v_gl_sub_acct_5, v_gl_sub_acct_6, v_gl_sub_acct_7,
                v_dr_cr_tag, v_sl_type_cd
           FROM giac_chart_of_accts
          WHERE gl_acct_id = v_gl_acct_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message :=
                  'No record in the Chart of Accounts for this GL ID '
               || TO_CHAR (v_gl_acct_id, 'fm999999');
      END;

      /****************************************************************************
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      ****************************************************************************/
      IF v_dr_cr_tag = 'D'
      THEN
         v_debit_amt := ABS (p_acct_amt);
         v_credit_amt := 0;
      ELSE
         v_debit_amt := 0;
         v_credit_amt := ABS (p_acct_amt);
      END IF;

      /****************************************************************************
      * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      ****************************************************************************/
      BEGIN
         SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
           INTO v_acct_entry_id
           FROM giac_acct_entries
          WHERE gacc_gibr_branch_cd = p_branch_cd
            AND gacc_gfun_fund_cd = p_fund_cd
            AND gacc_tran_id = p_gacc_tran_id
            AND NVL (gl_acct_id, gl_acct_id) = v_gl_acct_id
            --totel--1/30/2008--Tune--Added NVL function
            AND generation_type = p_gen_type
            AND NVL (sl_cd, 0) = NVL (v_sl_cd, NVL (sl_cd, 0))
            AND NVL (sl_type_cd, '-') =
                                     NVL (v_sl_type_cd, NVL (sl_type_cd, '-'))
            AND NVL (sl_source_cd, '-') =
                                 NVL (v_sl_source_cd, NVL (sl_source_cd, '-'));

         IF NVL (v_acct_entry_id, 0) = 0
         THEN
            v_acct_entry_id := NVL (v_acct_entry_id, 0) + 1;

            INSERT INTO giac_acct_entries
                        (gacc_tran_id, gacc_gfun_fund_cd,
                         gacc_gibr_branch_cd, acct_entry_id, gl_acct_id,
                         gl_acct_category, gl_control_acct,
                         gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                         gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                         gl_sub_acct_7, sl_cd, debit_amt,
                         credit_amt, generation_type,
                         user_id, last_update,
                         sl_type_cd, sl_source_cd
                        )
                 VALUES (p_gacc_tran_id, p_fund_cd,
                         p_branch_cd, v_acct_entry_id, v_gl_acct_id,
                         v_gl_acct_category, v_gl_control_acct,
                         v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3,
                         v_gl_sub_acct_4, v_gl_sub_acct_5, v_gl_sub_acct_6,
                         v_gl_sub_acct_7, v_sl_cd, v_debit_amt,
                         v_credit_amt, p_gen_type,
                         NVL (giis_users_pkg.app_user, USER), SYSDATE,
                         v_sl_type_cd, v_sl_source_cd
                        );
         ELSE
            UPDATE giac_acct_entries
               SET debit_amt = debit_amt + v_debit_amt,
                   credit_amt = credit_amt + v_credit_amt,
                   user_id = NVL (giis_users_pkg.app_user, USER),
                   last_update = SYSDATE
             WHERE gacc_tran_id = p_gacc_tran_id
               AND gacc_gibr_branch_cd = p_branch_cd
               AND gacc_gfun_fund_cd = p_fund_cd
               AND gl_acct_id = v_gl_acct_id
               AND NVL (sl_cd, 0) = NVL (v_sl_cd, NVL (sl_cd, 0))
               AND NVL (sl_type_cd, '-') =
                                     NVL (v_sl_type_cd, NVL (sl_type_cd, '-'))
               AND NVL (sl_source_cd, '-') =
                                 NVL (v_sl_source_cd, NVL (sl_source_cd, '-'))
               AND generation_type = p_gen_type;
         END IF;
      END;
   END aeg_create_cib_giacs001;

   PROCEDURE create_acct_entries_giacs001 (
      p_module_id            giac_module_entries.module_id%TYPE,
      p_item_no              giac_module_entries.item_no%TYPE,
      p_acct_amt             giac_direct_prem_collns.collection_amt%TYPE,
      p_gen_type             giac_acct_entries.generation_type%TYPE,
      p_branch_cd            giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_fund_cd              giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_tran_id         giac_acct_entries.gacc_tran_id%TYPE,
      p_user_id              giis_users.user_id%TYPE,
      p_sl_cd                giac_acct_entries.sl_cd%TYPE,
      p_sl_type_cd           giac_acct_entries.sl_type_cd%TYPE,
      p_message        OUT   VARCHAR2
   )
   IS
      ws_gl_acct_category     giac_acct_entries.gl_acct_category%TYPE;
      ws_gl_control_acct      giac_acct_entries.gl_control_acct%TYPE;
      ws_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      ws_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      ws_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      ws_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      ws_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      ws_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_pol_type_tag         giac_module_entries.pol_type_tag%TYPE;
      ws_intm_type_level      giac_module_entries.intm_type_level%TYPE;
      ws_old_new_acct_level   giac_module_entries.old_new_acct_level%TYPE;
      ws_line_dep_level       giac_module_entries.line_dependency_level%TYPE;
      ws_dr_cr_tag            giac_module_entries.dr_cr_tag%TYPE;
      ws_acct_intm_cd         giis_intm_type.acct_intm_cd%TYPE;
      ws_line_cd              giis_line.line_cd%TYPE;
      ws_iss_cd               gipi_polbasic.iss_cd%TYPE;
      ws_old_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      ws_new_acct_cd          giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_1        giac_acct_entries.gl_sub_acct_1%TYPE;
      pt_gl_sub_acct_2        giac_acct_entries.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_3        giac_acct_entries.gl_sub_acct_3%TYPE;
      pt_gl_sub_acct_4        giac_acct_entries.gl_sub_acct_4%TYPE;
      pt_gl_sub_acct_5        giac_acct_entries.gl_sub_acct_5%TYPE;
      pt_gl_sub_acct_6        giac_acct_entries.gl_sub_acct_6%TYPE;
      pt_gl_sub_acct_7        giac_acct_entries.gl_sub_acct_7%TYPE;
      ws_debit_amt            giac_acct_entries.debit_amt%TYPE;
      ws_credit_amt           giac_acct_entries.credit_amt%TYPE;
      ws_gl_acct_id           giac_acct_entries.gl_acct_id%TYPE;
      ws_sl_type_cd           giac_module_entries.sl_type_cd%TYPE; --mikel 09.09.2015; FGIC 20143
      v_sl_cd                 giac_acct_entries.sl_cd%TYPE; --mikel 09.09.2015; FGIC 20143
      
   BEGIN
--msg_alert('AEG CREATE ACCT ENTRIES...','I',FALSE);

      /**************************************************************************
      *                                                                         *
      * Populate the GL Account Code used in every transactions.                *
      *                                                                         *
      **************************************************************************/
      BEGIN
         SELECT        gl_acct_category, gl_control_acct,
                       gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                       gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                       gl_sub_acct_7, pol_type_tag,
                       intm_type_level, old_new_acct_level,
                       dr_cr_tag, line_dependency_level
                       ,sl_type_cd --mikel 09.04.2015; FGIC 20143
                  INTO ws_gl_acct_category, ws_gl_control_acct,
                       ws_gl_sub_acct_1, ws_gl_sub_acct_2, ws_gl_sub_acct_3,
                       ws_gl_sub_acct_4, ws_gl_sub_acct_5, ws_gl_sub_acct_6,
                       ws_gl_sub_acct_7, ws_pol_type_tag,
                       ws_intm_type_level, ws_old_new_acct_level,
                       ws_dr_cr_tag, ws_line_dep_level
                       ,ws_sl_type_cd  --mikel 09.04.2015; FGIC 20143
                  FROM giac_module_entries
                 WHERE module_id = p_module_id AND item_no = p_item_no
         FOR UPDATE OF gl_sub_acct_1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message :=
               'No data found in giac_module_entries: GIACS001 - Order of Payments';
      END;

      IF p_message IS NOT NULL
      THEN
         raise_application_error(-20001, 'Geniisys Exception#E#'||p_message);
      END IF;
      
      /**************************************************************************
      *                                                                         *
      * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
      *                                                                         *
      **************************************************************************/
      giac_acct_entries_pkg.aeg_check_chart_of_accts (ws_gl_acct_category,
                                                      ws_gl_control_acct,
                                                      ws_gl_sub_acct_1,
                                                      ws_gl_sub_acct_2,
                                                      ws_gl_sub_acct_3,
                                                      ws_gl_sub_acct_4,
                                                      ws_gl_sub_acct_5,
                                                      ws_gl_sub_acct_6,
                                                      ws_gl_sub_acct_7,
                                                      ws_gl_acct_id,
                                                      p_message
                                                     );

      IF p_message IS NOT NULL
      THEN
         RETURN;
      END IF;

      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/
      IF ws_dr_cr_tag = 'D'
      THEN
         IF p_acct_amt > 0
         THEN
            ws_debit_amt := ABS (p_acct_amt);
            ws_credit_amt := 0;
         ELSE
            ws_debit_amt := 0;
            ws_credit_amt := ABS (p_acct_amt);
         END IF;
      ELSE
         IF p_acct_amt > 0
         THEN
            ws_debit_amt := 0;
            ws_credit_amt := ABS (p_acct_amt);
         ELSE
            ws_debit_amt := ABS (p_acct_amt);
            ws_credit_amt := 0;
         END IF;
      END IF;

      /****************************************************************************
      *                                                                           *
      * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      *                                                                           *
      ****************************************************************************/
      
      --added by mikel 09.09.2015 FGIC 20143
      IF ws_sl_type_cd IS NOT NULL
      THEN
         v_sl_cd := p_sl_cd;
      END IF;
      
      giac_acct_entries_pkg.insert_update_acct_entries (ws_gl_acct_category,
                                                        ws_gl_control_acct,
                                                        ws_gl_sub_acct_1,
                                                        ws_gl_sub_acct_2,
                                                        ws_gl_sub_acct_3,
                                                        ws_gl_sub_acct_4,
                                                        ws_gl_sub_acct_5,
                                                        ws_gl_sub_acct_6,
                                                        ws_gl_sub_acct_7,
                                                        --p_sl_cd,
                                                        v_sl_cd, --mikel 09.09.2015; FGIC 20143
                                                        p_sl_type_cd,
                                                        p_gen_type,
                                                        ws_gl_acct_id,
                                                        ws_debit_amt,
                                                        ws_credit_amt,
                                                        p_branch_cd,
                                                        p_fund_cd,
                                                        p_gacc_tran_id,
                                                        p_user_id
                                                       );
   END create_acct_entries_giacs001;

   /*
   ** Created By:       D.Alcantara
   ** Date Created:     05/16/2011
   ** Reference By:     GIACS035 - Close DCB
   ** Description:
   */
   PROCEDURE aeg_balancing_entries_giacs035 (
      p_module_name   IN       giac_modules.module_name%TYPE,
      p_tran_id       IN       giac_acct_entries.gacc_tran_id%TYPE,
      p_branch_cd     IN       giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_fund_cd       IN       giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_item_no       IN       giac_module_entries.item_no%TYPE,
      p_with_pdc      IN       VARCHAR2,
      p_user          IN       giis_users.user_id%TYPE,
      p_mesg          OUT      VARCHAR2
   )
   IS
      v_gen_type           giac_modules.generation_type%TYPE;
      v_amount             giac_dcb_bank_dep.amount%TYPE;
      cm_exists            VARCHAR2 (1);
      v_amt_wo_cm          giac_dcb_bank_dep.amount%TYPE;
      v_module_id          giac_modules.module_id%TYPE;
      v_gl_acct_category   giac_module_entries.gl_acct_category%TYPE;
      v_gl_control_acct    giac_module_entries.gl_control_acct%TYPE;
      v_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%TYPE;
      v_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%TYPE;
      v_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%TYPE;
      v_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%TYPE;
      v_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%TYPE;
      v_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%TYPE;
      v_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%TYPE;
      v_dr_cr_tag          giac_module_entries.dr_cr_tag%TYPE;
      v_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE;
      v_acct_entry_id      giac_acct_entries.acct_entry_id%TYPE;
      v_sl_cd              giac_acct_entries.sl_cd%TYPE               := NULL;
      v_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE          := NULL;
      v_sl_source_cd       giac_acct_entries.sl_source_cd%TYPE        := NULL;
      v_debit_amt          giac_acct_entries.debit_amt%TYPE;
      v_credit_amt         giac_acct_entries.credit_amt%TYPE;
   BEGIN
      p_mesg := 'Y';

      BEGIN
         SELECT generation_type
           INTO v_gen_type
           FROM giac_modules
          WHERE module_name = p_module_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_mesg := 'GIACS035 has no generation type in giac_modules.';
      END;

      BEGIN
         IF p_with_pdc = 'Y'
         THEN
            SELECT NVL (SUM (amount), 0)
              INTO v_amount
              FROM giac_dcb_bank_dep
             WHERE gacc_tran_id = p_tran_id AND pay_mode = 'PDC';
         ELSE
            SELECT NVL (SUM (amount), 0)
              INTO v_amount
              FROM giac_dcb_bank_dep
             WHERE gacc_tran_id = p_tran_id;
         END IF;

         IF v_amount = 0
         THEN
            p_mesg := 'Bank deposit amount is zero.';
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_mesg := 'Bank deposit record not found.';
      END;

      BEGIN
         SELECT module_id
           INTO v_module_id
           FROM giac_modules
          WHERE module_name = 'GIACS001';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_mesg := 'No data found in giac_modules.';
      END;

      BEGIN
         SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
                gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                dr_cr_tag
           INTO v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1,
                v_gl_sub_acct_2, v_gl_sub_acct_3, v_gl_sub_acct_4,
                v_gl_sub_acct_5, v_gl_sub_acct_6, v_gl_sub_acct_7,
                v_dr_cr_tag
           FROM giac_module_entries
          WHERE module_id = v_module_id AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_mesg := 'No data found in giac_module_entries.';
      END;

      BEGIN
         SELECT DISTINCT gl_acct_id
                    INTO v_gl_acct_id
                    FROM giac_chart_of_accts
                   WHERE gl_acct_category = v_gl_acct_category
                     AND gl_control_acct = v_gl_control_acct
                     AND gl_sub_acct_1 = v_gl_sub_acct_1
                     AND gl_sub_acct_2 = v_gl_sub_acct_2
                     AND gl_sub_acct_3 = v_gl_sub_acct_3
                     AND gl_sub_acct_4 = v_gl_sub_acct_4
                     AND gl_sub_acct_5 = v_gl_sub_acct_5
                     AND gl_sub_acct_6 = v_gl_sub_acct_6
                     AND gl_sub_acct_7 = v_gl_sub_acct_7
                     AND leaf_tag = 'Y';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            BEGIN
               p_mesg :=
                     'GL account code '
                  || TO_CHAR (v_gl_acct_category)
                  || '-'
                  || TO_CHAR (v_gl_control_acct, '09')
                  || '-'
                  || TO_CHAR (v_gl_sub_acct_1, '09')
                  || '-'
                  || TO_CHAR (v_gl_sub_acct_2, '09')
                  || '-'
                  || TO_CHAR (v_gl_sub_acct_3, '09')
                  || '-'
                  || TO_CHAR (v_gl_sub_acct_4, '09')
                  || '-'
                  || TO_CHAR (v_gl_sub_acct_5, '09')
                  || '-'
                  || TO_CHAR (v_gl_sub_acct_6, '09')
                  || '-'
                  || TO_CHAR (v_gl_sub_acct_7, '09')
                  || ' does not exist in the Chart of Accounts.';
            END;
      END;

      IF v_dr_cr_tag = 'D'
      THEN
         v_debit_amt := 0;
         v_credit_amt := ABS (v_amount);
      ELSIF v_dr_cr_tag = 'C'
      THEN
         v_debit_amt := ABS (v_amount);
         v_credit_amt := 0;
      END IF;

      IF p_mesg = 'Y'
      THEN
         BEGIN
            SELECT NVL (MAX (giae.acct_entry_id), 0) acct_entry_id
              INTO v_acct_entry_id
              FROM giac_acct_entries giae
             WHERE giae.gacc_tran_id = p_tran_id
               AND giae.gacc_gibr_branch_cd = p_branch_cd
               AND giae.gacc_gfun_fund_cd = p_fund_cd
               AND NVL (giae.sl_cd, 0) = NVL (v_sl_cd, NVL (giae.sl_cd, 0))
               AND NVL (giae.sl_type_cd, '-') =
                                NVL (v_sl_type_cd, NVL (giae.sl_type_cd, '-'))
               AND NVL (giae.sl_source_cd, '-') =
                            NVL (v_sl_source_cd, NVL (giae.sl_source_cd, '-'))
               AND giae.generation_type = v_gen_type
               AND giae.gl_acct_id = v_gl_acct_id;

            IF NVL (v_acct_entry_id, 0) = 0
            THEN
               v_acct_entry_id := NVL (v_acct_entry_id, 0) + 1;

               INSERT INTO giac_acct_entries
                           (gacc_tran_id, gacc_gfun_fund_cd,
                            gacc_gibr_branch_cd, acct_entry_id, gl_acct_id,
                            gl_acct_category, gl_control_acct,
                            gl_sub_acct_1, gl_sub_acct_2,
                            gl_sub_acct_3, gl_sub_acct_4,
                            gl_sub_acct_5, gl_sub_acct_6,
                            gl_sub_acct_7, sl_cd, debit_amt,
                            credit_amt, generation_type, user_id,
                            last_update, sl_type_cd, sl_source_cd
                           )
                    VALUES (p_tran_id, p_fund_cd,
                            p_branch_cd, v_acct_entry_id, v_gl_acct_id,
                            v_gl_acct_category, v_gl_control_acct,
                            v_gl_sub_acct_1, v_gl_sub_acct_2,
                            v_gl_sub_acct_3, v_gl_sub_acct_4,
                            v_gl_sub_acct_5, v_gl_sub_acct_6,
                            v_gl_sub_acct_7, v_sl_cd, v_debit_amt,
                            v_credit_amt, v_gen_type, NVL (p_user, USER),
                            SYSDATE, v_sl_type_cd, v_sl_source_cd
                           );
            ELSE
               p_mesg := 'Balancing acct entry already exists.';
            END IF;
         END;
      END IF;
   END aeg_balancing_entries_giacs035;

   FUNCTION get_giacs086_acct_entries (
       p_tran_id   giac_acct_entries.gacc_tran_id%TYPE,
      p_gl_acct_category   gicl_acct_entries.gl_acct_category%TYPE,
      p_gl_control_acct    gicl_acct_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1      gicl_acct_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      gicl_acct_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      gicl_acct_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      gicl_acct_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      gicl_acct_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      gicl_acct_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      gicl_acct_entries.gl_sub_acct_7%TYPE,
      p_sl_code            gicl_acct_entries.sl_cd%TYPE,
      p_debit_amt          gicl_acct_entries.debit_amt%TYPE,
      p_credit_amt         gicl_acct_entries.credit_amt%TYPE
   )
      RETURN acct_entries_tab1 PIPELINED
   IS
      v_list   acct_entries_type1;
   BEGIN
      FOR i IN (SELECT TO_CHAR(a.gl_acct_category)|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_control_acct,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_1,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_2,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_3,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_4,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_5,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_6,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_7,'09')) gl_acct_code,a.gl_acct_category,  
                         a.gl_control_acct,   a.gl_sub_acct_1,     a.gl_sub_acct_2,    
                         a.gl_sub_acct_3,     a.gl_sub_acct_4,     a.gl_sub_acct_5,    
                         a.gl_sub_acct_6,     a.gl_sub_acct_7,a.sl_type_cd,a.debit_amt,         a.credit_amt,a.sl_cd
                  FROM giac_acct_entries a
                  where gacc_tran_id = p_tran_id
                  AND a.gl_acct_category LIKE NVL(p_gl_acct_category, a.gl_acct_category)
                    AND a.gl_control_acct LIKE NVL(p_gl_control_acct, a.gl_control_acct)
                    AND a.gl_sub_acct_1 LIKE NVL(p_gl_sub_acct_1, a.gl_sub_acct_1)
                    AND a.gl_sub_acct_2 LIKE NVL(p_gl_sub_acct_2, a.gl_sub_acct_2)
                    AND a.gl_sub_acct_3 LIKE NVL(p_gl_sub_acct_3, a.gl_sub_acct_3)
                    AND a.gl_sub_acct_4 LIKE NVL(p_gl_sub_acct_4, a.gl_sub_acct_4)
                    AND a.gl_sub_acct_5 LIKE NVL(p_gl_sub_acct_5, a.gl_sub_acct_5)
                    AND a.gl_sub_acct_6 LIKE NVL(p_gl_sub_acct_6, a.gl_sub_acct_6)
                    AND a.gl_sub_acct_7 LIKE NVL(p_gl_sub_acct_7, a.gl_sub_acct_7)
                    AND NVL(a.sl_cd, 0) LIKE NVL(p_sl_code, NVL(a.sl_cd, 0))
                    AND NVL(a.debit_amt, 0) LIKE NVL(p_debit_amt, NVL(a.debit_amt, 0))
                    AND NVL(a.credit_amt,0) LIKE NVL(p_credit_amt, NVL(a.credit_amt,0))
                  )
      LOOP
        v_list.dsp_gl_acct_code := i.gl_acct_code;
         v_list.gl_acct_category :=  i.gl_acct_category;  
            v_list.gl_control_acct  :=  i.gl_control_acct;  
            v_list.gl_sub_acct_1    :=  i.gl_sub_acct_1;  
            v_list.gl_sub_acct_2    :=  i.gl_sub_acct_2; 
            v_list.gl_sub_acct_3    :=  i.gl_sub_acct_3; 
            v_list.gl_sub_acct_4    :=  i.gl_sub_acct_4;  
            v_list.gl_sub_acct_5    :=  i.gl_sub_acct_5;  
            v_list.gl_sub_acct_6    :=  i.gl_sub_acct_6; 
            v_list.gl_sub_acct_7    :=  i.gl_sub_acct_7; 
             v_list.sl_cd            :=  i.sl_cd;   
            v_list.debit_amt        :=  i.debit_amt;  
            v_list.credit_amt       :=  i.credit_amt;
            v_list.dsp_gl_acct_name :=  GET_GL_ACCT_NAME_2(i.gl_acct_category,  i.gl_control_acct,   i.gl_sub_acct_1,     
                                                           i.gl_sub_acct_2,     i.gl_sub_acct_3,     i.gl_sub_acct_4,    
                                                           i.gl_sub_acct_5,     i.gl_sub_acct_6,     i.gl_sub_acct_7,      
                                                           i.sl_type_cd,        i.sl_cd);  
                                                           
              BEGIN
                SELECT sl_name
                  INTO v_list.dsp_sl_name
                  FROM giac_sl_lists
                 WHERE sl_type_cd = i.sl_type_cd
                   AND sl_cd      = i.sl_cd;
              EXCEPTION
                  WHEN no_data_found THEN
                    v_list.dsp_sl_name := NULL;
              END;
         PIPE ROW (v_list);
      END LOOP;
   END;
   
   /*
   ** Created By: D.Alcantara, 05/20/2011
   **  Date Created : 12.29.2011
   **  Reference By : (GICLS055 - Generate Recovery Attg. Entries)
   */ 
   PROCEDURE Ins_Updt_Acct_Entries_gicls055 (
        p_recovery_acct_id        gicl_recovery_acct.recovery_acct_id%TYPE,
        p_tran_id                giac_acct_entries.gacc_tran_id%TYPE,
        p_fund_cd                giac_acctrans.gfun_fund_cd%TYPE,
        p_iss_cd                gicl_recovery_acct.iss_cd%TYPE,
        p_user_id                giis_users.user_id%TYPE
    ) IS
      CURSOR cur_acct_entries IS
         SELECT recovery_acct_id,
                GENERATION_TYPE, GL_ACCT_ID, GL_ACCT_CATEGORY, GL_CONTROL_ACCT,
                GL_SUB_ACCT_1, GL_SUB_ACCT_2, GL_SUB_ACCT_3, GL_SUB_ACCT_4,
                GL_SUB_ACCT_5, GL_SUB_ACCT_6, GL_SUB_ACCT_7,
                sl_type_cd, SL_CD, sl_source_cd,
                SUM(DEBIT_AMT) debit_amt, SUM(CREDIT_AMT) credit_amt
           FROM gicl_rec_acct_entries
          WHERE recovery_acct_id = p_recovery_acct_id
          GROUP BY recovery_acct_id,
                   GENERATION_TYPE, GL_ACCT_ID, GL_ACCT_CATEGORY, GL_CONTROL_ACCT,
                   GL_SUB_ACCT_1, GL_SUB_ACCT_2, GL_SUB_ACCT_3, GL_SUB_ACCT_4,
                   GL_SUB_ACCT_5, GL_SUB_ACCT_6, GL_SUB_ACCT_7,
                   sl_type_cd, SL_CD, sl_source_cd;

      v_acct_entry_id giac_acct_entries.acct_entry_id%type default 0;
      
    BEGIN
      FOR al IN cur_acct_entries LOOP
          v_acct_entry_id := v_acct_entry_id + 1;
          INSERT INTO giac_acct_entries (GACC_TRAN_ID, GACC_GFUN_FUND_CD, GACC_GIBR_BRANCH_CD,            
                                         ACCT_ENTRY_ID, GL_ACCT_ID, GL_ACCT_CATEGORY,              
                                         GL_CONTROL_ACCT, GL_SUB_ACCT_1, GL_SUB_ACCT_2,                  
                                         GL_SUB_ACCT_3, GL_SUB_ACCT_4, GL_SUB_ACCT_5,                  
                                         GL_SUB_ACCT_6, GL_SUB_ACCT_7, sl_type_cd, SL_CD, 
                                         sl_source_cd,
                                         DEBIT_AMT, CREDIT_AMT, GENERATION_TYPE,                
                                         USER_ID, LAST_UPDATE)
                                 VALUES (p_tran_id, p_fund_cd, p_iss_cd, 
                                         v_acct_entry_id, al.GL_ACCT_ID, al.GL_ACCT_CATEGORY,
                                         al.GL_CONTROL_ACCT, al.GL_SUB_ACCT_1, al.GL_SUB_ACCT_2,
                                         al.GL_SUB_ACCT_3, al.GL_SUB_ACCT_4, al.GL_SUB_ACCT_5,
                                         al.GL_SUB_ACCT_6, al.GL_SUB_ACCT_7, al.sl_type_cd, al.SL_CD,
                                         al.sl_source_cd,
                                         al.debit_amt, al.credit_amt, al.GENERATION_TYPE,
                                         nvl(p_user_id, USER), SYSDATE);
      END LOOP;
    END Ins_Updt_Acct_Entries_gicls055;
    
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 01.17.2012
    **  Reference By    : (GICLB001 - Batch O/S Takeup)
    **  Description     :  OFFSET_LOSS program unit; 
    **                     This is to insert an account into giac_acct_entries to handle
    **                     the difference, if any, between the total debits and total credits.      
    */
    PROCEDURE offset_loss(
        p_tran_id       giac_acctrans.tran_id%TYPE,
        p_module_id     giac_module_entries.module_id%TYPE,
        p_user_id       giac_acct_entries.user_id%TYPE
    )
    IS
      v_tran           giac_acctrans.tran_id%TYPE                   := p_tran_id;
      v_acct_entry_id  giac_acct_entries.acct_entry_id%TYPE         := 0;
      v_credit         giac_acct_entries.credit_amt%TYPE            := 0;
      v_debit          giac_acct_entries.credit_amt%TYPE            := 0; 
      v_glcat          giac_chart_of_accts.gl_acct_category%TYPE;
      v_gl1            giac_chart_of_accts.gl_sub_acct_1%TYPE;
      v_gl2            giac_chart_of_accts.gl_sub_acct_2%TYPE;
      v_gl3            giac_chart_of_accts.gl_sub_acct_3%TYPE;
      v_gl4            giac_chart_of_accts.gl_sub_acct_4%TYPE;
      v_gl5            giac_chart_of_accts.gl_sub_acct_5%TYPE;
      v_gl6            giac_chart_of_accts.gl_sub_acct_6%TYPE;
      v_gl7            giac_chart_of_accts.gl_sub_acct_7%TYPE;
      v_glca           giac_chart_of_accts.gl_control_acct%TYPE;
    BEGIN

    /*  FOR isscd IN (SELECT max(tran_id) tran_id, gibr_branch_cd 
               FROM giac_acctrans
                  WHERE tran_year = to_number(to_char(:control.dsp_date,'YYYY'))
                    AND tran_month = to_number(to_char(:control.dsp_date,'MM'))
               GROUP BY gibr_branch_cd) 
      LOOP -- Herbert 082301 Looped to handle multiple tran_IDs arising from multiple branches */

        FOR offset IN (SELECT SUM(NVL(credit_amt, 0) - NVL(debit_amt, 0)) offset,
                              gacc_gfun_fund_cd fund, gacc_gibr_branch_cd branch
                         FROM giac_acct_entries
                        WHERE gacc_tran_id = v_tran
                        GROUP BY gacc_gfun_fund_cd, gacc_gibr_branch_cd) 
        LOOP

          IF offset.offset = 0 THEN
             EXIT;
          ELSIF offset.offset > 0 THEN
            v_debit := abs(offset.offset);
          ELSE
            v_credit := abs(offset.offset);
          END IF;

          --Herbert 090401
          BEGIN
           SELECT gl_acct_category, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                  gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, gl_control_acct
             INTO v_glcat, v_gl1, v_gl2, v_gl3, v_gl4, v_gl5, v_gl6, v_gl7, v_glca
             FROM giac_module_entries
            WHERE module_id = p_module_id
              AND item_no = 15;
           EXCEPTION WHEN no_data_found THEN NULL;
          END;

          FOR chart IN (SELECT *
                          FROM giac_chart_of_accts
                         WHERE gl_acct_category = v_glcat
                          AND gl_sub_acct_1     = v_gl1
                          AND gl_sub_acct_2     = v_gl2 
                          AND gl_sub_acct_3     = v_gl3
                          AND gl_sub_acct_4     = v_gl4
                          AND gl_sub_acct_5     = v_gl5
                          AND gl_sub_acct_6     = v_gl6 
                          AND gl_sub_acct_7     = v_gl7 
                          AND gl_control_acct   = v_glca)
          LOOP
            FOR acct_id IN (SELECT MAX(acct_entry_id) max_id
                  FROM giac_acct_entries
                 WHERE gacc_tran_id = v_tran)
            LOOP
              v_acct_entry_id := acct_id.max_id;
              EXIT;
            END LOOP;
            INSERT INTO giac_acct_entries
              (gacc_tran_id,            gacc_gfun_fund_cd,
               gacc_gibr_branch_cd,     acct_entry_id,
               gl_acct_id,              gl_acct_category,
               gl_control_acct,         gl_sub_acct_1,
               gl_sub_acct_2,           gl_sub_acct_3,
               gl_sub_acct_4,           gl_sub_acct_5,
               gl_sub_acct_6,           gl_sub_acct_7,
               sl_cd,                   debit_amt,
               credit_amt,              generation_type,
               user_id,                 last_update,
               sl_type_cd,              sl_source_cd)
            VALUES
              (v_tran,                  offset.fund,
               offset.branch,           v_acct_entry_id+1,
               chart.gl_acct_id,        chart.gl_acct_category,
               chart.gl_control_acct,   chart.gl_sub_acct_1,
               chart.gl_sub_acct_2,     chart.gl_sub_acct_3,
               chart.gl_sub_acct_4,     chart.gl_sub_acct_5,
               chart.gl_sub_acct_6,     chart.gl_sub_acct_7,
               NULL,                    v_debit,
               v_credit,                'W',
               p_user_id,               SYSDATE,
               NULL,                    NULL);
          END LOOP;
        END LOOP;
    --  END LOOP;
    END offset_loss; 
    
    /*
    **  Created by      : Robert Virrey 
    **  Date Created    : 01.17.2012
    **  Reference By    : (GICLB001 - Batch O/S Takeup)
    **  Description     :  AEG_Insert_Update_Acct_Entries program unit; 
    **                     This procedure determines whether the records will be updated or inserted
    **                     in GIAC_ACCT_ENTRIES.     
    */
    PROCEDURE INS_UPDT_ACCT_ENTRIES_GICLB001(
        p_branch_cd            GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
        p_fund_cd              GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE,
        p_tran_id              GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        p_user_id              GIAC_ACCT_ENTRIES.user_id%TYPE,
        iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
        iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
        iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
        iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
        iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
        iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
        iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
        iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
        iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
        iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE,
        iuae_sl_type_cd        giac_acct_entries.sl_type_cd%type
    ) 
    IS
        iuae_acct_entry_id     GIAC_ACCT_ENTRIES.ACCT_ENTRY_ID%TYPE;
        iuae_sl_source_cd      gicl_acct_entries.sl_source_cd%type;
        v_sl_cd                giac_acct_entries.sl_cd%type;     
    BEGIN

      IF iuae_sl_type_cd IS NOT NULL THEN
         iuae_sl_source_cd  := 1;
         v_sl_cd            := iuae_sl_cd;
      ELSE
         iuae_sl_source_cd  := NULL;
         v_sl_cd            := NULL;
      END IF;     


      SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gl_acct_category    = iuae_gl_acct_category
         AND gl_control_acct     = iuae_gl_control_acct        
         AND gl_sub_acct_1       = iuae_gl_sub_acct_1
         AND gl_sub_acct_2       = iuae_gl_sub_acct_2
         AND gl_sub_acct_3       = iuae_gl_sub_acct_3
         AND gl_sub_acct_4       = iuae_gl_sub_acct_4
         AND gl_sub_acct_5       = iuae_gl_sub_acct_5
         AND gl_sub_acct_6       = iuae_gl_sub_acct_6
         AND gl_sub_acct_7       = iuae_gl_sub_acct_7
         AND sl_cd               = iuae_sl_cd
         AND generation_type     = iuae_generation_type
         AND gacc_gibr_branch_cd = p_branch_cd
         AND gacc_gfun_fund_cd   = p_fund_cd
         AND gacc_tran_id        = p_tran_id;
    --msg_alert('insert...','I',FALSE);
      IF NVL(iuae_acct_entry_id,0) = 0 THEN
        iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;
        INSERT INTO GIAC_ACCT_ENTRIES(gacc_tran_id       , gacc_gfun_fund_cd,
                                      gacc_gibr_branch_cd, acct_entry_id    ,
                                      gl_acct_id         , gl_acct_category ,
                                      gl_control_acct    , gl_sub_acct_1    ,
                                      gl_sub_acct_2      , gl_sub_acct_3    ,
                                      gl_sub_acct_4      , gl_sub_acct_5    ,
                                      gl_sub_acct_6      , gl_sub_acct_7    ,
                                      sl_cd              , debit_amt        ,
                                      credit_amt         , generation_type  ,
                                      user_id            , last_update,
                                      sl_type_cd         , sl_source_cd)
           VALUES (p_tran_id                     , p_fund_cd                   ,
                   p_branch_cd                   , iuae_acct_entry_id          ,
                   iuae_gl_acct_id               , iuae_gl_acct_category       ,
                   iuae_gl_control_acct          , iuae_gl_sub_acct_1          ,
                   iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3          ,
                   iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5          ,
                   iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7          ,
                   iuae_sl_cd                    , iuae_debit_amt              ,
                   iuae_credit_amt               , iuae_generation_type        ,
                   p_user_id                     , SYSDATE                     ,
                   iuae_sl_type_cd               , iuae_sl_source_cd);
      ELSE
    --msg_alert('update...','I',FALSE);
        UPDATE giac_acct_entries
           SET debit_amt  = debit_amt  + iuae_debit_amt,
               credit_amt = credit_amt + iuae_credit_amt
               ,sl_type_cd = iuae_sl_type_cd, -- Added by Jerome 10.05.2016 SR 5676
               sl_cd = v_sl_cd -- Added by Jerome 10.05.2016 SR 5676
       WHERE gl_sub_acct_1       = iuae_gl_sub_acct_1
         AND gl_sub_acct_2       = iuae_gl_sub_acct_2
         AND gl_sub_acct_3       = iuae_gl_sub_acct_3
         AND gl_sub_acct_4       = iuae_gl_sub_acct_4
         AND gl_sub_acct_5       = iuae_gl_sub_acct_5
         AND gl_sub_acct_6       = iuae_gl_sub_acct_6
         AND gl_sub_acct_7       = iuae_gl_sub_acct_7
         AND generation_type     = iuae_generation_type
         AND gl_acct_id          = iuae_gl_acct_id
         AND gacc_gibr_branch_cd = p_branch_cd
         AND gacc_gfun_fund_cd   = p_fund_cd
         AND gacc_tran_id        = p_tran_id
         AND NVL(sl_type_cd, '-')= NVL(iuae_sl_type_cd, '-')
         AND NVL(sl_cd, 0)       = NVL(v_sl_cd, 0);
      END IF;
    END INS_UPDT_ACCT_ENTRIES_GICLB001;

    PROCEDURE ins_updt_acct_entries_giacs017(
        p_gacc_tran_id    GIAC_DIRECT_CLAIM_PAYTS.gacc_tran_id%TYPE,
        p_gacc_branch_cd  GIAC_ACCTRANS.gibr_branch_cd%TYPE,
        p_gacc_fund_cd    GIAC_ACCTRANS.gfun_fund_cd%TYPE,
        p_claim_id        giac_direct_claim_payts.claim_id%TYPE,
        p_advice_id       giac_direct_claim_payts.advice_id%TYPE,
        p_payee_class_cd  giac_direct_claim_payts.payee_class_cd%TYPE,
        p_payee_cd        giac_direct_claim_payts.payee_cd%TYPE,
        p_var_gen_type    GIAC_MODULES.generation_type%TYPE,
        p_user_id         GIIS_USERS.user_id%TYPE
    ) IS
        CURSOR cur_acct_entries IS
            SELECT GENERATION_TYPE, GL_ACCT_ID, GL_ACCT_CATEGORY, GL_CONTROL_ACCT,
                GL_SUB_ACCT_1, GL_SUB_ACCT_2, GL_SUB_ACCT_3, GL_SUB_ACCT_4,
                GL_SUB_ACCT_5, GL_SUB_ACCT_6, GL_SUB_ACCT_7,
                sl_type_cd, SL_CD, sl_source_cd,
                SUM(DEBIT_AMT) debit_amt, SUM(CREDIT_AMT) credit_amt, 
                advice_id, claim_id,
                payee_class_cd, payee_cd           -- added by judyann 03262009
            FROM gicl_acct_entries
                WHERE claim_id = p_claim_id
                  AND advice_id = p_advice_id
                  AND payee_class_cd = p_payee_class_cd
                  AND payee_cd = p_payee_cd   
            GROUP BY GENERATION_TYPE, GL_ACCT_ID, GL_ACCT_CATEGORY, GL_CONTROL_ACCT,
                   GL_SUB_ACCT_1, GL_SUB_ACCT_2, GL_SUB_ACCT_3, GL_SUB_ACCT_4,
                   GL_SUB_ACCT_5, GL_SUB_ACCT_6, GL_SUB_ACCT_7,
                   sl_type_cd, SL_CD, sl_source_cd, 
                   advice_id, claim_id,
                   payee_class_cd, payee_cd;

        v_acct_entry_id     giac_acct_entries.acct_entry_id%type;
    BEGIN
        BEGIN
            SELECT MAX(acct_entry_id) 
              INTO v_acct_entry_id
              FROM giac_acct_entries
             WHERE gacc_tran_id = p_gacc_tran_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_acct_entry_id := 0;
        END; 
        
        FOR al IN cur_acct_entries LOOP
            v_acct_entry_id := v_acct_entry_id + 1;

            FOR t IN (SELECT DISTINCT transaction_type    -- judyann 03262009; added DISTINCT, to handle multiple records per advice
                        FROM giac_direct_claim_payts
                       WHERE gacc_tran_id = p_gacc_tran_id
                         AND claim_id = al.claim_id
                         AND advice_id = al.advice_id
                         AND payee_class_cd = al.payee_class_cd
                         AND payee_cd = al.payee_cd)
            LOOP
              IF t.transaction_type = 1 THEN             -- added by judyann 02122003
                 INSERT INTO giac_acct_entries(GACC_TRAN_ID, GACC_GFUN_FUND_CD, GACC_GIBR_BRANCH_CD,            
                                               ACCT_ENTRY_ID, GL_ACCT_ID, GL_ACCT_CATEGORY,              
                                               GL_CONTROL_ACCT, GL_SUB_ACCT_1, GL_SUB_ACCT_2,                  
                                               GL_SUB_ACCT_3, GL_SUB_ACCT_4, GL_SUB_ACCT_5,                  
                                               GL_SUB_ACCT_6, GL_SUB_ACCT_7, sl_type_cd, SL_CD, 
                                               sl_source_cd,
                                               DEBIT_AMT, CREDIT_AMT, GENERATION_TYPE,                
                                               USER_ID, LAST_UPDATE)
                                        VALUES(p_gacc_tran_id, p_gacc_fund_cd,
                                               p_gacc_branch_cd, 
                                               v_acct_entry_id, al.GL_ACCT_ID, al.GL_ACCT_CATEGORY,
                                               al.GL_CONTROL_ACCT, al.GL_SUB_ACCT_1, al.GL_SUB_ACCT_2,
                                               al.GL_SUB_ACCT_3, al.GL_SUB_ACCT_4, al.GL_SUB_ACCT_5,
                                               al.GL_SUB_ACCT_6, al.GL_SUB_ACCT_7, al.sl_type_cd, al.SL_CD,
                                               al.sl_source_cd,
                                               al.debit_amt, al.credit_amt, p_var_gen_type,
                                               nvl(p_user_id, USER), SYSDATE);

              ELSIF t.transaction_type = 2 THEN
                 INSERT INTO giac_acct_entries(GACC_TRAN_ID, GACC_GFUN_FUND_CD, GACC_GIBR_BRANCH_CD,            
                                               ACCT_ENTRY_ID, GL_ACCT_ID, GL_ACCT_CATEGORY,              
                                               GL_CONTROL_ACCT, GL_SUB_ACCT_1, GL_SUB_ACCT_2,                  
                                               GL_SUB_ACCT_3, GL_SUB_ACCT_4, GL_SUB_ACCT_5,                  
                                               GL_SUB_ACCT_6, GL_SUB_ACCT_7, sl_type_cd, SL_CD, 
                                               sl_source_cd,
                                               DEBIT_AMT, CREDIT_AMT, GENERATION_TYPE,                
                                               USER_ID, LAST_UPDATE)
                                        VALUES(p_gacc_tran_id, p_gacc_fund_cd,
                                               p_gacc_branch_cd, 
                                               v_acct_entry_id, al.GL_ACCT_ID, al.GL_ACCT_CATEGORY,
                                               al.GL_CONTROL_ACCT, al.GL_SUB_ACCT_1, al.GL_SUB_ACCT_2,
                                               al.GL_SUB_ACCT_3, al.GL_SUB_ACCT_4, al.GL_SUB_ACCT_5,
                                               al.GL_SUB_ACCT_6, al.GL_SUB_ACCT_7, al.sl_type_cd, al.SL_CD,
                                               al.sl_source_cd,
                                               al.credit_amt, al.debit_amt, p_var_gen_type,
                                               nvl(p_user_id, USER), SYSDATE);
              END IF;
            END LOOP;
        END LOOP;        
    END ins_updt_acct_entries_giacs017;
    
     FUNCTION get_giacs016_sum_acct_entries (
       p_replenish_id   giac_acct_entries.gacc_tran_id%TYPE,
      p_gl_acct_category   gicl_acct_entries.gl_acct_category%TYPE,
      p_gl_control_acct    gicl_acct_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1      gicl_acct_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      gicl_acct_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      gicl_acct_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      gicl_acct_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      gicl_acct_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      gicl_acct_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      gicl_acct_entries.gl_sub_acct_7%TYPE,
      p_sl_code            gicl_acct_entries.sl_cd%TYPE,
      p_debit_amt          gicl_acct_entries.debit_amt%TYPE,
      p_credit_amt         gicl_acct_entries.credit_amt%TYPE
   )
      RETURN acct_entries_tab1 PIPELINED
      
      is
      v_list   acct_entries_type1;
      begin
      
        for i in
                (select * from(SELECT  TO_CHAR(a.gl_acct_category)|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_control_acct,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_1,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_2,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_3,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_4,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_5,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_6,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_7,'09')) gl_acct_code ,d.replenish_id, a.gl_acct_category,  
                         a.gl_control_acct,   a.gl_sub_acct_1,     a.gl_sub_acct_2,    
                         a.gl_sub_acct_3,     a.gl_sub_acct_4,     a.gl_sub_acct_5,    
                         a.gl_sub_acct_6,     a.gl_sub_acct_7,a.sl_type_cd, b.gl_acct_name,
                         a.sl_cd, c.sl_name, SUM (debit_amt) debit_amt,
                          SUM (credit_amt) credit_amt
                     FROM giac_replenish_dv_dtl d,
                          giac_acct_entries a,
                          giac_chart_of_accts b,
                          giac_sl_lists c
                    WHERE a.gl_acct_id = b.gl_acct_id
                      AND a.sl_type_cd = c.sl_type_cd(+)
                      AND a.sl_cd = c.sl_cd(+)
                      AND a.gacc_tran_id = d.dv_tran_id
                      AND include_tag = 'Y'
                      AND a.gl_acct_category LIKE NVL(p_gl_acct_category, a.gl_acct_category)
                    AND a.gl_control_acct LIKE NVL(p_gl_control_acct, a.gl_control_acct)
                    AND a.gl_sub_acct_1 LIKE NVL(p_gl_sub_acct_1, a.gl_sub_acct_1)
                    AND a.gl_sub_acct_2 LIKE NVL(p_gl_sub_acct_2, a.gl_sub_acct_2)
                    AND a.gl_sub_acct_3 LIKE NVL(p_gl_sub_acct_3, a.gl_sub_acct_3)
                    AND a.gl_sub_acct_4 LIKE NVL(p_gl_sub_acct_4, a.gl_sub_acct_4)
                    AND a.gl_sub_acct_5 LIKE NVL(p_gl_sub_acct_5, a.gl_sub_acct_5)
                    AND a.gl_sub_acct_6 LIKE NVL(p_gl_sub_acct_6, a.gl_sub_acct_6)
                    AND a.gl_sub_acct_7 LIKE NVL(p_gl_sub_acct_7, a.gl_sub_acct_7)
                    AND NVL(a.sl_cd, 0) LIKE NVL(p_sl_code, NVL(a.sl_cd, 0))
                    AND NVL(a.debit_amt, 0) LIKE NVL(p_debit_amt, NVL(a.debit_amt, 0))
                    AND NVL(a.credit_amt,0) LIKE NVL(p_credit_amt, NVL(a.credit_amt,0))
                 GROUP BY d.replenish_id,
                          a.gl_acct_id,
                          a.gl_acct_category,
                          a.gl_control_acct,
                          a.gl_sub_acct_1,
                          a.gl_sub_acct_2,
                          a.gl_sub_acct_3,
                          a.gl_sub_acct_4,
                          a.gl_sub_acct_5,
                          a.gl_sub_acct_6,
                          a.gl_sub_acct_7,
                          b.gl_acct_name,
                          a.sl_type_cd,
                          a.sl_cd,
                          c.sl_name
                       
                          )  where replenish_id = p_replenish_id
                          order by gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7
                          )
        
        loop
           v_list.dsp_gl_acct_code := i.gl_acct_code;
             v_list.gl_acct_category :=  i.gl_acct_category;  
            v_list.gl_control_acct  :=  i.gl_control_acct;  
            v_list.gl_sub_acct_1    :=  i.gl_sub_acct_1;  
            v_list.gl_sub_acct_2    :=  i.gl_sub_acct_2; 
            v_list.gl_sub_acct_3    :=  i.gl_sub_acct_3; 
            v_list.gl_sub_acct_4    :=  i.gl_sub_acct_4;  
            v_list.gl_sub_acct_5    :=  i.gl_sub_acct_5;  
            v_list.gl_sub_acct_6    :=  i.gl_sub_acct_6; 
            v_list.gl_sub_acct_7    :=  i.gl_sub_acct_7; 
             v_list.sl_cd            :=  i.sl_cd;   
            v_list.debit_amt        :=  i.debit_amt;  
            v_list.credit_amt       :=  i.credit_amt;
            v_list.dsp_gl_acct_name := i.gl_acct_name;
            v_list.dsp_sl_name := i.sl_name;
                       
            pipe row(v_list);
        end loop;
      end;
      
      FUNCTION check_giacs060_gl_trans (
      p_branch_cd       VARCHAR2,
      p_fund_cd         VARCHAR2,
      p_category        VARCHAR2,
      p_control         VARCHAR2,
      p_sub1            VARCHAR2,
      p_sub2            VARCHAR2,
      p_sub3            VARCHAR2,
      p_sub4            VARCHAR2,
      p_sub5            VARCHAR2,
      p_sub6            VARCHAR2,
      p_sub7            VARCHAR2,
      p_tran_class      VARCHAR2,
      p_sl_cd           VARCHAR2,
      p_sl_type_cd      VARCHAR2,
      p_tran_post       VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_exists VARCHAR2(1);
   BEGIN
      BEGIN
        SELECT 'Y'
          INTO v_exists
          FROM giac_chart_of_accts e,
               giac_disb_vouchers d,
               giac_order_of_payts c,
               giac_acctrans b,
               giac_acct_entries a
         WHERE a.gacc_tran_id = b.tran_id
           AND a.gacc_tran_id = c.gacc_tran_id(+)
           AND a.gacc_tran_id = d.gacc_tran_id(+)
           AND a.gacc_gibr_branch_cd = NVL(p_branch_cd, a.gacc_gibr_branch_cd)
           AND a.gacc_gfun_fund_cd = p_fund_cd
           AND a.gl_acct_category = NVL(p_category, a.gl_acct_category)
           AND a.gl_control_acct = NVL (p_control, a.gl_control_acct)
           AND a.gl_sub_acct_1 = NVL (p_sub1, a.gl_sub_acct_1)
           AND a.gl_sub_acct_2 = NVL (p_sub2, a.gl_sub_acct_2)
           AND a.gl_sub_acct_3 = NVL (p_sub3, a.gl_sub_acct_3)
           AND a.gl_sub_acct_4 = NVL (p_sub4, a.gl_sub_acct_4)
           AND a.gl_sub_acct_5 = NVL (p_sub5, a.gl_sub_acct_5)
           AND a.gl_sub_acct_6 = NVL (p_sub6, a.gl_sub_acct_6)
           AND a.gl_sub_acct_7 = NVL (p_sub7, a.gl_sub_acct_7)
           AND b.tran_class = NVL (p_tran_class, b.tran_class)
           AND NVL (a.sl_cd, 0) = NVL (p_sl_cd, NVL (a.sl_cd, 0))
           AND NVL (a.sl_type_cd, '-') =
                                       NVL (p_sl_type_cd, NVL (a.sl_type_cd, '-'))
           AND a.gl_acct_id = e.gl_acct_id
           AND b.tran_flag <> 'D'
           AND TRUNC (DECODE (p_tran_post, 'T', b.tran_date, b.posting_date))
                  BETWEEN TO_DATE(p_from_date, 'mm-dd-yyyy')
                      AND TO_DATE(p_to_date, 'mm-dd-yyyy')
           AND ROWNUM = 1;
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              v_exists := 'N';
      END;           
        RETURN v_exists;                     
   END check_giacs060_gl_trans;   
   
   --added by reymon for premium receivable sl type 11212013
   FUNCTION peril_rec_computation (
      p_iss_cd         giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_prem_seq_no    giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_prem_colln     giac_direct_prem_collns.premium_amt%TYPE,
      p_gacc_tran_id   giac_acctrans.tran_id%TYPE
   )
      RETURN prem_rec_dtls_tab PIPELINED
   AS
      v_prem_rec_dtls   prem_rec_dtls_type;
      v_sum_prem        gipi_invperil.prem_amt%TYPE;
      v_max_peril       gipi_invperil.peril_cd%TYPE;
      v_prem_paid       giac_direct_prem_collns.premium_amt%TYPE;
      v_sum_total       gipi_invoice.prem_amt%TYPE;
      v_sum_col         giac_direct_prem_collns.premium_amt%TYPE   := 0;
      v_diff            giac_direct_prem_collns.premium_amt%TYPE   := 0;
      v_peril_amt       giac_direct_prem_collns.premium_amt%TYPE   := 0;
      v_sum_col_p       giac_direct_prem_collns.premium_amt%TYPE   := 0;
      v_diff_p          giac_direct_prem_collns.premium_amt%TYPE   := 0;
   BEGIN
      SELECT SUM (prem_amt), MAX (peril_cd)
        INTO v_sum_prem, v_max_peril
        FROM gipi_invperil
       WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;
       
      SELECT SUM (prem_amt + tax_amt)
        INTO v_sum_total
        FROM gipi_invoice
       WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;

      SELECT NVL (SUM (collection_amt), 0) prem_paid
        INTO v_prem_paid
        FROM giac_direct_prem_collns a, giac_acctrans b
       WHERE b140_iss_cd = p_iss_cd
         AND b140_prem_seq_no = p_prem_seq_no
         AND a.gacc_tran_id = b.tran_id
         AND a.gacc_tran_id <> p_gacc_tran_id
         AND b.tran_flag <> 'D';

      FOR i IN (SELECT   a.peril_cd,
                         TO_NUMBER
                                  (   LTRIM (TO_CHAR (c.acct_line_cd, '00'))
                                   || LTRIM (TO_CHAR (b.acct_subline_cd, '00'))
                                   || LTRIM (TO_CHAR (a.peril_cd, '000'))
                                  ) sl_cd,
                         v_sum_total * (d.prem_amt / v_sum_prem) prem_amt, (d.prem_amt / v_sum_prem) peril_pct
                    FROM giis_peril a,
                         giis_subline b,
                         giis_line c,
                         gipi_invperil d,
                         gipi_invoice e,
                         gipi_polbasic f
                   WHERE a.line_cd = b.line_cd
                     AND NVL (a.subline_cd, b.subline_cd) = b.subline_cd
                     AND a.line_cd = c.line_cd
                     AND a.peril_cd = d.peril_cd
                     AND f.line_cd = b.line_cd
                     AND f.subline_cd = b.subline_cd
                     AND d.iss_cd = e.iss_cd
                     AND d.prem_seq_no = e.prem_seq_no
                     AND e.policy_id = f.policy_id
                     AND d.iss_cd = p_iss_cd
                     AND d.prem_seq_no = p_prem_seq_no
                ORDER BY peril_cd)
      LOOP
         IF v_sum_total = p_prem_colln                          --full payment
         THEN
            v_prem_rec_dtls.sl_cd := i.sl_cd;
            v_prem_rec_dtls.amount := i.prem_amt;
            v_sum_col := v_sum_col + v_prem_rec_dtls.amount;
            IF i.peril_cd = v_max_peril AND v_sum_col <> p_prem_colln
            THEN
               v_diff := p_prem_colln - v_sum_col;
               v_prem_rec_dtls.amount := v_prem_rec_dtls.amount + v_diff;
            END IF;
            PIPE ROW (v_prem_rec_dtls);
         ELSIF v_sum_total <> (p_prem_colln + v_prem_paid)
         THEN
            v_prem_rec_dtls.sl_cd := i.sl_cd;
            v_prem_rec_dtls.amount := p_prem_colln * i.peril_pct;
            v_sum_col := v_sum_col + v_prem_rec_dtls.amount;

            IF i.peril_cd = v_max_peril AND v_sum_col <> p_prem_colln
            THEN
               v_diff := p_prem_colln - v_sum_col;
               v_prem_rec_dtls.amount := v_prem_rec_dtls.amount + v_diff;
            END IF;

            PIPE ROW (v_prem_rec_dtls);
         ELSIF v_sum_total = (p_prem_colln + v_prem_paid)
         THEN
            v_prem_rec_dtls.sl_cd := i.sl_cd;
            v_prem_rec_dtls.amount := p_prem_colln * i.peril_pct;
            v_peril_amt := 0;

            FOR a IN (SELECT collection_amt premium_amt,
                             (collection_amt * i.peril_pct) peril_amt
                        FROM giac_direct_prem_collns a, giac_acctrans b
                       WHERE b140_iss_cd = p_iss_cd
                         AND b140_prem_seq_no = p_prem_seq_no
                         AND a.gacc_tran_id = b.tran_id
                         AND a.gacc_tran_id <> p_gacc_tran_id
                         AND b.tran_flag <> 'D')
            LOOP
               v_peril_amt := v_peril_amt + a.peril_amt;

               IF i.peril_cd = v_max_peril
               THEN
                  SELECT SUM (ROUND ((prem_amt / v_sum_prem) * a.premium_amt,
                                     2
                                    )
                             ) tots
                    INTO v_sum_col_p
                    FROM gipi_invperil
                   WHERE iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no
                     AND peril_cd <> i.peril_cd;

                  v_diff_p := (v_sum_col_p + a.peril_amt) - a.premium_amt;
                  v_peril_amt := v_peril_amt - v_diff_p;
                  
               END IF;
            END LOOP;

            IF (v_prem_rec_dtls.amount + v_peril_amt) <> i.prem_amt
            THEN
               v_diff := i.prem_amt - (v_prem_rec_dtls.amount + v_peril_amt);
               v_prem_rec_dtls.amount := v_prem_rec_dtls.amount + v_diff;
            END IF;
            
            v_sum_col := v_sum_col + v_prem_rec_dtls.amount;
            
            IF i.peril_cd = v_max_peril AND v_sum_col <> p_prem_colln
            THEN
               v_diff := p_prem_colln - v_sum_col;
               v_prem_rec_dtls.amount := v_prem_rec_dtls.amount + v_diff;
            END IF;
            PIPE ROW (v_prem_rec_dtls);
         END IF;
      END LOOP;
   END peril_rec_computation;

   FUNCTION intm_rec_computation (
      p_iss_cd         giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_prem_seq_no    giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_prem_colln     giac_direct_prem_collns.premium_amt%TYPE,
      p_gacc_tran_id   giac_acctrans.tran_id%TYPE
   )
      RETURN prem_rec_dtls_tab PIPELINED
   AS
      v_prem_rec_dtls   prem_rec_dtls_type;
      v_sum_prem        gipi_invperil.prem_amt%TYPE;
      v_max_intm        gipi_comm_invoice.intrmdry_intm_no%TYPE;
      v_prem_paid       giac_direct_prem_collns.premium_amt%TYPE;
      v_sum_col         giac_direct_prem_collns.premium_amt%TYPE   := 0;
      v_diff            giac_direct_prem_collns.premium_amt%TYPE   := 0;
      v_intm_amt        giac_direct_prem_collns.premium_amt%TYPE   := 0;
      v_sum_col_i       giac_direct_prem_collns.premium_amt%TYPE   := 0;
      v_diff_i          giac_direct_prem_collns.premium_amt%TYPE   := 0;
   BEGIN
      SELECT SUM (prem_amt)
        INTO v_sum_prem
        FROM gipi_invperil
       WHERE iss_cd = p_iss_cd
         AND prem_seq_no = p_prem_seq_no;

      SELECT MAX (intrmdry_intm_no)
        INTO v_max_intm
        FROM gipi_comm_invoice
       WHERE iss_cd = p_iss_cd
         AND prem_seq_no = p_prem_seq_no;
      
      SELECT NVL (SUM (premium_amt), 0) prem_paid
        INTO v_prem_paid
        FROM giac_direct_prem_collns a, giac_acctrans b
       WHERE b140_iss_cd = p_iss_cd
         AND b140_prem_seq_no = p_prem_seq_no
         AND a.gacc_tran_id = b.tran_id
         AND a.gacc_tran_id <> p_gacc_tran_id
         AND b.tran_flag <> 'D';

      FOR i IN (SELECT   intrmdry_intm_no intm_no, intrmdry_intm_no sl_cd,
                         v_sum_prem * (share_percentage / 100) prem_amt,
                         (share_percentage / 100) intm_pct
                    FROM gipi_comm_invoice
                   WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no
                ORDER BY intm_no)
      LOOP
         IF v_sum_prem = p_prem_colln                          --full payment
         THEN
            v_prem_rec_dtls.sl_cd := i.sl_cd;
            v_prem_rec_dtls.amount := i.prem_amt;
            PIPE ROW (v_prem_rec_dtls);
         ELSIF v_sum_prem <> (p_prem_colln + v_prem_paid)
         THEN
            v_prem_rec_dtls.sl_cd := i.sl_cd;
            v_prem_rec_dtls.amount := p_prem_colln * i.intm_pct;
            v_sum_col := v_sum_col + v_prem_rec_dtls.amount;

            IF i.intm_no = v_max_intm AND v_sum_col <> p_prem_colln
            THEN
               v_diff := p_prem_colln - v_sum_col;
               v_prem_rec_dtls.amount := v_prem_rec_dtls.amount + v_diff;
            END IF;

            PIPE ROW (v_prem_rec_dtls);
         ELSIF v_sum_prem = (p_prem_colln + v_prem_paid)
         THEN
            v_prem_rec_dtls.sl_cd := i.sl_cd;
            v_prem_rec_dtls.amount := p_prem_colln * i.intm_pct;
            v_intm_amt := 0;

            FOR a IN (SELECT premium_amt,
                             (premium_amt * i.intm_pct) intm_amt
                        FROM giac_direct_prem_collns a, giac_acctrans b
                       WHERE b140_iss_cd = p_iss_cd
                         AND b140_prem_seq_no = p_prem_seq_no
                         AND a.gacc_tran_id = b.tran_id
                         AND a.gacc_tran_id <> p_gacc_tran_id
                         AND b.tran_flag <> 'D')
            LOOP
               v_intm_amt := v_intm_amt + a.intm_amt;

               IF i.intm_no = v_max_intm
               THEN
                  SELECT SUM (ROUND ((share_percentage / 100) * a.premium_amt,
                                     2
                                    )
                             ) tots
                    INTO v_sum_col_i
                    FROM gipi_comm_invoice
                   WHERE iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no
                     AND intrmdry_intm_no <> i.intm_no;

                  v_diff_i := (v_sum_col_i + a.intm_amt) - a.premium_amt;
                  v_intm_amt := v_intm_amt - v_diff_i;
               END IF;
            END LOOP;

            IF (v_prem_rec_dtls.amount + v_intm_amt) <> i.prem_amt
            THEN
               v_diff := i.prem_amt - (v_prem_rec_dtls.amount + v_intm_amt);
               v_prem_rec_dtls.amount := v_prem_rec_dtls.amount + v_diff;
            END IF;

            PIPE ROW (v_prem_rec_dtls);
         END IF;
      END LOOP;
   END intm_rec_computation;
   
   --end 11212013
   PROCEDURE AEG_PARAMETERS_GIACS042 (  --  dren 08.03.2015 : SR 0017729 - GIACS042 Accounting Entries - Start
      p_gacc_branch_cd      giac_acctrans.gibr_branch_cd%TYPE,
      p_gacc_fund_cd        giac_acctrans.gfun_fund_cd%TYPE,  
      p_gacc_tran_id        GIAC_ACCTRANS.tran_id%TYPE,
      p_module_name         GIAC_MODULES.module_name%TYPE,      
      p_message             OUT   VARCHAR2            
   )   
   IS       
      v_module_id        giac_modules.module_id%TYPE;
      v_gen_type         giac_modules.generation_type%TYPE;
         
      CURSOR B_cur is 
        SELECT GDBD.bank_cd, GDBD.bank_acct_cd, GDBD.amount, 
               gdbd.old_dep_amt, gdbd.adj_amt 
          FROM giac_dcb_bank_dep GDBD
          WHERE GDBD.gacc_tran_id = p_gacc_tran_id;

    BEGIN
      BEGIN
        SELECT module_id, generation_type
          INTO v_module_id, v_gen_type
          FROM giac_modules
          WHERE module_name = p_module_name;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_message := 'No data found in GIAC MODULES.';
      END;

      -- Call the deletion of accounting entry procedure.
      GIAC_ACCT_ENTRIES_PKG.aeg_delete_acct_entries (p_gacc_tran_id, v_gen_type);

      FOR B_rec in B_cur LOOP
        -- Call the accounting entry generation procedure.
        IF nvl(b_rec.old_dep_amt,0) <> 0 THEN       
            IF nvl(b_rec.adj_amt,0) <> 0 THEN
            GIAC_ACCT_ENTRIES_PKG.AEG_CREATE_ACCT_ENTRIES_42(p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
                                       b_rec.bank_cd, b_rec.bank_acct_cd,
                                       b_rec.adj_amt, v_module_id, v_gen_type, p_message);
            END IF;                        
        ELSE
            GIAC_ACCT_ENTRIES_PKG.AEG_CREATE_ACCT_ENTRIES_42(p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
                                       B_rec.bank_cd, B_rec.bank_acct_cd,
                                       B_rec.amount, v_module_id, v_gen_type, p_message);
            END IF;
      END LOOP;
    END AEG_PARAMETERS_GIACS042;  
    PROCEDURE AEG_CREATE_ACCT_ENTRIES_42 (
        p_gacc_branch_cd            giac_acctrans.gibr_branch_cd%TYPE,
        p_gacc_fund_cd              giac_acctrans.gfun_fund_cd%TYPE,
        p_gacc_tran_id              giac_acctrans.tran_id%TYPE,    
        p_bank_cd                   giac_bank_accounts.bank_cd%TYPE,
        p_bank_acct_cd              giac_bank_accounts.bank_acct_cd%TYPE,
        p_amount                    giac_dcb_bank_dep.amount%TYPE,
        p_module_id                 giac_modules.module_id%TYPE,
        p_gen_type                  GIAC_ACCT_ENTRIES.generation_type%TYPE,     
        p_message                   OUT   VARCHAR2    
    )
    IS
        v_gl_acct_id        GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
        v_sl_cd             giac_acct_entries.sl_cd%TYPE;
        v_giacs1_mod_id     giac_module_entries.module_id%TYPE;
        v_dr_cr_tag         giac_module_entries.dr_cr_tag%TYPE;
        v_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
        v_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
        v_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
        v_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
        v_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
        v_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
        v_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
        v_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
        v_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
        v_sl_type_cd        giac_acct_entries.sl_type_cd%TYPE;
        v_debit_amt         giac_acct_entries.debit_amt%TYPE;
        v_credit_amt        giac_acct_entries.credit_amt%TYPE;
        v_sl_source_cd      giac_acct_entries.sl_source_cd%TYPE;     
    BEGIN
        -- Populate the GL Account ID used in every transaction.
        BEGIN
            SELECT gl_acct_id, sl_cd
            INTO v_gl_acct_id, v_sl_cd
            FROM giac_bank_accounts
            WHERE bank_cd = p_bank_cd
            AND bank_acct_cd = p_bank_acct_cd;
        EXCEPTION
        WHEN no_data_found THEN
            p_message := 'No data found in giac_bank_accounts.';
        END;

        -- get account no for this v_gl_acct_id 
        begin
            select gl_acct_category, gl_control_acct, gl_sub_acct_1,
            gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, 
            gl_sub_acct_7, gslt_sl_type_cd
            into  v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1,     
            v_gl_sub_acct_2, v_gl_sub_acct_3, v_gl_sub_acct_4, v_gl_sub_acct_5, v_gl_sub_acct_6, 
            v_gl_sub_acct_7, v_sl_type_cd
            from  giac_chart_of_accts
            where gl_acct_id = v_gl_acct_id;
        exception
        when no_data_found 
        then
            p_message := 'No record in the Chart of Accounts for this GL ID' || to_char(v_gl_acct_id);
        end;
                         
        -- get dr_cd_tag of GIACS001 and use as dr_cd_tag of bank deposits.
        BEGIN
            SELECT module_id
            INTO v_giacs1_mod_id
            FROM giac_modules
            WHERE module_name = 'GIACS001';
                              
            SELECT dr_cr_tag
            INTO v_dr_cr_tag
            FROM giac_module_entries
            WHERE module_id = v_giacs1_mod_id
            AND item_no   = 1 ;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            p_message := 'No data found in giac_module_entries.';
        END;              
                               
        -- Check if the accounting code exists in GIAC_CHART_OF_ACCTS 
        -- table.
        
        GIAC_ACCT_ENTRIES_PKG.AEG_CHECK_CHART_OF_ACCTS_42(v_gl_acct_id, v_gl_acct_category,
                                                            v_gl_control_acct, v_gl_sub_acct_1,     
                                                            v_gl_sub_acct_2, v_gl_sub_acct_3,    
                                                            v_gl_sub_acct_4, v_gl_sub_acct_5,    
                                                            v_gl_sub_acct_6, v_gl_sub_acct_7, 
                                                            v_sl_type_cd, p_message);
                                
                                  
        -- If the accounting code exists in GIAC_CHART_OF_ACCTS table, 
        -- validate the debit-credit tag to determine whether the positive 
        -- amount will be debited or credited.                                                              *
         IF v_dr_cr_tag = 'D' THEN
            IF p_amount > 0 THEN
                v_debit_amt  := ABS(p_amount);
                v_credit_amt := 0;
            ELSE
                v_debit_amt  := 0;
                v_credit_amt := ABS(p_amount);
            END IF;
        ELSE
            IF p_amount > 0 THEN
                v_debit_amt  := 0;
                v_credit_amt := ABS(p_amount);
            ELSE
                v_debit_amt  := ABS(p_amount);
                v_credit_amt := 0;
            END IF;
        END IF;--vfm--
                   
                     
        -- Check if the derived GL code exists in GIAC_ACCT_ENTRIES table 
        -- for the same transaction id.  Insert the record if it does not 
        -- exists else update the existing record.
        GIAC_ACCT_ENTRIES_PKG.AEG_Insert_Update_Acct_Entries( p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
                                                               v_gl_acct_category,
                                                               v_gl_control_acct, v_gl_sub_acct_1,     
                                                               v_gl_sub_acct_2, v_gl_sub_acct_3,    
                                                               v_gl_sub_acct_4, v_gl_sub_acct_5,    
                                                               v_gl_sub_acct_6, v_gl_sub_acct_7,
                                                               v_sl_cd, v_sl_type_cd, nvl(v_sl_source_cd,1),
                                                               p_gen_type, v_gl_acct_id,
                                                               v_debit_amt, v_credit_amt                                                                                        
                                                               ); 
    END;    
    PROCEDURE AEG_CHECK_CHART_OF_ACCTS_42 (
      cca_gl_acct_id         IN OUT      giac_chart_of_accts.gl_acct_id%TYPE,
      cca_gl_acct_category   IN OUT      giac_acct_entries.gl_acct_category%TYPE,
      cca_gl_control_acct    IN OUT      giac_acct_entries.gl_control_acct%TYPE,
      cca_gl_sub_acct_1      IN OUT      giac_acct_entries.gl_sub_acct_1%TYPE,
      cca_gl_sub_acct_2      IN OUT      giac_acct_entries.gl_sub_acct_2%TYPE,
      cca_gl_sub_acct_3      IN OUT      giac_acct_entries.gl_sub_acct_3%TYPE,
      cca_gl_sub_acct_4      IN OUT      giac_acct_entries.gl_sub_acct_4%TYPE,
      cca_gl_sub_acct_5      IN OUT      giac_acct_entries.gl_sub_acct_5%TYPE,
      cca_gl_sub_acct_6      IN OUT      giac_acct_entries.gl_sub_acct_6%TYPE,
      cca_gl_sub_acct_7      IN OUT      giac_acct_entries.gl_sub_acct_7%TYPE,
      cca_sl_type_cd         IN OUT      GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,
      p_msg_alert            OUT         VARCHAR2    
    )
    IS 
    BEGIN
      SELECT DISTINCT gl_acct_category, gl_control_acct,
                      gl_sub_acct_1, gl_sub_acct_2,
                      gl_sub_acct_3, gl_sub_acct_4,
                      gl_sub_acct_5, gl_sub_acct_6,
                      gl_sub_acct_7, gslt_sl_type_cd
        INTO cca_gl_acct_category, cca_gl_control_acct,
             cca_gl_sub_acct_1, cca_gl_sub_acct_2,
             cca_gl_sub_acct_3, cca_gl_sub_acct_4,     
             cca_gl_sub_acct_5, cca_gl_sub_acct_6,     
             cca_gl_sub_acct_7, cca_sl_type_cd
        FROM giac_chart_of_accts
        WHERE gl_acct_id = cca_gl_acct_id
        AND leaf_tag = 'Y';
    EXCEPTION
       WHEN no_data_found THEN
         BEGIN
         p_msg_alert := 'GL account code '||to_char(cca_gl_acct_category,'09')
                        ||'-'||to_char(cca_gl_control_acct,'09') 
                        ||'-'||to_char(cca_gl_sub_acct_1,'09')
                        ||'-'||to_char(cca_gl_sub_acct_2,'09')
                        ||'-'||to_char(cca_gl_sub_acct_3,'09')
                        ||'-'||to_char(cca_gl_sub_acct_4,'09')
                        ||'-'||to_char(cca_gl_sub_acct_5,'09')
                        ||'-'||to_char(cca_gl_sub_acct_6,'09')
                        ||'-'||to_char(cca_gl_sub_acct_7,'09')
                        ||' does not exist in the Chart of Accounts.';
         END;
    END;  --  dren 08.03.2015 : SR 0017729 - GIACS042 Accounting Entries - End
   
END giac_acct_entries_pkg;
/
