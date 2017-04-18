CREATE OR REPLACE PACKAGE BODY CPI.giiss054_pkg
AS
   FUNCTION get_rec_list (
      p_tariff_zone        giis_tariff_zone.tariff_zone%TYPE,
      p_tariff_zone_desc   giis_tariff_zone.tariff_zone_desc%TYPE,
      p_line_cd            giis_tariff_zone.line_cd%TYPE,
      p_subline_cd         giis_tariff_zone.subline_cd%TYPE,
      p_user_id            VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   a.tariff_zone, a.tariff_zone_desc, a.line_cd,
                   a.subline_cd, a.tarf_cd, a.remarks, a.user_id,
                   a.last_update
              FROM giis_tariff_zone a
             WHERE UPPER (a.tariff_zone) LIKE
                                             UPPER (NVL (p_tariff_zone, '%'))
               AND UPPER (a.tariff_zone_desc) LIKE
                                         UPPER (NVL (p_tariff_zone_desc, '%'))
               AND UPPER (a.line_cd) LIKE UPPER (NVL (p_line_cd, '%'))
               AND UPPER (NVL (a.subline_cd, '%')) LIKE
                                               UPPER (NVL (p_subline_cd, '%'))
               AND check_user_per_line2 (line_cd, NULL, 'GIISS054', p_user_id) =
                                                                             1
          ORDER BY a.tariff_zone)
      LOOP
         v_rec.tariff_zone := i.tariff_zone;
         v_rec.tariff_zone_desc := i.tariff_zone_desc;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.tarf_cd := i.tarf_cd;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');

         BEGIN
            SELECT a.line_name
              INTO v_rec.line_name
              FROM giis_line a
             WHERE a.line_cd = i.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.line_name := NULL;
         END;

         BEGIN
            SELECT a.subline_name
              INTO v_rec.subline_name
              FROM giis_subline a
             WHERE a.subline_cd = i.subline_cd
               AND a.line_cd = i.line_cd; --marco - 08.18.2014
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.subline_name := NULL;
         END;

         BEGIN
            SELECT a.tarf_desc
              INTO v_rec.tarf_desc
              FROM giis_tariff a
             WHERE a.tarf_cd = i.tarf_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.tarf_desc := NULL;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_line_lov (p_user_id VARCHAR2)
      RETURN get_line_lov_tab PIPELINED
   IS
      v_rec   get_line_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.line_cd, c.line_name
                           FROM giis_subline a, giis_line c
                          WHERE a.line_cd = c.line_cd
                            AND check_user_per_line2 (a.line_cd,
                                                      NULL,
                                                      'GIISS054',
                                                      p_user_id
                                                     ) = 1
                            AND EXISTS (
                                   SELECT 1
                                     FROM giis_line b
                                    WHERE b.line_cd = a.line_cd
                                      AND (   b.line_cd = 'FI'
                                           OR b.menu_line_cd = 'FI'
                                          )))
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_subline_lov (p_line_cd VARCHAR2)
      RETURN get_subline_lov_tab PIPELINED
   IS
      v_rec   get_subline_lov_type;
   BEGIN
      FOR i IN (SELECT subline_cd, subline_name
                  FROM giis_subline
                 WHERE line_cd = p_line_cd)
      LOOP
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_tarf_lov
      RETURN get_tarf_lov_tab PIPELINED
   IS
      v_rec   get_tarf_lov_type;
   BEGIN
      FOR i IN (SELECT tarf_cd, tarf_desc
                  FROM giis_tariff)
      LOOP
         v_rec.tarf_cd := i.tarf_cd;
         v_rec.tarf_desc := i.tarf_desc;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE val_add_rec (p_tariff_zone giis_tariff_zone.tariff_zone%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_tariff_zone a
                 WHERE a.tariff_zone = p_tariff_zone)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same tariff_zone.'
            );
         RETURN;
      END IF;
   END;

   PROCEDURE val_del_rec (p_tariff_zone giis_tariff_zone.tariff_zone%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_tariff_rates_hdr a
                 WHERE a.tariff_zone = p_tariff_zone)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_TARIFF_ZONE while dependent record(s) in GIIS_TARIFF_RATES_HDR exists.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_fireitem a
                 WHERE a.tariff_zone = p_tariff_zone)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_TARIFF_ZONE while dependent record(s) in GIPI_FIREITEM exists.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_vehicle a
                 WHERE a.tariff_zone = p_tariff_zone)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_TARIFF_ZONE while dependent record(s) in GIPI_VEHICLE exists.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_wfireitm a
                 WHERE a.tariff_zone = p_tariff_zone)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_TARIFF_ZONE while dependent record(s) in GIPI_WFIREITM exists.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_wvehicle a
                 WHERE a.tariff_zone = p_tariff_zone)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_TARIFF_ZONE while dependent record(s) in GIPI_WVEHICLE exists.'
            );
         RETURN;
      END IF;
   END;

   PROCEDURE set_rec (p_rec giis_tariff_zone%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_tariff_zone
         USING DUAL
         ON (tariff_zone = p_rec.tariff_zone)
         WHEN NOT MATCHED THEN
            INSERT (tariff_zone, tariff_zone_desc, line_cd, subline_cd,
                    tarf_cd, remarks, user_id, last_update)
            VALUES (p_rec.tariff_zone, p_rec.tariff_zone_desc, p_rec.line_cd,
                    p_rec.subline_cd, p_rec.tarf_cd, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET tariff_zone_desc = p_rec.tariff_zone_desc,
                   line_cd = p_rec.line_cd, subline_cd = p_rec.subline_cd,
                   tarf_cd = p_rec.tarf_cd, remarks = p_rec.remarks,
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_tariff_zone giis_tariff_zone.tariff_zone%TYPE)
   AS
   BEGIN
      DELETE FROM giis_tariff_zone a
            WHERE a.tariff_zone = p_tariff_zone;
   END;

   FUNCTION check_giiss054_user_access (p_user_id VARCHAR2)
      RETURN NUMBER
   IS
      v_access   NUMBER := 0;
   BEGIN
      FOR rec IN (SELECT line_cd,
                         check_user_per_line2 (line_cd,
                                               NULL,
                                               'GIISS054',
                                               p_user_id
                                              ) accessrights
                    FROM giis_line
                   WHERE line_cd = 'FI' OR menu_line_cd = 'FI')
      LOOP
         IF rec.accessrights = 1
         THEN
            v_access := 1;
            EXIT;
         END IF;
      END LOOP;

      RETURN v_access;
   END;
END;
/


