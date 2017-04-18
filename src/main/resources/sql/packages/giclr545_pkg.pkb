CREATE OR REPLACE PACKAGE BODY CPI.giclr545_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 08.14.2013
     **  Reference By : GICLR545
     **  Description  : Reported Claims per Status
     */
   FUNCTION cf_company_name
      RETURN CHAR
   IS
      ws_company   giis_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO ws_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ws_company := NULL;
      END;

      RETURN (ws_company);
   END;

   FUNCTION cf_company_address
      RETURN CHAR
   IS
      ws_address   giis_parameters.param_value_v%TYPE;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO ws_address
           FROM giis_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            ws_address := NULL;
      END;

      RETURN (ws_address);
   END;

   FUNCTION cf_title (p_loss_exp VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      IF p_loss_exp = 'L'
      THEN
         RETURN ('REPORTED CLAIMS PER STATUS - LOSSES');
      ELSIF p_loss_exp = 'E'
      THEN
         RETURN ('REPORTED CLAIMS PER STATUS - EXPENSES');
      ELSE
         RETURN ('REPORTED CLAIMS PER STATUS');
      END IF;
   END;

   FUNCTION cf_date (p_start_dt DATE, p_end_dt DATE)
      RETURN CHAR
   IS
      v_date   VARCHAR2 (50);
   BEGIN
      RETURN (   'from '
              || TO_CHAR (p_start_dt, 'fmMonth DD, YYYY')
              || ' to '
              || TO_CHAR (p_end_dt, 'fmMonth DD, YYYY')
             );
   END;

   FUNCTION cf_status (p_clm_stat_cd VARCHAR2, p_clm_stat_type VARCHAR2)
      RETURN CHAR
   IS
      v_stat_desc   giis_clm_stat.clm_stat_desc%TYPE;
   BEGIN
      IF p_clm_stat_cd IS NULL AND p_clm_stat_type = 'N'
      THEN
         v_stat_desc := 'OPEN CLAIMS';
      ELSIF p_clm_stat_cd IS NULL AND p_clm_stat_type IS NULL
      THEN
         v_stat_desc := 'ALL CLAIM STATUS';
      ELSIF p_clm_stat_cd IS NOT NULL AND p_clm_stat_type IS NOT NULL
      THEN
         FOR i IN (SELECT clm_stat_desc stat_desc
                     FROM giis_clm_stat
                    WHERE clm_stat_cd = p_clm_stat_cd
                      AND clm_stat_type = p_clm_stat_type)
         LOOP
            v_stat_desc := i.stat_desc;
            EXIT;
         END LOOP;
      END IF;

      RETURN (v_stat_desc);
   END;

   FUNCTION cf_clm_amt (p_loss_exp VARCHAR2)
      RETURN CHAR
   IS
   BEGIN
      IF p_loss_exp = 'L'
      THEN
         RETURN ('Loss Amount');
      ELSIF p_loss_exp = 'E'
      THEN
         RETURN ('Expense Amount');
      ELSE
         RETURN ('Claim Amount');
      END IF;
   END;

   FUNCTION cf_intm (p_pol_iss_cd VARCHAR2, p_claim_id NUMBER)
      RETURN CHAR
   IS
      v_intm     VARCHAR2 (300) := NULL;
      var_intm   VARCHAR2 (300) := NULL;
   BEGIN
      IF p_pol_iss_cd = 'RI'
      THEN
         FOR ri IN (SELECT DISTINCT b.ri_name, a.ri_cd
                               FROM gicl_claims a, giis_reinsurer b
                              WHERE a.claim_id = p_claim_id AND a.ri_cd = b.ri_cd(+))
         LOOP
            v_intm := TO_CHAR (ri.ri_cd) || '/' || ri.ri_name;

            IF var_intm IS NULL
            THEN
               var_intm := v_intm;
            ELSE
               var_intm := v_intm || CHR (10) || var_intm;
            END IF;
         END LOOP;
      ELSE
         FOR intm IN (SELECT DISTINCT a.intm_no nmbr, b.intm_name nm,
                                      b.ref_intm_cd ref_cd
                                 FROM gicl_intm_itmperil a,
                                      giis_intermediary b
                                WHERE a.intm_no = b.intm_no
                                  AND a.claim_id = p_claim_id)
         LOOP
            v_intm :=
                   TO_CHAR (intm.nmbr) || '/' || intm.ref_cd || '/'
                   || intm.nm;

            IF var_intm IS NULL
            THEN
               var_intm := v_intm;
            ELSE
               var_intm := v_intm || CHR (10) || var_intm;
            END IF;
         END LOOP;
      END IF;

      RETURN (var_intm);
   END;

   FUNCTION cf_loss_amt (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_loss_amt   gicl_clm_res_hist.loss_reserve%TYPE;
      v_loss_exp   VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L')
        INTO v_loss_exp
        FROM DUAL;

      v_loss_amt :=
         gicls540_pkg.get_loss_amt (p_claim_id,
                                    p_peril_cd,
                                    v_loss_exp,
                                    p_clm_stat_cd
                                   );
      RETURN (v_loss_amt);
   END;

   FUNCTION cf_exp_amt (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_exp_amt   gicl_clm_res_hist.expense_reserve%TYPE;
   BEGIN
      v_exp_amt :=
         gicls540_pkg.get_loss_amt (p_claim_id,
                                    p_peril_cd,
                                    'E',
                                    p_clm_stat_cd
                                   );
      RETURN (v_exp_amt);
   END;

   FUNCTION cf_retention (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_net_ret    gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_loss_exp   VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L')
        INTO v_loss_exp
        FROM DUAL;

      v_net_ret :=
         gicls540_pkg.amount_per_share_type (p_claim_id,
                                             p_peril_cd,
                                             1,
                                             v_loss_exp,
                                             p_clm_stat_cd
                                            );
      RETURN (v_net_ret);
   END;

   FUNCTION cf_exp_retention (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_net_ret   gicl_reserve_ds.shr_loss_res_amt%TYPE;
   BEGIN
      v_net_ret :=
         gicls540_pkg.amount_per_share_type (p_claim_id,
                                             p_peril_cd,
                                             1,
                                             'E',
                                             p_clm_stat_cd
                                            );
      RETURN (v_net_ret);
   END;

   FUNCTION cf_treaty (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_trty       gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_loss_exp   VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L')
        INTO v_loss_exp
        FROM DUAL;

      v_trty :=
         gicls540_pkg.amount_per_share_type (p_claim_id,
                                             p_peril_cd,
                                             giacp.v ('TRTY_SHARE_TYPE'),
                                             v_loss_exp,
                                             p_clm_stat_cd
                                            );
      RETURN (v_trty);
   END;

   FUNCTION cf_exp_treaty (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_trty   gicl_reserve_ds.shr_loss_res_amt%TYPE;
   BEGIN
      v_trty :=
         gicls540_pkg.amount_per_share_type (p_claim_id,
                                             p_peril_cd,
                                             giacp.v ('TRTY_SHARE_TYPE'),
                                             'E',
                                             p_clm_stat_cd
                                            );
      RETURN (v_trty);
   END;

   FUNCTION cf_xol (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_xol        gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_loss_exp   VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L')
        INTO v_loss_exp
        FROM DUAL;

      v_xol :=
         gicls540_pkg.amount_per_share_type (p_claim_id,
                                             p_peril_cd,
                                             giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                             v_loss_exp,
                                             p_clm_stat_cd
                                            );
      RETURN (v_xol);
   END;

   FUNCTION cf_exp_xol (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_xol   gicl_reserve_ds.shr_loss_res_amt%TYPE;
   BEGIN
      v_xol :=
         gicls540_pkg.amount_per_share_type (p_claim_id,
                                             p_peril_cd,
                                             giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                             'E',
                                             p_clm_stat_cd
                                            );
      RETURN (v_xol);
   END;

   FUNCTION cf_facul (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_facul      gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_loss_exp   VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L')
        INTO v_loss_exp
        FROM DUAL;

      v_facul :=
         gicls540_pkg.amount_per_share_type (p_claim_id,
                                             p_peril_cd,
                                             giacp.v ('FACUL_SHARE_TYPE'),
                                             v_loss_exp,
                                             p_clm_stat_cd
                                            );
      RETURN (v_facul);
   END;

   FUNCTION cf_exp_facul (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_facul   gicl_reserve_ds.shr_loss_res_amt%TYPE;
   BEGIN
      v_facul :=
         gicls540_pkg.amount_per_share_type (p_claim_id,
                                             p_peril_cd,
                                             giacp.v ('FACUL_SHARE_TYPE'),
                                             'E',
                                             p_clm_stat_cd
                                            );
      RETURN (v_facul);
   END;

   FUNCTION get_giclr545_record (
      p_clm_stat_cd     VARCHAR2,
      p_clm_stat_type   VARCHAR2,
      p_start_dt        DATE,
      p_end_dt          DATE,
      p_loss_exp        VARCHAR2,
      p_line_cd         VARCHAR2,
      p_iss_cd          VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN giclr545_record_tab PIPELINED
   IS
      v_rec   giclr545_record_type;
      mjm     BOOLEAN              := TRUE;
   BEGIN
      v_rec.company_name := cf_company_name;
      v_rec.company_address := cf_company_address;
      v_rec.title := cf_title (p_loss_exp);
      v_rec.cf_date := cf_date (p_start_dt, p_end_dt);
      v_rec.status := cf_status (p_clm_stat_cd, p_clm_stat_type);
      v_rec.cf_clm_amt := cf_clm_amt (p_loss_exp);

      FOR i IN (SELECT   a.clm_stat_cd, b.clm_stat_desc, a.claim_id,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                         || '-'
                         || LPAD (TO_CHAR (a.clm_seq_no), 7, '0')
                                                                claim_number,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.pol_iss_cd
                         || '-'
                         || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                         || '-'
                         || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                         || '-'
                         || LPAD (TO_CHAR (a.renew_no), 2, '0')
                                                               policy_number,
                         a.assured_name, a.intm_no, a.pol_iss_cd,
                         a.pol_eff_date, a.dsp_loss_date, a.clm_file_date
                    FROM gicl_claims a, giis_clm_stat b
                   WHERE a.clm_stat_cd = b.clm_stat_cd
                     AND a.clm_stat_cd = NVL (p_clm_stat_cd, a.clm_stat_cd)
                     AND b.clm_stat_type =
                                        NVL (p_clm_stat_type, b.clm_stat_type)
                     AND TRUNC (a.clm_file_date) BETWEEN NVL (p_start_dt,
                                                              a.clm_file_date
                                                             )
                                                     AND NVL (p_end_dt,
                                                              a.clm_file_date
                                                             )
                     AND check_user_per_iss_cd2 (a.line_cd,
                                                 a.iss_cd,
                                                 'GICLS540',
                                                 p_user_id
                                                ) = 1
                ORDER BY b.clm_stat_desc,
                         a.line_cd,
                         a.subline_cd,
                         a.iss_cd,
                         a.clm_yy,
                         a.clm_seq_no)
      LOOP
         mjm := FALSE;
         v_rec.clm_stat_cd := i.clm_stat_cd;
         v_rec.clm_stat_desc := i.clm_stat_desc;
         v_rec.claim_id := i.claim_id;
         v_rec.claim_number := i.claim_number;
         v_rec.policy_number := i.policy_number;
         v_rec.assured_name := i.assured_name;
         v_rec.intm_no := i.intm_no;
         v_rec.pol_iss_cd := i.pol_iss_cd;
         v_rec.pol_eff_date := i.pol_eff_date;
         v_rec.dsp_loss_date := i.dsp_loss_date;
         v_rec.clm_file_date := i.clm_file_date;
         v_rec.cf_intm := cf_intm (i.pol_iss_cd, i.claim_id);
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_giclr545_record;

   FUNCTION get_peril_record (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE,
      p_user_id       VARCHAR2
   )
      RETURN peril_record_tab PIPELINED
   IS
      v_rec     peril_record_type;
      v_print   BOOLEAN           := TRUE;
   BEGIN
      FOR i IN (SELECT DISTINCT b.claim_id, a.peril_cd
                           FROM giis_peril a, gicl_item_peril b
                          WHERE a.line_cd = b.line_cd
                            AND b.claim_id = NVL (p_claim_id, b.claim_id))
      LOOP
         v_print := FALSE;
         v_rec.claim_id := i.claim_id;
         v_rec.peril_cd := i.peril_cd;
         v_rec.loss_amt :=
              cf_loss_amt (i.claim_id, i.peril_cd, p_loss_exp, p_clm_stat_cd);
         v_rec.exp_amt :=
               cf_exp_amt (i.claim_id, i.peril_cd, p_loss_exp, p_clm_stat_cd);
         v_rec.RETENTION :=
             cf_retention (i.claim_id, i.peril_cd, p_loss_exp, p_clm_stat_cd);
         v_rec.exp_retention :=
            cf_exp_retention (i.claim_id,
                              i.peril_cd,
                              p_loss_exp,
                              p_clm_stat_cd
                             );
         v_rec.treaty :=
                 cf_treaty (i.claim_id, i.peril_cd, p_loss_exp, p_clm_stat_cd);
         v_rec.exp_treaty :=
             cf_exp_treaty (i.claim_id, i.peril_cd, p_loss_exp, p_clm_stat_cd);
         v_rec.xol :=
                    cf_xol (i.claim_id, i.peril_cd, p_loss_exp, p_clm_stat_cd);
         v_rec.exp_xol :=
                cf_exp_xol (i.claim_id, i.peril_cd, p_loss_exp, p_clm_stat_cd);
         v_rec.facul :=
                  cf_facul (i.claim_id, i.peril_cd, p_loss_exp, p_clm_stat_cd);
         v_rec.exp_facul :=
              cf_exp_facul (i.claim_id, i.peril_cd, p_loss_exp, p_clm_stat_cd);
         PIPE ROW (v_rec);
      END LOOP;

      IF v_print
      THEN
         v_rec.loss_amt := 0;
         v_rec.exp_amt := 0;
         v_rec.RETENTION := 0;
         v_rec.exp_retention := 0;
         v_rec.treaty := 0;
         v_rec.exp_treaty := 0;
         v_rec.xol := 0;
         v_rec.exp_xol := 0;
         v_rec.facul := 0;
         v_rec.exp_facul := 0;
         PIPE ROW (v_rec);
      END IF;
   END get_peril_record;
   
   --Deo [01.11.2017]: add start (SR-5399)
   FUNCTION escape_string (p_string VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN '"' || REPLACE (p_string, '"', '""') || '"';
   END;

   FUNCTION get_clm_amt (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_amount   gicl_reserve_ds.shr_loss_res_amt%TYPE   := 0;
      v_exist    VARCHAR2 (1);
   BEGIN
      IF p_clm_stat_cd = 'CC' OR p_clm_stat_cd = 'DN' OR p_clm_stat_cd = 'WD'
      THEN
         v_amount := 0;
      ELSE
         FOR j IN
            (SELECT DISTINCT b.claim_id, b.item_no, a.peril_cd, c.dist_sw,
                    c.tran_id, c.paid
               FROM giis_peril a,
                    gicl_item_peril b,
                    (SELECT claim_id, item_no, peril_cd,
                            NVL (dist_sw, '!') dist_sw,
                            NVL (tran_id, -1) tran_id,
                            SUM (DECODE (NVL (cancel_tag, 'N'), 'N',
                                DECODE (tran_id, NULL,
                                    DECODE (p_loss_exp, 'E',
                                        NVL (convert_rate * expense_reserve, 0),
                                        NVL (convert_rate * loss_reserve, 0)),
                                    DECODE (p_loss_exp, 'E',
                                        NVL (convert_rate * expenses_paid, 0),
                                        NVL (convert_rate * losses_paid, 0))),
                                DECODE (p_loss_exp, 'E',
                                    NVL (convert_rate * expense_reserve, 0),
                                    NVL (convert_rate * loss_reserve, 0)
                                       ))) paid
                      FROM gicl_clm_res_hist
                     WHERE claim_id = p_claim_id
                  GROUP BY claim_id, item_no, peril_cd, NVL (dist_sw, '!'),
                           NVL (tran_id, -1)) c
              WHERE a.line_cd = b.line_cd
                AND a.peril_cd = b.peril_cd
                AND b.claim_id = c.claim_id
                AND b.item_no = c.item_no
                AND b.peril_cd = c.peril_cd
                AND b.claim_id = p_claim_id
              ORDER BY 1, 2, 3)
         LOOP
            v_exist := NULL;

            FOR i IN (SELECT 'x'
                        INTO v_exist
                        FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                       WHERE a.tran_id IS NOT NULL
                         AND NVL (a.cancel_tag, 'N') = 'N'
                         AND b.payee_type = p_loss_exp
                         AND a.claim_id = p_claim_id
                         AND a.item_no = j.item_no
                         AND a.peril_cd = j.peril_cd
                         AND a.claim_id = b.claim_id
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b.peril_cd
                         AND a.grouped_item_no = b.grouped_item_no
                         AND a.clm_loss_id = b.clm_loss_id)
            LOOP
               v_exist := 'Y';
               EXIT;
            END LOOP;

            IF v_exist = 'Y'
            THEN
               IF j.tran_id > 0 AND j.dist_sw = '!'
               THEN
                  v_amount := v_amount + NVL (j.paid, 0);
               END IF;
            ELSE
               IF j.dist_sw = 'Y'
               THEN
                  v_amount := v_amount + NVL (j.paid, 0);
               END IF;
            END IF;
         END LOOP;
      END IF;

      RETURN (v_amount);
   END;

   FUNCTION get_clm_amt_per_shr (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_share_type    gicl_loss_exp_ds.share_type%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_amount   gicl_reserve_ds.shr_loss_res_amt%TYPE   := 0;
      v_exist    VARCHAR2 (1);
   BEGIN
      IF p_clm_stat_cd = 'CC' OR p_clm_stat_cd = 'DN' OR p_clm_stat_cd = 'WD'
      THEN
         v_amount := 0;
      ELSE
         FOR j IN
            (SELECT DISTINCT b.claim_id, b.item_no, a.peril_cd, c.paid,
                     d.reserve
               FROM giis_peril a,
                    gicl_item_peril b,
                    (SELECT a.claim_id, a.item_no, a.peril_cd,
                            SUM (c.convert_rate * NVL (shr_le_net_amt, 0)) paid
                       FROM gicl_clm_loss_exp a,
                            gicl_loss_exp_ds b,
                            gicl_advice c
                      WHERE a.claim_id = b.claim_id
                        AND a.clm_loss_id = b.clm_loss_id
                        AND a.claim_id = c.claim_id
                        AND a.advice_id = c.advice_id
                        AND b.claim_id = p_claim_id
                        AND a.tran_id IS NOT NULL
                        AND NVL (b.negate_tag, 'N') = 'N'
                        AND b.share_type = p_share_type
                        AND a.payee_type = DECODE (p_loss_exp, 'L', 'L', 'E')
                      GROUP BY a.claim_id, a.item_no, a.peril_cd) c,
                     (SELECT a.claim_id, a.item_no, a.peril_cd,
                             DECODE (p_loss_exp, 'L',
                                 SUM (b.convert_rate
                                    * NVL (a.shr_loss_res_amt, 0)),
                                 SUM (b.convert_rate
                                    * NVL (a.shr_exp_res_amt, 0))) reserve
                      FROM gicl_reserve_ds a, gicl_clm_res_hist b
                     WHERE a.claim_id = b.claim_id
                       AND a.clm_res_hist_id = b.clm_res_hist_id
                       AND b.dist_sw = 'Y'
                       AND a.claim_id = p_claim_id
                       AND NVL (a.negate_tag, 'N') = 'N'
                       AND a.share_type = p_share_type
                  GROUP BY a.claim_id, a.item_no, a.peril_cd) d
              WHERE a.line_cd = b.line_cd
                AND a.peril_cd = b.peril_cd
                AND b.claim_id = c.claim_id(+)
                AND b.item_no = c.item_no(+)
                AND b.peril_cd = c.peril_cd(+)
                AND b.claim_id = d.claim_id(+)
                AND b.item_no = d.item_no(+)
                AND b.peril_cd = d.peril_cd(+)
                AND b.claim_id = p_claim_id
              ORDER BY 1, 2, 3)
         LOOP
            v_exist := NULL;

            FOR i IN (SELECT 'x'
                        INTO v_exist
                        FROM gicl_clm_res_hist a, gicl_clm_loss_exp b
                       WHERE a.tran_id IS NOT NULL
                         AND NVL (a.cancel_tag, 'N') = 'N'
                         AND b.payee_type = p_loss_exp
                         AND a.claim_id = p_claim_id
                         AND a.item_no = j.item_no
                         AND a.peril_cd = j.peril_cd
                         AND a.claim_id = b.claim_id
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b.peril_cd
                         AND a.grouped_item_no = b.grouped_item_no
                         AND a.clm_loss_id = b.clm_loss_id)
            LOOP
               v_exist := 'Y';
               EXIT;
            END LOOP;

            IF v_exist IS NOT NULL
            THEN
               v_amount := v_amount + NVL (j.paid, 0);
            ELSE
               v_amount := v_amount + NVL (j.reserve, 0);
            END IF;
         END LOOP;
      END IF;

      RETURN (v_amount);
   END;

   FUNCTION csv_giclr545 (
      p_start_dt        DATE,
      p_end_dt          DATE,
      p_loss_exp        VARCHAR2,
      p_clm_stat_cd     gicl_claims.clm_stat_cd%TYPE,
      p_clm_stat_type   VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED
   IS
      v                    str_csv_rec_type;
      v_rec                peril_record_type;
      v_col_hdr            VARCHAR2 (32767);
      v_col_val            VARCHAR2 (32767);
      v_cnt                NUMBER                               := 0;
      v_print              BOOLEAN                              := TRUE;
      v_trty_shr_typ       giac_parameters.param_value_v%TYPE
                                               := giacp.v ('TRTY_SHARE_TYPE');
      v_xol_trty_shr_typ   giac_parameters.param_value_v%TYPE
                                           := giacp.v ('XOL_TRTY_SHARE_TYPE');
      v_facul_shr_typ      giac_parameters.param_value_v%TYPE
                                              := giacp.v ('FACUL_SHARE_TYPE');
   BEGIN
      v_col_hdr :=
            'CLAIM STATUS,CLAIM NUMBER,POLICY NUMBER,ASSURED,'
         || 'INTERMEDIARY / CEDANT,EFF DATE,LOSS DATE,';

      IF p_loss_exp = 'LE'
      THEN
         v_col_hdr :=
               v_col_hdr
            || 'LOSS AMOUNT,RETENTION - LOSS,PROPORTIONAL TREATY - LOSS,'
            || 'NON PROPORTIONAL TREATY - LOSS,FACULTATIVE - LOSS,'
            || 'EXPENSE AMOUNT,RETENTION - EXPENSE,PROPORTIONAL TREATY - EXPENSE,'
            || 'NON PROPORTIONAL TREATY - EXPENSE,FACULTATIVE - EXPENSE,COUNT';
      ELSE
         v_col_hdr :=
               v_col_hdr
            || UPPER (cf_clm_amt (p_loss_exp))
            || ',RETENTION,PROPORTIONAL TREATY,'
            || 'NON PROPORTIONAL TREATY,FACULTATIVE,COUNT';
      END IF;

      v.rec := v_col_hdr;
      PIPE ROW (v);

      FOR i IN
         (SELECT   a.clm_stat_cd, b.clm_stat_desc, a.claim_id,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LPAD (TO_CHAR (a.clm_yy), 2, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.clm_seq_no), 7, '0') claim_number,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.pol_iss_cd
                   || '-'
                   || LPAD (TO_CHAR (a.issue_yy), 2, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.pol_seq_no), 7, '0')
                   || '-'
                   || LPAD (TO_CHAR (a.renew_no), 2, '0') policy_number,
                   a.assured_name, a.intm_no, a.pol_iss_cd, a.pol_eff_date,
                   a.dsp_loss_date, a.clm_file_date,
                   COUNT (a.clm_stat_cd) OVER (PARTITION BY a.clm_stat_cd)
                                                                  stat_cd_cnt
              FROM gicl_claims a, giis_clm_stat b
             WHERE a.clm_stat_cd = b.clm_stat_cd
               AND a.clm_stat_cd = NVL (p_clm_stat_cd, a.clm_stat_cd)
               AND b.clm_stat_type = NVL (p_clm_stat_type, b.clm_stat_type)
               AND TRUNC (a.clm_file_date) BETWEEN NVL (p_start_dt,
                                                        a.clm_file_date
                                                       )
                                               AND NVL (p_end_dt,
                                                        a.clm_file_date
                                                       )
               AND check_user_per_iss_cd2 (a.line_cd,
                                           a.iss_cd,
                                           'GICLS540',
                                           p_user_id
                                          ) = 1
          ORDER BY a.clm_stat_cd,
                   a.line_cd,
                   a.subline_cd,
                   a.iss_cd,
                   a.clm_yy,
                   a.clm_seq_no)
      LOOP
         v_cnt := v_cnt + 1;
         v_col_val :=
               escape_string (i.clm_stat_desc)
            || ','
            || escape_string (i.claim_number)
            || ','
            || escape_string (i.policy_number)
            || ','
            || escape_string (i.assured_name)
            || ','
            || escape_string (cf_intm (i.pol_iss_cd, i.claim_id))
            || ','
            || escape_string (TO_CHAR (i.pol_eff_date, 'mm-dd-yyyy'))
            || ','
            || escape_string (TO_CHAR (i.dsp_loss_date, 'mm-dd-yyyy'));
         v_print := TRUE;

         FOR j IN (SELECT DISTINCT b.claim_id
                              FROM giis_peril a, gicl_item_peril b
                             WHERE a.line_cd = b.line_cd
                               AND b.claim_id = i.claim_id)
         LOOP
            v_print := FALSE;

            IF p_loss_exp IN ('L', 'LE')
            THEN
               v_rec.loss_amt :=
                    NVL (v_rec.loss_amt, 0)
                  + get_clm_amt (j.claim_id, 'L', i.clm_stat_cd);
               v_rec.retention :=
                    NVL (v_rec.retention, 0)
                  + get_clm_amt_per_shr (j.claim_id, 1, 'L', i.clm_stat_cd);
               v_rec.treaty :=
                    NVL (v_rec.treaty, 0)
                  + get_clm_amt_per_shr (j.claim_id,
                                         v_trty_shr_typ,
                                         'L',
                                         i.clm_stat_cd
                                        );
               v_rec.xol :=
                    NVL (v_rec.xol, 0)
                  + get_clm_amt_per_shr (j.claim_id,
                                         v_xol_trty_shr_typ,
                                         'L',
                                         i.clm_stat_cd
                                        );
               v_rec.facul :=
                    NVL (v_rec.facul, 0)
                  + get_clm_amt_per_shr (j.claim_id,
                                         v_facul_shr_typ,
                                         'L',
                                         i.clm_stat_cd
                                        );
            END IF;

            IF p_loss_exp IN ('E', 'LE')
            THEN
               v_rec.exp_amt :=
                    NVL (v_rec.exp_amt, 0)
                  + get_clm_amt (j.claim_id, 'E', i.clm_stat_cd);
               v_rec.exp_retention :=
                    NVL (v_rec.exp_retention, 0)
                  + get_clm_amt_per_shr (j.claim_id, 1, 'E', i.clm_stat_cd);
               v_rec.exp_treaty :=
                    NVL (v_rec.exp_treaty, 0)
                  + get_clm_amt_per_shr (j.claim_id,
                                         v_trty_shr_typ,
                                         'E',
                                         i.clm_stat_cd
                                        );
               v_rec.exp_xol :=
                    NVL (v_rec.exp_xol, 0)
                  + get_clm_amt_per_shr (j.claim_id,
                                         v_xol_trty_shr_typ,
                                         'E',
                                         i.clm_stat_cd
                                        );
               v_rec.exp_facul :=
                    NVL (v_rec.exp_facul, 0)
                  + get_clm_amt_per_shr (j.claim_id,
                                         v_facul_shr_typ,
                                         'E',
                                         i.clm_stat_cd
                                        );
            END IF;
         END LOOP;

         IF v_print
         THEN
            IF p_loss_exp = 'LE'
            THEN
               v_col_val :=
                     v_col_val
                  || ',"0.00","0.00","0.00","0.00","0.00",'
                  || '"0.00","0.00","0.00","0.00","0.00"';
            ELSE
               v_col_val :=
                           v_col_val || ',"0.00","0.00","0.00","0.00","0.00"';
            END IF;
         ELSE
            IF p_loss_exp IN ('L', 'LE')
            THEN
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_rec.loss_amt,
                                             'fm999,999,999,990.00'
                                            )
                                   )
                  || ','
                  || escape_string (TO_CHAR (v_rec.retention,
                                             'fm999,999,999,990.00'
                                            )
                                   )
                  || ','
                  || escape_string (TO_CHAR (v_rec.treaty,
                                             'fm999,999,999,990.00'
                                            )
                                   )
                  || ','
                  || escape_string (TO_CHAR (v_rec.xol,
                                             'fm999,999,999,990.00')
                                   )
                  || ','
                  || escape_string (TO_CHAR (v_rec.facul,
                                             'fm999,999,999,990.00'
                                            )
                                   );
            END IF;

            IF p_loss_exp IN ('E', 'LE')
            THEN
               v_col_val :=
                     v_col_val
                  || ','
                  || escape_string (TO_CHAR (v_rec.exp_amt,
                                             'fm999,999,999,990.00'
                                            )
                                   )
                  || ','
                  || escape_string (TO_CHAR (v_rec.exp_retention,
                                             'fm999,999,999,990.00'
                                            )
                                   )
                  || ','
                  || escape_string (TO_CHAR (v_rec.exp_treaty,
                                             'fm999,999,999,990.00'
                                            )
                                   )
                  || ','
                  || escape_string (TO_CHAR (v_rec.exp_xol,
                                             'fm999,999,999,990.00'
                                            )
                                   )
                  || ','
                  || escape_string (TO_CHAR (v_rec.exp_facul,
                                             'fm999,999,999,990.00'
                                            )
                                   );
            END IF;
         END IF;

         IF v_cnt = i.stat_cd_cnt
         THEN
            v_col_val := v_col_val || ',' || i.stat_cd_cnt;
            v_cnt := 0;
         ELSE
            v_col_val := v_col_val || ',""';
         END IF;

         v_rec.loss_amt := 0;
         v_rec.exp_amt := 0;
         v_rec.retention := 0;
         v_rec.exp_retention := 0;
         v_rec.treaty := 0;
         v_rec.exp_treaty := 0;
         v_rec.xol := 0;
         v_rec.exp_xol := 0;
         v_rec.facul := 0;
         v_rec.exp_facul := 0;
         v.rec := v_col_val;
         PIPE ROW (v);
      END LOOP;
   END csv_giclr545;
   --Deo [01.11.2017]: add ends (SR-5399)
END;
/


