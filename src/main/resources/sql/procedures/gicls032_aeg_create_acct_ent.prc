DROP PROCEDURE CPI.GICLS032_AEG_CREATE_ACCT_ENT;

CREATE OR REPLACE PROCEDURE CPI.gicls032_aeg_create_acct_ent (
   p_claim_id           gicl_claims.claim_id%TYPE,
   p_advice_id          gicl_advice.advice_id%TYPE,
   p_variables          gicl_advice_pkg.gicls032_variables,
   aeg_sl_cd            giac_acct_entries.sl_cd%TYPE,
   aeg_module_id        giac_module_entries.module_id%TYPE,
   aeg_item_no          NUMBER,                                                                --GIAC_MODULE_ENTRIES.item_no%TYPE,
   aeg_line_cd          giis_line.line_cd%TYPE,
   aeg_trty_type        giis_dist_share.acct_trty_type%TYPE,
   aeg_acct_amt         giac_direct_prem_collns.collection_amt%TYPE,
   aeg_payee_class_cd   gicl_acct_entries.payee_class_cd%TYPE,
   aeg_payee_cd         gicl_acct_entries.payee_cd%TYPE,
   aeg_gen_type         giac_acct_entries.generation_type%TYPE,
   aeg_whold            gicl_loss_exp_tax.tax_type%TYPE
)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - aeg_create_acct_entries
   */

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
   ws_trty_type_level      giac_module_entries.ca_treaty_type_level%TYPE;
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
   ws_sl_type_cd           giac_chart_of_accts.gslt_sl_type_cd%TYPE;
   ws_ri_parm              giac_parameters.param_value_v%TYPE;
   ws_sl_cd                giac_acct_entries.sl_cd%TYPE;
   v_line_cd               gicl_claims.line_cd%TYPE;
   v_subline_cd            gicl_claims.subline_cd%TYPE;
   v_iss_cd                gicl_claims.iss_cd%TYPE;
   v_pol_iss_cd            gicl_claims.pol_iss_cd%TYPE;
   v_ri_cd                 gicl_claims.ri_cd%TYPE;
   v_assd_no               gicl_claims.assd_no%TYPE;
BEGIN
   SELECT line_cd, subline_cd, iss_cd, ri_cd, pol_iss_cd, assd_no
     INTO v_line_cd, v_subline_cd, v_iss_cd, v_ri_cd, v_pol_iss_cd, v_assd_no
     FROM gicl_claims
    WHERE claim_id = p_claim_id;

   /**************************************************************************
   *                                                                         *
   * Populate the GL Account Code used in every transactions.                *
   *                                                                         *
   **************************************************************************/
   IF aeg_whold IS NULL
   THEN
      BEGIN
         SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, pol_type_tag, NVL (intm_type_level, 0),
                old_new_acct_level, NVL (line_dependency_level, 0), dr_cr_tag, NVL (ca_treaty_type_level, 0), sl_type_cd
           INTO ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1, ws_gl_sub_acct_2, ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                ws_gl_sub_acct_5, ws_gl_sub_acct_6, ws_gl_sub_acct_7, ws_pol_type_tag, ws_intm_type_level,
                ws_old_new_acct_level, ws_line_dep_level, ws_dr_cr_tag, ws_trty_type_level, ws_sl_type_cd
           FROM giac_module_entries
          WHERE module_id = aeg_module_id AND item_no = aeg_item_no;
--       FOR UPDATE of gl_sub_acct_1;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            gicl_advice_pkg.revert_advice (p_claim_id);
            raise_application_error (-20001, 'Geniisys Exception#E#No data found in giac_module_entries. $$$$'|| aeg_module_id);
      END;
   ELSIF aeg_whold = 'W'
   THEN
      BEGIN
         SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7, dr_cr_tag, gslt_sl_type_cd
           INTO ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1, ws_gl_sub_acct_2, ws_gl_sub_acct_3, ws_gl_sub_acct_4,
                ws_gl_sub_acct_5, ws_gl_sub_acct_6, ws_gl_sub_acct_7, ws_dr_cr_tag, ws_sl_type_cd
           FROM giac_chart_of_accts
          WHERE gl_acct_id = (SELECT gl_acct_id
                                FROM giac_wholding_taxes
                               WHERE whtax_id = aeg_item_no);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            gicl_advice_pkg.revert_advice (p_claim_id);
            raise_application_error (-20001, 'Geniisys Exception#E#No data giac_wholding_taxes.');
      END;
   END IF;

   /**************************************************************************
   *                      *
   * Validate if the General Ledger Account Category is Zero. If It is the   *
   * item in the Module Entries will not be used, thus it will not execute   *
   * the rest of the program unit.              *
   *                                                                         *
   **************************************************************************/
   IF ws_gl_acct_category = 0
   THEN
      RETURN;
   END IF;

   /**************************************************************************
   *                                                                         *
   * Validate the INTM_TYPE_LEVEL value which indicates the segment of the   *
   * GL account code that holds the intermediary type.                       *
   *                                                                         *
   **************************************************************************/
   IF ws_intm_type_level != 0
   THEN
      gicls032_get_intm_type (p_claim_id, p_variables.v_ri_iss_cd, ws_acct_intm_cd);

      IF aeg_line_cd = 'Y'
      THEN
         ws_acct_intm_cd := ws_acct_intm_cd * 3 - 1;
      END IF;

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
            gicl_advice_pkg.revert_advice (p_claim_id);
            raise_application_error (-20001, 'Geniisys Exception#E#No data found in giis_line.');
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
   * Validate the CA_TREATY_TYPE_LEVEL value which indicates the segment of  *
   * the GL account code that holds the treaty type code.                    *
   *                                                                         *
   **************************************************************************/
   IF ws_trty_type_level != 0
   THEN
      aeg_check_level (ws_trty_type_level,
                       aeg_trty_type,
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
                             ws_gl_acct_id
                            );

  /***************************************************************************
  *                       *
  * Fetch the SL TYPE from GIAC_CHART_OF_ACCTS table and compare it to the   *
  * value of RI_SL_TYPE of GIAC_PARAMETERS...this will identify the value of *
  * the SL CODE of GIAC_ACCT_ENTRIES.               *
  *                       *
  ***************************************************************************/
/* modified by judyann 03182002
** added other possible values of sl_type_cd
** for generation of accounting entries connected to claims
*/
   IF (v_iss_cd = p_variables.v_ri_iss_cd AND ws_sl_type_cd = p_variables.v_ri_sl_type AND aeg_item_no IN (1, 4))
   THEN                                                                        --to insert sl_cd of ceding company; juday 12172004
      ws_sl_cd := v_ri_cd;
   ELSIF ws_sl_type_cd = p_variables.v_ri_sl_type
   THEN                                                                                             --to insert sl_cd of reinsurer
      ws_sl_cd := aeg_sl_cd;
   ELSIF ws_sl_type_cd = p_variables.v_lsp_sl_type
   THEN                                                                                    --to insert sl_cd of line-subline-peril
      lsp_sl_code (p_variables.v_claim_sl_cd, v_line_cd, v_subline_cd, aeg_sl_cd, ws_sl_cd);
   ELSIF ws_sl_type_cd = p_variables.v_branch_sl_type
   THEN                                                                                 --to insert sl_cd of policy issuing source
      branch_sl_cd (v_pol_iss_cd, ws_sl_cd);
   ELSIF ws_sl_type_cd = p_variables.v_assd_sl_type
   THEN                                                                                               --to insert sl_cd of assured
      ws_sl_cd := v_assd_no;
   ELSIF ws_sl_type_cd = p_variables.v_intm_sl_type
   THEN
      FOR m IN (SELECT intm_no
                  FROM gicl_intm_itmperil
                 WHERE claim_id = p_claim_id)
      LOOP
         ws_sl_cd := m.intm_no;
      END LOOP;
   --intm_sl_cd (p_claim_id, ws_sl_cd);
   ELSIF ws_sl_type_cd = p_variables.v_adj_sl_type
   THEN                                                                                              --to insert sl_cd of adjuster
      IF aeg_payee_class_cd = giacp.v ('ADJP_CLASS_CD')
      THEN
         ws_sl_cd := gicl_clm_loss_exp_pkg.get_payee_cd (p_claim_id, aeg_payee_class_cd);
      ELSE
         ws_sl_cd := NULL;
      END IF;
   ELSIF ws_sl_type_cd = p_variables.v_lawyer_sl_type
   THEN                                                                                                --to insert sl_cd of lawyer
      IF aeg_payee_class_cd = giacp.v ('LAWYER_CLASS_CD')
      THEN
         ws_sl_cd := gicl_clm_loss_exp_pkg.get_payee_cd (p_claim_id, aeg_payee_class_cd);
      ELSE
         ws_sl_cd := NULL;
      END IF;
   ELSIF ws_sl_type_cd = p_variables.v_motshop_sl_type
   THEN                                                                                             --to insert sl_cd of motorshop
      IF aeg_payee_class_cd = giacp.v ('MC_PAYEE_CLASS')
      THEN
         ws_sl_cd := gicl_clm_loss_exp_pkg.get_payee_cd (p_claim_id, aeg_payee_class_cd);
      ELSE
         ws_sl_cd := NULL;
      END IF;
   END IF;

   /****************************************************************************
   *                                                                           *
   * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
   * debit-credit tag to determine whether the positive amount will be debited *
   * or credited.                                                              *
   *                                                                           *
   ****************************************************************************/
   IF (aeg_module_id = p_variables.os_module_id)
   THEN
--     or (aeg_whold = 'W' and variable.v_wheld_net_tag = 'Y')then
      IF ws_dr_cr_tag = 'D'
      THEN
         IF aeg_acct_amt > 0
         THEN
            ws_credit_amt := ABS (aeg_acct_amt);
            ws_debit_amt := 0;
         ELSE
            ws_credit_amt := 0;
            ws_debit_amt := ABS (aeg_acct_amt);
         END IF;
      ELSE
         IF aeg_acct_amt > 0
         THEN
            ws_credit_amt := 0;
            ws_debit_amt := ABS (aeg_acct_amt);
         ELSE
            ws_credit_amt := ABS (aeg_acct_amt);
            ws_debit_amt := 0;
         END IF;
      END IF;
   ELSE
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
   END IF;

   /****************************************************************************
   *                                                                           *
   * Check if the derived GL code exists in GICL_ACCT_ENTRIES table for the    *
   * same transaction id.  Insert the record if it does not exists else update *
   * the existing record.                                                      *
   *                                                                           *
   ****************************************************************************/   
   gicls032_aeg_ins_upd_acct_ent (p_claim_id,
                                  p_advice_id,
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
                                  ws_credit_amt,
                                  ws_sl_type_cd,
                                  aeg_payee_class_cd,
                                  aeg_payee_cd
                                 );
END;
/


