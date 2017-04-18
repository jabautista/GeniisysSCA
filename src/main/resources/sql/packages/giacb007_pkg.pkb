CREATE OR REPLACE PACKAGE BODY cpi.giacb007_pkg
AS
/*
**  Created by   : Benjo Brito
**  Date Created : 10.13.2016
**  Remarks      : GIACB007 - Generate accounting entries for takeup of inward treaty production
*/
   PROCEDURE prod_take_up (
      p_prod_date   IN       DATE,
      p_user_id     IN       giis_users.user_id%TYPE,
      p_msg         OUT      VARCHAR2
   )
   IS
      v_prod_date   DATE         := p_prod_date;
      v_addl        VARCHAR2 (1) := 'N';
      v_exists      VARCHAR2 (1);
      v_msg_1       NUMBER       := 0;
      v_msg_2       NUMBER       := 0;
   BEGIN
      giis_users_pkg.app_user := p_user_id;

      BEGIN
         FOR i IN (SELECT tran_id
                     FROM giac_acctrans
                    WHERE tran_class = 'INT'
                      AND tran_flag = 'P'
                      AND TO_CHAR (tran_date, 'mm-dd-yyyy') =
                                           TO_CHAR (v_prod_date, 'mm-dd-yyyy'))
         LOOP
            v_addl := 'Y';
            v_msg_1 := v_msg_1 + 1;

            IF v_msg_1 = 1
            THEN
               p_msg :=
                     p_msg
                  || '#Production for '
                  || TO_CHAR (v_prod_date, 'fmMonth dd,yyyy')
                  || ' has already been done.This will be an additional take up.';
            END IF;

            <<get_new_prod_date>>
            v_prod_date := v_prod_date - 1;

            BEGIN
               SELECT DISTINCT 'x'
                          INTO v_exists
                          FROM giac_acctrans
                         WHERE tran_class = 'INT'
                           AND tran_flag = 'P'
                           AND TO_CHAR (tran_date, 'mm-dd-yyyy') =
                                           TO_CHAR (v_prod_date, 'mm-dd-yyyy');

               IF v_exists = 'x'
               THEN
                  GOTO get_new_prod_date;
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  BEGIN
                     SELECT DISTINCT 'x'
                                INTO v_exists
                                FROM giac_acctrans
                               WHERE tran_class = 'INT'
                                 AND tran_flag = 'C'
                                 AND TO_CHAR (tran_date, 'mm-dd-yyyy') =
                                           TO_CHAR (v_prod_date, 'mm-dd-yyyy');

                     IF v_msg_1 = 1
                     THEN
                        p_msg :=
                              p_msg
                           || '#Production take up for '
                           || TO_CHAR (v_prod_date, 'fmMonth dd,yyyy')
                           || ' has already been done. This will be a complete take up of this transaction date.';
                     END IF;

                     UPDATE giri_intreaty
                        SET acct_ent_date = NULL
                      WHERE TO_CHAR (acct_ent_date, 'mm-dd-yyyy') =
                                           TO_CHAR (v_prod_date, 'mm-dd-yyyy');

                     UPDATE giri_intreaty
                        SET acct_neg_date = NULL
                      WHERE TO_CHAR (acct_neg_date, 'mm-dd-yyyy') =
                                           TO_CHAR (v_prod_date, 'mm-dd-yyyy');

                     DELETE FROM giac_inw_treaty_takeup
                           WHERE takeup_year =
                                     TO_NUMBER (TO_CHAR (v_prod_date, 'YYYY'))
                             AND takeup_mm =
                                       TO_NUMBER (TO_CHAR (v_prod_date, 'MM'));

                     FOR x IN (SELECT tran_id
                                 FROM giac_acctrans
                                WHERE tran_class = 'INT'
                                  AND tran_flag = 'C'
                                  AND TO_CHAR (tran_date, 'mm-dd-yyyy') =
                                           TO_CHAR (v_prod_date, 'mm-dd-yyyy'))
                     LOOP
                        UPDATE giac_acctrans
                           SET tran_flag = 'D'
                         WHERE tran_id = x.tran_id;
                     END LOOP;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        NULL;
                  END;
            END;
         END LOOP;
      END;

      IF v_addl = 'N'
      THEN
         UPDATE giri_intreaty
            SET acct_ent_date = NULL
          WHERE TO_CHAR (acct_ent_date, 'mm-dd-yyyy') =
                                           TO_CHAR (v_prod_date, 'mm-dd-yyyy');

         UPDATE giri_intreaty
            SET acct_neg_date = NULL
          WHERE TO_CHAR (acct_neg_date, 'mm-dd-yyyy') =
                                           TO_CHAR (v_prod_date, 'mm-dd-yyyy');

         DELETE FROM giac_inw_treaty_takeup
               WHERE takeup_year = TO_NUMBER (TO_CHAR (v_prod_date, 'YYYY'))
                 AND takeup_mm = TO_NUMBER (TO_CHAR (v_prod_date, 'MM'));

         FOR i IN (SELECT tran_id
                     FROM giac_acctrans
                    WHERE tran_class = 'INT'
                      AND tran_flag = 'C'
                      AND TO_CHAR (tran_date, 'mm-dd-yyyy') =
                                           TO_CHAR (v_prod_date, 'mm-dd-yyyy'))
         LOOP
            UPDATE giac_acctrans
               SET tran_flag = 'D'
             WHERE tran_id = i.tran_id;

            v_msg_2 := v_msg_2 + 1;

            IF v_msg_2 = 1
            THEN
               p_msg :=
                     p_msg
                  || '#Production take up for '
                  || TO_CHAR (v_prod_date, 'fmMonth dd,yyyy')
                  || ' has already been done. This will be a complete retake-up.';
            END IF;
         END LOOP;
      END IF;

      giacb007_pkg.generate_acct_entries (v_prod_date, p_msg);
   END;

   PROCEDURE generate_acct_entries (p_prod_date IN DATE, p_msg IN OUT VARCHAR2)
   IS
      v_gfun_fund_cd       giac_parameters.param_value_v%TYPE;
      v_gibr_branch_cd     giac_parameters.param_value_v%TYPE;
      v_count              NUMBER (1)                                  := 0;
      v_takeup_id          giac_inw_treaty_takeup.takeup_id%TYPE       := 1;
      v_takeup_year        giac_inw_treaty_takeup.takeup_year%TYPE
                                 := TO_NUMBER (TO_CHAR (p_prod_date, 'YYYY'));
      v_takeup_mm          giac_inw_treaty_takeup.takeup_mm%TYPE
                                   := TO_NUMBER (TO_CHAR (p_prod_date, 'MM'));
      v_multiplier         NUMBER                                      := 1;
      v_ri_prem_amt        giri_intreaty.ri_prem_amt%TYPE;
      v_ri_comm_amt        giri_intreaty.ri_comm_amt%TYPE;
      v_ri_comm_vat        giri_intreaty.ri_comm_vat%TYPE;
      v_charge_amt         giri_incharges_tax.charge_amt%TYPE;
      v_charge_vat         giri_incharges_tax.tax_amt%TYPE;
      v_charge_wtax        giri_incharges_tax.tax_amt%TYPE;
      v_fc_prem_amt        giri_intreaty.ri_prem_amt%TYPE;
      v_fc_comm_amt        giri_intreaty.ri_comm_amt%TYPE;
      v_fc_comm_vat        giri_intreaty.ri_comm_vat%TYPE;
      v_fc_charge_amt      giri_incharges_tax.charge_amt%TYPE;
      v_fc_charge_vat      giri_incharges_tax.tax_amt%TYPE;
      v_fc_charge_wtax     giri_incharges_tax.tax_amt%TYPE;
      v_tran_id            giac_acctrans.tran_id%TYPE;
      v_item_no            giac_module_entries.item_no%TYPE;
      v_gl_acct_category   giac_module_entries.gl_acct_category%TYPE;
      v_gl_control_acct    giac_module_entries.gl_control_acct%TYPE;
      v_dr_cr_tag          giac_module_entries.dr_cr_tag%TYPE;
      v_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%TYPE;
      v_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%TYPE;
      v_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%TYPE;
      v_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%TYPE;
      v_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%TYPE;
      v_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%TYPE;
      v_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%TYPE;
      v_sl_type_cd         giac_module_entries.sl_type_cd%TYPE;
      v_generation_type    giac_modules.generation_type%TYPE;
      v_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE;
      v_sl_cd              giac_acct_entries.sl_cd%TYPE;
      v_amount             NUMBER                                      := 0;
      v_debit_amt          NUMBER                                      := 0;
      v_credit_amt         NUMBER                                      := 0;
   BEGIN
      v_gfun_fund_cd := giacp.v ('FUND_CD');
      v_gibr_branch_cd := giacp.v ('BRANCH_CD');

      FOR rec IN (SELECT intreaty_id, line_cd, trty_yy, intrty_seq_no,
                         share_cd, ri_cd, ri_prem_amt, ri_comm_amt,
                         ri_comm_vat, currency_cd, currency_rt, intrty_flag
                    FROM giri_intreaty
                   WHERE 1 = 1
                     AND (   (    intrty_flag = 2
                              AND TO_DATE (booking_mth || '-' || booking_yy,
                                           'FMMONTH-YYYY'
                                          ) <= p_prod_date
                              AND acct_ent_date IS NULL
                              AND cancel_date IS NULL
                              AND approve_date IS NOT NULL
                             )
                          OR (    intrty_flag = 3
                              AND acct_ent_date IS NOT NULL
                              AND acct_neg_date IS NULL
                              AND cancel_date IS NOT NULL
                             )
                         ))
      LOOP
         v_count := v_count + 1;

         BEGIN
            SELECT SUM (amount)
              INTO v_charge_amt
              FROM giri_intreaty_charges
             WHERE intreaty_id = rec.intreaty_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_charge_amt := 0;
         END;
         
         BEGIN
            SELECT SUM (DECODE (tax_type, 'I', tax_amt, 0)),
                   SUM (DECODE (tax_type, 'W', tax_amt, 0))
              INTO v_charge_vat,
                   v_charge_wtax
              FROM giri_incharges_tax
             WHERE intreaty_id = rec.intreaty_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_charge_vat := 0;
               v_charge_wtax := 0;
         END;

         BEGIN
            SELECT MAX (takeup_id) + 1
              INTO v_takeup_id
              FROM giac_inw_treaty_takeup;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_takeup_id := 1;
         END;

         IF rec.intrty_flag = 3
         THEN
            v_multiplier := -1;
         END IF;

         v_fc_prem_amt    := NVL (rec.ri_prem_amt, 0) * v_multiplier;
         v_fc_comm_amt    := NVL (rec.ri_comm_amt, 0) * v_multiplier;
         v_fc_comm_vat    := NVL (rec.ri_comm_vat, 0) * v_multiplier;
         v_fc_charge_amt  := NVL (v_charge_amt, 0) * v_multiplier;
         v_fc_charge_vat  := NVL (v_charge_vat, 0) * v_multiplier;
         v_fc_charge_wtax := NVL (v_charge_wtax, 0) * v_multiplier;
         v_ri_prem_amt    := NVL (rec.ri_prem_amt, 0) * rec.currency_rt * v_multiplier;
         v_ri_comm_amt    := NVL (rec.ri_comm_amt, 0) * rec.currency_rt * v_multiplier;
         v_ri_comm_vat    := NVL (rec.ri_comm_vat, 0) * rec.currency_rt * v_multiplier;
         v_charge_amt     := NVL (v_charge_amt, 0) * rec.currency_rt * v_multiplier;
         v_charge_vat     := NVL (v_charge_vat, 0) * rec.currency_rt * v_multiplier;
         v_charge_wtax    := NVL (v_charge_wtax, 0) * rec.currency_rt * v_multiplier;

         INSERT INTO giac_inw_treaty_takeup
                     (takeup_id, takeup_year, takeup_mm,
                      intreaty_id, line_cd, trty_yy,
                      intrty_seq_no, share_cd, ri_cd,
                      ri_prem_amt, ri_comm_amt, ri_comm_vat,
                      charge_amt, charge_vat, charge_wtax,
                      currency_cd, currency_rt, fc_prem_amt,
                      fc_comm_amt, fc_comm_vat, fc_charge_amt,
                      fc_charge_vat, fc_charge_wtax
                     )
              VALUES (NVL (v_takeup_id, 1), v_takeup_year, v_takeup_mm,
                      rec.intreaty_id, rec.line_cd, rec.trty_yy,
                      rec.intrty_seq_no, rec.share_cd, rec.ri_cd,
                      v_ri_prem_amt, v_ri_comm_amt, v_ri_comm_vat,
                      v_charge_amt, v_charge_vat, v_charge_wtax,
                      rec.currency_cd, rec.currency_rt, v_fc_prem_amt,
                      v_fc_comm_amt, v_fc_comm_vat, v_fc_charge_amt,
                      v_fc_charge_vat, v_fc_charge_wtax
                     );

         IF v_count = 1
         THEN
            giacb007_pkg.insert_giac_acctrans (p_prod_date, v_tran_id, p_msg);

            DELETE FROM giac_acct_entries
                  WHERE gacc_tran_id = v_tran_id;
         END IF;

         FOR rec2 IN (SELECT   a.item_no, a.gl_acct_category,
                               a.gl_control_acct, a.dr_cr_tag,
                               a.gl_sub_acct_1, a.gl_sub_acct_2,
                               a.gl_sub_acct_3, a.gl_sub_acct_4,
                               a.gl_sub_acct_5, a.gl_sub_acct_6,
                               a.gl_sub_acct_7, a.sl_type_cd,
                               a.line_dependency_level, b.generation_type
                          FROM giac_module_entries a, giac_modules b
                         WHERE a.module_id = b.module_id
                           AND module_name = 'GIACB007'
                      ORDER BY item_no)
         LOOP
            v_item_no := rec2.item_no;
            v_gl_acct_category := rec2.gl_acct_category;
            v_gl_control_acct := rec2.gl_control_acct;
            v_dr_cr_tag := rec2.dr_cr_tag;
            v_gl_sub_acct_1 := rec2.gl_sub_acct_1;
            v_gl_sub_acct_2 := rec2.gl_sub_acct_2;
            v_gl_sub_acct_3 := rec2.gl_sub_acct_3;
            v_gl_sub_acct_4 := rec2.gl_sub_acct_4;
            v_gl_sub_acct_5 := rec2.gl_sub_acct_5;
            v_gl_sub_acct_6 := rec2.gl_sub_acct_6;
            v_gl_sub_acct_7 := rec2.gl_sub_acct_7;
            v_sl_type_cd := rec2.sl_type_cd;
            v_generation_type := rec2.generation_type;

            IF v_sl_type_cd = 2
            THEN
               v_sl_cd := rec.ri_cd;
            ELSE
               v_sl_cd := NULL;
            END IF;

            IF rec2.line_dependency_level != 0
            THEN
               giacb007_pkg.check_level
                                 (rec2.line_dependency_level,
                                  giacb007_pkg.get_acct_line_cd (rec.line_cd),
                                  v_gl_sub_acct_1,
                                  v_gl_sub_acct_2,
                                  v_gl_sub_acct_3,
                                  v_gl_sub_acct_4,
                                  v_gl_sub_acct_5,
                                  v_gl_sub_acct_6,
                                  v_gl_sub_acct_7
                                 );
            END IF;

            giacb007_pkg.check_chart_of_accts (v_gl_acct_category,
                                               v_gl_control_acct,
                                               v_gl_sub_acct_1,
                                               v_gl_sub_acct_2,
                                               v_gl_sub_acct_3,
                                               v_gl_sub_acct_4,
                                               v_gl_sub_acct_5,
                                               v_gl_sub_acct_6,
                                               v_gl_sub_acct_7,
                                               v_gl_acct_id,
                                               v_dr_cr_tag,
                                               p_msg
                                              );

            IF v_item_no IN (1, 2, 3, 6)
            THEN
               IF v_item_no = 1
               THEN
                  v_amount := v_ri_prem_amt;
               ELSIF v_item_no = 2
               THEN
                  IF NVL (giacp.v ('INWPREM_TAKE_UP'), '1') = '1'
                  THEN
                     v_amount :=
                          v_ri_prem_amt
                        - (v_ri_comm_amt + v_ri_comm_vat)
                        + (v_charge_amt + v_charge_vat + v_charge_wtax);
                  ELSE
                     v_amount :=
                          v_ri_prem_amt
                        + (v_charge_amt + v_charge_vat + v_charge_wtax);
                  END IF;
               ELSIF v_item_no = 3
               THEN
                  v_amount := v_ri_comm_amt;
               ELSIF v_item_no = 6
               THEN
                  v_amount := v_ri_comm_vat;
               END IF;
               
               v_amount := v_amount * v_multiplier;
               
               IF v_multiplier = 1
               THEN
                  get_drcr_amt (v_dr_cr_tag, v_amount, v_credit_amt,
                                 v_debit_amt);
               ELSE
                  get_drcr_amt (v_dr_cr_tag, v_amount, v_debit_amt,
                                 v_credit_amt);
               END IF;

               IF NVL (giacp.v ('INWPREM_TAKE_UP'), '1') = '2' AND v_item_no IN (3, 6) THEN
                   NULL;
               ELSE
                   IF giacb007_pkg.check_if_exist (v_tran_id,
                                                   v_gfun_fund_cd,
                                                   v_gibr_branch_cd,
                                                   v_gl_acct_id,
                                                   v_gl_acct_category,
                                                   v_gl_control_acct,
                                                   v_gl_sub_acct_1,
                                                   v_gl_sub_acct_2,
                                                   v_gl_sub_acct_3,
                                                   v_gl_sub_acct_4,
                                                   v_gl_sub_acct_5,
                                                   v_gl_sub_acct_6,
                                                   v_gl_sub_acct_7,
                                                   v_sl_cd
                                                  )
                   THEN
                      UPDATE giac_acct_entries
                         SET debit_amt = NVL (debit_amt, 0) + NVL (v_debit_amt, 0),
                             credit_amt = NVL (credit_amt, 0) + NVL (v_credit_amt, 0)
                       WHERE gacc_tran_id = v_tran_id
                         AND gacc_gfun_fund_cd = v_gfun_fund_cd
                         AND gacc_gibr_branch_cd = v_gibr_branch_cd
                         AND gl_acct_id = v_gl_acct_id
                         AND gl_acct_category = v_gl_acct_category
                         AND gl_control_acct = v_gl_control_acct
                         AND gl_sub_acct_1 = v_gl_sub_acct_1
                         AND gl_sub_acct_2 = v_gl_sub_acct_2
                         AND gl_sub_acct_3 = v_gl_sub_acct_3
                         AND gl_sub_acct_4 = v_gl_sub_acct_4
                         AND gl_sub_acct_5 = v_gl_sub_acct_5
                         AND gl_sub_acct_6 = v_gl_sub_acct_6
                         AND gl_sub_acct_7 = v_gl_sub_acct_7
                         AND NVL (sl_cd, 0) = NVL (v_sl_cd, NVL (sl_cd, 0));
                   ELSE
                      giacb007_pkg.insert_giac_acct_entries (v_tran_id,
                                                             v_gfun_fund_cd,
                                                             v_gibr_branch_cd,
                                                             v_gl_acct_id,
                                                             v_gl_acct_category,
                                                             v_gl_control_acct,
                                                             v_gl_sub_acct_1,
                                                             v_gl_sub_acct_2,
                                                             v_gl_sub_acct_3,
                                                             v_gl_sub_acct_4,
                                                             v_gl_sub_acct_5,
                                                             v_gl_sub_acct_6,
                                                             v_gl_sub_acct_7,
                                                             v_sl_cd,
                                                             v_debit_amt,
                                                             v_credit_amt,
                                                             v_generation_type,
                                                             v_sl_type_cd
                                                            );
                   END IF;
               END IF;
            END IF;
         END LOOP;

         FOR rec3 IN (SELECT a.amount, b.gl_acct_id, b.gl_acct_category,
                             b.gl_control_acct, b.gl_sub_acct_1,
                             b.gl_sub_acct_2, b.gl_sub_acct_3,
                             b.gl_sub_acct_4, b.gl_sub_acct_5,
                             b.gl_sub_acct_6, b.gl_sub_acct_7
                        FROM giri_intreaty_charges a, giac_taxes b
                       WHERE a.charge_cd = b.tax_cd
                         AND b.fund_cd = v_gfun_fund_cd
                         AND a.intreaty_id = rec.intreaty_id)
         LOOP
            v_gl_acct_category := rec3.gl_acct_category;
            v_gl_control_acct := rec3.gl_control_acct;
            v_gl_sub_acct_1 := rec3.gl_sub_acct_1;
            v_gl_sub_acct_2 := rec3.gl_sub_acct_2;
            v_gl_sub_acct_3 := rec3.gl_sub_acct_3;
            v_gl_sub_acct_4 := rec3.gl_sub_acct_4;
            v_gl_sub_acct_5 := rec3.gl_sub_acct_5;
            v_gl_sub_acct_6 := rec3.gl_sub_acct_6;
            v_gl_sub_acct_7 := rec3.gl_sub_acct_7;
            v_gl_acct_id := rec3.gl_acct_id;
            v_amount := NVL (rec3.amount, 0) * rec.currency_rt;
            v_sl_type_cd := NULL;
            v_sl_cd := NULL;
            v_generation_type := NULL;
            giacb007_pkg.check_chart_of_accts (v_gl_acct_category,
                                               v_gl_control_acct,
                                               v_gl_sub_acct_1,
                                               v_gl_sub_acct_2,
                                               v_gl_sub_acct_3,
                                               v_gl_sub_acct_4,
                                               v_gl_sub_acct_5,
                                               v_gl_sub_acct_6,
                                               v_gl_sub_acct_7,
                                               v_gl_acct_id,
                                               v_dr_cr_tag,
                                               p_msg
                                              );

            IF v_multiplier = 1
            THEN
               get_drcr_amt (v_dr_cr_tag, v_amount, v_credit_amt,
                             v_debit_amt);
            ELSE
               get_drcr_amt (v_dr_cr_tag, v_amount, v_debit_amt,
                             v_credit_amt);
            END IF;

            IF giacb007_pkg.check_if_exist (v_tran_id,
                                            v_gfun_fund_cd,
                                            v_gibr_branch_cd,
                                            v_gl_acct_id,
                                            v_gl_acct_category,
                                            v_gl_control_acct,
                                            v_gl_sub_acct_1,
                                            v_gl_sub_acct_2,
                                            v_gl_sub_acct_3,
                                            v_gl_sub_acct_4,
                                            v_gl_sub_acct_5,
                                            v_gl_sub_acct_6,
                                            v_gl_sub_acct_7,
                                            v_sl_cd
                                           )
            THEN
               UPDATE giac_acct_entries
                  SET debit_amt = NVL (debit_amt, 0) + NVL (v_debit_amt, 0),
                      credit_amt = NVL (credit_amt, 0) + NVL (v_credit_amt, 0)
                WHERE gacc_tran_id = v_tran_id
                  AND gacc_gfun_fund_cd = v_gfun_fund_cd
                  AND gacc_gibr_branch_cd = v_gibr_branch_cd
                  AND gl_acct_id = v_gl_acct_id
                  AND gl_acct_category = v_gl_acct_category
                  AND gl_control_acct = v_gl_control_acct
                  AND gl_sub_acct_1 = v_gl_sub_acct_1
                  AND gl_sub_acct_2 = v_gl_sub_acct_2
                  AND gl_sub_acct_3 = v_gl_sub_acct_3
                  AND gl_sub_acct_4 = v_gl_sub_acct_4
                  AND gl_sub_acct_5 = v_gl_sub_acct_5
                  AND gl_sub_acct_6 = v_gl_sub_acct_6
                  AND gl_sub_acct_7 = v_gl_sub_acct_7
                  AND NVL (sl_cd, 0) = NVL (v_sl_cd, NVL (sl_cd, 0));
            ELSE
               giacb007_pkg.insert_giac_acct_entries (v_tran_id,
                                                      v_gfun_fund_cd,
                                                      v_gibr_branch_cd,
                                                      v_gl_acct_id,
                                                      v_gl_acct_category,
                                                      v_gl_control_acct,
                                                      v_gl_sub_acct_1,
                                                      v_gl_sub_acct_2,
                                                      v_gl_sub_acct_3,
                                                      v_gl_sub_acct_4,
                                                      v_gl_sub_acct_5,
                                                      v_gl_sub_acct_6,
                                                      v_gl_sub_acct_7,
                                                      v_sl_cd,
                                                      v_debit_amt,
                                                      v_credit_amt,
                                                      v_generation_type,
                                                      v_sl_type_cd
                                                     );
            END IF;
         END LOOP;

         FOR rec4 IN (SELECT tax_type, tax_cd, sl_type_cd, sl_cd, tax_amt
                        FROM giri_incharges_tax
                       WHERE intreaty_id = rec.intreaty_id)
         LOOP
            v_amount := NVL (rec4.tax_amt, 0) * rec.currency_rt;
            v_sl_type_cd := rec4.sl_type_cd;
            v_sl_cd := rec4.sl_cd;

            IF rec4.tax_type = 'I'
            THEN
               SELECT a.gl_acct_category, a.gl_control_acct, a.dr_cr_tag,
                      a.gl_sub_acct_1, a.gl_sub_acct_2, a.gl_sub_acct_3,
                      a.gl_sub_acct_4, a.gl_sub_acct_5, a.gl_sub_acct_6,
                      a.gl_sub_acct_7, b.generation_type
                 INTO v_gl_acct_category, v_gl_control_acct, v_dr_cr_tag,
                      v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3,
                      v_gl_sub_acct_4, v_gl_sub_acct_5, v_gl_sub_acct_6,
                      v_gl_sub_acct_7, v_generation_type
                 FROM giac_module_entries a, giac_modules b
                WHERE a.module_id = b.module_id
                  AND b.module_name = 'GIACS039'
                  AND a.item_no = rec4.tax_cd;
            ELSIF rec4.tax_type = 'W'
            THEN
               v_generation_type := NULL;

               SELECT b.gl_acct_category, b.gl_control_acct, b.dr_cr_tag,
                      b.gl_sub_acct_1, b.gl_sub_acct_2, b.gl_sub_acct_3,
                      b.gl_sub_acct_4, b.gl_sub_acct_5, b.gl_sub_acct_6,
                      b.gl_sub_acct_7
                 INTO v_gl_acct_category, v_gl_control_acct, v_dr_cr_tag,
                      v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3,
                      v_gl_sub_acct_4, v_gl_sub_acct_5, v_gl_sub_acct_6,
                      v_gl_sub_acct_7
                 FROM giac_wholding_taxes a, giac_chart_of_accts b
                WHERE a.gl_acct_id = b.gl_acct_id AND a.whtax_id = rec4.tax_cd;
            END IF;

            giacb007_pkg.check_chart_of_accts (v_gl_acct_category,
                                               v_gl_control_acct,
                                               v_gl_sub_acct_1,
                                               v_gl_sub_acct_2,
                                               v_gl_sub_acct_3,
                                               v_gl_sub_acct_4,
                                               v_gl_sub_acct_5,
                                               v_gl_sub_acct_6,
                                               v_gl_sub_acct_7,
                                               v_gl_acct_id,
                                               v_dr_cr_tag,
                                               p_msg
                                              );

            IF v_multiplier = 1
            THEN
               get_drcr_amt (v_dr_cr_tag, v_amount, v_credit_amt,
                             v_debit_amt);
            ELSE
               get_drcr_amt (v_dr_cr_tag, v_amount, v_debit_amt,
                             v_credit_amt);
            END IF;

            IF giacb007_pkg.check_if_exist (v_tran_id,
                                            v_gfun_fund_cd,
                                            v_gibr_branch_cd,
                                            v_gl_acct_id,
                                            v_gl_acct_category,
                                            v_gl_control_acct,
                                            v_gl_sub_acct_1,
                                            v_gl_sub_acct_2,
                                            v_gl_sub_acct_3,
                                            v_gl_sub_acct_4,
                                            v_gl_sub_acct_5,
                                            v_gl_sub_acct_6,
                                            v_gl_sub_acct_7,
                                            v_sl_cd
                                           )
            THEN
               UPDATE giac_acct_entries
                  SET debit_amt = NVL (debit_amt, 0) + NVL (v_debit_amt, 0),
                      credit_amt = NVL (credit_amt, 0) + NVL (v_credit_amt, 0)
                WHERE gacc_tran_id = v_tran_id
                  AND gacc_gfun_fund_cd = v_gfun_fund_cd
                  AND gacc_gibr_branch_cd = v_gibr_branch_cd
                  AND gl_acct_id = v_gl_acct_id
                  AND gl_acct_category = v_gl_acct_category
                  AND gl_control_acct = v_gl_control_acct
                  AND gl_sub_acct_1 = v_gl_sub_acct_1
                  AND gl_sub_acct_2 = v_gl_sub_acct_2
                  AND gl_sub_acct_3 = v_gl_sub_acct_3
                  AND gl_sub_acct_4 = v_gl_sub_acct_4
                  AND gl_sub_acct_5 = v_gl_sub_acct_5
                  AND gl_sub_acct_6 = v_gl_sub_acct_6
                  AND gl_sub_acct_7 = v_gl_sub_acct_7
                  AND NVL (sl_cd, 0) = NVL (v_sl_cd, NVL (sl_cd, 0));
            ELSE
               giacb007_pkg.insert_giac_acct_entries (v_tran_id,
                                                      v_gfun_fund_cd,
                                                      v_gibr_branch_cd,
                                                      v_gl_acct_id,
                                                      v_gl_acct_category,
                                                      v_gl_control_acct,
                                                      v_gl_sub_acct_1,
                                                      v_gl_sub_acct_2,
                                                      v_gl_sub_acct_3,
                                                      v_gl_sub_acct_4,
                                                      v_gl_sub_acct_5,
                                                      v_gl_sub_acct_6,
                                                      v_gl_sub_acct_7,
                                                      v_sl_cd,
                                                      v_debit_amt,
                                                      v_credit_amt,
                                                      v_generation_type,
                                                      v_sl_type_cd
                                                     );
            END IF;
         END LOOP;

         IF v_multiplier = 1
         THEN
            UPDATE giri_intreaty
               SET acct_ent_date = p_prod_date
             WHERE intreaty_id = rec.intreaty_id;
         ELSE
            UPDATE giri_intreaty
               SET acct_neg_date = p_prod_date
             WHERE intreaty_id = rec.intreaty_id;
         END IF;
      END LOOP;

      IF v_count = 0
      THEN
         p_msg :=
            p_msg
            || '#No record/s available for batch accounting generation.';
      ELSE
         giacb007_pkg.check_debit_credit_amt (v_tran_id, p_msg);
      END IF;
   END;

   PROCEDURE insert_giac_acctrans (
      p_prod_date   IN       DATE,
      p_tran_id     OUT      giac_acctrans.tran_id%TYPE,
      p_msg         IN OUT   VARCHAR2
   )
   IS
      v_gfun_fund_cd     giac_parameters.param_value_v%TYPE;
      v_gibr_branch_cd   giac_parameters.param_value_v%TYPE;
      v_tran_flag        giac_acctrans.tran_flag%TYPE;
      v_tran_year        giac_acctrans.tran_year%TYPE;
      v_tran_month       giac_acctrans.tran_month%TYPE;
      v_tran_seq_no      giac_acctrans.tran_seq_no%TYPE;
      v_tran_class       giac_acctrans.tran_class%TYPE;
      v_tran_class_no    giac_acctrans.tran_class_no%TYPE;
   BEGIN
      v_gfun_fund_cd := giacp.v ('FUND_CD');
      v_gibr_branch_cd := giacp.v ('BRANCH_CD');
      v_tran_flag := 'C';
      v_tran_year := TO_NUMBER (TO_CHAR (p_prod_date, 'YYYY'));
      v_tran_month := TO_NUMBER (TO_CHAR (p_prod_date, 'MM'));
      v_tran_class := 'INT';

      BEGIN
         SELECT tran_id
           INTO p_tran_id
           FROM giac_acctrans
          WHERE gfun_fund_cd = v_gfun_fund_cd
            AND gibr_branch_cd = v_gibr_branch_cd
            AND tran_flag = v_tran_flag
            AND tran_year = v_tran_year
            AND tran_month = v_tran_month
            AND tran_class = v_tran_class
            AND TO_CHAR (tran_date, 'mm-dd-yyyy') =
                                           TO_CHAR (p_prod_date, 'mm-dd-yyyy');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            SELECT acctran_tran_id_s.NEXTVAL
              INTO p_tran_id
              FROM DUAL;

            v_tran_seq_no :=
               giac_sequence_generation (v_gfun_fund_cd,
                                         v_gibr_branch_cd,
                                         'TRAN_SEQ_NO',
                                         v_tran_year,
                                         0
                                        );
            v_tran_class_no :=
               giac_sequence_generation (v_gfun_fund_cd,
                                         v_gibr_branch_cd,
                                         v_tran_class,
                                         v_tran_year,
                                         v_tran_month
                                        );

            INSERT INTO giac_acctrans
                        (tran_id, gfun_fund_cd, gibr_branch_cd,
                         tran_date, tran_year, tran_month,
                         tran_seq_no, tran_flag, tran_class,
                         tran_class_no,
                         particulars,
                         user_id, last_update
                        )
                 VALUES (p_tran_id, v_gfun_fund_cd, v_gibr_branch_cd,
                         p_prod_date, v_tran_year, v_tran_month,
                         v_tran_seq_no, v_tran_flag, v_tran_class,
                         v_tran_class_no,
                            'Production take up of Inward Treaty for the month of '
                         || TO_CHAR (p_prod_date, 'fmMonth YYYY'),
                         giis_users_pkg.app_user, SYSDATE
                        );
      END;
   END;

   FUNCTION get_acct_line_cd (p_line_cd VARCHAR2)
      RETURN NUMBER
   IS
      CURSOR c1
      IS
         SELECT acct_line_cd
           FROM giis_line
          WHERE line_cd = p_line_cd;

      v_line   NUMBER := '';
   BEGIN
      OPEN c1;

      FETCH c1
       INTO v_line;

      IF c1%NOTFOUND
      THEN
         NULL;
      END IF;

      CLOSE c1;

      RETURN v_line;
   END;

   PROCEDURE check_level (
      p_line_dependency_level   IN       giac_module_entries.line_dependency_level%TYPE,
      p_acct_line_cd            IN       giis_line.acct_line_cd%TYPE,
      p_gl_sub_acct_1           IN OUT   giac_module_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2           IN OUT   giac_module_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3           IN OUT   giac_module_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4           IN OUT   giac_module_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5           IN OUT   giac_module_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6           IN OUT   giac_module_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7           IN OUT   giac_module_entries.gl_sub_acct_7%TYPE
   )
   IS
   BEGIN
      IF p_line_dependency_level = 1
      THEN
         p_gl_sub_acct_1 := p_acct_line_cd;
      ELSIF p_line_dependency_level = 2
      THEN
         p_gl_sub_acct_2 := p_acct_line_cd;
      ELSIF p_line_dependency_level = 3
      THEN
         p_gl_sub_acct_3 := p_acct_line_cd;
      ELSIF p_line_dependency_level = 4
      THEN
         p_gl_sub_acct_4 := p_acct_line_cd;
      ELSIF p_line_dependency_level = 5
      THEN
         p_gl_sub_acct_5 := p_acct_line_cd;
      ELSIF p_line_dependency_level = 6
      THEN
         p_gl_sub_acct_6 := p_acct_line_cd;
      ELSIF p_line_dependency_level = 7
      THEN
         p_gl_sub_acct_7 := p_acct_line_cd;
      END IF;
   END;

   PROCEDURE check_chart_of_accts (
      p_gl_acct_category   IN       giac_module_entries.gl_acct_category%TYPE,
      p_gl_control_acct    IN       giac_module_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1      IN       giac_module_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      IN       giac_module_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      IN       giac_module_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      IN       giac_module_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      IN       giac_module_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      IN       giac_module_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      IN       giac_module_entries.gl_sub_acct_7%TYPE,
      p_gl_acct_id         IN OUT   giac_chart_of_accts.gl_acct_id%TYPE,
      p_dr_cr_tag          IN OUT   giac_chart_of_accts.dr_cr_tag%TYPE,
      p_msg                IN OUT   VARCHAR2
   )
   IS
   BEGIN
      SELECT gl_acct_id, dr_cr_tag
        INTO p_gl_acct_id, p_dr_cr_tag
        FROM giac_chart_of_accts
       WHERE gl_acct_category = p_gl_acct_category
         AND gl_control_acct = p_gl_control_acct
         AND gl_sub_acct_1 = p_gl_sub_acct_1
         AND gl_sub_acct_2 = p_gl_sub_acct_2
         AND gl_sub_acct_3 = p_gl_sub_acct_3
         AND gl_sub_acct_4 = p_gl_sub_acct_4
         AND gl_sub_acct_5 = p_gl_sub_acct_5
         AND gl_sub_acct_6 = p_gl_sub_acct_6
         AND gl_sub_acct_7 = p_gl_sub_acct_7;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error
                     (-20001,
                         p_msg
                      || '#Geniisys Exception#GL account code '
                      || TO_CHAR (p_gl_acct_category)
                      || '-'
                      || TO_CHAR (p_gl_control_acct, '09')
                      || '-'
                      || TO_CHAR (p_gl_sub_acct_1, '09')
                      || '-'
                      || TO_CHAR (p_gl_sub_acct_2, '09')
                      || '-'
                      || TO_CHAR (p_gl_sub_acct_3, '09')
                      || '-'
                      || TO_CHAR (p_gl_sub_acct_4, '09')
                      || '-'
                      || TO_CHAR (p_gl_sub_acct_5, '09')
                      || '-'
                      || TO_CHAR (p_gl_sub_acct_6, '09')
                      || '-'
                      || TO_CHAR (p_gl_sub_acct_7, '09')
                      || ' does not exist in chart of accounts (giac_acctrans).'
                     );
   END;

   PROCEDURE insert_giac_acct_entries (
      p_gacc_tran_id          IN   giac_acct_entries.gacc_tran_id%TYPE,
      p_gacc_gfun_fund_cd     IN   giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_gibr_branch_cd   IN   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gl_acct_id            IN   giac_acct_entries.gl_acct_id%TYPE,
      p_gl_acct_category      IN   giac_acct_entries.gl_acct_category%TYPE,
      p_gl_control_acct       IN   giac_acct_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1         IN   giac_acct_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2         IN   giac_acct_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3         IN   giac_acct_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4         IN   giac_acct_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5         IN   giac_acct_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6         IN   giac_acct_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7         IN   giac_acct_entries.gl_sub_acct_7%TYPE,
      p_sl_cd                 IN   giac_acct_entries.sl_cd%TYPE,
      p_debit_amt             IN   giac_acct_entries.debit_amt%TYPE,
      p_credit_amt            IN   giac_acct_entries.credit_amt%TYPE,
      p_generation_type       IN   giac_acct_entries.generation_type%TYPE,
      p_sl_type_cd            IN   giac_acct_entries.sl_type_cd%TYPE
   )
   IS
      v_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE;
   BEGIN
      SELECT NVL (MAX (acct_entry_id), 0) acct_entry_id
        INTO v_acct_entry_id
        FROM giac_acct_entries
       WHERE gacc_tran_id = p_gacc_tran_id
         AND gacc_gfun_fund_cd = p_gacc_gfun_fund_cd
         AND gacc_gibr_branch_cd = p_gacc_gibr_branch_cd
         AND gl_acct_id = p_gl_acct_id
         AND gl_acct_category = p_gl_acct_category
         AND gl_control_acct = p_gl_control_acct
         AND gl_sub_acct_1 = p_gl_sub_acct_1
         AND gl_sub_acct_2 = p_gl_sub_acct_2
         AND gl_sub_acct_3 = p_gl_sub_acct_3
         AND gl_sub_acct_4 = p_gl_sub_acct_4
         AND gl_sub_acct_5 = p_gl_sub_acct_5
         AND gl_sub_acct_6 = p_gl_sub_acct_6
         AND gl_sub_acct_7 = p_gl_sub_acct_7
         AND NVL (sl_cd, 0) = NVL (p_sl_cd, NVL (sl_cd, 0));

      IF NVL (v_acct_entry_id, 0) = 0
      THEN
         v_acct_entry_id := NVL (v_acct_entry_id, 0) + 1;

         INSERT INTO giac_acct_entries
                     (gacc_tran_id, gacc_gfun_fund_cd,
                      gacc_gibr_branch_cd, acct_entry_id, gl_acct_id,
                      gl_acct_category, gl_control_acct,
                      gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                      gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                      gl_sub_acct_7, debit_amt, credit_amt,
                      generation_type, sl_cd, sl_type_cd, sl_source_cd,
                      user_id, last_update
                     )
              VALUES (p_gacc_tran_id, p_gacc_gfun_fund_cd,
                      p_gacc_gibr_branch_cd, v_acct_entry_id, p_gl_acct_id,
                      p_gl_acct_category, p_gl_control_acct,
                      p_gl_sub_acct_1, p_gl_sub_acct_2, p_gl_sub_acct_3,
                      p_gl_sub_acct_4, p_gl_sub_acct_5, p_gl_sub_acct_6,
                      p_gl_sub_acct_7, p_debit_amt, p_credit_amt,
                      p_generation_type, p_sl_cd, p_sl_type_cd, 1,
                      giis_users_pkg.app_user, SYSDATE
                     );
      ELSE
         UPDATE giac_acct_entries
            SET debit_amt = debit_amt + p_debit_amt,
                credit_amt = credit_amt + p_credit_amt
          WHERE gacc_tran_id = p_gacc_tran_id
            AND gacc_gfun_fund_cd = p_gacc_gfun_fund_cd
            AND gacc_gibr_branch_cd = p_gacc_gibr_branch_cd
            AND gl_acct_id = p_gl_acct_id
            AND gl_acct_category = p_gl_acct_category
            AND gl_control_acct = p_gl_control_acct
            AND gl_sub_acct_1 = p_gl_sub_acct_1
            AND gl_sub_acct_2 = p_gl_sub_acct_2
            AND gl_sub_acct_3 = p_gl_sub_acct_3
            AND gl_sub_acct_4 = p_gl_sub_acct_4
            AND gl_sub_acct_5 = p_gl_sub_acct_5
            AND gl_sub_acct_6 = p_gl_sub_acct_6
            AND gl_sub_acct_7 = p_gl_sub_acct_7
            AND NVL (sl_cd, 0) = NVL (p_sl_cd, NVL (sl_cd, 0));
      END IF;
   END;

   FUNCTION check_if_exist (
      p_gacc_tran_id          giac_acct_entries.gacc_tran_id%TYPE,
      p_gacc_gfun_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_gibr_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gl_acct_id            giac_chart_of_accts.gl_acct_id%TYPE,
      p_gl_acct_category      giac_acct_entries.gl_acct_category%TYPE,
      p_gl_control_acct       giac_acct_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1         giac_acct_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2         giac_acct_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3         giac_acct_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4         giac_acct_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5         giac_acct_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6         giac_acct_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7         giac_acct_entries.gl_sub_acct_7%TYPE,
      p_sl_cd                 giac_acct_entries.sl_cd%TYPE
   )
      RETURN BOOLEAN
   IS
      v_dummy   VARCHAR2 (1);
   BEGIN
      SELECT 'x'
        INTO v_dummy
        FROM giac_acct_entries
       WHERE gacc_tran_id = p_gacc_tran_id
         AND gacc_gfun_fund_cd = p_gacc_gfun_fund_cd
         AND gacc_gibr_branch_cd = p_gacc_gibr_branch_cd
         AND gl_acct_id = p_gl_acct_id
         AND gl_acct_category = p_gl_acct_category
         AND gl_control_acct = p_gl_control_acct
         AND gl_sub_acct_1 = p_gl_sub_acct_1
         AND gl_sub_acct_2 = p_gl_sub_acct_2
         AND gl_sub_acct_3 = p_gl_sub_acct_3
         AND gl_sub_acct_4 = p_gl_sub_acct_4
         AND gl_sub_acct_5 = p_gl_sub_acct_5
         AND gl_sub_acct_6 = p_gl_sub_acct_6
         AND gl_sub_acct_7 = p_gl_sub_acct_7
         AND NVL (sl_cd, 0) = NVL (p_sl_cd, NVL (sl_cd, 0))
         AND ROWNUM = 1;

      RETURN TRUE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN FALSE;
   END;

   PROCEDURE check_debit_credit_amt (
      p_gacc_tran_id   IN       giac_acct_entries.gacc_tran_id%TYPE,
      p_msg            IN OUT   VARCHAR2
   )
   IS
      v_gfun_fund_cd       giac_parameters.param_value_v%TYPE;
      v_gibr_branch_cd     giac_parameters.param_value_v%TYPE;
      v_acct_entry_id      giac_acct_entries.acct_entry_id%TYPE;
      v_tot_debit_amt      NUMBER                                      := 0;
      v_tot_credit_amt     NUMBER                                      := 0;
      v_debit_amt          NUMBER                                      := 0;
      v_credit_amt         NUMBER                                      := 0;
      v_item_no            giac_module_entries.item_no%TYPE;
      v_gl_acct_category   giac_module_entries.gl_acct_category%TYPE;
      v_gl_control_acct    giac_module_entries.gl_control_acct%TYPE;
      v_dr_cr_tag          giac_module_entries.dr_cr_tag%TYPE;
      v_gl_sub_acct_1      giac_module_entries.gl_sub_acct_1%TYPE;
      v_gl_sub_acct_2      giac_module_entries.gl_sub_acct_2%TYPE;
      v_gl_sub_acct_3      giac_module_entries.gl_sub_acct_3%TYPE;
      v_gl_sub_acct_4      giac_module_entries.gl_sub_acct_4%TYPE;
      v_gl_sub_acct_5      giac_module_entries.gl_sub_acct_5%TYPE;
      v_gl_sub_acct_6      giac_module_entries.gl_sub_acct_6%TYPE;
      v_gl_sub_acct_7      giac_module_entries.gl_sub_acct_7%TYPE;
      v_sl_type_cd         giac_module_entries.sl_type_cd%TYPE;
      v_generation_type    giac_modules.generation_type%TYPE;
      v_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE;
      v_sl_cd              giac_acct_entries.sl_cd%TYPE;
   BEGIN
      v_gfun_fund_cd := giacp.v ('FUND_CD');
      v_gibr_branch_cd := giacp.v ('BRANCH_CD');

      SELECT MAX (NVL (acct_entry_id, 0)) + 1
        INTO v_acct_entry_id
        FROM giac_acct_entries
       WHERE gacc_tran_id = p_gacc_tran_id;

      SELECT SUM (NVL (debit_amt, 0)), SUM (NVL (credit_amt, 0))
        INTO v_tot_debit_amt, v_tot_credit_amt
        FROM giac_acct_entries
       WHERE gacc_tran_id = p_gacc_tran_id;

      IF v_tot_debit_amt <> v_tot_credit_amt
      THEN
         IF v_tot_debit_amt > v_tot_credit_amt
         THEN
            v_item_no := 4;
         ELSE
            v_item_no := 5;
         END IF;

         FOR rec IN (SELECT a.gl_acct_category, a.gl_control_acct,
                            a.dr_cr_tag, a.gl_sub_acct_1, a.gl_sub_acct_2,
                            a.gl_sub_acct_3, a.gl_sub_acct_4, a.gl_sub_acct_5,
                            a.gl_sub_acct_6, a.gl_sub_acct_7, a.sl_type_cd,
                            b.generation_type
                       FROM giac_module_entries a, giac_modules b
                      WHERE a.module_id = b.module_id
                        AND a.item_no = v_item_no
                        AND module_name = 'GIACB007')
         LOOP
            v_gl_acct_category := rec.gl_acct_category;
            v_gl_control_acct := rec.gl_control_acct;
            v_dr_cr_tag := rec.dr_cr_tag;
            v_gl_sub_acct_1 := rec.gl_sub_acct_1;
            v_gl_sub_acct_2 := rec.gl_sub_acct_2;
            v_gl_sub_acct_3 := rec.gl_sub_acct_3;
            v_gl_sub_acct_4 := rec.gl_sub_acct_4;
            v_gl_sub_acct_5 := rec.gl_sub_acct_5;
            v_gl_sub_acct_6 := rec.gl_sub_acct_6;
            v_gl_sub_acct_7 := rec.gl_sub_acct_7;
            v_sl_type_cd := rec.sl_type_cd;
            v_generation_type := rec.generation_type;
            v_sl_cd := NULL;

            IF v_dr_cr_tag = 'D'
            THEN
               v_debit_amt := ABS (v_tot_debit_amt - v_tot_credit_amt);
               v_credit_amt := 0;
            ELSE
               v_debit_amt := 0;
               v_credit_amt := ABS (v_tot_debit_amt - v_tot_credit_amt);
            END IF;

            giacb007_pkg.check_chart_of_accts (v_gl_acct_category,
                                               v_gl_control_acct,
                                               v_gl_sub_acct_1,
                                               v_gl_sub_acct_2,
                                               v_gl_sub_acct_3,
                                               v_gl_sub_acct_4,
                                               v_gl_sub_acct_5,
                                               v_gl_sub_acct_6,
                                               v_gl_sub_acct_7,
                                               v_gl_acct_id,
                                               v_dr_cr_tag,
                                               p_msg
                                              );

            IF giacb007_pkg.check_if_exist (p_gacc_tran_id,
                                            v_gfun_fund_cd,
                                            v_gibr_branch_cd,
                                            v_gl_acct_id,
                                            v_gl_acct_category,
                                            v_gl_control_acct,
                                            v_gl_sub_acct_1,
                                            v_gl_sub_acct_2,
                                            v_gl_sub_acct_3,
                                            v_gl_sub_acct_4,
                                            v_gl_sub_acct_5,
                                            v_gl_sub_acct_6,
                                            v_gl_sub_acct_7,
                                            v_sl_cd
                                           )
            THEN
               UPDATE giac_acct_entries
                  SET debit_amt = NVL (debit_amt, 0) + NVL (v_debit_amt, 0),
                      credit_amt = NVL (credit_amt, 0) + NVL (v_credit_amt, 0)
                WHERE gacc_tran_id = p_gacc_tran_id
                  AND gacc_gfun_fund_cd = v_gfun_fund_cd
                  AND gacc_gibr_branch_cd = v_gibr_branch_cd
                  AND gl_acct_id = v_gl_acct_id
                  AND gl_acct_category = v_gl_acct_category
                  AND gl_control_acct = v_gl_control_acct
                  AND gl_sub_acct_1 = v_gl_sub_acct_1
                  AND gl_sub_acct_2 = v_gl_sub_acct_2
                  AND gl_sub_acct_3 = v_gl_sub_acct_3
                  AND gl_sub_acct_4 = v_gl_sub_acct_4
                  AND gl_sub_acct_5 = v_gl_sub_acct_5
                  AND gl_sub_acct_6 = v_gl_sub_acct_6
                  AND gl_sub_acct_7 = v_gl_sub_acct_7
                  AND NVL (sl_cd, 0) = NVL (v_sl_cd, NVL (sl_cd, 0));
            ELSE
               giacb007_pkg.insert_giac_acct_entries (p_gacc_tran_id,
                                                      v_gfun_fund_cd,
                                                      v_gibr_branch_cd,
                                                      v_gl_acct_id,
                                                      v_gl_acct_category,
                                                      v_gl_control_acct,
                                                      v_gl_sub_acct_1,
                                                      v_gl_sub_acct_2,
                                                      v_gl_sub_acct_3,
                                                      v_gl_sub_acct_4,
                                                      v_gl_sub_acct_5,
                                                      v_gl_sub_acct_6,
                                                      v_gl_sub_acct_7,
                                                      v_sl_cd,
                                                      v_debit_amt,
                                                      v_credit_amt,
                                                      v_generation_type,
                                                      v_sl_type_cd
                                                     );
            END IF;
         END LOOP;
      END IF;
   END;
END;
/