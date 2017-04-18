CREATE OR REPLACE PACKAGE BODY CPI.gipis110_pkg
AS
   /*
   **  Created by        : Steven Ramirez
   **  Date Created      : 10.04.2013
   **  Reference By      : GIPIS110 - View Block Accumulation
   */
   FUNCTION get_province
      RETURN province_tab PIPELINED
   IS
      v_rec   province_type;
   BEGIN
      FOR i IN (SELECT   province_cd, province_desc
                    FROM giis_province
                ORDER BY province_cd)
      LOOP
         v_rec.province_desc := i.province_desc;
         v_rec.province_cd := i.province_cd;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_city (p_province_cd giis_province.province_cd%TYPE)
      RETURN city_tab PIPELINED
   IS
      v_rec   city_type;
   BEGIN
      FOR i IN (SELECT   city, city_cd, province_cd
                    FROM giis_city
                   WHERE province_cd = NVL (p_province_cd, province_cd)
                ORDER BY city)
      LOOP
         v_rec.city := i.city;
         v_rec.city_cd := i.city_cd;

         FOR j IN (SELECT province_cd, province_desc
                     FROM giis_province
                    WHERE province_cd = i.province_cd)
         LOOP
            v_rec.province_desc := j.province_desc;
            v_rec.province_cd := j.province_cd;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION check_fi_access (p_user_id giis_users.user_id%TYPE)
      RETURN NUMBER
   IS
      v_access   NUMBER := 0;
   BEGIN
      FOR rec IN (SELECT line_cd,
                         check_user_per_line2 (line_cd,
                                               NULL,
                                               'GIPIS110',
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

   FUNCTION get_giis_block (
      p_city_cd       giis_block.city_cd%TYPE,
      p_province_cd   giis_block.province_cd%TYPE
   )
      RETURN giis_block_tab PIPELINED
   IS
      v_rec   giis_block_type;
   BEGIN
      FOR i IN (SELECT province_cd, city, city_cd, district_no, block_no,
                       block_desc, block_id, retn_lim_amt, trty_lim_amt,
                       district_desc, remarks
                  FROM giis_block
                 WHERE city_cd = p_city_cd AND province_cd = p_province_cd)
      LOOP
         v_rec.province_cd := i.province_cd;
         v_rec.city := i.city;
         v_rec.city_cd := i.city_cd;
         v_rec.district_no := i.district_no;
         v_rec.block_no := i.block_no;
         v_rec.block_desc := i.block_desc;
         v_rec.block_id := i.block_id;
         v_rec.retn_lim_amt := i.retn_lim_amt;
         v_rec.trty_lim_amt := i.trty_lim_amt;
         v_rec.district_desc := i.district_desc;
         v_rec.remarks := i.remarks;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_giis_block_dtl (
      p_block_id          giis_block.block_id%TYPE,
      p_exclude_not_eff   VARCHAR2,
      p_exclude           VARCHAR2,
      p_user_id           giis_users.user_id%TYPE,
      p_district_no       giis_block.district_no%TYPE,
      p_block_no          giis_block.block_no%TYPE,
      p_province_cd       giis_block.province_cd%TYPE,
      p_city              giis_block.city%TYPE,
      p_bus_type          NUMBER
   )
      RETURN giis_block_dtl_tab PIPELINED
   IS
      v_rec                giis_block_dtl_type;
      v_manual_counter     NUMBER                    := 0;
      v_risk_cd            giis_risks.risk_cd%TYPE;
      v_manual             NUMBER                    := 0;
      v_manual_sum         NUMBER                    := 0;
      v_actual_sum         NUMBER                    := 0;
      v_temporary_sum      NUMBER                    := 0;
      v_sum_tot            NUMBER                    := 0;
      v_block_actual_sum   NUMBER                    := 0;
      v_block_temp_sum     NUMBER                    := 0;
      v_block_manual_sum   NUMBER                    := 0;
      v_block_sum_tot      NUMBER                    := 0;
   BEGIN
      gipis110_pkg.get_block_act_exposures (p_exclude,
                                            p_exclude_not_eff,
                                            p_user_id,
                                            p_district_no,
                                            p_block_no,
                                            p_province_cd,
                                            p_city,
                                            v_rec.actual,
                                            v_block_actual_sum,
                                            null    --nieko 07132016 kb 894
                                           );
      gipis110_pkg.get_block_temp_exposures (p_exclude,
                                             p_exclude_not_eff,
                                             p_user_id,
                                             p_district_no,
                                             p_block_no,
                                             p_province_cd,
                                             p_city,
                                             v_block_temp_sum,
                                             null,    --nieko 07132016 kb 894  
                                             p_bus_type                                           
                                            );

      FOR risk IN (SELECT block_id, risk_cd, risk_desc
                     FROM giis_risks
                   UNION
                   SELECT p_block_id, TO_CHAR (0), 'NO RISK'
                     FROM DUAL)
      LOOP
         IF p_block_id = risk.block_id
         THEN
            v_rec.risk_cd := risk.risk_cd;
            v_rec.risk_desc := risk.risk_desc;
            EXIT;
         ELSE
            v_rec.risk_cd := '0';
            v_rec.risk_desc := 'NO RISK';
         END IF;
      END LOOP;

      FOR i IN (SELECT   *
                    FROM ((SELECT ROWNUM, rv_low_value, rv_meaning, block_id,
                                  risk_cd, risk_desc
                             FROM cg_ref_codes, giis_risks
                            WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE'
                              AND ROWNUM < 4
                           UNION
                           SELECT ROWNUM, rv_low_value, rv_meaning,
                                  p_block_id, TO_CHAR (0), 'NO RISK'
                             FROM cg_ref_codes
                            WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE'
                              AND ROWNUM < 4)
                          UNION ALL
                          (SELECT 4, '', '', 0, '0', 'NO RISK'
                             FROM DUAL
                           UNION ALL
                           SELECT 5, '', '', 0, '0', 'NO RISK'
                             FROM DUAL))
                ORDER BY rv_low_value)
      LOOP
         v_rec.rv_low_value := i.rv_low_value;
         v_rec.rv_meaning := i.rv_meaning;
         v_manual_counter := v_manual_counter + 1;

         IF v_manual_counter < 4
         THEN
            gipis110_pkg.get_itemds_dtl_manual (v_manual_counter,
                                                p_block_id,
                                                v_manual
                                               );
            v_rec.MANUAL := v_manual;

            IF NVL (p_exclude, 'N') = 'Y'
               AND NVL (p_exclude_not_eff, 'N') = 'Y'
            THEN
               FOR x1 IN (SELECT a.line_cd
                            FROM giis_line a
                           WHERE EXISTS (
                                    SELECT 'X'
                                      FROM gixx_block_accumulation_dist
                                     WHERE NVL (endt_expiry_date,
                                                expiry_date) >= SYSDATE
                                       AND eff_date <= SYSDATE
                                       AND line_cd = a.line_cd
                                       AND block_id = p_block_id
                                    UNION
                                    SELECT 'X'
                                      FROM gipi_fire_basic_item_dist_v2
                                     WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                       SYSDATE
                                       AND eff_date <= SYSDATE
                                       AND line_cd = a.line_cd
                                       AND block_id = p_block_id))
               LOOP
                  gipis110_pkg.get_itemds_dtl_act (x1.line_cd,
                                                   p_exclude,
                                                   p_exclude_not_eff,
                                                   p_user_id,
                                                   p_district_no,
                                                   p_block_no,
                                                   p_province_cd,
                                                   p_city,
                                                   i.rv_low_value,
                                                   v_rec.risk_cd,
                                                   v_rec.actual
                                                  );
                  gipis110_pkg.get_itemds_dtl_temp (x1.line_cd,
                                                    p_exclude,
                                                    p_exclude_not_eff,
                                                    p_user_id,
                                                    p_district_no,
                                                    p_block_no,
                                                    p_province_cd,
                                                    p_city,
                                                    i.rv_low_value,
                                                    v_rec.risk_cd,
                                                    v_rec.TEMPORARY,
                                                    p_bus_type
                                                   );
               END LOOP;
            ELSIF     NVL (p_exclude, 'N') = 'Y'
                  AND NVL (p_exclude_not_eff, 'N') = 'N'
            THEN
               FOR x1 IN (SELECT a.line_cd
                            FROM giis_line a
                           WHERE EXISTS (
                                    SELECT 'X'
                                      FROM gixx_block_accumulation_dist
                                     WHERE NVL (endt_expiry_date,
                                                expiry_date) >= SYSDATE
                                       AND block_id = p_block_id
                                       AND line_cd = a.line_cd
                                    UNION
                                    SELECT 'X'
                                      FROM gipi_fire_basic_item_dist_v2
                                     WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                       SYSDATE
                                       AND block_id = p_block_id
                                       AND line_cd = a.line_cd))
               LOOP
                  gipis110_pkg.get_itemds_dtl_act (x1.line_cd,
                                                   p_exclude,
                                                   p_exclude_not_eff,
                                                   p_user_id,
                                                   p_district_no,
                                                   p_block_no,
                                                   p_province_cd,
                                                   p_city,
                                                   i.rv_low_value,
                                                   v_rec.risk_cd,
                                                   v_rec.actual
                                                  );
                  gipis110_pkg.get_itemds_dtl_temp (x1.line_cd,
                                                    p_exclude,
                                                    p_exclude_not_eff,
                                                    p_user_id,
                                                    p_district_no,
                                                    p_block_no,
                                                    p_province_cd,
                                                    p_city,
                                                    i.rv_low_value,
                                                    v_rec.risk_cd,
                                                    v_rec.TEMPORARY,
                                                    p_bus_type
                                                   );
               END LOOP;
            ELSIF     NVL (p_exclude, 'N') = 'N'
                  AND NVL (p_exclude_not_eff, 'N') = 'Y'
            THEN
               FOR x1 IN (SELECT a.line_cd
                            FROM giis_line a
                           WHERE EXISTS (
                                    SELECT 'X'
                                      FROM gixx_block_accumulation_dist
                                     WHERE eff_date <= SYSDATE
                                       AND block_id = p_block_id
                                       AND line_cd = a.line_cd
                                    UNION
                                    SELECT 'X'
                                      FROM gipi_fire_basic_item_dist_v2
                                     WHERE eff_date <= SYSDATE
                                       AND block_id = p_block_id
                                       AND line_cd = a.line_cd))
               LOOP
                  gipis110_pkg.get_itemds_dtl_act (x1.line_cd,
                                                   p_exclude,
                                                   p_exclude_not_eff,
                                                   p_user_id,
                                                   p_district_no,
                                                   p_block_no,
                                                   p_province_cd,
                                                   p_city,
                                                   i.rv_low_value,
                                                   v_rec.risk_cd,
                                                   v_rec.actual
                                                  );
                  gipis110_pkg.get_itemds_dtl_temp (x1.line_cd,
                                                    p_exclude,
                                                    p_exclude_not_eff,
                                                    p_user_id,
                                                    p_district_no,
                                                    p_block_no,
                                                    p_province_cd,
                                                    p_city,
                                                    i.rv_low_value,
                                                    v_rec.risk_cd,
                                                    v_rec.TEMPORARY,
                                                    p_bus_type
                                                   );
               END LOOP;
            ELSIF     NVL (p_exclude, 'N') = 'N'
                  AND NVL (p_exclude_not_eff, 'N') = 'N'
            THEN
               FOR x1 IN (SELECT a.line_cd
                            FROM giis_line a
                           WHERE EXISTS (
                                    SELECT 'X'
                                      FROM gixx_block_accumulation_dist
                                     WHERE block_id = p_block_id
                                       AND line_cd = a.line_cd
                                    UNION
                                    SELECT 'X'
                                      FROM gipi_fire_basic_item_dist_v2
                                     WHERE block_id = p_block_id
                                       AND line_cd = a.line_cd))
               LOOP
                  gipis110_pkg.get_itemds_dtl_act (x1.line_cd,
                                                   p_exclude,
                                                   p_exclude_not_eff,
                                                   p_user_id,
                                                   p_district_no,
                                                   p_block_no,
                                                   p_province_cd,
                                                   p_city,
                                                   i.rv_low_value,
                                                   v_rec.risk_cd,
                                                   v_rec.actual
                                                  );
                  gipis110_pkg.get_itemds_dtl_temp (x1.line_cd,
                                                    p_exclude,
                                                    p_exclude_not_eff,
                                                    p_user_id,
                                                    p_district_no,
                                                    p_block_no,
                                                    p_province_cd,
                                                    p_city,
                                                    i.rv_low_value,
                                                    v_rec.risk_cd,
                                                    v_rec.TEMPORARY,
                                                    p_bus_type
                                                   );
               END LOOP;
            END IF;

            IF v_rec.MANUAL IS NULL
            THEN
               v_rec.MANUAL := 0;
            END IF;

            IF v_rec.actual IS NULL
            THEN
               v_rec.actual := 0;
            END IF;

            IF v_rec.TEMPORARY IS NULL
            THEN
               v_rec.TEMPORARY := 0;
            END IF;

            IF v_risk_cd IS NULL
            THEN
               v_risk_cd := v_rec.risk_cd;
            END IF;
         END IF;

         --reset to zero for new risk.
         IF v_risk_cd <> v_rec.risk_cd
         THEN
            IF v_manual_counter = 4
            THEN
               v_rec.actual := 0;
               v_rec.TEMPORARY := 0;
               v_rec.expo_sum := 0;
            END IF;

            IF v_manual_counter < 4
            THEN
               v_rec.expo_sum := 0;
               v_risk_cd := v_rec.risk_cd;
            END IF;
         END IF;

         IF v_manual_counter < 4
         THEN
            v_block_manual_sum := v_block_manual_sum + v_rec.MANUAL;
            v_block_sum_tot :=
                 NVL (v_block_manual_sum, 0)
               + NVL (v_block_actual_sum, 0)
               + NVL (v_block_temp_sum, 0);
            v_manual_sum := v_manual_sum + v_rec.MANUAL;
            v_actual_sum := NVL (v_actual_sum, 0) + NVL (v_rec.actual, 0);
            v_temporary_sum :=
                            NVL (v_temporary_sum, 0)
                            + NVL (v_rec.TEMPORARY, 0);
            v_sum_tot := v_manual_sum + v_actual_sum + v_temporary_sum;
            v_rec.expo_sum :=
                         NVL (v_rec.MANUAL, 0) + v_rec.actual
                         + v_rec.TEMPORARY;
         END IF;

         IF v_manual_counter = 4
         THEN
            v_rec.MANUAL := v_manual_sum;
            v_rec.actual := v_actual_sum;
            v_rec.TEMPORARY := v_temporary_sum;
            v_rec.expo_sum := v_sum_tot;
            v_rec.rv_meaning := 'Risk Total';
         END IF;

         IF v_manual_counter = 5
         THEN
            v_rec.MANUAL := v_block_manual_sum;
            v_rec.actual := v_block_actual_sum;
            v_rec.TEMPORARY := v_block_temp_sum;
            v_rec.expo_sum := v_block_sum_tot;
            v_rec.rv_meaning := 'Block Total';
         END IF;

         PIPE ROW (v_rec);
      END LOOP;
   END;

   PROCEDURE get_itemds_dtl_manual (
      p_counter             NUMBER,
      p_block_id            giis_block.block_id%TYPE,
      p_manual     IN OUT   NUMBER
   )
   IS
      v_share_type       NUMBER         := 0;
      v_netret_beg_bal   NUMBER         := 0;
      v_trty_beg_bal     NUMBER         := 0;
      v_facul_beg_bal    NUMBER         := 0;
      v_eff_date         VARCHAR2 (100);
      v_expiry           VARCHAR2 (100);
   BEGIN
      FOR i IN (SELECT netret_beg_bal, trty_beg_bal, facul_beg_bal
                  FROM giis_block
                 WHERE block_id = p_block_id)
      LOOP
         v_netret_beg_bal := i.netret_beg_bal;
         v_trty_beg_bal := i.trty_beg_bal;
         v_facul_beg_bal := i.facul_beg_bal;
         EXIT;
      END LOOP;

      IF p_counter = 1
      THEN                                                           --NET RET
         p_manual := NVL (v_netret_beg_bal, 0);
      ELSIF p_counter = 2
      THEN                                                            --TREATY
         p_manual := NVL (v_trty_beg_bal, 0);
      ELSIF p_counter = 3
      THEN                                                             --FACUL
         p_manual := NVL (v_facul_beg_bal, 0);
      END IF;
   END;

   PROCEDURE get_itemds_dtl_act (
      p_line_cd                 VARCHAR2,
      p_exclude                 VARCHAR2,
      p_exclude_not_eff         VARCHAR2,
      p_user_id                 giis_users.user_id%TYPE,
      p_district_no             giis_block.district_no%TYPE,
      p_block_no                giis_block.block_no%TYPE,
      p_province_cd             giis_block.province_cd%TYPE,
      p_city                    giis_block.city%TYPE,
      p_rv_low_value            cg_ref_codes.rv_low_value%TYPE,
      p_risk_cd                 giis_risks.risk_cd%TYPE,
      p_actual            OUT   NUMBER
   )
   IS
      v_dist_tsi   NUMBER         := 0;
      v_eff_date   VARCHAR2 (100);
      v_expiry     VARCHAR2 (100);
   BEGIN
      /*** ACTUAL EXPOSURE ***/
      IF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         FOR d1 IN
            (SELECT SUM (dist_tsi) dist_tsi
               FROM gixx_block_accumulation_dist
              WHERE line_cd = p_line_cd
                AND check_user_per_iss_cd2 (line_cd,
                                            iss_cd,
                                            'GIPIS110',
                                            p_user_id
                                           ) = 1
                --vondanix 3/16/13--
                AND district_no = p_district_no
                AND block_no = p_block_no
                AND province_cd = p_province_cd
                AND city = p_city
                AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08042016 kb 894
                AND expiry_date >= SYSDATE
                AND eff_date <= SYSDATE
                AND p_line_cd || TO_CHAR (share_cd) IN (
                                SELECT a160.line_cd || TO_CHAR (a160.share_cd)
                                  FROM giis_dist_share a160
                                 WHERE a160.share_type = p_rv_low_value)
                AND peril_cd IN (
                                SELECT peril_cd
                                  FROM giis_peril
                                 WHERE peril_type = 'B'
                                       AND line_cd = p_line_cd))
         LOOP
            v_dist_tsi := d1.dist_tsi;
         END LOOP;

         p_actual := NVL (p_actual, 0) + NVL (v_dist_tsi, 0);
      ELSIF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         FOR d1 IN
            (SELECT SUM (dist_tsi) dist_tsi
               FROM gixx_block_accumulation_dist
              WHERE line_cd = p_line_cd
                AND check_user_per_iss_cd2 (line_cd,
                                            iss_cd,
                                            'GIPIS110',
                                            p_user_id
                                           ) = 1
                --vondanix 3/16/13--
                AND district_no = p_district_no
                AND block_no = p_block_no
                AND province_cd = p_province_cd
                AND city = p_city
                AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08042016 kb 894
                AND expiry_date >= SYSDATE
                AND p_line_cd || TO_CHAR (share_cd) IN (
                                SELECT a160.line_cd || TO_CHAR (a160.share_cd)
                                  FROM giis_dist_share a160
                                 WHERE a160.share_type = p_rv_low_value)
                AND peril_cd IN (
                                SELECT peril_cd
                                  FROM giis_peril
                                 WHERE peril_type = 'B'
                                       AND line_cd = p_line_cd))
         LOOP
            v_dist_tsi := d1.dist_tsi;
         END LOOP;

         p_actual := NVL (p_actual, 0) + NVL (v_dist_tsi, 0);
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         FOR d1 IN
            (SELECT SUM (dist_tsi) dist_tsi
               FROM gixx_block_accumulation_dist
              WHERE line_cd = p_line_cd
                AND check_user_per_iss_cd2 (line_cd,
                                            iss_cd,
                                            'GIPIS110',
                                            p_user_id
                                           ) = 1
                --vondanix 3/16/13--
                AND district_no = p_district_no
                AND block_no = p_block_no
                AND province_cd = p_province_cd
                AND city = p_city
                AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08042016 kb 894
                AND eff_date <= SYSDATE
                AND p_line_cd || TO_CHAR (share_cd) IN (
                                SELECT a160.line_cd || TO_CHAR (a160.share_cd)
                                  FROM giis_dist_share a160
                                 WHERE a160.share_type = p_rv_low_value)
                AND peril_cd IN (
                                SELECT peril_cd
                                  FROM giis_peril
                                 WHERE peril_type = 'B'
                                       AND line_cd = p_line_cd))
         LOOP
            v_dist_tsi := d1.dist_tsi;
         END LOOP;

         p_actual := NVL (p_actual, 0) + NVL (v_dist_tsi, 0);
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         FOR d1 IN
            (SELECT SUM (dist_tsi) dist_tsi
               FROM gixx_block_accumulation_dist
              WHERE line_cd = p_line_cd
                AND check_user_per_iss_cd2 (line_cd,
                                            iss_cd,
                                            'GIPIS110',
                                            p_user_id
                                           ) = 1
                --vondanix 3/16/13--
                AND district_no = p_district_no
                AND block_no = p_block_no
                AND province_cd = p_province_cd
                AND city = p_city
                AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08042016 kb 894
                AND p_line_cd || TO_CHAR (share_cd) IN (
                                SELECT a160.line_cd || TO_CHAR (a160.share_cd)
                                  FROM giis_dist_share a160
                                 WHERE a160.share_type = p_rv_low_value)
                AND peril_cd IN (
                                SELECT peril_cd
                                  FROM giis_peril
                                 WHERE peril_type = 'B'
                                       AND line_cd = p_line_cd))
         LOOP
            v_dist_tsi := d1.dist_tsi;
         END LOOP;

         p_actual := NVL (p_actual, 0) + NVL (v_dist_tsi, 0);
      END IF;
   END;

   PROCEDURE get_itemds_dtl_temp (
      p_line_cd                 VARCHAR2,
      p_exclude                 VARCHAR2,
      p_exclude_not_eff         VARCHAR2,
      p_user_id                 giis_users.user_id%TYPE,
      p_district_no             giis_block.district_no%TYPE,
      p_block_no                giis_block.block_no%TYPE,
      p_province_cd             giis_block.province_cd%TYPE,
      p_city                    giis_block.city%TYPE,
      p_rv_low_value            cg_ref_codes.rv_low_value%TYPE,
      p_risk_cd                 giis_risks.risk_cd%TYPE,
      p_temporary         OUT   NUMBER,
      p_bus_type                NUMBER
   )
   IS
      v_dist_tsi   NUMBER;
      v_ri		   VARCHAR2(7);
   BEGIN
      /*** TEMPORARY EXPOSURE ***/
      v_ri := Giacp.v('RI_ISS_CD');
      IF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         FOR d1 IN
            (SELECT a.dist_tsi
               FROM gipi_fire_basic_item_dist_v2 a--, gipi_witem b --nieko 02032017 kb 894
              WHERE 1=1--a.par_id = b.par_id
                AND check_user_per_iss_cd2 (line_cd,
                                            iss_cd,
                                            'GIPIS110',
                                            p_user_id
                                           ) = 1
                -- nieko 07132016 KB 894
                AND line_cd = p_line_cd
                AND district_no = p_district_no
                AND block_no = p_block_no
                AND province_cd = p_province_cd
                AND city = p_city
                AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08042016 kb 894
                AND NVL (endt_expiry_date, expiry_date) >= SYSDATE
                AND eff_date <= SYSDATE
                AND peril_type = 'B'
                AND p_line_cd || TO_CHAR (share_cd) IN (
                                SELECT a160.line_cd || TO_CHAR (a160.share_cd)
                                  FROM giis_dist_share a160
                                 WHERE a160.share_type = p_rv_low_value)
                AND iss_cd        = DECODE(p_bus_type,1,iss_cd,2,v_ri,iss_cd)
           	    AND iss_cd       <> DECODE(p_bus_type,1,v_ri,'XX')
                )
         LOOP
            v_dist_tsi := NVL (v_dist_tsi, 0) + NVL (d1.dist_tsi, 0);
         END LOOP;

         p_temporary := NVL (p_temporary, 0) + NVL (v_dist_tsi, 0);
      ELSIF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         FOR d1 IN
            (SELECT a.dist_tsi
               FROM gipi_fire_basic_item_dist_v2 a--, gipi_witem b --nieko 02032017 kb 894
              WHERE 1=1--a.par_id = b.par_id
                AND check_user_per_iss_cd2 (line_cd,
                                            iss_cd,
                                            'GIPIS110',
                                            p_user_id
                                           ) = 1
                -- nieko 07132016 KB 894
                AND line_cd = p_line_cd
                AND district_no = p_district_no
                AND block_no = p_block_no
                AND province_cd = p_province_cd
                AND city = p_city
                AND peril_type = 'B'
                AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08042016 kb 894
                AND NVL (endt_expiry_date, expiry_date) >= SYSDATE
                AND p_line_cd || TO_CHAR (share_cd) IN (
                                SELECT a160.line_cd || TO_CHAR (a160.share_cd)
                                  FROM giis_dist_share a160
                                 WHERE a160.share_type = p_rv_low_value)
                AND iss_cd        = DECODE(p_bus_type,1,iss_cd,2,v_ri,iss_cd)
           	    AND iss_cd       <> DECODE(p_bus_type,1,v_ri,'XX')
                )
         LOOP
            v_dist_tsi := NVL (v_dist_tsi, 0) + NVL (d1.dist_tsi, 0);
         END LOOP;

         p_temporary := NVL (p_temporary, 0) + NVL (v_dist_tsi, 0);
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         FOR d1 IN
            (SELECT a.dist_tsi
               FROM gipi_fire_basic_item_dist_v2 a--, gipi_witem b --nieko 02032017 kb 894
              WHERE 1=1--a.par_id = b.par_id
                AND check_user_per_iss_cd2 (line_cd,
                                            iss_cd,
                                            'GIPIS110',
                                            p_user_id
                                           ) = 1
                -- nieko 07132016 KB 894
                AND line_cd = p_line_cd
                AND district_no = p_district_no
                AND block_no = p_block_no
                AND province_cd = p_province_cd
                AND city = p_city
                AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08042016 kb 894
                AND peril_type = 'B'
                AND eff_date <= SYSDATE
                AND p_line_cd || TO_CHAR (share_cd) IN (
                                SELECT a160.line_cd || TO_CHAR (a160.share_cd)
                                  FROM giis_dist_share a160
                                 WHERE a160.share_type = p_rv_low_value)
                AND iss_cd        = DECODE(p_bus_type,1,iss_cd,2,v_ri,iss_cd)
           	    AND iss_cd       <> DECODE(p_bus_type,1,v_ri,'XX')
                )
         LOOP
            v_dist_tsi := NVL (v_dist_tsi, 0) + NVL (d1.dist_tsi, 0);
         END LOOP;

         p_temporary := NVL (p_temporary, 0) + NVL (v_dist_tsi, 0);
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         FOR d1 IN
            (SELECT a.dist_tsi
               FROM gipi_fire_basic_item_dist_v2 a--, gipi_witem b --nieko 02032017 kb 894
              WHERE 1=1--a.par_id = b.par_id
                AND check_user_per_iss_cd2 (line_cd,
                                            iss_cd,
                                            'GIPIS110',
                                            p_user_id
                                           ) = 1
                -- nieko 07132016 KB 894
                AND line_cd = p_line_cd
                AND district_no = p_district_no
                AND block_no = p_block_no
                AND province_cd = p_province_cd
                AND city = p_city
                AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08042016 kb 894
                AND peril_type = 'B'
                AND p_line_cd || TO_CHAR (share_cd) IN (
                                SELECT a160.line_cd || TO_CHAR (a160.share_cd)
                                  FROM giis_dist_share a160
                                 WHERE a160.share_type = p_rv_low_value)
                AND iss_cd        = DECODE(p_bus_type,1,iss_cd,2,v_ri,iss_cd)
           	    AND iss_cd       <> DECODE(p_bus_type,1,v_ri,'XX')
                )
         LOOP
            v_dist_tsi := NVL (v_dist_tsi, 0) + NVL (d1.dist_tsi, 0);
         END LOOP;

         p_temporary := NVL (p_temporary, 0) + NVL (v_dist_tsi, 0);
      END IF;
   END;

   PROCEDURE get_block_act_exposures (
      p_exclude                     VARCHAR2,
      p_exclude_not_eff             VARCHAR2,
      p_user_id                     giis_users.user_id%TYPE,
      p_district_no                 giis_block.district_no%TYPE,
      p_block_no                    giis_block.block_no%TYPE,
      p_province_cd                 giis_block.province_cd%TYPE,
      p_city                        giis_block.city%TYPE,
      p_actual             IN OUT   NUMBER,
      p_block_actual_sum   IN OUT   NUMBER,      
      p_risk_cd                     giis_risks.risk_cd%TYPE -- nieko 07132016 KB 894
   )
   IS
      v_dist_tsi   NUMBER := 0;
   BEGIN
      p_block_actual_sum := 0;

      IF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         FOR d1 IN (SELECT SUM (dist_tsi) dist_tsi
                      FROM gixx_block_accumulation_dist bgad, giis_peril gp
                     WHERE 1 = 1
                       AND check_user_per_iss_cd2 (bgad.line_cd,
                                                   iss_cd,
                                                   'GIPIS110',
                                                   p_user_id
                                                  ) = 1   --vondanix 3/16/13--
                       AND bgad.line_cd = gp.line_cd
                       AND bgad.peril_cd = gp.peril_cd
                       AND gp.peril_type = 'B'
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       --AND NVL(bgad.risk_cd, 0) = NVL(p_risk_cd, 0) -- nieko 07132016 KB 894
                       AND expiry_date >= SYSDATE
                       AND eff_date <= SYSDATE)
         LOOP
            v_dist_tsi := d1.dist_tsi;
         END LOOP;
      ELSIF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         FOR d1 IN (SELECT SUM (dist_tsi) dist_tsi
                      FROM gixx_block_accumulation_dist bgad, giis_peril gp
                     WHERE 1 = 1
                       AND check_user_per_iss_cd2 (bgad.line_cd,
                                                   iss_cd,
                                                   'GIPIS110',
                                                   p_user_id
                                                  ) = 1   --vondanix 3/16/13--
                       AND bgad.line_cd = gp.line_cd
                       AND bgad.peril_cd = gp.peril_cd
                       AND gp.peril_type = 'B'
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       --AND NVL(bgad.risk_cd, 0) = NVL(p_risk_cd, 0) -- nieko 07132016 KB 894
                       AND expiry_date >= SYSDATE)
         LOOP
            v_dist_tsi := d1.dist_tsi;
         END LOOP;

         p_actual := NVL (p_actual, 0) + NVL (v_dist_tsi, 0);
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         FOR d1 IN (SELECT SUM (dist_tsi) dist_tsi
                      FROM gixx_block_accumulation_dist bgad, giis_peril gp
                     WHERE 1 = 1
                       AND check_user_per_iss_cd2 (bgad.line_cd,
                                                   iss_cd,
                                                   'GIPIS110',
                                                   p_user_id
                                                  ) = 1   --vondanix 3/16/13--
                       AND bgad.line_cd = gp.line_cd
                       AND bgad.peril_cd = gp.peril_cd
                       AND gp.peril_type = 'B'
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       --AND NVL(bgad.risk_cd, 0) = NVL(p_risk_cd, 0) -- nieko 07132016 KB 894
                       AND eff_date <= SYSDATE)
         LOOP
            v_dist_tsi := d1.dist_tsi;
         END LOOP;
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         FOR d1 IN (SELECT SUM (dist_tsi) dist_tsi
                      FROM gixx_block_accumulation_dist bgad, giis_peril gp
                     WHERE 1 = 1
                       AND check_user_per_iss_cd2 (bgad.line_cd,
                                                   iss_cd,
                                                   'GIPIS110',
                                                   p_user_id
                                                  ) = 1   --vondanix 3/16/13--
                       AND bgad.line_cd = gp.line_cd
                       AND bgad.peril_cd = gp.peril_cd
                       AND gp.peril_type = 'B'
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       --AND NVL(bgad.risk_cd, 0) = NVL(p_risk_cd, 0) -- nieko 07132016 KB 894
                       AND city = p_city)
         LOOP
            v_dist_tsi := d1.dist_tsi;
         END LOOP;
      END IF;

      p_block_actual_sum := NVL (v_dist_tsi, 0);
   END;

   PROCEDURE get_block_temp_exposures (
      p_exclude                    VARCHAR2,
      p_exclude_not_eff            VARCHAR2,
      p_user_id                    giis_users.user_id%TYPE,
      p_district_no                giis_block.district_no%TYPE,
      p_block_no                   giis_block.block_no%TYPE,
      p_province_cd                giis_block.province_cd%TYPE,
      p_city                       giis_block.city%TYPE,
      p_block_temp_sum    IN OUT   NUMBER,
      p_risk_cd                    giis_risks.risk_cd%TYPE, -- nieko 07132016 KB 894
      p_bus_type                   NUMBER
   )
   IS
      v_dist_tsi   NUMBER;
      v_ri		   VARCHAR2(7);
   BEGIN
      p_block_temp_sum := 0;
      v_ri := Giacp.v('RI_ISS_CD');
      
      IF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         FOR d1 IN (SELECT a.dist_tsi
                      FROM gipi_fire_basic_item_dist_v2 a --, gipi_witem b -- nieko 02032017 KB 894
                     WHERE 1=1 --a.par_id = b.par_id
                       AND check_user_per_iss_cd2 (line_cd,
                                                   iss_cd,
                                                   'GIPIS110',
                                                   p_user_id
                                                  ) = 1
                       --vondanix 3/16/13--
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       --AND NVL(a.risk_cd, 0) = NVL(p_risk_cd, 0) -- nieko 07132016 KB 894
                       AND NVL (endt_expiry_date, expiry_date) >= SYSDATE
                       AND eff_date <= SYSDATE
                       AND peril_type = 'B'
                       AND iss_cd        = DECODE(p_bus_type,1,iss_cd,2,v_ri,iss_cd)
	                   AND iss_cd       <> DECODE(p_bus_type,1,v_ri,'XX')
                       )
         LOOP
            v_dist_tsi := NVL (v_dist_tsi, 0) + NVL (d1.dist_tsi, 0);
         END LOOP;
      ELSIF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         FOR d1 IN (SELECT a.dist_tsi
                      FROM gipi_fire_basic_item_dist_v2 a--, gipi_witem b -- nieko 02032017 KB 894
                     WHERE 1=1 --a.par_id = b.par_id
                       AND check_user_per_iss_cd2 (line_cd,
                                                   iss_cd,
                                                   'GIPIS110',
                                                   p_user_id
                                                  ) = 1
                       --vondanix 3/16/13--
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       --AND NVL(a.risk_cd, 0) = NVL(p_risk_cd, 0) -- nieko 07132016 KB 894
                       AND NVL (endt_expiry_date, expiry_date) >= SYSDATE
                       AND peril_type = 'B'
                       AND iss_cd        = DECODE(p_bus_type,1,iss_cd,2,v_ri,iss_cd)
	                   AND iss_cd       <> DECODE(p_bus_type,1,v_ri,'XX')
                       )
         LOOP
            v_dist_tsi := NVL (v_dist_tsi, 0) + NVL (d1.dist_tsi, 0);
         END LOOP;
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         FOR d1 IN (SELECT a.dist_tsi
                      FROM gipi_fire_basic_item_dist_v2 a--, gipi_witem b -- nieko 02032017 KB 894
                     WHERE 1=1--a.par_id = b.par_id
                       AND check_user_per_iss_cd2 (line_cd,
                                                   iss_cd,
                                                   'GIPIS110',
                                                   p_user_id
                                                  ) = 1
                       --vondanix 3/16/13--
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       --AND NVL(a.risk_cd, 0) = NVL(p_risk_cd, 0) -- nieko 07132016 KB 894
                       AND eff_date <= SYSDATE
                       AND peril_type = 'B'
                       AND iss_cd        = DECODE(p_bus_type,1,iss_cd,2,v_ri,iss_cd)
	                   AND iss_cd       <> DECODE(p_bus_type,1,v_ri,'XX')
                       )
         LOOP
            v_dist_tsi := NVL (v_dist_tsi, 0) + NVL (d1.dist_tsi, 0);
         END LOOP;
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         FOR d1 IN (SELECT a.dist_tsi
                      FROM gipi_fire_basic_item_dist_v2 a--, gipi_witem b -- nieko 02032017 KB 894
                     WHERE 1=1--a.par_id = b.par_id
                       AND check_user_per_iss_cd2 (line_cd,
                                                   iss_cd,
                                                   'GIPIS110',
                                                   p_user_id
                                                  ) = 1
                       --vondanix 3/16/13--
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       --AND NVL(a.risk_cd, 0) = NVL(p_risk_cd, 0) -- nieko 07132016 KB 894
                       AND peril_type = 'B'
                       AND iss_cd        = DECODE(p_bus_type,1,iss_cd,2,v_ri,iss_cd)
	                   AND iss_cd       <> DECODE(p_bus_type,1,v_ri,'XX')
                       )
         LOOP
            v_dist_tsi := NVL (v_dist_tsi, 0) + NVL (d1.dist_tsi, 0);
         END LOOP;
      END IF;

      p_block_temp_sum := NVL (p_block_temp_sum, 0) + NVL (v_dist_tsi, 0);
   END;

   FUNCTION get_share_exposure (
      p_exclude           VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_rv_low_value      cg_ref_codes.rv_low_value%TYPE,
      p_block_id          giis_block.block_id%TYPE,
      p_district_no       giis_block.district_no%TYPE,
      p_block_no          giis_block.block_no%TYPE,
      p_province_cd       giis_block.province_cd%TYPE,
      p_city              giis_block.city%TYPE,
      p_risk_cd           giis_risks.risk_cd%TYPE
   )
      RETURN share_exposure_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      custom    cur_typ;
      v_rec     share_exposure_type;
      v_where   VARCHAR2 (10000)    := '';
      v_query   VARCHAR2 (10000);
      v_cnt     NUMBER              := 0;
   BEGIN
      IF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         v_where :=
               'share_type = '''
            || p_rv_low_value
            || ''' AND line_cd || ''-'' || TO_CHAR(share_cd) IN (
        SELECT line_cd || ''-'' || TO_CHAR(share_cd)
          FROM gixx_block_accumulation_dist
         WHERE NVL(endt_expiry_date, expiry_date) >= SYSDATE
            AND eff_date <= SYSDATE
               AND BLOCK_ID    = '''
            || p_block_id
            || ''' '
            || 'AND NVL(risk_cd,0) ='
            || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 12142016 KB 894
            || '
        UNION
        SELECT line_cd || ''-'' || TO_CHAR(share_cd)
          FROM gipi_fire_basic_item_dist_v2
         WHERE NVL(endt_expiry_date, expiry_date) >= SYSDATE
            AND eff_date <= SYSDATE
               AND BLOCK_ID    = '''
            || p_block_id
            || ''' '
            || 'AND NVL(risk_cd,0) ='
            || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 12142016 KB 894
            || '
        UNION
         SELECT line_cd || ''-'' || TO_CHAR(share_cd)
          FROM gipi_fire_basic_item_dist_v4
         WHERE NVL(endt_expiry_date, expiry_date) >= SYSDATE
            AND eff_date <= SYSDATE
               AND BLOCK_ID    = '''
            || p_block_id
            || ''' '
            || 'AND NVL(risk_cd,0) ='
            || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 12142016 KB 894
            || ')';
      ELSIF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         v_where :=
               'share_type = '''
            || p_rv_low_value
            || ''' AND line_cd || ''-'' || TO_CHAR(share_cd) IN (
        SELECT line_cd || ''-'' || TO_CHAR(share_cd)
          FROM gixx_block_accumulation_dist
         WHERE NVL(endt_expiry_date, expiry_date) >= SYSDATE
            AND BLOCK_ID  = '''
            || p_block_id
            || ''' '
            || 'AND NVL(risk_cd,0) ='
            || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 12142016 KB 894
            || '
       UNION
        SELECT line_cd || ''-'' || TO_CHAR(share_cd)
          FROM gipi_fire_basic_item_dist_v2
         WHERE NVL(endt_expiry_date, expiry_date) >= SYSDATE
            AND BLOCK_ID = '''
            || p_block_id
            || ''' '
            || 'AND NVL(risk_cd,0) ='
            || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 12142016 KB 894
            || '
       UNION
         SELECT line_cd || ''-'' || TO_CHAR(share_cd)
          FROM gipi_fire_basic_item_dist_v4
         WHERE NVL(endt_expiry_date, expiry_date) >= SYSDATE
            AND BLOCK_ID = '''
            || p_block_id
            || ''' '
            || 'AND NVL(risk_cd,0) ='
            || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 12142016 KB 894
            || ')';
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         v_where :=
               'share_type = '''
            || p_rv_low_value
            || ''' AND line_cd || ''-'' || TO_CHAR(share_cd) IN (
        SELECT line_cd || ''-'' || TO_CHAR(share_cd)
          FROM gixx_block_accumulation_dist
         WHERE eff_date <= SYSDATE
               AND BLOCK_ID = '''
            || p_block_id
            || ''' '
            || 'AND NVL(risk_cd,0) ='
            || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 12142016 KB 894
            || '
       UNION
        SELECT line_cd || ''-'' || TO_CHAR(share_cd)
          FROM gipi_fire_basic_item_dist_v2
         WHERE eff_date <= SYSDATE
               AND BLOCK_ID = '''
            || p_block_id
            || ''' '
            || 'AND NVL(risk_cd,0) ='
            || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 12142016 KB 894
            || '
       UNION
         SELECT line_cd || ''-'' || TO_CHAR(share_cd)
          FROM gipi_fire_basic_item_dist_v4
         WHERE eff_date <= SYSDATE
               AND BLOCK_ID = '''
            || p_block_id
            || ''' '
            || 'AND NVL(risk_cd,0) ='
            || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 12142016 KB 894
            || ')';
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         v_where :=
               'share_type = '''
            || p_rv_low_value
            || ''' AND line_cd || ''-'' || TO_CHAR(share_cd) IN (
        SELECT line_cd || ''-'' || TO_CHAR(share_cd)
          FROM gixx_block_accumulation_dist
         WHERE BLOCK_ID = '''
            || p_block_id
            || ''' '
            || 'AND NVL(risk_cd,0) ='
            || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 12142016 KB 894
            || '
       UNION
        SELECT line_cd || ''-'' || TO_CHAR(share_cd)
          FROM gipi_fire_basic_item_dist_v2
         WHERE BLOCK_ID = '''
            || p_block_id
            || ''' '
            || 'AND NVL(risk_cd,0) ='
            || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 12142016 KB 894
            || '
       UNION
         SELECT line_cd || ''-'' || TO_CHAR(share_cd)
          FROM gipi_fire_basic_item_dist_v4
         WHERE BLOCK_ID = '''
            || p_block_id
            || ''' '
            || 'AND NVL(risk_cd,0) ='
            || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 12142016 KB 894
            || ')';
      END IF;

      v_query :=
            'SELECT share_cd,line_cd,trty_name
    FROM giis_dist_share WHERE 1 = 1 AND '
         || v_where;

      OPEN custom FOR v_query;

      LOOP
         FETCH custom
          INTO v_rec.share_cd, v_rec.line_cd, v_rec.trty_name;

         v_cnt := v_cnt + 1;

         IF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            FOR x1 IN (SELECT a.line_cd
                         FROM giis_line a
                        WHERE EXISTS (
                                 SELECT 'X'
                                   FROM gixx_block_accumulation_dist
                                  WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                      SYSDATE
                                    AND eff_date <= SYSDATE
                                    AND block_id = p_block_id
                                    AND line_cd = a.line_cd
                                 UNION
                                 SELECT 'X'
                                   FROM gipi_fire_basic_item_dist_v2
                                  WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                       SYSDATE
                                    AND eff_date <= SYSDATE
                                    AND block_id = p_block_id
                                    AND line_cd = a.line_cd))
            LOOP
               gipis110_pkg.get_itemds_act_x (x1.line_cd,
                                              p_exclude,
                                              p_exclude_not_eff,
                                              p_district_no,
                                              p_block_no,
                                              p_province_cd,
                                              p_city,
                                              v_rec.line_cd,
                                              v_rec.share_cd,
                                              p_risk_cd,
                                              v_rec.actual
                                             );
               gipis110_pkg.get_itemds_temp_x (x1.line_cd,
                                               p_exclude,
                                               p_exclude_not_eff,
                                               p_district_no,
                                               p_block_no,
                                               p_province_cd,
                                               p_city,
                                               v_rec.line_cd,
                                               v_rec.share_cd,
                                               p_risk_cd,
                                               v_rec.TEMPORARY
                                              );
            END LOOP;
         ELSIF NVL (p_exclude, 'N') = 'Y'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            FOR x1 IN (SELECT a.line_cd
                         FROM giis_line a
                        WHERE EXISTS (
                                 SELECT 'X'
                                   FROM gixx_block_accumulation_dist
                                  WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                      SYSDATE
                                    AND block_id = p_block_id
                                    AND line_cd = a.line_cd
                                 UNION
                                 SELECT 'X'
                                   FROM gipi_fire_basic_item_dist_v2
                                  WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                       SYSDATE
                                    AND block_id = p_block_id
                                    AND line_cd = a.line_cd))
            LOOP
               gipis110_pkg.get_itemds_act_x (x1.line_cd,
                                              p_exclude,
                                              p_exclude_not_eff,
                                              p_district_no,
                                              p_block_no,
                                              p_province_cd,
                                              p_city,
                                              v_rec.line_cd,
                                              v_rec.share_cd,
                                              p_risk_cd,
                                              v_rec.actual
                                             );
               gipis110_pkg.get_itemds_temp_x (x1.line_cd,
                                               p_exclude,
                                               p_exclude_not_eff,
                                               p_district_no,
                                               p_block_no,
                                               p_province_cd,
                                               p_city,
                                               v_rec.line_cd,
                                               v_rec.share_cd,
                                               p_risk_cd,
                                               v_rec.TEMPORARY
                                              );
            END LOOP;
         ELSIF NVL (p_exclude, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            FOR x1 IN (SELECT a.line_cd
                         FROM giis_line a
                        WHERE EXISTS (
                                 SELECT 'X'
                                   FROM gixx_block_accumulation_dist
                                  WHERE eff_date <= SYSDATE
                                    AND block_id = p_block_id
                                    AND line_cd = a.line_cd
                                 UNION
                                 SELECT 'X'
                                   FROM gipi_fire_basic_item_dist_v2
                                  WHERE eff_date <= SYSDATE
                                    AND block_id = p_block_id
                                    AND line_cd = a.line_cd))
            LOOP
               gipis110_pkg.get_itemds_act_x (x1.line_cd,
                                              p_exclude,
                                              p_exclude_not_eff,
                                              p_district_no,
                                              p_block_no,
                                              p_province_cd,
                                              p_city,
                                              v_rec.line_cd,
                                              v_rec.share_cd,
                                              p_risk_cd,
                                              v_rec.actual
                                             );
               gipis110_pkg.get_itemds_temp_x (x1.line_cd,
                                               p_exclude,
                                               p_exclude_not_eff,
                                               p_district_no,
                                               p_block_no,
                                               p_province_cd,
                                               p_city,
                                               v_rec.line_cd,
                                               v_rec.share_cd,
                                               p_risk_cd,
                                               v_rec.TEMPORARY
                                              );
            END LOOP;
         ELSIF NVL (p_exclude, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            FOR x1 IN (SELECT a.line_cd
                         FROM giis_line a
                        WHERE EXISTS (
                                 SELECT 'X'
                                   FROM gixx_block_accumulation_dist
                                  WHERE block_id = p_block_id
                                    AND line_cd = a.line_cd
                                 UNION
                                 SELECT 'X'
                                   FROM gipi_fire_basic_item_dist_v2
                                  WHERE block_id = p_block_id
                                    AND line_cd = a.line_cd))
            LOOP
               gipis110_pkg.get_itemds_act_x (x1.line_cd,
                                              p_exclude,
                                              p_exclude_not_eff,
                                              p_district_no,
                                              p_block_no,
                                              p_province_cd,
                                              p_city,
                                              v_rec.line_cd,
                                              v_rec.share_cd,
                                              p_risk_cd,
                                              v_rec.actual
                                             );
               gipis110_pkg.get_itemds_temp_x (x1.line_cd,
                                               p_exclude,
                                               p_exclude_not_eff,
                                               p_district_no,
                                               p_block_no,
                                               p_province_cd,
                                               p_city,
                                               v_rec.line_cd,
                                               v_rec.share_cd,
                                               p_risk_cd,
                                               v_rec.TEMPORARY
                                              );
            END LOOP;
         END IF;

         IF v_rec.actual IS NULL
         THEN
            v_rec.actual := 0;
         END IF;

         IF v_rec.TEMPORARY IS NULL
         THEN
            v_rec.TEMPORARY := 0;
         END IF;

         v_rec.expo_sum := v_rec.actual + v_rec.TEMPORARY;
         EXIT WHEN custom%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE custom;

      IF v_cnt < 6
      THEN
         FOR i IN 1 .. 6 - v_cnt
         LOOP
            v_rec.actual := NULL;
            v_rec.TEMPORARY := NULL;
            v_rec.expo_sum := NULL;
            v_rec.share_cd := NULL;
            v_rec.line_cd := NULL;
            v_rec.trty_name := NULL;
            PIPE ROW (v_rec);
         END LOOP;
      END IF;
   END;

   PROCEDURE get_itemds_act_x (
      p_line_cd                 VARCHAR2,
      p_exclude                 VARCHAR2,
      p_exclude_not_eff         VARCHAR2,
      p_district_no             giis_block.district_no%TYPE,
      p_block_no                giis_block.block_no%TYPE,
      p_province_cd             giis_block.province_cd%TYPE,
      p_city                    giis_block.city%TYPE,
      p_share_line_cd           giis_dist_share.line_cd%TYPE,
      p_share_cd                giis_dist_share.share_cd%TYPE,
      p_risk_cd                 giis_risks.risk_cd%TYPE,
      p_actual            OUT   NUMBER
   )
   IS
      v_dist_tsi   NUMBER;
   BEGIN
      /*** ACTUAL EXPOSURE ***/
      IF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         FOR c1 IN (SELECT SUM (dist_tsi) dist_tsi
                      FROM gixx_block_accumulation_dist
                     WHERE line_cd = p_line_cd
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       AND p_line_cd = p_share_line_cd
                       AND share_cd = p_share_cd
                       --AND NVL (risk_cd, 0) = p_risk_cd
                       AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08192016 kb 894 
                       /*AND share_cd IN (SELECT share_cd
                                    FROM giis_dist_share
                                   WHERE share_type = :cg$ctrl.nbt_share_type)*/
                       AND NVL (endt_expiry_date, expiry_date) >= SYSDATE
                       AND eff_date <= SYSDATE
                       AND peril_cd IN (
                                SELECT peril_cd
                                  FROM giis_peril
                                 WHERE peril_type = 'B'
                                       AND line_cd = p_line_cd))
         LOOP
            v_dist_tsi := c1.dist_tsi;
         --v_dist_tsi := NVL(v_dist_tsi, 0) + NVL(c1.dist_tsi, 0);
         END LOOP;

         p_actual := NVL (p_actual, 0) + NVL (v_dist_tsi, 0);
      ELSIF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         FOR c1 IN (SELECT SUM (dist_tsi) dist_tsi
                      FROM gixx_block_accumulation_dist
                     WHERE line_cd = p_line_cd
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       AND p_line_cd = p_share_line_cd
                       AND share_cd = p_share_cd
                       --AND NVL (risk_cd, 0) = p_risk_cd
                       AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08192016 kb 894
                       AND NVL (endt_expiry_date, expiry_date) >= SYSDATE
                       AND peril_cd IN (
                                SELECT peril_cd
                                  FROM giis_peril
                                 WHERE peril_type = 'B'
                                       AND line_cd = p_line_cd))
         LOOP
            v_dist_tsi := c1.dist_tsi;
         --v_dist_tsi := NVL(v_dist_tsi, 0) + NVL(c1.dist_tsi, 0);
         END LOOP;

         p_actual := NVL (p_actual, 0) + NVL (v_dist_tsi, 0);
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         FOR c1 IN (SELECT SUM (dist_tsi) dist_tsi
                      FROM gixx_block_accumulation_dist
                     WHERE line_cd = p_line_cd
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       AND p_line_cd = p_share_line_cd
                       AND share_cd = p_share_cd
                       --AND NVL (risk_cd, 0) = p_risk_cd
                       AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08192016 kb 894
                       AND eff_date <= SYSDATE
                       AND peril_cd IN (
                                SELECT peril_cd
                                  FROM giis_peril
                                 WHERE peril_type = 'B'
                                       AND line_cd = p_line_cd))
         LOOP
            v_dist_tsi := c1.dist_tsi;
         --v_dist_tsi := NVL(v_dist_tsi, 0) + NVL(c1.dist_tsi, 0);
         END LOOP;

         p_actual := NVL (p_actual, 0) + NVL (v_dist_tsi, 0);
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         FOR c1 IN (SELECT SUM (dist_tsi) dist_tsi
                      FROM gixx_block_accumulation_dist
                     WHERE line_cd = p_line_cd
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       AND p_line_cd = p_share_line_cd
                       AND share_cd = p_share_cd
                       --AND NVL (risk_cd, 0) = p_risk_cd
                       AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08192016 kb 894
                       AND peril_cd IN (
                                SELECT peril_cd
                                  FROM giis_peril
                                 WHERE peril_type = 'B'
                                       AND line_cd = p_line_cd))
         LOOP
            v_dist_tsi := c1.dist_tsi;
         --v_dist_tsi := NVL(v_dist_tsi, 0) + NVL(c1.dist_tsi, 0);
         END LOOP;

         p_actual := NVL (p_actual, 0) + NVL (v_dist_tsi, 0);
      END IF;
   END;

   PROCEDURE get_itemds_temp_x (
      p_line_cd                 VARCHAR2,
      p_exclude                 VARCHAR2,
      p_exclude_not_eff         VARCHAR2,
      p_district_no             giis_block.district_no%TYPE,
      p_block_no                giis_block.block_no%TYPE,
      p_province_cd             giis_block.province_cd%TYPE,
      p_city                    giis_block.city%TYPE,
      p_share_line_cd           giis_dist_share.line_cd%TYPE,
      p_share_cd                giis_dist_share.share_cd%TYPE,
      p_risk_cd                 giis_risks.risk_cd%TYPE,
      p_temporary         OUT   NUMBER
   )
   IS
      v_dist_tsi   NUMBER;
   BEGIN
      /*** TEMPORARY EXPOSURE ***/
      IF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         FOR c1 IN (SELECT dist_tsi
                      FROM gipi_fire_basic_item_dist_v2
                     WHERE line_cd = p_line_cd
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       AND p_line_cd = p_share_line_cd
                       AND share_cd = p_share_cd
                       --AND NVL (risk_cd, 0) = p_risk_cd
                       AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08192016 kb 894
                       AND peril_type = 'B'
                       AND NVL (endt_expiry_date, expiry_date) >= SYSDATE
                       AND eff_date <= SYSDATE)
         LOOP
            --v_dist_tsi := c1.dist_tsi;
            v_dist_tsi := NVL (v_dist_tsi, 0) + NVL (c1.dist_tsi, 0);
         END LOOP;

         p_temporary := NVL (p_temporary, 0) + NVL (v_dist_tsi, 0);
      ELSIF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         FOR c1 IN (SELECT dist_tsi
                      FROM gipi_fire_basic_item_dist_v2
                     WHERE line_cd = p_line_cd
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       AND p_line_cd = p_share_line_cd
                       AND share_cd = p_share_cd
                       AND peril_type = 'B'
                       --AND NVL (risk_cd, 0) = p_risk_cd
                       AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08192016 kb 894
                       AND peril_type = 'B'
                       AND NVL (endt_expiry_date, expiry_date) >= SYSDATE)
         LOOP
            --v_dist_tsi := c1.dist_tsi;
            v_dist_tsi := NVL (v_dist_tsi, 0) + NVL (c1.dist_tsi, 0);
         END LOOP;

         p_temporary := NVL (p_temporary, 0) + NVL (v_dist_tsi, 0);
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         FOR c1 IN (SELECT dist_tsi
                      FROM gipi_fire_basic_item_dist_v2
                     WHERE line_cd = p_line_cd
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       AND p_line_cd = p_share_line_cd
                       AND share_cd = p_share_cd
                       AND peril_type = 'B'
                       --AND NVL (risk_cd, 0) = p_risk_cd
                       AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd) --nieko 08192016 kb 894
                       AND eff_date <= SYSDATE)
         LOOP
            --v_dist_tsi := c1.dist_tsi;
            v_dist_tsi := NVL (v_dist_tsi, 0) + NVL (c1.dist_tsi, 0);
         END LOOP;

         p_temporary := NVL (p_temporary, 0) + NVL (v_dist_tsi, 0);
      ELSIF NVL (p_exclude, 'N') = 'N' AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         FOR c1 IN (SELECT dist_tsi
                      FROM gipi_fire_basic_item_dist_v2
                     WHERE line_cd = p_line_cd
                       AND district_no = p_district_no
                       AND block_no = p_block_no
                       AND province_cd = p_province_cd
                       AND city = p_city
                       AND p_line_cd = p_share_line_cd
                       AND share_cd = p_share_cd
                       AND peril_type = 'B'
                       --AND NVL (risk_cd, 0) = p_risk_cd
                       AND NVL (risk_cd, 0) = DECODE(p_risk_cd, 'AR', NVL (risk_cd, 0), p_risk_cd)) --nieko 08192016 kb 894
         LOOP
            --v_dist_tsi := c1.dist_tsi;
            v_dist_tsi := NVL (v_dist_tsi, 0) + NVL (c1.dist_tsi, 0);
         END LOOP;

         p_temporary := NVL (p_temporary, 0) + NVL (v_dist_tsi, 0);
      END IF;
   END;

   FUNCTION get_actual_exposure (
      p_exclude           VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_share_type        gixx_block_accumulation_dist.share_type%TYPE,
      p_block_id          giis_block.block_id%TYPE,
      p_user_id           giis_users.user_id%TYPE,
      p_mode              VARCHAR2,
      p_all               VARCHAR2,
      p_risk_cd           giis_risks.risk_cd%TYPE -- nieko 07132016 KB 894
   )
      RETURN actual_exposure_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      custom          cur_typ;
      v_rec           actual_exposure_type;
      v_where_v440    VARCHAR2 (10000);
      v_where_v440a   VARCHAR2 (10000);
      v_where_dflt    VARCHAR2 (10000);
      v_query         VARCHAR2 (10000);
   BEGIN
      IF p_all = 'N'
      THEN
         IF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where_v440a :=
                  'AND share_type = '''
               || p_share_type
               || '''
         AND expiry_date >= SYSDATE
         AND eff_date    <= SYSDATE';
            v_where_v440 :=
                  'AND share_type = '''
               || p_share_type
               || '''
          AND expiry_date >= SYSDATE
          AND eff_date    <= SYSDATE';
         ELSIF NVL (p_exclude, 'N') = 'Y'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where_v440a :=
                  'AND share_type = '''
               || p_share_type
               || '''
          AND expiry_date >= SYSDATE';
            v_where_v440 :=
                  'AND share_type = '''
               || p_share_type
               || '''
          AND expiry_date >= SYSDATE';
         ELSIF NVL (p_exclude, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where_v440a :=
                  'AND share_type = '''
               || p_share_type
               || '''
          AND eff_date    <= SYSDATE';
            v_where_v440 :=
                  'AND share_type = '''
               || p_share_type
               || '''
          AND eff_date    <= SYSDATE';
         ELSIF NVL (p_exclude, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where_v440a := 'AND share_type = ''' || p_share_type || '''';
            v_where_v440 := 'AND share_type = ''' || p_share_type || '''';
         END IF;
      ELSE
         v_where_v440a :=
               'AND CHECK_USER_PER_ISS_CD2(line_cd, iss_cd, ''GIPIS110'','''
            || p_user_id
            || ''') = 1 ';
         v_where_dflt :=
               ' AND policy_id IN (SELECT x.policy_id 
                                      FROM gixx_block_accumulation x
                                     WHERE x.endt_seq_no = (SELECT MAX(endt_seq_no)
                                                              FROM gixx_block_accumulation
                                                             WHERE line_cd    = x.line_cd
                                                               AND subline_cd = x.subline_cd
                                                               AND iss_cd     = x.iss_cd
                                                               AND issue_yy   = x.issue_yy
                                                               AND pol_seq_no = x.pol_seq_no
                                                               AND renew_no   = x.renew_no
                                                               AND CHECK_USER_PER_ISS_CD2(line_cd, iss_cd, ''GIPIS110'','''
            || p_user_id
            || ''') = 1)) ';

         IF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where_v440 :=
                  'AND NVL(ENDT_EXPIRY_DATE, EXPIRY_DATE) >= SYSDATE '
               || 'AND EFF_DATE <= SYSDATE AND LINE_CD||SUBLINE_CD||ISS_CD||ISSUE_YY||POL_SEQ_NO||RENEW_NO||ITEM_NO '
               || 'IN (SELECT LINE_CD||SUBLINE_CD||ISS_CD||ISSUE_YY||POL_SEQ_NO||RENEW_NO||ITEM_NO FROM '
               || 
                  --vonda-3/15/13 'GIXX_BLOCK_ACCUMULATION_DIST)');
                  'GIXX_BLOCK_ACCUMULATION_DIST WHERE CHECK_USER_PER_ISS_CD2(line_cd, iss_cd, ''GIPIS110'','''
               || p_user_id
               || ''') = 1)';
            v_where_v440a :=
                  'AND NVL(ENDT_EXPIRY_DATE, EXPIRY_DATE) >= SYSDATE '
               || 'AND EFF_DATE <= SYSDATE AND LINE_CD||SUBLINE_CD||ISS_CD||ISSUE_YY||POL_SEQ_NO||RENEW_NO||ITEM_NO '
               || 'IN (SELECT LINE_CD||SUBLINE_CD||ISS_CD||ISSUE_YY||POL_SEQ_NO||RENEW_NO||ITEM_NO FROM '
               || 
                  --vonda-3/15/13 'GIXX_BLOCK_ACCUMULATION_DIST)');
                  'GIXX_BLOCK_ACCUMULATION_DIST WHERE CHECK_USER_PER_ISS_CD2(line_cd, iss_cd, ''GIPIS110'','''
               || p_user_id
               || ''') = 1)';
         ELSIF NVL (p_exclude, 'N') = 'Y'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN                            --ADDED ACCESS RIGHTS --vonda-3/15/13
            v_where_v440 :=
                  'AND NVL(ENDT_EXPIRY_DATE, EXPIRY_DATE) >= SYSDATE AND CHECK_USER_PER_ISS_CD2(line_cd, iss_cd, ''GIPIS110'','''
               || p_user_id
               || ''') = 1';
            v_where_v440a :=
                  'AND NVL(ENDT_EXPIRY_DATE, EXPIRY_DATE) >= SYSDATE AND CHECK_USER_PER_ISS_CD2(line_cd, iss_cd, ''GIPIS110'','''
               || p_user_id
               || ''') = 1';
         ELSIF NVL (p_exclude, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN                            --ADDED ACCESS RIGHTS --vonda-3/15/13
            v_where_v440 :=
                  'AND EFF_DATE <= SYSDATE AND CHECK_USER_PER_ISS_CD2(line_cd, iss_cd, ''GIPIS110'','''
               || p_user_id
               || ''') = 1';
            v_where_v440a :=
                  'AND EFF_DATE <= SYSDATE AND CHECK_USER_PER_ISS_CD2(line_cd, iss_cd, ''GIPIS110'','''
               || p_user_id
               || ''') = 1';
         ELSIF     NVL (p_exclude, 'N' || v_where_dflt) = 'N'
--ito pa ung isang weird,sa CS inilagay yang v_where_dflt na yan dyan. para kasing mali siya...
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where_v440 := v_where_dflt;
            v_where_v440a := v_where_dflt;
         END IF;
      END IF;

      IF p_all = 'N'
      THEN
         IF p_mode = 'ITEM'
         THEN
            v_query :=
                  'SELECT DISTINCT a.fr_item_type, a.block_id, NVL (risk_cd, 0) risk_cd,
                    a.line_cd, a.assd_no, a.assd_name, a.item_no,
                    a.construction_cd, a.tarf_cd, a.subline_cd, a.iss_cd,
                    a.issue_yy, a.pol_seq_no, a.renew_no, a.eff_date,
                    a.expiry_date, a.loc_risk, a.district_no, a.block_no,
                    a.dist_flag, a.share_type, '''',
                    '''', '''', '''', '''', ''''
               FROM gixx_block_accumulation_dist a WHERE 1=1 AND block_id ='''
               || p_block_id
               || ''' '
               || 'AND NVL(risk_cd,0) ='
               || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 08042016 KB 894
               || ' '
               || v_where_v440a
               || ' ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, item_no';
         ELSE
            v_query :=
                  'SELECT DISTINCT fr_item_type, block_id, NVL (risk_cd, 0) risk_cd, 
                    line_cd, assd_no, assd_name, item_no, 
                    construction_cd, tarf_cd, subline_cd, iss_cd, 
                    issue_yy, pol_seq_no, renew_no, eff_date, 
                    expiry_date, loc_risk, district_no, block_no,
                    dist_flag, share_type, province_cd,
                    city, peril_cd, peril_name, peril_sname, prem_rt
               FROM gixx_block_accumulation_dist WHERE 1=1 AND block_id ='''
               || p_block_id
               || ''' '
               || 'AND NVL(risk_cd,0) ='
               || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 08042016 KB 894
               || ' '
               || v_where_v440
               || ' ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, item_no';
         END IF;

         OPEN custom FOR v_query;

         LOOP
            FETCH custom
             INTO v_rec.fr_item_type, v_rec.block_id, v_rec.risk_cd,
                  v_rec.line_cd, v_rec.assd_no, v_rec.assd_name,
                  v_rec.item_no, v_rec.construction_cd, v_rec.tarf_cd,
                  v_rec.subline_cd, v_rec.iss_cd, v_rec.issue_yy,
                  v_rec.pol_seq_no, v_rec.renew_no, v_rec.eff_date,
                  v_rec.expiry_date, v_rec.loc_risk, v_rec.district_no,
                  v_rec.block_no, v_rec.dist_flag, v_rec.share_type,
                  v_rec.province_cd, v_rec.city, v_rec.peril_cd,
                  v_rec.peril_name, v_rec.peril_sname, v_rec.prem_rt;

            v_rec.dsp_expiry_date :=
                                    TO_CHAR (v_rec.expiry_date, 'MM-DD-YYYY');
            v_rec.dsp_eff_date := TO_CHAR (v_rec.eff_date, 'MM-DD-YYYY');
            v_rec.policy_no :=
                  v_rec.line_cd
               || '-'
               || v_rec.subline_cd
               || '-'
               || v_rec.iss_cd
               || '-'
               || LTRIM (TO_CHAR (v_rec.issue_yy, '09'))
               || '-'
               || LTRIM (TO_CHAR (v_rec.pol_seq_no, '0999999'))
               || '-'
               || LTRIM (TO_CHAR (v_rec.renew_no, '09'));

            BEGIN
               SELECT param_value_v
                 INTO v_rec.fire
                 FROM giis_parameters
                WHERE param_name = 'FIRE';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#E#Parameter value does not exist from giis parameters.'
                     );
            END;

            v_rec.max_expiry := NULL;
            v_rec.expired := 'N';

            IF v_rec.eff_date > SYSDATE
            THEN
               v_rec.not_yet_eff := 'Y';
            ELSE
               v_rec.not_yet_eff := 'N';
            END IF;

            FOR max_expiry IN (SELECT   expiry_date
                                   FROM gixx_block_accumulation_dist
                                  WHERE line_cd = v_rec.line_cd
                                    AND subline_cd = v_rec.subline_cd
                                    AND iss_cd = v_rec.iss_cd
                                    AND issue_yy = v_rec.issue_yy
                                    AND pol_seq_no = v_rec.pol_seq_no
                                    AND renew_no = v_rec.renew_no
                                    AND share_type = p_share_type
                               ORDER BY endt_seq_no DESC)
            LOOP
               v_rec.max_expiry := max_expiry.expiry_date;
               v_rec.dsp_max_expiry :=
                                     TO_CHAR (v_rec.max_expiry, 'MM-DD-YYYY');

               IF (max_expiry.expiry_date) < SYSDATE
               THEN
                  v_rec.expired := 'Y';
               END IF;

               EXIT;
            END LOOP;

            FOR x IN (SELECT fr_itm_tp_ds
                        FROM giis_fi_item_type
                       WHERE fr_item_type = v_rec.fr_item_type)
            LOOP
               v_rec.dsp_fr_item_type := x.fr_itm_tp_ds;
            END LOOP;

            IF v_rec.dist_flag = '1'
            THEN
               v_rec.dsp_dist_status := 'Undistributed';
            ELSIF v_rec.dist_flag = '2'
            THEN
               v_rec.dsp_dist_status := 'w/ Facultative';
            ELSIF v_rec.dist_flag = '3'
            THEN
               v_rec.dsp_dist_status := 'Distributed';
            ELSIF v_rec.dist_flag = '4'
            THEN
               v_rec.dsp_dist_status := 'Undistributed';
            ELSIF v_rec.dist_flag = '5'
            THEN
               v_rec.dsp_dist_status := 'Undistributed';
            END IF;

            v_rec.nbt_cons_desc := NULL;

            FOR a IN (SELECT construction_desc cons_desc
                        FROM giis_fire_construction
                       WHERE construction_cd = v_rec.construction_cd)
            LOOP
               v_rec.nbt_cons_desc := a.cons_desc;
               EXIT;
            END LOOP;

            IF p_mode = 'ITEM'
            THEN
               v_rec.with_claims :=
                  gipis110_pkg.record_claim_exists ('V440A_DIST',
                                                    v_rec.line_cd,
                                                    v_rec.subline_cd,
                                                    v_rec.iss_cd,
                                                    v_rec.issue_yy,
                                                    v_rec.pol_seq_no,
                                                    v_rec.renew_no
                                                   );
               v_rec.ann_tsi_amt := 0;

               FOR a IN (SELECT ann_tsi_amt
                           FROM gixx_block_accumulation_dist
                          WHERE item_no = v_rec.item_no
                            AND line_cd = v_rec.line_cd
                            AND subline_cd = v_rec.subline_cd
                            AND iss_cd = v_rec.iss_cd
                            AND issue_yy = v_rec.issue_yy
                            AND pol_seq_no = v_rec.pol_seq_no
                            AND renew_no = v_rec.renew_no
                            AND share_type = p_share_type
                            AND peril_cd IN (
                                   SELECT peril_cd
                                     FROM giis_peril
                                    WHERE peril_type = 'B'
                                      AND line_cd = v_rec.line_cd))
               LOOP
                  v_rec.ann_tsi_amt := a.ann_tsi_amt;
                  EXIT;
               END LOOP;

               v_rec.dist_tsi := 0;

               FOR a IN (SELECT SUM (dist_tsi) dist_tsi
                           FROM gixx_block_accumulation_dist
                          WHERE item_no = v_rec.item_no
                            AND line_cd = v_rec.line_cd
                            AND subline_cd = v_rec.subline_cd
                            AND iss_cd = v_rec.iss_cd
                            AND issue_yy = v_rec.issue_yy
                            AND pol_seq_no = v_rec.pol_seq_no
                            AND renew_no = v_rec.renew_no
                            AND share_type = p_share_type
                            AND peril_cd IN (
                                   SELECT peril_cd
                                     FROM giis_peril
                                    WHERE peril_type = 'B'
                                      AND line_cd = v_rec.line_cd))
               LOOP
                  v_rec.dist_tsi := a.dist_tsi;
                  EXIT;
               END LOOP;
            ELSE
               v_rec.with_claims :=
                  gipis110_pkg.record_claim_exists ('V440_DIST',
                                                    v_rec.line_cd,
                                                    v_rec.subline_cd,
                                                    v_rec.iss_cd,
                                                    v_rec.issue_yy,
                                                    v_rec.pol_seq_no,
                                                    v_rec.renew_no
                                                   );
               v_rec.ann_tsi_amt := 0;

               FOR a IN (SELECT ann_tsi_amt
                           FROM gixx_block_accumulation_dist
                          WHERE item_no = v_rec.item_no
                            AND peril_cd = v_rec.peril_cd
                            AND line_cd = v_rec.line_cd
                            AND subline_cd = v_rec.subline_cd
                            AND iss_cd = v_rec.iss_cd
                            AND issue_yy = v_rec.issue_yy
                            AND pol_seq_no = v_rec.pol_seq_no
                            AND renew_no = v_rec.renew_no
                            AND share_type = p_share_type)
               LOOP
                  v_rec.ann_tsi_amt := a.ann_tsi_amt;
                  EXIT;
               END LOOP;

               v_rec.dist_tsi := 0;

               FOR a IN (SELECT SUM (dist_tsi) dist_tsi
                           FROM gixx_block_accumulation_dist
                          WHERE item_no = v_rec.item_no
                            AND peril_cd = v_rec.peril_cd
                            AND line_cd = v_rec.line_cd
                            AND subline_cd = v_rec.subline_cd
                            AND iss_cd = v_rec.iss_cd
                            AND issue_yy = v_rec.issue_yy
                            AND pol_seq_no = v_rec.pol_seq_no
                            AND renew_no = v_rec.renew_no
                            AND share_type = p_share_type)
               LOOP
                  v_rec.dist_tsi := a.dist_tsi;
                  EXIT;
               END LOOP;
            END IF;

            EXIT WHEN custom%NOTFOUND;
            PIPE ROW (v_rec);
         END LOOP;

         CLOSE custom;
      ELSE
         IF p_mode = 'ITEM'
         THEN
            v_query :=
                  'SELECT DISTINCT fr_item_type, block_id, nvl(risk_cd,0) risk_cd,
                    line_cd, assd_no,  assd_name, item_no, 
                    construction_cd, tarf_cd, subline_cd, iss_cd, 
                    issue_yy, pol_seq_no, renew_no, TRUNC(eff_date) eff_date,
                    TRUNC(incept_date) incept_date, TRUNC(expiry_date) expiry_date, TRUNC(endt_expiry_date) endt_expiry_date,
                    loc_risk, district_no, block_no, dist_flag,
                    '''', '''', '''', '''' 
                FROM GIXX_BLOCK_ACCUMULATION where 1=1 AND block_id ='''
               || p_block_id
               || ''''
               || 'AND NVL(risk_cd,0) ='
               || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 08042016 KB 894
               || ' '
               || v_where_v440a
               || ' ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, item_no';
         ELSE
            v_query :=
                  'SELECT DISTINCT fr_item_type, block_id, nvl(risk_cd,0) risk_cd,
                    line_cd, assd_no, assd_name, item_no, 
                    construction_cd, tarf_cd, subline_cd, iss_cd, 
                    issue_yy, pol_seq_no, renew_no, eff_date, 
                    incept_date, expiry_date,endt_expiry_date,
                    loc_risk,district_no,block_no,dist_flag, 
                    endt_seq_no, peril_name, prem_rt, ann_tsi_amt
                FROM gixx_block_accumulation where 1=1 AND block_id ='''
               || p_block_id
               || ''''
               || 'AND NVL(risk_cd,0) ='
               || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 08042016 KB 894
               || ' '
               || v_where_v440
               || ' ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, item_no';
         END IF;

         OPEN custom FOR v_query;

         LOOP
            FETCH custom
             INTO v_rec.fr_item_type, v_rec.block_id, v_rec.risk_cd,
                  v_rec.line_cd, v_rec.assd_no, v_rec.assd_name,
                  v_rec.item_no, v_rec.construction_cd, v_rec.tarf_cd,
                  v_rec.subline_cd, v_rec.iss_cd, v_rec.issue_yy,
                  v_rec.pol_seq_no, v_rec.renew_no, v_rec.eff_date,
                  v_rec.incept_date, v_rec.expiry_date,
                  v_rec.endt_expiry_date, v_rec.loc_risk, v_rec.district_no,
                  v_rec.block_no, v_rec.dist_flag, v_rec.endt_seq_no,
                  v_rec.peril_name, v_rec.prem_rt, v_rec.ann_tsi_amt;

            v_rec.dsp_expiry_date :=
                                    TO_CHAR (v_rec.expiry_date, 'MM-DD-YYYY');
            v_rec.dsp_eff_date := TO_CHAR (v_rec.eff_date, 'MM-DD-YYYY');
            v_rec.dsp_incept_date :=
                                    TO_CHAR (v_rec.incept_date, 'MM-DD-YYYY');
            v_rec.policy_no :=
                  v_rec.line_cd
               || '-'
               || v_rec.subline_cd
               || '-'
               || v_rec.iss_cd
               || '-'
               || LTRIM (TO_CHAR (v_rec.issue_yy, '09'))
               || '-'
               || LTRIM (TO_CHAR (v_rec.pol_seq_no, '0999999'))
               || '-'
               || LTRIM (TO_CHAR (v_rec.renew_no, '09'));

            BEGIN
               SELECT param_value_v
                 INTO v_rec.fire
                 FROM giis_parameters
                WHERE param_name = 'FIRE';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#E#Parameter value does not exist from giis parameters.'
                     );
            END;

            v_rec.max_expiry := NULL;
            v_rec.expired := 'N';

            IF v_rec.eff_date > SYSDATE
            THEN
               v_rec.not_yet_eff := 'Y';
            ELSE
               v_rec.not_yet_eff := 'N';
            END IF;

            FOR max_expiry IN (SELECT   expiry_date
                                   FROM gixx_block_accumulation_dist
                                  WHERE line_cd = v_rec.line_cd
                                    AND subline_cd = v_rec.subline_cd
                                    AND iss_cd = v_rec.iss_cd
                                    AND issue_yy = v_rec.issue_yy
                                    AND pol_seq_no = v_rec.pol_seq_no
                                    AND renew_no = v_rec.renew_no
                               ORDER BY endt_seq_no DESC)
            LOOP
               v_rec.max_expiry := max_expiry.expiry_date;
               v_rec.dsp_max_expiry :=
                                     TO_CHAR (v_rec.max_expiry, 'MM-DD-YYYY');

               IF (max_expiry.expiry_date) < SYSDATE
               THEN
                  v_rec.expired := 'Y';
               END IF;

               EXIT;
            END LOOP;

--            IF v_rec.incept_date > SYSDATE
--            THEN
--               v_rec.not_yet_eff := 'Y';
--            END IF;
            FOR x IN (SELECT fr_itm_tp_ds
                        FROM giis_fi_item_type
                       WHERE fr_item_type = v_rec.fr_item_type)
            LOOP
               v_rec.dsp_fr_item_type := x.fr_itm_tp_ds;
            END LOOP;

            IF v_rec.dist_flag = '1'
            THEN
               v_rec.dsp_dist_status := 'Undistributed';
            ELSIF v_rec.dist_flag = '2'
            THEN
               v_rec.dsp_dist_status := 'w/ Facultative';
            ELSIF v_rec.dist_flag = '3'
            THEN
               v_rec.dsp_dist_status := 'Distributed';
            ELSIF v_rec.dist_flag = '4'
            THEN
               v_rec.dsp_dist_status := 'Undistributed';
            ELSIF v_rec.dist_flag = '5'
            THEN
               v_rec.dsp_dist_status := 'Undistributed';
            END IF;

            v_rec.nbt_cons_desc := NULL;

            FOR a IN (SELECT construction_desc cons_desc
                        FROM giis_fire_construction
                       WHERE construction_cd = v_rec.construction_cd)
            LOOP
               v_rec.nbt_cons_desc := a.cons_desc;
               EXIT;
            END LOOP;

            IF p_mode = 'ITEM'
            THEN
               v_rec.ann_tsi_amt := 0;

               FOR a IN (SELECT ann_tsi_amt
                           FROM gixx_block_accumulation
                          WHERE item_no = v_rec.item_no
                            AND line_cd = v_rec.line_cd
                            AND subline_cd = v_rec.subline_cd
                            AND iss_cd = v_rec.iss_cd
                            AND issue_yy = v_rec.issue_yy
                            AND pol_seq_no = v_rec.pol_seq_no
                            AND renew_no = v_rec.renew_no
                            AND peril_cd IN (
                                   SELECT peril_cd
                                     FROM giis_peril
                                    WHERE peril_type = 'B'
                                      AND line_cd = v_rec.line_cd))
               LOOP
                  v_rec.ann_tsi_amt := a.ann_tsi_amt;
                  EXIT;
               END LOOP;

               v_rec.dist_tsi := 0;

               FOR a IN (SELECT SUM (dist_tsi) dist_tsi
                           FROM gixx_block_accumulation_dist
                          WHERE item_no = v_rec.item_no
                            AND line_cd = v_rec.line_cd
                            AND subline_cd = v_rec.subline_cd
                            AND iss_cd = v_rec.iss_cd
                            AND issue_yy = v_rec.issue_yy
                            AND pol_seq_no = v_rec.pol_seq_no
                            AND renew_no = v_rec.renew_no
                            AND peril_cd IN (
                                   SELECT peril_cd
                                     FROM giis_peril
                                    WHERE peril_type = 'B'
                                      AND line_cd = v_rec.line_cd))
               LOOP
                  v_rec.dist_tsi := a.dist_tsi;
                  EXIT;
               END LOOP;

               v_rec.with_claims :=
                  gipis110_pkg.record_claim_exists ('V440A',
                                                    v_rec.line_cd,
                                                    v_rec.subline_cd,
                                                    v_rec.iss_cd,
                                                    v_rec.issue_yy,
                                                    v_rec.pol_seq_no,
                                                    v_rec.renew_no
                                                   );
            ELSE
               v_rec.with_claims :=
                  gipis110_pkg.record_claim_exists ('V440',
                                                    v_rec.line_cd,
                                                    v_rec.subline_cd,
                                                    v_rec.iss_cd,
                                                    v_rec.issue_yy,
                                                    v_rec.pol_seq_no,
                                                    v_rec.renew_no
                                                   );
            END IF;

            EXIT WHEN custom%NOTFOUND;
            PIPE ROW (v_rec);
         END LOOP;

         CLOSE custom;
      END IF;
   END;

   FUNCTION record_claim_exists (
      p_block        VARCHAR2,
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd       gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_pol_seq_no   gicl_claims.pol_seq_no%TYPE,
      p_renew_no     gicl_claims.renew_no%TYPE
   )
      RETURN NUMBER
   IS
      v_claim_id   NUMBER (12) := 0;
   BEGIN
      IF UPPER (p_block) = 'V440'
      THEN
         FOR a IN (SELECT claim_id
                     FROM gicl_claims
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND pol_iss_cd = p_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no)
         LOOP
            v_claim_id := a.claim_id;
         END LOOP;
      ELSIF UPPER (p_block) = 'V440A'
      THEN
         FOR a IN (SELECT claim_id
                     FROM gicl_claims
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND pol_iss_cd = p_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no)
         LOOP
            v_claim_id := a.claim_id;
         END LOOP;
      ELSIF UPPER (p_block) = 'V440A_DIST'
      THEN
         FOR a IN (SELECT claim_id
                     FROM gicl_claims
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND pol_iss_cd = p_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no)
         LOOP
            v_claim_id := a.claim_id;
         END LOOP;
      ELSIF UPPER (p_block) = 'V440_DIST'
      THEN
         FOR a IN (SELECT claim_id
                     FROM gicl_claims
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND pol_iss_cd = p_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no)
         LOOP
            v_claim_id := a.claim_id;
         END LOOP;
      END IF;

      RETURN (v_claim_id);
   END;

   FUNCTION get_temporary_exposure (
      p_exclude           VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_share_type        gixx_block_accumulation_dist.share_type%TYPE,
      p_block_id          giis_block.block_id%TYPE,
      p_user_id           giis_users.user_id%TYPE,
      p_mode              VARCHAR2,
      p_all               VARCHAR2,
      p_risk_cd           giis_risks.risk_cd%TYPE -- nieko 07132016 KB 894
   )
      RETURN temporary_exposure_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      custom          cur_typ;
      v_rec           temporary_exposure_type;
      v_where_v441    VARCHAR2 (10000);
      v_where_v441a   VARCHAR2 (10000);
      v_where_dflt    VARCHAR2 (10000);
      v_query         VARCHAR2 (10000);
   BEGIN
      IF p_all = 'N'
      THEN
         IF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where_v441 :=
                  ' AND share_cd IN (SELECT share_cd 
                         FROM giis_dist_share
                        WHERE share_type = '''
               || p_share_type
               || ''')
         AND NVL(endt_expiry_date, expiry_date) >= SYSDATE
				 AND eff_date   <= SYSDATE';
         ELSIF NVL (p_exclude, 'N') = 'Y'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where_v441 :=
                  ' AND share_cd IN (SELECT share_cd 
                         FROM giis_dist_share
                        WHERE share_type = '''
               || p_share_type
               || ''')
         AND NVL(endt_expiry_date, expiry_date) >= SYSDATE';
         ELSIF NVL (p_exclude, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where_v441 :=
                  ' AND share_cd IN (SELECT share_cd 
                         FROM giis_dist_share
                        WHERE share_type = '''
               || p_share_type
               || ''')
         AND eff_date   <= SYSDATE';
         ELSIF NVL (p_exclude, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where_v441 :=
                  ' AND share_cd IN (SELECT share_cd 
                         FROM giis_dist_share
                        WHERE share_type = '''
               || p_share_type
               || ''')';
         END IF;
      ELSE
         IF NVL (p_exclude, 'N') = 'Y' AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where_v441 :=
                  ' AND NVL(ENDT_EXPIRY_DATE, EXPIRY_DATE) >= SYSDATE'
               || ' AND eff_date <= SYSDATE';
         ELSIF NVL (p_exclude, 'N') = 'Y'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where_v441 :=
                         ' AND NVL(ENDT_EXPIRY_DATE, EXPIRY_DATE) >= SYSDATE';
         ELSIF NVL (p_exclude, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where_v441 := ' AND  eff_date <= SYSDATE';
         ELSIF NVL (p_exclude, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where_v441 := '';
         END IF;
      END IF;

      IF p_all = 'N'
      THEN
         IF p_mode = 'ITEM'
         THEN
            v_query :=
                  'SELECT DISTINCT par_id, line_cd, subline_cd, iss_cd, issue_yy, par_yy,
                    par_seq_no, quote_seq_no, renew_no, item_no, district_no,
                    block_no, pol_flag, ann_tsi_amt, assd_no, assd_name, eff_date,
                    incept_date, expiry_date, endt_expiry_date, dist_flag,
                    tarf_cd, construction_cd, loc_risk, province_cd, city,
                    block_id, dist_tsi, share_cd, par_no, fr_item_type, risk_cd,
                    '''', '''', '''', '''', ''''
               FROM gipi_fire_basic_item_dist_v4 
              WHERE 1 = 1 AND block_id ='''
               || p_block_id
               || ''' '
               || 'AND NVL(risk_cd,0) ='
               || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 08042016 KB 894
               || ' '
               || v_where_v441
               || ' ORDER BY line_cd,  iss_cd, par_yy, par_seq_no, quote_seq_no, item_no';
         ELSE
            v_query :=
                  'SELECT DISTINCT par_id, line_cd, subline_cd, iss_cd, issue_yy, par_yy,
                    par_seq_no, quote_seq_no, renew_no, item_no, district_no,
                    block_no, pol_flag, ann_tsi_amt, assd_no, assd_name, eff_date,
                    incept_date, expiry_date, endt_expiry_date, dist_flag,
                    tarf_cd, construction_cd, loc_risk, province_cd, city, 
                    block_id, dist_tsi, share_cd, par_no, fr_item_type, risk_cd, 
                    peril_type, peril_cd, prem_rt, peril_sname, peril_name
               FROM gipi_fire_basic_item_dist_v2
              WHERE 1 = 1 AND block_id ='''
               || p_block_id
               || ''' '
               || 'AND NVL(risk_cd,0) ='
               || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 08042016 KB 894
               || ' '
               || v_where_v441
               || ' ORDER BY line_cd,  iss_cd, par_yy, par_seq_no, quote_seq_no, item_no';
         END IF;

         OPEN custom FOR v_query;

         LOOP
            FETCH custom
             INTO v_rec.par_id, v_rec.line_cd, v_rec.subline_cd,
                  v_rec.iss_cd, v_rec.issue_yy, v_rec.par_yy,
                  v_rec.par_seq_no, v_rec.quote_seq_no, v_rec.renew_no,
                  v_rec.item_no, v_rec.district_no, v_rec.block_no,
                  v_rec.pol_flag, v_rec.ann_tsi_amt, v_rec.assd_no,
                  v_rec.assd_name, v_rec.eff_date, v_rec.incept_date,
                  v_rec.expiry_date, v_rec.endt_expiry_date, v_rec.dist_flag,
                  v_rec.tarf_cd, v_rec.construction_cd, v_rec.loc_risk,
                  v_rec.province_cd, v_rec.city, v_rec.block_id,
                  v_rec.dist_tsi, v_rec.share_cd, v_rec.par_no,
                  v_rec.fr_item_type, v_rec.risk_cd, v_rec.peril_type,
                  v_rec.peril_cd, v_rec.prem_rt, v_rec.peril_sname,
                  v_rec.peril_name;

            v_rec.dsp_expiry_date :=
                                    TO_CHAR (v_rec.expiry_date, 'MM-DD-YYYY');
            v_rec.dsp_eff_date := TO_CHAR (v_rec.eff_date, 'MM-DD-YYYY');
            v_rec.dsp_par_no :=
                  v_rec.line_cd
               || '-'
               || v_rec.iss_cd
               || '-'
               || LTRIM (TO_CHAR (v_rec.par_yy, '09'))
               || '-'
               || LTRIM (TO_CHAR (v_rec.par_seq_no, '099999'))
               || '-'
               || LTRIM (TO_CHAR (v_rec.quote_seq_no, '09'));

            BEGIN
               SELECT param_value_v
                 INTO v_rec.fire
                 FROM giis_parameters
                WHERE param_name = 'FIRE';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#E#Parameter value does not exist from giis parameters.'
                     );
            END;

            FOR x IN (SELECT fr_itm_tp_ds
                        FROM giis_fi_item_type
                       WHERE fr_item_type = v_rec.fr_item_type)
            LOOP
               v_rec.dsp_fr_item_type := x.fr_itm_tp_ds;
            END LOOP;

            IF v_rec.endt_expiry_date IS NULL
            THEN
               v_rec.max_expiry := v_rec.expiry_date;
            ELSE
               v_rec.max_expiry := v_rec.endt_expiry_date;
            END IF;

            v_rec.dsp_max_expiry := TO_CHAR (v_rec.max_expiry, 'MM-DD-YYYY');
            v_rec.expired := 'N';
            v_rec.not_yet_eff := 'N';

            IF NVL (v_rec.endt_expiry_date, v_rec.expiry_date) < SYSDATE
            THEN
               v_rec.expired := 'Y';
            END IF;

            FOR a IN (SELECT eff_date
                        FROM gipi_wpolbas
                       WHERE par_id = v_rec.par_id)
            LOOP
               IF a.eff_date > SYSDATE
               THEN
                  v_rec.not_yet_eff := 'Y';
               END IF;

               EXIT;
            END LOOP;

            IF v_rec.dist_flag = '1'
            THEN
               v_rec.dsp_dist_status := 'Undistributed';
            ELSIF v_rec.dist_flag = '2'
            THEN
               v_rec.dsp_dist_status := 'w/ Facultative';
            ELSIF v_rec.dist_flag = '3'
            THEN
               v_rec.dsp_dist_status := 'Distributed';
            ELSIF v_rec.dist_flag = '4'
            THEN
               v_rec.dsp_dist_status := 'Undistributed';
            ELSIF v_rec.dist_flag = '5'
            THEN
               v_rec.dsp_dist_status := 'Undistributed';
            END IF;

            v_rec.nbt_cons_desc := NULL;

            FOR a IN (SELECT construction_desc cons_desc
                        FROM giis_fire_construction
                       WHERE construction_cd = v_rec.construction_cd)
            LOOP
               v_rec.nbt_cons_desc := a.cons_desc;
               EXIT;
            END LOOP;

            IF p_mode = 'ITEM'
            THEN
               v_rec.with_claims :=
                  gipis110_pkg.record_claim_exists ('V441A_DIST',
--ito rin parang mali wala naman sa condition nung record_claim_exists ung 'V441A_DIST'...
                                                    v_rec.line_cd,
                                                    v_rec.subline_cd,
                                                    v_rec.iss_cd,
                                                    v_rec.par_yy,
                                                    v_rec.par_seq_no,
                                                    v_rec.renew_no
                                                   );
            ELSE
               v_rec.with_claims :=
                  gipis110_pkg.record_claim_exists ('V441_DIST',
--ito rin parang mali wala naman sa condition nung record_claim_exists ung 'V441_DIST'...
                                                    v_rec.line_cd,
                                                    v_rec.subline_cd,
                                                    v_rec.iss_cd,
                                                    v_rec.par_yy,
                                                    v_rec.par_seq_no,
                                                    v_rec.renew_no
                                                   );
            END IF;

            EXIT WHEN custom%NOTFOUND;
            PIPE ROW (v_rec);
         END LOOP;

         CLOSE custom;
      ELSE
         IF p_mode = 'ITEM'
         THEN
            v_query :=
                  'SELECT DISTINCT par_id, line_cd, subline_cd, iss_cd, issue_yy, par_yy,
                par_seq_no, quote_seq_no, renew_no, item_no, district_no,
                block_no, pol_flag, ann_tsi_amt, assd_no, assd_name, eff_date,
                incept_date, expiry_date, endt_expiry_date, dist_flag,
                tarf_cd, construction_cd, loc_risk, province_cd, city,
                block_id, par_no, fr_item_type, risk_cd,
                '''', '''', '''', ''''
           FROM gipi_fire_basic_item_v4
          WHERE 1 = 1 AND block_id ='''
               || p_block_id
               || ''' '
               || 'AND NVL(risk_cd,0) ='
               || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 08042016 KB 894
               || ' '
               || v_where_v441
               || ' ORDER BY line_cd,  iss_cd, par_yy, par_seq_no, quote_seq_no, item_no';
         ELSE
            v_query :=
                  'SELECT DISTINCT par_id, line_cd, subline_cd, iss_cd, issue_yy, par_yy,
                par_seq_no, quote_seq_no, renew_no, item_no, district_no,
                block_no, pol_flag, ann_tsi_amt, assd_no, assd_name, eff_date,
                incept_date, expiry_date, endt_expiry_date, dist_flag,
                tarf_cd, construction_cd, loc_risk, province_cd, city, 
                block_id, par_no, fr_item_type, risk_cd,
                peril_cd, prem_rt, peril_sname, peril_name
           FROM gipi_fire_basic_item_v2
          WHERE 1 = 1 AND block_id ='''
               || p_block_id
               || ''' '
               || 'AND NVL(risk_cd,0) ='
               || 'DECODE(''' || p_risk_cd || ''' , ''AR'', NVL (risk_cd, 0), ''' || p_risk_cd || ''')'        -- nieko 08042016 KB 894
               || ' '
               || v_where_v441
               || ' ORDER BY line_cd,  iss_cd, par_yy, par_seq_no, quote_seq_no, item_no';
         END IF;

         OPEN custom FOR v_query;

         LOOP
            FETCH custom
             INTO v_rec.par_id, v_rec.line_cd, v_rec.subline_cd,
                  v_rec.iss_cd, v_rec.issue_yy, v_rec.par_yy,
                  v_rec.par_seq_no, v_rec.quote_seq_no, v_rec.renew_no,
                  v_rec.item_no, v_rec.district_no, v_rec.block_no,
                  v_rec.pol_flag, v_rec.ann_tsi_amt, v_rec.assd_no,
                  v_rec.assd_name, v_rec.eff_date, v_rec.incept_date,
                  v_rec.expiry_date, v_rec.endt_expiry_date, v_rec.dist_flag,
                  v_rec.tarf_cd, v_rec.construction_cd, v_rec.loc_risk,
                  v_rec.province_cd, v_rec.city, v_rec.block_id,
                  v_rec.par_no, v_rec.fr_item_type, v_rec.risk_cd,
                  v_rec.peril_cd, v_rec.prem_rt, v_rec.peril_sname,
                  v_rec.peril_name;

            v_rec.dsp_expiry_date :=
                                    TO_CHAR (v_rec.expiry_date, 'MM-DD-YYYY');
            v_rec.dsp_eff_date := TO_CHAR (v_rec.eff_date, 'MM-DD-YYYY');
            v_rec.dsp_incept_date :=
                                    TO_CHAR (v_rec.incept_date, 'MM-DD-YYYY');
            v_rec.dsp_par_no :=
                  v_rec.line_cd
               || '-'
               || v_rec.iss_cd
               || '-'
               || LTRIM (TO_CHAR (v_rec.par_yy, '09'))
               || '-'
               || LTRIM (TO_CHAR (v_rec.par_seq_no, '099999'))
               || '-'
               || LTRIM (TO_CHAR (v_rec.quote_seq_no, '09'));

            BEGIN
               SELECT param_value_v
                 INTO v_rec.fire
                 FROM giis_parameters
                WHERE param_name = 'FIRE';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#E#Parameter value does not exist from giis parameters.'
                     );
            END;

            FOR x IN (SELECT fr_itm_tp_ds
                        FROM giis_fi_item_type
                       WHERE fr_item_type = v_rec.fr_item_type)
            LOOP
               v_rec.dsp_fr_item_type := x.fr_itm_tp_ds;
            END LOOP;

            v_rec.expired := 'N';
            v_rec.not_yet_eff := 'N';

            IF v_rec.endt_expiry_date IS NULL
            THEN
               v_rec.max_expiry := v_rec.expiry_date;
            ELSE
               v_rec.max_expiry := v_rec.endt_expiry_date;
            END IF;

            v_rec.dsp_max_expiry := TO_CHAR (v_rec.max_expiry, 'MM-DD-YYYY');

            IF NVL (v_rec.endt_expiry_date, v_rec.expiry_date) < SYSDATE
            THEN
               v_rec.expired := 'Y';
            END IF;

            FOR a IN (SELECT eff_date
                        FROM gipi_wpolbas
                       WHERE par_id = v_rec.par_id)
            LOOP
               IF a.eff_date > SYSDATE
               THEN
                  v_rec.not_yet_eff := 'Y';
               END IF;

               EXIT;
            END LOOP;

            IF v_rec.dist_flag = '1'
            THEN
               v_rec.dsp_dist_status := 'Undistributed';
            ELSIF v_rec.dist_flag = '2'
            THEN
               v_rec.dsp_dist_status := 'w/ Facultative';
            ELSIF v_rec.dist_flag = '3'
            THEN
               v_rec.dsp_dist_status := 'Distributed';
            ELSIF v_rec.dist_flag = '4'
            THEN
               v_rec.dsp_dist_status := 'Undistributed';
            ELSIF v_rec.dist_flag = '5'
            THEN
               v_rec.dsp_dist_status := 'Undistributed';
            END IF;

            v_rec.nbt_cons_desc := NULL;

            FOR a IN (SELECT construction_desc cons_desc
                        FROM giis_fire_construction
                       WHERE construction_cd = v_rec.construction_cd)
            LOOP
               v_rec.nbt_cons_desc := a.cons_desc;
               EXIT;
            END LOOP;

            IF p_mode = 'ITEM'
            THEN
               v_rec.with_claims :=
                  gipis110_pkg.record_claim_exists ('V441A',
--ito rin parang mali wala naman sa condition nung record_claim_exists ung 'V441A'...
                                                    v_rec.line_cd,
                                                    v_rec.subline_cd,
                                                    v_rec.iss_cd,
                                                    v_rec.par_yy,
                                                    v_rec.par_seq_no,
                                                    v_rec.renew_no
                                                   );
            ELSE
               v_rec.with_claims :=
                  gipis110_pkg.record_claim_exists ('V441',
--ito rin parang mali wala naman sa condition nung record_claim_exists ung 'V441'...
                                                    v_rec.line_cd,
                                                    v_rec.subline_cd,
                                                    v_rec.iss_cd,
                                                    v_rec.par_yy,
                                                    v_rec.par_seq_no,
                                                    v_rec.renew_no
                                                   );
            END IF;

            EXIT WHEN custom%NOTFOUND;
            PIPE ROW (v_rec);
         END LOOP;

         CLOSE custom;
      END IF;
   END;
   
   --nieko 07132016 KB 894
   FUNCTION gipis110_block_risk (
      p_block_id        giis_block.block_id%TYPE
   )
      RETURN giis_block_risk_tab PIPELINED
   IS
    v_rec giis_block_risk_type;
   BEGIN
      FOR i IN (SELECT a.block_id, district_no, block_no, block_desc, risk_cd, risk_desc,
                       retn_lim_amt, trty_lim_amt
                  FROM giis_block a, giis_risks b
                 WHERE a.block_id = b.block_id AND a.block_id = p_block_id
                UNION
                SELECT c.block_id, district_no, block_no, block_desc, '0', 'NO RISKS',
                       retn_lim_amt, trty_lim_amt
                  FROM giis_block c
                 WHERE c.block_id = p_block_id
                UNION
                SELECT c.block_id, district_no, block_no, block_desc, 'AR', 'ALL RISKS',
                       retn_lim_amt, trty_lim_amt
                  FROM giis_block c
                 WHERE c.block_id = p_block_id)
      
      LOOP
         v_rec.block_id     := i.block_id;
         v_rec.district_no  := i.district_no;
         v_rec.block_no     := i.block_no;
         v_rec.block_desc   := i.block_desc;
         v_rec.risk_cd      := i.risk_cd;
         v_rec.risk_desc    := i.risk_desc;
         v_rec.retn_lim_amt := i.retn_lim_amt;
         v_rec.trty_lim_amt := i.trty_lim_amt;
         PIPE ROW (v_rec);
      END LOOP;
   END;
   
   FUNCTION get_giis_block_risk_dtl (
      p_block_id          giis_block.block_id%TYPE,
      p_exclude_not_eff   VARCHAR2,
      p_exclude           VARCHAR2,
      p_user_id           giis_users.user_id%TYPE,
      p_district_no       giis_block.district_no%TYPE,
      p_block_no          giis_block.block_no%TYPE,
      p_province_cd       giis_block.province_cd%TYPE,
      p_city              giis_block.city%TYPE,
      p_risk_cd           giis_risks.risk_cd%TYPE,
      p_bus_type          NUMBER
   )
      RETURN giis_block_dtl_tab PIPELINED
   IS
      v_rec                giis_block_dtl_type;
      v_manual_counter     NUMBER                    := 0;
      v_risk_cd            giis_risks.risk_cd%TYPE;
      v_manual             NUMBER                    := 0;
      v_manual_sum         NUMBER                    := 0;
      v_actual_sum         NUMBER                    := 0;
      v_temporary_sum      NUMBER                    := 0;
      v_sum_tot            NUMBER                    := 0;
      v_block_actual_sum   NUMBER                    := 0;
      v_block_temp_sum     NUMBER                    := 0;
      v_block_manual_sum   NUMBER                    := 0;
      v_block_sum_tot      NUMBER                    := 0;
   BEGIN
      gipis110_pkg.get_block_act_exposures (p_exclude,
                                            p_exclude_not_eff,
                                            p_user_id,
                                            p_district_no,
                                            p_block_no,
                                            p_province_cd,
                                            p_city,
                                            v_rec.actual,
                                            v_block_actual_sum,
                                            null    --nieko 07132016 kb 894
                                           );
      gipis110_pkg.get_block_temp_exposures (p_exclude,
                                             p_exclude_not_eff,
                                             p_user_id,
                                             p_district_no,
                                             p_block_no,
                                             p_province_cd,
                                             p_city,
                                             v_block_temp_sum,
                                             null,    --nieko 07132016 kb 894
                                             p_bus_type
                                            );

      
      IF p_risk_cd <> '0' and p_risk_cd <> 'AR'
      THEN
          SELECT risk_cd, risk_desc
            INTO v_rec.risk_cd, v_rec.risk_desc
            FROM giis_risks
           WHERE block_id = p_block_id
             AND risk_cd = p_risk_cd;
      ELSIF p_risk_cd = '0'
      THEN
        v_rec.risk_cd := '0';
        v_rec.risk_desc := 'NO RISK';
      ELSE 
        v_rec.risk_cd := 'AR';
        v_rec.risk_desc := 'ALL RISK';
        --nieko 08042016 kb 894
      END IF;

      FOR i IN (SELECT   *
                    FROM ((SELECT ROWNUM, rv_low_value, rv_meaning,
                                  p_block_id, v_rec.risk_cd risk_cd, v_rec.risk_desc risk_desc
                             FROM cg_ref_codes
                            WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE'
                              AND ROWNUM < 4)
                          UNION ALL
                          (SELECT 4, '', '', 0, '0', 'NO RISK'
                             FROM DUAL
                           UNION ALL
                           SELECT 5, '', '', 0, '0', 'NO RISK'
                             FROM DUAL))
                ORDER BY rv_low_value)
      LOOP
         v_rec.rv_low_value := i.rv_low_value;
         v_rec.rv_meaning := i.rv_meaning;
         v_manual_counter := v_manual_counter + 1;

         IF v_manual_counter < 4
         THEN
            gipis110_pkg.get_itemds_dtl_manual (v_manual_counter,
                                                p_block_id,
                                                v_manual
                                               );
            v_rec.MANUAL := v_manual;

            IF NVL (p_exclude, 'N') = 'Y'
               AND NVL (p_exclude_not_eff, 'N') = 'Y'
            THEN
               FOR x1 IN (SELECT a.line_cd
                            FROM giis_line a
                           WHERE EXISTS (
                                    SELECT 'X'
                                      FROM gixx_block_accumulation_dist
                                     WHERE NVL (endt_expiry_date,
                                                expiry_date) >= SYSDATE
                                       AND eff_date <= SYSDATE
                                       AND line_cd = a.line_cd
                                       AND block_id = p_block_id
                                    UNION
                                    SELECT 'X'
                                      FROM gipi_fire_basic_item_dist_v2
                                     WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                       SYSDATE
                                       AND eff_date <= SYSDATE
                                       AND line_cd = a.line_cd
                                       AND block_id = p_block_id))
               LOOP
                  gipis110_pkg.get_itemds_dtl_act (x1.line_cd,
                                                   p_exclude,
                                                   p_exclude_not_eff,
                                                   p_user_id,
                                                   p_district_no,
                                                   p_block_no,
                                                   p_province_cd,
                                                   p_city,
                                                   i.rv_low_value,
                                                   v_rec.risk_cd,
                                                   v_rec.actual
                                                  );
                  gipis110_pkg.get_itemds_dtl_temp (x1.line_cd,
                                                    p_exclude,
                                                    p_exclude_not_eff,
                                                    p_user_id,
                                                    p_district_no,
                                                    p_block_no,
                                                    p_province_cd,
                                                    p_city,
                                                    i.rv_low_value,
                                                    v_rec.risk_cd,
                                                    v_rec.TEMPORARY,
                                                    p_bus_type
                                                   );
               END LOOP;
            ELSIF     NVL (p_exclude, 'N') = 'Y'
                  AND NVL (p_exclude_not_eff, 'N') = 'N'
            THEN
               FOR x1 IN (SELECT a.line_cd
                            FROM giis_line a
                           WHERE EXISTS (
                                    SELECT 'X'
                                      FROM gixx_block_accumulation_dist
                                     WHERE NVL (endt_expiry_date,
                                                expiry_date) >= SYSDATE
                                       AND block_id = p_block_id
                                       AND line_cd = a.line_cd
                                    UNION
                                    SELECT 'X'
                                      FROM gipi_fire_basic_item_dist_v2
                                     WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                       SYSDATE
                                       AND block_id = p_block_id
                                       AND line_cd = a.line_cd))
               LOOP
                  gipis110_pkg.get_itemds_dtl_act (x1.line_cd,
                                                   p_exclude,
                                                   p_exclude_not_eff,
                                                   p_user_id,
                                                   p_district_no,
                                                   p_block_no,
                                                   p_province_cd,
                                                   p_city,
                                                   i.rv_low_value,
                                                   v_rec.risk_cd,
                                                   v_rec.actual
                                                  );
                  gipis110_pkg.get_itemds_dtl_temp (x1.line_cd,
                                                    p_exclude,
                                                    p_exclude_not_eff,
                                                    p_user_id,
                                                    p_district_no,
                                                    p_block_no,
                                                    p_province_cd,
                                                    p_city,
                                                    i.rv_low_value,
                                                    v_rec.risk_cd,
                                                    v_rec.TEMPORARY,
                                                    p_bus_type
                                                   );
               END LOOP;
            ELSIF     NVL (p_exclude, 'N') = 'N'
                  AND NVL (p_exclude_not_eff, 'N') = 'Y'
            THEN
               FOR x1 IN (SELECT a.line_cd
                            FROM giis_line a
                           WHERE EXISTS (
                                    SELECT 'X'
                                      FROM gixx_block_accumulation_dist
                                     WHERE eff_date <= SYSDATE
                                       AND block_id = p_block_id
                                       AND line_cd = a.line_cd
                                    UNION
                                    SELECT 'X'
                                      FROM gipi_fire_basic_item_dist_v2
                                     WHERE eff_date <= SYSDATE
                                       AND block_id = p_block_id
                                       AND line_cd = a.line_cd))
               LOOP
                  gipis110_pkg.get_itemds_dtl_act (x1.line_cd,
                                                   p_exclude,
                                                   p_exclude_not_eff,
                                                   p_user_id,
                                                   p_district_no,
                                                   p_block_no,
                                                   p_province_cd,
                                                   p_city,
                                                   i.rv_low_value,
                                                   v_rec.risk_cd,
                                                   v_rec.actual
                                                  );
                  gipis110_pkg.get_itemds_dtl_temp (x1.line_cd,
                                                    p_exclude,
                                                    p_exclude_not_eff,
                                                    p_user_id,
                                                    p_district_no,
                                                    p_block_no,
                                                    p_province_cd,
                                                    p_city,
                                                    i.rv_low_value,
                                                    v_rec.risk_cd,
                                                    v_rec.TEMPORARY,
                                                    p_bus_type
                                                   );
               END LOOP;
            ELSIF     NVL (p_exclude, 'N') = 'N'
                  AND NVL (p_exclude_not_eff, 'N') = 'N'
            THEN
               FOR x1 IN (SELECT a.line_cd
                            FROM giis_line a
                           WHERE EXISTS (
                                    SELECT 'X'
                                      FROM gixx_block_accumulation_dist
                                     WHERE block_id = p_block_id
                                       AND line_cd = a.line_cd
                                    UNION
                                    SELECT 'X'
                                      FROM gipi_fire_basic_item_dist_v2
                                     WHERE block_id = p_block_id
                                       AND line_cd = a.line_cd))
               LOOP
                  gipis110_pkg.get_itemds_dtl_act (x1.line_cd,
                                                   p_exclude,
                                                   p_exclude_not_eff,
                                                   p_user_id,
                                                   p_district_no,
                                                   p_block_no,
                                                   p_province_cd,
                                                   p_city,
                                                   i.rv_low_value,
                                                   v_rec.risk_cd,
                                                   v_rec.actual
                                                  );
                  gipis110_pkg.get_itemds_dtl_temp (x1.line_cd,
                                                    p_exclude,
                                                    p_exclude_not_eff,
                                                    p_user_id,
                                                    p_district_no,
                                                    p_block_no,
                                                    p_province_cd,
                                                    p_city,
                                                    i.rv_low_value,
                                                    v_rec.risk_cd,
                                                    v_rec.TEMPORARY,
                                                    p_bus_type
                                                   );
               END LOOP;
            END IF;

            IF v_rec.MANUAL IS NULL
            THEN
               v_rec.MANUAL := 0;
            END IF;

            IF v_rec.actual IS NULL
            THEN
               v_rec.actual := 0;
            END IF;

            IF v_rec.TEMPORARY IS NULL
            THEN
               v_rec.TEMPORARY := 0;
            END IF;

            IF v_risk_cd IS NULL
            THEN
               v_risk_cd := v_rec.risk_cd;
            END IF;
         END IF;

         --reset to zero for new risk.
         IF v_risk_cd <> v_rec.risk_cd
         THEN
            IF v_manual_counter = 4
            THEN
               v_rec.actual := 0;
               v_rec.TEMPORARY := 0;
               v_rec.expo_sum := 0;
            END IF;

            IF v_manual_counter < 4
            THEN
               v_rec.expo_sum := 0;
               v_risk_cd := v_rec.risk_cd;
            END IF;
         END IF;

         IF v_manual_counter < 4
         THEN
            v_block_manual_sum := v_block_manual_sum + v_rec.MANUAL;
            v_block_sum_tot :=
                 NVL (v_block_manual_sum, 0)
               + NVL (v_block_actual_sum, 0)
               + NVL (v_block_temp_sum, 0);
            v_manual_sum := v_manual_sum + v_rec.MANUAL;
            v_actual_sum := NVL (v_actual_sum, 0) + NVL (v_rec.actual, 0);
            v_temporary_sum :=
                            NVL (v_temporary_sum, 0)
                            + NVL (v_rec.TEMPORARY, 0);
            v_sum_tot := v_manual_sum + v_actual_sum + v_temporary_sum;
            v_rec.expo_sum :=
                         NVL (v_rec.MANUAL, 0) + v_rec.actual
                         + v_rec.TEMPORARY;
         END IF;

         IF v_manual_counter = 4
         THEN
            v_rec.MANUAL := v_manual_sum;
            v_rec.actual := v_actual_sum;
            v_rec.TEMPORARY := v_temporary_sum;
            v_rec.expo_sum := v_sum_tot;
            v_rec.rv_meaning := 'Risk Total';
         END IF;

         IF v_manual_counter = 5
         THEN
            v_rec.MANUAL := v_block_manual_sum;
            v_rec.actual := v_block_actual_sum;
            v_rec.TEMPORARY := v_block_temp_sum;
            v_rec.expo_sum := v_block_sum_tot;
            v_rec.rv_meaning := 'Block Total';
         END IF;

         PIPE ROW (v_rec);
      END LOOP;
   END;
   --nieko 07132016  end
END;
/


