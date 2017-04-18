DROP PROCEDURE CPI.PROCESS_PACK_ENDT_CANCELLATION;

CREATE OR REPLACE PROCEDURE CPI.process_pack_endt_cancellation (
   p_par_id             IN       gipi_wpolbas.par_id%TYPE,-- this is pack_par_id
   p_policy_id          IN       gipi_polbasic.policy_id%TYPE,
   p_line_cd            IN       gipi_wpolbas.line_cd%TYPE,
   p_subline_cd         IN       gipi_wpolbas.subline_cd%TYPE,
   p_iss_cd             IN       gipi_wpolbas.iss_cd%TYPE,
   p_issue_yy           IN       gipi_wpolbas.issue_yy%TYPE,
   p_pol_seq_no         IN       gipi_wpolbas.pol_seq_no%TYPE,
   p_renew_no           IN       gipi_wpolbas.renew_no%TYPE,
   p_pack_pol_flag      IN       gipi_wpolbas.pack_pol_flag%TYPE,
   p_cancel_type        IN       gipi_wpolbas.cancel_type%TYPE,
   p_eff_date           IN OUT   VARCHAR2,
   p_endt_expiry_date   OUT      VARCHAR2,
   p_expiry_date        OUT      VARCHAR2,
   p_tsi_amt            OUT      gipi_wpolbas.tsi_amt%TYPE,
   p_prem_amt           OUT      gipi_wpolbas.prem_amt%TYPE,
   p_ann_tsi_amt        OUT      gipi_wpolbas.ann_tsi_amt%TYPE,
   p_ann_prem_amt       OUT      gipi_wpolbas.ann_prem_amt%TYPE,
   p_prorate_flag       OUT      gipi_wpolbas.prorate_flag%TYPE,
   p_prov_prem_pct      OUT      gipi_wpolbas.prov_prem_pct%TYPE,
   p_prov_prem_tag      OUT      gipi_wpolbas.prov_prem_tag%TYPE,
   p_short_rt_percent   OUT      gipi_wpolbas.short_rt_percent%TYPE,
   p_comp_sw            OUT      gipi_wpolbas.comp_sw%TYPE,
   p_par_status          OUT      VARCHAR2,
   p_msg_alert          OUT      VARCHAR2
)
AS
/**
    Description: Created for endt cancellation for endt package policies
    Date: 10.30.2012
    Created By: Irwin C. Tabisora
**/
   v_par_id             gipi_polbasic.par_id%TYPE;
   v_line_cd            gipi_polbasic.line_cd%TYPE;
   v_iss_cd             gipi_polbasic.iss_cd%TYPE;
   b540_line_cd         gipi_wpolbas.line_cd%TYPE;
   b540_subline_cd      gipi_wpolbas.subline_cd%TYPE;
   b540_iss_cd          gipi_wpolbas.iss_cd%TYPE;
   b540_issue_yy        gipi_wpolbas.issue_yy%TYPE;
   b540_pol_seq_no      gipi_wpolbas.pol_seq_no%TYPE;
   b540_renew_no        gipi_wpolbas.renew_no%TYPE;
   v_eff_date           gipi_polbasic.eff_date%TYPE
                             := TO_DATE (p_eff_date, 'MM-DD-RRRR HH24:MI:SS');
   v_expiry_date        gipi_polbasic.expiry_date%TYPE
                          := TO_DATE (p_expiry_date, 'MM-DD-RRRR HH24:MI:SS');
   v_endt_expiry_date   gipi_polbasic.endt_expiry_date%TYPE
                     := TO_DATE (p_endt_expiry_date, 'MM-DD-RRRR HH24:MI:SS');
   v_prorate            NUMBER;
   v_item_ann_prem      gipi_item.ann_prem_amt%TYPE;
   v_item_ann_tsi       gipi_item.ann_tsi_amt%TYPE;
   v_perl_ann_prem      gipi_item.ann_prem_amt%TYPE;
   v_perl_ann_tsi       gipi_item.ann_tsi_amt%TYPE;
   v_item_prem          gipi_item.ann_prem_amt%TYPE;
   v_item_tsi           gipi_item.ann_tsi_amt%TYPE;
   v_perl_prem          gipi_item.ann_prem_amt%TYPE;
   v_perl_tsi           gipi_item.ann_tsi_amt%TYPE;
   v_pol_prem           gipi_polbasic.ann_prem_amt%TYPE;
   v_pol_tsi            gipi_polbasic.ann_tsi_amt%TYPE;
   v_pol_ann_prem       gipi_polbasic.ann_prem_amt%TYPE;
   v_comp_prem          gipi_item.ann_prem_amt%TYPE;
   v_comp_var           NUMBER;
   v_prov_discount      NUMBER (12, 9);
   v_post_sw            VARCHAR2 (1)                          := 'Y';
   v_agg_sw             gipi_itmperil.aggregate_sw%TYPE;
   v_ann_tsi            gipi_item.ann_tsi_amt%TYPE;
   v_ann_prem           gipi_item.ann_prem_amt%TYPE;
BEGIN
   delete_all_tables_pack (p_par_id,
                      p_line_cd,
                      p_subline_cd,
                      p_iss_cd,
                      p_issue_yy,
                      p_pol_seq_no,
                      p_renew_no,
                      v_eff_date,
                      p_msg_alert
                     );

   FOR a1 IN (SELECT policy_id, line_cd, subline_cd
                FROM gipi_polbasic
               WHERE pack_policy_id = p_policy_id)
   LOOP
      FOR c0 IN (SELECT a.par_id, b.line_cd, b.subline_cd, b.iss_cd,
                        b.issue_yy, b.pol_seq_no, b.renew_no
                   FROM gipi_wpolbas b, gipi_parlist a
                  WHERE 1 = 1
                    AND b.par_id = a.par_id
                    AND b.line_cd = a1.line_cd
                    AND b.subline_cd = a1.subline_cd
                    AND a.pack_par_id = p_par_id                -- pack_par_id
                    AND a.par_status NOT IN (98, 99))
      LOOP
         v_par_id := c0.par_id;
         v_line_cd := c0.line_cd;
         v_iss_cd := c0.iss_cd;
         b540_line_cd := c0.line_cd;
         b540_subline_cd := c0.subline_cd;
         b540_iss_cd := c0.iss_cd;
         b540_issue_yy := c0.issue_yy;
         b540_pol_seq_no := c0.pol_seq_no;
         b540_renew_no := c0.renew_no;

         --PROCESS_ENDT_CANCELLATION
         FOR c1 IN (SELECT eff_date, endt_expiry_date, prorate_flag,
                           prov_prem_pct, prov_prem_tag, short_rt_percent,
                           ann_tsi_amt, ann_prem_amt, comp_sw, expiry_date,
                           incept_date
                      FROM gipi_polbasic
                     WHERE policy_id = a1.policy_id
                       AND pol_flag IN ('1', '2', '3'))
         LOOP
            v_pol_prem := 0;
            v_pol_tsi := 0;
            v_pol_ann_prem := 0;

            FOR c2 IN (SELECT DISTINCT item_no item
                                  FROM gipi_itmperil
                                 WHERE policy_id = a1.policy_id
                                   AND (   NVL (tsi_amt, 0) <> 0
                                        OR NVL (prem_amt, 0) <> 0
                                       ))
            LOOP
               FOR c3 IN (SELECT '1'
                            FROM gipi_itmperil a, gipi_polbasic b
                           WHERE a.policy_id = b.policy_id
                             AND b.pol_flag IN ('1', '2', '3')
                             AND (   NVL (a.tsi_amt, 0) <> 0
                                  OR NVL (a.prem_amt, 0) <> 0
                                 )
                             AND b.line_cd = b540_line_cd
                             AND b.subline_cd = b540_subline_cd
                             AND b.iss_cd = b540_iss_cd
                             AND b.issue_yy = b540_issue_yy
                             AND b.pol_seq_no = b540_pol_seq_no
                             AND b.renew_no = b540_renew_no
                             AND b.eff_date > c1.eff_date
                             AND a.item_no = c2.item)
               LOOP
                  p_msg_alert :=
                     'This endorsement cannot be cancelled there is an existing affecting endorsement that will be affected.';
                  GOTO raise_form_trigger_failure;
               END LOOP;
            END LOOP;

                    -- for PAR that is not yet saved perform POST command
             -- so that it will not encounter error in creating negated records
            /* FOR C1 IN(SELECT LINE_CD
                          FROM gipi_wpolbas
                         WHERE par_id = v_par_id)
             LOOP
               post_sw := 'N';
               EXIT;
             END LOOP;

             IF post_sw = 'Y' THEN
                POST;
             END IF;*/
            p_prorate_flag := c1.prorate_flag;
            p_prov_prem_pct := c1.prov_prem_pct;
            p_prov_prem_tag := c1.prov_prem_tag;
            p_short_rt_percent := c1.short_rt_percent;
            p_comp_sw := c1.comp_sw;
            p_prem_amt := 0;
            p_tsi_amt := 0;

            --A.R.C. 09.12.2006
            UPDATE gipi_wpolbas
               SET prorate_flag = c1.prorate_flag,
                   prov_prem_pct = c1.prov_prem_pct,
                   prov_prem_tag = c1.prov_prem_tag,
                   short_rt_percent = c1.short_rt_percent,
                   comp_sw = c1.comp_sw,
                   prem_amt = 0,
                   tsi_amt = 0
             WHERE par_id = v_par_id;

            IF NVL (c1.prov_prem_tag, 'N') = 'N'
            THEN
               v_prov_discount := 1;
            ELSE
               v_prov_discount := NVL (c1.prov_prem_pct / 100, 1);
            END IF;

            /* computation is based on prorate */
            IF c1.prorate_flag = '1'
            THEN
               v_eff_date := c1.eff_date + (1 / 1440);
               v_endt_expiry_date := c1.endt_expiry_date;
               v_expiry_date := c1.expiry_date;
               p_ann_prem_amt := c1.ann_prem_amt;
               p_ann_tsi_amt := c1.ann_tsi_amt;

               UPDATE gipi_wpolbas
                  SET eff_date = c1.eff_date + (1 / 1440),
                      endt_expiry_date = c1.endt_expiry_date,
                      expiry_date = c1.expiry_date,
                      ann_prem_amt = c1.ann_prem_amt,
                      ann_tsi_amt = c1.ann_tsi_amt
                WHERE par_id = v_par_id;

               IF NVL (c1.comp_sw, 'N') = 'N'
               THEN
                  v_comp_var := 0;
               ELSIF NVL (c1.comp_sw, 'N') = 'Y'
               THEN
                  v_comp_var := 1;
               ELSE
                  v_comp_var := -1;
               END IF;

               v_prorate :=
                    (  (TRUNC (c1.endt_expiry_date) - TRUNC (c1.eff_date))
                     + v_comp_var
                    )
                  / check_duration (c1.incept_date, c1.expiry_date);

               FOR item IN (SELECT item_no, item_title, item_grp, ann_tsi_amt,
                                   ann_prem_amt, currency_cd, currency_rt,
                                   pack_line_cd, pack_subline_cd, group_cd,
                                   tsi_amt, prem_amt
                              FROM gipi_item
                             WHERE policy_id = a1.policy_id)
               LOOP
                  INSERT INTO gipi_witem
                              (item_no, item_title, item_grp,
                               ann_tsi_amt, ann_prem_amt,
                               currency_cd, currency_rt,
                               pack_line_cd, pack_subline_cd,
                               group_cd, rec_flag, tsi_amt, prem_amt, par_id
                              )
                       VALUES (item.item_no, item.item_title, item.item_grp,
                               item.ann_tsi_amt, item.ann_prem_amt,
                               item.currency_cd, item.currency_rt,
                               item.pack_line_cd, item.pack_subline_cd,
                               item.group_cd, 'C', 0, 0, v_par_id
                              );

                  v_item_ann_tsi :=
                              NVL (item.ann_tsi_amt, 0)
                              - NVL (item.tsi_amt, 0);
                  v_item_ann_prem := item.ann_prem_amt;
                  v_pol_tsi := v_pol_tsi + (item.tsi_amt * item.currency_rt);
                  v_pol_prem :=
                               v_pol_prem
                               + (item.prem_amt * item.currency_rt);

                  IF NVL (item.tsi_amt, 0) = 0
                  THEN
                     v_item_tsi := 0;
                  ELSE
                     v_item_tsi := -item.tsi_amt;
                  END IF;

                  IF NVL (item.prem_amt, 0) = 0
                  THEN
                     v_item_prem := 0;
                  ELSE
                     v_item_prem := -item.prem_amt;
                  END IF;

                  FOR perl IN (SELECT a.item_no, a.line_cd, a.peril_cd,
                                      a.tarf_cd, a.prem_rt, a.tsi_amt,
                                      a.prem_amt, a.ann_tsi_amt,
                                      a.ann_prem_amt, a.ri_comm_amt comm_amt,
                                      a.ri_comm_rate comm_rate
                                 FROM gipi_itmperil a
                                WHERE a.policy_id = a1.policy_id
                                  AND a.item_no = item.item_no)
                  LOOP
                     v_perl_ann_tsi :=
                             NVL (perl.ann_tsi_amt, 0)
                             - NVL (perl.tsi_amt, 0);
                     v_perl_ann_prem := 0;
                     v_comp_prem := 0;

                     IF NVL (perl.comm_amt, 0) = 0
                     THEN
                        perl.comm_amt := 0;
                     ELSE
                        perl.comm_amt := -perl.prem_amt;
                     END IF;

                     IF NVL (perl.tsi_amt, 0) = 0
                     THEN
                        v_perl_tsi := 0;
                     ELSE
                        v_perl_tsi := -perl.tsi_amt;
                     END IF;

                     IF NVL (perl.prem_amt, 0) = 0
                     THEN
                        v_perl_prem := 0;
                     ELSE
                        v_perl_prem := -perl.prem_amt;
                     END IF;

                     IF NVL (perl.prem_amt, 0) <> 0
                        OR NVL (perl.tsi_amt, 0) <> 0
                     THEN
                        IF     NVL (perl.tsi_amt, 0) = 0
                           AND NVL (perl.prem_rt, 0) = 0
                        THEN
                           v_comp_prem := perl.prem_amt / v_prorate;
                        ELSE
                           v_comp_prem :=
                                ((perl.tsi_amt * perl.prem_rt) / 100
                                )
                              * v_prov_discount;
                        END IF;

                        v_pol_ann_prem :=
                             v_pol_ann_prem
                             + (v_comp_prem * item.currency_rt);
                        v_perl_ann_prem := perl.ann_prem_amt - v_comp_prem;
                        v_item_ann_prem := v_item_ann_prem - v_comp_prem;
                     END IF;

                     INSERT INTO gipi_witmperl
                                 (par_id, item_no, line_cd,
                                  peril_cd, prem_rt, tarf_cd,
                                  tsi_amt, prem_amt, ann_tsi_amt,
                                  ann_prem_amt, ri_comm_amt,
                                  ri_comm_rate
                                 )
                          VALUES (v_par_id, item.item_no, perl.line_cd,
                                  perl.peril_cd, perl.prem_rt, perl.tarf_cd,
                                  v_perl_tsi, v_perl_prem, v_perl_ann_tsi,
                                  v_perl_ann_prem, perl.comm_amt,
                                  perl.comm_rate
                                 );
                  END LOOP;

                  UPDATE gipi_witem
                     SET prem_amt = v_item_prem,
                         tsi_amt = v_item_tsi,
                         ann_prem_amt = v_item_ann_prem,
                         ann_tsi_amt = v_item_ann_tsi
                   WHERE par_id = v_par_id AND item_no = item.item_no;
				   GIPIS031_CREATE_ITEM_FOR_LINE(v_par_id, item.item_no, item.pack_line_cd); --added by robert GENQA 4844 09.02.15
               END LOOP;
            /* computation is based on 1 year span */
            ELSIF c1.prorate_flag = '2'
            THEN
               IF c1.eff_date > v_eff_date
               THEN
                  v_eff_date := c1.eff_date + (1 / 1440);
                  v_endt_expiry_date := c1.endt_expiry_date;
                  v_expiry_date := c1.expiry_date;
                  p_ann_prem_amt := c1.ann_prem_amt;
                  p_ann_tsi_amt := c1.ann_tsi_amt;

                  --A.R.C. 09.12.2006
                  UPDATE gipi_wpolbas
                     SET eff_date = c1.eff_date + (1 / 1440),
                         endt_expiry_date = c1.endt_expiry_date,
                         expiry_date = c1.expiry_date,
                         ann_prem_amt = c1.ann_prem_amt,
                         ann_tsi_amt = c1.ann_tsi_amt
                   WHERE par_id = v_par_id;
               END IF;

               FOR item IN (SELECT item_no, item_title, item_grp, ann_tsi_amt,
                                   ann_prem_amt, currency_cd, currency_rt,
                                   pack_line_cd, pack_subline_cd, group_cd,
                                   tsi_amt, prem_amt
                              FROM gipi_item
                             WHERE policy_id = a1.policy_id)
               LOOP
                  INSERT INTO gipi_witem
                              (item_no, item_title, item_grp,
                               ann_tsi_amt, ann_prem_amt,
                               currency_cd, currency_rt,
                               pack_line_cd, pack_subline_cd,
                               group_cd, rec_flag, tsi_amt, prem_amt, par_id
                              )
                       VALUES (item.item_no, item.item_title, item.item_grp,
                               item.ann_tsi_amt, item.ann_prem_amt,
                               item.currency_cd, item.currency_rt,
                               item.pack_line_cd, item.pack_subline_cd,
                               item.group_cd, 'C', 0, 0, v_par_id
                              );

                  v_item_ann_tsi :=
                              NVL (item.ann_tsi_amt, 0)
                              - NVL (item.tsi_amt, 0);
                  v_item_ann_prem := item.ann_prem_amt;
                  v_pol_tsi := v_pol_tsi + (item.tsi_amt * item.currency_rt);
                  v_pol_prem :=
                               v_pol_prem
                               + (item.prem_amt * item.currency_rt);

                  IF NVL (item.tsi_amt, 0) = 0
                  THEN
                     v_item_tsi := 0;
                  ELSE
                     v_item_tsi := -item.tsi_amt;
                  END IF;

                  IF NVL (item.prem_amt, 0) = 0
                  THEN
                     v_item_prem := 0;
                  ELSE
                     v_item_prem := -item.prem_amt;
                  END IF;

                  FOR perl IN (SELECT a.item_no, a.line_cd, a.peril_cd,
                                      a.tarf_cd, a.prem_rt, a.tsi_amt,
                                      a.prem_amt, a.ann_tsi_amt,
                                      a.ann_prem_amt, a.ri_comm_amt comm_amt,
                                      a.ri_comm_rate comm_rate
                                 FROM gipi_itmperil a
                                WHERE a.policy_id = a1.policy_id
                                  AND a.item_no = item.item_no)
                  LOOP
                     v_perl_ann_tsi :=
                             NVL (perl.ann_tsi_amt, 0)
                             - NVL (perl.tsi_amt, 0);
                     v_perl_ann_prem := 0;

                     IF NVL (perl.comm_amt, 0) = 0
                     THEN
                        perl.comm_amt := 0;
                     ELSE
                        perl.comm_amt := -perl.prem_amt;
                     END IF;

                     IF NVL (perl.tsi_amt, 0) = 0
                     THEN
                        v_perl_tsi := 0;
                     ELSE
                        v_perl_tsi := -perl.tsi_amt;
                     END IF;

                     IF NVL (perl.prem_amt, 0) = 0
                     THEN
                        v_perl_prem := 0;
                     ELSE
                        v_perl_prem := -perl.prem_amt;
                     END IF;

                     IF NVL (perl.prem_amt, 0) <> 0
                        OR NVL (perl.tsi_amt, 0) <> 0
                     THEN
                        IF     NVL (perl.tsi_amt, 0) = 0
                           AND NVL (perl.prem_rt, 0) = 0
                        THEN
                           v_comp_prem := perl.prem_amt;
                        ELSE
                           v_comp_prem :=
                                ((perl.tsi_amt * perl.prem_rt) / 100
                                )
                              * v_prov_discount;
                        END IF;

                        v_pol_ann_prem :=
                             v_pol_ann_prem
                             + (v_comp_prem * item.currency_rt);
                        v_perl_ann_prem := perl.ann_prem_amt - v_comp_prem;
                        v_item_ann_prem := v_item_ann_prem - v_comp_prem;
                     END IF;

                     INSERT INTO gipi_witmperl
                                 (par_id, item_no, line_cd,
                                  peril_cd, prem_rt, tarf_cd,
                                  tsi_amt, prem_amt, ann_tsi_amt,
                                  ann_prem_amt, ri_comm_amt,
                                  ri_comm_rate
                                 )
                          VALUES (v_par_id, item.item_no, perl.line_cd,
                                  perl.peril_cd, perl.prem_rt, perl.tarf_cd,
                                  v_perl_tsi, v_perl_prem, v_perl_ann_tsi,
                                  v_perl_ann_prem, perl.comm_amt,
                                  perl.comm_rate
                                 );
                  END LOOP;

                  UPDATE gipi_witem
                     SET prem_amt = v_item_prem,
                         tsi_amt = v_item_tsi,
                         ann_prem_amt = v_item_ann_prem,
                         ann_tsi_amt = v_item_ann_tsi
                   WHERE par_id = v_par_id AND item_no = item.item_no;
				   GIPIS031_CREATE_ITEM_FOR_LINE(v_par_id, item.item_no, item.pack_line_cd); --added by robert GENQA 4844 09.02.15
               END LOOP;
            ELSIF c1.prorate_flag = '3'
            THEN
               IF c1.eff_date > v_eff_date
               THEN
                  v_eff_date := c1.eff_date + (1 / 1440);
                  v_endt_expiry_date := c1.endt_expiry_date;
                  v_expiry_date := c1.expiry_date;
                  p_ann_prem_amt := c1.ann_prem_amt;
                  p_ann_tsi_amt := c1.ann_tsi_amt;

                  --A.R.C. 09.12.2006
                  UPDATE gipi_wpolbas
                     SET eff_date = c1.eff_date + (1 / 1440),
                         endt_expiry_date = c1.endt_expiry_date,
                         expiry_date = c1.expiry_date,
                         ann_prem_amt = c1.ann_prem_amt,
                         ann_tsi_amt = c1.ann_tsi_amt
                   WHERE par_id = v_par_id;
               END IF;

               FOR item IN (SELECT item_no, item_title, item_grp, ann_tsi_amt,
                                   ann_prem_amt, currency_cd, currency_rt,
                                   pack_line_cd, pack_subline_cd, group_cd,
                                   tsi_amt, prem_amt
                              FROM gipi_item
                             WHERE policy_id = a1.policy_id)
               LOOP
                  INSERT INTO gipi_witem
                              (item_no, item_title, item_grp,
                               ann_tsi_amt, ann_prem_amt,
                               currency_cd, currency_rt,
                               pack_line_cd, pack_subline_cd,
                               group_cd, rec_flag, tsi_amt, prem_amt, par_id
                              )
                       VALUES (item.item_no, item.item_title, item.item_grp,
                               item.ann_tsi_amt, item.ann_prem_amt,
                               item.currency_cd, item.currency_rt,
                               item.pack_line_cd, item.pack_subline_cd,
                               item.group_cd, 'C', 0, 0, v_par_id
                              );

                  v_item_ann_tsi :=
                              NVL (item.ann_tsi_amt, 0)
                              - NVL (item.tsi_amt, 0);
                  v_item_ann_prem := item.ann_prem_amt;
                  v_pol_tsi := v_pol_tsi + (item.tsi_amt * item.currency_rt);
                  v_pol_prem :=
                               v_pol_prem
                               + (item.prem_amt * item.currency_rt);

                  IF NVL (item.tsi_amt, 0) = 0
                  THEN
                     v_item_tsi := 0;
                  ELSE
                     v_item_tsi := -item.tsi_amt;
                  END IF;

                  IF NVL (item.prem_amt, 0) = 0
                  THEN
                     v_item_prem := 0;
                  ELSE
                     v_item_prem := -item.prem_amt;
                  END IF;

                  FOR perl IN (SELECT a.item_no, a.line_cd, a.peril_cd,
                                      a.tarf_cd, a.prem_rt, a.tsi_amt,
                                      a.prem_amt, a.ann_tsi_amt,
                                      a.ann_prem_amt, a.ri_comm_amt comm_amt,
                                      a.ri_comm_rate comm_rate
                                 FROM gipi_itmperil a
                                WHERE a.policy_id = a1.policy_id
                                  AND a.item_no = item.item_no)
                  LOOP
                     v_perl_ann_tsi :=
                             NVL (perl.ann_tsi_amt, 0)
                             - NVL (perl.tsi_amt, 0);
                     v_perl_ann_prem := 0;

                     IF NVL (perl.tsi_amt, 0) = 0
                     THEN
                        v_perl_tsi := 0;
                     ELSE
                        v_perl_tsi := -perl.tsi_amt;
                     END IF;

                     IF NVL (perl.prem_amt, 0) = 0
                     THEN
                        v_perl_prem := 0;
                     ELSE
                        v_perl_prem := -perl.prem_amt;
                     END IF;

                     IF NVL (perl.comm_amt, 0) = 0
                     THEN
                        perl.comm_amt := 0;
                     ELSE
                        perl.comm_amt := -perl.prem_amt;
                     END IF;

                     IF NVL (perl.prem_amt, 0) <> 0
                        OR NVL (perl.tsi_amt, 0) <> 0
                     THEN
                        IF     NVL (perl.tsi_amt, 0) = 0
                           AND NVL (perl.prem_rt, 0) = 0
                        THEN
                           v_comp_prem :=
                                perl.prem_amt
                              / (NVL (c1.short_rt_percent, 1) / 100);
                        ELSE
                           v_comp_prem :=
                                ((perl.tsi_amt * perl.prem_rt) / 100
                                )
                              * v_prov_discount;
                        END IF;

                        v_pol_ann_prem :=
                             v_pol_ann_prem
                             + (v_comp_prem * item.currency_rt);
                        v_perl_ann_prem := perl.ann_prem_amt - v_comp_prem;
                        v_item_ann_prem := v_item_ann_prem - v_comp_prem;
                     END IF;

                     INSERT INTO gipi_witmperl
                                 (par_id, item_no, line_cd,
                                  peril_cd, prem_rt, tarf_cd,
                                  tsi_amt, prem_amt, ann_tsi_amt,
                                  ann_prem_amt, ri_comm_amt,
                                  ri_comm_rate
                                 )
                          VALUES (v_par_id, item.item_no, perl.line_cd,
                                  perl.peril_cd, perl.prem_rt, perl.tarf_cd,
                                  v_perl_tsi, v_perl_prem, v_perl_ann_tsi,
                                  v_perl_ann_prem, perl.comm_amt,
                                  perl.comm_rate
                                 );
                  END LOOP;

                  UPDATE gipi_witem
                     SET prem_amt = v_item_prem,
                         tsi_amt = v_item_tsi,
                         ann_prem_amt = v_item_ann_prem,
                         ann_tsi_amt = v_item_ann_tsi
                   WHERE par_id = v_par_id AND item_no = item.item_no;
				   GIPIS031_CREATE_ITEM_FOR_LINE(v_par_id, item.item_no, item.pack_line_cd); --added by robert GENQA 4844 09.02.15
               END LOOP;
            END IF;

            p_tsi_amt := -v_pol_tsi;
            p_prem_amt := -v_pol_prem;
            p_ann_tsi_amt := p_ann_tsi_amt - v_pol_tsi;
            p_ann_prem_amt := p_ann_prem_amt - v_pol_ann_prem;

            --A.R.C. 09.12.2006
            FOR ann1 IN (SELECT ann_tsi_amt, ann_prem_amt
                           FROM gipi_wpolbas
                          WHERE par_id = v_par_id)
            LOOP
               v_ann_tsi := ann1.ann_tsi_amt;
               v_ann_prem := ann1.ann_prem_amt;
            END LOOP;

            UPDATE gipi_wpolbas
               SET tsi_amt = -v_pol_tsi,
                   prem_amt = -v_pol_prem,
                   ann_tsi_amt = v_ann_tsi - v_pol_tsi,
                   ann_prem_amt = v_ann_prem - v_pol_ann_prem
             WHERE par_id = v_par_id;
         END LOOP;

         IF p_pack_pol_flag = 'Y'
         THEN
            FOR pack IN (SELECT pack_line_cd, item_no
                           FROM gipi_witem
                          WHERE par_id = v_par_id)
            LOOP
               FOR a IN (SELECT '1'
                           FROM gipi_witmperl
                          WHERE par_id = v_par_id)
               LOOP
                  create_winvoice (0,
                                   0,
                                   0,
                                   v_par_id,
                                   pack.pack_line_cd,
                                   v_iss_cd
                                  );              -- modified by aivhie 120301
                  EXIT;
               END LOOP;
            END LOOP;
         ELSE
            FOR a IN (SELECT '1'
                        FROM gipi_witmperl
                       WHERE par_id = v_par_id)
            LOOP
               create_winvoice (0, 0, 0, v_par_id, v_line_cd, v_iss_cd);
               -- modified by aivhie 120301
               EXIT;
            END LOOP;
         END IF;

         cr_bill_dist.get_tsi (v_par_id); --(118541); replaced by robert GENQA 4844 09.02.15
         p_par_status := '5';
         p_eff_date := TO_CHAR (v_eff_date, 'MM-DD-RRRR HH24:MI:SS');
         p_endt_expiry_date :=
                         TO_CHAR (v_endt_expiry_date, 'MM-DD-RRRR HH24:MI:SS');
         p_expiry_date := TO_CHAR (v_expiry_date, 'MM-DD-RRRR HH24:MI:SS');

         -- end of process_pack_endt

         -- begin upd_gipi_pack_wpolbas
         FOR a1 IN (SELECT SUM (NVL (tsi_amt, 0)) tsi,
                           SUM (NVL (prem_amt, 0)) prem,
                           SUM (NVL (ann_tsi_amt, 0)) ann_tsi,
                           SUM (NVL (ann_prem_amt, 0)) ann_prem
                      FROM gipi_wpolbas
                     WHERE EXISTS (
                              SELECT 1
                                FROM gipi_parlist z
                               WHERE z.par_id = gipi_wpolbas.par_id
                                 AND z.par_status NOT IN (98, 99)
                                 AND z.pack_par_id = p_par_id))
         LOOP
            /* Update package basic information with respect to the
            ** fetch records from GIPI_WPOLBAS.
            */
            p_tsi_amt := a1.tsi;
            p_prem_amt := a1.prem;
            p_ann_tsi_amt := a1.ann_tsi;
            p_ann_prem_amt := a1.ann_prem;
            EXIT;
         END LOOP;
      END LOOP;
   END LOOP;

   <<raise_form_trigger_failure>>
   NULL;
END;
/


