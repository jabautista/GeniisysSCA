DROP PROCEDURE CPI.GIPIS065_CREATE_DISTRIBUTION2;

CREATE OR REPLACE PROCEDURE CPI.gipis065_create_distribution2 (
   p_par_id   IN   NUMBER
)
IS
   TYPE number_varray IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;

   vv_tsi_amt       number_varray;
   vv_ann_tsi_amt   number_varray;
   vv_prem_amt      number_varray;
   vv_item_grp      number_varray;
   varray_cnt       NUMBER                          := 0;
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
   p_message        VARCHAR2 (200)                    := '0';
   p_dist_no        giuw_pol_dist.dist_no%TYPE;
   dist_exist       VARCHAR2 (1);

   -- first cursor
   CURSOR c1 (p_dist_no giuw_pol_dist.dist_no%TYPE)
   IS
      SELECT DISTINCT frps_yy, frps_seq_no
                 FROM giri_wdistfrps
                WHERE dist_no = p_dist_no;

   CURSOR c2 (p_dist_no giuw_pol_dist.dist_no%TYPE)
   IS
      SELECT DISTINCT frps_yy, frps_seq_no
                 FROM giri_distfrps
                WHERE dist_no = p_dist_no;
/*main*/
BEGIN
   BEGIN
      FOR a1 IN (SELECT dist_no
                   FROM giuw_pol_dist
                  WHERE par_id = p_par_id)
      LOOP
         p_dist_no := a1.dist_no;
         EXIT;
      END LOOP;

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
         --'Pls. be adviced that there are no items for this PAR.';
         END IF;
      END;

      FOR x IN (SELECT dist_no
                  FROM giuw_pol_dist
                 WHERE par_id = p_par_id)
      LOOP
         pi_dist_no := x.dist_no;
         dist_exist := 'Y';

         BEGIN
            --2--
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
                 -- EXIT;
               /*IF alert_but2 = alert_button1
                  THEN
                     --x_but := 1;*/
               delete_ri_tables_gipis002 (pi_dist_no);
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
         END;

         BEGIN                                                           --3--
            SELECT DISTINCT 1
                       INTO p_exist
                       FROM giuw_wpolicyds
                      WHERE dist_no = pi_dist_no;

            /*alert_id := FIND_ALERT ('DISTRIBUTION');
            alert_but := SHOW_ALERT (alert_id);*/
            p_message := '3';
                  --'Changes will be done to the distribution tables. Do you like to proceed?';
               --EXIT;
            /*IF alert_but = alert_button1
            THEN*/
            x_but := 1;
         /*ELSE
            x_but := 2;
         END IF;*/
         EXCEPTION                                                       --3--
            WHEN NO_DATA_FOUND
            THEN
               --x_but := 1;
               p_message := '0';
         END;

         IF x_but = 2
         THEN
            NULL;                               --RAISE FORM_TRIGGER_FAILURE;
         ELSE
            FOR c1_rec IN c1(p_dist_no )
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

            FOR c2_rec IN c2(p_dist_no)
            LOOP
               NULL;
            --  MSG_ALERT('This PAR has corresponding records in the posted tables for RI.'||
              --          '  Could not proceed.','E', TRUE);
            END LOOP;

            delete_working_dist_tables (pi_dist_no);

            UPDATE giuw_pol_dist
               SET tsi_amt = NVL (v_tsi_amt, 0),
                   prem_amt = NVL (v_prem_amt, 0),
                   ann_tsi_amt = NVL (v_ann_tsi_amt, 0),
                   last_upd_date = SYSDATE,
                   user_id = USER
             WHERE par_id = p_par_id AND dist_no = pi_dist_no;
         END IF;
      END LOOP;
   EXCEPTION
      WHEN TOO_MANY_ROWS
      THEN
         /*  MSG_ALERT('There are too many distribution numbers assigned for this item. '||
                     'Please contact your database administrator to rectify the matter. Check '||
                     'records in the policy table with par_id = '||to_char(b_par_id)||
                     '.','E',TRUE);*/
         p_message := '4';
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            SELECT eff_date, expiry_date, endt_type
              INTO p_eff_date, p_expiry_date, p_endt_type
              FROM gipi_wpolbas
             WHERE par_id = p_par_id;

            IF ((p_eff_date IS NULL) OR (p_expiry_date IS NULL))
            THEN
               --MSG_ALERT('Could not proceed. The effectivity date or expiry date had not been updated.','E',TRUE);
               p_message := '5';
            END IF;

            BEGIN
               DECLARE
                  CURSOR c
                  IS
                     SELECT pol_dist_dist_no_s.NEXTVAL
                       FROM SYS.DUAL;
               BEGIN
                  OPEN c;

                  FETCH c
                   INTO p2_dist_no;

                  IF c%NOTFOUND
                  THEN
                     --msg_alert('No row in table SYS.DUAL', 'F', TRUE);
                     p_message := '6';
                  END IF;

                  CLOSE c;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     --cgte$other_exceptions;
                     NULL;
               END;
            END;

            BEGIN
               p_policy_id := NULL;
            END;

            INSERT INTO giuw_pol_dist
                        (dist_no, par_id, policy_id, endt_type,
                         tsi_amt, prem_amt,
                         ann_tsi_amt, dist_flag, redist_flag, eff_date,
                         expiry_date, create_date, user_id, last_upd_date,
                         auto_dist
                        )
                 VALUES (p2_dist_no, p_par_id, p_policy_id, p_endt_type,
                         NVL (v_tsi_amt, 0), NVL (v_prem_amt, 0),
                         NVL (v_ann_tsi_amt, 0), 1, 1, p_eff_date,
                         p_expiry_date, SYSDATE, USER, SYSDATE,
                         'N'
                        );
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               --MSG_ALERT('You had committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.','E',TRUE);
               p_message := '7';
            WHEN TOO_MANY_ROWS
            THEN
               /*MESSAGE('Multiple rows were found to exist in GIPI_WPOLBAS. '||
                       'Please contact your database administrator '||
                       'to rectify the matter. Check record with par_id = '||to_char(b_par_id));*/
               p_message := '8';
         END;
   END;
END;
/


