DROP PROCEDURE CPI.GICLS032_UPDATE_SL_CD;

CREATE OR REPLACE PROCEDURE CPI.gicls032_update_sl_cd (p_claim_id gicl_advice.claim_id%TYPE, p_advice_id gicl_advice.advice_id%TYPE)
IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - update_sl_cd
   */  

   v_gl_acct_id   gicl_acct_entries.gl_acct_id%TYPE;
   v_tax_cd       gicl_loss_exp_tax.tax_cd%TYPE;
   v_tax_type     gicl_loss_exp_tax.tax_type%TYPE;
   v_curr_rec     NUMBER;
   v_exist        VARCHAR2 (1);
   v_entry        VARCHAR2 (1);
   v_sl_cd        gicl_acct_entries.sl_cd%TYPE;
BEGIN
   FOR j IN (SELECT acct_entry_id, gl_acct_id
               FROM gicl_acct_entries
              WHERE advice_id = p_advice_id)
   LOOP
      v_exist := 0;

      FOR c IN (SELECT DISTINCT 'X' entry
                           FROM gicl_acct_entries
                          WHERE claim_id = p_claim_id
                            AND advice_id = p_advice_id
                            AND acct_entry_id = j.acct_entry_id
                            AND gl_acct_id IN (
                                   SELECT gl_acct_id
                                     FROM giac_chart_of_accts a, giac_module_entries b
                                    WHERE b.module_id IN (SELECT module_id
                                                            FROM giac_modules
                                                           WHERE module_name LIKE 'GIACS039')
                                      AND a.gl_acct_category = b.gl_acct_category
                                      AND a.gl_control_acct = b.gl_control_acct
                                      AND a.gl_sub_acct_1 = b.gl_sub_acct_1
                                      AND a.gl_sub_acct_2 = b.gl_sub_acct_2
                                      AND a.gl_sub_acct_3 = b.gl_sub_acct_3
                                      AND a.gl_sub_acct_4 = b.gl_sub_acct_4
                                      AND a.gl_sub_acct_5 = b.gl_sub_acct_5
                                      AND a.gl_sub_acct_6 = b.gl_sub_acct_6
                                      AND a.gl_sub_acct_7 = b.gl_sub_acct_7
                                   UNION
                                   SELECT a.gl_acct_id
                                     FROM giac_chart_of_accts a, giac_wholding_taxes b
                                    WHERE a.gl_acct_id = b.gl_acct_id
                                   UNION
                                   SELECT a.gl_acct_id
                                     FROM giac_taxes a))
      LOOP
         v_entry := c.entry;

         IF v_entry IS NOT NULL
         THEN
            v_exist := 1;
         END IF;

         IF v_exist = 1
         THEN
            FOR l IN (SELECT a.gl_acct_id, item_no tax_cd, 'I' tax_type
                        FROM giac_chart_of_accts a, giac_module_entries b
                       WHERE b.module_id IN (SELECT module_id
                                               FROM giac_modules
                                              WHERE module_name LIKE 'GIACS039')
                         AND a.gl_acct_category = b.gl_acct_category
                         AND a.gl_control_acct = b.gl_control_acct
                         AND a.gl_sub_acct_1 = b.gl_sub_acct_1
                         AND a.gl_sub_acct_2 = b.gl_sub_acct_2
                         AND a.gl_sub_acct_3 = b.gl_sub_acct_3
                         AND a.gl_sub_acct_4 = b.gl_sub_acct_4
                         AND a.gl_sub_acct_5 = b.gl_sub_acct_5
                         AND a.gl_sub_acct_6 = b.gl_sub_acct_6
                         AND a.gl_sub_acct_7 = b.gl_sub_acct_7
                      UNION
                      SELECT a.gl_acct_id, whtax_id tax_cd, 'W' tax_type
                        FROM giac_chart_of_accts a, giac_wholding_taxes b
                       WHERE a.gl_acct_id = b.gl_acct_id
                      UNION
                      SELECT a.gl_acct_id, tax_cd, 'O' tax_type
                        FROM giac_taxes a)
            LOOP
               v_gl_acct_id := l.gl_acct_id;
               v_tax_cd := l.tax_cd;
               v_tax_type := l.tax_type;

               IF j.gl_acct_id = v_gl_acct_id
               THEN
                  FOR s IN (SELECT sl_cd
                              FROM gicl_loss_exp_tax a, gicl_clm_loss_exp b
                             WHERE a.claim_id = b.claim_id
                               AND a.clm_loss_id = b.clm_loss_id
                               AND a.tax_type = v_tax_type
                               AND a.tax_cd = v_tax_cd
                               AND a.claim_id = p_claim_id
                               AND b.advice_id = p_advice_id)
                  LOOP
                     v_sl_cd := s.sl_cd;

                     IF v_sl_cd IS NOT NULL
                     THEN
                        UPDATE gicl_acct_entries
                           SET sl_cd = v_sl_cd
                         WHERE claim_id = p_claim_id
                           AND advice_id = p_advice_id
                           --AND gl_acct_id = :c027.gl_acct_id
                           AND acct_entry_id = j.acct_entry_id;
                     END IF;
                  END LOOP;
               END IF;
            END LOOP;
         END IF;
      END LOOP;      
   END LOOP;
END;
/


