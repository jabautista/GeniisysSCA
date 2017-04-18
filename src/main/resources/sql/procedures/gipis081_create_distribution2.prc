DROP PROCEDURE CPI.GIPIS081_CREATE_DISTRIBUTION2;

CREATE OR REPLACE PROCEDURE CPI.gipis081_create_distribution2 (
   p_par_id    IN   NUMBER)
IS
   TYPE number_varray IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   vv_tsi_amt       number_varray;
   vv_ann_tsi_amt   number_varray;
   vv_prem_amt      number_varray;
   vv_item_grp      number_varray;
   varray_cnt       NUMBER                            := 0;
   b_exist          NUMBER;
   p_exist          NUMBER;
   pi_dist_no       giuw_pol_dist.dist_no%TYPE;
   p_frps_yy        giri_wdistfrps.frps_yy%TYPE;
   p_frps_seq_no    giri_wdistfrps.frps_seq_no%TYPE;
   p2_dist_no       giuw_pol_dist.dist_no%TYPE;
   p_eff_date       gipi_polbasic.eff_date%TYPE;
   p_expiry_date    gipi_polbasic.expiry_date%TYPE;
   p_endt_type      gipi_polbasic.endt_type%TYPE;
   p_policy_id      gipi_polbasic.policy_id%TYPE;
   p_tsi_amt        gipi_witem.tsi_amt%TYPE;
   p_ann_tsi_amt    gipi_witem.ann_tsi_amt%TYPE;
   p_prem_amt       gipi_witem.prem_amt%TYPE;
   v_tsi_amt        gipi_witem.tsi_amt%TYPE           := 0;
   v_ann_tsi_amt    gipi_witem.ann_tsi_amt%TYPE       := 0;
   v_prem_amt       gipi_witem.prem_amt%TYPE          := 0;
   x_but            NUMBER;
   dist_cnt         NUMBER                            := 0;
   dist_max         giuw_pol_dist.dist_no%TYPE;
   dist_min         giuw_pol_dist.dist_no%TYPE;
   dist_exist       VARCHAR2 (1);
   p_message        VARCHAR2 (200)                    := '0';

   CURSOR c1
   IS
      SELECT DISTINCT frps_yy, frps_seq_no
                 FROM giri_wdistfrps
                WHERE dist_no = pi_dist_no;

   CURSOR c2
   IS
      SELECT DISTINCT frps_yy, frps_seq_no
                 FROM giri_distfrps
                WHERE dist_no = pi_dist_no;
/*main*/
BEGIN
   BEGIN
      BEGIN                                                             
         FOR array_loop IN (SELECT   SUM (tsi_amt * currency_rt) tsi_amt,
                                     SUM (ann_tsi_amt * currency_rt
                                         ) ann_tsi_amt,
                                     SUM (prem_amt * currency_rt) prem_amt,
                                     item_grp
                                FROM gipi_witem
                               WHERE par_id = p_par_id
                            GROUP BY item_grp)
         LOOP
            varray_cnt := varray_cnt + 1;
            vv_tsi_amt (varray_cnt) := array_loop.tsi_amt;
            vv_ann_tsi_amt (varray_cnt) := array_loop.ann_tsi_amt;
            vv_prem_amt (varray_cnt) := array_loop.prem_amt;
            vv_item_grp (varray_cnt) := array_loop.item_grp;
         END LOOP;

         IF varray_cnt = 0
         THEN
            /*msg_alert ('Pls. be adviced that there are no items for this PAR.',
                       'E',
                       TRUE
                      );*/
            p_message := '1';
			RETURN;
         END IF;
      END;                                                               --1--

      FOR x IN (SELECT dist_no
                  FROM giuw_pol_dist
                 WHERE par_id = p_par_id)
      LOOP
         pi_dist_no := x.dist_no;
         dist_exist := 'Y';

         BEGIN                                                          --2--
            SELECT DISTINCT 1
                       INTO b_exist
                       FROM giuw_policyds
                      WHERE dist_no = pi_dist_no;

            IF SQL%FOUND
            THEN
               /*alert_id2 := FIND_ALERT ('REC_EXISTS_IN_POST_POL_TAB');
               alert_but2 := SHOW_ALERT (alert_id2);*/
               p_message := '2';
                  --'This PAR has existing records in the posted POLICY tables.  Changes will be made.  Would you like to continue?';
            /*IF alert_but2 = alert_button1
               THEN
                  --x_but := 1;*/
                  Delete_Ri_Tables_Gipis002 (pi_dist_no);
                  delete_working_dist_tables (pi_dist_no);
                  delete_main_dist_tables (pi_dist_no);

                  UPDATE giuw_pol_dist
                     SET user_id = USER,
                         last_upd_date = SYSDATE,
                         dist_type = NULL,
                         dist_flag = '1'
                   WHERE par_id = p_par_id AND dist_no = pi_dist_no;

                  UPDATE gipi_wpolbas
                     SET user_id = USER
                   WHERE par_id = p_par_id;
               /*ELSE                p_par_id                                 --alert_but1
                                                                    --x_but := 2;
                  HIDE_VIEW ('WARNING');
                  SET_APPLICATION_PROPERTY (cursor_style, 'DEFAULT');
                  SHOW_VIEW ('CG$STACKED_HEADER_1');
                  RAISE form_trigger_failure;
               END IF;*/
            ELSE                                                   --sql%found
               RAISE NO_DATA_FOUND;
            END IF;
         EXCEPTION                                                       --2--
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;                                                            --2--

         BEGIN                                                           --3--
            SELECT DISTINCT 1
                       INTO p_exist
                       FROM giuw_wpolicyds
                      WHERE dist_no = pi_dist_no;

            /*alert_id := FIND_ALERT ('DISTRIBUTION');
            alert_but := SHOW_ALERT (alert_id);*/
            p_message := '3';
               --'Changes will be done to the distribution tables. Do you like to proceed?';
         /*IF alert_but = alert_button1
         THEN*/
            x_but := 1;
         /*ELSE
            x_but := 2;
         END IF;*/
         EXCEPTION                                                       --3--
            WHEN NO_DATA_FOUND
            THEN
               x_but := 1;
               p_message := '3A';
         END;                                                            --3--
            IF x_but = 2
            THEN
               NULL; --RAISE form_trigger_failure;
			   RETURN;
            ELSE
               FOR c1_rec IN c1
               LOOP
                  DELETE      giri_wfrperil
                        WHERE frps_yy = c1_rec.frps_yy
                          AND frps_seq_no = c1_rec.frps_seq_no;

                  DELETE      giri_wfrps_ri
                        WHERE frps_yy = c1_rec.frps_yy
                          AND frps_seq_no = c1_rec.frps_seq_no;

                  DELETE      giri_wdistfrps
                        WHERE dist_no = pi_dist_no;
               END LOOP;

               FOR c2_rec IN c2
               LOOP
			     NULL;
                  /*msg_alert
                     (   'This PAR has corresponding records in the posted tables for RI.'
                      || '  Could not proceed.',
                      'E',
                      TRUE
                     );*/
               END LOOP;

               delete_working_dist_tables (pi_dist_no);

      ------------------------------------------------------
               IF vv_item_grp.EXISTS (1)
               THEN
                  FOR cnt IN vv_item_grp.FIRST .. vv_item_grp.LAST
                  LOOP
                     BEGIN                                                    --4--
                        SELECT COUNT (dist_no), MAX (dist_no),
                               MIN (dist_no)  --add min(dist_no) and filter item_grp
                          INTO dist_cnt, dist_max,
                               dist_min
                          FROM giuw_pol_dist
                         WHERE par_id = p_par_id
                           AND NVL (item_grp, vv_item_grp (cnt)) = vv_item_grp (cnt);
                     END;                                                      --4--

                     IF dist_cnt = 1
                     THEN
                        v_tsi_amt := v_tsi_amt + vv_tsi_amt (cnt);
                        v_ann_tsi_amt := v_ann_tsi_amt + vv_ann_tsi_amt (cnt);
                        v_prem_amt := v_prem_amt + vv_prem_amt (cnt);
                     ELSIF pi_dist_no BETWEEN dist_min AND dist_max
                     THEN
                        v_tsi_amt := vv_tsi_amt (cnt);
                        v_ann_tsi_amt := vv_ann_tsi_amt (cnt);
                        v_prem_amt := vv_prem_amt (cnt);
                        EXIT;
                     END IF;
                  END LOOP;
               END IF;

      -------------------------------------------------------
               IF pi_dist_no = dist_max
               THEN
                  UPDATE giuw_pol_dist
                     SET tsi_amt = NVL (v_tsi_amt, 0),
                         prem_amt =
                              NVL (v_prem_amt, 0)
                            - (  ROUND ((NVL (v_prem_amt, 0) / dist_cnt), 2)
                               * (dist_cnt - 1)
                              ),
                         ann_tsi_amt = NVL (v_ann_tsi_amt, 0),
                         last_upd_date = SYSDATE,
                         user_id = USER
                   WHERE par_id = p_par_id AND dist_no = pi_dist_no;
               ELSE
                  UPDATE giuw_pol_dist
                     SET tsi_amt = NVL (v_tsi_amt, 0),
                         prem_amt = NVL (v_prem_amt, 0) / dist_cnt,
                         ann_tsi_amt = NVL (v_ann_tsi_amt, 0),
                         last_upd_date = SYSDATE,
                         user_id = USER
                   WHERE par_id = p_par_id AND dist_no = pi_dist_no;
               END IF;
            END IF;
      END LOOP;                                                        --added
   EXCEPTION                                                          /*MAIN*/
      WHEN TOO_MANY_ROWS
      THEN
         /*msg_alert
            (   'There are too many distribution numbers assigned for this item. '
             || 'Please contact your database administrator to rectify the matter. Check '
             || 'records in the policy table with par_id = '
             || TO_CHAR (p_par_id)
             || '.',
             'E',
             TRUE
            );*/
         p_message := '4';
               /*'There are too many distribution numbers assigned for this item. '
            || 'Please contact your database administrator to rectify the matter. Check '
            || 'records in the policy table with par_id = '
            || TO_CHAR (p_par_id)*/
            --|| '.';
      WHEN NO_DATA_FOUND
      THEN
------------------------
         DECLARE
            p_no_of_takeup    giis_takeup_term.no_of_takeup%TYPE;
            p_yearly_tag      giis_takeup_term.yearly_tag%TYPE;
            p_takeup_term     gipi_wpolbas.takeup_term%TYPE;
            v_policy_days     NUMBER                               := 0;
            v_no_of_payment   NUMBER                               := 1;
            v_duration_frm    DATE;
            v_duration_to     DATE;
            v_days_interval   NUMBER                               := 0;
         BEGIN                                                           --5--
            SELECT eff_date, expiry_date, endt_type, takeup_term
              INTO p_eff_date, p_expiry_date, p_endt_type, p_takeup_term
              FROM gipi_wpolbas
             WHERE par_id = p_par_id;

            IF ((p_eff_date IS NULL) OR (p_expiry_date IS NULL))
            THEN
               /*msg_alert
                  ('Could not proceed. The effectivity date or expiry date had not been updated.',
                   'E',
                   TRUE
                  );*/
               p_message := '5';
			   RETURN;
                  --'Could not proceed. The effectivity date or expiry date had not been updated.';
            END IF;

            IF TRUNC (p_expiry_date - p_eff_date) = 31
            THEN
               v_policy_days := 30;
            ELSE
               v_policy_days := TRUNC (p_expiry_date - p_eff_date);
            END IF;

            FOR b1 IN (SELECT no_of_takeup, yearly_tag
                         FROM giis_takeup_term
                        WHERE takeup_term = p_takeup_term)
            LOOP
               p_no_of_takeup := b1.no_of_takeup;
               p_yearly_tag := b1.yearly_tag;
            END LOOP;

            IF p_yearly_tag = 'Y'
            THEN
               IF TRUNC ((v_policy_days) / 365, 2) * p_no_of_takeup >
                     TRUNC (TRUNC ((v_policy_days) / 365, 2) * p_no_of_takeup)
               THEN
                  v_no_of_payment :=
                       TRUNC (TRUNC ((v_policy_days) / 365, 2)
                              * p_no_of_takeup
                             )
                     + 1;
               ELSE
                  v_no_of_payment :=
                     TRUNC (TRUNC ((v_policy_days) / 365, 2) * p_no_of_takeup);
               END IF;
            ELSE
               IF v_policy_days < p_no_of_takeup
               THEN
                  v_no_of_payment := v_policy_days;
               ELSE
                  v_no_of_payment := p_no_of_takeup;
               END IF;
            END IF;

            IF v_no_of_payment < 1
            THEN
               v_no_of_payment := 1;
            END IF;

            v_days_interval := ROUND (v_policy_days / v_no_of_payment);
            p_policy_id := NULL;

            IF v_no_of_payment = 1
            THEN
-------------------------------------------------------- IF: Single takeup (x)
               DECLARE
                  CURSOR c
                  IS
                     SELECT pol_dist_dist_no_s.NEXTVAL
                       FROM SYS.DUAL;
               BEGIN                                                     --6--
                  OPEN c;

                  FETCH c
                   INTO p2_dist_no;

                  IF c%NOTFOUND
                  THEN
                     --msg_alert ('No row in table SYS.DUAL', 'F', TRUE);
                     p_message := '6'; --'No row in table SYS.DUAL';
					 
					 RETURN;
                  END IF;

                  CLOSE c;
               EXCEPTION                                                 --6--
                  WHEN OTHERS
                  THEN
                     --cgte$other_exceptions;
                     NULL;
               END;                                                      --6--
            --beth 06162000 include field auto_dist
            INSERT INTO giuw_pol_dist
                        (dist_no, par_id, policy_id, endt_type,
                         tsi_amt, prem_amt,
                         ann_tsi_amt, dist_flag, redist_flag, eff_date,
                         expiry_date, create_date, user_id, last_upd_date,
                         post_flag, auto_dist
                        )
                 VALUES (p2_dist_no, p_par_id, p_policy_id, p_endt_type,
                         NVL (v_tsi_amt, 0), NVL (v_prem_amt, 0),
                         NVL (v_ann_tsi_amt, 0), 1, 1, p_eff_date,
                         p_expiry_date, SYSDATE, USER, SYSDATE,
                         'O', 'N'
                        );
            ELSE
--------------------------------------------------------------------------------- ELSE: MULTI TAKE-UP (x)
-------------------------------------------------------------------------------------- LONG TERM LOOP start
               v_duration_frm := NULL;
               v_duration_to := NULL;

               FOR takeup_val IN 1 .. v_no_of_payment
               LOOP
                  IF v_duration_frm IS NULL
                  THEN
                     v_duration_frm := TRUNC (p_eff_date);
                  ELSE
                     v_duration_frm :=
                                     TRUNC (v_duration_frm + v_days_interval);
                  END IF;

                  v_duration_to := TRUNC (v_duration_frm + v_days_interval)
                                   - 1;

                  DECLARE
                     CURSOR c
                     IS
                        SELECT pol_dist_dist_no_s.NEXTVAL
                          FROM SYS.DUAL;
                  BEGIN                                                  --7--
                     OPEN c;

                     FETCH c
                      INTO p2_dist_no;

                     IF c%NOTFOUND
                     THEN
                        --msg_alert ('No row in table SYS.DUAL', 'F', TRUE);
                        p_message := '6'; --'No row in table SYS.DUAL';
                        RETURN;
                     END IF;

                     CLOSE c;
                  EXCEPTION                                              --7--
                     WHEN OTHERS
                     THEN
                        --cgte$other_exceptions;
                        NULL;
                  END;                                                   --7--

                  IF takeup_val = v_no_of_payment
                  THEN
                     --------------------------------------------- IF: last loop record (y)
                     INSERT INTO giuw_pol_dist
                                  (dist_no, par_id, policy_id,
                                   endt_type, dist_flag, redist_flag, eff_date,
                                   expiry_date, create_date, user_id,
                                   last_upd_date, post_flag, auto_dist, tsi_amt,
                                   prem_amt,
                                   ann_tsi_amt
                                  )
                           VALUES (p2_dist_no, p_par_id, p_policy_id,
                                   p_endt_type, 1, 1, v_duration_frm,
                                   v_duration_to, SYSDATE, USER,
                                   SYSDATE, 'O', 'N', NVL (v_tsi_amt, 0),
                                     NVL (v_prem_amt, 0)
                                   - (  ROUND ((  NVL (v_prem_amt, 0)
                                                / v_no_of_payment
                                               ),
                                               2
                                              )
                                      * (v_no_of_payment - 1)
                                     ),
                                   NVL (v_ann_tsi_amt, 0)
                                  );
                  ELSE
----------------------------------------------------------------------------- ELSE: other loop records (y)
                     INSERT INTO giuw_pol_dist
                                 (dist_no, par_id, policy_id,
                                  endt_type, dist_flag, redist_flag,
                                  eff_date, expiry_date, create_date,
                                  user_id, last_upd_date, post_flag,
                                  auto_dist, tsi_amt,
                                  prem_amt,
                                  ann_tsi_amt
                                 )
                          VALUES (p2_dist_no, p_par_id, p_policy_id,
                                  p_endt_type, 1, 1,
                                  v_duration_frm, v_duration_to, SYSDATE,
                                  USER, SYSDATE, 'O',
                                  'N', NVL (v_tsi_amt, 0),
                                  (NVL (v_prem_amt, 0) / v_no_of_payment
                                  ),
                                  NVL (v_ann_tsi_amt, 0)
                                 );
                  END IF;
               END LOOP;
            END IF;
         EXCEPTION                                                       --5--
            WHEN NO_DATA_FOUND
            THEN
               /*msg_alert
                  ('You had committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.',
                   'E',
                   TRUE
                  );*/
               p_message := '7';
			   RETURN;
                  --'You had committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.';
            WHEN TOO_MANY_ROWS
            THEN
               p_message := '8';
                 /*    'Multiple rows were found to exist in GIPI_WPOLBAS. '
                  || 'Please contact your database administrator '
                  || 'to rectify the matter. Check record with par_id = '
                  || TO_CHAR (p_par_id);*/
         /*MESSAGE (   'Multiple rows were found to exist in GIPI_WPOLBAS. '
                  || 'Please contact your database administrator '
                  || 'to rectify the matter. Check record with par_id = '
                  || TO_CHAR (p_par_id)
                 );*/
         END;                                                            
      /*MESSAGE ('Deleting non-existent item group for distribution...',
               no_acknowledge
              );*/

      DELETE FROM giuw_pol_dist a
            WHERE par_id = p_par_id
              AND dist_no = pi_dist_no
              AND NOT EXISTS (
                     SELECT 1
                       FROM gipi_witem b
                      WHERE b.item_grp = NVL (a.item_grp, b.item_grp)
                        AND b.par_id = a.par_id);
   END;
END;
/


