CREATE OR REPLACE PACKAGE BODY CPI.gisms011_pkg
AS
   FUNCTION get_rec (p_param_name giis_parameters.param_name%TYPE)
      RETURN rec_tab PIPELINED
   IS
      v_rec             rec_type;
      v_param_value_v   VARCHAR2 (200);
      v_temp            VARCHAR2 (200);
      v_count           NUMBER         := 0;
      ctr               NUMBER         := 0;
   BEGIN
      /*
      **NETWORK NUMBERS
      */
      SELECT param_value_v
        INTO v_param_value_v
        FROM giis_parameters
       WHERE param_name = NVL (p_param_name, 'GLOBE_NUMBER');

      /* Get the number of "," */
      LOOP
         v_count := v_count + 1;
         ctr := INSTR (v_param_value_v, ',', 1, v_count);
         EXIT WHEN ctr = 0 OR ctr IS NULL;
      END LOOP;

      IF v_count > 1
      THEN                                         --if comma exist, do substr
         FOR i IN 1 .. v_count
         LOOP
            v_rec.tbg_id := i;
            v_rec.param_name := NVL (p_param_name, 'GLOBE_NUMBER');
            v_temp :=
               SUBSTR (v_param_value_v,
                       1,
                       INSTR (v_param_value_v, ',', 1, 1) - 1
                      );

            IF v_temp IS NOT NULL
            THEN
               v_rec.network_number := v_temp;
            ELSE
               v_rec.network_number := v_param_value_v;
            END IF;

            v_param_value_v :=
               SUBSTR (v_param_value_v, INSTR (v_param_value_v, ',', 1, 1) + 1);
            PIPE ROW (v_rec);
         END LOOP;
      ELSIF v_count = 1 AND v_param_value_v IS NOT NULL
      THEN                                            -- if comma doesnt exist
         v_rec.network_number := v_param_value_v;
         v_rec.param_name := NVL (p_param_name, 'GLOBE_NUMBER');
         v_rec.tbg_id := 1;
         PIPE ROW (v_rec);
      END IF;

      RETURN;
   END;

   PROCEDURE set_rec (
      p_rec              giis_parameters%ROWTYPE,
      p_tbg_id           NUMBER,
      p_network_number   VARCHAR2
   )
   IS
      v_param_value_v       VARCHAR2 (200);
      v_temp                VARCHAR2 (200);
      v_count               NUMBER         := 0;
      v_ctr                 NUMBER         := 0;
      v_old_param_value_v   VARCHAR2 (200);
      v_tbg_id              NUMBER         := 0;
      v_new_param_value_v   VARCHAR2 (200);
   BEGIN
      SELECT param_value_v
        INTO v_param_value_v
        FROM giis_parameters
       WHERE param_name = p_rec.param_name;

      v_old_param_value_v := v_param_value_v;

      /* Get the number of "," */
      LOOP
         v_count := v_count + 1;
         v_ctr := INSTR (v_param_value_v, ',', 1, v_count);
         EXIT WHEN v_ctr = 0 OR v_ctr IS NULL;
      END LOOP;

      IF p_tbg_id != 0
      THEN                                                 --update the number
         IF v_count > 1
         THEN                 --if comma exist,(more than 1 entry ) do substr
            FOR i IN 1 .. v_count
            LOOP
               v_temp :=
                  SUBSTR (v_param_value_v,
                          1,
                          INSTR (v_param_value_v, ',', 1, 1) - 1
                         );
               v_tbg_id := i;

               IF v_tbg_id = p_tbg_id        --check what number to be updated
               THEN
                  IF v_temp IS NOT NULL
                  THEN
                     v_new_param_value_v :=
                               v_new_param_value_v || p_network_number || ',';
                  ELSE
                     v_new_param_value_v :=
                                      v_new_param_value_v || p_network_number;
                  END IF;
               ELSE
                  IF v_temp IS NOT NULL
                  THEN
                     v_new_param_value_v :=
                                         v_new_param_value_v || v_temp || ',';
                  ELSE
                     v_new_param_value_v :=
                                       v_new_param_value_v || v_param_value_v;
                  END IF;
               END IF;

               v_param_value_v :=
                  SUBSTR (v_param_value_v,
                          INSTR (v_param_value_v, ',', 1, 1) + 1
                         );
            END LOOP;
         ELSIF v_count = 1 AND v_old_param_value_v IS NOT NULL
         THEN
            -- if comma doesnt exist (1 number)
            v_new_param_value_v := p_network_number;
         END IF;
      ELSE                                                   -- add new number
         IF v_count > 1
         THEN
            v_new_param_value_v :=
                               v_old_param_value_v || ',' || p_network_number;
         -- if comma doesnt exist (1 number)
         ELSIF v_count = 1 AND v_old_param_value_v IS NOT NULL
         THEN
            v_new_param_value_v :=
                               v_old_param_value_v || ',' || p_network_number;
         -- if comma doesnt exist (0 number)
         ELSIF v_count = 1 AND v_old_param_value_v IS NULL
         THEN
            v_new_param_value_v := p_network_number;
         END IF;
      END IF;

      MERGE INTO giis_parameters
         USING DUAL
         ON (param_name = p_rec.param_name)
         WHEN MATCHED THEN
            UPDATE
               SET param_value_v = v_new_param_value_v,
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE val_assd_name_format (p_assd_name_format VARCHAR2)
   AS
      assd_length   NUMBER;
      ctra          NUMBER;
      assd_format   VARCHAR2 (100);
      temp1         VARCHAR2 (3);
      temp2         VARCHAR2 (3);
   BEGIN
      --CHECK ASSD_NAME--
      assd_length := LENGTH (p_assd_name_format);
      ctra :=
           assd_length
         - LENGTH (REPLACE (REPLACE (p_assd_name_format, '<', NULL), '>',
                            NULL)
                  );              --count number of <>; must have a value of 6
      assd_format :=
         REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (p_assd_name_format,
                                                      'LN',
                                                      NULL
                                                     ),
                                             'FN',
                                             NULL
                                            ),
                                    'MI',
                                    NULL
                                   ),
                           ' ',
                           NULL
                          ),
                  ',',
                  NULL
                 );

      IF ctra <> 6 OR assd_format NOT LIKE '<><><>'
      THEN
         raise_application_error
              (-20001,
               'Geniisys Exception#I#LN, FN, MI should be enclosed with <>.#'
              );
         RETURN;
      END IF;

      FOR i IN 1 .. 3
      LOOP
         temp1 :=
            SUBSTR (p_assd_name_format,
                    INSTR (p_assd_name_format, '<', 1, i) + 1,
                    3
                   );

         FOR j IN (i + 1) .. 3
         LOOP
            temp2 :=
               SUBSTR (p_assd_name_format,
                       INSTR (p_assd_name_format, '<', 1, j) + 1,
                       3
                      );

            IF temp1 LIKE temp2
            THEN
               raise_application_error
                            (-20001,
                             'Geniisys Exception#I#Values should be unique.#'
                            );
               RETURN;
            END IF;
         END LOOP;

         IF temp1 NOT LIKE 'LN>'
         THEN
            IF temp1 NOT LIKE 'FN>'
            THEN
               IF temp1 NOT LIKE 'MI>'
               THEN
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#I#LN, FN, and MI are the only values that should be enclosed with <>.#'
                     );
                  RETURN;
               END IF;
            END IF;
         END IF;
      END LOOP;
   END;

   PROCEDURE val_intm_name_format (p_intm_name_format VARCHAR2)
   AS
      intm_length   NUMBER;
      ctra          NUMBER;
      intm_format   VARCHAR2 (100);
      temp1         VARCHAR2 (3);
      temp2         VARCHAR2 (3);
   BEGIN
      --CHECK INTM_NAME--
      intm_length := LENGTH (p_intm_name_format);
      ctra :=
           intm_length
         - LENGTH (REPLACE (REPLACE (p_intm_name_format, '<', NULL), '>',
                            NULL)
                  );              --count number of <>; must have a value of 6
      intm_format :=
         REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (p_intm_name_format,
                                                      'LN',
                                                      NULL
                                                     ),
                                             'FN',
                                             NULL
                                            ),
                                    'MI',
                                    NULL
                                   ),
                           ' ',
                           NULL
                          ),
                  ',',
                  NULL
                 );

      IF NVL (ctra, 0) <> 6 OR intm_format NOT LIKE '<><><>'
      THEN
         raise_application_error
              (-20001,
               'Geniisys Exception#I#LN, FN, MI should be enclosed with <>.#'
              );
         RETURN;
      END IF;

      FOR i IN 1 .. 3
      LOOP
         temp1 :=
            SUBSTR (p_intm_name_format,
                    INSTR (p_intm_name_format, '<', 1, i) + 1,
                    3
                   );

         FOR j IN (i + 1) .. 3
         LOOP
            temp2 :=
               SUBSTR (p_intm_name_format,
                       INSTR (p_intm_name_format, '<', 1, j) + 1,
                       3
                      );

            IF temp1 LIKE temp2
            THEN
               raise_application_error
                            (-20001,
                             'Geniisys Exception#I#Values should be unique.#'
                            );
               RETURN;
            END IF;
         END LOOP;

         IF temp1 NOT LIKE 'LN>'
         THEN
            IF temp1 NOT LIKE 'FN>'
            THEN
               IF temp1 NOT LIKE 'MI>'
               THEN
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#I#LN, FN, and MI are the only values that should be enclosed with <>.#'
                     );
                  RETURN;
               END IF;
            END IF;
         END IF;
      END LOOP;
   END;

   PROCEDURE val_add_rec (
      p_param_name       giis_parameters.param_name%TYPE,
      p_network_number   VARCHAR2
   )
   AS
      v_param_value_v   VARCHAR2 (200);
      v_temp            VARCHAR2 (200);
      v_count           NUMBER         := 0;
      ctr               NUMBER         := 0;
   BEGIN
      /*
         **NETWORK NUMBERS
         */
      SELECT param_value_v
        INTO v_param_value_v
        FROM giis_parameters
       WHERE param_name = NVL (p_param_name, 'GLOBE_NUMBER');

      /* Get the number of "," */
      LOOP
         v_count := v_count + 1;
         ctr := INSTR (v_param_value_v, ',', 1, v_count);
         EXIT WHEN ctr = 0 OR ctr IS NULL;
      END LOOP;

      IF v_count > 1
      THEN                                         --if comma exist, do substr
         FOR i IN 1 .. v_count
         LOOP
            v_temp :=
               SUBSTR (v_param_value_v,
                       1,
                       INSTR (v_param_value_v, ',', 1, 1) - 1
                      );

            IF v_temp IS NOT NULL
            THEN
               IF v_temp = p_network_number
               THEN
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#E#Record already exists with the same param_value_v.#'
                     );
               END IF;
            ELSE
               IF v_param_value_v = p_network_number
               THEN
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#E#Record already exists with the same param_value_v.#'
                     );
               END IF;
            END IF;

            v_param_value_v :=
               SUBSTR (v_param_value_v, INSTR (v_param_value_v, ',', 1, 1) + 1);
         END LOOP;
      ELSIF v_count = 1 AND v_param_value_v IS NOT NULL
      THEN                                            -- if comma doesnt exist
         IF v_param_value_v = p_network_number
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Record already exists with the same param_value_v.#'
               );
         END IF;
      END IF;
   END;

   PROCEDURE delete_rec (
      p_rec              giis_parameters%ROWTYPE,
      p_network_number   VARCHAR2
   )
   IS
      v_param_value_v       VARCHAR2 (200);
      v_temp                VARCHAR2 (200);
      v_count               NUMBER         := 0;
      v_ctr                 NUMBER         := 0;
      v_old_param_value_v   VARCHAR2 (200);
      v_tbg_id              NUMBER         := 0;
      v_new_param_value_v   VARCHAR2 (200) := '';
   BEGIN
      SELECT param_value_v
        INTO v_param_value_v
        FROM giis_parameters
       WHERE param_name = p_rec.param_name;

      v_old_param_value_v := v_param_value_v;

      /* Get the number of "," */
      LOOP
         v_count := v_count + 1;
         v_ctr := INSTR (v_param_value_v, ',', 1, v_count);
         EXIT WHEN v_ctr = 0 OR v_ctr IS NULL;
      END LOOP;

      IF v_count > 1
      THEN                     --if comma exist,(more than 1 entry ) do substr
         FOR i IN 1 .. v_count
         LOOP
            v_temp :=
               SUBSTR (v_param_value_v,
                       1,
                       INSTR (v_param_value_v, ',', 1, 1) - 1
                      );

            IF v_temp IS NOT NULL
            THEN
               IF v_temp != p_network_number
               THEN
                  v_new_param_value_v := v_new_param_value_v || v_temp || ',';
               END IF;
            ELSE
               IF v_param_value_v != p_network_number
               THEN
                  v_new_param_value_v :=
                                       v_new_param_value_v || v_param_value_v;
               ELSIF v_param_value_v = p_network_number
               THEN
                  v_new_param_value_v :=
                     SUBSTR (v_new_param_value_v,
                             1,
                             LENGTH (v_new_param_value_v) - 1
                            );
               END IF;
            END IF;

            v_param_value_v :=
               SUBSTR (v_param_value_v, INSTR (v_param_value_v, ',', 1, 1) + 1);
         END LOOP;
      ELSIF v_count = 1 AND v_old_param_value_v IS NOT NULL
      THEN
         -- if comma doesnt exist (1 number)
         IF v_param_value_v = p_network_number
         THEN
            v_new_param_value_v := '';
         END IF;
      END IF;

      MERGE INTO giis_parameters
         USING DUAL
         ON (param_name = p_rec.param_name)
         WHEN MATCHED THEN
            UPDATE
               SET param_value_v = v_new_param_value_v,
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE set_name_format (p_rec giac_parameters%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giac_parameters
         USING DUAL
         ON (param_name = p_rec.param_name)
         WHEN MATCHED THEN
            UPDATE
               SET param_value_v = p_rec.param_value_v,
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;
END;
/


