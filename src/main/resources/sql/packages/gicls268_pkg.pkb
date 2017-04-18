CREATE OR REPLACE PACKAGE BODY CPI.gicls268_pkg
AS
   FUNCTION get_gicls268_query (
      p_user_id    giis_users.user_id%TYPE,
      p_plate_no   gicl_mc_tp_dtl.plate_no%TYPE
   )
      RETURN clm_list_per_plate_no_tab PIPELINED
   IS
      v_list   clm_list_per_plate_no_type;
   BEGIN
      FOR i IN
         (SELECT *
            FROM (SELECT DISTINCT claim_id, item_no, plate_no
                    FROM gicl_motor_car_dtl
           UNION
                  SELECT DISTINCT claim_id, item_no, plate_no
                    FROM gicl_mc_tp_dtl)
           WHERE claim_id IN (SELECT DISTINCT claim_id
                                FROM gicl_claims
                               WHERE check_user_per_line2 (line_cd, iss_cd, 'GICLS268', p_user_id) = 1)
               AND plate_no = p_plate_no
          ORDER BY item_no)
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.item_no := i.item_no;
         v_list.plate_no := i.plate_no;
         v_list.claim_no := get_clm_no (i.claim_id);

         DECLARE
            v_type   gicl_mc_tp_dtl.tp_type%TYPE;
         BEGIN
            FOR a IN (SELECT DISTINCT tp_type
                                 FROM gicl_mc_tp_dtl
                                WHERE claim_id = i.claim_id)
            LOOP
               v_type := a.tp_type;
            END LOOP;

            IF v_type = 'A'
            THEN
               v_list.adverse_party := 'Y';
               v_list.third_party := 'N';
            ELSIF v_type = 'T'
            THEN
               v_list.third_party := 'Y';
               v_list.adverse_party := 'N';
            ELSE
               v_list.adverse_party := 'N';
               v_list.third_party := 'N';
            END IF;
         END;

         BEGIN
            SELECT DISTINCT item_title
                       INTO v_list.item_title
                       FROM gicl_clm_item
                      WHERE claim_id = i.claim_id AND item_no = i.item_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.item_title := NULL;
         END;

         BEGIN
            SELECT NVL (SUM (a.loss_reserve), 0),
                   NVL (SUM (a.losses_paid), 0),
                   NVL (SUM (a.expense_reserve), 0),
                   NVL (SUM (a.expenses_paid), 0)
              INTO v_list.loss_reserve,
                   v_list.losses_paid,
                   v_list.expense_reserve,
                   v_list.expenses_paid
              FROM gicl_clm_reserve a
             WHERE a.claim_id = i.claim_id AND a.item_no = i.item_no;
         END;

         BEGIN
            SELECT (   a.line_cd
                    || '-'
                    || a.subline_cd
                    || '-'
                    || a.pol_iss_cd--iss_cd commented and changed by reymon 11152013
                    || '-'
                    || LTRIM (TO_CHAR (a.issue_yy, '09'))
                    || '-'
                    || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                    || '-'
                    || LTRIM (TO_CHAR (a.renew_no, '09'))
                   ),
                   a.assd_no, a.loss_date, b.assd_name,
                   a.clm_file_date, a.recovery_sw,
                   a.subline_cd
              INTO v_list.policy_no,
                   v_list.assd_no, v_list.loss_date, v_list.assured_name,
                   v_list.clm_file_date, v_list.recovery_sw,
                   v_list.subline_cd
              FROM gicl_claims a, giis_assured b
             WHERE a.claim_id = i.claim_id AND a.assd_no = b.assd_no;
         END;

         BEGIN
            SELECT COUNT (*)
              INTO v_list.recovery_det_count
              FROM gicl_clm_recovery
             WHERE claim_id = i.claim_id;
             
            IF v_list.recovery_det_count = 0 THEN
               v_list.recovery_sw := 'N';
            ELSE
               v_list.recovery_sw := 'Y';
            END IF;      
         END;

         BEGIN
            SELECT COUNT (a.claim_id)
              INTO v_list.vehicle_info_count
              FROM gicl_claims a,
                   gicl_clm_recovery b,
                   gicl_motor_car_dtl c,
                   gicl_recovery_payor d
             WHERE a.claim_id = b.claim_id
               AND b.claim_id = c.claim_id
               AND c.claim_id = d.claim_id
               AND b.recovery_id = d.recovery_id
               AND a.plate_no LIKE p_plate_no;
         END;

         BEGIN
            SELECT DISTINCT 1
                       INTO v_list.vehicle_type
                       FROM gicl_mc_tp_dtl
                      WHERE claim_id = i.claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.vehicle_type := 0;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_gicls268_query;

   FUNCTION get_clm_list_per_plate_no (
      p_user_id    giis_users.user_id%TYPE,
      p_plate_no   gicl_mc_tp_dtl.plate_no%TYPE,
      p_search_by_opt     VARCHAR2,
      p_date_as_of        VARCHAR2,
      p_date_to           VARCHAR2,
      p_date_from         VARCHAR2
   )
      RETURN clm_list_per_plate_no_tab PIPELINED
   IS
      v_list   clm_list_per_plate_no_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM TABLE (gicls268_pkg.get_gicls268_query (p_user_id, p_plate_no))
                 WHERE (((DECODE (p_search_by_opt,
                                  'lossDate', TRUNC(loss_date),
                                  'fileDate', TRUNC(clm_file_date)
                                  ) >= TRUNC(TO_DATE (p_date_from, 'MM-DD-YYYY'))
                         )
                            AND (DECODE (p_search_by_opt,
                                         'lossDate', TRUNC(loss_date),
                                         'fileDate', TRUNC(clm_file_date)
                                        ) <= TRUNC(TO_DATE (p_date_to, 'MM-DD-YYYY'))
                                )
                           )
                        OR (DECODE (p_search_by_opt,
                                    'lossDate', TRUNC(loss_date),
                                    'fileDate', TRUNC(clm_file_date)
                                   ) <= TRUNC(TO_DATE (p_date_as_of, 'MM-DD-YYYY'))
                           )
                       ))
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.item_no := i.item_no;
         v_list.plate_no := i.plate_no;
         v_list.claim_no := get_clm_no (i.claim_id);
         v_list.loss_reserve := i.loss_reserve;
         v_list.expense_reserve := i.expense_reserve;
         v_list.losses_paid := i.losses_paid;
         v_list.expenses_paid := i.expenses_paid;
         v_list.assd_no := i.assd_no;
         v_list.assured_name := i.assured_name;
         v_list.policy_no := i.policy_no;
         v_list.recovery_sw := i.recovery_sw;
         v_list.adverse_party := i.adverse_party;
         v_list.third_party := i.third_party;
         v_list.loss_date := i.loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.item_title := i.item_title;
         v_list.vehicle_info_count := i.vehicle_info_count;
         v_list.recovery_det_count := i.recovery_det_count;
         v_list.vehicle_type := i.vehicle_type;
         v_list.subline_cd := i.subline_cd;

         IF v_list.tot_loss_reserve IS NULL
         THEN
            SELECT SUM (loss_reserve), SUM (expense_reserve),
                   SUM (losses_paid), SUM (expenses_paid)
              INTO v_list.tot_loss_reserve, v_list.tot_expense_reserve,
                   v_list.tot_losses_paid, v_list.tot_expenses_paid
              FROM TABLE (gicls268_pkg.get_gicls268_query (p_user_id,
                                                           p_plate_no
                                                          )
                         );
         END IF;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_plate_no_gicls628
      RETURN plate_tab PIPELINED
   IS
      v_list   plate_type;
   BEGIN
      FOR i IN (SELECT DISTINCT b.plate_no
                           FROM gicl_motor_car_dtl a, gicl_claims b
                          WHERE b.plate_no = a.plate_no
                            AND b.claim_id = a.claim_id)
      LOOP
         v_list.plate_no := i.plate_no;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_plate_no_gicls628;

   FUNCTION get_vehicle_info (
      p_vehicle_type   NUMBER,
      p_claim_id       NUMBER,
      p_subline_cd     VARCHAR2
   )
      RETURN vehicle_info_tab PIPELINED
   IS
      v_list   vehicle_info_type;
   BEGIN
      IF p_vehicle_type = 0
      THEN
         FOR i IN (SELECT DISTINCT claim_id, model_year, motor_no, serial_no,
                                   mot_type, NULL other_info, basic_color_cd,
                                   color_cd, motcar_comp_cd car_company_cd,
                                   make_cd, series_cd, drvr_name,
                                   drvr_occ_cd, drvr_age, drvr_sex
                              FROM gicl_motor_car_dtl
                             WHERE claim_id = p_claim_id)
         LOOP
            v_list.model_year := i.model_year;
            v_list.motor_no := i.motor_no;
            v_list.serial_no := i.serial_no;
            v_list.mot_type := i.mot_type;
            v_list.other_info := i.other_info;
            v_list.color_cd := i.color_cd;
            v_list.basic_color_cd := i.basic_color_cd;
            v_list.car_company_cd := i.car_company_cd;
            v_list.make_cd := i.make_cd;
            v_list.series_cd := i.series_cd;
            v_list.drvr_name := i.drvr_name;
            v_list.drvr_age := i.drvr_age;
            v_list.drvr_sex := i.drvr_sex;
            v_list.drvr_occ_cd := i.drvr_occ_cd;
         END LOOP;
      ELSE
         FOR i IN (SELECT DISTINCT claim_id, model_year, motor_no, serial_no,
                                   mot_type, other_info, basic_color_cd,
                                   color_cd, motorcar_comp_cd car_company_cd,
                                   make_cd, series_cd, drvr_name,
                                   drvr_occ_cd, drvr_age, drvr_sex
                              FROM gicl_mc_tp_dtl
                             WHERE claim_id = p_claim_id)
         LOOP
            v_list.model_year := i.model_year;
            v_list.motor_no := i.motor_no;
            v_list.serial_no := i.serial_no;
            v_list.mot_type := i.mot_type;
            v_list.other_info := i.other_info;
            v_list.color_cd := i.color_cd;
            v_list.basic_color_cd := i.basic_color_cd;
            v_list.car_company_cd := i.car_company_cd;
            v_list.make_cd := i.make_cd;
            v_list.series_cd := i.series_cd;
            v_list.drvr_name := i.drvr_name;
            v_list.drvr_age := i.drvr_age;
            v_list.drvr_sex := i.drvr_sex;
            v_list.drvr_occ_cd := i.drvr_occ_cd;
         END LOOP;
      END IF;

      BEGIN
         SELECT DISTINCT motor_type_desc
                    INTO v_list.motor_type_desc
                    FROM giis_motortype
                   WHERE type_cd = v_list.mot_type
                     AND subline_cd = p_subline_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.motor_type_desc := NULL;
      END;

      BEGIN
         SELECT DISTINCT color, basic_color
                    INTO v_list.color, v_list.basic_color
                    FROM giis_mc_color
                   WHERE basic_color_cd = v_list.basic_color_cd
                     AND color_cd = v_list.color_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.color := NULL;
            v_list.basic_color := NULL;
      END;

      BEGIN
         SELECT DISTINCT car_company
                    INTO v_list.car_company
                    FROM giis_mc_car_company
                   WHERE car_company_cd = v_list.car_company_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.car_company := NULL;
      END;

      BEGIN
         SELECT DISTINCT make
                    INTO v_list.make
                    FROM giis_mc_make
                   WHERE make_cd = v_list.make_cd
                     AND car_company_cd = v_list.car_company_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.make := NULL;
      END;

      BEGIN
         SELECT DISTINCT engine_series
                    INTO v_list.engine_series
                    FROM giis_mc_eng_series
                   WHERE make_cd = v_list.make_cd
                     AND car_company_cd = v_list.car_company_cd
                     AND series_cd = v_list.series_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.engine_series := NULL;
      END;

      BEGIN
         SELECT DISTINCT occ_desc
                    INTO v_list.drvr_occ
                    FROM gicl_drvr_occptn
                   WHERE drvr_occ_cd = v_list.drvr_occ_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.drvr_occ := NULL;
      END;

      PIPE ROW (v_list);
      RETURN;
   END get_vehicle_info;
END;
/


