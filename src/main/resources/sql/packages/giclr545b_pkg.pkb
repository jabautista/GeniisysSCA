CREATE OR REPLACE PACKAGE BODY CPI.giclr545b_pkg
AS
   /*
     **  Created by   : Michael John R. Malicad
     **  Date Created : 08.16.2013
     **  Reference By : GICLR545B
     **  Description  : Reported Claims Totals per Status
     */
   FUNCTION cf_company_name
      RETURN VARCHAR2
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
      RETURN VARCHAR2
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

   FUNCTION cf_loss_amt (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_loss_amt     gicl_clm_res_hist.loss_reserve%TYPE;
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_loss_amt := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_loss_amt :=
              v_loss_amt
            + gicls540_pkg.get_loss_amt (p_claim_id,
                                         p_peril_cd,
                                         v_loss_exp,
                                         p_clm_stat_cd
                                        );
         v_loss_exp := 'E';
      END LOOP;

      RETURN (v_loss_amt);
   END;

   FUNCTION cf_retention (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_net_ret      gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_net_ret := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_net_ret :=
              v_net_ret
            + gicls540_pkg.amount_per_share_type (p_claim_id,
                                                  p_peril_cd,
                                                  1,
                                                  v_loss_exp,
                                                  p_clm_stat_cd
                                                 );
         v_loss_exp := 'E';
      END LOOP;

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
      v_trty         gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_trty := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_trty :=
              v_trty
            + gicls540_pkg.amount_per_share_type (p_claim_id,
                                                  p_peril_cd,
                                                  giacp.v ('TRTY_SHARE_TYPE'),
                                                  v_loss_exp,
                                                  p_clm_stat_cd
                                                 );
         v_loss_exp := 'E';
      END LOOP;

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
      v_xol          gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_xol := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_xol :=
              v_xol
            + gicls540_pkg.amount_per_share_type
                                              (p_claim_id,
                                               p_peril_cd,
                                               giacp.v ('XOL_TRTY_SHARE_TYPE'),
                                               v_loss_exp,
                                               p_clm_stat_cd
                                              );
         v_loss_exp := 'E';
      END LOOP;

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
      v_facul        gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_loop_count   NUMBER;
      v_loss_exp     VARCHAR2 (2);
   BEGIN
      SELECT DECODE (p_loss_exp, 'E', 'E', 'L'),
             DECODE (p_loss_exp, 'LE', 2, 1)
        INTO v_loss_exp,
             v_loop_count
        FROM DUAL;

      v_facul := 0;

      FOR i IN 1 .. v_loop_count
      LOOP
         v_facul :=
              v_facul
            + gicls540_pkg.amount_per_share_type (p_claim_id,
                                                  p_peril_cd,
                                                  giacp.v ('FACUL_SHARE_TYPE'),
                                                  v_loss_exp,
                                                  p_clm_stat_cd
                                                 );
         v_loss_exp := 'E';
      END LOOP;

      RETURN (v_facul);
   END;

   FUNCTION get_giclr545b_record (
      p_clm_stat_cd     VARCHAR2,
      p_clm_stat_type   VARCHAR2,
      p_start_dt        DATE,
      p_end_dt          DATE,
      p_loss_exp        VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN giclr545b_record_tab PIPELINED
   IS
      v_rec   giclr545b_record_type;
      mjm     BOOLEAN               := TRUE;
   BEGIN
      v_rec.company_name := cf_company_name;
      v_rec.company_address := cf_company_address;
      v_rec.title := cf_title (p_loss_exp);
      v_rec.cf_date := cf_date (p_start_dt, p_end_dt);
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
         PIPE ROW (v_rec);
      END LOOP;

      IF mjm = TRUE
      THEN
         v_rec.mjm := '1';
         PIPE ROW (v_rec);
      END IF;
   END get_giclr545b_record;

   FUNCTION get_peril_record (
      p_claim_id        gicl_claims.claim_id%TYPE,
      p_loss_exp        VARCHAR2,
      p_clm_stat_cd     gicl_claims.clm_stat_cd%TYPE,
      p_user_id         VARCHAR2,
      p_clm_stat_type   VARCHAR2,
      p_start_dt        DATE,
      p_end_dt          DATE
   )
      RETURN peril_record_tab PIPELINED
   IS
      v_rec     peril_record_type;
      v_print   BOOLEAN           := TRUE;
   BEGIN
      FOR y IN (SELECT   a.clm_stat_cd, b.clm_stat_desc, a.claim_id,
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
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
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
         v_rec.clm_stat_cd := y.clm_stat_cd;
         v_rec.clm_stat_desc := y.clm_stat_desc;
         v_rec.claim_id := y.claim_id;

         FOR i IN (SELECT DISTINCT b.claim_id, a.peril_cd
                              FROM giis_peril a, gicl_item_peril b
                             WHERE a.line_cd = b.line_cd
                               AND b.claim_id = y.claim_id)
         LOOP
            v_print := FALSE;
            v_rec.claim_id := i.claim_id;
            v_rec.peril_cd := i.peril_cd;
            v_rec.loss_amt :=
               cf_loss_amt (i.claim_id, i.peril_cd, p_loss_exp,
                            y.clm_stat_cd);
            v_rec.RETENTION :=
               cf_retention (i.claim_id,
                             i.peril_cd,
                             p_loss_exp,
                             y.clm_stat_cd
                            );
            v_rec.treaty :=
                 cf_treaty (i.claim_id, i.peril_cd, p_loss_exp, y.clm_stat_cd);
            v_rec.xol :=
                    cf_xol (i.claim_id, i.peril_cd, p_loss_exp, y.clm_stat_cd);
            v_rec.facul :=
                  cf_facul (i.claim_id, i.peril_cd, p_loss_exp, y.clm_stat_cd);
            PIPE ROW (v_rec);
         END LOOP;
      END LOOP;

      IF v_print
      THEN
         v_rec.loss_amt := 0;
         v_rec.RETENTION := 0;
         v_rec.treaty := 0;
         v_rec.xol := 0;
         v_rec.facul := 0;
         PIPE ROW (v_rec);
      END IF;
   END get_peril_record;
END;
/


