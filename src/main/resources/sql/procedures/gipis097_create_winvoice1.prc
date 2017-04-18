DROP PROCEDURE CPI.GIPIS097_CREATE_WINVOICE1;

CREATE OR REPLACE PROCEDURE CPI.gipis097_create_winvoice1 (
   p_par_id    IN   NUMBER,
   p_line_cd   IN   VARCHAR2,
   p_iss_cd    IN   VARCHAR2
)
IS
--
-- Used by item-peril module to create an initial value for invoice module.
-- Taxes selection from maintenace tables are also performed.
--
   CURSOR a1
   IS
      SELECT NVL (eff_date, incept_date), issue_date, place_cd
        FROM gipi_wpolbas
       WHERE par_id = p_par_id;

   comm_amt_per_group   gipi_winvoice.ri_comm_amt%TYPE;
   prem_amt_per_peril   gipi_winvoice.prem_amt%TYPE;
   prem_amt_per_group   gipi_winvoice.prem_amt%TYPE;
   tax_amt_per_peril    gipi_winvoice.tax_amt%TYPE;
   tax_amt_per_group1   gipi_winvoice.tax_amt%TYPE;
   tax_amt_per_group2   gipi_winvoice.tax_amt%TYPE;
   p_tax_amt            REAL;
   prev_item_grp        gipi_winvoice.item_grp%TYPE;
   prev_currency_cd     gipi_winvoice.currency_cd%TYPE;
   prev_currency_rt     gipi_winvoice.currency_rt%TYPE;
   p_assd_name          giis_assured.assd_name%TYPE;
   dummy                VARCHAR2 (1);
   p_issue_date         gipi_wpolbas.issue_date%TYPE;
   p_eff_date           gipi_wpolbas.eff_date%TYPE;
   p_place_cd           gipi_wpolbas.place_cd%TYPE;
   p_pack               gipi_wpolbas.pack_pol_flag%TYPE;
   v_cod                giis_parameters.param_value_v%TYPE;
BEGIN
   OPEN a1;

   FETCH a1
    INTO p_eff_date, p_issue_date, p_place_cd;

   CLOSE a1;

   DELETE FROM gipi_winstallment
         WHERE par_id = p_par_id;

   DELETE FROM gipi_wcomm_inv_perils
         WHERE par_id = p_par_id;

   DELETE FROM gipi_wcomm_invoices
         WHERE par_id = p_par_id;

   DELETE FROM gipi_winvperl
         WHERE par_id = p_par_id;

   DELETE FROM gipi_wpackage_inv_tax
         WHERE par_id = p_par_id;

   DELETE FROM gipi_winv_tax
         WHERE par_id = p_par_id;

   DELETE FROM gipi_winvoice
         WHERE par_id = p_par_id;

   BEGIN
      FOR a1 IN (SELECT SUBSTR (b.assd_name, 1, 30) assd_name
                   FROM gipi_parlist a, giis_assured b
                  WHERE a.assd_no = b.assd_no
                    AND a.par_id = p_par_id
                    AND a.line_cd = p_line_cd)
      LOOP
         p_assd_name := a1.assd_name;
      END LOOP;

      IF p_assd_name IS NULL
      THEN
         p_assd_name := 'Null';
      END IF;
   END;

   FOR a IN (SELECT pack_pol_flag
               FROM gipi_wpolbas
              WHERE par_id = p_par_id)
   LOOP
      p_pack := a.pack_pol_flag;
      EXIT;
   END LOOP;

   BEGIN
      FOR a IN (SELECT param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'CASH ON DELIVERY')
      LOOP
         v_cod := a.param_value_v;
         EXIT;
      END LOOP;

      FOR b IN (SELECT main_currency_cd, currency_rt
                  FROM giac_parameters a, giis_currency b
                 WHERE param_name = 'DEFAULT_CURRENCY')
      LOOP
         prev_currency_cd := b.main_currency_cd;
         prev_currency_rt := b.currency_rt;
         EXIT;
      END LOOP;

      INSERT INTO gipi_winvoice
                  (par_id, item_grp, payt_terms, prem_seq_no, prem_amt,
                   tax_amt, property, insured, due_date, notarial_fee,
                   ri_comm_amt, currency_cd, currency_rt
                  )
           VALUES (p_par_id, 1, v_cod, NULL, 0,
                   0, NULL, p_assd_name, NULL, 0,
                   0, prev_currency_cd, prev_currency_rt
                  );
   END;
END;
/


