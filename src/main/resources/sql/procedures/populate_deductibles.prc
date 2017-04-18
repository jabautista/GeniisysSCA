CREATE OR REPLACE PROCEDURE CPI.POPULATE_DEDUCTIBLES(
    P_ITEM_NO          IN  NUMBER,
    p_old_pol_id       IN  gipi_pack_polbasic.pack_policy_id%TYPE,
    p_proc_summary_sw  IN  VARCHAR2,
    p_new_par_id       IN  gipi_pack_wpolwc.pack_par_id%TYPE,
    p_msg             OUT  VARCHAR2
)
IS
  v_ded_line_cd           gipi_deductibles.ded_line_cd%TYPE;
  v_ded_subline_cd        gipi_deductibles.ded_subline_cd%TYPE;
  v_ded_deductible_cd     gipi_deductibles.ded_deductible_cd%TYPE;
  v_deductible_text       gipi_deductibles.deductible_text%TYPE;
  v_deductible_amt        gipi_deductibles.deductible_amt%TYPE;
  v_deductible_rt         gipi_deductibles.deductible_rt%TYPE;
  v_peril_cd              gipi_deductibles.peril_cd%TYPE;
  v_policy_id             gipi_polbasic.policy_id%TYPE;
  v_endt_id               gipi_polbasic.policy_id%TYPE;
  --rg_id                   RECORDGROUP;
  rg_count                NUMBER;
  rg_count2               NUMBER;
  rg_name                 VARCHAR2(30) := 'GROUP_POLICY';
  rg_col                  VARCHAR2(50) := rg_name || '.policy_id';
  exist                   VARCHAR2(1) := 'N';
  v_row                   NUMBER;

  x_line_cd             gipi_polbasic.line_cd%TYPE;
  x_subline_cd          gipi_polbasic.subline_cd%TYPE;
  x_iss_cd              gipi_polbasic.iss_cd%TYPE;
  x_issue_yy            gipi_polbasic.issue_yy%TYPE;
  x_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE;
  x_renew_no            gipi_polbasic.renew_no%TYPE;

   --added by joanne 060314
   v_modified         VARCHAR2(1) := 'N';
   v_tsi_amt          giex_itmperil.tsi_amt%TYPE;
   v_itm_tsi_amt      giex_itmperil.tsi_amt%TYPE;
   v_perl_tsi_amt     giex_itmperil.tsi_amt%TYPE;
   v_ded_amt          giex_new_group_deductibles.deductible_amt%TYPE;
   v_cnt_deducs       NUMBER := 0;
   v_currency_rt      giex_itmperil.currency_rt%TYPE;
   v_round_off            giis_parameters.param_value_n%TYPE;
   v_apply_dep            VARCHAR2 (1);
   v_temp_currency_tsi    giex_old_group_peril.orig_tsi_amt%TYPE;
   v_temp_tsi             giex_old_group_peril.tsi_amt%TYPE;
   v_polded_exist         VARCHAR2 (1) := 'N'; --joanne 07.02.14
   --end
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-21-2011
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
  **  Description  : POPULATE_DEDUCTIBLES program unit
  */
     GET_POLICY_GROUP_RECORD(rg_name, p_old_pol_id, p_proc_summary_sw, x_line_cd, x_subline_cd, x_iss_cd, x_issue_yy, x_pol_seq_no, x_renew_no, p_msg);

     --added by joanne 06.03.14, determine if perils were modified in GIEXS007
     FOR x IN (SELECT 1
                  FROM giex_itmperil
                 WHERE policy_id = p_old_pol_id)
      LOOP
         v_modified := 'Y';
         EXIT;
      END LOOP;

     --added by joanne 06.03.14, get currency_rt
     FOR y IN (SELECT DISTINCT currency_rt
                  FROM giex_old_group_itmperil
                 WHERE policy_id = p_old_pol_id
                ORDER BY currency_rt DESC )
      LOOP
        v_currency_rt := y.currency_rt;
      END LOOP;

     IF v_modified = 'Y' THEN --Peril created in GIEXS007
        FOR rec IN (SELECT a.item_no, a.peril_cd, a.ded_deductible_cd, a.line_cd, a.subline_cd,
                           a.deductible_rt, a.deductible_amt, b.deductible_text
                      FROM giex_new_group_deductibles a, giis_deductible_desc b
                     WHERE policy_id = p_old_pol_id
                       AND a.line_cd = b.line_cd
                       AND a.subline_cd = b.subline_cd
                       AND a.ded_deductible_cd = b.deductible_cd
                       and a.item_no=p_item_no)
        LOOP
            v_deductible_amt :=  ROUND(rec.deductible_amt/v_currency_rt,2);

            INSERT INTO gipi_wdeductibles
                        (par_id, item_no, ded_line_cd, ded_subline_cd,
                         ded_deductible_cd, deductible_text, deductible_amt,
                         deductible_rt, peril_cd
                        )
                 VALUES (p_new_par_id, rec.item_no, rec.line_cd, rec.subline_cd,
                         rec.ded_deductible_cd, rec.deductible_text, v_deductible_amt,
                         rec.deductible_rt, rec.peril_cd
                        );
        END LOOP;

        --joanne 07.02.14, for policy level deductibles
        FOR rec IN (SELECT a.item_no, a.peril_cd, a.ded_deductible_cd, a.line_cd, a.subline_cd,
                           a.deductible_rt, a.deductible_amt, b.deductible_text
                      FROM giex_new_group_deductibles a, giis_deductible_desc b
                     WHERE policy_id = p_old_pol_id
                       AND a.line_cd = b.line_cd
                       AND a.subline_cd = b.subline_cd
                       AND a.ded_deductible_cd = b.deductible_cd
                       AND a.item_no=0
                       AND a.peril_cd=0)
        LOOP
            FOR dedrec IN (SELECT 1
                            FROM gipi_wdeductibles
                           WHERE   par_id = p_new_par_id
                           AND item_no = rec.item_no
                           AND peril_cd = rec.peril_cd
                           AND ded_deductible_cd = rec.ded_deductible_cd )
            LOOP
                v_polded_exist := 'Y';
            END LOOP;

            IF v_polded_exist = 'N' THEN
                v_deductible_amt :=  ROUND(rec.deductible_amt/v_currency_rt,2);

                INSERT INTO gipi_wdeductibles
                            (par_id, item_no, ded_line_cd, ded_subline_cd,
                             ded_deductible_cd, deductible_text, deductible_amt,
                             deductible_rt, peril_cd
                            )
                     VALUES (p_new_par_id, rec.item_no, rec.line_cd, rec.subline_cd,
                             rec.ded_deductible_cd, rec.deductible_text, v_deductible_amt,
                             rec.deductible_rt, rec.peril_cd
                            );
            END IF;

            v_polded_exist := 'N';
        END LOOP;
     ELSE --Peril NOT created in GIEXS007
       IF NVL(p_proc_summary_sw, 'Y') = 'N'  THEN
            -- get the round off parameter value
            BEGIN
              SELECT DECODE (param_value_n,
                             10, -1,
                             100, -2,
                             1000, -3,
                             10000, -4,
                             100000, -5,
                             1000000, -6,
                             9
                            )
                INTO v_round_off
                FROM giis_parameters
               WHERE param_name = 'ROUND_OFF_PLACE';
            EXCEPTION
              WHEN NO_DATA_FOUND
              THEN
                 v_round_off := 9;
            END;

            v_apply_dep := NVL (giisp.v ('AUTO_COMPUTE_MC_DEP'), 'N');
            v_temp_currency_tsi    := 0;
            v_temp_tsi             := 0;
            v_tsi_amt              := 0;
            v_itm_tsi_amt          := 0;
            v_perl_tsi_amt         := 0;

          ---POLICY LEVEL computation of deductible amount-----
            --get unsummarized depreciated tsi amount
            FOR pol_itmperil IN (SELECT a.tsi_amt, b.currency_rt,
                                        a.peril_cd, a.line_cd,
                                        a.item_no --benjo 11.23.2016 SR-5621
                                   FROM gipi_itmperil a, gipi_item b, giis_peril c
                                  WHERE a.policy_id = p_old_pol_id
                                    AND a.policy_id = b.policy_id
                                    AND a.item_no = b.item_no
                                    AND a.line_cd = c.line_cd
                                    AND a.peril_cd = c.peril_cd
                                    AND c.peril_type = 'B'
                               ORDER BY a.item_no, a.peril_cd)
            LOOP
                v_temp_currency_tsi := pol_itmperil.tsi_amt;
               /*IF v_apply_dep = 'Y' THEN
                  FOR a IN (SELECT NVL (rate, 0) rate
                              FROM giex_dep_perl
                             WHERE line_cd = pol_itmperil.line_cd
                               AND peril_cd = pol_itmperil.peril_cd)
                  LOOP
                    IF a.rate <> 0 THEN
                         v_temp_currency_tsi :=
                            ROUND ((  v_temp_currency_tsi
                                    - (  v_temp_currency_tsi
                                       * (a.rate / 100)
                                      )
                                   ),
                                   v_round_off
                                  );
                    END IF;
                  END LOOP;
               END IF;*/ --benjo 11.23.2016 SR-5621 comment out
               
               compute_depreciation_amounts (p_old_pol_id, pol_itmperil.item_no, pol_itmperil.line_cd, pol_itmperil.peril_cd, v_temp_currency_tsi); --benjo 11.23.2016 SR-5621
               
               v_temp_tsi := v_temp_currency_tsi * pol_itmperil.currency_rt;
               v_tsi_amt := v_tsi_amt + v_temp_tsi;
            END LOOP;

          --compute deductible amounts
          FOR pol IN (SELECT a.item_no item_no, a.peril_cd peril_cd,
                             a.ded_line_cd, a.ded_subline_cd,
                             a.ded_deductible_cd, b.deductible_rt,
                             b.deductible_amt, b.ded_type, b.min_amt,
                             b.max_amt, b.range_sw, a.deductible_text
                        FROM gipi_deductibles a,
                             giis_deductible_desc b
                       WHERE a.ded_line_cd = b.line_cd
                         AND a.ded_subline_cd = b.subline_cd
                         AND a.ded_deductible_cd = b.deductible_cd
                         AND a.policy_id = p_old_pol_id
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
               FROM gipi_wdeductibles
              WHERE par_id = p_new_par_id
                AND item_no = pol.item_no
                AND peril_cd = pol.peril_cd
                AND ded_deductible_cd = pol.ded_deductible_cd;

             IF v_cnt_deducs = 0 THEN
                v_deductible_amt :=  ROUND(v_deductible_amt/v_currency_rt,2);

                INSERT INTO gipi_wdeductibles
                            (par_id, item_no, ded_line_cd, ded_subline_cd,
                             ded_deductible_cd, deductible_text, deductible_amt,
                             deductible_rt, peril_cd
                            )
                     VALUES (p_new_par_id, pol.item_no, pol.ded_line_cd, pol.ded_subline_cd,
                             pol.ded_deductible_cd, pol.deductible_text, v_deductible_amt,
                             pol.deductible_rt, pol.peril_cd
                            );
             END IF;

             v_cnt_deducs := 0;
             v_deductible_amt := 0;
             v_ded_amt := 0;
          END LOOP;

          ------- ITEM LEVEL computation of deductible amount------------
          FOR item IN (SELECT DISTINCT a.item_no item_no
                           FROM gipi_itmperil a
                          WHERE a.policy_id = p_old_pol_id
                       ORDER BY a.item_no)
          LOOP
            v_itm_tsi_amt          := 0;
            --get unsummarized depreciated tsi amount per item
            FOR itm_itmperil IN (SELECT a.tsi_amt, b.currency_rt,
                                        a.peril_cd, a.line_cd, b.item_no
                                   FROM gipi_itmperil a, gipi_item b, giis_peril c
                                  WHERE a.policy_id = p_old_pol_id
                                    AND a.policy_id = b.policy_id
                                    AND a.item_no = b.item_no
                                    AND a.line_cd = c.line_cd
                                    AND a.peril_cd = c.peril_cd
                                    AND c.peril_type = 'B'
                               ORDER BY a.item_no, a.peril_cd)
            LOOP
                v_temp_currency_tsi := itm_itmperil.tsi_amt;
               /*IF v_apply_dep = 'Y' THEN
                  FOR a IN (SELECT NVL (rate, 0) rate
                              FROM giex_dep_perl
                             WHERE line_cd = itm_itmperil.line_cd
                               AND peril_cd = itm_itmperil.peril_cd)
                  LOOP
                    IF a.rate <> 0 THEN
                         v_temp_currency_tsi :=
                            ROUND ((  v_temp_currency_tsi
                                    - (  v_temp_currency_tsi
                                       * (a.rate / 100)
                                      )
                                   ),
                                   v_round_off
                                  );
                    END IF;
                  END LOOP;
               END IF;*/ --benjo 11.23.2016 SR-5621 comment out
               
               compute_depreciation_amounts (p_old_pol_id, itm_itmperil.item_no, itm_itmperil.line_cd, itm_itmperil.peril_cd, v_temp_currency_tsi); --benjo 11.23.2016 SR-5621

               v_temp_tsi := v_temp_currency_tsi * itm_itmperil.currency_rt;
               IF itm_itmperil.item_no = item.item_no THEN
                    v_itm_tsi_amt := v_itm_tsi_amt + v_temp_tsi;
               END IF;
            END LOOP;

            FOR deduc IN (SELECT  a.item_no, a.peril_cd,
                                  a.ded_line_cd, a.ded_subline_cd,
                                  a.ded_deductible_cd,
                                  b.deductible_rt, b.deductible_amt,
                                  b.ded_type, b.min_amt, b.max_amt,
                                  b.range_sw, a.deductible_text
                             FROM gipi_deductibles a,
                                  giis_deductible_desc b
                            WHERE a.ded_line_cd = b.line_cd
                              AND a.ded_subline_cd = b.subline_cd
                              AND a.ded_deductible_cd = b.deductible_cd
                              AND a.policy_id = p_old_pol_id --joanne 07.03.14
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
                   FROM gipi_wdeductibles
                  WHERE par_id = p_new_par_id
                    AND item_no = deduc.item_no
                    AND peril_cd = deduc.peril_cd
                    AND ded_deductible_cd = deduc.ded_deductible_cd;

              IF v_cnt_deducs = 0 THEN
                v_deductible_amt :=  ROUND(v_deductible_amt/v_currency_rt,2);

                INSERT INTO gipi_wdeductibles
                            (par_id, item_no, ded_line_cd, ded_subline_cd,
                             ded_deductible_cd, deductible_text, deductible_amt,
                             deductible_rt, peril_cd
                            )
                     VALUES (p_new_par_id, deduc.item_no, deduc.ded_line_cd, deduc.ded_subline_cd,
                             deduc.ded_deductible_cd, deduc.deductible_text, v_deductible_amt,
                             deduc.deductible_rt, deduc.peril_cd
                            );
              END IF;

                v_cnt_deducs := 0;
                v_deductible_amt := 0;
                v_ded_amt := 0;
             END LOOP;
          END LOOP;

          ----- PERIL LEVEL computation of deductibles------
            FOR perl IN (SELECT a.line_cd, a.item_no, a.peril_cd, a.tsi_amt
                           FROM gipi_itmperil a
                          WHERE a.policy_id = p_old_pol_id
                       ORDER BY a.item_no, a.peril_cd)
            LOOP
                v_temp_currency_tsi := perl.tsi_amt;

                /*IF v_apply_dep = 'Y' THEN
                  FOR a IN (SELECT NVL (rate, 0) rate
                              FROM giex_dep_perl
                             WHERE line_cd = perl.line_cd
                               AND peril_cd = perl.peril_cd)
                  LOOP
                    IF a.rate <> 0 THEN
                         v_temp_currency_tsi :=
                            ROUND ((  v_temp_currency_tsi
                                    - (  v_temp_currency_tsi
                                       * (a.rate / 100)
                                      )
                                   ),
                                   v_round_off
                                  );
                    END IF;
                  END LOOP;
                END IF;*/ --benjo 11.23.2016 SR-5621 comment out
                
                compute_depreciation_amounts (p_old_pol_id, perl.item_no, perl.line_cd, perl.peril_cd, v_temp_currency_tsi); --benjo 11.23.2016 SR-5621

                v_perl_tsi_amt := v_temp_currency_tsi * v_currency_rt;

                FOR deduct IN (SELECT a.item_no, a.ded_line_cd,
                                   a.ded_subline_cd,
                                   a.ded_deductible_cd,
                                   b.deductible_rt, b.deductible_amt,
                                   b.ded_type, b.min_amt, b.max_amt,
                                   b.range_sw, a.peril_cd, a.deductible_text
                              FROM gipi_deductibles a,
                                   giis_deductible_desc b
                             WHERE a.ded_line_cd = b.line_cd
                               AND a.ded_subline_cd = b.subline_cd
                               AND a.ded_deductible_cd = b.deductible_cd
                               AND a.policy_id = p_old_pol_id
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
                   FROM gipi_wdeductibles
                  WHERE par_id = p_new_par_id
                    AND item_no = deduct.item_no
                    AND peril_cd = deduct.peril_cd
                    AND ded_deductible_cd = deduct.ded_deductible_cd;

                    IF v_cnt_deducs = 0 THEN
                        v_deductible_amt :=  ROUND(v_deductible_amt/v_currency_rt,2);

                        INSERT INTO gipi_wdeductibles
                                    (par_id, item_no, ded_line_cd, ded_subline_cd,
                                     ded_deductible_cd, deductible_text, deductible_amt,
                                     deductible_rt, peril_cd
                                    )
                             VALUES (p_new_par_id, deduct.item_no, deduct.ded_line_cd, deduct.ded_subline_cd,
                                     deduct.ded_deductible_cd, deduct.deductible_text, v_deductible_amt,
                                     deduct.deductible_rt, deduct.peril_cd
                                    );
                    END IF;

                    v_cnt_deducs := 0;
                    v_deductible_amt := 0;
                    v_ded_amt := 0;
                END LOOP;
            END LOOP;
       ELSIF NVL(p_proc_summary_sw,'Y') = 'Y'  THEN
          SELECT SUM (ren_tsi_amt * currency_rt)
            INTO v_tsi_amt
            FROM giex_old_group_itmperil a,
                 giis_peril b
              WHERE a.policy_id = p_old_pol_id
               AND a.line_cd = b.line_cd
                AND a.peril_cd = b.peril_cd
                AND b.peril_type = 'B';

          ---POLICY LEVEL computation of deductible amount-----
          FOR pol IN (SELECT a.item_no item_no, a.peril_cd peril_cd,
                             a.ded_line_cd, a.ded_subline_cd,
                             a.ded_deductible_cd, b.deductible_rt,
                             b.deductible_amt, b.ded_type, b.min_amt,
                             b.max_amt, b.range_sw, a.deductible_text
                        FROM gipi_deductibles a,
                             giis_deductible_desc b
                       WHERE a.ded_line_cd = b.line_cd
                         AND a.ded_subline_cd = b.subline_cd
                         AND a.ded_deductible_cd = b.deductible_cd
                         AND a.policy_id IN (SELECT policy_id
                                                      FROM gipi_polbasic
                                                     WHERE line_cd = x_line_cd
                                                       AND subline_cd = x_subline_cd
                                                       AND iss_cd = x_iss_cd
                                                       AND issue_yy = x_issue_yy
                                                       AND pol_seq_no = x_pol_seq_no
                                                       AND renew_no = x_renew_no
                                                       AND pol_flag IN ('1', '2', '3'))
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
               FROM gipi_wdeductibles
              WHERE par_id = p_new_par_id
                AND item_no = pol.item_no
                AND peril_cd = pol.peril_cd
                AND ded_deductible_cd = pol.ded_deductible_cd;


             IF v_cnt_deducs = 0 THEN
                v_deductible_amt :=  ROUND(v_deductible_amt/v_currency_rt,2);

                INSERT INTO gipi_wdeductibles
                            (par_id, item_no, ded_line_cd, ded_subline_cd,
                             ded_deductible_cd, deductible_text, deductible_amt,
                             deductible_rt, peril_cd
                            )
                     VALUES (p_new_par_id, pol.item_no, pol.ded_line_cd, pol.ded_subline_cd,
                             pol.ded_deductible_cd, pol.deductible_text, v_deductible_amt,
                             pol.deductible_rt, pol.peril_cd
                            );
             END IF;

             v_cnt_deducs := 0;
             v_deductible_amt := 0;
             v_ded_amt := 0;
          END LOOP;

          ------- ITEM LEVEL computation of deductible amount------------
          FOR item IN (SELECT   a.item_no,
                                SUM (a.ren_tsi_amt * currency_rt) ren_tsi_amt
                           FROM giex_old_group_itmperil a,
                                giis_peril b
                          WHERE a.policy_id = p_old_pol_id
                            AND a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                            AND b.peril_type = 'B'
                       GROUP BY a.item_no
                       ORDER BY a.item_no)
          LOOP
             v_itm_tsi_amt := item.ren_tsi_amt;

             FOR deduc IN (SELECT a.item_no, a.peril_cd,
                                  a.ded_line_cd, a.ded_subline_cd,
                                  a.ded_deductible_cd,
                                  b.deductible_rt, b.deductible_amt,
                                  b.ded_type, b.min_amt, b.max_amt,
                                  b.range_sw, a.deductible_text
                             FROM gipi_deductibles a,
                                  giis_deductible_desc b
                            WHERE a.ded_line_cd = b.line_cd
                              AND a.ded_subline_cd = b.subline_cd
                              AND a.ded_deductible_cd = b.deductible_cd
                              AND a.policy_id IN (SELECT policy_id
                                                      FROM gipi_polbasic
                                                     WHERE line_cd = x_line_cd
                                                       AND subline_cd = x_subline_cd
                                                       AND iss_cd = x_iss_cd
                                                       AND issue_yy = x_issue_yy
                                                       AND pol_seq_no = x_pol_seq_no
                                                       AND renew_no = x_renew_no
                                                       AND pol_flag IN ('1', '2', '3'))
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
                   FROM gipi_wdeductibles
                  WHERE par_id = p_new_par_id
                    AND item_no = deduc.item_no
                    AND peril_cd = deduc.peril_cd
                    AND ded_deductible_cd = deduc.ded_deductible_cd;

              IF v_cnt_deducs = 0 THEN
                v_deductible_amt :=  ROUND(v_deductible_amt/v_currency_rt,2);

                INSERT INTO gipi_wdeductibles
                            (par_id, item_no, ded_line_cd, ded_subline_cd,
                             ded_deductible_cd, deductible_text, deductible_amt,
                             deductible_rt, peril_cd
                            )
                     VALUES (p_new_par_id, deduc.item_no, deduc.ded_line_cd, deduc.ded_subline_cd,
                             deduc.ded_deductible_cd, deduc.deductible_text, v_deductible_amt,
                             deduc.deductible_rt, deduc.peril_cd
                            );
              END IF;

                v_cnt_deducs := 0;
                v_deductible_amt := 0;
                v_ded_amt := 0;
             END LOOP;
          END LOOP;

          ----- PERIL LEVEL computation of deductibles------
         FOR perl IN (SELECT a.item_no, a.peril_cd,
                            (a.ren_tsi_amt * currency_rt) ren_tsi_amt
                           FROM giex_old_group_itmperil a
                          WHERE a.policy_id = p_old_pol_id
                       ORDER BY a.item_no, a.peril_cd)
          LOOP
             v_perl_tsi_amt := perl.ren_tsi_amt;

             FOR deduct IN (SELECT a.item_no, a.ded_line_cd,
                                   a.ded_subline_cd,
                                   a.ded_deductible_cd,
                                   b.deductible_rt, b.deductible_amt,
                                   b.ded_type, b.min_amt, b.max_amt,
                                   b.range_sw, a.peril_cd, a.deductible_text
                              FROM gipi_deductibles a,
                                   giis_deductible_desc b
                             WHERE a.ded_line_cd = b.line_cd
                               AND a.ded_subline_cd = b.subline_cd
                               AND a.ded_deductible_cd = b.deductible_cd
                               AND a.policy_id IN (SELECT policy_id
                                                      FROM gipi_polbasic
                                                     WHERE line_cd = x_line_cd
                                                       AND subline_cd = x_subline_cd
                                                       AND iss_cd = x_iss_cd
                                                       AND issue_yy = x_issue_yy
                                                       AND pol_seq_no = x_pol_seq_no
                                                       AND renew_no = x_renew_no
                                                       AND pol_flag IN ('1', '2', '3'))
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
                   FROM gipi_wdeductibles
                  WHERE par_id = p_new_par_id
                    AND item_no = deduct.item_no
                    AND peril_cd = deduct.peril_cd
                    AND ded_deductible_cd = deduct.ded_deductible_cd;

              IF v_cnt_deducs = 0 THEN
                v_deductible_amt :=  ROUND(v_deductible_amt/v_currency_rt,2);

                INSERT INTO gipi_wdeductibles
                            (par_id, item_no, ded_line_cd, ded_subline_cd,
                             ded_deductible_cd, deductible_text, deductible_amt,
                             deductible_rt, peril_cd
                            )
                     VALUES (p_new_par_id, deduct.item_no, deduct.ded_line_cd, deduct.ded_subline_cd,
                             deduct.ded_deductible_cd, deduct.deductible_text, v_deductible_amt,
                             deduct.deductible_rt, deduct.peril_cd
                            );
               END IF;

                v_cnt_deducs := 0;
                v_deductible_amt := 0;
                v_ded_amt := 0;
             END LOOP;
          END LOOP;
       END IF;
     END IF;
     /*Comment by joanne 06.04.2014, replace by code above
     IF NVL(p_proc_summary_sw,'N') = 'N'  THEN
        FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                   FROM gipi_polbasic
                  WHERE line_cd     =  x_line_cd
                    AND subline_cd  =  x_subline_cd
                    AND iss_cd      =  x_iss_cd
                    AND issue_yy    =  to_char(x_issue_yy)
                    AND pol_seq_no  =  to_char(x_pol_seq_no)
                    AND renew_no    =  to_char(x_renew_no)
                    AND (endt_seq_no = 0 OR
                        (endt_seq_no > 0 AND
                        TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                    AND pol_flag In ('1','2','3')
                    AND NVL(endt_seq_no,0) = 0
                  ORDER BY eff_date, endt_seq_no)
         LOOP
            v_policy_id  := b.policy_id;
              FOR data  IN
                  ( SELECT ded_line_cd,     ded_subline_cd,     ded_deductible_cd,
                           deductible_text, deductible_amt,     deductible_rt,
                           peril_cd
                      FROM gipi_deductibles
                     WHERE policy_id = v_policy_id
                       AND item_no   = p_item_no
                 ) LOOP
                 exist := 'N';
                 FOR CHK IN
                     ( SELECT '1'
                         FROM gipi_wdeductibles
                        WHERE ded_deductible_cd  = data.ded_deductible_cd
                          AND item_no = p_item_no
                          AND par_id  = p_new_par_id
                          AND peril_cd = data.peril_cd -- joanne 113013, consolidate to cs added condition to ensure peril_level deductible is reached in checking if it exists
                      ) LOOP
                      exist := 'Y';
                      EXIT;
                 END LOOP;
                  IF exist = 'N' THEN
                       v_ded_line_cd          := data.ded_line_cd;
                       v_ded_subline_cd       := data.ded_subline_cd;
                       v_ded_deductible_cd    := data.ded_deductible_cd;
                       v_deductible_text      := data.deductible_text;
                       v_deductible_amt       := NVL(data.deductible_amt,0);
                       v_deductible_rt        := NVL(data.deductible_rt,0);
                       v_peril_cd             := data.peril_cd;
                       FOR b1 IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                                   FROM gipi_polbasic
                                  WHERE line_cd     =  x_line_cd
                                    AND subline_cd  =  x_subline_cd
                                    AND iss_cd      =  x_iss_cd
                                    AND issue_yy    =  to_char(x_issue_yy)
                                    AND pol_seq_no  =  to_char(x_pol_seq_no)
                                    AND renew_no    =  to_char(x_renew_no)
                                    AND (endt_seq_no = 0 OR
                                        (endt_seq_no > 0 AND
                                        TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                                    AND pol_flag In ('1','2','3')
                                    AND NVL(endt_seq_no,0) = 0
                                  ORDER BY eff_date, endt_seq_no)
                         LOOP
                            v_endt_id   := b1.policy_id;
                             IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN
                                    ( SELECT ded_line_cd,     ded_subline_cd,
                                        deductible_text, deductible_amt,
                                        deductible_rt,   peril_cd
                                   FROM gipi_deductibles
                                  WHERE ded_deductible_cd =  v_ded_deductible_cd
                                    AND item_no = p_item_no
                                    AND policy_id = v_endt_id
                                    AND peril_cd = v_peril_cd -- joanne 113013
                               ) LOOP
                                  v_ded_line_cd          := NVL(data2.ded_line_cd, v_ded_line_cd);
                                  v_ded_subline_cd       := NVL(data2.ded_subline_cd, v_ded_subline_cd);
                                  v_deductible_text      := NVL(data2.deductible_text, v_deductible_text);
                                  v_deductible_amt       := NVL(data2.deductible_amt,0) + v_deductible_amt;
                                  v_deductible_rt        := NVL(data2.deductible_rt, v_deductible_rt);
                                  v_peril_cd             := NVL(data2.peril_cd, v_peril_cd);
                               END LOOP;
                            END IF;
                         END LOOP;
                    --CLEAR_MESSAGE;
                    --MESSAGE('Copying deductibles ...',NO_ACKNOWLEDGE);
                    --SYNCHRONIZE;
                    INSERT INTO gipi_wdeductibles (
                                par_id,               item_no,          ded_line_cd,       ded_subline_cd,
                                ded_deductible_cd,    deductible_text,  deductible_amt,    deductible_rt,
                                peril_cd)
                        VALUES(p_new_par_id,         p_item_no,        v_ded_line_cd,     v_ded_subline_cd,
                                v_ded_deductible_cd,  v_deductible_text, v_deductible_amt, v_deductible_rt, v_peril_cd);
                    v_ded_line_cd          := NULL;
                       v_ded_subline_cd       := NULL;
                       v_ded_deductible_cd    := NULL;
                       v_deductible_text      := NULL;
                       v_deductible_amt       := NULL;
                       v_deductible_rt        := NULL;
                       v_peril_cd             := NULL;
                 END IF;
              END LOOP;
         END LOOP;
     ELSIF NVL(p_proc_summary_sw,'N') = 'Y'  THEN
        FOR b IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                   FROM gipi_polbasic
                  WHERE line_cd     =  x_line_cd
                    AND subline_cd  =  x_subline_cd
                    AND iss_cd      =  x_iss_cd
                    AND issue_yy    =  to_char(x_issue_yy)
                    AND pol_seq_no  =  to_char(x_pol_seq_no)
                    AND renew_no    =  to_char(x_renew_no)
                    AND (endt_seq_no = 0 OR
                        (endt_seq_no > 0 AND
                        TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                    AND pol_flag In ('1','2','3')
                  ORDER BY eff_date, endt_seq_no)
         LOOP
            v_policy_id  := b.policy_id;
              FOR data  IN
                  ( SELECT ded_line_cd,     ded_subline_cd,     ded_deductible_cd,
                           deductible_text, deductible_amt,     deductible_rt,
                           peril_cd
                      FROM gipi_deductibles
                     WHERE policy_id = v_policy_id
                       AND item_no   = p_item_no
                 ) LOOP
                 exist := 'N';
                 FOR CHK IN
                     ( SELECT '1'
                         FROM gipi_wdeductibles
                        WHERE ded_deductible_cd  = data.ded_deductible_cd
                          AND item_no = p_item_no
                          AND par_id  = p_new_par_id
                          AND peril_cd = data.peril_cd -- joanne 113013, consolidate to cs added condition to ensure peril_level deductible is reached in checking if it exists
                      ) LOOP
                      exist := 'Y';
                      EXIT;
                 END LOOP;
                  IF exist = 'N' THEN
                       v_ded_line_cd          := data.ded_line_cd;
                       v_ded_subline_cd       := data.ded_subline_cd;
                       v_ded_deductible_cd    := data.ded_deductible_cd;
                       v_deductible_text      := data.deductible_text;
                       v_deductible_amt       := NVL(data.deductible_amt,0);
                       v_deductible_rt        := NVL(data.deductible_rt,0);
                       v_peril_cd             := data.peril_cd;
                       FOR b1 IN(SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                                   FROM gipi_polbasic
                                  WHERE line_cd     =  x_line_cd
                                    AND subline_cd  =  x_subline_cd
                                    AND iss_cd      =  x_iss_cd
                                    AND issue_yy    =  to_char(x_issue_yy)
                                    AND pol_seq_no  =  to_char(x_pol_seq_no)
                                    AND renew_no    =  to_char(x_renew_no)
                                    AND (endt_seq_no = 0 OR
                                        (endt_seq_no > 0 AND
                                        TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                                    AND pol_flag In ('1','2','3')
                                  ORDER BY eff_date, endt_seq_no)
                         LOOP
                            v_endt_id   := b1.policy_id;
                             IF v_endt_id <> v_policy_id THEN
                                FOR DATA2 IN
                                    ( SELECT ded_line_cd,     ded_subline_cd,
                                        deductible_text, deductible_amt,
                                        deductible_rt,   peril_cd
                                   FROM gipi_deductibles
                                  WHERE ded_deductible_cd =  v_ded_deductible_cd
                                    AND item_no = p_item_no
                                    AND policy_id = v_endt_id
                                    AND peril_cd = v_peril_cd -- joanne 113013
                               ) LOOP
                                  v_ded_line_cd          := NVL(data2.ded_line_cd, v_ded_line_cd);
                                  v_ded_subline_cd       := NVL(data2.ded_subline_cd, v_ded_subline_cd);
                                  v_deductible_text      := NVL(data2.deductible_text, v_deductible_text);
                                  v_deductible_amt       := NVL(data2.deductible_amt,0) + v_deductible_amt;
                                  v_deductible_rt        := NVL(data2.deductible_rt, v_deductible_rt);
                                  v_peril_cd             := NVL(data2.peril_cd, v_peril_cd);
                               END LOOP;
                            END IF;
                         END LOOP;
                    --CLEAR_MESSAGE;
                    --MESSAGE('Copying deductibles ...',NO_ACKNOWLEDGE);
                    --SYNCHRONIZE;
                    INSERT INTO gipi_wdeductibles (
                                par_id,               item_no,          ded_line_cd,       ded_subline_cd,
                                ded_deductible_cd,    deductible_text,  deductible_amt,    deductible_rt,
                                peril_cd)
                        VALUES(p_new_par_id,         p_item_no,        v_ded_line_cd,     v_ded_subline_cd,
                                v_ded_deductible_cd,  v_deductible_text, v_deductible_amt, v_deductible_rt, v_peril_cd);
                    v_ded_line_cd          := NULL;
                       v_ded_subline_cd       := NULL;
                       v_ded_deductible_cd    := NULL;
                       v_deductible_text      := NULL;
                       v_deductible_amt       := NULL;
                       v_deductible_rt        := NULL;
                       v_peril_cd             := NULL;
                 END IF;
              END LOOP;
         END LOOP;
       END IF;*/
END;
/


