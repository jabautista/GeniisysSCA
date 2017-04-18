CREATE OR REPLACE PACKAGE BODY CPI.claims_menu_pkg
IS
--gicls010
   v_claims   gicls_menu_type;

   FUNCTION items (
      p_claim_id   IN   gicl_claims.claim_id%TYPE,
      p_line_cd    IN   giis_line.line_cd%TYPE
   )
      RETURN gicls_menu_tab PIPELINED
   IS
      v_exist       VARCHAR2 (1);
      v_motor_car   giis_line.line_cd%TYPE;
      v_fire        giis_line.line_cd%TYPE;
      v_marine      giis_line.line_cd%TYPE;
      v_aviation    giis_line.line_cd%TYPE;
      v_hull        giis_line.line_cd%TYPE;
      v_casualty    giis_line.line_cd%TYPE;
      v_accident    giis_line.line_cd%TYPE;
      v_surety      giis_line.line_cd%TYPE;
      v_engr        giis_line.line_cd%TYPE;
      v_med         giis_line.line_cd%TYPE;
      v_line1       giis_line.line_cd%TYPE;
      v_line2       VARCHAR2 (15);
      v_line        giis_line.line_cd%TYPE;
   BEGIN
      --SET_MENU_ITEM_PROPERTY('claims_menu.winsub', ENABLED, PROPERTY_FALSE); Ano ba ginagawa nito hehehe dagdag nyo na lang pag kailangan ng module nyo --tonio aug 08, 2011
      v_motor_car := giisp.v ('LINE_CODE_MC');
      v_fire := giisp.v ('LINE_CODE_FI');
      v_aviation := giisp.v ('LINE_CODE_AV');
      v_marine := giisp.v ('LINE_CODE_MN');
      v_hull := giisp.v ('LINE_CODE_MH');
      v_casualty := giisp.v ('LINE_CODE_CA');
      v_accident := giisp.v ('LINE_CODE_AC');
      v_surety := giisp.v ('LINE_CODE_SU');
      v_engr := giisp.v ('LINE_CODE_EN');
      v_med := giisp.v ('LINE_CODE_MD');

      BEGIN
         SELECT menu_line_cd
           INTO v_line1
           FROM giis_line
          WHERE line_cd = p_line_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_line1 := NULL;
      END;

      v_line2 := 'LINE_CODE_' || v_line1;

      BEGIN
         SELECT param_value_v
           INTO v_line
           FROM giis_parameters
          WHERE param_name = v_line2;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      IF NVL (v_line, p_line_cd) = v_motor_car
      THEN
         --SET_MENU_ITEM_PROPERTY('claims_menu.basic_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.item_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reports',ENABLED,PROPERTY_TRUE);
         v_claims.basic_information := 'Y';
         v_claims.item_information := 'Y';
         v_claims.reserve := 'N';
         v_claims.lossexpense_history := 'N';
         v_claims.generate_advice := 'N';
         v_claims.reports := 'Y';

         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_motor_car_dtl
                      WHERE claim_id = p_claim_id;

            IF v_exist IS NOT NULL
            THEN
               manipulate_menu (p_claim_id, p_line_cd);
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      ELSIF NVL (v_line, p_line_cd) = v_fire
      THEN
         --SET_MENU_ITEM_PROPERTY('claims_menu.basic_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.item_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reports',ENABLED,PROPERTY_TRUE);
         v_claims.basic_information := 'Y';
         v_claims.item_information := 'Y';
         v_claims.reserve := 'N';
         v_claims.lossexpense_history := 'N';
         v_claims.generate_advice := 'N';
         v_claims.reports := 'Y';

         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_fire_dtl
                      WHERE claim_id = p_claim_id;

            IF v_exist IS NOT NULL
            THEN
               manipulate_menu (p_claim_id, p_line_cd);
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      ELSIF NVL (v_line, p_line_cd) = v_surety
      THEN
         --SET_MENU_ITEM_PROPERTY('claims_menu.basic_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.item_information',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reports',ENABLED,PROPERTY_FALSE);
         v_claims.basic_information := 'Y';
         v_claims.item_information := 'N';
         v_claims.reserve := 'Y';
         v_claims.lossexpense_history := 'N';
         v_claims.generate_advice := 'N';
         v_claims.reports := 'N';

         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_item_peril
                      WHERE claim_id = p_claim_id;

            IF v_exist IS NOT NULL
            THEN
               manipulate_menu (p_claim_id, p_line_cd);
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      ELSIF NVL (v_line, p_line_cd) = v_marine
      THEN
         --SET_MENU_ITEM_PROPERTY('claims_menu.basic_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.item_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reports',ENABLED,PROPERTY_TRUE);
         v_claims.basic_information := 'Y';
         v_claims.item_information := 'Y';
         v_claims.reserve := 'N';
         v_claims.lossexpense_history := 'N';
         v_claims.generate_advice := 'N';
         v_claims.reports := 'Y';

         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_cargo_dtl
                      WHERE claim_id = p_claim_id;

            IF v_exist IS NOT NULL
            THEN
               manipulate_menu (p_claim_id, p_line_cd);
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      ELSIF NVL (v_line, p_line_cd) = v_aviation
      THEN
         --SET_MENU_ITEM_PROPERTY('claims_menu.basic_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.item_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reports',ENABLED,PROPERTY_TRUE);
         v_claims.basic_information := 'Y';
         v_claims.item_information := 'Y';
         v_claims.reserve := 'N';
         v_claims.lossexpense_history := 'N';
         v_claims.generate_advice := 'N';
         v_claims.reports := 'Y';

         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_aviation_dtl
                      WHERE claim_id = p_claim_id;

            IF v_exist IS NOT NULL
            THEN
               manipulate_menu (p_claim_id, p_line_cd);
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      ELSIF NVL (v_line, p_line_cd) = v_hull
      THEN
         --SET_MENU_ITEM_PROPERTY('claims_menu.basic_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.item_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reports',ENABLED,PROPERTY_TRUE);
         v_claims.basic_information := 'Y';
         v_claims.item_information := 'Y';
         v_claims.reserve := 'N';
         v_claims.lossexpense_history := 'N';
         v_claims.generate_advice := 'N';
         v_claims.reports := 'Y';

         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_hull_dtl
                      WHERE claim_id = p_claim_id;

            IF v_exist IS NOT NULL
            THEN
               manipulate_menu (p_claim_id, p_line_cd);
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      ELSIF NVL (v_line, p_line_cd) = v_casualty
      THEN
         --SET_MENU_ITEM_PROPERTY('CLAIMS_MENU.BASIC_INFORMATION',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('CLAIMS_MENU.ITEM_INFORMATION',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('CLAIMS_MENU.RESERVE',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('CLAIMS_MENU.LOSSEXPENSE_HISTORY',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('CLAIMS_MENU.GENERATE_ADVICE',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('CLAIMS_MENU.REPORTS',ENABLED,PROPERTY_TRUE);
         v_claims.basic_information := 'Y';
         v_claims.item_information := 'Y';
         v_claims.reserve := 'N';
         v_claims.lossexpense_history := 'N';
         v_claims.generate_advice := 'N';
         v_claims.reports := 'Y';

         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_casualty_dtl
                      WHERE claim_id = p_claim_id;

            IF v_exist IS NOT NULL
            THEN
               manipulate_menu (p_claim_id, p_line_cd);
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      ELSIF NVL (v_line, p_line_cd) = v_accident
      THEN
         --SET_MENU_ITEM_PROPERTY('CLAIMS_MENU.BASIC_INFORMATION',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('CLAIMS_MENU.ITEM_INFORMATION',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('CLAIMS_MENU.RESERVE',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('CLAIMS_MENU.LOSSEXPENSE_HISTORY',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('CLAIMS_MENU.GENERATE_ADVICE',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('CLAIMS_MENU.REPORTS',ENABLED,PROPERTY_TRUE);
         v_claims.basic_information := 'Y';
         v_claims.item_information := 'Y';
         v_claims.reserve := 'N';
         v_claims.lossexpense_history := 'N';
         v_claims.generate_advice := 'N';
         v_claims.reports := 'Y';

         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_accident_dtl
                      WHERE claim_id = p_claim_id;

            IF v_exist IS NOT NULL
            THEN
               manipulate_menu (p_claim_id, p_line_cd);
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      ELSIF NVL (v_line, p_line_cd) = v_engr
      THEN
         --SET_MENU_ITEM_PROPERTY('claims_menu.basic_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.item_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reports',ENABLED,PROPERTY_TRUE);
         v_claims.basic_information := 'Y';
         v_claims.item_information := 'Y';
         v_claims.reserve := 'N';
         v_claims.lossexpense_history := 'N';
         v_claims.generate_advice := 'N';
         v_claims.reports := 'Y';

         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_engineering_dtl
                      WHERE claim_id = p_claim_id;

            IF v_exist IS NOT NULL
            THEN
               manipulate_menu (p_claim_id, p_line_cd);
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      ELSIF NVL (v_line, p_line_cd) = v_med
      THEN
         --SET_MENU_ITEM_PROPERTY('claims_menu.basic_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.item_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reports',ENABLED,PROPERTY_TRUE);
         v_claims.basic_information := 'Y';
         v_claims.item_information := 'Y';
         v_claims.reserve := 'N';
         v_claims.lossexpense_history := 'N';
         v_claims.generate_advice := 'N';
         v_claims.reports := 'Y';

         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_exist
                       FROM gicl_medical_dtl
                      WHERE claim_id = p_claim_id;

            IF v_exist IS NOT NULL
            THEN
               manipulate_menu (p_claim_id, p_line_cd);
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      ELSE
         --SET_MENU_ITEM_PROPERTY('claims_menu.basic_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.item_information',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_FALSE);
         --SET_MENU_ITEM_PROPERTY('claims_menu.reports',ENABLED,PROPERTY_TRUE);
         v_claims.basic_information := 'Y';
         v_claims.item_information := 'Y';
         v_claims.reserve := 'N';
         v_claims.lossexpense_history := 'N';
         v_claims.generate_advice := 'N';
         v_claims.reports := 'Y';
      END IF;

      BEGIN
         SELECT DISTINCT 'x'
                    INTO v_exist
                    FROM gicl_item_peril
                   WHERE claim_id = p_claim_id;

         IF v_exist IS NOT NULL
         THEN
            manipulate_menu (p_claim_id, p_line_cd);
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      DECLARE
         v_recovery   gicl_claims.recovery_sw%TYPE;
         v_chk        VARCHAR2 (1)                   := 'N';
         v_dist       VARCHAR2 (1);
         v_entry      VARCHAR2 (1);
      BEGIN
         /*SELECT DISTINCT recovery_sw
           INTO v_recovery
           FROM gicl_claims a, gicl_advice b
          WHERE a.claim_id = p_claim_id
            AND a.claim_id = b.claim_id
            AND b.advice_flag = 'Y';*/
         v_recovery := check_claim_with_recovery (p_claim_id);

         IF v_recovery = 'Y'
         THEN
            --SET_MENU_ITEM_PROPERTY('claims_menu.loss_recovery',ENABLED,PROPERTY_TRUE);
            --SET_MENU_ITEM_PROPERTY('loss_recovery_menu.recovery_information',ENABLED,PROPERTY_TRUE);
            v_claims.loss_recovery := 'Y';
            v_claims.recovery_information := 'Y';

            FOR payt IN (SELECT DISTINCT 'x' dist
                                    FROM gicl_recovery_payt
                                   WHERE claim_id = p_claim_id
                                     AND stat_sw = 'Y'
                                     AND NVL (cancel_tag, 'N') = 'N')
            LOOP
               v_dist := payt.dist;

               FOR payt2 IN (SELECT DISTINCT 'x' entry
                                        FROM gicl_recovery_payt
                                       WHERE claim_id = p_claim_id
                                         AND dist_sw = 'Y'
                                         AND NVL (entry_tag, 'N') = 'N')
               LOOP
                  v_entry := payt2.entry;
               END LOOP;
            END LOOP;

            IF v_dist IS NOT NULL
            THEN
               --SET_MENU_ITEM_PROPERTY('loss_recovery_menu.recovery_distribution',ENABLED,PROPERTY_TRUE);
               v_claims.recovery_distribution := 'Y';

               IF v_entry IS NOT NULL
               THEN
                  --SET_MENU_ITEM_PROPERTY('loss_recovery_menu.generate_recovery_acct_entries',ENABLED,PROPERTY_TRUE);
                  v_claims.generate_recovery_acct_entries := 'Y';
               ELSE
                  --SET_MENU_ITEM_PROPERTY('loss_recovery_menu.generate_recovery_acct_entries',ENABLED,PROPERTY_FALSE);
                  v_claims.generate_recovery_acct_entries := 'N';
               END IF;
            ELSE
               --SET_MENU_ITEM_PROPERTY('loss_recovery_menu.recovery_distribution',ENABLED,PROPERTY_FALSE);
               --SET_MENU_ITEM_PROPERTY('loss_recovery_menu.generate_recovery_acct_entries',ENABLED,PROPERTY_FALSE);
               v_claims.recovery_distribution := 'N';
               v_claims.generate_recovery_acct_entries := 'N';
            END IF;
         ELSE
            --SET_MENU_ITEM_PROPERTY('claims_menu.loss_recovery',ENABLED,PROPERTY_FALSE);
            v_claims.loss_recovery := 'N';
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            --SET_MENU_ITEM_PROPERTY('claims_menu.loss_recovery',ENABLED,PROPERTY_FALSE);
            v_claims.loss_recovery := 'N';
      END;

      PIPE ROW (v_claims);
   END items;                                                --end of gicls010

--gicls010 manipulate
   PROCEDURE manipulate_menu (
        p_claim_id   IN   gicl_claims.claim_id%TYPE,
        p_line_cd    IN   giis_line.line_cd%TYPE
   )
   IS
      v_le_exist     VARCHAR2 (1);
      v_dist_exist   VARCHAR2 (1);
      v_adv_exist    VARCHAR2 (1);
      v_loss_exist   VARCHAR2 (1);
      v_exist        VARCHAR2 (1);
      v_adv          VARCHAR2 (1);
      v_item         NUMBER       := NULL;
      v_peril        NUMBER       := NULL;
      v_chk          VARCHAR2 (1) := 'N';
      v_dist         VARCHAR2 (1);
      v_entry        VARCHAR2 (1);
   BEGIN
      --SET_MENU_ITEM_PROPERTY('claims_menu.winsub', ENABLED, PROPERTY_FALSE); Ano ba ginagawa nito hehehe dagdag nyo na lang pag kailangan ng module nyo --tonio aug 08, 2011
      --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_FALSE);
      --SET_MENU_ITEM_PROPERTY('reserve_set_up.claim_reserve',ENABLED,PROPERTY_FALSE);
      --SET_MENU_ITEM_PROPERTY('reserve_set_up.pla',ENABLED,PROPERTY_FALSE);
      --SET_MENU_ITEM_PROPERTY('reserve_set_up.plr',ENABLED,PROPERTY_FALSE);
      v_claims.reserve := 'N';
      v_claims.claim_reserve := 'N';
      v_claims.pla := 'N';
      v_claims.plr := 'N';

      FOR item IN (SELECT c.item_no
                     FROM gicl_claims a, gicl_clm_item c
                    WHERE a.claim_id = p_claim_id AND a.claim_id = c.claim_id)
      LOOP
         IF item.item_no IS NOT NULL
         THEN
            v_item := item.item_no;
         END IF;

         FOR peril IN (SELECT peril_cd
                         FROM gicl_item_peril
                        WHERE claim_id = p_claim_id AND item_no = item.item_no)
         LOOP
            IF peril.peril_cd IS NOT NULL
            THEN
               v_peril := peril.peril_cd;
            END IF;
         END LOOP;
      END LOOP;

      IF v_item IS NOT NULL AND v_peril IS NOT NULL
      THEN
         --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_TRUE);
         --SET_MENU_ITEM_PROPERTY('reserve_set_up.claim_reserve',ENABLED,PROPERTY_TRUE);
         v_claims.reserve := 'Y';
         v_claims.claim_reserve := 'Y';

         BEGIN
            SELECT DISTINCT 'x'
                       INTO v_le_exist
                       FROM gicl_clm_res_hist
                      WHERE claim_id = p_claim_id;

            IF v_le_exist IS NOT NULL
            THEN
               BEGIN
                  SELECT DISTINCT 'x'
                             INTO v_dist_exist
                             FROM gicl_clm_res_hist
                            WHERE claim_id = p_claim_id AND dist_sw = 'Y';

                  IF v_dist_exist IS NOT NULL
                  THEN
                     --SET_MENU_ITEM_PROPERTY('reserve_set_up.pla',ENABLED,PROPERTY_TRUE);
                     --SET_MENU_ITEM_PROPERTY('reserve_set_up.plr',ENABLED,PROPERTY_TRUE);
                     --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_TRUE);
                     v_claims.pla := 'Y';
                     v_claims.plr := 'Y';
                     v_claims.lossexpense_history := 'Y';

                     BEGIN
                        SELECT DISTINCT 'x'
                                   INTO v_loss_exist
                                   FROM gicl_clm_loss_exp
                                  WHERE claim_id = p_claim_id;

                        IF v_loss_exist IS NOT NULL
                        THEN
                           BEGIN
                              SELECT DISTINCT 'x'
                                         INTO v_adv_exist
                                         FROM gicl_clm_loss_exp
                                        WHERE claim_id = p_claim_id
                                          AND dist_sw = 'Y'
                                          AND (   cancel_sw IS NULL
                                               OR cancel_sw = 'N'
                                              );

                              IF v_adv_exist IS NOT NULL
                              THEN
                                 --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_TRUE);
                                 --SET_MENU_ITEM_PROPERTY('generate_advice.generate_advice',ENABLED,PROPERTY_TRUE);
                                 --SET_MENU_ITEM_PROPERTY('generate_advice.generate_fla',ENABLED,PROPERTY_FALSE);
                                 --SET_MENU_ITEM_PROPERTY('generate_advice.loa',ENABLED,PROPERTY_FALSE);
                                 --SET_MENU_ITEM_PROPERTY('generate_advice.cash_settlement',ENABLED,PROPERTY_FALSE);
                                 v_claims.generate_advice := 'Y';
                                 v_claims.sub_generate_advice := 'Y';
                                 v_claims.generate_fla := 'N';
                                 v_claims.generate_loa := 'N';
                                 v_claims.generate_cash_settlement := 'N';

                                 BEGIN
                                    SELECT DISTINCT 'x'
                                               INTO v_exist
                                               FROM gicl_advice
                                              WHERE claim_id = p_claim_id;

                                    IF v_exist IS NOT NULL
                                    THEN
                                       --SET_MENU_ITEM_PROPERTY('generate_advice.generate_fla',ENABLED,PROPERTY_TRUE);
                                       v_claims.generate_fla := 'Y';

                                       IF p_line_cd = 'MC'
                                       THEN
                                          --SET_MENU_ITEM_PROPERTY('generate_advice.loa',ENABLED,PROPERTY_TRUE);
                                          --SET_MENU_ITEM_PROPERTY('generate_advice.cash_settlement',ENABLED,PROPERTY_TRUE);
                                          v_claims.generate_loa := 'Y';
                                          v_claims.generate_cash_settlement :=
                                                                          'Y';
                                       END IF;

                                       BEGIN
                                          SELECT DISTINCT 'X'
                                                     INTO v_adv
                                                     FROM gicl_advice
                                                    WHERE claim_id =
                                                                    p_claim_id
                                                      AND advice_flag = 'Y';
                                       EXCEPTION
                                          WHEN NO_DATA_FOUND
                                          THEN
                                             v_adv := NULL;
                                       END;

                                       IF v_adv IS NOT NULL
                                       THEN
                                          --SET_MENU_ITEM_PROPERTY('claims_menu.loss_recovery',ENABLED, PROPERTY_TRUE);
                                          --SET_MENU_ITEM_PROPERTY('loss_recovery_menu.recovery_information',ENABLED,PROPERTY_TRUE);
                                          v_claims.loss_recovery := 'Y';
                                          v_claims.recovery_information :=
                                                                          'Y';

                                          FOR payt IN
                                             (SELECT DISTINCT 'x' dist
                                                         FROM gicl_recovery_payt
                                                        WHERE claim_id =
                                                                    p_claim_id
                                                          AND stat_sw = 'Y'
                                                          AND NVL (cancel_tag,
                                                                   'N'
                                                                  ) = 'N')
                                          LOOP
                                             v_dist := payt.dist;

                                             FOR payt2 IN
                                                (SELECT DISTINCT 'x' entry
                                                            FROM gicl_recovery_payt
                                                           WHERE claim_id =
                                                                    p_claim_id
                                                             AND dist_sw = 'Y'
                                                             AND NVL
                                                                    (entry_tag,
                                                                     'N'
                                                                    ) = 'N')
                                             LOOP
                                                v_entry := payt2.entry;
                                             END LOOP;
                                          END LOOP;

                                          IF v_dist IS NOT NULL
                                          THEN
                                             --SET_MENU_ITEM_PROPERTY('LOSS_RECOVERY_MENU.RECOVERY_DISTRIBUTION',ENABLED,PROPERTY_TRUE);
                                             v_claims.recovery_distribution :=
                                                                          'Y';

                                             IF v_entry IS NOT NULL
                                             THEN
                                                --SET_MENU_ITEM_PROPERTY('LOSS_RECOVERY_MENU.GENERATE_RECOVERY_ACCT_ENTRIES',ENABLED,PROPERTY_TRUE);
                                                v_claims.generate_recovery_acct_entries :=
                                                                          'Y';
                                             ELSE
                                                --SET_MENU_ITEM_PROPERTY('LOSS_RECOVERY_MENU.GENERATE_RECOVERY_ACCT_ENTRIES',ENABLED,PROPERTY_FALSE);
                                                v_claims.generate_recovery_acct_entries :=
                                                                          'N';
                                             END IF;
                                          ELSE
                                             --SET_MENU_ITEM_PROPERTY('LOSS_RECOVERY_MENU.RECOVERY_DISTRIBUTION',ENABLED,PROPERTY_FALSE);
                                             --SET_MENU_ITEM_PROPERTY('LOSS_RECOVERY_MENU.GENERATE_RECOVERY_ACCT_ENTRIES',ENABLED,PROPERTY_FALSE);
                                             v_claims.recovery_distribution :=
                                                                          'N';
                                             v_claims.generate_recovery_acct_entries :=
                                                                          'N';
                                          END IF;
                                       END IF;
                                    END IF;
                                 EXCEPTION
                                    WHEN NO_DATA_FOUND
                                    THEN
                                       NULL;
                                 END;
                              END IF;
                           EXCEPTION
                              WHEN NO_DATA_FOUND
                              THEN
                                 NULL;
                           END;
                        END IF;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           NULL;
                     END;
                  END IF;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     NULL;
               END;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      END IF;
   END;                                              --END gicls010 manipulate

--all item modules
   PROCEDURE manipulate_menu_dtl (
      p_claim_id   IN   gicl_claims.claim_id%TYPE,
      p_item_no    IN   gipi_item.item_no%TYPE,
      p_peril_cd   IN   giis_peril.peril_cd%TYPE
   )
   IS
      v_peril_exist   VARCHAR2 (1);
      v_le_exist      VARCHAR2 (1);
      v_dist_exist    VARCHAR2 (1);
      v_adv_exist     VARCHAR2 (1);
      v_loss_exist    VARCHAR2 (1);
      v_exist         VARCHAR2 (1);
      v_line_cd       giis_line.line_cd%TYPE   := NULL;
   BEGIN
      BEGIN
         SELECT line_cd
           INTO v_line_cd
           FROM gicl_claims
          WHERE claim_id = p_claim_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      --RAISE FORM_TRIGGER_FAILURE;
      END;

      --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_FALSE);
      --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_FALSE);
      --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_FALSE);
      v_claims.reserve := 'N';
      v_claims.lossexpense_history := 'N';
      v_claims.generate_advice := 'N';

      BEGIN
         SELECT DISTINCT 'x'
                    INTO v_peril_exist
                    FROM gicl_item_peril
                   WHERE claim_id = p_claim_id
                     AND item_no = p_item_no
                     AND peril_cd = p_peril_cd;

         IF v_peril_exist IS NOT NULL
         THEN
            --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_TRUE);
            --SET_MENU_ITEM_PROPERTY('reserve_set_up.claim_reserve',ENABLED,PROPERTY_TRUE);
            --SET_MENU_ITEM_PROPERTY('reserve_set_up.pla',ENABLED,PROPERTY_FALSE);
            --SET_MENU_ITEM_PROPERTY('reserve_set_up.plr',ENABLED,PROPERTY_FALSE);
            v_claims.reserve := 'Y';
            v_claims.claim_reserve := 'Y';
            v_claims.pla := 'N';
            v_claims.plr := 'N';

            BEGIN
               SELECT DISTINCT 'x'
                          INTO v_le_exist
                          FROM gicl_clm_res_hist
                         WHERE claim_id = p_claim_id
                           AND item_no = p_item_no
                           AND peril_cd = p_peril_cd;

               IF v_le_exist IS NOT NULL
               THEN
                  --SET_MENU_ITEM_PROPERTY('claims_menu.reserve',ENABLED,PROPERTY_TRUE);
                  --SET_MENU_ITEM_PROPERTY('reserve_set_up.claim_reserve',ENABLED,PROPERTY_TRUE);
                  --SET_MENU_ITEM_PROPERTY('reserve_set_up.pla',ENABLED,PROPERTY_FALSE);
                  --SET_MENU_ITEM_PROPERTY('reserve_set_up.plr',ENABLED,PROPERTY_FALSE);
                  v_claims.reserve := 'Y';
                  v_claims.claim_reserve := 'Y';
                  v_claims.pla := 'N';
                  v_claims.plr := 'N';

                  BEGIN
                     SELECT DISTINCT 'x'
                                INTO v_dist_exist
                                FROM gicl_clm_res_hist
                               WHERE claim_id = p_claim_id
                                 AND dist_sw = 'Y'
                                 AND item_no = p_item_no
                                 AND peril_cd = p_peril_cd;

                     IF v_dist_exist IS NOT NULL
                     THEN
                        --SET_MENU_ITEM_PROPERTY('reserve_set_up.pla',ENABLED,PROPERTY_TRUE);
                        --SET_MENU_ITEM_PROPERTY('reserve_set_up.plr',ENABLED,PROPERTY_TRUE);
                        --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_TRUE);
                        v_claims.lossexpense_history := 'Y';
                        v_claims.pla := 'Y';
                        v_claims.plr := 'Y';

                        BEGIN
                           SELECT DISTINCT 'x'
                                      INTO v_loss_exist
                                      FROM gicl_clm_loss_exp
                                     WHERE claim_id = p_claim_id
                                       AND item_no = p_item_no
                                       AND peril_cd = p_peril_cd
                                       AND (   cancel_sw IS NULL
                                            OR cancel_sw = 'N'
                                           );

                           IF v_loss_exist IS NOT NULL
                           THEN
                              BEGIN
                                 SELECT DISTINCT 'x'
                                            INTO v_adv_exist
                                            FROM gicl_clm_loss_exp
                                           WHERE claim_id = p_claim_id
                                             AND item_no = p_item_no
                                             AND peril_cd = p_peril_cd
                                             AND dist_sw = 'Y'
                                             AND (   cancel_sw IS NULL
                                                  OR cancel_sw = 'N'
                                                 );

                                 IF v_adv_exist IS NOT NULL
                                 THEN
                                    --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_TRUE);
                                    --SET_MENU_ITEM_PROPERTY('generate_advice.generate_advice',ENABLED,PROPERTY_TRUE);
                                    --SET_MENU_ITEM_PROPERTY('generate_advice.generate_fla',ENABLED,PROPERTY_FALSE);
                                    --SET_MENU_ITEM_PROPERTY('generate_advice.loa',ENABLED,PROPERTY_FALSE);
                                    --SET_MENU_ITEM_PROPERTY('generate_advice.cash_settlement',ENABLED,PROPERTY_FALSE);
                                    v_claims.generate_advice := 'Y';
                                    v_claims.sub_generate_advice := 'Y';
                                    v_claims.generate_fla := 'N';
                                    v_claims.generate_loa := 'N';
                                    v_claims.generate_cash_settlement := 'N';

                                    BEGIN
                                       SELECT DISTINCT 'x'
                                                  INTO v_exist
                                                  FROM gicl_clm_loss_exp
                                                 WHERE claim_id = p_claim_id
                                                   AND item_no = p_item_no
                                                   AND peril_cd = p_peril_cd
                                                   AND dist_sw = 'Y'
                                                   AND (   cancel_sw IS NULL
                                                        OR cancel_sw = 'N'
                                                       )
                                                   AND advice_id IS NOT NULL;

                                       IF v_exist IS NOT NULL
                                       THEN
                                          --SET_MENU_ITEM_PROPERTY('generate_advice.generate_fla',ENABLED,PROPERTY_TRUE);
                                          v_claims.generate_fla := 'Y';

                                          IF v_line_cd = 'MC'
                                          THEN
                                             --SET_MENU_ITEM_PROPERTY('generate_advice.loa',ENABLED,PROPERTY_TRUE);
                                             --SET_MENU_ITEM_PROPERTY('generate_advice.cash_settlement',ENABLED,PROPERTY_TRUE);
                                             v_claims.generate_loa := 'Y';
                                             v_claims.generate_cash_settlement :=
                                                                          'Y';
                                          END IF;
                                       END IF;
                                    EXCEPTION
                                       WHEN NO_DATA_FOUND
                                       THEN
                                          NULL;
                                    END;
                                 END IF;
                              EXCEPTION
                                 WHEN NO_DATA_FOUND
                                 THEN
                                    NULL;
                              END;
                           END IF;
                        EXCEPTION
                           WHEN NO_DATA_FOUND
                           THEN
                              NULL;
                        END;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        BEGIN
                           SELECT DISTINCT 'x'
                                      INTO v_loss_exist
                                      FROM gicl_clm_loss_exp
                                     WHERE claim_id = p_claim_id
                                       AND item_no = p_item_no
                                       AND peril_cd = p_peril_cd
                                       AND (   cancel_sw IS NULL
                                            OR cancel_sw = 'N'
                                           );

                           IF v_loss_exist IS NOT NULL
                           THEN
                              --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_TRUE);
                              v_claims.lossexpense_history := 'Y';

                              BEGIN
                                 SELECT DISTINCT 'x'
                                            INTO v_adv_exist
                                            FROM gicl_clm_loss_exp
                                           WHERE claim_id = p_claim_id
                                             AND item_no = p_item_no
                                             AND peril_cd = p_peril_cd
                                             AND dist_sw = 'Y'
                                             AND (   cancel_sw IS NULL
                                                  OR cancel_sw = 'N'
                                                 );

                                 IF v_adv_exist IS NOT NULL
                                 THEN
                                    --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_TRUE);
                                    --SET_MENU_ITEM_PROPERTY('generate_advice.generate_advice',ENABLED,PROPERTY_TRUE);
                                    --SET_MENU_ITEM_PROPERTY('generate_advice.generate_fla',ENABLED,PROPERTY_FALSE);
                                    --SET_MENU_ITEM_PROPERTY('generate_advice.loa',ENABLED,PROPERTY_FALSE);
                                    --SET_MENU_ITEM_PROPERTY('generate_advice.cash_settlement',ENABLED,PROPERTY_FALSE);
                                    v_claims.generate_advice := 'Y';
                                    v_claims.sub_generate_advice := 'Y';
                                    v_claims.generate_fla := 'N';
                                    v_claims.generate_loa := 'N';
                                    v_claims.generate_cash_settlement := 'N';

                                    BEGIN
                                       SELECT DISTINCT 'x'
                                                  INTO v_exist
                                                  FROM gicl_clm_loss_exp
                                                 WHERE claim_id = p_claim_id
                                                   AND item_no = p_item_no
                                                   AND peril_cd = p_peril_cd
                                                   AND dist_sw = 'Y'
                                                   AND (   cancel_sw IS NULL
                                                        OR cancel_sw = 'N'
                                                       )
                                                   AND advice_id IS NOT NULL;

                                       IF v_exist IS NOT NULL
                                       THEN
                                          --SET_MENU_ITEM_PROPERTY('generate_advice.generate_fla',ENABLED,PROPERTY_TRUE);
                                          v_claims.generate_fla := 'Y';

                                          IF v_line_cd = 'MC'
                                          THEN
                                             --SET_MENU_ITEM_PROPERTY('generate_advice.loa',ENABLED,PROPERTY_TRUE);
                                             --SET_MENU_ITEM_PROPERTY('generate_advice.cash_settlement',ENABLED,PROPERTY_TRUE);
                                             v_claims.generate_loa := 'Y';
                                             v_claims.generate_cash_settlement :=
                                                                          'Y';
                                          END IF;
                                       END IF;
                                    EXCEPTION
                                       WHEN NO_DATA_FOUND
                                       THEN
                                          NULL;
                                    END;
                                 END IF;
                              EXCEPTION
                                 WHEN NO_DATA_FOUND
                                 THEN
                                    NULL;
                              END;
                           END IF;
                        EXCEPTION
                           WHEN NO_DATA_FOUND
                           THEN
                              NULL;
                        END;
                  END;
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  BEGIN
                     SELECT DISTINCT 'x'
                                INTO v_loss_exist
                                FROM gicl_clm_loss_exp
                               WHERE claim_id = p_claim_id
                                 AND item_no = p_item_no
                                 AND peril_cd = p_peril_cd
                                 AND (cancel_sw IS NULL OR cancel_sw = 'N');

                     IF v_loss_exist IS NOT NULL
                     THEN
                        --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_TRUE);
                        v_claims.lossexpense_history := 'Y';

                        BEGIN
                           SELECT DISTINCT 'x'
                                      INTO v_adv_exist
                                      FROM gicl_clm_loss_exp
                                     WHERE claim_id = p_claim_id
                                       AND item_no = p_item_no
                                       AND peril_cd = p_peril_cd
                                       AND dist_sw = 'Y'
                                       AND (   cancel_sw IS NULL
                                            OR cancel_sw = 'N'
                                           );

                           IF v_adv_exist IS NOT NULL
                           THEN
                              --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_TRUE);
                              --SET_MENU_ITEM_PROPERTY('generate_advice.generate_advice',ENABLED,PROPERTY_TRUE);
                              --SET_MENU_ITEM_PROPERTY('generate_advice.generate_fla',ENABLED,PROPERTY_FALSE);
                              --SET_MENU_ITEM_PROPERTY('generate_advice.loa',ENABLED,PROPERTY_FALSE);
                              --SET_MENU_ITEM_PROPERTY('generate_advice.cash_settlement',ENABLED,PROPERTY_FALSE);
                              v_claims.generate_advice := 'Y';
                              v_claims.sub_generate_advice := 'Y';
                              v_claims.generate_fla := 'N';
                              v_claims.generate_loa := 'N';
                              v_claims.generate_cash_settlement := 'N';

                              BEGIN
                                 SELECT DISTINCT 'x'
                                            INTO v_exist
                                            FROM gicl_clm_loss_exp
                                           WHERE claim_id = p_claim_id
                                             AND item_no = p_item_no
                                             AND peril_cd = p_peril_cd
                                             AND dist_sw = 'Y'
                                             AND (   cancel_sw IS NULL
                                                  OR cancel_sw = 'N'
                                                 )
                                             AND advice_id IS NOT NULL;

                                 IF v_exist IS NOT NULL
                                 THEN
                                    --SET_MENU_ITEM_PROPERTY('generate_advice.generate_fla',ENABLED,PROPERTY_TRUE);
                                    v_claims.generate_fla := 'Y';

                                    IF v_line_cd = 'MC'
                                    THEN
                                       --SET_MENU_ITEM_PROPERTY('generate_advice.loa',ENABLED,PROPERTY_TRUE);
                                       --SET_MENU_ITEM_PROPERTY('generate_advice.cash_settlement',ENABLED,PROPERTY_TRUE);
                                       v_claims.generate_loa := 'Y';
                                       v_claims.generate_cash_settlement :=
                                                                          'Y';
                                    END IF;
                                 END IF;
                              EXCEPTION
                                 WHEN NO_DATA_FOUND
                                 THEN
                                    NULL;
                              END;
                           END IF;
                        EXCEPTION
                           WHEN NO_DATA_FOUND
                           THEN
                              NULL;
                        END;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        NULL;
                  END;
            END;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
   END manipulate_menu_dtl;                             --END all item modules

   PROCEDURE manipulate_menu_hist (
      p_claim_id   IN   gicl_claims.claim_id%TYPE,
      p_line_cd    IN   giis_line.line_cd%TYPE
   )
   IS
      v_loss_exist   VARCHAR2 (1);
      v_adv_exist    VARCHAR2 (1);
      v_exist        VARCHAR2 (1);
   BEGIN
      --SET_MENU_ITEM_PROPERTY('claims_menu.lossexpense_history',ENABLED,PROPERTY_TRUE);
      v_claims.lossexpense_history := 'Y';

      BEGIN
         SELECT DISTINCT 'x'
                    INTO v_loss_exist
                    FROM gicl_clm_loss_exp
                   WHERE claim_id = p_claim_id;

         IF v_loss_exist IS NOT NULL
         THEN
            BEGIN
               SELECT DISTINCT 'x'
                          INTO v_adv_exist
                          FROM gicl_clm_loss_exp
                         WHERE claim_id = p_claim_id
                           AND dist_sw = 'Y'
                           AND (cancel_sw IS NULL OR cancel_sw = 'N');

               IF v_adv_exist IS NOT NULL
               THEN
                  --SET_MENU_ITEM_PROPERTY('claims_menu.generate_advice',ENABLED,PROPERTY_TRUE);
                  --SET_MENU_ITEM_PROPERTY('generate_advice.generate_advice',ENABLED,PROPERTY_TRUE);
                  --SET_MENU_ITEM_PROPERTY('generate_advice.generate_fla',ENABLED,PROPERTY_FALSE);
                  --SET_MENU_ITEM_PROPERTY('generate_advice.loa',ENABLED,PROPERTY_FALSE);
                  --SET_MENU_ITEM_PROPERTY('generate_advice.cash_settlement',ENABLED,PROPERTY_FALSE);
                  v_claims.generate_advice := 'Y';
                  v_claims.sub_generate_advice := 'Y';
                  v_claims.generate_fla := 'N';
                  v_claims.generate_loa := 'N';
                  v_claims.generate_cash_settlement := 'N';

                  BEGIN
                     SELECT DISTINCT 'x'
                                INTO v_exist
                                FROM gicl_advice
                               WHERE claim_id = p_claim_id;

                     IF v_exist IS NOT NULL
                     THEN
                        --SET_MENU_ITEM_PROPERTY('generate_advice.generate_fla',ENABLED,PROPERTY_TRUE);
                        v_claims.generate_fla := 'Y';

                        IF p_line_cd = 'MC'
                        THEN
                            --SET_MENU_ITEM_PROPERTY('generate_advice.loa',ENABLED,PROPERTY_TRUE);
                           -- SET_MENU_ITEM_PROPERTY('generate_advice.cash_settlement',ENABLED,PROPERTY_TRUE);
                           v_claims.generate_loa := 'Y';
                           v_claims.generate_cash_settlement := 'Y';
                        END IF;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        NULL;
                  END;
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
   END manipulate_menu_hist;

   FUNCTION enable_menus (
      p_claim_id   IN   gicl_claims.claim_id%TYPE,
      p_param           VARCHAR2
   )
      RETURN gicls_menu_tab PIPELINED
   IS
      v_loss_exist   VARCHAR2 (1);
      v_adv_exist    VARCHAR2 (1);
      v_exist        VARCHAR2 (1);
      v_adv_line     VARCHAR2 (2);
   BEGIN
      v_claims.plr := p_param;
      v_claims.pla := p_param;

      v_claims.lossexpense_history := NULL;
      BEGIN
         SELECT DISTINCT 'X'
                    INTO v_loss_exist
                    FROM gicl_clm_loss_exp
                   WHERE claim_id = p_claim_id;

         IF v_loss_exist IS NOT NULL
         THEN
            --SET_MENU_ITEM_PROPERTY ('CLAIMS_MENU.LOSSEXPENSE_HISTORY',enabled,v_sw );
            v_claims.lossexpense_history := p_param;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_claims.generate_advice := NULL;
      BEGIN
         SELECT DISTINCT 'X'
                    INTO v_adv_exist
                    FROM gicl_clm_loss_exp
                   WHERE claim_id = p_claim_id
                     AND dist_sw = 'Y'
                     AND (cancel_sw IS NULL OR cancel_sw = 'N');

         IF v_adv_exist IS NOT NULL
         THEN
            --SET_MENU_ITEM_PROPERTY ('CLAIMS_MENU.GENERATE_ADVICE', enabled, v_sw);
            v_claims.generate_advice := p_param;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
        
      v_claims.generate_fla := NULL;
      v_claims.generate_loa := NULL;  
      BEGIN
         SELECT DISTINCT 'X', line_cd
                    INTO v_exist, v_adv_line
                    FROM gicl_advice
                   WHERE claim_id = p_claim_id;

         IF v_exist IS NOT NULL
         THEN
            --SET_MENU_ITEM_PROPERTY ('GENERATE_ADVICE.GENERATE_FLA',  enabled,  v_sw );
                v_claims.generate_fla := p_param;
            IF v_adv_line = 'MC'
            THEN
               --SET_MENU_ITEM_PROPERTY ('GENERATE_ADVICE.LOA', enabled, v_sw);
               v_claims.generate_loa := p_param;
            END IF;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
      
      PIPE ROW(v_claims);
   END;
END claims_menu_pkg;
/


