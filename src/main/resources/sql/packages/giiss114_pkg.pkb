CREATE OR REPLACE PACKAGE BODY CPI.giiss114_pkg
AS
   FUNCTION get_basic_color_rec_list (
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE,
      p_basic_color      giis_mc_color.basic_color%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT a.basic_color_cd, a.basic_color
                     FROM giis_mc_color a
                    WHERE UPPER (a.basic_color_cd) LIKE
                                          UPPER (NVL (p_basic_color_cd, '%'))
                      AND UPPER (a.basic_color) LIKE
                                              UPPER (NVL (p_basic_color, '%'))
                 ORDER BY a.basic_color_cd)
      LOOP
         v_rec.basic_color_cd := i.basic_color_cd;
         v_rec.basic_color := i.basic_color;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_rec_list (
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE,
      p_color_cd         giis_mc_color.color_cd%TYPE,
      p_color            giis_mc_color.color%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   a.basic_color_cd, a.basic_color, a.color_cd,
                         a.color, a.remarks, a.user_id, a.last_update
                    FROM giis_mc_color a
                   WHERE a.color_cd = NVL (p_color_cd, a.color_cd)
                     AND UPPER (a.color) LIKE UPPER (NVL (p_color, '%'))
                     AND a.basic_color_cd = p_basic_color_cd
                ORDER BY a.color_cd)
      LOOP
         v_rec.basic_color_cd := i.basic_color_cd;
         v_rec.basic_color := i.basic_color;
         v_rec.color_cd := i.color_cd;
         v_rec.color := i.color;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');

         BEGIN
            SELECT COUNT (*)
              INTO v_rec.count_rec
              FROM giis_mc_color
             WHERE basic_color_cd = p_basic_color_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.count_rec := 0;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_mc_color%ROWTYPE)
   IS
      v_exists     VARCHAR2 (1) := 'N';
      v_color_cd   NUMBER;
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_mc_color a
                 WHERE a.basic_color_cd = p_rec.basic_color_cd
                   AND a.color_cd = p_rec.color_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giis_mc_color a
            SET color = p_rec.color,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE a.basic_color_cd = p_rec.basic_color_cd
            AND a.color_cd = p_rec.color_cd;
      ELSIF v_exists = 'N'
      THEN
         v_color_cd := giiss114_pkg.generate_color_cd (p_rec.basic_color_cd);

         INSERT INTO giis_mc_color
                     (basic_color_cd, basic_color, color_cd,
                      color, remarks, user_id, last_update
                     )
              VALUES (p_rec.basic_color_cd, p_rec.basic_color, v_color_cd,
                      p_rec.color, p_rec.remarks, p_rec.user_id, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_rec (p_rec giis_mc_color%ROWTYPE)
   AS
   BEGIN
      DELETE FROM giis_mc_color
            WHERE basic_color_cd = p_rec.basic_color_cd
              AND color_cd = p_rec.color_cd;
   END;

   PROCEDURE del_rec_basic (
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_mc_color
            WHERE basic_color_cd = p_basic_color_cd;
   END;

   PROCEDURE val_del_rec_basic (
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_wvehicle a
                 WHERE a.basic_color_cd = p_basic_color_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_MC_COLOR while dependent record(s) in GIPI_WVEHICLE exists.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_vehicle a
                 WHERE a.basic_color_cd = p_basic_color_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_MC_COLOR while dependent record(s) in GIPI_VEHICLE exists.'
            );
         RETURN;
      END IF;
   
   
      FOR i IN (SELECT color_cd
                  FROM giis_mc_color
                 WHERE basic_color_cd = p_basic_color_cd)
      LOOP
         giiss114_pkg.val_del_rec (i.color_cd);
      END LOOP;
   END;

   PROCEDURE val_del_rec (p_color_cd giis_mc_color.color_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_wvehicle a
                 WHERE a.color_cd = p_color_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_MC_COLOR while dependent record(s) in GIPI_WVEHICLE exists.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_vehicle a
                 WHERE a.color_cd = p_color_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_MC_COLOR while dependent record(s) in GIPI_VEHICLE exists.'
            );
         RETURN;
      END IF;
   END;

   PROCEDURE val_add_rec_basic (
      p_action           VARCHAR2,-- andrew - 08052015 - SR 19241
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE,
      p_basic_color      giis_mc_color.basic_color%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN   
      IF p_action = 'ADD'
      THEN
          FOR i IN (SELECT '1'
                      FROM giis_mc_color a
                     WHERE a.basic_color_cd = p_basic_color_cd)
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;

          IF v_exists = 'Y'
          THEN
             raise_application_error
                (-20001,
                 'Geniisys Exception#E#Record already exists with the same basic_color_cd.'
                );
             RETURN;
          END IF;

          FOR i IN (SELECT '1'
                      FROM giis_mc_color a
                     WHERE a.basic_color = p_basic_color)
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;

          IF v_exists = 'Y'
          THEN
             raise_application_error
                (-20001,
                 'Geniisys Exception#E#Record already exists with the same basic_color.'
                );
             RETURN;
          END IF;
      ELSIF p_action = 'UPDATE'
      THEN      
          FOR i IN(SELECT 1
             FROM gipi_wvehicle a
                 ,giis_mc_color b
            WHERE a.basic_color_cd = b.basic_color_cd
              AND b.basic_color_cd = p_basic_color_cd
              AND UPPER(b.basic_color) <> UPPER(p_basic_color))
          LOOP
             raise_application_error(-20001, 'Geniisys Exception#E#Cannot update record from GIIS_MC_COLOR while dependent record(s) in GIPI_WVEHICLE exists.');-- andrew - 08052015 - SR 19241
          END LOOP;
          
          FOR i IN(SELECT 1
             FROM gipi_vehicle a
                 ,giis_mc_color b
            WHERE a.basic_color_cd = b.basic_color_cd
              AND b.basic_color_cd = p_basic_color_cd
              AND UPPER(b.basic_color) <> UPPER(p_basic_color))
          LOOP
             raise_application_error(-20001, 'Geniisys Exception#E#Cannot update record from GIIS_MC_COLOR while dependent record(s) in GIPI_VEHICLE exists.');-- andrew - 08052015 - SR 19241
          END LOOP;          
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_action           VARCHAR2, -- andrew - 08052015 - SR 19241
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE,
      p_color_cd   giis_mc_color.color_cd%TYPE, -- andrew - 08052015 - SR 19241      
      p_color            giis_mc_color.color%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      IF p_action = 'ADD' -- andrew - 08052015 - SR 19241
      THEN
          FOR i IN (SELECT '1'
                      FROM giis_mc_color a
                     WHERE a.basic_color_cd = p_basic_color_cd
                       AND a.color = p_color)
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;

          IF v_exists = 'Y'
          THEN
             raise_application_error
                (-20001,
                 'Geniisys Exception#E#Record already exists with the same color.'
                );
          END IF;
      ELSIF p_action = 'UPDATE'  -- andrew - 08052015 - SR 19241
      THEN      
          FOR i IN(SELECT 1
             FROM gipi_wvehicle a
                 ,giis_mc_color b
            WHERE a.basic_color_cd = b.basic_color_cd
              AND a.color_cd = b.color_cd
              AND b.basic_color_cd = p_basic_color_cd
              AND b.color_cd = p_color_cd
              AND UPPER(b.color) <> UPPER(p_color))
          LOOP
             raise_application_error(-20001, 'Geniisys Exception#E#Cannot update record from GIIS_MC_COLOR while dependent record(s) in GIPI_WVEHICLE exists.');-- andrew - 08052015 - SR 19241
          END LOOP;
          
          FOR i IN(SELECT 1
             FROM gipi_vehicle a
                 ,giis_mc_color b
            WHERE a.basic_color_cd = b.basic_color_cd
              AND a.color_cd = b.color_cd
              AND b.basic_color_cd = p_basic_color_cd
              AND b.color_cd = p_color_cd
              AND UPPER(b.color) <> UPPER(p_color))
          LOOP
             raise_application_error(-20001, 'Geniisys Exception#E#Cannot update record from GIIS_MC_COLOR while dependent record(s) in GIPI_VEHICLE exists.');-- andrew - 08052015 - SR 19241
          END LOOP;          
      END IF;      
   END;

   FUNCTION generate_color_cd (
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE
   )
      RETURN NUMBER
   IS
      v_exist      VARCHAR2 (1)                  := 'Y';
      v_color_cd   giis_mc_color.color_cd%TYPE;
      v_counter    NUMBER (10);
      var          NUMBER;
      v_return     NUMBER;
   BEGIN
      v_counter := 0;

      WHILE v_exist = 'Y' AND v_counter < 1000000000
      LOOP
         v_counter := v_counter + 1;

         IF v_counter = 1000000000
         THEN
            FOR a IN (SELECT mc_color_color_cd_s.NEXTVAL color_cd
                        FROM DUAL)
            LOOP
               var := a.color_cd;

               FOR b IN (SELECT color_cd
                           FROM giis_mc_color
                          WHERE basic_color_cd = p_basic_color_cd)
               LOOP
                  IF var != b.color_cd
                  THEN
                     v_return := var;
                     v_exist := 'N';
                     EXIT;
                  END IF;
               END LOOP;

               IF v_exist = 'N'
               THEN
                  EXIT;
               END IF;
            END LOOP;
         ELSE
            SELECT mc_color_color_cd_s.NEXTVAL
              INTO v_return
              FROM DUAL;

            v_exist := 'N';

            FOR a IN (SELECT 'A'
                        FROM giis_mc_color
                       WHERE color_cd = v_return)
            LOOP
               v_exist := 'Y';
               EXIT;
            END LOOP;
         END IF;
      END LOOP;

      RETURN v_return;
   END;

   PROCEDURE update_basic_rec (p_rec giis_mc_color%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_mc_color
         USING DUAL
         ON (basic_color_cd = p_rec.basic_color_cd)
         WHEN MATCHED THEN
            UPDATE
               SET basic_color = p_rec.basic_color, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;
END;
/


