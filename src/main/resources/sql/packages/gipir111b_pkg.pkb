CREATE OR REPLACE PACKAGE BODY CPI.gipir111b_pkg
AS
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 09.30.2013
   **  Reference By : GIPIR111B- Casualty Accumulation Report With Claims
   **  Description  :
   */
   FUNCTION populate_gipir111b (
      p_location_cd   VARCHAR2,
      p_eff_tag       VARCHAR2,
      p_expiry_tag    VARCHAR2
   )
      RETURN gipir111b_tab PIPELINED
   AS
      v_rec           gipir111b_type;
      v_not_exist     BOOLEAN                             := TRUE;
      v_policy_no     VARCHAR2 (50)                       := NULL;
      v_assured       gixx_ca_accum_dist.assd_name%TYPE   := NULL;
      v_location      gipi_casualty_item.LOCATION%TYPE    := NULL;
      v_incept_date   VARCHAR2 (50)                       := NULL;
      v_expiry_date   VARCHAR2 (50)                       := NULL;
      v_total         NUMBER (20, 2)                      := NULL;
      v_retention     NUMBER (20, 2)                      := NULL;
      v_treaty        NUMBER (20, 2)                      := NULL;
      v_facultative   NUMBER (20, 2)                      := NULL;
      v_currency_rt   gipi_item.currency_rt%TYPE          := 0;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_add := giisp.v ('COMPANY_ADDRESS');

      FOR q1 IN (SELECT a.*,
                        a.location_cd || ' - ' || a.location_desc
                                                                 AS LOCATION
                   FROM giis_ca_location a
                  WHERE location_cd = p_location_cd)
      LOOP
         FOR q2 IN (SELECT   line_cd, subline_cd, iss_cd, issue_yy,
                             pol_seq_no, renew_no, location_cd
                        FROM gixx_ca_accum
                       WHERE location_cd = q1.location_cd
                    GROUP BY line_cd,
                             subline_cd,
                             iss_cd,
                             issue_yy,
                             pol_seq_no,
                             renew_no,
                             location_cd)
         LOOP
            FOR q3 IN (SELECT   a.line_cd, a.subline_cd, a.iss_cd,
                                a.issue_yy, a.pol_seq_no, a.renew_no,
                                a.assd_name, a.policy_id,
                                   b.address1
                                || ' '
                                || b.address2
                                || ' '
                                || b.address3 AS address,
                                a.location_cd
                           FROM gixx_ca_accum_dist a, gipi_polbasic b
                          WHERE a.policy_id = b.policy_id
                            AND a.line_cd = q2.line_cd
                            AND a.subline_cd = q2.subline_cd
                            AND a.iss_cd = q2.iss_cd
                            AND a.issue_yy = q2.issue_yy
                            AND a.pol_seq_no = q2.pol_seq_no
                            AND a.renew_no = q2.renew_no
                            AND a.location_cd = q2.location_cd
                       GROUP BY a.line_cd,
                                a.subline_cd,
                                a.iss_cd,
                                a.issue_yy,
                                a.pol_seq_no,
                                a.renew_no,
                                a.assd_name,
                                a.policy_id,
                                   b.address1
                                || ' '
                                || b.address2
                                || ' '
                                || b.address3,
                                a.location_cd)
            LOOP
               FOR q4 IN
                  (SELECT   a.policy_id, a.item_no,
                            get_policy_no (a.policy_id) AS policy_no,
                            (  NVL (b.RETENTION, 0)
                             + NVL (c.treaty, 0)
                             + NVL (d.facultative, 0)
                            ) AS total,
                            b.RETENTION, c.treaty, d.facultative, e.LOCATION,
                            a.incept_date, a.expiry_date, g.claim_no,
                            g.loss_date, g.location_of_loss,
                            DECODE (g.item_no,
                                    NULL, 0,
                                    g.loss_res_amt
                                   ) loss_res_amt,
                            DECODE (g.item_no,
                                    NULL, 0,
                                    g.exp_res_amt
                                   ) exp_res_amt,
                            DECODE (g.item_no,
                                    NULL, 0,
                                    g.loss_pd_amt
                                   ) loss_pd_amt,
                            DECODE (g.item_no,
                                    NULL, 0,
                                    g.exp_pd_amt
                                   ) exp_pd_amt
                       FROM gixx_ca_accum_dist a,
                            (SELECT   policy_id, item_no,
                                      SUM (dist_tsi) AS RETENTION
                                 FROM gixx_ca_accum_dist
                                WHERE share_type = 1
                             GROUP BY policy_id, item_no) b,
                            (SELECT   policy_id, item_no,
                                      SUM (dist_tsi) AS treaty
                                 FROM gixx_ca_accum_dist
                                WHERE share_type = 2
                             GROUP BY policy_id, item_no) c,
                            (SELECT   policy_id, item_no,
                                      SUM (dist_tsi) AS facultative
                                 FROM gixx_ca_accum_dist
                                WHERE share_type = 3
                             GROUP BY policy_id, item_no) d,
                            (SELECT policy_id,
                                       line_cd
                                    || '-'
                                    || subline_cd
                                    || '-'
                                    || iss_cd
                                    || '-'
                                    || issue_yy
                                    || '-'
                                    || pol_seq_no
                                    || '-'
                                    || renew_no AS policy_no
                               FROM gixx_ca_accum_dist) f,
                            (SELECT    a.line_cd
                                    || '-'
                                    || a.subline_cd
                                    || '-'
                                    || a.pol_iss_cd
                                    || '-'
                                    || a.issue_yy
                                    || '-'
                                    || a.pol_seq_no
                                    || '-'
                                    || a.renew_no AS policy_no,
                                       a.line_cd
                                    || '-'
                                    || a.subline_cd
                                    || '-'
                                    || a.iss_cd
                                    || '-'
                                    || a.clm_yy
                                    || '-'
                                    || a.clm_seq_no AS claim_no,
                                    a.claim_id, b.item_no, a.loss_date,
                                       a.loss_loc1
                                    || ' '
                                    || a.loss_loc2
                                    || ' '
                                    || a.loss_loc3 AS location_of_loss,
                                    a.loss_res_amt, a.loss_pd_amt,
                                    a.exp_res_amt, a.exp_pd_amt
                               FROM gicl_claims a, gicl_clm_item b
                              WHERE a.claim_id = b.claim_id(+)) g,
                            gipi_casualty_item e
                      WHERE a.policy_id = b.policy_id(+)
                        AND a.policy_id = c.policy_id(+)
                        AND a.policy_id = d.policy_id(+)
                        AND a.policy_id = e.policy_id(+)
                        AND a.item_no = b.item_no(+)
                        AND a.item_no = c.item_no(+)
                        AND a.item_no = d.item_no(+)
                        AND a.item_no = e.item_no(+)
                        AND f.policy_no = g.policy_no(+)
                        AND a.item_no = NVL (g.item_no, a.item_no)
                        AND a.policy_id = f.policy_id
                        AND a.policy_id = q3.policy_id
                        AND TRUNC (a.expiry_date) >=
                               DECODE (p_expiry_tag,
                                       'Y', SYSDATE,
                                       TRUNC (a.expiry_date)
                                      )
                        AND TRUNC (a.eff_date) <=
                               DECODE (p_eff_tag,
                                       'Y', SYSDATE,
                                       TRUNC (a.eff_date)
                                      )
                   GROUP BY a.policy_id,
                            a.item_no,
                               a.line_cd
                            || '-'
                            || a.subline_cd
                            || '-'
                            || a.iss_cd
                            || '-'
                            || a.issue_yy
                            || '-'
                            || a.pol_seq_no
                            || '-'
                            || a.renew_no,
                            b.RETENTION,
                            c.treaty,
                            d.facultative,
                            e.LOCATION,
                            a.incept_date,
                            a.expiry_date,
                            g.claim_no,
                            g.loss_date,
                            g.location_of_loss,
                            g.item_no,
                            g.loss_res_amt,
                            g.exp_res_amt,
                            g.loss_pd_amt,
                            g.exp_pd_amt)
               LOOP
                  v_not_exist := FALSE;
                  v_rec.exist := 'Y';
                  v_rec.location_cd := q1.location_cd;
                  v_rec.location_desc := q1.location_desc;
                  v_rec.ret_limit := q1.ret_limit;
                  v_rec.treaty_limit := q1.treaty_limit;
                  v_rec.policy_id := q4.policy_id;
                  v_rec.policy_no := q4.policy_no;
                  v_rec.assured := q3.assd_name;
                  v_rec.LOCATION := q4.LOCATION;
                  v_rec.incept_date := TO_CHAR (q4.incept_date, 'MM-DD-RRRR');
                  v_rec.expiry_date := TO_CHAR (q4.expiry_date, 'MM-DD-RRRR');

                  FOR rt IN (SELECT currency_rt
                               FROM gipi_item
                              WHERE policy_id = q4.policy_id
                                AND item_no = q4.item_no)
                  LOOP
                     v_currency_rt := rt.currency_rt;
                  END LOOP;

                  v_rec.RETENTION := NVL (q4.RETENTION, 0) * v_currency_rt;
                  v_rec.treaty := NVL (q4.treaty, 0) * v_currency_rt;
                  v_rec.facultative := NVL (q4.facultative, 0) * v_currency_rt;
                  v_rec.total :=
                       NVL (v_rec.RETENTION, 0)
                     + NVL (v_rec.treaty, 0)
                     + NVL (v_rec.facultative, 0);

                  IF     v_policy_no IS NULL
                     AND v_assured IS NULL
                     AND v_location IS NULL
                     AND v_incept_date IS NULL
                     AND v_expiry_date IS NULL
                     AND v_total IS NULL
                     AND v_retention IS NULL
                     AND v_treaty IS NULL
                     AND v_facultative IS NULL
                  THEN
                     v_policy_no := q4.policy_no;
                     v_assured := q3.assd_name;
                     v_location := q4.LOCATION;
                     v_incept_date := TO_CHAR (q4.incept_date, 'MM-DD-RRRR');
                     v_expiry_date := TO_CHAR (q4.expiry_date, 'MM-DD-RRRR');
                     v_total := NVL (v_rec.total, 0);
                     v_retention := NVL (v_rec.RETENTION, 0);
                     v_treaty := NVL (v_rec.treaty, 0);
                     v_facultative := NVL (v_rec.facultative, 0);
                  ELSE
                     IF     v_policy_no = v_rec.policy_no
                        AND v_assured = v_rec.assured
                        AND v_location = v_rec.LOCATION
                        AND v_incept_date = v_rec.incept_date
                        AND v_expiry_date = v_rec.expiry_date
                        AND v_total = v_rec.total
                        AND v_retention = v_rec.RETENTION
                        AND v_treaty = v_rec.treaty
                        AND v_facultative = v_rec.facultative
                     THEN
                        v_rec.policy_no := NULL;
                        v_rec.assured := NULL;
                        v_rec.LOCATION := NULL;
                        v_rec.incept_date := NULL;
                        v_rec.expiry_date := NULL;
                        v_rec.total := NULL;
                        v_rec.RETENTION := NULL;
                        v_rec.treaty := NULL;
                        v_rec.facultative := NULL;
                     ELSE
                        v_policy_no := q4.policy_no;
                        v_assured := q3.assd_name;
                        v_location := q4.LOCATION;
                        v_incept_date :=
                                       TO_CHAR (q4.incept_date, 'MM-DD-RRRR');
                        v_expiry_date :=
                                       TO_CHAR (q4.expiry_date, 'MM-DD-RRRR');
                        v_total := NVL (q4.total, 0);
                        v_retention := NVL (q4.RETENTION, 0);
                        v_treaty := NVL (q4.treaty, 0);
                        v_facultative := NVL (q4.facultative, 0);
                     END IF;
                  END IF;

                  v_rec.claim_no := q4.claim_no;
                  v_rec.loss_date := TO_CHAR (q4.loss_date, 'MM-DD-RRRR');
                  v_rec.location_of_loss := q4.location_of_loss;
                  v_rec.loss_res_amt := NVL (q4.loss_res_amt, 0);
                  v_rec.exp_res_amt := NVL (q4.exp_res_amt, 0);
                  v_rec.loss_pd_amt := NVL (q4.loss_pd_amt, 0);
                  v_rec.exp_pd_amt := NVL (q4.exp_pd_amt, 0);
                  PIPE ROW (v_rec);
               END LOOP;
            END LOOP;
         END LOOP;
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.exist := 'N';
         PIPE ROW (v_rec);
      END IF;
   END populate_gipir111b;
END gipir111b_pkg;
/


