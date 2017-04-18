CREATE OR REPLACE PACKAGE BODY CPI.giclr206xr_pkg
AS
   FUNCTION get_giclr206xr_main (
      p_paid_date   NUMBER,
      p_from_date   DATE,
      p_to_date     DATE
   )
      RETURN giclr206xr_tab PIPELINED
   AS
      v_rec     giclr206xr_type;
      v_param   VARCHAR2 (20);
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_rec.cf_company
           FROM giac_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_rec.cf_com_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.cf_com_address := NULL;
      END;

      BEGIN
         SELECT report_title
           INTO v_rec.report_title
           FROM giis_reports
          WHERE report_id = 'GICLR206XR';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.report_title := NULL;
      END;

      BEGIN
         BEGIN
            SELECT DECODE (p_paid_date,
                           1, 'Transaction Date',
                           2, 'Posting Date'
                          )
              INTO v_param
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_param := NULL;
         END;

         v_rec.cf_param_date := '(Based on ' || v_param || ')';
      END;

      BEGIN
         SELECT    'from '
                || TO_CHAR (p_from_date, 'fmMonth DD, YYYY')
                || ' to '
                || TO_CHAR (p_to_date, 'fmMonth DD, YYYY')
           INTO v_rec.cf_date
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.cf_date := NULL;
      END;

      PIPE ROW (v_rec);
      RETURN;
   END;

   FUNCTION intm_descformula (
      p_buss_source_type   giis_intm_type.intm_type%TYPE
   )
      RETURN VARCHAR2
   IS
      v_source_type_desc   giis_intm_type.intm_desc%TYPE;
   BEGIN
      BEGIN
         SELECT intm_desc
           INTO v_source_type_desc
           FROM giis_intm_type
          WHERE intm_type = p_buss_source_type;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_source_type_desc := 'REINSURER ';
         WHEN OTHERS
         THEN
            v_source_type_desc := NULL;
      END;

      RETURN v_source_type_desc;
   END;

   FUNCTION source_nameformula (
      p_iss_type      VARCHAR2,
      p_buss_source   gicl_res_brdrx_ds_extr.buss_source%TYPE
   )
      RETURN VARCHAR2
   IS
      v_source_name   giis_intermediary.intm_name%TYPE;
   BEGIN
      IF p_iss_type = 'RI'
      THEN
         BEGIN
            SELECT ri_name
              INTO v_source_name
              FROM giis_reinsurer
             WHERE ri_cd = p_buss_source;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_source_name := NULL;
         END;
      ELSE
         BEGIN
            SELECT intm_name
              INTO v_source_name
              FROM giis_intermediary
             WHERE intm_no = p_buss_source;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_source_name := NULL;
         END;
      END IF;

      RETURN v_source_name;
   END;

   FUNCTION subline_nameformula (
      p_line_cd      giis_subline.line_cd%TYPE,
      p_subline_cd   giis_subline.subline_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_subline_name   giis_subline.subline_name%TYPE;
   BEGIN
      BEGIN
         SELECT subline_name
           INTO v_subline_name
           FROM giis_subline
          WHERE subline_cd = p_subline_cd AND line_cd = p_line_cd;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_subline_name := NULL;
      END;

      RETURN v_subline_name;
   END;

   FUNCTION iss_nameformula (p_iss_cd giis_issource.iss_cd%TYPE)
      RETURN VARCHAR2
   IS
      v_iss_name   giis_issource.iss_name%TYPE;
   BEGIN
      BEGIN
         SELECT iss_name
           INTO v_iss_name
           FROM giis_issource
          WHERE iss_cd = p_iss_cd;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_iss_name := NULL;
      END;

      RETURN v_iss_name;
   END;

   FUNCTION get_header (p_session_id gicl_res_brdrx_extr.session_id%TYPE)
      RETURN header_tab PIPELINED
   AS
      v_rec   header_type;
   BEGIN
      FOR i IN (SELECT DISTINCT    a.iss_cd
                                || '-'
                                || a.buss_source
                                || '-'
                                || a.line_cd
                                || '-'
                                || a.subline_cd
                                || '-'
                                || a.loss_year dummy,
                                DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                                DECODE (a.iss_cd,
                                        'RI', 'RI',
                                        b.intm_type
                                       ) buss_source_type,
                                a.iss_cd, a.buss_source, a.line_cd,
                                a.subline_cd, a.loss_year, d.line_name,
                                1 header_part
                           FROM gicl_res_brdrx_ds_extr a,
                                giis_intermediary b,
                                giis_dist_share c,
                                giis_line d
                          WHERE a.buss_source = b.intm_no(+)
                            AND a.line_cd = c.line_cd
                            AND a.grp_seq_no = c.share_cd
                            AND c.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                            AND a.session_id = p_session_id
                            AND NVL (a.losses_paid, 0) <> 0
                            AND a.line_cd = d.line_cd
                UNION ALL
                SELECT DISTINCT    a.iss_cd
                                || '-'
                                || a.buss_source
                                || '-'
                                || a.line_cd
                                || '-'
                                || a.subline_cd
                                || '-'
                                || a.loss_year
                                || '-1' dummy,
                                DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                                DECODE (a.iss_cd,
                                        'RI', 'RI',
                                        b.intm_type
                                       ) buss_source_type,
                                a.iss_cd, a.buss_source, a.line_cd,
                                a.subline_cd, a.loss_year, d.line_name,
                                2 header_part
                           FROM gicl_res_brdrx_ds_extr a,
                                giis_intermediary b,
                                giis_dist_share c,
                                giis_line d
                          WHERE a.buss_source = b.intm_no(+)
                            AND a.line_cd = c.line_cd
                            AND a.grp_seq_no = c.share_cd
                            AND c.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                            AND a.session_id = p_session_id
                            AND NVL (a.losses_paid, 0) <> 0
                            AND a.line_cd = d.line_cd
                            AND (SELECT COUNT (DISTINCT z.grp_seq_no)
                                   FROM gicl_res_brdrx_ds_extr z
                                  WHERE z.session_id = a.session_id
                                    AND z.grp_seq_no NOT IN (1, 999)
                                    AND z.iss_cd = a.iss_cd
                                    AND z.buss_source = a.buss_source
                                    AND z.line_cd = a.line_cd
                                    AND z.subline_cd = a.subline_cd
                                    AND z.loss_year = a.loss_year) > 5)
      LOOP
         v_rec.iss_type := i.iss_type;
         v_rec.buss_source_type := i.buss_source_type;
         v_rec.buss_source_name := intm_descformula (i.buss_source_type);
         v_rec.iss_cd := i.iss_cd;
         v_rec.iss_name := iss_nameformula (i.iss_cd);
         v_rec.buss_source := i.buss_source;
         v_rec.source_name := source_nameformula (i.iss_type, i.buss_source);
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := subline_nameformula (i.line_cd, i.subline_cd);
         v_rec.loss_year := i.loss_year;
         v_rec.header_part := i.header_part;
         v_rec.dummy := i.dummy;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION treaty_nameformula (
      p_grp_seq_no   gicl_res_brdrx_ds_extr.grp_seq_no%TYPE,
      p_line_cd      gicl_res_brdrx_ds_extr.line_cd%TYPE
   )
      RETURN VARCHAR2
   IS
      v_trty_name   giis_dist_share.trty_name%TYPE;
   BEGIN
      BEGIN
         SELECT trty_name
           INTO v_trty_name
           FROM giis_dist_share
          WHERE share_cd = p_grp_seq_no AND line_cd = p_line_cd;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_trty_name := NULL;
      END;

      RETURN v_trty_name;
   END;

   FUNCTION get_treaty_header (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_iss_cd        gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_buss_source   gicl_res_brdrx_ds_extr.buss_source%TYPE,
      p_line_cd       gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd    gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_ds_extr.loss_year%TYPE,
      p_header_part   NUMBER
   )
      RETURN treaty_header_tab PIPELINED
   AS
      rep   treaty_header_type;
   BEGIN
      IF p_header_part = 1
      THEN
         FOR c IN (SELECT *
                     FROM (SELECT ROWNUM row_num, z.*
                             FROM (SELECT DISTINCT a.iss_cd, a.buss_source,
                                                   a.line_cd, a.subline_cd,
                                                   a.loss_year, a.grp_seq_no
                                              FROM gicl_res_brdrx_ds_extr a
                                             WHERE a.session_id = p_session_id
                                               AND a.grp_seq_no NOT IN
                                                                     (1, 999)
                                               AND a.iss_cd = p_iss_cd
                                               AND a.buss_source =
                                                                 p_buss_source
                                               AND a.line_cd = p_line_cd
                                               AND a.subline_cd = p_subline_cd
                                               AND a.loss_year = p_loss_year
                                          ORDER BY a.grp_seq_no) z)
                    WHERE row_num BETWEEN 1 AND 5)
         LOOP
            rep.treaty_name := treaty_nameformula (c.grp_seq_no, c.line_cd);
            rep.grp_seq_no := c.grp_seq_no;
            PIPE ROW (rep);
         END LOOP;
      ELSIF p_header_part = 2
      THEN
         FOR c IN (SELECT *
                     FROM (SELECT ROWNUM row_num, z.*
                             FROM (SELECT DISTINCT a.iss_cd, a.buss_source,
                                                   a.line_cd, a.subline_cd,
                                                   a.loss_year, a.grp_seq_no
                                              FROM gicl_res_brdrx_ds_extr a
                                             WHERE a.session_id = p_session_id
                                               AND a.grp_seq_no NOT IN
                                                                     (1, 999)
                                               AND a.iss_cd = p_iss_cd
                                               AND a.buss_source =
                                                                 p_buss_source
                                               AND a.line_cd = p_line_cd
                                               AND a.subline_cd = p_subline_cd
                                               AND a.loss_year = p_loss_year
                                          ORDER BY a.grp_seq_no) z)
                    WHERE row_num BETWEEN 6 AND 10)
         LOOP
            rep.treaty_name := treaty_nameformula (c.grp_seq_no, c.line_cd);
            rep.grp_seq_no := c.grp_seq_no;
            PIPE ROW (rep);
         END LOOP;
      END IF;
   END get_treaty_header;

   FUNCTION get_net_recovery (
      p_session_id    gicl_rcvry_brdrx_rids_extr.session_id%TYPE,
      p_claim_id      gicl_rcvry_brdrx_rids_extr.claim_id%TYPE,
      p_paid_losses   NUMBER
   )
      RETURN NUMBER
   IS
      v_pd_loss   gicl_res_brdrx_rids_extr.losses_paid%TYPE;
   BEGIN
      v_pd_loss := p_paid_losses;

      FOR i IN (SELECT shr_ri_recovery_amt rec_amt
                  FROM gicl_rcvry_brdrx_rids_extr
                 WHERE session_id = p_session_id
                   AND claim_id = p_claim_id
                   AND payee_type = 'L')
      LOOP
         IF NVL (i.rec_amt, 0) != 0
         THEN
            v_pd_loss := v_pd_loss - i.rec_amt;
         END IF;
      END LOOP;

      RETURN (v_pd_loss);
   END;

   FUNCTION get_paid_losses (
      p_session_id   gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_ds_extr.claim_id%TYPE
   )
      RETURN NUMBER
   AS
      v_paid_losses   NUMBER := 0;
   BEGIN
      FOR i IN (SELECT SUM (NVL (a.losses_paid, 0)) paid_losses
                  FROM gicl_res_brdrx_ds_extr a
                 WHERE a.session_id = p_session_id
                   AND a.grp_seq_no NOT IN (1, 999)
                   AND NVL (a.losses_paid, 0) <> 0
                   AND a.claim_id = p_claim_id)
      LOOP
         v_paid_losses := i.paid_losses;
      END LOOP;

      v_paid_losses :=
                    get_net_recovery (p_session_id, p_claim_id, v_paid_losses);
      RETURN v_paid_losses;
   END;

   FUNCTION get_details (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_iss_cd        gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_buss_source   gicl_res_brdrx_ds_extr.buss_source%TYPE,
      p_line_cd       gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd    gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_ds_extr.loss_year%TYPE
   )
      RETURN details_tab PIPELINED
   AS
      v_rec   details_type;
   BEGIN
      FOR c IN (SELECT DISTINCT a.claim_id, a.assd_no, a.claim_no,
                                a.policy_no, a.incept_date, a.expiry_date,
                                a.loss_date, b.assd_name, a.ref_pol_no
                           FROM gicl_res_brdrx_extr a, giis_assured b
                          WHERE a.session_id = p_session_id
                            AND NVL (a.losses_paid, 0) <> 0
                            AND a.iss_cd = p_iss_cd
                            AND a.buss_source = p_buss_source
                            AND a.line_cd = p_line_cd
                            AND a.subline_cd = p_subline_cd
                            AND a.loss_year = p_loss_year
                            AND a.assd_no = b.assd_no)
      LOOP
         v_rec.claim_id := c.claim_id;
         v_rec.claim_no := c.claim_no;
         v_rec.assd_no := c.assd_no;
         v_rec.assd_name := c.assd_name;
         v_rec.policy_no := c.policy_no;
         v_rec.ref_pol_no := c.ref_pol_no;
         v_rec.incept_date := c.incept_date;
         v_rec.expiry_date := c.expiry_date;
         v_rec.loss_date := c.loss_date;
         v_rec.paid_losses := get_paid_losses (p_session_id, c.claim_id);
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION item_titleformula (
      p_claim_id          gicl_claims.claim_id%TYPE,
      p_line_cd           gicl_claims.line_cd%TYPE,
      p_item_no           gicl_accident_dtl.item_no%TYPE,
      p_grouped_item_no   gicl_accident_dtl.grouped_item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_item_title   VARCHAR2 (200);
   BEGIN
      v_item_title :=
         get_gpa_item_title (p_claim_id,
                             p_line_cd,
                             p_item_no,
                             NVL (p_grouped_item_no, 0)
                            );
      RETURN v_item_title;
   END;

   FUNCTION get_items (
      p_session_id   gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE
   )
      RETURN item_tab PIPELINED
   AS
      v_rec   item_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.item_no, a.line_cd, a.grouped_item_no
                           FROM gicl_res_brdrx_extr a
                          WHERE a.session_id = p_session_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND ABS (NVL (a.losses_paid, 0)) > 0
                       ORDER BY item_no)
      LOOP
         v_rec.item_no := i.item_no;
         v_rec.item_title :=
            item_titleformula (p_claim_id,
                               i.line_cd,
                               i.item_no,
                               i.grouped_item_no
                              );
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION cf_intm_riformula (
      p_session_id   gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_item_no      gicl_res_brdrx_extr.item_no%TYPE,
      p_peril_cd     gicl_intm_itmperil.peril_cd%TYPE,
      p_intm_no      gicl_res_brdrx_extr.intm_no%TYPE,
      p_intm_break   NUMBER
   )
      RETURN VARCHAR2
   IS
      v_pol_iss_cd   gicl_claims.pol_iss_cd%TYPE;
      v_intm_ri      VARCHAR2 (1000);
   BEGIN
      BEGIN
         SELECT pol_iss_cd
           INTO v_pol_iss_cd
           FROM gicl_claims
          WHERE claim_id = p_claim_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_pol_iss_cd := NULL;
      END;

      IF v_pol_iss_cd = giacp.v ('RI_ISS_CD')
      THEN
         BEGIN
            FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                        FROM gicl_claims a, giis_reinsurer b
                       WHERE a.ri_cd = b.ri_cd AND a.claim_id = p_claim_id)
            LOOP
               v_intm_ri := TO_CHAR (r.ri_cd) || CHR (10) || r.ri_name;
            END LOOP;
         END;
      ELSE
         IF p_intm_break = 1
         THEN
            BEGIN
               FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                                b.ref_intm_cd ref_intm_cd
                           FROM gicl_res_brdrx_extr a, giis_intermediary b
                          WHERE a.intm_no = b.intm_no
                            AND a.session_id = p_session_id
                            AND a.claim_id = p_claim_id
                            AND a.item_no = p_item_no
                            AND a.peril_cd = p_peril_cd
                            AND a.intm_no = p_intm_no)
               LOOP
                  v_intm_ri :=
                        TO_CHAR (i.intm_no)
                     || '/'
                     || i.ref_intm_cd
                     || CHR (10)
                     || i.intm_name;
               END LOOP;
            END;
         ELSIF p_intm_break = 0
         THEN
            BEGIN
               FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                           FROM gicl_intm_itmperil a, giis_intermediary b
                          WHERE a.intm_no = b.intm_no
                            AND a.claim_id = p_claim_id
                            AND a.item_no = p_item_no
                            AND a.peril_cd = p_peril_cd)
               LOOP
                  v_intm_ri :=
                        TO_CHAR (m.intm_no)
                     || '/'
                     || m.ref_intm_cd
                     || CHR (10)
                     || m.intm_name
                     || CHR (10)
                     || v_intm_ri;
               END LOOP;
            END;
         END IF;
      END IF;

      RETURN (v_intm_ri);
   END;

   FUNCTION cf_paid_losses1formula (
      p_session_id    gicl_rcvry_brdrx_ds_extr.session_id%TYPE,
      p_claim_id      gicl_rcvry_brdrx_ds_extr.claim_id%TYPE,
      p_item_no       gicl_rcvry_brdrx_ds_extr.item_no%TYPE,
      p_peril_cd      gicl_rcvry_brdrx_ds_extr.peril_cd%TYPE,
      p_grp_seq_no    gicl_rcvry_brdrx_ds_extr.grp_seq_no%TYPE,
      p_paid_losses   gicl_res_brdrx_extr.losses_paid%TYPE
   )
      RETURN NUMBER
   IS
      v_pd_loss   gicl_res_brdrx_ds_extr.losses_paid%TYPE;
   BEGIN
      v_pd_loss := p_paid_losses;

      FOR i IN (SELECT SUM (shr_recovery_amt) rec_amt
                  FROM gicl_rcvry_brdrx_ds_extr
                 WHERE session_id = p_session_id
                   AND claim_id = p_claim_id
                   AND item_no = p_item_no
                   AND peril_cd = p_peril_cd
                   AND grp_seq_no = p_grp_seq_no
                   AND payee_type = 'L')
      LOOP
         IF NVL (i.rec_amt, 0) != 0
         THEN
            v_pd_loss := v_pd_loss - i.rec_amt;
         END IF;
      END LOOP;

      RETURN (v_pd_loss);
   END;

   FUNCTION get_perils (
      p_session_id   gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_item_no      gicl_res_brdrx_extr.item_no%TYPE,
      p_paid_date    NUMBER,
      p_from_date    DATE,
      p_to_date      DATE,
      p_intm_break   NUMBER
   )
      RETURN peril_tab PIPELINED
   AS
      v_rec   peril_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.peril_cd, a.line_cd, a.loss_cat_cd,
                                a.tsi_amt, a.intm_no, a.clm_loss_id,
                                NVL (a.losses_paid, 0) paid_losses,
                                a.grouped_item_no, b.peril_name
                           FROM gicl_res_brdrx_extr a, giis_peril b
                          WHERE a.session_id = p_session_id
                            AND a.claim_id = NVL (p_claim_id, a.claim_id)
                            AND ABS (NVL (a.losses_paid, 0)) > 0
                            AND a.item_no = p_item_no
                            AND a.peril_cd = b.peril_cd
                            AND a.line_cd = b.line_cd)
      LOOP
         v_rec.peril_cd := i.peril_cd;
         v_rec.tsi_amt := i.tsi_amt;
         v_rec.loss_cat_cd := i.loss_cat_cd;
         v_rec.paid_losses := i.paid_losses;
         v_rec.loss_cat_des := i.peril_name;
         v_rec.cf_intm_ri :=
            cf_intm_riformula (p_session_id,
                               p_claim_id,
                               p_item_no,
                               i.peril_cd,
                               p_intm_break,
                               i.intm_no
                              );
         v_rec.cf_dv_no :=
            gicls202_pkg.get_voucher_check_no (p_claim_id,
                                               p_item_no,
                                               i.peril_cd,
                                               i.grouped_item_no,
                                               p_from_date,
                                               p_to_date,
                                               p_paid_date,
                                               'L'
                                              );
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_treaty_details (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_claim_id      gicl_res_brdrx_ds_extr.claim_id%TYPE,
      p_iss_cd        gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_buss_source   gicl_res_brdrx_ds_extr.buss_source%TYPE,
      p_line_cd       gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd    gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_ds_extr.loss_year%TYPE,
      p_header_part   NUMBER
   )
      RETURN treaty_details_tab PIPELINED
   AS
      TYPE x IS TABLE OF treaty_details_type
         INDEX BY PLS_INTEGER;

      v_coll        x;
      v_rec         treaty_details_type;
      v_row_count   NUMBER (1);
      v_query       VARCHAR2 (5000);
      v_index       NUMBER;
   BEGIN
      FOR i IN
         (SELECT ROWNUM header_row_num, grp_seq_no
            FROM TABLE (giclr206xr_pkg.get_treaty_header (p_session_id,
                                                          p_iss_cd,
                                                          p_buss_source,
                                                          p_line_cd,
                                                          p_subline_cd,
                                                          p_loss_year,
                                                          p_header_part
                                                         )
                       ))
      LOOP
         FOR j IN (SELECT ROWNUM row_num, a.brdrx_ds_record_id, a.grp_seq_no,
                          a.peril_cd, a.item_no,
                          NVL (a.losses_paid, 0) paid_losses
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND ABS (NVL (a.losses_paid, 0)) > 0
                      AND a.claim_id = NVL (p_claim_id, a.claim_id)
                      AND grp_seq_no = i.grp_seq_no)
         LOOP
            IF i.header_row_num = 1
            THEN
               v_coll (j.row_num).brdrx_ds_record_id1 := j.brdrx_ds_record_id;
               v_coll (j.row_num).paid_losses1 :=
                  cf_paid_losses1formula (p_session_id,
                                          p_claim_id,
                                          j.item_no,
                                          j.peril_cd,
                                          j.grp_seq_no,
                                          j.paid_losses
                                         );
            ELSIF i.header_row_num = 2
            THEN
               v_coll (j.row_num).brdrx_ds_record_id2 := j.brdrx_ds_record_id;
               v_coll (j.row_num).paid_losses2 :=
                  cf_paid_losses1formula (p_session_id,
                                          p_claim_id,
                                          j.item_no,
                                          j.peril_cd,
                                          j.grp_seq_no,
                                          j.paid_losses
                                         );
            ELSIF i.header_row_num = 3
            THEN
               v_coll (j.row_num).brdrx_ds_record_id3 := j.brdrx_ds_record_id;
               v_coll (j.row_num).paid_losses3 :=
                  cf_paid_losses1formula (p_session_id,
                                          p_claim_id,
                                          j.item_no,
                                          j.peril_cd,
                                          j.grp_seq_no,
                                          j.paid_losses
                                         );
            ELSIF i.header_row_num = 4
            THEN
               v_coll (j.row_num).brdrx_ds_record_id4 := j.brdrx_ds_record_id;
               v_coll (j.row_num).paid_losses4 :=
                  cf_paid_losses1formula (p_session_id,
                                          p_claim_id,
                                          j.item_no,
                                          j.peril_cd,
                                          j.grp_seq_no,
                                          j.paid_losses
                                         );
            ELSIF i.header_row_num = 5
            THEN
               v_coll (j.row_num).brdrx_ds_record_id5 := j.brdrx_ds_record_id;
               v_coll (j.row_num).paid_losses5 :=
                  cf_paid_losses1formula (p_session_id,
                                          p_claim_id,
                                          j.item_no,
                                          j.peril_cd,
                                          j.grp_seq_no,
                                          j.paid_losses
                                         );
            END IF;
         END LOOP;
      END LOOP;

      v_index := v_coll.FIRST;

      WHILE v_index IS NOT NULL
      LOOP
         v_rec.brdrx_ds_record_id1 := v_coll (v_index).brdrx_ds_record_id1;
         v_rec.paid_losses1 := v_coll (v_index).paid_losses1;
         v_rec.brdrx_ds_record_id2 := v_coll (v_index).brdrx_ds_record_id2;
         v_rec.paid_losses2 := v_coll (v_index).paid_losses2;
         v_rec.brdrx_ds_record_id3 := v_coll (v_index).brdrx_ds_record_id3;
         v_rec.paid_losses3 := v_coll (v_index).paid_losses3;
         v_rec.brdrx_ds_record_id4 := v_coll (v_index).brdrx_ds_record_id4;
         v_rec.paid_losses4 := v_coll (v_index).paid_losses4;
         v_rec.brdrx_ds_record_id5 := v_coll (v_index).brdrx_ds_record_id5;
         v_rec.paid_losses5 := v_coll (v_index).paid_losses5;
         PIPE ROW (v_rec);
         v_index := v_coll.NEXT (v_index);
      END LOOP;
   END;

   FUNCTION get_facul (
      p_session_id           gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_iss_cd               gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_buss_source          gicl_res_brdrx_ds_extr.buss_source%TYPE,
      p_line_cd              gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd           gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year            gicl_res_brdrx_ds_extr.loss_year%TYPE,
      p_header_part          NUMBER,
      p_brdrx_ds_record_id   gicl_res_brdrx_ds_extr.brdrx_ds_record_id%TYPE
   )
      RETURN facul_tab PIPELINED
   AS
      TYPE x IS TABLE OF facul_type
         INDEX BY PLS_INTEGER;

      v_coll        x;
      v_rec         facul_type;
      v_row_count   NUMBER (1);
      v_query       VARCHAR2 (5000);
      v_index       NUMBER;
   BEGIN
      FOR i IN
         (SELECT ROWNUM header_row_num, grp_seq_no
            FROM TABLE (giclr206xr_pkg.get_treaty_header (p_session_id,
                                                          p_iss_cd,
                                                          p_buss_source,
                                                          p_line_cd,
                                                          p_subline_cd,
                                                          p_loss_year,
                                                          p_header_part
                                                         )
                       ))
      LOOP
         FOR j IN (SELECT ROWNUM row_num, z.*
                     FROM (SELECT   a.brdrx_ds_record_id,
                                    DECODE (a.prnt_ri_cd,
                                            NULL, a.ri_cd,
                                            a.prnt_ri_cd
                                           ) facul_ri_cd,
                                    b.ri_sname,
                                    SUM (a.shr_ri_pct) facul_shr_ri_pct,
                                    SUM (NVL (a.losses_paid, 0)) paid_losses,
                                    a.claim_id, a.item_no, a.peril_cd,
                                    a.grp_seq_no
                               FROM gicl_res_brdrx_rids_extr a,
                                    giis_reinsurer b
                              WHERE a.grp_seq_no NOT IN (1, 999)
                                AND a.session_id = p_session_id
                                AND DECODE (a.prnt_ri_cd,
                                            NULL, a.ri_cd,
                                            a.prnt_ri_cd
                                           ) = b.ri_cd
                                AND a.grp_seq_no = i.grp_seq_no
                                AND ABS (NVL (a.losses_paid, 0)) > 0
                                AND a.brdrx_ds_record_id =
                                                          p_brdrx_ds_record_id
                           GROUP BY a.brdrx_ds_record_id,
                                    DECODE (a.prnt_ri_cd,
                                            NULL, a.ri_cd,
                                            a.prnt_ri_cd
                                           ),
                                    b.ri_sname,
                                    a.claim_id,
                                    a.item_no,
                                    a.peril_cd,
                                    a.grp_seq_no
                           ORDER BY a.brdrx_ds_record_id) z)
         LOOP
            IF i.header_row_num = 1
            THEN
               v_coll (j.row_num).ri_sname1 := j.ri_sname;
               v_coll (j.row_num).paid_losses1 :=
                  cf_paid_losses1formula (p_session_id,
                                          j.claim_id,
                                          j.item_no,
                                          j.peril_cd,
                                          j.grp_seq_no,
                                          j.paid_losses
                                         );
            ELSIF i.header_row_num = 2
            THEN
               v_coll (j.row_num).ri_sname2 := j.ri_sname;
               v_coll (j.row_num).paid_losses2 :=
                  cf_paid_losses1formula (p_session_id,
                                          j.claim_id,
                                          j.item_no,
                                          j.peril_cd,
                                          j.grp_seq_no,
                                          j.paid_losses
                                         );
            ELSIF i.header_row_num = 3
            THEN
               v_coll (j.row_num).ri_sname3 := j.ri_sname;
               v_coll (j.row_num).paid_losses3 :=
                  cf_paid_losses1formula (p_session_id,
                                          j.claim_id,
                                          j.item_no,
                                          j.peril_cd,
                                          j.grp_seq_no,
                                          j.paid_losses
                                         );
            ELSIF i.header_row_num = 4
            THEN
               v_coll (j.row_num).ri_sname4 := j.ri_sname;
               v_coll (j.row_num).paid_losses4 :=
                  cf_paid_losses1formula (p_session_id,
                                          j.claim_id,
                                          j.item_no,
                                          j.peril_cd,
                                          j.grp_seq_no,
                                          j.paid_losses
                                         );
            ELSIF i.header_row_num = 5
            THEN
               v_coll (j.row_num).ri_sname5 := j.ri_sname;
               v_coll (j.row_num).paid_losses5 :=
                  cf_paid_losses1formula (p_session_id,
                                          j.claim_id,
                                          j.item_no,
                                          j.peril_cd,
                                          j.grp_seq_no,
                                          j.paid_losses
                                         );
            END IF;
         END LOOP;
      END LOOP;

      v_index := v_coll.FIRST;

      WHILE v_index IS NOT NULL
      LOOP
         v_rec.ri_sname1 := v_coll (v_index).ri_sname1;
         v_rec.paid_losses1 := v_coll (v_index).paid_losses1;
         v_rec.ri_sname2 := v_coll (v_index).ri_sname2;
         v_rec.paid_losses2 := v_coll (v_index).paid_losses2;
         v_rec.ri_sname3 := v_coll (v_index).ri_sname3;
         v_rec.paid_losses3 := v_coll (v_index).paid_losses3;
         v_rec.ri_sname4 := v_coll (v_index).ri_sname4;
         v_rec.paid_losses4 := v_coll (v_index).paid_losses4;
         v_rec.ri_sname5 := v_coll (v_index).ri_sname5;
         v_rec.paid_losses5 := v_coll (v_index).paid_losses5;
         PIPE ROW (v_rec);
         v_index := v_coll.NEXT (v_index);
      END LOOP;
   END;

   FUNCTION cf_1formula (
      p_session_id    gicl_rcvry_brdrx_rids_extr.session_id%TYPE,
      p_grp_seq_no    gicl_rcvry_brdrx_rids_extr.grp_seq_no%TYPE,
      p_ri_cd         gicl_rcvry_brdrx_rids_extr.ri_cd%TYPE,
      p_paid_losses   NUMBER
   )
      RETURN NUMBER
   IS
      v_pd_loss   gicl_res_brdrx_rids_extr.losses_paid%TYPE;
   BEGIN
      v_pd_loss := p_paid_losses;

      FOR i IN (SELECT shr_ri_recovery_amt rec_amt
                  FROM gicl_rcvry_brdrx_rids_extr
                 WHERE session_id = p_session_id
                   AND grp_seq_no = p_grp_seq_no
                   AND ri_cd = p_ri_cd
                   AND payee_type = 'L')
      LOOP
         IF NVL (i.rec_amt, 0) != 0
         THEN
            v_pd_loss := v_pd_loss - i.rec_amt;
         END IF;
      END LOOP;

      RETURN (v_pd_loss);
   END;

   FUNCTION get_treaty_ri (
      p_session_id    gicl_res_brdrx_ds_extr.session_id%TYPE,
      p_iss_cd        gicl_res_brdrx_ds_extr.iss_cd%TYPE,
      p_buss_source   gicl_res_brdrx_ds_extr.buss_source%TYPE,
      p_line_cd       gicl_res_brdrx_ds_extr.line_cd%TYPE,
      p_subline_cd    gicl_res_brdrx_ds_extr.subline_cd%TYPE,
      p_loss_year     gicl_res_brdrx_ds_extr.loss_year%TYPE
   )
      RETURN treaty_ri_tab PIPELINED
   AS
      rep   treaty_ri_type;
   BEGIN
      FOR i IN (SELECT   a.grp_seq_no,
                         DECODE (a.prnt_ri_cd,
                                 NULL, a.ri_cd,
                                 a.prnt_ri_cd
                                ) trty_ri_cd,
                         a.ri_cd, b.trty_shr_pct, a.line_cd, e.trty_name,
                         f.ri_sname, SUM (NVL (a.losses_paid, 0))
                                                                 paid_losses
                    FROM gicl_res_brdrx_rids_extr a,
                         giis_trty_panel b,
                         gicl_res_brdrx_extr c,
                         gicl_res_brdrx_ds_extr d,
                         giis_dist_share e,
                         giis_reinsurer f
                   WHERE a.grp_seq_no NOT IN (1, 999)
                     AND a.session_id = p_session_id
                     AND a.session_id = c.session_id
                     AND a.session_id = d.session_id
                     AND c.brdrx_record_id = d.brdrx_record_id
                     AND a.brdrx_ds_record_id = d.brdrx_ds_record_id
                     AND a.line_cd = b.line_cd
                     AND a.grp_seq_no = b.trty_seq_no
                     AND a.ri_cd = b.ri_cd
                     AND NVL (a.losses_paid, 0) > 0
                     AND a.grp_seq_no = e.share_cd
                     AND a.line_cd = e.line_cd
                     AND c.iss_cd = p_iss_cd
                     AND c.buss_source = p_buss_source
                     AND c.line_cd = p_line_cd
                     AND c.subline_cd = p_subline_cd
                     AND c.loss_year = p_loss_year
                     AND f.ri_cd = a.ri_cd
                GROUP BY a.grp_seq_no,
                         DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd),
                         a.ri_cd,
                         b.trty_shr_pct,
                         a.line_cd,
                         e.trty_name,
                         f.ri_sname
                ORDER BY a.grp_seq_no,
                         DECODE (a.prnt_ri_cd, NULL, a.ri_cd, a.prnt_ri_cd))
      LOOP
         rep.line_cd := i.line_cd;
         rep.grp_seq_no := i.grp_seq_no;
         rep.ri_cd := i.ri_cd;
         rep.trty_ri_cd := i.trty_ri_cd;
         rep.treaty_name := i.trty_name;
         rep.ri_name := i.ri_sname;
         rep.paid_losses :=
             cf_1formula (p_session_id, i.grp_seq_no, i.ri_cd, i.paid_losses);
         rep.trty_shr_pct := i.trty_shr_pct;
         PIPE ROW (rep);
      END LOOP;
   END get_treaty_ri;
END giclr206xr_pkg;
/


