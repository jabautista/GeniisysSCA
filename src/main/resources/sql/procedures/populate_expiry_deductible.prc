DROP PROCEDURE CPI.POPULATE_EXPIRY_DEDUCTIBLE;

CREATE OR REPLACE PROCEDURE CPI.populate_expiry_deductible (
   p_policy_id   giex_expiry.policy_id%TYPE,
   p_summary_sw  giex_expiry.summary_sw%TYPE
)
IS
/* Created by: Jhing Factor
** Created on : 05.07.2013
** Purpose  : to insert records in giex_new_group_deductible when perils are recreated in giexs007
*/

/* Modified by: Jongs
** Date: 08072013
** Purpose: to consider summary switch upon extraction of deductibles: 'Y' = endorsements considered; 'N' = original policy details only
*/

/* Modified by: Joanne
** Date: 05292014
** Purpose: to recompute deductibles base on depreciated unsummarized TSI_AMT when summary switch = 'N'
*/
   v_exists   VARCHAR2 (1) := 'N';
   --added by joanne 05292014
   v_tsi_amt          giex_itmperil.tsi_amt%TYPE;
   v_itm_tsi_amt      giex_itmperil.tsi_amt%TYPE;
   v_perl_tsi_amt     giex_itmperil.tsi_amt%TYPE;
   v_ded_amt          giex_new_group_deductibles.deductible_amt%TYPE;
   v_deductible_amt   giex_new_group_deductibles.deductible_amt%TYPE;
   v_cnt_deducs       NUMBER := 0;
   --end
BEGIN

   DELETE FROM giex_new_group_deductibles
    WHERE policy_id = p_policy_id;

   IF NVL (giisp.v ('INCLUDE_DEDUCTIBLE_EXPIRY'), 'N') = 'Y'
   THEN
      FOR x IN (SELECT 1
                  FROM giex_new_group_deductibles
                 WHERE policy_id = p_policy_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'N'
      THEN
        IF p_summary_sw = 'Y' THEN  --endorsements included(net amounts)
          FOR rec IN (SELECT policy_id, item_no, peril_cd, ded_deductible_cd,
                             line_cd, subline_cd, deductible_rt,
                             deductible_amt
                        FROM giex_old_group_deductibles
                       WHERE policy_id = p_policy_id)
          LOOP
            INSERT INTO giex_new_group_deductibles
                        (policy_id, item_no, peril_cd,
                         ded_deductible_cd, line_cd, subline_cd,
                         deductible_rt, deductible_amt
                        )
                 VALUES (rec.policy_id, rec.item_no, rec.peril_cd,
                         rec.ded_deductible_cd, rec.line_cd, rec.subline_cd,
                         rec.deductible_rt, rec.deductible_amt
                        );
          END LOOP;

        ELSE  -- original policy
          /*FOR rec2 IN (SELECT policy_id, item_no, peril_cd, ded_deductible_cd,
                             ded_line_cd, ded_subline_cd, deductible_rt,
                             deductible_amt
                        FROM gipi_deductibles
                       WHERE policy_id = p_policy_id)
          LOOP


            INSERT INTO giex_new_group_deductibles
                        (policy_id, item_no, peril_cd,
                         ded_deductible_cd, line_cd, subline_cd,
                         deductible_rt, deductible_amt
                        )
                 VALUES (rec2.policy_id, rec2.item_no, rec2.peril_cd,
                         rec2.ded_deductible_cd, rec2.ded_line_cd, rec2.ded_subline_cd,
                         rec2.deductible_rt, rec2.deductible_amt
                        );
          END LOOP;   */
          --comment out by joanne 05292014, replace by code below
          SELECT SUM (tsi_amt * currency_rt)
            INTO v_tsi_amt
            FROM giex_itmperil a,
                 giis_peril b
              WHERE a.policy_id = p_policy_id
               AND a.line_cd = b.line_cd
                AND a.peril_cd = b.peril_cd
                AND b.peril_type = 'B';

          ---POLICY LEVEL computation of deductible amount-----
          FOR pol IN (SELECT a.item_no item_no, a.peril_cd peril_cd,
                             a.ded_line_cd, a.ded_subline_cd,
                             a.ded_deductible_cd, b.deductible_rt,
                             b.deductible_amt, b.ded_type, b.min_amt,
                             b.max_amt, b.range_sw
                        FROM gipi_deductibles a,
                             giis_deductible_desc b
                       WHERE a.ded_line_cd = b.line_cd
                         AND a.ded_subline_cd = b.subline_cd
                         AND a.ded_deductible_cd = b.deductible_cd
                         AND a.policy_id = p_policy_id
                         AND a.item_no = 0
                         AND a.peril_cd = 0)
          LOOP
            IF pol.ded_type = 'F'
             THEN
                v_deductible_amt := pol.deductible_amt;
             ELSIF pol.ded_type = 'T'
             THEN
                v_ded_amt :=
                        v_tsi_amt
                        * (NVL (pol.deductible_rt, 0) / 100);

                IF     pol.deductible_rt IS NOT NULL
                   AND pol.min_amt IS NOT NULL
                   AND pol.max_amt IS NOT NULL
                THEN
                   IF pol.range_sw = 'H'
                   THEN
                      v_ded_amt := GREATEST (v_ded_amt, pol.min_amt);
                      v_deductible_amt :=
                                       LEAST (v_ded_amt, pol.max_amt);
                   ELSIF pol.range_sw = 'L'
                   THEN
                      v_ded_amt := LEAST (v_ded_amt, pol.min_amt);
                      v_deductible_amt :=
                                       LEAST (v_ded_amt, pol.max_amt);
                   ELSE
                      v_deductible_amt := pol.max_amt;
                   END IF;
                ELSIF     pol.deductible_rt IS NOT NULL
                      AND pol.min_amt IS NOT NULL
                THEN
                   v_deductible_amt :=
                                    GREATEST (v_ded_amt, pol.min_amt);
                ELSIF     pol.deductible_rt IS NOT NULL
                      AND pol.max_amt IS NOT NULL
                THEN
                   v_deductible_amt := LEAST (v_ded_amt, pol.max_amt);
                ELSE
                   IF pol.deductible_rt IS NOT NULL
                   THEN
                      v_deductible_amt := v_ded_amt;
                   ELSIF pol.min_amt IS NOT NULL
                   THEN
                      v_deductible_amt := pol.min_amt;
                   ELSIF pol.max_amt IS NOT NULL
                   THEN
                      v_deductible_amt := pol.max_amt;
                   END IF;
                END IF;
             END IF;

             SELECT COUNT(*)
               INTO v_cnt_deducs
               FROM giex_new_group_deductibles
              WHERE policy_id = p_policy_id
                AND item_no = pol.item_no
                AND peril_cd = pol.peril_cd
                AND ded_deductible_cd = pol.ded_deductible_cd;

             IF v_cnt_deducs = 0 THEN

             INSERT INTO giex_new_group_deductibles
                         (policy_id, item_no, peril_cd,
                          ded_deductible_cd, line_cd,
                          subline_cd, deductible_rt,
                          deductible_amt
                         )
                  VALUES (p_policy_id, pol.item_no, pol.peril_cd,
                          pol.ded_deductible_cd, pol.ded_line_cd,
                          pol.ded_subline_cd, pol.deductible_rt,
                          v_deductible_amt
                         );
             END IF;

             v_cnt_deducs := 0;
             v_deductible_amt := 0;
             v_ded_amt := 0;
          END LOOP;

          ------- ITEM LEVEL computation of deductible amount------------
          FOR item IN (SELECT   a.item_no,
                                SUM (a.tsi_amt * currency_rt) tsi_amt
                           FROM giex_itmperil a,
                                giis_peril b
                          WHERE a.policy_id = p_policy_id
                            AND a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                            AND b.peril_type = 'B'
                       GROUP BY a.item_no
                       ORDER BY a.item_no)
          LOOP
             v_itm_tsi_amt := item.tsi_amt;

             FOR deduc IN (SELECT a.item_no, a.peril_cd,
                                  a.ded_line_cd, a.ded_subline_cd,
                                  a.ded_deductible_cd,
                                  b.deductible_rt, b.deductible_amt,
                                  b.ded_type, b.min_amt, b.max_amt,
                                  b.range_sw
                             FROM gipi_deductibles a,
                                  giis_deductible_desc b
                            WHERE a.ded_line_cd = b.line_cd
                              AND a.ded_subline_cd = b.subline_cd
                              AND a.ded_deductible_cd = b.deductible_cd
                              AND a.policy_id = p_policy_id
                              AND a.item_no = item.item_no
                              AND a.peril_cd = 0)
             LOOP
                v_ded_amt :=
                     v_itm_tsi_amt
                   * (NVL (deduc.deductible_rt, 0) / 100);

                IF deduc.ded_type = 'F'
                THEN
                   v_deductible_amt := deduc.deductible_amt;
                ELSIF deduc.ded_type = 'T'
                THEN
                   IF     deduc.deductible_rt IS NOT NULL
                      AND deduc.min_amt IS NOT NULL
                      AND deduc.max_amt IS NOT NULL
                   THEN
                      IF deduc.range_sw = 'H'
                      THEN
                         v_ded_amt :=
                                  GREATEST (v_ded_amt, deduc.min_amt);
                         v_deductible_amt :=
                                     LEAST (v_ded_amt, deduc.max_amt);
                      ELSIF deduc.range_sw = 'L'
                      THEN
                         v_ded_amt :=
                                     LEAST (v_ded_amt, deduc.min_amt);
                         v_deductible_amt :=
                                     LEAST (v_ded_amt, deduc.max_amt);
                      ELSE
                         v_deductible_amt := deduc.max_amt;
                      END IF;
                   ELSIF     deduc.deductible_rt IS NOT NULL
                         AND deduc.min_amt IS NOT NULL
                   THEN
                      v_deductible_amt :=
                                  GREATEST (v_ded_amt, deduc.min_amt);
                   ELSIF     deduc.deductible_rt IS NOT NULL
                         AND deduc.max_amt IS NOT NULL
                   THEN
                      v_deductible_amt :=
                                     LEAST (v_ded_amt, deduc.max_amt);
                   ELSE
                      IF deduc.deductible_rt IS NOT NULL
                      THEN
                         v_deductible_amt := v_ded_amt;
                      ELSIF deduc.min_amt IS NOT NULL
                      THEN
                         v_deductible_amt := deduc.min_amt;
                      ELSIF deduc.max_amt IS NOT NULL
                      THEN
                         v_deductible_amt := deduc.max_amt;
                      END IF;
                   END IF;
                ELSIF deduc.ded_type = 'L'
                THEN
                   v_deductible_amt := NULL;
                ELSIF deduc.ded_type = 'I'
                THEN
                   v_deductible_amt := NULL;
                END IF;

                 SELECT COUNT(*)
                   INTO v_cnt_deducs
                   FROM giex_new_group_deductibles
                  WHERE policy_id = p_policy_id
                    AND item_no = deduc.item_no
                    AND peril_cd = deduc.peril_cd
                    AND ded_deductible_cd = deduc.ded_deductible_cd;

              IF v_cnt_deducs = 0 THEN

                INSERT INTO giex_new_group_deductibles
                            (policy_id, item_no,
                             peril_cd, ded_deductible_cd,
                             line_cd, subline_cd,
                             deductible_rt, deductible_amt
                            )
                     VALUES (p_policy_id, deduc.item_no,
                             deduc.peril_cd, deduc.ded_deductible_cd,
                             deduc.ded_line_cd, deduc.ded_subline_cd,
                             deduc.deductible_rt, v_deductible_amt
                            );
               END IF;

                v_cnt_deducs := 0;
                v_deductible_amt := 0;
                v_ded_amt := 0;
             END LOOP;
          END LOOP;

          ----- PERIL LEVEL computation of deductibles------
          FOR perl IN (SELECT   a.item_no, a.peril_cd,
                                (a.tsi_amt * currency_rt) tsi_amt
                           FROM giex_itmperil a
                          WHERE a.policy_id = p_policy_id
                       ORDER BY a.item_no, a.peril_cd)
          LOOP
             v_perl_tsi_amt := perl.tsi_amt;

             FOR deduct IN (SELECT a.item_no, a.ded_line_cd,
                                   a.ded_subline_cd,
                                   a.ded_deductible_cd,
                                   b.deductible_rt, b.deductible_amt,
                                   b.ded_type, b.min_amt, b.max_amt,
                                   b.range_sw, a.peril_cd
                              FROM gipi_deductibles a,
                                   giis_deductible_desc b
                             WHERE a.ded_line_cd = b.line_cd
                               AND a.ded_subline_cd = b.subline_cd
                               AND a.ded_deductible_cd = b.deductible_cd
                                AND a.policy_id = p_policy_id
                               AND a.item_no = perl.item_no
                               AND a.peril_cd = perl.peril_cd)
             LOOP
               IF deduct.ded_type = 'F'
                THEN
                   v_deductible_amt := deduct.deductible_amt;
                ELSIF deduct.ded_type = 'T'
                THEN
                   v_ded_amt :=
                        v_perl_tsi_amt
                      * (NVL (deduct.deductible_rt, 0) / 100);

                   IF     deduct.deductible_rt IS NOT NULL
                      AND deduct.min_amt IS NOT NULL
                      AND deduct.max_amt IS NOT NULL
                   THEN
                      IF deduct.range_sw = 'H'
                      THEN
                         v_ded_amt :=
                                 GREATEST (v_ded_amt, deduct.min_amt);
                         v_deductible_amt :=
                                    LEAST (v_ded_amt, deduct.max_amt);
                      ELSIF deduct.range_sw = 'L'
                      THEN
                         v_ded_amt :=
                                    LEAST (v_ded_amt, deduct.min_amt);
                         v_deductible_amt :=
                                    LEAST (v_ded_amt, deduct.max_amt);
                      ELSE
                         v_deductible_amt := deduct.max_amt;
                      END IF;
                   ELSIF     deduct.deductible_rt IS NOT NULL
                         AND deduct.min_amt IS NOT NULL
                   THEN
                      v_deductible_amt :=
                                 GREATEST (v_ded_amt, deduct.min_amt);
                   ELSIF     deduct.deductible_rt IS NOT NULL
                         AND deduct.max_amt IS NOT NULL
                   THEN
                      v_deductible_amt :=
                                    LEAST (v_ded_amt, deduct.max_amt);
                   ELSE
                      IF deduct.deductible_rt IS NOT NULL
                      THEN
                         v_deductible_amt := v_ded_amt;
                      ELSIF deduct.min_amt IS NOT NULL
                      THEN
                         v_deductible_amt := deduct.min_amt;
                      ELSIF deduct.max_amt IS NOT NULL
                      THEN
                         v_deductible_amt := deduct.max_amt;
                      END IF;
                   END IF;
                ELSIF deduct.ded_type = 'L'
                THEN
                   v_deductible_amt := NULL;
                ELSIF deduct.ded_type = 'I'
                THEN
                   v_deductible_amt := NULL;
                END IF;

                 SELECT COUNT(*)
                   INTO v_cnt_deducs
                   FROM giex_new_group_deductibles
                  WHERE policy_id = p_policy_id
                    AND item_no = deduct.item_no
                    AND peril_cd = deduct.peril_cd
                    AND ded_deductible_cd = deduct.ded_deductible_cd;

              IF v_cnt_deducs = 0 THEN

                INSERT INTO giex_new_group_deductibles
                            (policy_id, item_no,
                             peril_cd,
                             ded_deductible_cd,
                             line_cd,
                             subline_cd,
                             deductible_rt, deductible_amt
                            )
                     VALUES (p_policy_id, deduct.item_no,
                             deduct.peril_cd,
                             deduct.ded_deductible_cd,
                             deduct.ded_line_cd,
                             deduct.ded_subline_cd,
                             deduct.deductible_rt, v_deductible_amt
                            );
               END IF;

                v_cnt_deducs := 0;
                v_deductible_amt := 0;
                v_ded_amt := 0;
             END LOOP;
          END LOOP;
        END IF;
      END IF;
   END IF;
END;
/


