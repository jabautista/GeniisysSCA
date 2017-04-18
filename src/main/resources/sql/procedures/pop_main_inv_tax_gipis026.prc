DROP PROCEDURE CPI.POP_MAIN_INV_TAX_GIPIS026;

CREATE OR REPLACE PROCEDURE CPI.pop_main_inv_tax_gipis026 (
   p_par_id   gipi_parlist.par_id%TYPE
)
IS
   v_peril_sw   giis_tax_charges.peril_sw%TYPE;
   v_tax_amt    gipi_orig_inv_tax.tax_amt%TYPE    := 0;
   v_tot_tax    gipi_orig_inv_tax.tax_amt%TYPE    := 0;
   v_prem_amt   gipi_orig_invoice.prem_amt%TYPE   := 0;
   v_exist      VARCHAR2 (1)                      := 'N';
   v_exist1     VARCHAR2 (1)                      := 'N';
BEGIN
   FOR amt IN (SELECT prem_amt, item_grp
                 FROM gipi_orig_invoice
                WHERE par_id = p_par_id)
   LOOP
      FOR tax IN (SELECT item_grp, tax_cd, line_cd, tax_allocation,
                         fixed_tax_allocation, iss_cd, tax_id, rate
                    FROM gipi_winv_tax
                   WHERE par_id = p_par_id AND item_grp = amt.item_grp)
      LOOP
         FOR c IN (SELECT peril_sw
                     FROM giis_tax_charges
                    WHERE iss_cd = tax.iss_cd
                      AND line_cd = tax.line_cd
                      AND tax_cd = tax.tax_cd)
         LOOP
            v_peril_sw := c.peril_sw;
         END LOOP;

         v_tax_amt := tax.rate * amt.prem_amt / 100;
         v_tot_tax := v_tot_tax + v_tax_amt;
		 
         FOR exist IN (SELECT 'a'
                         FROM gipi_orig_inv_tax
                        WHERE par_id = p_par_id
                          AND item_grp = tax.item_grp
                          AND tax_cd = tax.tax_cd)
         LOOP
            v_exist := 'Y';
         END LOOP;

         IF v_exist = 'N'
         THEN
            INSERT INTO gipi_orig_inv_tax
                        (par_id, item_grp, tax_cd, line_cd,
                         tax_allocation, fixed_tax_allocation,
                         iss_cd, tax_amt, tax_id, rate
                        )
                 VALUES (p_par_id, tax.item_grp, tax.tax_cd, tax.line_cd,
                         tax.tax_allocation, tax.fixed_tax_allocation,
                         tax.iss_cd, NVL (v_tax_amt, 0), tax.tax_id, tax.rate
                        );
         ELSE
            v_exist := 'N';

            UPDATE gipi_orig_inv_tax
               SET tax_amt = NVL (v_tax_amt, 0)
             WHERE par_id = p_par_id
               AND item_grp = tax.item_grp
               AND tax_cd = tax.tax_cd;
         --end i--
         END IF;
      END LOOP;

      FOR exist IN (SELECT tax_cd
                      FROM gipi_orig_inv_tax
                     WHERE tax_cd NOT IN (
                              SELECT a.tax_cd
                                FROM gipi_winv_tax a, gipi_orig_inv_tax b
                               WHERE a.par_id = p_par_id
                                 AND a.item_grp = amt.item_grp
                                 AND a.par_id = b.par_id
                                 AND a.item_grp = b.item_grp
                                 AND a.tax_cd = b.tax_cd)
                       AND item_grp = amt.item_grp
                       AND par_id = p_par_id)
      LOOP
         DELETE      gipi_orig_inv_tax
               WHERE par_id = p_par_id
                 AND item_grp = amt.item_grp
                 AND tax_cd = exist.tax_cd;
      END LOOP;

      UPDATE gipi_orig_invoice
         SET tax_amt = v_tot_tax
       WHERE par_id = p_par_id AND item_grp = amt.item_grp;

      v_tot_tax := 0;
   END LOOP;
END;
/


