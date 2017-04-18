DROP PROCEDURE CPI.UPDATE_GIPI_WPOLBAS2;

CREATE OR REPLACE PROCEDURE CPI.update_gipi_wpolbas2 (
   p_par_id        NUMBER,
   p_negate_item   VARCHAR2)
IS
   v_tsi                gipi_wpolbas.tsi_amt%TYPE            := 0;
   v_ann_tsi            gipi_wpolbas.ann_tsi_amt%TYPE        := 0;
   v_prem               gipi_wpolbas.prem_amt%TYPE           := 0;
   v_ann_prem           gipi_wpolbas.ann_prem_amt%TYPE       := 0;
   v_ann_tsi2           gipi_wpolbas.ann_tsi_amt%TYPE        := 0;
   v_ann_prem2          gipi_wpolbas.ann_prem_amt%TYPE       := 0;
   v_prorate            NUMBER (12, 9);
   v_no_of_items        NUMBER;
   v_comp_prem          gipi_wpolbas.prem_amt%TYPE           := 0;
   expired_sw           VARCHAR2 (1)                         := 'N';
   v_exist              VARCHAR2 (1);
   v_expiry_date        DATE;
   v_line_cd            gipi_wpolbas.line_cd%TYPE;
   v_subline_cd         gipi_wpolbas.subline_cd%TYPE;
   v_iss_cd             gipi_wpolbas.iss_cd%TYPE;
   v_issue_yy           gipi_wpolbas.issue_yy%TYPE;
   v_pol_seq_no         gipi_wpolbas.pol_seq_no%TYPE;
   v_renew_no           gipi_wpolbas.renew_no%TYPE;
   v_eff_date           gipi_wpolbas.eff_date%TYPE;
   v_prorate_flag       gipi_wpolbas.prorate_flag%TYPE;
   v_comp_sw            gipi_wpolbas.comp_sw%TYPE;
   v_endt_expiry_date   gipi_wpolbas.endt_expiry_date%TYPE;
   v_short_rt_percent   gipi_wpolbas.short_rt_percent%TYPE;
BEGIN
   v_expiry_date := extract_expiry (p_par_id);

   SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
          renew_no, eff_date, prorate_flag, comp_sw, endt_expiry_date, short_rt_percent
     INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no,
          v_renew_no, v_eff_date, v_prorate_flag, v_comp_sw, v_endt_expiry_date, v_short_rt_percent
     FROM gipi_wpolbas
    WHERE par_id = p_par_id;

   -- summarize amounts of all items for this record
   FOR a1 IN (SELECT SUM (NVL (tsi_amt, 0) * NVL (currency_rt, 1)) tsi,
                     SUM (NVL (prem_amt, 0) * NVL (currency_rt, 1)) prem,
                     COUNT (item_no) no_of_items
                FROM gipi_witem
               WHERE par_id = p_par_id)
   LOOP
      v_ann_tsi := v_ann_tsi + a1.tsi;
      v_tsi := v_tsi + a1.tsi;
      v_prem := v_prem + a1.prem;
      v_no_of_items := NVL (a1.no_of_items, 0);

      /** rollie 21feb2006
          disallows recomputation of prem if item_no was negated programmatically
      **/
      IF NVL (p_negate_item, 'N') = 'Y'
      THEN
         v_ann_prem := v_ann_prem + a1.prem;
      ELSE
         --Three conditions have to be considered for endt.
         -- 2 indicates that computation should be base on 1 year span
         IF v_prorate_flag = 2
         THEN
            v_ann_prem := v_ann_prem + a1.prem;
         -- 1 indicates that computation should be prorated
         ELSIF v_prorate_flag = 1
         THEN
            IF v_comp_sw = 'Y'
            THEN
               v_prorate :=
                    ((TRUNC (v_endt_expiry_date) - TRUNC (v_eff_date)) + 1
                    )
                  / (ADD_MONTHS (v_eff_date, 12) - v_eff_date);
            ELSIF v_comp_sw = 'M'
            THEN
               v_prorate :=
                    ((TRUNC (v_endt_expiry_date) - TRUNC (v_eff_date)) - 1
                    )
                  / (ADD_MONTHS (v_eff_date, 12) - v_eff_date);
            ELSE
               v_prorate :=
                    (TRUNC (v_endt_expiry_date) - TRUNC (v_eff_date))
                  / (ADD_MONTHS (v_eff_date, 12) - v_eff_date);
            END IF;

            --*modified by bdarusin, mar072003, to resolve ora01476 divisor is equal to zero
            IF TRUNC (v_eff_date) = TRUNC (v_endt_expiry_date)
            THEN
               v_prorate := 1;
            END IF;

            --msg_alert('ann prem '||A1.prem ||' '|| (v_prorate),'I',FALSE);
            v_ann_prem := v_ann_prem + (a1.prem / (v_prorate));
         -- 3 indicates that computation should be based with respect to the short rate percent.
         ELSE
            v_ann_prem :=
                  v_ann_prem
                  + (a1.prem / (NVL (v_short_rt_percent, 1) / 100));
         END IF;
      END IF;
   /* rollie 21feb2006 end of comment*/
   END LOOP;

   /*check if policy has an existing expired short term endorsement(s) */
   expired_sw := 'N';

   FOR sw IN (SELECT   '1'
                  FROM gipi_itmperil a, gipi_polbasic b
                 WHERE b.line_cd = v_line_cd
                   AND b.subline_cd = v_subline_cd
                   AND b.iss_cd = v_iss_cd
                   AND b.issue_yy = v_issue_yy
                   AND b.pol_seq_no = v_pol_seq_no
                   AND b.renew_no = v_renew_no
                   AND b.policy_id = a.policy_id
                   --AND b.pol_flag IN ('1', '2', '3') replaced by: Nica 06.04.2013
                   AND b.pol_flag IN ('1','2','3','X')
                   AND (a.prem_amt <> 0 OR a.tsi_amt <> 0)
                   AND TRUNC (b.eff_date) <= TRUNC (v_eff_date)
                   --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date) )< TRUNC(v_eff_date)
                   AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                      b.expiry_date, v_expiry_date,
                                      b.expiry_date, b.endt_expiry_date
                                     )
                             ) < TRUNC (v_eff_date)
              ORDER BY b.eff_date DESC)
   LOOP
      expired_sw := 'Y';
      EXIT;
   END LOOP;

   /*update amounts in gipi_wpolbas
   **for policy that have expired short term endorsement
   **recompute annualized amounts, for policy that does not have
   **expired short term endorsements just get the amounts from the
   **latest endorsements
   */
   -- there are no existing short-term endt.
   IF NVL (expired_sw, 'N') = 'N'
   THEN
      v_exist := 'N';

      -- query amounts from the latest endt
      FOR a2 IN (SELECT   b250.ann_tsi_amt ann_tsi,
                          b250.ann_prem_amt ann_prem
                     FROM gipi_wpolbas b, gipi_polbasic b250
                    WHERE b.par_id = p_par_id
                      AND b250.line_cd = b.line_cd
                      AND b250.subline_cd = b.subline_cd
                      AND b250.iss_cd = b.iss_cd
                      AND b250.issue_yy = b.issue_yy
                      AND b250.pol_seq_no = b.pol_seq_no
                      AND b250.renew_no = b.renew_no
                      --AND b250.pol_flag IN ('1', '2', '3') replaced by: Nica 06.04.2013
                      AND b250.pol_flag   IN ('1','2','3','X')
                      AND TRUNC (b250.eff_date) <= TRUNC (b.eff_date)
                      --AND TRUNC(NVL(b250.endt_expiry_date,b250.expiry_date)) >= TRUNC(b.eff_date)
                      AND (   TRUNC (DECODE (NVL (b250.endt_expiry_date,
                                                  b250.expiry_date
                                                 ),
                                             b250.expiry_date, v_expiry_date,
                                             b250.expiry_date, b250.endt_expiry_date
                                            )
                                    ) >= TRUNC (v_eff_date)
                           OR p_negate_item = 'Y'
                          )
                      AND NVL (b250.endt_seq_no, 0) > 0
                 ORDER BY b250.eff_date DESC)
      LOOP
         UPDATE gipi_wpolbas
            SET tsi_amt = NVL (v_tsi, 0),
                prem_amt = NVL (v_prem, 0),
                ann_tsi_amt = a2.ann_tsi + NVL (v_ann_tsi, 0),
                ann_prem_amt = a2.ann_prem + NVL (v_ann_prem, 0),
                no_of_items = NVL (v_no_of_items, 0)
          WHERE par_id = p_par_id;

         --msg_alert('v_tsi '||v_tsi||' v_prem '||v_prem||' v_ann_tsi '||v_ann_tsi||' v_ann_prem '||v_ann_prem,'I',FALSE);
         v_exist := 'Y';
         -- toggle switch that will indicate that amount is alredy retrieved
         EXIT;
      END LOOP;

      --for records with no endt. yet query it's amount from policy record
      IF v_exist = 'N'
      THEN
         FOR a2 IN (SELECT   b250.tsi_amt tsi, b250.prem_amt prem,
                             b250.ann_tsi_amt ann_tsi,
                             b250.ann_prem_amt ann_prem
                        FROM gipi_wpolbas b, gipi_polbasic b250
                       WHERE b.par_id = p_par_id
                         AND b250.line_cd = b.line_cd
                         AND b250.subline_cd = b.subline_cd
                         AND b250.iss_cd = b.iss_cd
                         AND b250.issue_yy = b.issue_yy
                         AND b250.pol_seq_no = b.pol_seq_no
                         AND b250.renew_no = b.renew_no
                         --AND b250.pol_flag IN ('1', '2', '3') replaced by: Nica 06.04.2013
                         AND b250.pol_flag   IN ('1','2','3','X')
                         AND NVL (b250.endt_seq_no, 0) = 0
                    ORDER BY b.eff_date DESC)
         LOOP
            UPDATE gipi_wpolbas
               SET tsi_amt = NVL (v_tsi, 0),
                   prem_amt = NVL (v_prem, 0),
                   ann_tsi_amt = a2.ann_tsi + NVL (v_ann_tsi, 0),
                   ann_prem_amt = a2.ann_prem + NVL (v_ann_prem, 0),
                   no_of_items = NVL (v_no_of_items, 0)
             WHERE par_id = p_par_id;

            EXIT;
         END LOOP;
      END IF;
   ELSE
      --for records with existing short term endt. amounts will be recomputed
      --by adding all amounts of policy and endt. that is not yet expired
      FOR a2 IN (SELECT   (c.tsi_amt * a.currency_rt) tsi,
                          (c.prem_amt * a.currency_rt) prem, b.eff_date,
                          b.endt_expiry_date, b.expiry_date, b.prorate_flag,
                          NVL (b.comp_sw, 'N') comp_sw,
                          b.short_rt_percent short_rt, c.peril_cd
                     FROM gipi_item a, gipi_polbasic b, gipi_itmperil c
                    WHERE b.line_cd = v_line_cd
                      AND b.subline_cd = v_subline_cd
                      AND b.iss_cd = v_iss_cd
                      AND b.issue_yy = v_issue_yy
                      AND b.pol_seq_no = v_pol_seq_no
                      AND b.renew_no = v_renew_no
                      AND b.policy_id = a.policy_id
                      AND b.policy_id = c.policy_id
                      AND a.item_no = c.item_no
                      --AND b.pol_flag IN ('1', '2', '3') replaced by: Nica 06.04.2013
                      AND b.pol_flag IN ('1', '2', '3', 'X')
                      AND TRUNC (b.eff_date) <=
                             DECODE (NVL (b.endt_seq_no, 0),
                                     0, TRUNC (b.eff_date),
                                     TRUNC (v_eff_date)
                                    )
                      --AND TRUNC(NVL(B.endt_expiry_date,B.expiry_date)) >= TRUNC(v_eff_date)
                      /*AND (   TRUNC (DECODE (NVL (b.endt_expiry_date,
                                                  b.expiry_date
                                                 ),
                                             b.expiry_date, v_expiry_date,
                                             b.expiry_date, b.endt_expiry_date
                                            )
                                    ) >= TRUNC (v_eff_date)
                           OR p_negate_item = 'Y'
                          )*/ -- replaced by: Nica 06.04.2013
                      AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date), b.expiry_date,
                          v_expiry_date, b.expiry_date,b.endt_expiry_date)) < TRUNC(v_eff_date)
                 ORDER BY b.eff_date DESC)
      LOOP
         v_comp_prem := 0;

         /** rollie 21feb2006
               disallows recomputation of prem if item_no was negated programmatically
           **/
         IF NVL (p_negate_item, 'N') = 'Y'
         THEN
            v_comp_prem := a2.prem;
         ELSE
            IF a2.prorate_flag = 1
            THEN
               IF a2.endt_expiry_date <= a2.eff_date
               THEN
                  raise_application_error
                     ('GENWEB',
                         'Your endorsement expiry date is equal to or less than your effectivity date.'
                      || ' Restricted condition.'
                     );
               ELSE
                  IF a2.comp_sw = 'Y'
                  THEN
                     v_prorate :=
                          (  (TRUNC (a2.endt_expiry_date)
                              - TRUNC (a2.eff_date)
                             )
                           + 1
                          )
                        / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                  ELSIF a2.comp_sw = 'M'
                  THEN
                     v_prorate :=
                          (  (TRUNC (a2.endt_expiry_date)
                              - TRUNC (a2.eff_date)
                             )
                           - 1
                          )
                        / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                  ELSE
                     v_prorate :=
                          (TRUNC (a2.endt_expiry_date) - TRUNC (a2.eff_date)
                          )
                        / (ADD_MONTHS (a2.eff_date, 12) - a2.eff_date);
                  END IF;
               END IF;

               /*modified by bdarusin, mar072003, to resolve ora01476 divisor is equal to zero*/
               IF TRUNC (v_eff_date) = TRUNC (v_endt_expiry_date)
               THEN
                  v_prorate := 1;
               END IF;

               v_comp_prem := a2.prem / v_prorate;
            ELSIF a2.prorate_flag = 2
            THEN
               v_comp_prem := a2.prem;
            ELSE
               v_comp_prem := a2.prem / (a2.short_rt / 100);
            END IF;
         END IF;

         v_ann_prem2 := v_ann_prem2 + v_comp_prem;

         FOR TYPE IN (SELECT peril_type
                        FROM giis_peril
                       WHERE line_cd = v_line_cd AND peril_cd = a2.peril_cd)
         LOOP
            IF TYPE.peril_type = 'B'
            THEN
               v_ann_tsi2 := v_ann_tsi2 + a2.tsi;
            END IF;
         END LOOP;
      END LOOP;

      UPDATE gipi_wpolbas
         SET tsi_amt = NVL (v_tsi, 0),
             prem_amt = NVL (v_prem, 0),
             ann_tsi_amt = NVL (v_ann_tsi, 0) + NVL (v_ann_tsi2, 0),
             ann_prem_amt = NVL (v_ann_prem, 0) + NVL (v_ann_prem2, 0),
             no_of_items = NVL (v_no_of_items, 0)
       WHERE par_id = p_par_id;
   --msg_alert('3','I',FALSE);
   END IF;
END;
/


