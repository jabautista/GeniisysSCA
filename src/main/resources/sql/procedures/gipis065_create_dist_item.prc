DROP PROCEDURE CPI.GIPIS065_CREATE_DIST_ITEM;

CREATE OR REPLACE PROCEDURE CPI.gipis065_create_dist_item (b_par_id IN NUMBER)
IS
   tmpvar          NUMBER;
-- MOST OF THE ALERT MESSAGES ARE ALREADY HANDLED IN THE DISTRIBUTION VALIDATION. SO IT IS OMMITED HERE.
   b_exist         NUMBER;
   p_exist         NUMBER;
   p_dist_no       giuw_pol_dist.dist_no%TYPE;
   pi_dist_no      NUMBER;
   p_frps_yy       giri_wdistfrps.frps_yy%TYPE;
   p_frps_seq_no   giri_wdistfrps.frps_seq_no%TYPE;
   p2_dist_no      giuw_pol_dist.dist_no%TYPE;
   p_eff_date      gipi_polbasic.eff_date%TYPE;
   p_expiry_date   gipi_polbasic.expiry_date%TYPE;
   p_endt_type     gipi_polbasic.endt_type%TYPE;
   p_policy_id     gipi_polbasic.policy_id%TYPE;
   p_tsi_amt       gipi_witem.tsi_amt%TYPE;
   p_ann_tsi_amt   gipi_witem.ann_tsi_amt%TYPE;
   p_prem_amt      gipi_witem.prem_amt%TYPE;
   v_tsi_amt       gipi_witem.tsi_amt%TYPE           := 0;
   v_ann_tsi_amt   gipi_witem.ann_tsi_amt%TYPE       := 0;
   v_prem_amt      gipi_witem.prem_amt%TYPE          := 0;
   x_but           NUMBER;

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
BEGIN
   BEGIN
      SELECT dist_no
        INTO pi_dist_no
        FROM giuw_pol_dist
       WHERE par_id = b_par_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   --MESSAGE('Processing distribution information...', NO_ACKNOWLEDGE);
   SELECT SUM (tsi_amt * currency_rt), SUM (ann_tsi_amt * currency_rt),
          SUM (prem_amt * currency_rt)
     INTO v_tsi_amt, v_ann_tsi_amt,
          v_prem_amt
     FROM gipi_witem
    WHERE par_id = b_par_id;

   IF ((v_tsi_amt IS NULL) OR (v_ann_tsi_amt IS NULL) OR (v_prem_amt IS NULL)
      )
   THEN
      delete_ri_tables_gipis002 (pi_dist_no);
      delete_working_dist_tables (pi_dist_no);
      delete_main_dist_tables (pi_dist_no);

      DELETE      giuw_distrel
            WHERE dist_no_old = pi_dist_no;

      DELETE      giuw_pol_dist
            WHERE dist_no = pi_dist_no;
   --HIDE_VIEW('WARNING');
   --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
   ELSE
      BEGIN
         SELECT DISTINCT dist_no
                    INTO p_dist_no
                    FROM giuw_pol_dist
                   WHERE par_id = b_par_id;

         BEGIN
            SELECT DISTINCT 1
                       INTO b_exist
                       FROM giuw_policyds
                      WHERE dist_no = pi_dist_no;

            IF SQL%FOUND
            THEN
               --HIDE_VIEW('WARNING');
               --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
               --SHOW_VIEW('CG$STACKED_HEADER_1');
                --alert_id2   := FIND_ALERT('REC_EXISTS_IN_POST_POL_TAB');
                 --alert_but2  := SHOW_ALERT(ALERT_ID2);
               --IF alert_but2 = ALERT_BUTTON1 THEN
               delete_ri_tables_gipis002 (pi_dist_no);
               delete_working_dist_tables (pi_dist_no);
               delete_main_dist_tables (pi_dist_no);

               UPDATE giuw_pol_dist
                  SET user_id = USER,
                      last_upd_date = SYSDATE,
                      dist_type = NULL,
                      dist_flag = '1'
                WHERE dist_no = pi_dist_no;

               UPDATE gipi_wpolbas
                  SET user_id = USER
                WHERE par_id = b_par_id;
                   --ELSE
               --HIDE_VIEW('WARNING');
               --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
               --SHOW_VIEW('CG$STACKED_HEADER_1');
               --RAISE FORM_TRIGGER_FAILURE;
            --END IF;
            ELSE
               RAISE NO_DATA_FOUND;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT DISTINCT 1
                       INTO p_exist
                       FROM giuw_wpolicyds
                      WHERE dist_no = pi_dist_no;

            --alert_id   := FIND_ALERT('DISTRIBUTION');
            --alert_but  := SHOW_ALERT(ALERT_ID);
            --IF alert_but = ALERT_BUTTON1 THEN
            x_but := 1;
         --ELSE
            --x_but := 2;
         --END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               x_but := 1;
         END;

         --IF x_but = 2 THEN
               --  HIDE_VIEW('WARNING');
               --  SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
               --  SHOW_VIEW('CG$STACKED_HEADER_1');
               --  RAISE FORM_TRIGGER_FAILURE;
           --   ELSE
         FOR c1_rec IN c1
         LOOP
            delete_ri_tables_gipis002 (pi_dist_no);

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
         -- MSG_ALERT('This PAR has corresponding records in the posted tables for RI.'||
           -- ' Could not proceed.','E',TRUE);
         END LOOP;

         delete_working_dist_tables (pi_dist_no);

         UPDATE giuw_pol_dist
            SET tsi_amt = NVL (v_tsi_amt, 0),
                prem_amt = NVL (v_prem_amt, 0),
                ann_tsi_amt = NVL (v_ann_tsi_amt, 0),
                last_upd_date = SYSDATE,
                user_id = USER
          WHERE par_id = b_par_id AND dist_no = pi_dist_no;
      --   END IF;
      EXCEPTION
         WHEN TOO_MANY_ROWS
         THEN
            /*  HIDE_VIEW('WARNING');
              SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
              SHOW_VIEW('CG$STACKED_HEADER_1');
              MSG_ALERT('There are too many distribution numbers assigned for this item. '||
                      'Please call your administrator to rectify the matter. Check '||
                      'records in the policy table with par_id = '||to_char(b_par_id)||
                      '.','E',TRUE);*/
            NULL;
         WHEN NO_DATA_FOUND
         THEN
            BEGIN
               SELECT eff_date, expiry_date, endt_type
                 INTO p_eff_date, p_expiry_date, p_endt_type
                 FROM gipi_wpolbas
                WHERE par_id = b_par_id;

                   /*
               IF ((p_eff_date IS NULL ) OR (p_expiry_date IS NULL)) THEN
                  HIDE_VIEW('WARNING');
                  SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
                  SHOW_VIEW('CG$STACKED_HEADER_1');
                  MSG_ALERT('Could not proceed. The effectivity date or expiry date had not been updated.','E',TRUE);
               END IF;*/
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
                        NULL;
                     --msg_alert('No row in table SYS.DUAL', 'F', TRUE);
                     END IF;

                     CLOSE c;
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        NULL;
                  -- CGTE$OTHER_EXCEPTIONS;
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
                            post_flag, auto_dist
                           )
                    VALUES (p2_dist_no, b_par_id, p_policy_id, p_endt_type,
                            NVL (v_tsi_amt, 0), NVL (v_prem_amt, 0),
                            NVL (v_ann_tsi_amt, 0), 1, 1, p_eff_date,
                            p_expiry_date, SYSDATE, USER, SYSDATE,
                            'O', 'N'
                           );
            EXCEPTION
               WHEN TOO_MANY_ROWS
               THEN
                     /*  HIDE_VIEW('WARNING');
                  SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
                      SHOW_VIEW('CG$STACKED_HEADER_1');
                       message('Multiple rows were found to exist in GIPI_WPOLBAS. Please call your administrator '||
                                'to rectify the matter. Check record with par_id = '||to_char(b_par_id));*/
                  NULL;
               WHEN NO_DATA_FOUND
               THEN
                          /*HIDE_VIEW('WARNING');
                          SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
                        SHOW_VIEW('CG$STACKED_HEADER_1');
                          MSG_ALERT('You have committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.','E',TRUE);

                  */
                  NULL;
            END;
      END;
   END IF;
   
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           /* HIDE_VIEW('WARNING');
           SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
           SHOW_VIEW('CG$STACKED_HEADER_1');
         MSG_ALERT('Pls. be adviced that there are no items for this PAR.','E',TRUE);*/
         null;
END gipis065_create_dist_item;
/


