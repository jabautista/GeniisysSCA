CREATE OR REPLACE PACKAGE BODY CPI.giiss024_pkg
AS
   FUNCTION get_rec_list (
      p_region_cd       giis_region.region_cd%TYPE,
      p_region_desc     giis_region.region_desc%TYPE,
      p_province_cd     giis_province.province_cd%TYPE,
      p_province_desc   giis_province.province_desc%TYPE,
      p_city_cd         giis_city.city_cd%TYPE,
      p_city            giis_city.city%TYPE,
      p_mode            VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      IF p_mode = 'region'
      THEN
         FOR i IN (SELECT   *
                       FROM giis_region
                      WHERE region_cd LIKE NVL (p_region_cd, region_cd)
                        AND UPPER (region_desc) LIKE
                                              UPPER (NVL (p_region_desc, '%'))
                   ORDER BY region_cd)
         LOOP
            v_rec.region_cd := i.region_cd;
            v_rec.region_desc := i.region_desc;
            v_rec.user_id := i.user_id;
            v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            PIPE ROW (v_rec);
         END LOOP;
      ELSIF p_mode = 'province'
      THEN
         FOR i IN
            (SELECT   *
                 FROM giis_province
                WHERE UPPER (province_cd) LIKE
                                             UPPER (NVL (p_province_cd, '%'))
                  AND UPPER (province_desc) LIKE
                                            UPPER (NVL (p_province_desc, '%'))
                  AND region_cd LIKE NVL (p_region_cd, region_cd)
             ORDER BY province_cd)
         LOOP
            v_rec.province_cd := i.province_cd;
            v_rec.province_desc := i.province_desc;
            v_rec.region_cd := i.region_cd;
            v_rec.remarks := i.remarks;
            v_rec.user_id := i.user_id;
            v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            PIPE ROW (v_rec);
         END LOOP;
      ELSIF p_mode = 'city'
      THEN
         FOR i IN (SELECT   *
                       FROM giis_city
                      WHERE UPPER (city_cd) LIKE UPPER (NVL (p_city_cd, '%'))
                        AND UPPER (city) LIKE UPPER (NVL (p_city, '%'))
                        AND UPPER (province_cd) LIKE
                                              UPPER (NVL (p_province_cd, '%'))
                   ORDER BY city)
         LOOP
            v_rec.city_cd := i.city_cd;
            v_rec.city := i.city;
            v_rec.province_cd := i.province_cd;
            v_rec.remarks := i.remarks;
            v_rec.user_id := i.user_id;
            v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
            PIPE ROW (v_rec);
         END LOOP;
      END IF;

      RETURN;
   END;

   PROCEDURE set_giis_region (p_rec giis_region%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_region
         USING DUAL
         ON (region_cd = p_rec.region_cd)
         WHEN NOT MATCHED THEN
            INSERT (region_cd, region_desc, user_id, last_update)
            VALUES (p_rec.region_cd, p_rec.region_desc, p_rec.user_id,
                    SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET region_desc = p_rec.region_desc, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE set_giis_province (p_rec giis_province%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_province
         USING DUAL
         ON (province_cd = p_rec.province_cd)
         WHEN NOT MATCHED THEN
            INSERT (province_cd, province_desc, region_cd, remarks, user_id,
                    last_update)
            VALUES (p_rec.province_cd, p_rec.province_desc, p_rec.region_cd,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET province_desc = p_rec.province_desc,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE set_giis_city (p_rec giis_city%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_city
         USING DUAL
         ON (city_cd = p_rec.city_cd AND province_cd = p_rec.province_cd)
         WHEN NOT MATCHED THEN
            INSERT (city_cd, city, province_cd, remarks, user_id,
                    last_update)
            VALUES (p_rec.city_cd, p_rec.city, p_rec.province_cd,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET city = p_rec.city, remarks = p_rec.remarks,
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_giis_region (p_region_cd giis_region.region_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_region
            WHERE region_cd = p_region_cd;
   END;

   PROCEDURE del_giis_province (p_province_cd giis_province.province_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_province
            WHERE province_cd = p_province_cd;
   END;

   PROCEDURE del_giis_city (
      p_city_cd       giis_city.city_cd%TYPE,
      p_province_cd   giis_city.province_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_city
            WHERE city_cd = p_city_cd AND province_cd = p_province_cd;
   END;

   PROCEDURE val_del_rec (
      p_rec_cd    VARCHAR2,
      p_rec_cd2   VARCHAR2,
      p_mode      VARCHAR2
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      IF p_mode = 'region'
      THEN
         FOR rec IN (SELECT '1'
                       FROM gipi_wlocation
                      WHERE region_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_REGION while dependent record(s) in GIPI_WLOCATION exists.'
               );
         END IF;

         FOR rec IN (SELECT '1'
                       FROM giis_province
                      WHERE region_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_REGION while dependent record(s) in GIIS_PROVINCE exists.'
               );
         END IF;

         FOR rec IN (SELECT '1'
                       FROM gipi_wpolbas
                      WHERE region_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_REGION while dependent record(s) in GIPI_WPOLBAS exists.'
               );
         END IF;

         FOR rec IN (SELECT '1'
                       FROM gipi_witem
                      WHERE region_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_REGION while dependent record(s) in GIPI_WITEM exists.'
               );
         END IF;

         FOR rec IN (SELECT '1'
                       FROM gipi_polbasic
                      WHERE region_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_REGION while dependent record(s) in GIPI_POLBASIC exists.'
               );
         END IF;

         FOR rec IN (SELECT '1'
                       FROM gipi_item
                      WHERE region_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_REGION while dependent record(s) in GIPI_ITEM exists.'
               );
         END IF;

         FOR rec IN (SELECT '1'
                       FROM gipi_location
                      WHERE region_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_REGION while dependent record(s) in GIPI_LOCATION exists.'
               );
         END IF;
      ELSIF p_mode = 'province'
      THEN
         FOR rec IN (SELECT '1'
                       FROM gipi_wlocation
                      WHERE province_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_PROVINCE while dependent record(s) in GIPI_WLOCATION exists.'
               );
         END IF;

         FOR rec IN (SELECT '1'
                       FROM giis_city
                      WHERE province_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_PROVINCE while dependent record(s) in GIIS_CITY exists.'
               );
         END IF;

         FOR rec IN (SELECT '1'
                       FROM gipi_location
                      WHERE province_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_PROVINCE while dependent record(s) in GIPI_LOCATION exists.'
               );
         END IF;
      ELSIF p_mode = 'city'
      THEN
         FOR rec IN (SELECT '1'
                       FROM giis_block
                      WHERE province_cd = p_rec_cd2 AND city_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_CITY while dependent record(s) in GIIS_BLOCK exists.'
               );
         END IF;
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_rec_cd    VARCHAR2,
      p_rec_cd2   VARCHAR2,
      p_mode      VARCHAR2
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      IF p_mode = 'region'
      THEN
         FOR i IN (SELECT '1'
                     FROM giis_region a
                    WHERE a.region_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Record already exists with the same region_cd.'
               );
         END IF;
      ELSIF p_mode = 'province'
      THEN
         FOR i IN (SELECT '1'
                     FROM giis_province a
                    WHERE a.province_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Record already exists with the same province_cd.'
               );
         END IF;

         FOR i IN (SELECT '1'
                     FROM giis_province a
                    WHERE a.province_desc = p_rec_cd2)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Record already exists with the same province_desc.'
               );
         END IF;
      ELSIF p_mode = 'city'
      THEN
         FOR i IN (SELECT '1'
                     FROM giis_city a
                    WHERE province_cd = p_rec_cd2 AND city_cd = p_rec_cd)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Record already exists with the same city_cd and province_cd.'
               );
         END IF;
      END IF;
   END;
END;
/


