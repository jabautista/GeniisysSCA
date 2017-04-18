DROP PROCEDURE CPI.VALIDATE_BONDS_TAX_ENTRY;

CREATE OR REPLACE PROCEDURE CPI.validate_bonds_tax_entry (
   p_par_id          IN       gipi_wpolbas.par_id%TYPE,
   p_item_grp        IN       gipi_winvoice.item_grp%TYPE,
   p_takeup_seq_no   IN       gipi_winvoice.takeup_seq_no%TYPE,
   p_tax_cd          IN       gipi_winv_tax.tax_cd%TYPE,
   p_tax_id          IN       gipi_winv_tax.tax_id%TYPE,
   p_tax_amt         IN OUT   gipi_winv_tax.tax_amt%TYPE,
   p_orig_tax_amt    IN       gipi_winv_tax.tax_amt%TYPE,
   p_message         OUT      VARCHAR2
)
/** Created by : Jhing Factor
**  Purpose: to validate tax amount during add or update of tax records. Patterned it to VALIDATE_TAX_ENTRY. Created a new procedure 
**           since at least one parameter is being used by non-bonds but is not yet applied to bonds module.
*/
IS
   v_rate               NUMBER;
   v_no_rate_tag        giis_tax_charges.no_rate_tag%TYPE;
   v_primary_sw         giis_tax_charges.primary_sw%TYPE;
   v_vat_tag            giis_assured.vat_tag%TYPE;
   v_param_gtr_tax      giis_parameters.param_value_v%TYPE
                     := NVL (giisp.v ('ALLOW_TAX_GREATER_THAN_PREMIUM'), 'N');
   v_expect_tax_amt     gipi_winv_tax.tax_amt%TYPE;
   v_doc_stamps         giac_parameters.param_value_n%TYPE
                                                    := giacp.n ('DOC_STAMPS');
   v_takeup_alloc_tag   giis_tax_charges.takeup_alloc_tag%TYPE;
   v_tax_type           giis_tax_charges.tax_type%TYPE;
   v_tax_amount         giis_tax_charges.tax_amount%TYPE;
   v_par_type           gipi_parlist.par_type%TYPE;
   p_val_tax_vs_prem    VARCHAR2 (1);
   v_prem_amt           gipi_itmperil.prem_amt%TYPE;
   v_line_cd            gipi_parlist.line_cd%TYPE;
   v_iss_cd             gipi_parlist.iss_cd%TYPE; 
BEGIN
   p_message := 'SUCCESS';

   FOR v1 IN (SELECT NVL (b.vat_tag, 3) vat_tag, c.par_type, c.line_cd, c.iss_cd
                FROM giis_assured b, gipi_parlist c
               WHERE b.assd_no = c.assd_no AND c.par_id = p_par_id)
   LOOP
      v_vat_tag := v1.vat_tag;
      v_par_type := v1.par_type;
      v_line_cd := v1.line_cd;
      v_iss_cd  := v1.iss_cd; 
   END LOOP;

   IF p_tax_cd = giacp.n ('EVAT') AND v_vat_tag = 2
   THEN
      IF p_tax_amt <> 0
      THEN
         p_tax_amt := 0;
         p_message := 'This assured is zero VAT rated.';
      END IF;
   ELSE
      FOR a IN (SELECT rate, no_rate_tag, primary_sw, peril_sw,
                       NVL (tax_type, 'R') tax_type
                  FROM giis_tax_charges
                 WHERE iss_cd = v_iss_cd
                   AND line_cd = v_line_cd
                   AND tax_cd = p_tax_cd
                   AND tax_id = p_tax_id)
      LOOP
         v_no_rate_tag := a.no_rate_tag;
         v_primary_sw := a.primary_sw;
         v_tax_type := a.tax_type;
         EXIT;
      END LOOP;

      -- get the total premium regardless of takeup. For bonds, there is no need to consider item group.
      FOR curinv IN (SELECT SUM (prem_amt) prem_amt
                       FROM gipi_winvoice
                      WHERE par_id = p_par_id)
      LOOP
         v_prem_amt := curinv.prem_amt;
         EXIT;
      END LOOP;

      -- jhing 11.08.2014 added validation on allow tax greater than premium. This parameter will only be applicable on
      -- policy and not on endorsement. Validation will only fire on fixed amount tax type. No checking done on cancellation since
      -- bonds only have coi and endt cancellation and no flat and prorate system cancellation
      p_val_tax_vs_prem := 'N';

      IF v_tax_type = 'A' AND v_par_type = 'P' AND v_param_gtr_tax <> 'Y'
      THEN
         p_val_tax_vs_prem := 'Y';
      ELSIF v_tax_type = 'A' AND v_par_type = 'E'
      THEN
         p_val_tax_vs_prem := 'Y';
      END IF;

      IF ABS (p_tax_amt) > ABS (v_prem_amt) AND p_val_tax_vs_prem = 'Y'
      THEN
         p_message :=
            'Invalid Tax Amount. Tax Amount should not be greater than the Premium.';
      ELSE
         IF v_prem_amt > 0 AND p_tax_amt < 0
         THEN
            p_message := 'Tax Amount should not be less than zero';
         ELSIF v_prem_amt < 0 AND p_tax_amt > 0
         THEN
            p_message := 'Tax Amount should not be greater than zero';
         ELSE
            -- jhing 11.09.2014 added re-computation for expected tax amount
            v_expect_tax_amt := 0;

            IF NVL (v_no_rate_tag, 'N') != 'Y'
            THEN
               SELECT NVL (takeup_alloc_tag, 'F'), NVL (tax_type, 'R'),
                      NVL (tax_amount, 0)
                 INTO v_takeup_alloc_tag, v_tax_type,
                      v_tax_amount
                 FROM giis_tax_charges
                WHERE iss_cd = v_iss_cd
                  AND line_cd = v_line_cd
                  AND tax_cd = p_tax_cd
                  AND tax_id = p_tax_id;

               IF p_tax_cd = v_doc_stamps
               THEN
                     SELECT gipi_winvoice_pkg.get_docstamps_taxamt
                                                           (p_tax_cd,
                                                            p_tax_id,
                                                            p_par_id,
                                                            0,
                                                            p_item_grp,
                                                            p_takeup_seq_no,
                                                            v_takeup_alloc_tag
                                                           )
                       INTO v_expect_tax_amt
                       FROM DUAL;
               ELSE
                  IF v_tax_type = 'A'
                  THEN
                        SELECT gipi_winvoice_pkg.get_fixed_amount_tax
                                                           (p_tax_cd,
                                                            p_tax_id,
                                                            p_par_id,
                                                            v_prem_amt,
                                                            0,
                                                            p_item_grp,
                                                            p_takeup_seq_no,
                                                            v_takeup_alloc_tag
                                                           )
                          INTO v_expect_tax_amt
                          FROM DUAL;
                  ELSIF v_tax_type = 'N'
                  THEN
                        SELECT gipi_winvoice_pkg.get_range_amt
                                                           (p_tax_cd,
                                                            p_tax_id,
                                                            p_par_id,
                                                            0,
                                                            p_item_grp,
                                                            p_takeup_seq_no,
                                                            v_takeup_alloc_tag
                                                           )
                          INTO v_expect_tax_amt
                          FROM DUAL;

                  ELSE
                        SELECT gipi_winvoice_pkg.get_rate_amt (p_tax_cd,
                                                               p_tax_id,
                                                               p_par_id,
                                                               p_item_grp,
                                                               p_takeup_seq_no
                                                              )
                          INTO v_expect_tax_amt
                          FROM DUAL;
                  END IF;
               END IF;
            END IF;

            IF (    NVL (p_tax_amt, 0) <> v_expect_tax_amt
                AND NVL (v_no_rate_tag, 'N') != 'Y'
                AND p_message = 'SUCCESS'
               )
            THEN
               p_message :=
                  (   'Tax Amount must not be less than '
                   || LTRIM (TO_CHAR (v_expect_tax_amt, '9,999,999,990.99'))
                   || ' and must not exceed '
                   || LTRIM (TO_CHAR (v_expect_tax_amt, '9,999,999,990.99'))
                   || '.'
                  );
               p_tax_amt := NVL (v_expect_tax_amt, 0);
            END IF;
         END IF;
      END IF;
   END IF;
END;
/


