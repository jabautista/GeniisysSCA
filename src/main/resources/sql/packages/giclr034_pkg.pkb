CREATE OR REPLACE PACKAGE BODY CPI.giclr034_pkg
AS
   FUNCTION cf_deductible (
      p_claim_id     gicl_claims.claim_id%TYPE,
      p_loss_date    gicl_claims.loss_date%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE
   )
      RETURN NUMBER
   IS
      v_ded_amt   gipi_deductibles.deductible_amt%TYPE;
   BEGIN
      FOR i IN (SELECT item_no, peril_cd
                  FROM gicl_item_peril
                 WHERE claim_id = p_claim_id)
      LOOP
         FOR d IN (SELECT SUM (b.deductible_amt) ded_amt
                     FROM giis_loss_exp a, gipi_deductibles b, gipi_polbasic c
                    WHERE a.line_cd = c.line_cd
                      AND a.line_cd = b.ded_line_cd
                      AND a.subline_cd = b.ded_subline_cd
                      AND a.loss_exp_cd = b.ded_deductible_cd
                      AND a.loss_exp_type = 'L'
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND b.policy_id = c.policy_id
                      AND c.line_cd = p_line_cd
                      AND c.subline_cd = p_subline_cd
                      AND c.iss_cd = p_iss_cd
                      AND c.issue_yy = p_issue_yy
                      AND c.pol_seq_no = p_pol_seq_no
                      AND c.renew_no = p_renew_no
                      AND c.expiry_date >= p_loss_date
                      AND c.dist_flag = '3'
                      AND c.pol_flag IN ('1', '2', '3', 'X')
                      AND b.item_no = i.item_no
                      AND b.peril_cd IN (i.peril_cd, 0)
                      AND NVL (b.deductible_amt, 0) > 0)
         LOOP
            v_ded_amt := d.ded_amt;
         END LOOP;
      END LOOP;

      RETURN (v_ded_amt);
   END;

   FUNCTION cf_deductible2 (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN NUMBER
   IS
      v_deductible   NUMBER (16, 2) := 0;
   BEGIN
      FOR x IN (SELECT   (SUM (ded_base_amt)) * (no_of_units) deductible
                    FROM gicl_loss_exp_dtl
                   WHERE claim_id = p_claim_id AND ded_loss_exp_cd IS NOT NULL
                GROUP BY no_of_units)
      LOOP
         v_deductible := x.deductible;
      END LOOP;

      RETURN (v_deductible);
   END;

   FUNCTION cf_mortgagee (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN VARCHAR2
   IS
      v_mortgagee   giis_mortgagee.mortg_name%TYPE;
   BEGIN
      FOR m IN (SELECT d.mortg_name
                  FROM gipi_mortgagee a, gipi_polbasic b, gicl_claims c, giis_mortgagee d
                 WHERE a.policy_id = b.policy_id
                   AND b.renew_no = c.renew_no
                   AND b.pol_seq_no = c.pol_seq_no
                   AND b.issue_yy = c.issue_yy
                   AND b.iss_cd = c.iss_cd
                   AND b.subline_cd = c.subline_cd
                   AND b.line_cd = c.line_cd
                   AND b.eff_date <= c.loss_date
                   AND a.mortg_cd = d.mortg_cd
                   AND d.iss_cd = c.iss_cd
                   AND c.claim_id = p_claim_id)
      LOOP
         v_mortgagee := m.mortg_name;
         EXIT;
      END LOOP;

      RETURN (v_mortgagee);
   END;

   FUNCTION get_leased_to_label (
      p_loss_date    gicl_claims.loss_date%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_label_tag   gipi_polbasic.label_tag%TYPE;
   BEGIN
      FOR i IN (SELECT   label_tag
                    FROM gipi_polbasic
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND iss_cd = p_iss_cd
                     AND issue_yy = p_issue_yy
                     AND pol_seq_no = p_pol_seq_no
                     AND renew_no = p_renew_no
                     AND pol_flag IN ('1', '2', '3', 'X')
                     AND TRUNC (eff_date) <= TRUNC (p_loss_date)
                     AND TRUNC (NVL (endt_expiry_date, expiry_date)) >= TRUNC (p_loss_date)
                ORDER BY eff_date DESC, endt_seq_no DESC)
      LOOP
         v_label_tag := i.label_tag;
         EXIT;
      END LOOP;

      IF NVL (v_label_tag, 'N') = 'Y'
      THEN
         RETURN ('LEASED TO');
      END IF;

      RETURN ('IN ACCOUNT OF');
   END;

   FUNCTION get_leased_to (p_acct_of_cd giis_assured.assd_name%TYPE)
      RETURN VARCHAR2
   IS
      v_lease_to   giis_assured.assd_name%TYPE;
   BEGIN
      BEGIN
         SELECT UPPER (assd_name)
           INTO v_lease_to
           FROM giis_assured
          WHERE assd_no = p_acct_of_cd;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_lease_to := NULL;
      END;

      RETURN (v_lease_to);
   END;

   FUNCTION get_curr16 (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN CHAR
   IS
      v_curr   giis_currency.short_name%TYPE;
   BEGIN
      FOR x IN (SELECT a.short_name
                  FROM giis_currency a, gicl_clm_item b
                 WHERE b.claim_id = p_claim_id AND a.main_currency_cd = b.currency_cd)
      LOOP
         v_curr := x.short_name;
      END LOOP;

      RETURN (v_curr);
   END;

   FUNCTION cf_tot_pd_amt (
      p_claim_id     gicl_claims.claim_id%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE
   )
      RETURN NUMBER
   IS
      v_tot_pd_amt   gicl_claims.loss_pd_amt%TYPE;
   BEGIN
      BEGIN
         SELECT NVL (SUM (loss_pd_amt), 0) + NVL (SUM (exp_pd_amt), 0)
           INTO v_tot_pd_amt
           FROM gicl_claims
          WHERE renew_no = p_renew_no
            AND pol_seq_no = p_pol_seq_no
            AND issue_yy = p_issue_yy
            AND pol_iss_cd = p_iss_cd
            AND subline_cd = p_subline_cd
            AND line_cd = p_line_cd
            AND claim_id <> p_claim_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_tot_pd_amt := 0;
      END;

      RETURN v_tot_pd_amt;
   END;

   FUNCTION cf_intm (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN VARCHAR2
   IS
      v_intermediary   giis_intermediary.intm_name%TYPE;
   BEGIN
      FOR i IN (SELECT DISTINCT intm_name
                           FROM gicl_basic_intm_v1
                          WHERE claim_id = p_claim_id)
      LOOP
         v_intermediary := i.intm_name;
      END LOOP;

      RETURN (v_intermediary);
   END;

   FUNCTION cf_no_of_claims (
      p_claim_id     gicl_claims.claim_id%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE
   )
      RETURN NUMBER
   IS
      v_clm_count   gicl_claims.claim_id%TYPE;
   BEGIN
      BEGIN
         SELECT COUNT (claim_id)
           INTO v_clm_count
           FROM gicl_claims
          WHERE renew_no = p_renew_no
            AND pol_seq_no = p_pol_seq_no
            AND issue_yy = p_issue_yy
            AND pol_iss_cd = p_iss_cd
            AND subline_cd = p_subline_cd
            AND line_cd = p_line_cd
            AND claim_id <> p_claim_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_clm_count := NULL;
      END;

      RETURN (v_clm_count);
   END;

   FUNCTION cf_tot_res_amt (
      p_claim_id     gicl_claims.claim_id%TYPE,
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE
   )
      RETURN NUMBER
   IS
      v_tot_res_amt   gicl_claims.loss_res_amt%TYPE;
   BEGIN
      BEGIN
         SELECT NVL (SUM (loss_res_amt), 0) + NVL (SUM (exp_res_amt), 0)
           INTO v_tot_res_amt
           FROM gicl_claims
          WHERE renew_no = p_renew_no
            AND pol_seq_no = p_pol_seq_no
            AND issue_yy = p_issue_yy
            AND pol_iss_cd = p_iss_cd
            AND subline_cd = p_subline_cd
            AND line_cd = p_line_cd
            AND clm_stat_cd IN ('CC', 'DN', 'WD')
            AND claim_id <> p_claim_id;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_tot_res_amt := 0;
      END;

      RETURN v_tot_res_amt;
   END;

    FUNCTION cf_issue_date(
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE    
    ) RETURN DATE
    IS
       v_issue_date   gipi_polbasic.issue_date%TYPE;
    BEGIN
       FOR d IN (SELECT issue_date
                   FROM gipi_polbasic
                  WHERE line_cd = p_line_cd
                    AND subline_cd = p_subline_cd
                    AND iss_cd = p_iss_cd
                    AND issue_yy = p_issue_yy
                    AND pol_seq_no = p_pol_seq_no
                    AND renew_no = p_renew_no
                    AND endt_seq_no = 0)
       LOOP
          v_issue_date := d.issue_date;
       END LOOP;

       RETURN (v_issue_date);
    END;

   FUNCTION populate_giclr034 (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN giclr034_tab PIPELINED
   IS
      v_rec          giclr034_type;
      v_in_hou_adj   gicl_claims.in_hou_adj%TYPE;
   BEGIN
      FOR i IN (SELECT a.claim_id, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                          a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (a.clm_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')) "CLAIM_NUMBER",
                          a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.pol_iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (a.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                       || '-'
                       || LTRIM (TO_CHAR (a.renew_no, '09')) "POLICY_NUMBER",
                       LTRIM (TO_CHAR (a.issue_yy, '09')) "UW_YEAR", a.assd_no, a.assured_name, a.dsp_loss_date, a.loss_date,
                       UPPER (a.loss_loc1) || ' ' || UPPER (a.loss_loc2) || ' ' || UPPER (a.loss_loc3) "LOSS_LOCATION",
                       a.clm_file_date, a.pol_eff_date, a.expiry_date, a.in_hou_adj, a.recovery_sw, a.remarks, a.clm_stat_cd,
                       UPPER (a.loss_dtls) loss_dtls, a.city_cd, a.province_cd, a.acct_of_cd, b.line_name, c.user_name,
                       UPPER (d.bill_addr1) || ' ' || UPPER (d.bill_addr2) || ' ' || UPPER (d.bill_addr3) address, d.phone_no,
                       e.clm_stat_desc, a.ri_cd
                  FROM gicl_claims a, giis_line b, giis_users c, giis_assured d, giis_clm_stat e
                 WHERE a.claim_id = p_claim_id
                   AND b.line_cd = a.line_cd
                   AND c.user_id = a.in_hou_adj
                   AND d.assd_no = a.assd_no
                   AND e.clm_stat_cd = a.clm_stat_cd)
      LOOP
         v_rec.claim_id := i.claim_id;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.pol_iss_cd := i.pol_iss_cd;
         v_rec.issue_yy := i.issue_yy;
         v_rec.pol_seq_no := i.pol_seq_no;
         v_rec.renew_no := i.renew_no;
         v_rec.claim_number := i.claim_number;
         v_rec.policy_number := i.policy_number;
         v_rec.uw_year := i.uw_year;
         v_rec.assd_no := i.assd_no;
         v_rec.assured_name := i.assured_name;
         v_rec.address := i.address;
         v_rec.dsp_loss_date := i.dsp_loss_date;
         v_rec.loss_date := i.loss_date;
         v_rec.loss_location := i.loss_location;
         v_rec.clm_file_date := i.clm_file_date;
         v_rec.pol_eff_date := i.pol_eff_date;
         v_rec.expiry_date := i.expiry_date;
         v_rec.in_hou_adj := i.in_hou_adj;
         v_rec.recovery_sw := i.recovery_sw;
         v_rec.remarks := i.remarks; 
         v_rec.clm_stat_cd := i.clm_stat_cd;
         v_rec.loss_dtls := i.loss_dtls;
         v_rec.city_cd := i.city_cd;
         v_rec.province_cd := i.province_cd;
         v_rec.acct_of_cd := i.acct_of_cd;
         v_rec.line_name := i.line_name;
         v_rec.user_name := i.user_name;
         v_rec.contact_no := i.phone_no;
         v_rec.clm_stat_desc := i.clm_stat_desc;
         v_rec.leased_to_label :=
                   get_leased_to_label (i.loss_date, i.line_cd, i.subline_cd, i.pol_iss_cd, i.issue_yy, i.renew_no, i.pol_seq_no);
         v_rec.leased_to := get_leased_to (i.acct_of_cd);
         v_rec.deductible_amt :=
             cf_deductible (p_claim_id, i.loss_date, i.line_cd, i.subline_cd, i.pol_iss_cd, i.issue_yy, i.renew_no, i.pol_seq_no);
         v_rec.currency := get_curr16 (p_claim_id);
         v_rec.mortgagee := cf_mortgagee (p_claim_id);
         v_rec.intermediary := cf_intm (p_claim_id);
         v_rec.deductible2 := cf_deductible2 (p_claim_id);
         v_rec.no_of_claims :=
                        cf_no_of_claims (p_claim_id, i.line_cd, i.subline_cd, i.pol_iss_cd, i.issue_yy, i.renew_no, i.pol_seq_no);
         v_rec.tot_pd_amt :=
                          cf_tot_pd_amt (p_claim_id, i.line_cd, i.subline_cd, i.pol_iss_cd, i.issue_yy, i.renew_no, i.pol_seq_no);
         v_rec.tot_res_amt :=
                         cf_tot_res_amt (p_claim_id, i.line_cd, i.subline_cd, i.pol_iss_cd, i.issue_yy, i.renew_no, i.pol_seq_no);
         v_rec.issue_date := cf_issue_date(i.line_cd, i.subline_cd, i.pol_iss_cd, i.issue_yy, i.renew_no, i.pol_seq_no);
         
         IF v_rec.tot_pd_amt - v_rec.tot_res_amt < 0
         THEN
            v_rec.tot_os := 0;
         ELSE
            v_rec.tot_os := v_rec.tot_pd_amt - v_rec.tot_res_amt;
         END IF;
         
         IF i.pol_iss_cd = giacp.v('RI_ISS_CD') THEN
            BEGIN
               SELECT ri_name
                 INTO v_rec.ri_name
                 FROM giis_reinsurer
                WHERE ri_cd = i.ri_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_rec.ri_name := '';
            END;
        END IF;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_q_policy (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN q_policy_tab PIPELINED
   IS
      v_rec          q_policy_type;
      v_line_cd      gipi_polbasic.line_cd%TYPE;
      v_subline_cd   gipi_polbasic.subline_cd%TYPE;
      v_iss_cd       gipi_polbasic.iss_cd%TYPE;
      v_issue_yy     gipi_polbasic.issue_yy%TYPE;
      v_renew_no     gipi_polbasic.renew_no%TYPE;
      v_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE;
      v_loss_date    gicl_claims.loss_date%TYPE;
   BEGIN
      SELECT line_cd, subline_cd, pol_iss_cd, issue_yy, pol_seq_no, renew_no, loss_date
        INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_loss_date
        FROM gicl_claims
       WHERE claim_id = p_claim_id;

      FOR i IN (SELECT   a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                            a.endt_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.endt_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.endt_seq_no, '099999')) endt_no,
                         a.issue_date, a.eff_date, a.endt_seq_no endt_seq_no
                    FROM gipi_polbasic a, gipi_item b, gicl_clm_item c
                   WHERE a.endt_seq_no <> 0
                     AND a.line_cd = v_line_cd
                     AND a.subline_cd = v_subline_cd
                     AND a.iss_cd = v_iss_cd
                     AND a.issue_yy = v_issue_yy
                     AND a.renew_no = v_renew_no
                     AND a.pol_seq_no = v_pol_seq_no
                     AND a.eff_date <= DECODE (a.endt_type, 'A', v_loss_date, 'N', a.eff_date)
                     AND a.endt_expiry_date >= DECODE (a.endt_type, 'A', v_loss_date, 'N', a.endt_expiry_date)
                     AND a.pol_flag IN ('1', '2', '3', 'X')
                     AND a.policy_id = b.policy_id
                     AND b.item_no = c.item_no
                     AND c.claim_id = p_claim_id
                UNION
                SELECT   a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                            a.endt_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.endt_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.endt_seq_no, '099999')) endt_no,
                         a.issue_date, a.eff_date, a.endt_seq_no endt_seq_no
                    FROM gipi_polbasic a
                   WHERE a.endt_seq_no <> 0
                     AND a.line_cd = v_line_cd
                     AND a.subline_cd = v_subline_cd
                     AND a.iss_cd = v_iss_cd
                     AND a.issue_yy = v_issue_yy
                     AND a.renew_no = v_renew_no
                     AND a.pol_seq_no = v_pol_seq_no
                     AND a.eff_date <= DECODE (a.endt_type, 'A', v_loss_date, 'N', a.eff_date)
                     AND a.endt_expiry_date >= DECODE (a.endt_type, 'A', v_loss_date, 'N', a.endt_expiry_date)
                     AND a.pol_flag IN ('1', '2', '3', 'X')
                     AND NOT EXISTS (SELECT 1
                                       FROM gipi_item b
                                      WHERE a.policy_id = b.policy_id)
                ORDER BY endt_seq_no DESC)
      LOOP
         v_rec.endt_no := i.endt_no;
         v_rec.endt_seq_no := i.endt_seq_no;
         v_rec.issue_date := i.issue_date;
         v_rec.eff_date := i.eff_date;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_q_motor_car (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN q_motor_car_tab PIPELINED
   IS
      v_rec   q_motor_car_type;
   BEGIN
      FOR i IN (SELECT a.claim_id, a.item_no, UPPER (a.item_title) item_title, a.plate_no, a.motor_no, a.serial_no, a.model_year,
                       a.color, a.drvr_name, a.drvr_age, b.car_company, c.make, d.subline_cd, d.subline_type_desc
                  FROM gicl_claims a1, gicl_motor_car_dtl a, giis_mc_car_company b, giis_mc_make c, giis_mc_subline_type d
                 WHERE a1.claim_id = p_claim_id
                   AND a.claim_id = a1.claim_id
                   AND a.motcar_comp_cd = b.car_company_cd(+)
                   AND b.car_company_cd = c.car_company_cd
                   AND a.make_cd = c.make_cd(+)
                   AND d.subline_cd = a1.subline_cd(+)
                   AND a.subline_type_cd = d.subline_type_cd(+))
      LOOP
         v_rec.item_no := i.item_no;
         v_rec.item_title := i.item_title;
         v_rec.plate_no := i.plate_no;
         v_rec.motor_no := i.motor_no;
         v_rec.serial_no := i.serial_no;
         v_rec.model_year := i.model_year;
         v_rec.color := i.color;
         v_rec.drvr_name := i.drvr_name;
         v_rec.drvr_age := i.drvr_age;
         v_rec.car_company := i.car_company;
         v_rec.make := i.make;
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_type_desc := i.subline_type_desc;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_q_adjuster_company (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN q_adjuster_tab PIPELINED
   IS
      v_rec   q_adjuster_type;
   BEGIN
      FOR i IN (SELECT a.adj_company_cd, a.claim_id,
                          payee_last_name
                       || DECODE (payee_first_name, NULL, NULL, ', ' || payee_first_name)
                       || DECODE (payee_middle_name, NULL, NULL, ' ' || payee_middle_name) adjuster
                  FROM giis_payees b, gicl_clm_adjuster a
                 WHERE a.claim_id = p_claim_id
                   AND payee_class_cd = giacp.v ('ADJP_CLASS_CD')
                   AND NVL (cancel_tag, 'N') <> 'Y'
                   AND NVL (delete_tag, 'N') <> 'Y'
                   AND payee_no = a.adj_company_cd)
      LOOP
         v_rec.adj_company_cd := i.adj_company_cd;
         v_rec.adjuster := i.adjuster;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_q_motorshop (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN q_motorshop_tab PIPELINED
   IS
      v_rec   q_motorshop_type;
   BEGIN
      FOR i IN (SELECT DECODE (payee_first_name,
                               NULL, payee_last_name,
                               payee_last_name || ', ' || payee_first_name || ' ' || payee_middle_name
                              ) payee
                  FROM gicl_clm_claimant a, giis_payees b
                 WHERE claim_id = p_claim_id
                   AND a.payee_class_cd = b.payee_class_cd
                   AND a.clmnt_no = b.payee_no
                   AND a.payee_class_cd = (SELECT param_value_v
                                             FROM giac_parameters
                                            WHERE param_name = 'MC_PAYEE_CLASS')
                UNION
                SELECT DECODE (payee_first_name,
                               NULL, payee_last_name,
                               payee_last_name || ', ' || payee_first_name || ' ' || payee_middle_name
                              ) payee
                  FROM gicl_clm_claimant a, giis_payees b
                 WHERE claim_id = p_claim_id
                   AND b.payee_class_cd = (SELECT param_value_v
                                             FROM giac_parameters
                                            WHERE param_name = 'MC_PAYEE_CLASS')
                   AND a.mc_payee_cd = b.payee_no
                   AND mc_payee_cd IS NOT NULL)
      LOOP
         v_rec.motorshop := i.payee;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_q_claim_item (p_claim_id gicl_claims.claim_id%TYPE, p_line_cd gicl_claims.line_cd%TYPE)
      RETURN q_item_tab PIPELINED
   IS
      v_rec   q_item_type;
   BEGIN
      FOR i IN (SELECT claim_id, item_no, grouped_item_no,
                          'ITEM '
                       || item_no
                       || ' - '
                       || UPPER (get_gpa_item_title (p_claim_id, p_line_cd, item_no, grouped_item_no)) item
                  FROM gicl_clm_item
                 WHERE claim_id = p_claim_id)
      LOOP
         v_rec.item_no := i.item_no;
         v_rec.grouped_item_no := i.grouped_item_no;
         v_rec.item := i.item;
         v_rec.currency := get_curr16 (p_claim_id);
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_q_claim_item_peril (p_claim_id gicl_claims.claim_id%TYPE, p_item_no gicl_clm_item.item_no%TYPE)
      RETURN q_item_peril_tab PIPELINED
   IS
      v_rec          q_item_peril_type;
      v_line_cd      gipi_polbasic.line_cd%TYPE;
      v_subline_cd   gipi_polbasic.subline_cd%TYPE;
      v_iss_cd       gipi_polbasic.iss_cd%TYPE;
      v_issue_yy     gipi_polbasic.issue_yy%TYPE;
      v_renew_no     gipi_polbasic.renew_no%TYPE;
      v_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE;
   BEGIN
      SELECT line_cd, subline_cd, pol_iss_cd, issue_yy, pol_seq_no, renew_no
        INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no
        FROM gicl_claims
       WHERE claim_id = p_claim_id;

      FOR i IN (SELECT   b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no, a.item_no, a.peril_cd,
                         c.peril_name, SUM (a.tsi_amt) "TSI"
                    FROM gipi_itmperil a, gipi_polbasic b, giis_peril c, gipi_item d
                   WHERE a.policy_id = b.policy_id
                     AND b.line_cd = v_line_cd
                     AND b.subline_cd = v_subline_cd
                     AND b.iss_cd = v_iss_cd
                     AND b.issue_yy = v_issue_yy
                     AND b.renew_no = v_renew_no
                     AND b.pol_seq_no = v_pol_seq_no
                     AND a.item_no = p_item_no
                     AND b.line_cd = c.line_cd
                     AND b.pol_flag <> '5'
                     AND a.peril_cd = c.peril_cd
                     AND c.peril_type = 'B'
                     AND a.item_no IN (SELECT item_no
                                         FROM gicl_item_peril
                                        WHERE claim_id = p_claim_id)
                     AND d.item_no = a.item_no
                     AND d.policy_id = a.policy_id
                GROUP BY b.line_cd,
                         b.subline_cd,
                         b.iss_cd,
                         b.issue_yy,
                         b.pol_seq_no,
                         b.renew_no,
                         a.item_no,
                         a.peril_cd,
                         c.peril_name)
      LOOP
         v_rec.peril_cd := i.peril_cd;
         v_rec.peril_name := i.peril_name;
         v_rec.tsi := i.tsi;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION cf_grouped_item (p_claim_id gicl_claims.claim_id%TYPE, p_line_cd gicl_claims.line_cd%TYPE)
      RETURN VARCHAR2
   IS
      v_gitem_no          NUMBER (9);
      v_gitem_title       VARCHAR2 (50);
      v_gitem             VARCHAR2 (500);
      v_menu_line_cd_pa   giis_line.menu_line_cd%TYPE;
      v_menu_line_cd_ca   giis_line.menu_line_cd%TYPE;
   BEGIN
      BEGIN
         --select menu_line_cd of PERSONAL ACCIDENT
         SELECT menu_line_cd
           INTO v_menu_line_cd_pa
           FROM giis_line
          WHERE line_cd = giisp.v ('LINE_CODE_AH');

         --select menu_line_cd of CASUALTY
         SELECT menu_line_cd
           INTO v_menu_line_cd_ca
           FROM giis_line
          WHERE line_cd = giisp.v ('LINE_CODE_CA');

         IF (p_line_cd = giisp.v ('LINE_CODE_CA')) OR (p_line_cd = v_menu_line_cd_ca)
         THEN
            SELECT grouped_item_no, UPPER (grouped_item_title)
              INTO v_gitem_no, v_gitem_title
              FROM gicl_casualty_dtl
             WHERE claim_id = p_claim_id;
         ELSIF (p_line_cd = giisp.v ('LINE_CODE_AH')) OR (p_line_cd = v_menu_line_cd_pa)
         THEN
            SELECT grouped_item_no, UPPER (grouped_item_title)
              INTO v_gitem_no, v_gitem_title
              FROM gicl_accident_dtl
             WHERE claim_id = p_claim_id;
         END IF;

         IF v_gitem_no IS NOT NULL AND v_gitem_title IS NOT NULL
         THEN
            v_gitem := 'GROUPED ITEM ' || v_gitem_no || ' - ' || v_gitem_title;
         ELSE
            v_gitem := NULL;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_gitem := NULL;
      END;

      RETURN (v_gitem);
   END;

   FUNCTION get_q_reserve_item (p_claim_id gicl_claims.claim_id%TYPE, p_line_cd gicl_claims.line_cd%TYPE)
      RETURN q_item_tab PIPELINED
   IS
      v_rec   q_item_type;
   BEGIN
      --removed loss_cat_cd to prevent displaying of Item Information more than once by MAC 11/08/2013.
      FOR i IN (SELECT DISTINCT claim_id, a.line_cd, /*loss_cat_cd,*/ item_no, grouped_item_no, 
                                   'ITEM '
                                || item_no
                                || ' - '
                                || UPPER (get_gpa_item_title (claim_id, NVL (menu_line_cd, a.line_cd), item_no, grouped_item_no))
                                                                                                                            item
                           FROM gicl_item_peril a, giis_line b
                          WHERE claim_id = p_claim_id AND a.line_cd = p_line_cd AND a.line_cd = b.line_cd)
      LOOP
         v_rec.item_no := i.item_no;
         v_rec.grouped_item_no := i.grouped_item_no;
         v_rec.item := i.item;
         v_rec.currency := get_curr16 (p_claim_id);
         v_rec.grouped_item := cf_grouped_item (p_claim_id, p_line_cd);
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_q_reserve (p_claim_id gicl_claims.claim_id%TYPE, p_item_no gicl_clm_item.item_no%TYPE)
      RETURN q_reserve_tab PIPELINED
   IS
      v_rec   q_reserve_type;
   BEGIN
      FOR i IN (SELECT a.peril_cd, c.peril_name, d.loss_cat_des, NVL (e.loss_reserve, 0) loss_reserve,
                       f.short_name loss_short_name, NVL (g.expense_reserve, 0) expense_reserve, h.short_name exp_short_name
                  FROM gicl_item_peril a,
                       gicl_clm_item b,
                       giis_peril c,
                       giis_loss_ctgry d,
                       gicl_clm_reserve e,
                       giis_currency f,
                       gicl_clm_reserve g,
                       giis_currency h
                 WHERE a.claim_id = p_claim_id
                   AND a.item_no = p_item_no
                   AND a.claim_id = b.claim_id
                   AND a.item_no = b.item_no
                   AND a.grouped_item_no = b.grouped_item_no
                   AND c.peril_cd = a.peril_cd
                   AND c.line_cd = a.line_cd
                   AND d.loss_cat_cd = a.loss_cat_cd
                   AND d.line_cd = a.line_cd
                   AND e.claim_id(+) = a.claim_id
                   AND e.item_no(+) = a.item_no
                   AND e.grouped_item_no(+) = a.grouped_item_no
                   AND e.peril_cd(+) = a.peril_cd
                   AND f.main_currency_cd(+) = e.currency_cd
                   AND g.claim_id(+) = a.claim_id
                   AND g.item_no(+) = a.item_no
                   AND g.grouped_item_no(+) = a.grouped_item_no
                   AND g.peril_cd(+) = a.peril_cd
                   AND h.main_currency_cd(+) = g.currency_cd)
      LOOP
         v_rec.peril_cd := i.peril_cd;
         v_rec.peril_name := i.peril_name;
         v_rec.loss_cat_des := i.loss_cat_des;
         v_rec.loss_reserve := i.loss_reserve;
         v_rec.loss_short_name := i.loss_short_name;
         v_rec.expense_reserve := i.expense_reserve;
         v_rec.exp_short_name := i.exp_short_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_reserve_history (p_claim_id gicl_claims.claim_id%TYPE, p_line_cd gicl_claims.line_cd%TYPE)
      RETURN reserve_hist_tab PIPELINED
   IS
      v_rec   reserve_hist_type;
   BEGIN
      FOR i IN (SELECT   a.claim_id, a.item_no, a.peril_cd, b.peril_name, a.user_id,
                         TO_CHAR (a.setup_date, 'MM-DD-RR HH:MI:SS AM') setup_date, NVL (a.loss_reserve, 0) loss_reserve,
                         NVL (a.expense_reserve, 0) expense_reserve,
                         SUM (NVL (a.loss_reserve, 0) + NVL (a.expense_reserve, 0)) "reserve", a.remarks, a.grouped_item_no,
                         a.currency_cd, c.short_name, a.setup_by
                    FROM gicl_clm_res_hist a, giis_peril b, giis_currency c
                   WHERE a.claim_id = p_claim_id
                     AND a.tran_id IS NULL
                     AND b.peril_cd = a.peril_cd
                     AND b.line_cd = p_line_cd
                     AND c.main_currency_cd = a.currency_cd
                GROUP BY a.claim_id,
                         a.item_no,
                         a.peril_cd,
                         b.peril_name,
                         a.user_id,
                         a.setup_date,
                         a.loss_reserve,
                         a.expense_reserve,
                         a.remarks,
                         a.grouped_item_no,
                         a.currency_cd,
                         c.short_name,
                         a.hist_seq_no,
                         a.setup_by
                ORDER BY a.item_no, b.peril_name, a.hist_seq_no DESC, a.setup_date DESC) --order Reserve History by Item Peril by MAC 11/08/2013.
      LOOP
         v_rec.item_no := i.item_no;
         v_rec.peril_cd := i.peril_cd;
         v_rec.peril_name := i.peril_name;
         v_rec.user_id := i.user_id;
         v_rec.setup_date := i.setup_date;
         v_rec.setup_by := i.setup_by;
         v_rec.loss_reserve := i.loss_reserve;
         v_rec.expense_reserve := i.expense_reserve;
         v_rec.loss_short_name := i.short_name;
         v_rec.exp_short_name := i.short_name;
         v_rec.remarks := i.remarks;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION cf_ref_no (
      p_gacc_tran_id    giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_tran_class      giac_acctrans.tran_class%TYPE,
      p_tran_class_no   giac_acctrans.tran_class_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_ref_no   VARCHAR2 (30);
   BEGIN
      IF p_tran_class = 'COL'
      THEN
         FOR c IN (SELECT or_pref_suf || '-' || TO_CHAR (or_no) or_no
                     FROM giac_order_of_payts
                    WHERE gacc_tran_id = p_gacc_tran_id)
         LOOP
            v_ref_no := c.or_no;
         END LOOP;
      ELSIF p_tran_class = 'DV'
      THEN
         FOR r IN (SELECT    document_cd
                          || '-'
                          || branch_cd
                          || '-'
                          || TO_CHAR (doc_year)
                          || '-'
                          || TO_CHAR (doc_mm)
                          || '-'
                          || TO_CHAR (doc_seq_no) request_no
                     FROM giac_payt_requests a, giac_payt_requests_dtl b
                    WHERE a.ref_id = b.gprq_ref_id AND b.tran_id = p_gacc_tran_id)
         LOOP
            v_ref_no := r.request_no;

            FOR d IN (SELECT dv_pref || '-' || TO_CHAR (dv_no) dv_no
                        FROM giac_disb_vouchers
                       WHERE gacc_tran_id = p_gacc_tran_id)
            LOOP
               v_ref_no := d.dv_no;
            END LOOP;
         END LOOP;
      ELSIF p_tran_class = 'JV'
      THEN
         v_ref_no := p_tran_class||'-'||p_tran_class_no; --p_tran_class Added by Jerome Bautista 08.20.2015 SR 18120
      END IF;

      RETURN (v_ref_no);
   END;

   FUNCTION get_premium_payments (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN premium_payment_tab PIPELINED
   IS
      v_rec          premium_payment_type;
      v_line_cd      gipi_polbasic.line_cd%TYPE;
      v_subline_cd   gipi_polbasic.subline_cd%TYPE;
      v_iss_cd       gipi_polbasic.iss_cd%TYPE;
      v_issue_yy     gipi_polbasic.issue_yy%TYPE;
      v_renew_no     gipi_polbasic.renew_no%TYPE;
      v_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE;
      v_loss_date    gicl_claims.loss_date%TYPE;
   BEGIN
      SELECT line_cd, subline_cd, pol_iss_cd, issue_yy, pol_seq_no, renew_no, loss_date
        INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_loss_date
        FROM gicl_claims
       WHERE claim_id = p_claim_id;

      FOR i IN (SELECT a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, c.gacc_tran_id,
                       DECODE (c.currency_cd, 1, c.premium_amt, c.premium_amt / c.convert_rate) premium_amt, d.tran_class, -- Modified by Jerome Bautista 08.20.2015 SR 18120
                       d.tran_class_no, d.tran_date, e.short_name
                  FROM gipi_polbasic a,
                       gipi_invoice b,
                       giac_direct_prem_collns c,
                       giac_acctrans d,
                       giis_currency e
                       --giac_order_of_payts f --Commented out by Jerome Bautista 08.20.2015 SR 18120
                 WHERE a.policy_id = b.policy_id
                   AND a.line_cd = v_line_cd
                   AND a.subline_cd = v_subline_cd
                   AND a.iss_cd = v_iss_cd
                   AND a.issue_yy = v_issue_yy
                   AND a.renew_no = v_renew_no
                   AND a.pol_seq_no = v_pol_seq_no
                   AND b.iss_cd = c.b140_iss_cd
                   AND b.prem_seq_no = c.b140_prem_seq_no
                   AND c.gacc_tran_id = d.tran_id
                   AND d.tran_flag <> 'D'
                   AND a.eff_date <= v_loss_date
                   AND a.pol_flag NOT IN ('4', '5')
                   --AND f.currency_cd = e.main_currency_cd --Commented out by Jerome Bautista 08.20.2015 SR 18120
                   AND c.currency_cd = e.main_currency_cd -- Added by Jerome Bautista 08.20.2015 SR 18120
                   AND d.tran_id NOT IN (SELECT e.gacc_tran_id
                                           FROM giac_reversals e, giac_acctrans f
                                          WHERE e.reversing_tran_id = f.tran_id AND f.tran_flag <> 'D')
                   --AND c.gacc_tran_id = f.gacc_tran_id --Commented out by Jerome Bautista 08.20.2015 SR 18120
                UNION
                SELECT a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, c.gacc_tran_id,
                       DECODE (c.currency_cd, 1, c.premium_amt, c.premium_amt / c.convert_rate) premium_amt, d.tran_class, --Modified by Jerome Bautista 08.20.2015 SR 18120
                       d.tran_class_no, d.tran_date, e.short_name
                  FROM gipi_polbasic a,
                       gipi_invoice b,
                       giac_inwfacul_prem_collns c,
                       giac_acctrans d,
                       giis_currency e
                       --giac_order_of_payts f --Commented out by Jerome Bautista 08.20.2015 SR 18120
                 WHERE a.policy_id = b.policy_id
                   AND a.line_cd = v_line_cd
                   AND a.subline_cd = v_subline_cd
                   AND a.iss_cd = v_iss_cd
                   AND a.issue_yy = v_issue_yy
                   AND a.renew_no = v_renew_no
                   AND a.pol_seq_no = v_pol_seq_no
                   AND b.iss_cd = c.b140_iss_cd
                   AND b.prem_seq_no = c.b140_prem_seq_no
                   AND c.gacc_tran_id = d.tran_id
                   AND d.tran_flag <> 'D'
                   AND a.eff_date <= v_loss_date
                   AND a.pol_flag NOT IN ('4', '5')
                   --AND f.currency_cd = e.main_currency_cd --Commented out by Jerome Bautista 08.20.2015 SR 18120
                   AND c.currency_cd = e.main_currency_cd -- Added by Jerome Bautista 08.20.2015 SR 18120
                   AND d.tran_id NOT IN (SELECT e.gacc_tran_id
                                           FROM giac_reversals e, giac_acctrans f
                                          WHERE e.reversing_tran_id = f.tran_id AND f.tran_flag <> 'D'))
                   --AND c.gacc_tran_id = f.gacc_tran_id) --Commented out by Jerome Bautista 08.20.2015 SR 18120
      LOOP
         v_rec.premium_amt := i.premium_amt;
         v_rec.tran_date := i.tran_date;
         v_rec.short_name := i.short_name;
         v_rec.ref_no := cf_ref_no (i.gacc_tran_id, i.tran_class, i.tran_class_no);
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_dist_share (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN dist_share_tab PIPELINED
   IS
      v_rec   dist_share_type;
   BEGIN
      FOR i IN (SELECT DISTINCT share_type,
                                DECODE (share_type, '1', 'RETENTION', '2', 'TREATY', '3', 'FACULTATIVE', '4', 'XOL') share_name
                           FROM giis_dist_share)
      LOOP
         v_rec.share_type := i.share_type;
         v_rec.share_name := i.share_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_uw_dist (p_claim_id gicl_claims.claim_id%TYPE, p_share_type giis_dist_share.share_type%TYPE)
      RETURN uw_dist_tab PIPELINED
   IS
      v_rec   uw_dist_type;
   BEGIN
      FOR i IN (SELECT   a.claim_id, a.item_no, a.peril_cd, c.share_type, c.line_cd, b.currency_cd,
                         SUM (shr_tsi_amt) "SHR_TSI_AMT", d.short_name
                    FROM gicl_item_peril a, gicl_clm_res_hist b, gicl_policy_dist c, giis_currency d
                   WHERE a.claim_id = p_claim_id
                     AND c.share_type = p_share_type
                     AND a.claim_id = b.claim_id
                     AND a.item_no = b.item_no
                     AND a.peril_cd = b.peril_cd
                     AND b.claim_id = c.claim_id
                     AND b.item_no = c.item_no
                     AND b.peril_cd = c.peril_cd
                     AND b.dist_sw = 'Y'
                     AND b.currency_cd = d.main_currency_cd(+)
                GROUP BY a.claim_id, a.item_no, a.peril_cd, c.share_type, c.line_cd, b.currency_cd, d.short_name)
      LOOP
         v_rec.short_name := i.short_name;
         v_rec.shr_tsi_amt := i.shr_tsi_amt;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_uw_ri (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN uw_ri_tab PIPELINED
   IS
      v_rec          uw_ri_type;
      v_line_cd      gipi_polbasic.line_cd%TYPE;
      v_subline_cd   gipi_polbasic.subline_cd%TYPE;
      v_iss_cd       gipi_polbasic.iss_cd%TYPE;
      v_issue_yy     gipi_polbasic.issue_yy%TYPE;
      v_renew_no     gipi_polbasic.renew_no%TYPE;
      v_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE;
      v_loss_date    gicl_claims.loss_date%TYPE;
   BEGIN
      SELECT line_cd, subline_cd, pol_iss_cd, issue_yy, pol_seq_no, renew_no, loss_date
        INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_loss_date
        FROM gicl_claims
       WHERE claim_id = p_claim_id;

      FOR i IN (SELECT   a.ri_cd, g.ri_name, a.ri_shr_pct, a.ri_tsi_amt,
                            a.line_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.binder_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.binder_seq_no, '099999')) "BINDER_NO",
                         e.line_cd, e.subline_cd, e.iss_cd, e.issue_yy, e.pol_seq_no, e.renew_no, f.short_name
                    FROM giri_binder a,
                         giri_frps_ri b,
                         giri_distfrps c,
                         giuw_pol_dist d,
                         gipi_polbasic e,
                         giis_currency f,
                         giis_reinsurer g
                   WHERE d.policy_id = e.policy_id
                     AND e.line_cd = v_line_cd
                     AND e.subline_cd = v_subline_cd
                     AND e.iss_cd = v_iss_cd
                     AND e.issue_yy = v_issue_yy
                     AND e.renew_no = v_renew_no
                     AND e.pol_seq_no = v_pol_seq_no
                     AND b.line_cd = c.line_cd
                     AND b.frps_yy = c.frps_yy
                     AND b.frps_seq_no = c.frps_seq_no
                     AND c.dist_no = d.dist_no
                     AND c.currency_cd = f.main_currency_cd
                     AND NVL (b.reverse_sw, 'N') = 'N'
                     AND a.fnl_binder_id = b.fnl_binder_id(+)
                     AND a.ri_cd = g.ri_cd
                ORDER BY a.ri_cd)
      LOOP
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         v_rec.binder_no := i.binder_no;
         v_rec.ri_shr_pct := i.ri_shr_pct;
         v_rec.ri_tsi_amt := i.ri_tsi_amt;
         v_rec.short_name := i.short_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_reserve_dist (p_claim_id gicl_claims.claim_id%TYPE, p_share_type giis_dist_share.share_type%TYPE)
      RETURN reserve_dist_tab PIPELINED
   IS
      v_rec   reserve_dist_type;
   BEGIN
      FOR i IN (SELECT   a.claim_id, a.item_no, a.peril_cd, c.clm_res_hist_id, c.share_type, c.line_cd, b.currency_cd,
                         SUM (NVL (shr_loss_res_amt, 0) + NVL (shr_exp_res_amt, 0)) "SHR_RES_AMT", d.short_name
                    FROM gicl_item_peril a, gicl_clm_res_hist b, gicl_reserve_ds c, giis_currency d
                   WHERE a.claim_id = p_claim_id
                     AND c.share_type = p_share_type
                     AND a.claim_id = b.claim_id
                     AND a.item_no = b.item_no
                     AND a.peril_cd = b.peril_cd
                     AND b.claim_id = c.claim_id
                     AND b.item_no = c.item_no
                     AND b.peril_cd = c.peril_cd
                     AND b.dist_sw = 'Y'
                     AND NVL (c.negate_tag, 'N') = 'N'
                     AND b.currency_cd = d.main_currency_cd(+)
                GROUP BY a.claim_id,
                         a.item_no,
                         a.peril_cd,
                         c.clm_res_hist_id,
                         c.share_type,
                         c.line_cd,
                         b.currency_cd,
                         d.short_name)
      LOOP
         v_rec.short_name := i.short_name;
         v_rec.shr_res_amt := i.shr_res_amt;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_reserve_ri (p_claim_id gicl_claims.claim_id%TYPE, p_total_loss NUMBER, p_total_exp NUMBER)
      RETURN reserve_ri_tab PIPELINED
   IS
      v_rec   reserve_ri_type;
   BEGIN
      FOR i IN (SELECT   d.claim_id, e.short_name,
                            d.line_cd
                         || '-'
                         || LTRIM (TO_CHAR (d.la_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (d.pla_seq_no, '0999999')) "PLA_NO",
                         d.ri_cd, f.ri_name,
                         (SUM (NVL (c.shr_loss_ri_res_amt, 0)) + SUM (NVL (c.shr_exp_ri_res_amt, 0))) "PLA_AMT"
                    FROM gicl_clm_res_hist a,
                         gicl_reserve_ds b,
                         gicl_reserve_rids c,
                         gicl_advs_pla d,
                         giis_currency e,
                         giis_reinsurer f
                   WHERE a.dist_sw = 'Y'
                     AND d.claim_id = p_claim_id
                     AND a.claim_id = b.claim_id
                     AND a.clm_res_hist_id = b.clm_res_hist_id
                     AND NVL (b.negate_tag, 'N') <> 'Y'
                     AND b.claim_id = c.claim_id
                     AND b.clm_res_hist_id = c.clm_res_hist_id
                     AND b.grp_seq_no = c.grp_seq_no
                     AND c.pla_id = d.pla_id
                     AND c.grp_seq_no = d.grp_seq_no
                     AND c.claim_id = d.claim_id
                     AND d.ri_cd = f.ri_cd
                     AND a.currency_cd = e.main_currency_cd
                GROUP BY d.claim_id, d.line_cd, d.la_yy, d.pla_seq_no, d.ri_cd, f.ri_name, e.short_name
                ORDER BY d.line_cd, d.la_yy, d.pla_seq_no)
      LOOP
         v_rec.ri_cd := i.ri_cd;
         v_rec.ri_name := i.ri_name;
         v_rec.pla_no := i.pla_no;
         v_rec.pla_amt := i.pla_amt;
         v_rec.short_name := i.short_name;
         v_rec.ri_shr_pct := (i.pla_amt / (p_total_loss + p_total_exp)) * 100;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_documents (
      p_claim_id     gicl_claims.claim_id%TYPE,
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE
   )
      RETURN document_tab PIPELINED
   IS
      v_rec   document_type;
   BEGIN
      FOR i IN (SELECT line_cd, subline_cd, clm_doc_cd, clm_doc_desc, NULL doc_cmpltd_dt
                  FROM gicl_clm_docs
                 WHERE priority_cd IS NOT NULL AND line_cd = p_line_cd AND subline_cd = p_subline_cd
                UNION
                SELECT a.line_cd, a.subline_cd, b.clm_doc_cd, b.clm_doc_desc, a.doc_cmpltd_dt
                  FROM gicl_reqd_docs a, gicl_clm_docs b
                 WHERE a.doc_cmpltd_dt IS NOT NULL
                   AND a.line_cd = b.line_cd
                   AND a.subline_cd = b.subline_cd
                   AND TO_CHAR(a.clm_doc_cd) = b.clm_doc_cd
                   AND a.claim_id = p_claim_id)
      LOOP
         v_rec.clm_doc_cd := i.clm_doc_cd;
         v_rec.clm_doc_desc := i.clm_doc_desc;
         v_rec.doc_cmpltd_dt := i.doc_cmpltd_dt;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE cf_released2 (
      p_claim_id        IN       gicl_claims.claim_id%TYPE,
      p_tran_id         IN       giac_payt_requests_dtl.tran_id%TYPE,
      p_date_released   OUT      giac_payt_requests.request_date%TYPE,
      p_rel             OUT      VARCHAR2
   )
   IS
      v_rel      VARCHAR2 (1);
      v_csr_no   VARCHAR2 (26);
   BEGIN
      FOR x IN (SELECT DISTINCT    a.document_cd
                                || '-'
                                || a.branch_cd
                                || '-'
                                || a.line_cd
                                || '-'
                                || TO_CHAR (a.doc_year)
                                || '-'
                                || TO_CHAR (a.doc_mm, '09')
                                || '-'
                                || TO_CHAR (a.doc_seq_no, '099999') csr_no,
                                a.request_date
                           FROM giac_payt_requests a, giac_payt_requests_dtl b, giac_direct_claim_payts c
                          WHERE a.ref_id = b.gprq_ref_id
                            AND b.tran_id = c.gacc_tran_id
                            AND b.tran_id = p_tran_id                                                                   -- try lng
                            AND b.payt_req_flag <> 'X'
                            AND c.advice_id IN (SELECT advice_id
                                                  FROM gicl_advice
                                                 WHERE claim_id = p_claim_id)
                            AND c.claim_id = p_claim_id
                UNION
                SELECT DISTINCT    a.document_cd
                                || '-'
                                || a.branch_cd
                                || '-'
                                || a.line_cd
                                || '-'
                                || TO_CHAR (a.doc_year)
                                || '-'
                                || TO_CHAR (a.doc_mm, '09')
                                || '-'
                                || TO_CHAR (a.doc_seq_no, '099999') csr_no,
                                a.request_date
                           FROM giac_payt_requests a, giac_payt_requests_dtl b, giac_inw_claim_payts c
                          WHERE a.ref_id = b.gprq_ref_id
                            AND b.tran_id = c.gacc_tran_id
                            AND b.tran_id = p_tran_id                                                                   -- try lng
                            AND b.payt_req_flag <> 'X'
                            AND c.advice_id IN (SELECT advice_id
                                                  FROM gicl_advice
                                                 WHERE claim_id = p_claim_id)
                            AND c.claim_id = p_claim_id)
      LOOP
         v_csr_no := x.csr_no;

         IF v_csr_no IS NULL
         THEN
            p_rel := 'N';
         ELSE
            p_rel := 'Y';
         END IF;

         p_date_released := x.request_date;
      END LOOP;
   END;

   FUNCTION cf_tot_payt_released_net (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_advice_id     gicl_advice.advice_id%TYPE,
      p_clm_loss_id   gicl_loss_exp_ds.clm_loss_id%TYPE
   )
      RETURN NUMBER
   IS
      v_tot_payt_released_net   NUMBER (16, 2);
   BEGIN
      FOR x IN (SELECT SUM (  NVL (a.shr_le_pd_amt, 0)
                            * DECODE (b.currency_cd,
                                      giacp.n ('CURRENCY_CD'), 1,
                                      c.currency_cd, 1,
                                      (NVL (c.orig_curr_rate, c.convert_rate))
                                     )
                           ) tot_payt_released_net
                  FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b, gicl_advice c
                 WHERE a.claim_id = b.claim_id
                   AND b.claim_id = c.claim_id
                   AND a.clm_loss_id = b.clm_loss_id
                   AND b.advice_id = c.advice_id
                   AND b.advice_id = p_advice_id
                   AND a.claim_id = p_claim_id
                   AND a.clm_loss_id = p_clm_loss_id
                   AND NVL (a.negate_tag, 'N') <> 'Y'
                   AND a.share_type <> 1)
      LOOP
         v_tot_payt_released_net := x.tot_payt_released_net;
      END LOOP;

      RETURN (v_tot_payt_released_net);
   END;

   FUNCTION get_payments (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN payments_tab PIPELINED
   IS
      v_rec   payments_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.claim_id, a.item_no, a.peril_cd, a.item_no || '-' || a.peril_cd item_peril, a.clm_loss_id,
                                a.payee_cd, a.payee_class_cd, a.tran_id,
                                  NVL (a.paid_amt, 0)
                                * DECODE (a.currency_cd,
                                          giacp.n ('CURRENCY_CD'), 1,
                                          c.currency_cd, 1,
                                          (NVL (c.orig_curr_rate, c.convert_rate))
                                         ) paid_amt,
                                a.advice_id, b.short_name, c.currency_cd,
                                DECODE (d.loss_exp_type, 'L', 'LOSS', 'E', 'EXPENSE') CATEGORY,
                                   UPPER (get_payee_name (a.payee_cd, a.payee_class_cd))
                                || ' / '
                                || UPPER (e.mail_addr1)
                                || ' '
                                || UPPER (e.mail_addr2)
                                || ' '
                                || UPPER (e.mail_addr3) payee_address,
                                f.dv_pref || '-' || f.dv_no tran_no, f.dv_date, g.check_no
                           FROM gicl_clm_loss_exp a,
                                giis_currency b,
                                gicl_advice c,
                                gicl_loss_exp_dtl d,
                                giis_payees e,
                                giac_disb_vouchers f,
                                giac_chk_disbursement g
                          WHERE a.claim_id = p_claim_id
                            AND c.currency_cd = b.main_currency_cd
                            AND NVL (a.dist_sw, 'N') <> 'N'
                            AND NVL (a.cancel_sw, 'N') = 'N'
                            AND a.claim_id = c.claim_id
                            AND a.advice_id = c.advice_id
                            AND NVL (c.apprvd_tag, 'N') = 'Y'
                            AND a.tran_id IS NOT NULL
                            AND d.claim_id = a.claim_id
                            AND d.clm_loss_id = a.clm_loss_id
                            AND e.payee_no = a.payee_cd
                            AND e.payee_class_cd = a.payee_class_cd
                            AND f.gacc_tran_id = a.tran_id
                            AND g.gacc_tran_id = a.tran_id
                       ORDER BY a.tran_id)
      LOOP
         v_rec.claim_id := i.claim_id;
         v_rec.item_no := i.item_no;
         v_rec.peril_cd := i.peril_cd;
         v_rec.clm_loss_id := i.clm_loss_id;
         v_rec.payee_class_cd := i.payee_class_cd;
         v_rec.tran_id := i.tran_id;
         v_rec.advice_id := i.advice_id;
         v_rec.currency_cd := i.currency_cd;
         v_rec.item_peril := i.item_peril;
         v_rec.paid_amt := i.paid_amt;
         v_rec.short_name := i.short_name;
         v_rec.CATEGORY := i.CATEGORY;
         v_rec.payee_address := i.payee_address;
         v_rec.tran_no := i.tran_no;
         v_rec.dv_date := i.dv_date;
         v_rec.check_no := i.check_no;
         v_rec.tot_payt_released_net := cf_tot_payt_released_net (p_claim_id, i.advice_id, i.clm_loss_id);
         cf_released2 (p_claim_id, i.tran_id, v_rec.date_released, v_rec.released);
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION cf_reference_no (p_acct_tran_id giac_order_of_payts.gacc_tran_id%TYPE)
      RETURN VARCHAR2
   IS
      v_ref_no   VARCHAR2 (30);
   BEGIN
      FOR t IN (SELECT tran_class, TO_CHAR (tran_class_no, '0999999999') tran_class_no
                  FROM giac_acctrans
                 WHERE tran_id = p_acct_tran_id)
      LOOP
         IF t.tran_class = 'COL'
         THEN
            FOR c IN (SELECT or_pref_suf || '-' || TO_CHAR (or_no, '0999999999') or_no
                        FROM giac_order_of_payts
                       WHERE gacc_tran_id = p_acct_tran_id)
            LOOP
               v_ref_no := c.or_no;
            END LOOP;
         ELSIF t.tran_class = 'DV'
         THEN
            FOR r IN (SELECT    document_cd
                             || '-'
                             || branch_cd
                             || '-'
                             || TO_CHAR (doc_year)
                             || '-'
                             || TO_CHAR (doc_mm)
                             || '-'
                             || TO_CHAR (doc_seq_no, '099999') request_no
                        FROM giac_payt_requests a, giac_payt_requests_dtl b
                       WHERE a.ref_id = b.gprq_ref_id AND b.tran_id = p_acct_tran_id)
            LOOP
               v_ref_no := r.request_no;

               FOR d IN (SELECT dv_pref || '-' || TO_CHAR (dv_no, '0999999999') dv_no
                           FROM giac_disb_vouchers
                          WHERE gacc_tran_id = p_acct_tran_id)
               LOOP
                  v_ref_no := d.dv_no;
               END LOOP;
            END LOOP;
         ELSIF t.tran_class = 'JV'
         THEN
            v_ref_no := t.tran_class || '-' || t.tran_class_no;
         END IF;
      END LOOP;

      RETURN (v_ref_no);
   END;

   FUNCTION cf_tot_rec_amt_net (
      p_recovery_id        gicl_recovery_ds.recovery_id%TYPE,
      p_recovery_payt_id   gicl_recovery_ds.recovery_payt_id%TYPE
   )
      RETURN NUMBER
   IS
      v_tot_rec_amt_net   gicl_recovery_ds.shr_recovery_amt%TYPE;
   BEGIN
      FOR x IN (SELECT SUM (shr_recovery_amt) rec_amt_net
                  FROM gicl_recovery_ds
                 WHERE recovery_id = p_recovery_id
                   AND recovery_payt_id = p_recovery_payt_id
                   AND share_type <> 1
                   AND NVL (negate_tag, 'N') = 'N')
      LOOP
         v_tot_rec_amt_net := x.rec_amt_net;
      END LOOP;

      RETURN (v_tot_rec_amt_net);
   END;

   FUNCTION get_recoveries (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN recovery_tab PIPELINED
   IS
      v_rec   recovery_type;
   BEGIN
      FOR i IN (SELECT z.claim_id, z.recovery_id, z.payor_class_cd, z.payor_cd, z.recovered_amt, z.acct_tran_id,
                       z.recovery_payt_id,
                       a.line_cd || '-' || a.iss_cd || '-' || TO_CHAR (a.rec_year) || '-'
                       || TO_CHAR (a.rec_seq_no, '099') recovery_no,
                       b.short_name,
                       DECODE (c.payee_first_name,
                               NULL, c.payee_last_name,
                               c.payee_last_name || ', ' || c.payee_first_name || ' ' || c.payee_middle_name
                              ) payor
                  FROM gicl_recovery_payt z, gicl_clm_recovery a, giis_currency b, giis_payees c
                 WHERE z.claim_id = p_claim_id
                   AND NVL (z.cancel_tag, 'N') = 'N'
                   AND z.recovery_id = a.recovery_id
                   AND a.currency_cd = b.main_currency_cd
                   AND c.payee_class_cd = z.payor_class_cd
                   AND c.payee_no = z.payor_cd)
      LOOP
         v_rec.recovery_no := i.recovery_no;
         v_rec.short_name := i.short_name;
         v_rec.payor := i.payor;
         v_rec.recovered_amt := i.recovered_amt;
         v_rec.reference_no := cf_reference_no (i.acct_tran_id);
         v_rec.tot_rec_amt_net := cf_tot_rec_amt_net (i.recovery_id, i.recovery_payt_id);
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION cf_tran_year (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN NUMBER
   IS
      v_tran_year   gicl_reserve_ds.dist_year%TYPE;
   BEGIN
      FOR x IN (SELECT a.dist_year
                  FROM gicl_reserve_ds a, gicl_clm_res_hist b
                 WHERE a.claim_id = b.claim_id AND a.claim_id = p_claim_id AND a.clm_res_hist_id = b.clm_res_hist_id)
      LOOP
         v_tran_year := x.dist_year;
      END LOOP;

      RETURN (v_tran_year);
   END;

   FUNCTION get_summary (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN summary_tab PIPELINED
   IS
      v_rec   summary_type;
   BEGIN
      FOR i IN (SELECT   a.claim_id, b.short_name,
                         SUM (  (NVL (a.loss_reserve, 0) + NVL (a.expense_reserve, 0))
                              - (NVL (a.losses_paid, 0) + NVL (a.expenses_paid, 0))
                             ) os_reserves,
                         SUM (NVL (a.losses_paid, 0) + NVL (a.expenses_paid, 0)) payments,
                         SUM (NVL (a.loss_reserve, 0) + NVL (a.expense_reserve, 0)) reserve_adj
                    FROM gicl_clm_reserve a, giis_currency b
                   WHERE a.claim_id = p_claim_id AND a.currency_cd = b.main_currency_cd
                GROUP BY a.claim_id, b.short_name)
      LOOP
         v_rec.short_name := i.short_name;
         v_rec.os_reserves := i.os_reserves;
         v_rec.payments := i.payments;
         v_rec.reserve_adj := i.reserve_adj;
         v_rec.tran_year := cf_tran_year (p_claim_id);
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_fire (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN fire_tab PIPELINED
   IS
      v_rec   fire_type;
   BEGIN
      FOR i IN (SELECT   a.claim_id, a.item_no, UPPER (a.item_title) item_title, a.district_no, a.block_no, a.currency_cd,
                         a.block_id, SUM (b.ann_tsi_amt) ann_tsi_amt, c.district_desc, c.block_desc, d.short_name
                    FROM gicl_fire_dtl a, gicl_item_peril b, giis_block c, giis_currency d
                   WHERE a.claim_id = p_claim_id
                     AND a.claim_id = b.claim_id
                     AND a.item_no = b.item_no
                     AND c.block_id = a.block_id
                     AND c.district_no = a.district_no
                     AND d.main_currency_cd = a.currency_cd
                GROUP BY a.claim_id,
                         a.item_no,
                         a.item_title,
                         a.district_no,
                         a.block_no,
                         a.block_id,
                         a.currency_cd,
                         c.district_desc,
                         c.block_desc,
                         d.short_name)
      LOOP
         v_rec.item_no := i.item_no;
         v_rec.item_title := i.item_title;
         v_rec.district_no := i.district_no;
         v_rec.block_id := i.block_id;
         v_rec.block_no := i.block_no;
         v_rec.ann_tsi_amt := i.ann_tsi_amt;
         v_rec.district_desc := i.district_desc;
         v_rec.block_desc := i.block_desc;
         v_rec.short_name := i.short_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_cargo (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN cargo_tab PIPELINED
   IS
      v_rec   cargo_type;
   BEGIN
      FOR i IN (SELECT a.claim_id, a.item_no, a.vessel_cd, a.cargo_type, a.origin, a.destn, b.vessel_name, c.cargo_type_desc
                  FROM gicl_cargo_dtl a, giis_vessel b, giis_cargo_type c
                 WHERE a.claim_id = p_claim_id AND b.vessel_cd = a.vessel_cd AND c.cargo_type = a.cargo_type)
      LOOP
         v_rec.item_no := i.item_no;
         v_rec.vessel_cd := i.vessel_cd;
         v_rec.cargo_type := i.cargo_type;
         v_rec.origin := i.origin;
         v_rec.destn := i.destn;
         v_rec.vessel_name := i.vessel_name;
         v_rec.cargo_type_desc := i.cargo_type_desc;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_casualty (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN casualty_tab PIPELINED
   IS
      v_rec   casualty_type;
   BEGIN
      FOR i IN (SELECT a.claim_id, a.item_no, UPPER (item_title) item_title, b.ann_tsi_amt, a.currency_cd, c.short_name
                  FROM gicl_casualty_dtl a, gicl_item_peril b, giis_currency c
                 WHERE a.claim_id = p_claim_id AND a.claim_id = b.claim_id AND c.main_currency_cd = a.currency_cd)
      LOOP
         v_rec.item_no := i.item_no;
         v_rec.item_title := i.item_title;
         v_rec.ann_tsi_amt := i.ann_tsi_amt;
         v_rec.short_name := i.short_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_accident (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN accident_tab PIPELINED
   IS
      v_rec   accident_type;
   BEGIN
      FOR i IN (SELECT a.claim_id, a.item_no, beneficiary_name, b.date_of_birth, b.age, relation
                  FROM gicl_accident_dtl a, gicl_beneficiary_dtl b
                 WHERE a.claim_id = p_claim_id AND a.claim_id = b.claim_id(+) AND a.item_no = b.item_no(+))
      LOOP
         v_rec.item_no := i.item_no;
         v_rec.beneficiary_name := i.beneficiary_name;
         v_rec.date_of_birth := i.date_of_birth;
         v_rec.age := i.age;
         v_rec.relation := i.relation;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION cf_oldest_os_prem (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN VARCHAR2
   IS
      v_oldest_os_prem   VARCHAR2 (10);
   BEGIN
      FOR x IN (SELECT   DECODE (a.balance_amt_due, 0, NULL, TO_CHAR (b.due_date, 'MM-DD-RRRR')) due_date, a.policy_id policy_id
                    FROM gipi_installment b, giac_aging_soa_details a
                   WHERE b.iss_cd = a.iss_cd
                     AND b.iss_cd <> 'RI'
                     AND b.prem_seq_no = a.prem_seq_no
                     AND b.inst_no = a.inst_no
                     AND a.policy_id = p_policy_id
                UNION
                SELECT   DECODE (a.balance_due, 0, NULL, TO_CHAR (b.due_date, 'MM-DD-RRRR')) due_date, c.policy_id policy_id
                    FROM gipi_installment b, giac_aging_ri_soa_details a, gipi_invoice c
                   WHERE b.iss_cd = 'RI'
                     AND b.prem_seq_no = a.prem_seq_no
                     AND b.inst_no = a.inst_no
                     AND c.prem_seq_no = a.prem_seq_no
                     AND c.policy_id = p_policy_id
                     AND c.iss_cd = b.iss_cd
                ORDER BY 2 ASC)
      LOOP
         v_oldest_os_prem := x.due_date;
         EXIT;
      END LOOP;

      RETURN (v_oldest_os_prem);
   END;

   FUNCTION get_oldest_os_prem (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN oldest_os_prem_tab PIPELINED
   IS
      v_rec          oldest_os_prem_type;
      v_line_cd      gipi_polbasic.line_cd%TYPE;
      v_subline_cd   gipi_polbasic.subline_cd%TYPE;
      v_iss_cd       gipi_polbasic.iss_cd%TYPE;
      v_issue_yy     gipi_polbasic.issue_yy%TYPE;
      v_renew_no     gipi_polbasic.renew_no%TYPE;
      v_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE;
      v_loss_date    gicl_claims.loss_date%TYPE;
   BEGIN
      SELECT line_cd, subline_cd, pol_iss_cd, issue_yy, pol_seq_no, renew_no, loss_date
        INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no, v_renew_no, v_loss_date
        FROM gicl_claims
       WHERE claim_id = p_claim_id;

      FOR i IN (SELECT policy_id, line_cd, subline_cd, iss_cd pol_iss_cd, issue_yy, pol_seq_no, renew_no
                  FROM gipi_polbasic
                 WHERE line_cd = v_line_cd
                   AND subline_cd = v_subline_cd
                   AND iss_cd = v_iss_cd
                   AND issue_yy = v_issue_yy
                   AND renew_no = v_renew_no
                   AND pol_seq_no = v_pol_seq_no
                   AND pol_flag IN ('1', '2', '3', 'X')
                   AND eff_date <= v_loss_date
                   AND NVL (endt_expiry_date, expiry_date) >= v_loss_date)
      LOOP
         v_rec.policy_id := i.policy_id;
         v_rec.oldest_os_prem := cf_oldest_os_prem (i.policy_id);
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_signatory (p_line_cd giis_line.line_cd%TYPE)
      RETURN signatory_tab PIPELINED
   IS
      v_rec   signatory_type;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.report_no, b.item_no, b.label, b.signatory_id, c.signatory, c.designation
                    FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                   WHERE a.report_no = b.report_no
                     AND a.report_id = b.report_id
                     AND b.signatory_id = c.signatory_id
                     AND b.report_no >= 0
                     AND a.report_id = 'GICLR034'
                     AND NVL (a.line_cd, p_line_cd) = p_line_cd
                MINUS
                SELECT   a.line_cd, a.report_no, b.item_no, b.label, b.signatory_id, c.signatory, c.designation
                    FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                   WHERE a.report_no = b.report_no
                     AND a.report_id = b.report_id
                     AND b.signatory_id = c.signatory_id
                     AND a.report_no >= 0
                     AND a.report_id = 'GICLR034'
                     AND a.line_cd IS NULL
                     AND EXISTS (SELECT 1
                                   FROM giac_documents
                                  WHERE report_id = 'GICLR034' AND report_no >= 0 AND line_cd = p_line_cd)
                ORDER BY 3)
      LOOP
         v_rec.label := i.label;
         v_rec.signatory := i.signatory;
         v_rec.designation := i.designation;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION cf_amount (
      p_claim_id     gicl_claims.claim_id%TYPE,
      p_adv_fla_id   gicl_advice.adv_fla_id%TYPE,
      p_ri_cd        gicl_loss_exp_rids.ri_cd%TYPE,
      p_grp_seq_no   gicl_loss_exp_rids.grp_seq_no%TYPE,
      p_share_type   gicl_loss_exp_rids.share_type%TYPE
   )
      RETURN NUMBER
   IS
      v_amt   NUMBER (16, 2);
   BEGIN
      FOR x IN (SELECT   d.short_name,
                         SUM (  NVL (a.shr_le_ri_adv_amt, 0)
                              * DECODE (b.currency_cd,
                                        giacp.n ('CURRENCY_CD'), 1,
                                        c.currency_cd, 1,
                                        (NVL (c.orig_curr_rate, c.convert_rate))
                                       )
                             ) amt
                    FROM gicl_loss_exp_rids a, gicl_clm_loss_exp b, gicl_advice c, giis_currency d
                   WHERE a.clm_loss_id = b.clm_loss_id
                     AND b.advice_id = c.advice_id
                     AND c.adv_fla_id = p_adv_fla_id
                     AND a.ri_cd = p_ri_cd
                     AND a.claim_id = p_claim_id
                     AND a.grp_seq_no = p_grp_seq_no
                     AND a.share_type = p_share_type
                     AND c.currency_cd = d.main_currency_cd
                GROUP BY d.short_name)
      LOOP
         v_amt := x.amt;
      END LOOP;

      RETURN (v_amt);
   END;

   PROCEDURE cf_orig_tran (
      p_claim_id             gicl_claims.claim_id%TYPE,
      p_request_date   OUT   giac_payt_requests.request_date%TYPE,
      p_csr_no         OUT   VARCHAR2
   )
   IS
   BEGIN
      FOR x IN (SELECT DISTINCT    a.document_cd
                                || '-'
                                || a.branch_cd
                                || '-'
                                || a.line_cd
                                || '-'
                                || TO_CHAR (a.doc_year)
                                || '-'
                                || TO_CHAR (a.doc_mm, '09')
                                || '-'
                                || TO_CHAR (a.doc_seq_no, '099999') csr_no,
                                a.request_date
                           FROM giac_payt_requests a, giac_payt_requests_dtl b, giac_direct_claim_payts c
                          WHERE a.ref_id = b.gprq_ref_id
                            AND b.tran_id = c.gacc_tran_id
                            AND b.payt_req_flag <> 'X'
                            AND c.advice_id IN (SELECT advice_id
                                                  FROM gicl_advice
                                                 WHERE claim_id = p_claim_id)
                            AND c.claim_id = p_claim_id
                UNION
                SELECT DISTINCT    a.document_cd
                                || '-'
                                || a.branch_cd
                                || '-'
                                || a.line_cd
                                || '-'
                                || TO_CHAR (a.doc_year)
                                || '-'
                                || TO_CHAR (a.doc_mm, '09')
                                || '-'
                                || TO_CHAR (a.doc_seq_no, '099999') csr_no,
                                a.request_date
                           FROM giac_payt_requests a, giac_payt_requests_dtl b, giac_inw_claim_payts c
                          WHERE a.ref_id = b.gprq_ref_id
                            AND b.tran_id = c.gacc_tran_id
                            AND b.payt_req_flag <> 'X'
                            AND c.advice_id IN (SELECT advice_id
                                                  FROM gicl_advice
                                                 WHERE claim_id = p_claim_id)
                            AND c.claim_id = p_claim_id)
      LOOP
         p_csr_no := x.csr_no;
         p_request_date := x.request_date;
      END LOOP;
   END;

    PROCEDURE cf_loss_exp(
      p_claim_id   gicl_claims.claim_id%TYPE, 
      p_item_peril OUT VARCHAR2,
      p_category   OUT VARCHAR2)
    IS
    BEGIN
       FOR x IN (SELECT item_no || '-' || peril_cd item_peril, DECODE(payee_type,'L','LOSS','E','EXPENSE') category
                   FROM gicl_clm_loss_exp
                  WHERE claim_id = p_claim_id)
       LOOP
          p_item_peril := x.item_peril;
          p_category := x.category;
       END LOOP;
    END;

   FUNCTION get_ri_recovery_share (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN ri_recovery_share_tab PIPELINED
   IS
      v_rec   ri_recovery_share_type;
   BEGIN
      FOR i IN (SELECT DISTINCT x.share_type, UPPER (a.rv_meaning) share_type_desc
                          FROM gicl_advs_fla x, gicl_advice y, cg_ref_codes a
                         WHERE x.claim_id = p_claim_id
                           AND y.claim_id = x.claim_id
                           AND y.adv_fla_id = x.adv_fla_id
                           AND NVL (y.advice_flag, 'N') = 'Y'
                           AND NVL (x.cancel_tag, 'N') = 'N'
                           AND a.rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE'
                           AND x.share_type = a.rv_low_value)
      LOOP
         v_rec.share_type := i.share_type;
         v_rec.share_type_desc := i.share_type_desc;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION get_ri_recovery (
     p_claim_id gicl_claims.claim_id%TYPE,
     p_share_type   gicl_loss_exp_rids.share_type%TYPE)
      RETURN ri_recovery_tab PIPELINED
   IS
      v_rec   ri_recovery_type;
   BEGIN
      FOR i IN (SELECT DISTINCT b.claim_id, b.ri_cd, b.share_type,
                                b.line_cd || '-' || TO_CHAR (b.la_yy, '09') || '-' || TO_CHAR (b.fla_seq_no, '0999999') recy_trn,
                                b.adv_fla_id, b.grp_seq_no, a.currency_cd, e.short_name, f.ri_name 
                           FROM gicl_advs_fla b, gicl_advice a, giis_currency e, giis_reinsurer f
                          WHERE b.claim_id = p_claim_id
                            AND b.share_type = p_share_type
                            AND a.claim_id = b.claim_id
                            AND a.adv_fla_id = b.adv_fla_id
                            AND NVL (a.advice_flag, 'N') = 'Y'
                            AND NVL (b.cancel_tag, 'N') = 'N'
                            AND e.main_currency_cd = a.currency_cd 
                            AND f.ri_cd = b.ri_cd
                          ORDER BY f.ri_name)
      LOOP
         v_rec.ri_cd := i.ri_cd;
         v_rec.recy_trn := i.recy_trn;
         v_rec.short_name := i.short_name;
         v_rec.ri_name := i.ri_name;
         v_rec.amount := cf_amount (i.claim_id, i.adv_fla_id, i.ri_cd, i.grp_seq_no, i.share_type);
         cf_orig_tran (i.claim_id, v_rec.request_date, v_rec.csr_no);
         cf_loss_exp(i.claim_id, v_rec.item_peril, v_rec.category);
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;   
END;
/


