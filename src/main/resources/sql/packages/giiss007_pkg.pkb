CREATE OR REPLACE PACKAGE BODY CPI.giiss007_pkg
AS
   FUNCTION get_province_rec_list
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT DISTINCT province_cd
                           FROM giis_block
                       ORDER BY province_cd)
      LOOP
         v_rec.province_cd := i.province_cd;

         BEGIN
            FOR j IN (SELECT province_desc
                        FROM giis_province
                       WHERE province_cd = i.province_cd)
            LOOP
               v_rec.province := j.province_desc;
               EXIT;
            END LOOP;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_province_rec_list;

   FUNCTION get_city_rec_list (p_province_cd giis_block.province_cd%TYPE)
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT DISTINCT city_cd
                           FROM giis_block
                          WHERE province_cd = p_province_cd
                       ORDER BY city_cd)
      LOOP
         v_rec.province_cd := p_province_cd;
         v_rec.city_cd := i.city_cd;

         FOR j IN (SELECT city
                     FROM giis_city
                    WHERE city_cd = i.city_cd
                    AND province_cd = p_province_cd) --added by carlo 02-17-2017 SR-23842
         LOOP
            v_rec.city := j.city;
            EXIT;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_city_rec_list;

   FUNCTION get_district_rec_list (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT DISTINCT district_no, district_desc
                           FROM giis_block
                          WHERE province_cd = p_province_cd
                            AND city_cd = p_city_cd
                       ORDER BY district_no)
      LOOP
         v_rec.province_cd := p_province_cd;
         v_rec.city_cd := p_city_cd;
         v_rec.district_no := i.district_no;
         v_rec.district_desc := i.district_desc;
         
         BEGIN
            SELECT DISTINCT sheet_no
              INTO v_rec.sheet_no
              FROM giis_block
             WHERE province_cd = p_province_cd
               AND city_cd = p_city_cd
               AND district_no = i.district_no; 
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_rec.sheet_no := NULL;
         END;
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_district_rec_list;

   FUNCTION get_block_rec_list (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE,
      p_district_no   giis_block.district_no%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   province_cd, city_cd, district_no, block_id,
                         block_no, block_desc, eq_zone, flood_zone,
                         typhoon_zone, retn_lim_amt, trty_lim_amt, sheet_no,
                         netret_beg_bal, facul_beg_bal, trty_beg_bal,
                         remarks, user_id, last_update, active_tag
                    FROM giis_block
                   WHERE province_cd = p_province_cd
                     AND city_cd = p_city_cd
                     AND district_no = p_district_no
                ORDER BY province_cd, city, district_no, block_no)
      LOOP
         v_rec.province_cd := i.province_cd;
         v_rec.city_cd := i.city_cd;
         v_rec.district_no := i.district_no;
         v_rec.block_id := i.block_id;
         v_rec.block_no := i.block_no;
         v_rec.block_desc := i.block_desc;
         v_rec.eq_zone := i.eq_zone;
         v_rec.flood_zone := i.flood_zone;
         v_rec.typhoon_zone := i.typhoon_zone;
         v_rec.retn_lim_amt := i.retn_lim_amt;
         v_rec.trty_lim_amt := i.trty_lim_amt;
         v_rec.sheet_no := i.sheet_no;
         v_rec.netret_beg_bal := i.netret_beg_bal;
         v_rec.facul_beg_bal := i.facul_beg_bal;
         v_rec.trty_beg_bal := i.trty_beg_bal;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_rec.active_tag := i.active_tag;

         BEGIN
            SELECT eq_desc
              INTO v_rec.eq_zone_desc
              FROM giis_eqzone
             WHERE eq_zone = i.eq_zone;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_rec.eq_zone_desc := NULL;   
         END;

         BEGIN
            SELECT flood_zone_desc
              INTO v_rec.flood_zone_desc
              FROM giis_flood_zone
             WHERE flood_zone = i.flood_zone;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_rec.flood_zone_desc := NULL;            
         END;

         BEGIN
            SELECT typhoon_zone_desc
              INTO v_rec.typhoon_zone_desc
              FROM giis_typhoon_zone
             WHERE typhoon_zone = i.typhoon_zone;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_rec.typhoon_zone_desc := NULL;
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_block_rec_list;

   FUNCTION get_risks_rec_list (p_block_id giis_block.block_id%TYPE)
      RETURN risks_rec_tab PIPELINED
   IS
      v_rec   risks_rec_type;
   BEGIN
      FOR i IN (SELECT risk_cd, risk_desc
                  FROM giis_risks
                 WHERE block_id = p_block_id)
      LOOP
         v_rec.risk_cd := i.risk_cd;
         v_rec.risk_desc := i.risk_desc;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_risks_rec_list;

   FUNCTION get_province_lov
      RETURN rec_tab PIPELINED
   IS
      v_list   rec_type;
   BEGIN
      FOR i IN (SELECT DISTINCT province_cd, province_desc
                           FROM giis_province
                          WHERE province_cd NOT IN (
                                                  SELECT DISTINCT province_cd
                                                             FROM giis_block)
                       ORDER BY province_cd)
      LOOP
         v_list.province_cd := i.province_cd;
         v_list.province := i.province_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_province_lov;

   FUNCTION get_city_lov (p_province_cd giis_block.province_cd%TYPE)
      RETURN rec_tab PIPELINED
   IS
      v_list   rec_type;
   BEGIN
      FOR i IN (SELECT DISTINCT city_cd, city
                           FROM giis_city
                          WHERE province_cd = p_province_cd
                            AND city_cd NOT IN (
                                             SELECT DISTINCT city_cd
                                                        FROM giis_block
                                                       WHERE province_cd =
                                                                 p_province_cd)
                       ORDER BY city_cd)
      LOOP
         v_list.city_cd := i.city_cd;
         v_list.city := i.city;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_city_lov;

   FUNCTION get_eq_zone_lov
      RETURN eq_zone_rec_tab PIPELINED
   IS
      v_list   eq_zone_rec_type;
   BEGIN
      FOR i IN (SELECT eq_zone, eq_desc
                  FROM giis_eqzone)
      LOOP
         v_list.eq_zone := i.eq_zone;
         v_list.eq_desc := i.eq_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_eq_zone_lov;

   FUNCTION get_flood_zone_lov
      RETURN flood_zone_rec_tab PIPELINED
   IS
      v_list   flood_zone_rec_type;
   BEGIN
      FOR i IN (SELECT flood_zone, flood_zone_desc
                  FROM giis_flood_zone)
      LOOP
         v_list.flood_zone := i.flood_zone;
         v_list.flood_zone_desc := i.flood_zone_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_flood_zone_lov;

   FUNCTION get_typhoon_zone_lov
      RETURN typhoon_zone_rec_tab PIPELINED
   IS
      v_list   typhoon_zone_rec_type;
   BEGIN
      FOR i IN (SELECT typhoon_zone, typhoon_zone_desc
                  FROM giis_typhoon_zone)
      LOOP
         v_list.typhoon_zone := i.typhoon_zone;
         v_list.typhoon_zone_desc := i.typhoon_zone_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_typhoon_zone_lov;

   PROCEDURE val_del_rec_risk (
      p_block_id   giis_risks.block_id%TYPE,
      p_risk_cd    giis_risks.risk_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_wfireitm a
                 WHERE a.block_id = p_block_id AND a.risk_cd = p_risk_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_RISKS while dependent record(s) in GIPI_WFIREITM exists.#'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_fireitem a
                 WHERE a.block_id = p_block_id AND a.risk_cd = p_risk_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_RISKS while dependent record(s) in GIPI_FIREITEM exists.#'
            );
         RETURN;
      END IF;
   END;

   PROCEDURE val_add_rec_risk (
      p_block_id    giis_risks.block_id%TYPE,
      p_risk_cd     giis_risks.risk_cd%TYPE,
      p_risk_desc   giis_risks.risk_desc%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_risks a
                 WHERE a.block_id = p_block_id AND a.risk_cd = p_risk_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same risk_cd.#'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM giis_risks a
                 WHERE a.block_id = p_block_id AND a.risk_desc = p_risk_desc)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same risk_desc.#'
            );
         RETURN;
      END IF;
   END;

   PROCEDURE del_rec_risk (
      p_block_id   giis_risks.block_id%TYPE,
      p_risk_cd    giis_risks.risk_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_risks a
            WHERE a.block_id = p_block_id AND a.risk_cd = p_risk_cd;
   END;

   PROCEDURE set_rec_risk (p_rec giis_risks%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_risks
         USING DUAL
         ON (block_id = p_rec.block_id AND risk_cd = p_rec.risk_cd)
         WHEN NOT MATCHED THEN
            INSERT (block_id, risk_cd, risk_desc, user_id, last_update)
            VALUES (p_rec.block_id, p_rec.risk_cd, p_rec.risk_desc,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET risk_desc = p_rec.risk_desc, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE val_add_rec_block (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE,
      p_district_no   giis_block.district_no%TYPE,
      p_block_no      giis_block.block_no%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_block a
                 WHERE a.province_cd = p_province_cd
                   AND a.city_cd = p_city_cd
                   AND district_no = p_district_no
                   AND block_no = p_block_no)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same province_cd, city_cd, district_no and block_no.#'
            );
         RETURN;
      END IF;
   END;

   PROCEDURE val_del_rec_block (p_block_id giis_block.block_id%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_risks
                 WHERE block_id = p_block_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_BLOCK while dependent record(s) in GIIS_RISKS exists.#'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_district_block
                 WHERE block_id = p_block_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_BLOCK while dependent record(s) in GIPI_DISTRICT_BLOCK exists.#'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_fireitem
                 WHERE block_id = p_block_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_BLOCK while dependent record(s) in GIPI_FIREITEM exists.#'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_wdistrict_block
                 WHERE block_id = p_block_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_BLOCK while dependent record(s) in GIPI_WDISTRICT_BLOCK exists.#'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_wfireitm
                 WHERE block_id = p_block_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_BLOCK while dependent record(s) in GIPI_WFIREITM exists.#'
            );
         RETURN;
      END IF;
   END;

   PROCEDURE set_rec_block (p_rec giis_block%ROWTYPE)
   IS
      v_block_exist    VARCHAR2 (1);
      v_exist          VARCHAR2 (1)               := 'Y';
      v_block_id       giis_block.block_id%TYPE;
      v_counter        NUMBER (10);
      var              NUMBER;
      v_seq_block_id   giis_block.block_id%TYPE;
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_block
                 WHERE block_id = p_rec.block_id)
      LOOP
         v_block_exist := 'Y';
         EXIT;
      END LOOP;

      IF v_block_exist = 'Y'
      THEN
         UPDATE giis_block
            SET block_desc = p_rec.block_desc,
                retn_lim_amt = p_rec.retn_lim_amt,
                trty_lim_amt = p_rec.trty_lim_amt,
                netret_beg_bal = p_rec.netret_beg_bal,
                facul_beg_bal = p_rec.facul_beg_bal,
                trty_beg_bal = p_rec.trty_beg_bal,
                eq_zone = p_rec.eq_zone,
                flood_zone = p_rec.flood_zone,
                typhoon_zone = p_rec.typhoon_zone,
                sheet_no = p_rec.sheet_no,
                district_desc = p_rec.district_desc,
                province = p_rec.province,
                city = p_rec.city,
                active_tag = p_rec.active_tag,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE block_id = p_rec.block_id;
      ELSE
         v_counter := 0;

         WHILE v_exist = 'Y' AND v_counter < 50000001
         LOOP
            v_counter := v_counter + 1;

            IF v_counter = 50000001
            THEN
               FOR a IN (SELECT giis_block_block_id_s.NEXTVAL block_id
                           FROM DUAL)
               LOOP
                  var := a.block_id;

                  FOR b IN (SELECT block_id
                              FROM giis_block)
                  LOOP
                     IF var != b.block_id
                     THEN
                        v_seq_block_id := var;
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
               SELECT giis_block_block_id_s.NEXTVAL
                 INTO v_seq_block_id
                 FROM DUAL;

               v_exist := 'N';

               FOR a IN (SELECT 'A'
                           FROM giis_block
                          WHERE block_id = v_seq_block_id)
               LOOP
                  v_exist := 'Y';
                  EXIT;
               END LOOP;
            END IF;
         END LOOP;

         INSERT INTO giis_block
                     (province_cd, city_cd, district_no,
                      block_id, block_no, block_desc,
                      retn_lim_amt, trty_lim_amt,
                      netret_beg_bal, facul_beg_bal,
                      trty_beg_bal, eq_zone, flood_zone,
                      typhoon_zone, sheet_no,
                      district_desc, province, city,
                      active_tag, remarks, user_id, last_update
                     )
              VALUES (p_rec.province_cd, p_rec.city_cd, p_rec.district_no,
                      v_seq_block_id, p_rec.block_no, p_rec.block_desc,
                      p_rec.retn_lim_amt, p_rec.trty_lim_amt,
                      p_rec.netret_beg_bal, p_rec.facul_beg_bal,
                      p_rec.trty_beg_bal, p_rec.eq_zone, p_rec.flood_zone,
                      p_rec.typhoon_zone, p_rec.sheet_no,
                      p_rec.district_desc, p_rec.province, p_rec.city,
                      p_rec.active_tag, p_rec.remarks, p_rec.user_id, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE update_rec_district (p_rec giis_block%ROWTYPE)
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_block
                 WHERE province_cd = p_rec.province_cd
                   AND city_cd = p_rec.city_cd
                   AND district_no = p_rec.district_no)
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      IF v_exist = 'Y'
      THEN
         UPDATE giis_block
            SET district_desc = p_rec.district_desc,
                sheet_no = p_rec.sheet_no
          WHERE province_cd = p_rec.province_cd
            AND city_cd = p_rec.city_cd
            AND district_no = p_rec.district_no;
      END IF;
   END;

   PROCEDURE del_rec_block (p_block_id giis_block.block_id%TYPE)
   AS
   BEGIN
      DELETE FROM giis_block
            WHERE block_id = p_block_id;
   END;

   PROCEDURE val_del_rec_province (p_province_cd giis_block.province_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT block_id
                  FROM giis_block
                 WHERE province_cd = p_province_cd)
      LOOP
         giiss007_pkg.val_del_rec_block (i.block_id);
      END LOOP;
   END;

   PROCEDURE del_rec_province (p_province_cd giis_block.province_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_block
            WHERE province_cd = p_province_cd;
   END;

   PROCEDURE val_del_rec_city (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT block_id
                  FROM giis_block
                 WHERE province_cd = p_province_cd AND city_cd = p_city_cd)
      LOOP
         giiss007_pkg.val_del_rec_block (i.block_id);
      END LOOP;
   END;

   PROCEDURE del_rec_city (p_rec giis_block%ROWTYPE)
   AS
   BEGIN
      DELETE FROM giis_block
            WHERE province_cd = p_rec.province_cd AND city_cd = p_rec.city_cd;
   END;

   PROCEDURE val_del_rec_district (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE,
      p_district_no   giis_block.district_no%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT block_id
                  FROM giis_block
                 WHERE province_cd = p_province_cd
                   AND city_cd = p_city_cd
                   AND district_no = p_district_no)
      LOOP
         giiss007_pkg.val_del_rec_block (i.block_id);
      END LOOP;
   END;

   PROCEDURE del_rec_district (p_rec giis_block%ROWTYPE)
   AS
   BEGIN
      DELETE FROM giis_block
            WHERE province_cd = p_rec.province_cd
              AND city_cd = p_rec.city_cd
              AND district_no = p_rec.district_no;
   END;
   
   PROCEDURE val_add_rec_district (
      p_province_cd   giis_block.province_cd%TYPE,
      p_city_cd       giis_block.city_cd%TYPE,
      p_district_no   giis_block.district_no%TYPE
   ) AS
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_block
                 WHERE province_cd = p_province_cd
                   AND city_cd = p_city_cd
                   AND district_no = p_district_no)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Record already exists with the same district_no.#'); 
      END LOOP;
   END;
END;
/


