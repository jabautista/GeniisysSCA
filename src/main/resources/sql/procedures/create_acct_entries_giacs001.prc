DROP PROCEDURE CPI.CREATE_ACCT_ENTRIES_GIACS001;

CREATE OR REPLACE PROCEDURE CPI.create_acct_entries_giacs001 (
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
                    gl_sub_acct_7, pol_type_tag, intm_type_level,
                    old_new_acct_level, dr_cr_tag, line_dependency_level
               INTO ws_gl_acct_category, ws_gl_control_acct,
                    ws_gl_sub_acct_1, ws_gl_sub_acct_2, ws_gl_sub_acct_3,
                    ws_gl_sub_acct_4, ws_gl_sub_acct_5, ws_gl_sub_acct_6,
                    ws_gl_sub_acct_7, ws_pol_type_tag, ws_intm_type_level,
                    ws_old_new_acct_level, ws_dr_cr_tag, ws_line_dep_level
               FROM giac_module_entries
              WHERE module_id = p_module_id AND item_no = p_item_no
      FOR UPDATE OF gl_sub_acct_1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_message :=
            'No data found in giac_module_entries: GIACS001 - Order of Payments';
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
   giac_acct_entries_pkg.insert_update_acct_entries (ws_gl_acct_category,
                                                     ws_gl_control_acct,
                                                     ws_gl_sub_acct_1,
                                                     ws_gl_sub_acct_2,
                                                     ws_gl_sub_acct_3,
                                                     ws_gl_sub_acct_4,
                                                     ws_gl_sub_acct_5,
                                                     ws_gl_sub_acct_6,
                                                     ws_gl_sub_acct_7,
                                                     p_sl_cd,
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
END;
/


