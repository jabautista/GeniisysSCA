CREATE OR REPLACE PACKAGE BODY CPI.gipis109_pkg
AS
   /*
   **  Created by        : Steven Ramirez
   **  Date Created      : 09.06.2013
   **  Reference By      : GIPIS109 - View Vessel Accumulation
   */
   FUNCTION get_giis_vessel (p_refresh VARCHAR2, p_enter_query VARCHAR2)
      RETURN giis_vessel_tab PIPELINED
   IS
      v_rec   giis_vessel_type;
   BEGIN
      IF p_enter_query = 'N'
      THEN
         v_rec.line_mn_msg := NULL;
         v_rec.line_mh_msg := NULL;
         v_rec.line_av_msg := NULL;

         BEGIN
            SELECT param_value_v
              INTO v_rec.line_mn
              FROM giis_parameters
             WHERE param_name = 'LINE_CODE_MN';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               IF p_refresh = 'N'
               THEN
                  v_rec.line_mn_msg :=
                        'Parameter for the line code of Marine Cargo returns no value, '
                     || 'Please contact your DBA.';
               ELSE
                  v_rec.line_mn := NULL;
               END IF;
            WHEN TOO_MANY_ROWS
            THEN
               IF p_refresh = 'N'
               THEN
                  v_rec.line_mn_msg :=
                        'Parameter for the line code of Marine Cargo returns too many rows, '
                     || 'Please contact your DBA.';
               ELSE
                  v_rec.line_mn := NULL;
               END IF;
         END;

         BEGIN
            SELECT param_value_v
              INTO v_rec.line_mh
              FROM giis_parameters
             WHERE param_name = 'LINE_CODE_MH';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               IF p_refresh = 'N'
               THEN
                  v_rec.line_mh_msg :=
                        'Parameter for the line code of Marine Hull returns no value, '
                     || 'Please contact your DBA.';
               ELSE
                  v_rec.line_mh := NULL;
               END IF;
            WHEN TOO_MANY_ROWS
            THEN
               IF p_refresh = 'N'
               THEN
                  v_rec.line_mh_msg :=
                        'Parameter for the line code of Marine Hull returns too many rows, '
                     || 'Please contact your DBA.';
               ELSE
                  v_rec.line_mh := NULL;
               END IF;
         END;

         BEGIN
            SELECT param_value_v
              INTO v_rec.line_av
              FROM giis_parameters
             WHERE param_name = 'LINE_CODE_AV';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               IF p_refresh = 'N'
               THEN
                  v_rec.line_av_msg :=
                        'Parameter for the line code of Aviation returns no value, '
                     || 'Please contact your DBA.';
               ELSE
                  v_rec.line_av := NULL;
               END IF;
            WHEN TOO_MANY_ROWS
            THEN
               IF p_refresh = 'N'
               THEN
                  v_rec.line_av_msg :=
                        'Parameter for the line code of Aviation returns too many rows, '
                     || 'Please contact your DBA.';
               ELSE
                  v_rec.line_av := NULL;
               END IF;
         END;

         IF     v_rec.line_mn_msg IS NULL
            AND v_rec.line_mh_msg IS NULL
            AND v_rec.line_av_msg IS NULL
         THEN
            FOR i IN (SELECT   vessel_cd, vessel_name, vessel_flag
                          FROM giis_vessel
                      ORDER BY vessel_cd)
            LOOP
               v_rec.vessel_cd := i.vessel_cd;
               v_rec.vessel_name := i.vessel_name;
               v_rec.vessel_flag := i.vessel_flag;

               BEGIN
                  IF i.vessel_flag = 'A'
                  THEN
                     v_rec.nbt_vestype := 'Aircraft';
                  ELSIF i.vessel_flag = 'V'
                  THEN
                     v_rec.nbt_vestype := 'Vessel';
                  ELSIF i.vessel_flag = 'I'
                  THEN
                     v_rec.nbt_vestype := 'Inland';
                  ELSE
                     v_rec.nbt_vestype := 'Others';
                  END IF;

                  v_rec.exclude_expired := 'Y';
                  v_rec.exclude_not_eff := 'Y';
                  v_rec.bus_type := 3;
               END;

               PIPE ROW (v_rec);
            END LOOP;
         ELSE
            PIPE ROW (v_rec);
         END IF;
      END IF;
   END;

   /*Modified by : Iris Bordey
   **Date        : 07.24.2002
   **Desc        : Copied scripit from when-button-pressed trigger of :a1160.ok_btn
   */
   FUNCTION get_exposures (
      p_vessel_cd         giis_vessel.vessel_cd%TYPE,
--      p_vessel_name       giis_vessel.vessel_name%TYPE,
--      p_bus_type          NUMBER,
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2
   )
      RETURN vessel_accum_dtl_tab PIPELINED
   IS
      v_rec   vessel_accum_dtl_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE'
                ORDER BY rv_low_value)
      LOOP
         v_rec.actual := 0;
         v_rec.TEMPORARY := 0;

         IF     NVL (p_exclude_expired, 'N') = 'Y'
            AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            FOR x1 IN (SELECT DISTINCT line_cd
                                  FROM gixx_vessel_acc_dist
                                 WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                      SYSDATE
                                   AND eff_date <= SYSDATE
                                   AND vessel_cd = p_vessel_cd
                       UNION
                       SELECT DISTINCT line_cd
                                  FROM gipi_vessel_acc_dist_v4
                                 WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                       SYSDATE
                                   AND eff_date <= SYSDATE
                                   AND vessel_cd = p_vessel_cd)
            LOOP
               v_rec.line_cd := x1.line_cd;
               gipis109_pkg.get_itemds_dtl_act (p_exclude_expired,
                                                p_exclude_not_eff,
                                                x1.line_cd,
                                                p_vessel_cd,
                                                i.rv_low_value,
                                                v_rec.actual
                                               );
               gipis109_pkg.get_itemds_dtl_temp (p_exclude_expired,
                                                 p_exclude_not_eff,
                                                 x1.line_cd,
                                                 p_vessel_cd,
                                                 i.rv_low_value,
                                                 v_rec.TEMPORARY
                                                );
            END LOOP;
         ELSIF     NVL (p_exclude_expired, 'N') = 'Y'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            FOR x1 IN (SELECT DISTINCT line_cd
                                  FROM gixx_vessel_acc_dist
                                 WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                      SYSDATE
                                   AND vessel_cd = p_vessel_cd
                       UNION
                       SELECT DISTINCT line_cd
                                  FROM gipi_vessel_acc_dist_v4
                                 WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                       SYSDATE
                                   AND vessel_cd = p_vessel_cd)
            LOOP
               v_rec.line_cd := x1.line_cd;
               gipis109_pkg.get_itemds_dtl_act (p_exclude_expired,
                                                p_exclude_not_eff,
                                                x1.line_cd,
                                                p_vessel_cd,
                                                i.rv_low_value,
                                                v_rec.actual
                                               );
               gipis109_pkg.get_itemds_dtl_temp (p_exclude_expired,
                                                 p_exclude_not_eff,
                                                 x1.line_cd,
                                                 p_vessel_cd,
                                                 i.rv_low_value,
                                                 v_rec.TEMPORARY
                                                );
            END LOOP;
         ELSIF     NVL (p_exclude_expired, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            FOR x1 IN (SELECT DISTINCT line_cd
                                  FROM gixx_vessel_acc_dist
                                 WHERE eff_date <= SYSDATE
                                   AND vessel_cd = p_vessel_cd
                       UNION
                       SELECT DISTINCT line_cd
                                  FROM gipi_vessel_acc_dist_v4
                                 WHERE eff_date <= SYSDATE
                                   AND vessel_cd = p_vessel_cd)
            LOOP
               v_rec.line_cd := x1.line_cd;
               gipis109_pkg.get_itemds_dtl_act (p_exclude_expired,
                                                p_exclude_not_eff,
                                                x1.line_cd,
                                                p_vessel_cd,
                                                i.rv_low_value,
                                                v_rec.actual
                                               );
               gipis109_pkg.get_itemds_dtl_temp (p_exclude_expired,
                                                 p_exclude_not_eff,
                                                 x1.line_cd,
                                                 p_vessel_cd,
                                                 i.rv_low_value,
                                                 v_rec.TEMPORARY
                                                );
            END LOOP;
         ELSIF     NVL (p_exclude_expired, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            FOR x1 IN (SELECT DISTINCT line_cd
                                  FROM gixx_vessel_acc_dist
                                 WHERE vessel_cd = p_vessel_cd
                       UNION
                       SELECT DISTINCT line_cd
                                  FROM gipi_vessel_acc_dist_v4
                                 WHERE vessel_cd = p_vessel_cd)
            LOOP
               v_rec.line_cd := x1.line_cd;
               gipis109_pkg.get_itemds_dtl_act (p_exclude_expired,
                                                p_exclude_not_eff,
                                                x1.line_cd,
                                                p_vessel_cd,
                                                i.rv_low_value,
                                                v_rec.actual
                                               );
               gipis109_pkg.get_itemds_dtl_temp (p_exclude_expired,
                                                 p_exclude_not_eff,
                                                 x1.line_cd,
                                                 p_vessel_cd,
                                                 i.rv_low_value,
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

         v_rec.rv_low_value := i.rv_low_value;
         v_rec.expo_sum := NVL (v_rec.actual, 0) + NVL (v_rec.TEMPORARY, 0);
         PIPE ROW (v_rec);
      END LOOP;
   END;

   PROCEDURE get_itemds_dtl_act (
      p_exclude_expired            VARCHAR2,
      p_exclude_not_eff            VARCHAR2,
      p_line_cd                    VARCHAR2,
      p_vessel_cd                  giis_vessel.vessel_cd%TYPE,
      p_rv_low_value               cg_ref_codes.rv_low_value%TYPE,
      p_actual            IN OUT   NUMBER
   )
   IS
      v_dist_tsi   NUMBER := 0;
   BEGIN
      /*** ACTUAL EXPOSURE ***/
      IF p_exclude_expired = 'Y' AND p_exclude_not_eff = 'Y'
      THEN
         FOR d1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gixx_vessel_acc_dist x,
                             giis_dist_share a160,
                             giis_peril y,
                             gipi_item z
                       WHERE x.line_cd = p_line_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND x.share_cd = a160.share_cd
                         AND x.line_cd = a160.line_cd
                         AND a160.share_type = p_rv_low_value
                         AND y.line_cd = x.line_cd
                         AND x.peril_cd = y.peril_cd
                         AND x.policy_id = z.policy_id
                         AND x.item_no = z.item_no
                         AND x.expiry_date >= SYSDATE
                         AND x.eff_date <= SYSDATE
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + d1.dist_tsi;
         END LOOP;
      ELSIF p_exclude_expired = 'Y' AND p_exclude_not_eff = 'N'
      THEN
         FOR d1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gixx_vessel_acc_dist x,
                             giis_dist_share a160,
                             giis_peril y,
                             gipi_item z
                       WHERE x.line_cd = p_line_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND x.share_cd = a160.share_cd
                         AND x.line_cd = a160.line_cd
                         AND a160.share_type = p_rv_low_value
                         AND y.line_cd = x.line_cd
                         AND x.peril_cd = y.peril_cd
                         AND x.policy_id = z.policy_id
                         AND x.item_no = z.item_no
                         AND x.expiry_date >= SYSDATE
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + d1.dist_tsi;
         END LOOP;
      ELSIF p_exclude_expired = 'N' AND p_exclude_not_eff = 'Y'
      THEN
         FOR d1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gixx_vessel_acc_dist x,
                             giis_dist_share a160,
                             giis_peril y,
                             gipi_item z
                       WHERE x.line_cd = p_line_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND x.share_cd = a160.share_cd
                         AND x.line_cd = a160.line_cd
                         AND a160.share_type = p_rv_low_value
                         AND y.line_cd = x.line_cd
                         AND x.peril_cd = y.peril_cd
                         AND x.policy_id = z.policy_id
                         AND x.item_no = z.item_no
                         AND x.eff_date <= SYSDATE
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + d1.dist_tsi;
         END LOOP;
      ELSIF p_exclude_expired = 'N' AND p_exclude_not_eff = 'N'
      THEN
         FOR d1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gixx_vessel_acc_dist x,
                             giis_dist_share a160,
                             giis_peril y,
                             gipi_item z
                       WHERE x.line_cd = p_line_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND x.share_cd = a160.share_cd
                         AND x.line_cd = a160.line_cd
                         AND a160.share_type = p_rv_low_value
                         AND y.line_cd = x.line_cd
                         AND x.peril_cd = y.peril_cd
                         AND x.policy_id = z.policy_id
                         AND x.item_no = z.item_no
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + d1.dist_tsi;
         END LOOP;
      END IF;

      p_actual := NVL (p_actual, 0) + NVL (v_dist_tsi, 0);
   END;

   PROCEDURE get_itemds_dtl_temp (
      p_exclude_expired            VARCHAR2,
      p_exclude_not_eff            VARCHAR2,
      p_line_cd                    VARCHAR2,
      p_vessel_cd                  giis_vessel.vessel_cd%TYPE,
      p_rv_low_value               cg_ref_codes.rv_low_value%TYPE,
      p_temporary         IN OUT   NUMBER
   )
   IS
      v_dist_tsi   NUMBER := 0;
   BEGIN
      /*** TEMPORARY EXPOSURE ***/
      IF p_exclude_expired = 'Y' AND p_exclude_not_eff = 'Y'
      THEN
         FOR d1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gipi_vessel_acc_dist_v4 x,
                             giis_dist_share a160,
                             giis_peril y,
                             gipi_witem z
                       WHERE x.line_cd = p_line_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND x.line_cd = a160.line_cd
                         AND x.share_cd = a160.share_cd
                         AND a160.share_type = p_rv_low_value
                         AND x.line_cd = y.line_cd
                         AND x.peril_cd = y.peril_cd
                         AND peril_type = 'B'
                         AND x.par_id = z.par_id
                         AND x.item_no = z.item_no
                         AND x.expiry_date >= SYSDATE
                         AND x.eff_date <= SYSDATE
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + d1.dist_tsi;
         END LOOP;
      ELSIF p_exclude_expired = 'Y' AND p_exclude_not_eff = 'N'
      THEN
         FOR d1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gipi_vessel_acc_dist_v4 x,
                             giis_dist_share a160,
                             giis_peril y,
                             gipi_witem z
                       WHERE x.line_cd = p_line_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND x.line_cd = a160.line_cd
                         AND x.share_cd = a160.share_cd
                         AND a160.share_type = p_rv_low_value
                         AND x.line_cd = y.line_cd
                         AND x.peril_cd = y.peril_cd
                         AND peril_type = 'B'
                         AND x.par_id = z.par_id
                         AND x.item_no = z.item_no
                         AND x.expiry_date >= SYSDATE
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + d1.dist_tsi;
         END LOOP;
      ELSIF p_exclude_expired = 'N' AND p_exclude_not_eff = 'Y'
      THEN
         FOR d1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gipi_vessel_acc_dist_v4 x,
                             giis_dist_share a160,
                             giis_peril y,
                             gipi_witem z
                       WHERE x.line_cd = p_line_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND x.line_cd = a160.line_cd
                         AND x.share_cd = a160.share_cd
                         AND a160.share_type = p_rv_low_value
                         AND x.line_cd = y.line_cd
                         AND x.peril_cd = y.peril_cd
                         AND peril_type = 'B'
                         AND x.par_id = z.par_id
                         AND x.item_no = z.item_no
                         AND x.eff_date <= SYSDATE
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + d1.dist_tsi;
         END LOOP;
      ELSIF p_exclude_expired = 'N' AND p_exclude_not_eff = 'N'
      THEN
         FOR d1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gipi_vessel_acc_dist_v4 x,
                             giis_dist_share a160,
                             giis_peril y,
                             gipi_witem z
                       WHERE x.line_cd = p_line_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND x.line_cd = a160.line_cd
                         AND x.share_cd = a160.share_cd
                         AND a160.share_type = p_rv_low_value
                         AND x.line_cd = y.line_cd
                         AND x.peril_cd = y.peril_cd
                         AND peril_type = 'B'
                         AND x.par_id = z.par_id
                         AND x.item_no = z.item_no
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + d1.dist_tsi;
         END LOOP;
      END IF;

      p_temporary := NVL (p_temporary, 0) + NVL (v_dist_tsi, 0);
   END;

   FUNCTION get_share_exposure (
      p_rv_low_value      cg_ref_codes.rv_low_value%TYPE,
      p_vessel_cd         giis_vessel.vessel_cd%TYPE,
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2
   )
      RETURN share_exposure_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      custom    cur_typ;
      v_rec     share_exposure_type;
      v_where   VARCHAR2 (10000)    := '';
      v_query   VARCHAR2 (10000);
   BEGIN
      IF     NVL (p_exclude_expired, 'N') = 'Y'
         AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         v_where :=
               'AND share_type = '
            || ''''
            || p_rv_low_value
            || ''''
            || ' AND line_cd || ''-'' || TO_CHAR(share_cd) IN (
		     SELECT line_cd || ''-'' || TO_CHAR(share_cd)
		       FROM gixx_vessel_acc_dist
		      WHERE NVL(endt_expiry_date, expiry_date) >= SYSDATE
		  			AND eff_date <= SYSDATE
		   			AND vessel_cd = '
            || ''''
            || p_vessel_cd
            || ''''
            || ' UNION
		     SELECT line_cd || ''-'' || TO_CHAR(share_cd)
		       FROM gipi_vessel_acc_dist_v4
		      WHERE NVL(endt_expiry_date, expiry_date) >= SYSDATE
		  			AND eff_date <= SYSDATE
		   			AND vessel_cd = '
            || ''''
            || p_vessel_cd
            || ''''
            || ' UNION
		      SELECT line_cd || ''-'' || TO_CHAR(share_cd)
		       FROM gipi_vessel_acc_dist_v4
		      WHERE NVL(endt_expiry_date, expiry_date) >= SYSDATE
		  			AND eff_date <= SYSDATE
		   			AND vessel_cd = '
            || ''''
            || p_vessel_cd
            || ''''
            || ' )';
      ELSIF     NVL (p_exclude_expired, 'N') = 'Y'
            AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         v_where :=
               'AND share_type = '
            || ''''
            || p_rv_low_value
            || ''''
            || ' AND line_cd || ''-'' || TO_CHAR(share_cd) IN (
		     SELECT line_cd || ''-'' || TO_CHAR(share_cd)
		       FROM gixx_vessel_acc_dist
		      WHERE NVL(endt_expiry_date, expiry_date) >= SYSDATE
		  			AND vessel_cd = '
            || ''''
            || p_vessel_cd
            || ''''
            || ' UNION
		     SELECT line_cd || ''-'' || TO_CHAR(share_cd)
		       FROM gipi_vessel_acc_dist_v4
		      WHERE NVL(endt_expiry_date, expiry_date) >= SYSDATE
		  			AND vessel_cd = '
            || ''''
            || p_vessel_cd
            || ''''
            || ' UNION
		      SELECT line_cd || ''-'' || TO_CHAR(share_cd)
		       FROM gipi_vessel_acc_dist_v4
		      WHERE NVL(endt_expiry_date, expiry_date) >= SYSDATE
		  			AND vessel_cd = '
            || ''''
            || p_vessel_cd
            || ''''
            || ' )';
      ELSIF     NVL (p_exclude_expired, 'N') = 'N'
            AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         v_where :=
               'AND share_type = '
            || ''''
            || p_rv_low_value
            || ''''
            || ' AND line_cd || ''-'' || TO_CHAR(share_cd) IN (
		     SELECT line_cd || ''-'' || TO_CHAR(share_cd)
		       FROM gixx_vessel_acc_dist
		      WHERE eff_date <= SYSDATE
		   			AND vessel_cd = '
            || ''''
            || p_vessel_cd
            || ''''
            || ' UNION
		     SELECT line_cd || ''-'' || TO_CHAR(share_cd)
		       FROM gipi_vessel_acc_dist_v4
		      WHERE eff_date <= SYSDATE
		   			AND vessel_cd = '
            || ''''
            || p_vessel_cd
            || ''''
            || ' UNION
		      SELECT line_cd || ''-'' || TO_CHAR(share_cd)
		       FROM gipi_vessel_acc_dist_v4
		      WHERE eff_date <= SYSDATE
		   			AND vessel_cd = '
            || ''''
            || p_vessel_cd
            || ''''
            || ' )';
      ELSIF     NVL (p_exclude_expired, 'N') = 'N'
            AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         v_where :=
               'AND share_type = '
            || ''''
            || p_rv_low_value
            || ''''
            || ' AND line_cd || ''-'' || TO_CHAR(share_cd) IN (
		     SELECT line_cd || ''-'' || TO_CHAR(share_cd)
		       FROM gixx_vessel_acc_dist
		      WHERE vessel_cd = '
            || ''''
            || p_vessel_cd
            || ''''
            || ' UNION
		     SELECT line_cd || ''-'' || TO_CHAR(share_cd)
		       FROM gipi_vessel_acc_dist_v4
		      WHERE vessel_cd = '
            || ''''
            || p_vessel_cd
            || ''''
            || ' UNION
		      SELECT line_cd || ''-'' || TO_CHAR(share_cd)
		       FROM gipi_vessel_acc_dist_v4
		      WHERE vessel_cd = '
            || ''''
            || p_vessel_cd
            || ''''
            || ' )';
      END IF;

      v_query :=
            'SELECT share_cd,line_cd,trty_name
       FROM giis_dist_share WHERE 1 = 1 '
         || v_where;

      OPEN custom FOR v_query;

      LOOP
         FETCH custom
          INTO v_rec.share_cd, v_rec.line_cd, v_rec.trty_name;

         v_rec.actual := 0;
         v_rec.TEMPORARY := 0;

         IF     NVL (p_exclude_expired, 'N') = 'Y'
            AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            FOR x1 IN (SELECT DISTINCT line_cd
                                  FROM gixx_vessel_acc_dist
                                 WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                      SYSDATE
                                   AND eff_date <= SYSDATE
                                   AND vessel_cd = p_vessel_cd
                       UNION
                       SELECT DISTINCT line_cd
                                  FROM gipi_vessel_acc_dist_v4
                                 WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                       SYSDATE
                                   AND eff_date <= SYSDATE
                                   AND vessel_cd = p_vessel_cd)
            LOOP
               gipis109_pkg.get_itemds_act_x (p_exclude_expired,
                                              p_exclude_not_eff,
                                              x1.line_cd,
                                              v_rec.line_cd,
                                              p_vessel_cd,
                                              v_rec.share_cd,
                                              v_rec.actual
                                             );
               gipis109_pkg.get_itemds_temp_x (p_exclude_expired,
                                               p_exclude_not_eff,
                                               x1.line_cd,
                                               v_rec.line_cd,
                                               p_vessel_cd,
                                               v_rec.share_cd,
                                               v_rec.TEMPORARY
                                              );
            END LOOP;
         ELSIF     NVL (p_exclude_expired, 'N') = 'Y'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            FOR x1 IN (SELECT DISTINCT line_cd
                                  FROM gixx_vessel_acc_dist
                                 WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                      SYSDATE
                                   AND vessel_cd = p_vessel_cd
                       UNION
                       SELECT DISTINCT line_cd
                                  FROM gipi_vessel_acc_dist_v4
                                 WHERE NVL (endt_expiry_date, expiry_date) >=
                                                                       SYSDATE
                                   AND vessel_cd = p_vessel_cd)
            LOOP
               gipis109_pkg.get_itemds_act_x (p_exclude_expired,
                                              p_exclude_not_eff,
                                              x1.line_cd,
                                              v_rec.line_cd,
                                              p_vessel_cd,
                                              v_rec.share_cd,
                                              v_rec.actual
                                             );
               gipis109_pkg.get_itemds_temp_x (p_exclude_expired,
                                               p_exclude_not_eff,
                                               x1.line_cd,
                                               v_rec.line_cd,
                                               p_vessel_cd,
                                               v_rec.share_cd,
                                               v_rec.TEMPORARY
                                              );
            END LOOP;
         ELSIF     NVL (p_exclude_expired, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            FOR x1 IN (SELECT DISTINCT line_cd
                                  FROM gixx_vessel_acc_dist
                                 WHERE eff_date <= SYSDATE
                                   AND vessel_cd = p_vessel_cd
                       UNION
                       SELECT DISTINCT line_cd
                                  FROM gipi_vessel_acc_dist_v4
                                 WHERE eff_date <= SYSDATE
                                   AND vessel_cd = p_vessel_cd)
            LOOP
               gipis109_pkg.get_itemds_act_x (p_exclude_expired,
                                              p_exclude_not_eff,
                                              x1.line_cd,
                                              v_rec.line_cd,
                                              p_vessel_cd,
                                              v_rec.share_cd,
                                              v_rec.actual
                                             );
               gipis109_pkg.get_itemds_temp_x (p_exclude_expired,
                                               p_exclude_not_eff,
                                               x1.line_cd,
                                               v_rec.line_cd,
                                               p_vessel_cd,
                                               v_rec.share_cd,
                                               v_rec.TEMPORARY
                                              );
            END LOOP;
         ELSIF     NVL (p_exclude_expired, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            FOR x1 IN (SELECT DISTINCT line_cd
                                  FROM gixx_vessel_acc_dist
                                 WHERE vessel_cd = p_vessel_cd
                       UNION
                       SELECT DISTINCT line_cd
                                  FROM gipi_vessel_acc_dist_v4
                                 WHERE vessel_cd = p_vessel_cd)
            LOOP
               gipis109_pkg.get_itemds_act_x (p_exclude_expired,
                                              p_exclude_not_eff,
                                              x1.line_cd,
                                              v_rec.line_cd,
                                              p_vessel_cd,
                                              v_rec.share_cd,
                                              v_rec.actual
                                             );
               gipis109_pkg.get_itemds_temp_x (p_exclude_expired,
                                               p_exclude_not_eff,
                                               x1.line_cd,
                                               v_rec.line_cd,
                                               p_vessel_cd,
                                               v_rec.share_cd,
                                               v_rec.TEMPORARY
                                              );
            END LOOP;
         END IF;

         v_rec.expo_sum := NVL (v_rec.actual, 0) + NVL (v_rec.TEMPORARY, 0);
         EXIT WHEN custom%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE custom;
   END;

   PROCEDURE get_itemds_act_x (
      p_exclude_expired            VARCHAR2,
      p_exclude_not_eff            VARCHAR2,
      p_line_cd                    VARCHAR2,
      p_line_cd2                   VARCHAR2,
      p_vessel_cd                  giis_vessel.vessel_cd%TYPE,
      p_share_cd                   giis_dist_share.share_cd%TYPE,
      p_actual            IN OUT   NUMBER
   )
   IS
      v_dist_tsi   NUMBER := 0;
   BEGIN
      /*** ACTUAL EXPOSURE ***/
      IF p_exclude_expired = 'Y' AND p_exclude_not_eff = 'Y'
      THEN
         FOR c1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gixx_vessel_acc_dist x,
                             giis_peril y,
                             gipi_item z
                       WHERE x.line_cd = p_line_cd
                         AND p_line_cd = p_line_cd2
                         AND x.share_cd = p_share_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND x.peril_cd = y.peril_cd
                         AND peril_type = 'B'
                         AND x.line_cd = y.line_cd
                         AND x.policy_id = z.policy_id
                         AND x.item_no = z.item_no
                         AND x.expiry_date >= SYSDATE
                         AND x.eff_date <= SYSDATE
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + NVL (c1.dist_tsi, 0);
         END LOOP;
      ELSIF p_exclude_expired = 'Y' AND p_exclude_not_eff = 'N'
      THEN
         FOR c1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gixx_vessel_acc_dist x,
                             giis_peril y,
                             gipi_item z
                       WHERE x.line_cd = p_line_cd
                         AND p_line_cd = p_line_cd2
                         AND x.share_cd = p_share_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND x.peril_cd = y.peril_cd
                         AND peril_type = 'B'
                         AND x.line_cd = y.line_cd
                         AND x.policy_id = z.policy_id
                         AND x.item_no = z.item_no
                         AND x.expiry_date >= SYSDATE
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + NVL (c1.dist_tsi, 0);
         END LOOP;
      ELSIF p_exclude_expired = 'N' AND p_exclude_not_eff = 'Y'
      THEN
         FOR c1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gixx_vessel_acc_dist x,
                             giis_peril y,
                             gipi_item z
                       WHERE x.line_cd = p_line_cd
                         AND p_line_cd = p_line_cd2
                         AND x.share_cd = p_share_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND x.peril_cd = y.peril_cd
                         AND peril_type = 'B'
                         AND x.line_cd = y.line_cd
                         AND x.policy_id = z.policy_id
                         AND x.item_no = z.item_no
                         AND x.eff_date <= SYSDATE
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + NVL (c1.dist_tsi, 0);
         END LOOP;
      ELSIF p_exclude_expired = 'N' AND p_exclude_not_eff = 'N'
      THEN
         FOR c1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gixx_vessel_acc_dist x,
                             giis_peril y,
                             gipi_item z
                       WHERE x.line_cd = p_line_cd
                         AND p_line_cd = p_line_cd2
                         AND x.share_cd = p_share_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND x.peril_cd = y.peril_cd
                         AND peril_type = 'B'
                         AND x.line_cd = y.line_cd
                         AND x.policy_id = z.policy_id
                         AND x.item_no = z.item_no
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + NVL (c1.dist_tsi, 0);
         END LOOP;
      END IF;

      p_actual := NVL (p_actual, 0) + NVL (v_dist_tsi, 0);
   END;

   PROCEDURE get_itemds_temp_x (
      p_exclude_expired            VARCHAR2,
      p_exclude_not_eff            VARCHAR2,
      p_line_cd                    VARCHAR2,
      p_line_cd2                   VARCHAR2,
      p_vessel_cd                  giis_vessel.vessel_cd%TYPE,
      p_share_cd                   giis_dist_share.share_cd%TYPE,
      p_temporary         IN OUT   NUMBER
   )
   IS
      v_dist_tsi   NUMBER := 0;
   BEGIN
      /*** TEMPORARY EXPOSURE ***/
      IF p_exclude_expired = 'Y' AND p_exclude_not_eff = 'Y'
      THEN
         FOR c1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gipi_vessel_acc_dist_v4 x,
                             giis_peril y,
                             gipi_witem z
                       WHERE x.line_cd = p_line_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND p_line_cd = p_line_cd2
                         AND share_cd = p_share_cd
                         AND x.line_cd = y.line_cd
                         AND x.peril_cd = y.peril_cd
                         AND peril_type = 'B'
                         AND x.par_id = z.par_id
                         AND x.item_no = z.item_no
                         AND x.expiry_date >= SYSDATE
                         AND x.eff_date <= SYSDATE
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + NVL (c1.dist_tsi, 0);
         END LOOP;
      ELSIF p_exclude_expired = 'Y' AND p_exclude_not_eff = 'N'
      THEN
         FOR c1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gipi_vessel_acc_dist_v4 x,
                             giis_peril y,
                             gipi_witem z
                       WHERE x.line_cd = p_line_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND p_line_cd = p_line_cd2
                         AND share_cd = p_share_cd
                         AND x.line_cd = y.line_cd
                         AND x.peril_cd = y.peril_cd
                         AND peril_type = 'B'
                         AND x.par_id = z.par_id
                         AND x.item_no = z.item_no
                         AND x.expiry_date >= SYSDATE
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + NVL (c1.dist_tsi, 0);
         END LOOP;
      ELSIF p_exclude_expired = 'N' AND p_exclude_not_eff = 'Y'
      THEN
         FOR c1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gipi_vessel_acc_dist_v4 x,
                             giis_peril y,
                             gipi_witem z
                       WHERE x.line_cd = p_line_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND p_line_cd = p_line_cd2
                         AND share_cd = p_share_cd
                         AND x.line_cd = y.line_cd
                         AND x.peril_cd = y.peril_cd
                         AND peril_type = 'B'
                         AND x.par_id = z.par_id
                         AND x.item_no = z.item_no
                         AND x.eff_date <= SYSDATE
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + NVL (c1.dist_tsi, 0);
         END LOOP;
      ELSIF p_exclude_expired = 'N' AND p_exclude_not_eff = 'N'
      THEN
         FOR c1 IN (SELECT   (SUM (x.dist_tsi) * z.currency_rt) dist_tsi
                        FROM gipi_vessel_acc_dist_v4 x,
                             giis_peril y,
                             gipi_witem z
                       WHERE x.line_cd = p_line_cd
                         AND x.vessel_cd = p_vessel_cd
                         AND p_line_cd = p_line_cd2
                         AND share_cd = p_share_cd
                         AND x.line_cd = y.line_cd
                         AND x.peril_cd = y.peril_cd
                         AND peril_type = 'B'
                         AND x.par_id = z.par_id
                         AND x.item_no = z.item_no
                    GROUP BY z.currency_rt)
         LOOP
            v_dist_tsi := v_dist_tsi + NVL (c1.dist_tsi, 0);
         END LOOP;
      END IF;

      p_temporary := NVL (p_temporary, 0) + NVL (v_dist_tsi, 0);
   END;

   FUNCTION get_actual_exposure (
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_share_cd          gixx_vessel_acc_dist.share_cd%TYPE,
      p_vessel_cd         VARCHAR2,
      p_all               VARCHAR2
   )
      RETURN actual_exposure_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      custom    cur_typ;

      CURSOR d (
         p_policy_id   gipi_item.policy_id%TYPE,
         p_item_no     gipi_item.item_no%TYPE
      )
      IS
         SELECT item_title
           FROM gipi_item
          WHERE policy_id = p_policy_id AND item_no = p_item_no;

      v_rec     actual_exposure_type;
      v_where   VARCHAR2 (10000);
      v_query   VARCHAR2 (10000);
   BEGIN
      v_where := '';

      IF p_all = 'N'
      THEN
         IF     NVL (p_exclude_expired, 'N') = 'Y'
            AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where :=
                  'AND share_cd = '
               || ''''
               || p_share_cd
               || ''''
               || ' AND NVL(endt_expiry_date, expiry_date) >= SYSDATE
                    AND eff_date <= SYSDATE';
         ELSIF     NVL (p_exclude_expired, 'N') = 'Y'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where :=
                  'AND share_cd = '
               || ''''
               || p_share_cd
               || ''''
               || ' AND NVL(endt_expiry_date, expiry_date) >= SYSDATE';
         ELSIF     NVL (p_exclude_expired, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where :=
                  'AND share_cd = '
               || ''''
               || p_share_cd
               || ''''
               || ' AND eff_date <= SYSDATE';
         ELSIF     NVL (p_exclude_expired, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where := 'AND share_cd = ' || '''' || p_share_cd || '''';
         END IF;
      ELSE
         IF     NVL (p_exclude_expired, 'N') = 'Y'
            AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where :=
                  'AND NVL(ENDT_EXPIRY_DATE, EXPIRY_DATE) >= SYSDATE '
               || 'AND EFF_DATE <= SYSDATE';
         ELSIF     NVL (p_exclude_expired, 'N') = 'Y'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where := 'AND NVL(ENDT_EXPIRY_DATE, EXPIRY_DATE) >= SYSDATE';
         ELSIF     NVL (p_exclude_expired, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where := 'AND EFF_DATE <= SYSDATE';
         ELSIF     NVL (p_exclude_expired, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where := '';
         END IF;
      END IF;

      IF p_all = 'N'
      THEN
         v_query :=
               'SELECT DISTINCT policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                renew_no, item_no, dist_flag, ann_tsi_amt, assd_no, assd_name,
                eff_date, incept_date, expiry_date, endt_expiry_date,
                peril_cd, prem_rt, peril_sname, peril_name, vessel_cd, eta,
                etd, bl_awb, cargo_type, cargo_class_cd, cargo_type_desc,
                cargo_class_desc, endt_seq_no,dist_tsi
               FROM gixx_vessel_acc_dist WHERE vessel_cd = '
            || ''''
            || p_vessel_cd
            || ''' '
            || v_where;
      ELSE
         v_query :=
               'SELECT DISTINCT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no,
                    a.renew_no, a.item_no, a.dist_flag, a.ann_tsi_amt, a.assd_no, a.assd_name,
                    a.eff_date, a.incept_date, a.expiry_date, a.endt_expiry_date,
                    a.peril_cd, a.prem_rt, a.peril_sname, a.peril_name, a.vessel_cd, a.eta,
                    a.etd, bl_awb, a.cargo_type, a.cargo_class_cd, a.cargo_type_desc,
                    a.cargo_class_desc, a.endt_seq_no,0
               FROM gixx_vessel_accumulation a
              WHERE a.policy_id IN (
                       SELECT x.policy_id
                         FROM gixx_vessel_accumulation x
                        WHERE x.endt_seq_no =
                                 (SELECT MAX (endt_seq_no)
                                    FROM gixx_vessel_accumulation
                                   WHERE line_cd = x.line_cd
                                     AND subline_cd = x.subline_cd
                                     AND iss_cd = x.iss_cd
                                     AND issue_yy = x.issue_yy
                                     AND pol_seq_no = x.pol_seq_no
                                     AND renew_no = x.renew_no)) '
            || v_where;
--               'AND b.vessel_cd = '
--            || ''''
--            || p_vessel_cd     , gipi_vessel_acc_v1 b
--            || ''' '
--            || 'AND a.policy_id = b.policy_id';
      END IF;

      OPEN custom FOR v_query;

      LOOP
         FETCH custom
          INTO v_rec.policy_id, v_rec.line_cd, v_rec.subline_cd,
               v_rec.iss_cd, v_rec.issue_yy, v_rec.pol_seq_no,
               v_rec.renew_no, v_rec.item_no, v_rec.dist_flag,
               v_rec.ann_tsi_amt, v_rec.assd_no, v_rec.assd_name,
               v_rec.eff_date, v_rec.incept_date, v_rec.expiry_date,
               v_rec.endt_expiry_date, v_rec.peril_cd, v_rec.prem_rt,
               v_rec.peril_sname, v_rec.peril_name, v_rec.vessel_cd,
               v_rec.eta, v_rec.etd, v_rec.bl_awb, v_rec.cargo_type,
               v_rec.cargo_class_cd, v_rec.cargo_type_desc,
               v_rec.cargo_class_desc, v_rec.endt_seq_no, v_rec.dist_tsi;

         v_rec.dsp_expiry_date := TO_CHAR (v_rec.expiry_date, 'DD-MON-YYYY');
         v_rec.dsp_eta := TO_CHAR (v_rec.eta, 'DD-MON-YYYY');
         v_rec.dsp_etd := TO_CHAR (v_rec.etd, 'DD-MON-YYYY');
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
         v_rec.ann_tsi_amt := 0;

         FOR a IN (SELECT SUM (NVL (ann_tsi_amt, 0)) ann_tsi_amt
                     FROM gixx_vessel_accumulation
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

         IF NVL (v_rec.endt_expiry_date, v_rec.expiry_date) < SYSDATE
         THEN
            v_rec.expired := 'Y';
         ELSE
            v_rec.expired := 'N';
         END IF;

         --jabp, july 4, 2001
         --used to check the check boxes if policies are not yet effective:
         IF v_rec.eff_date > SYSDATE
         THEN
            v_rec.not_yet_eff := 'Y';
         ELSE
            v_rec.not_yet_eff := 'N';
         END IF;

         FOR c_rec IN (SELECT policy_id
                         FROM gipi_polbasic
                        WHERE line_cd = v_rec.line_cd
                          AND subline_cd = v_rec.subline_cd
                          AND iss_cd = v_rec.iss_cd
                          AND issue_yy = v_rec.issue_yy
                          AND pol_seq_no = v_rec.pol_seq_no
                          AND renew_no = v_rec.renew_no)
         LOOP
            FOR d_rec IN (SELECT item_title
                            FROM gipi_item
                           WHERE policy_id = c_rec.policy_id
                             AND item_no = v_rec.item_no)
            LOOP
               v_rec.item_title := d_rec.item_title;
               EXIT;
            END LOOP;
         END LOOP;

         FOR i IN (SELECT currency_rt
                     FROM gipi_item
                    WHERE policy_id = v_rec.policy_id
                      AND item_no = v_rec.item_no)
         LOOP
            v_rec.dist_tsi := NVL (v_rec.dist_tsi, 0) * i.currency_rt;
            EXIT;
         END LOOP;

         IF v_rec.dist_flag = '1'
         THEN
            v_rec.nbt_dist_status := 'Undistributed';
         ELSIF v_rec.dist_flag = '2'
         THEN
            v_rec.nbt_dist_status := 'w/ Facultative';
         ELSIF v_rec.dist_flag = '3'
         THEN
            v_rec.nbt_dist_status := 'Distributed';
         ELSIF v_rec.dist_flag = '4'
         THEN
            v_rec.nbt_dist_status := 'Undistributed';
         ELSIF v_rec.dist_flag = '5'
         THEN
            v_rec.nbt_dist_status := 'Undistributed';
         END IF;

         EXIT WHEN custom%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE custom;
   END;

   FUNCTION get_temporary_exposure (
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_share_cd          gixx_vessel_acc_dist.share_cd%TYPE,
      p_vessel_cd         giis_vessel.vessel_cd%TYPE,
      p_mode              VARCHAR2,
      p_all               VARCHAR2
   )
      RETURN temporary_exposure_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      custom    cur_typ;
      v_rec     temporary_exposure_type;
      v_where   VARCHAR2 (10000);
      v_query   VARCHAR2 (10000);
   BEGIN
      v_where := '';

      IF p_all = 'N'
      THEN
         IF     NVL (p_exclude_expired, 'N') = 'Y'
            AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where :=
                  'AND share_cd = '
               || ''''
               || p_share_cd
               || ''''
               || ' AND NVL(endt_expiry_date, expiry_date) >= SYSDATE
                    AND eff_date <= SYSDATE';
         ELSIF     NVL (p_exclude_expired, 'N') = 'Y'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where :=
                  'AND share_cd = '
               || ''''
               || p_share_cd
               || ''''
               || ' AND NVL(endt_expiry_date, expiry_date) >= SYSDATE';
         ELSIF     NVL (p_exclude_expired, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where :=
                  'AND share_cd = '
               || ''''
               || p_share_cd
               || ''''
               || ' AND eff_date <= SYSDATE';
         ELSIF     NVL (p_exclude_expired, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where := 'AND share_cd = ' || '''' || p_share_cd || '''';
         END IF;
      ELSE
         IF     NVL (p_exclude_expired, 'N') = 'Y'
            AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where :=
                  'AND NVL(ENDT_EXPIRY_DATE, EXPIRY_DATE) >= SYSDATE '
               || 'AND EFF_DATE <= SYSDATE';
         ELSIF     NVL (p_exclude_expired, 'N') = 'Y'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where := 'AND NVL(ENDT_EXPIRY_DATE, EXPIRY_DATE) >= SYSDATE';
         ELSIF     NVL (p_exclude_expired, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'Y'
         THEN
            v_where := 'AND EFF_DATE <= SYSDATE';
         ELSIF     NVL (p_exclude_expired, 'N') = 'N'
               AND NVL (p_exclude_not_eff, 'N') = 'N'
         THEN
            v_where := '';
         END IF;
      END IF;

      IF p_mode = 'ITEM'
      THEN
         IF p_all = 'N'
         THEN
         /*edited by steven 01.29.2014
            from: endt_seq_no, endt_yy, endt_iss_cd
            to: null,null,null
            from: gipi_vessel_acc_dist_v2
            to: gipi_vessel_acc_dist_v4
         */
            v_query :=
                  'SELECT line_cd, subline_cd, iss_cd, issue_yy, renew_no, pol_flag, incept_date,
                   expiry_date, endt_expiry_date, eff_date, null, null,
                   null, item_no, vessel_cd, ann_tsi_amt, tsi_amt, rec_flag,
                   par_id, par_seq_no, assd_no, dist_flag, assd_name, dist_tsi
              FROM gipi_vessel_acc_dist_v4
                 WHERE vessel_cd = '
               || ''''
               || p_vessel_cd
               || ''' '
               || v_where;
         ELSE
            v_query :=
                  'SELECT line_cd, subline_cd, iss_cd, issue_yy, renew_no, pol_flag, incept_date,
                   expiry_date, endt_expiry_date, eff_date, endt_seq_no, endt_yy,
                   endt_iss_cd, item_no, vessel_cd, ann_tsi_amt, tsi_amt, rec_flag,
                   par_id, par_seq_no, assd_no, dist_flag, assd_name, 0
              FROM gipi_vessel_acc_v2
                 WHERE vessel_cd = '
               || ''''
               || p_vessel_cd
               || ''' '
               || v_where;
         END IF;

         OPEN custom FOR v_query;

         LOOP
            FETCH custom
             INTO v_rec.line_cd, v_rec.subline_cd, v_rec.iss_cd,
                  v_rec.issue_yy, v_rec.renew_no, v_rec.pol_flag,
                  v_rec.incept_date, v_rec.expiry_date,
                  v_rec.endt_expiry_date, v_rec.eff_date, v_rec.endt_seq_no,
                  v_rec.endt_yy, v_rec.endt_iss_cd, v_rec.item_no,
                  v_rec.vessel_cd, v_rec.ann_tsi_amt, v_rec.tsi_amt,
                  v_rec.rec_flag, v_rec.par_id, v_rec.par_seq_no,
                  v_rec.assd_no, v_rec.dist_flag, v_rec.assd_name,
                  v_rec.dist_tsi;

            v_rec.dsp_expiry_date :=
                                   TO_CHAR (v_rec.expiry_date, 'DD-MON-YYYY');

            BEGIN
               FOR c_rec IN (SELECT line_cd, iss_cd, par_yy, par_seq_no,
                                    quote_seq_no
                               FROM gipi_parlist
                              WHERE par_id = v_rec.par_id)
               LOOP
                  v_rec.par_no :=
                        c_rec.line_cd
                     || ' - '
                     || c_rec.iss_cd
                     || ' - '
                     || LTRIM (TO_CHAR (c_rec.par_yy, '09'))
                     || ' - '
                     || LTRIM (TO_CHAR (c_rec.par_seq_no, '0999999'))
                     || ' - '
                     || LTRIM (TO_CHAR (c_rec.quote_seq_no, '09'));
                  EXIT;
               END LOOP;

               FOR d_rec IN (SELECT item_title
                               FROM gipi_witem
                              WHERE par_id = v_rec.par_id
                                AND item_no = v_rec.item_no)
               LOOP
                  v_rec.item_title := d_rec.item_title;
                  EXIT;
               END LOOP;

--jabp, july 4, 2001
--used to check the check boxes if PAR are expired:
               IF NVL (v_rec.endt_expiry_date, v_rec.expiry_date) < SYSDATE
               THEN                          -- if expiry date is before today
                  v_rec.expired := 'Y';
               -- then the PAR is already expired
               ELSE
                  v_rec.expired := 'N';
               -- otherwise, the PAR has not yet expired
               END IF;

--jabp, july 4, 2001
--used to check the check boxes if PAR are not yet effective:
               IF v_rec.eff_date > SYSDATE
               THEN    --if the effectivity date of the policy is after today,
                  v_rec.not_yet_eff := 'Y';
               --then, the PAR  IS not yet effective
               ELSE
                  v_rec.not_yet_eff := 'N';
               --otherwise, the PAR WAS already effective
               END IF;
            END;

            BEGIN
               /*BETH 031299 fetch additional information for Marine Cargo line*/
               FOR mn_info IN (SELECT eta, etd, bl_awb, cargo_class_cd,
                                      cargo_type
                                 FROM gipi_wcargo
                                WHERE par_id = v_rec.par_id
                                  AND item_no = v_rec.item_no)
               LOOP
                  v_rec.eta := mn_info.eta;
                  v_rec.etd := mn_info.etd;
                  v_rec.bl_awb := mn_info.bl_awb;

                  FOR class_cd IN (SELECT cargo_class_desc
                                     FROM giis_cargo_class
                                    WHERE cargo_class_cd =
                                                       mn_info.cargo_class_cd)
                  LOOP
                     v_rec.cargo_class := class_cd.cargo_class_desc;
                     EXIT;
                  END LOOP;

                  FOR class_type IN (SELECT cargo_type_desc
                                       FROM giis_cargo_type
                                      WHERE cargo_class_cd =
                                                        mn_info.cargo_class_cd
                                        AND cargo_type = mn_info.cargo_type)
                  LOOP
                     v_rec.cargo_type := class_type.cargo_type_desc;
                     EXIT;
                  END LOOP;

                  EXIT;
               END LOOP;
            END;

            v_rec.dsp_eta := TO_CHAR (v_rec.eta, 'DD-MON-YYYY');
            v_rec.dsp_etd := TO_CHAR (v_rec.etd, 'DD-MON-YYYY');

            FOR i IN (SELECT currency_rt
                        FROM gipi_witem
                       WHERE par_id = v_rec.par_id AND item_no = v_rec.item_no)
            LOOP
               v_rec.dist_tsi := NVL (v_rec.dist_tsi, 0) * i.currency_rt;
               EXIT;
            END LOOP;

            BEGIN
               IF v_rec.dist_flag = '1'
               THEN
                  v_rec.nbt_dist_status := 'Undistributed';
               ELSIF v_rec.dist_flag = '2'
               THEN
                  v_rec.nbt_dist_status := 'w/ Facultative';
               ELSIF v_rec.dist_flag = '3'
               THEN
                  v_rec.nbt_dist_status := 'Distributed';
               ELSIF v_rec.dist_flag = '4'
               THEN
                  v_rec.nbt_dist_status := 'Undistributed';
               ELSIF v_rec.dist_flag = '5'
               THEN
                  v_rec.nbt_dist_status := 'Undistributed';
               END IF;
            END;

            EXIT WHEN custom%NOTFOUND;
            PIPE ROW (v_rec);
         END LOOP;
      ELSE
         IF p_all = 'N'
         THEN
            v_query :=
                  'SELECT line_cd, subline_cd, iss_cd, issue_yy, renew_no, pol_flag, incept_date,
                   expiry_date, endt_expiry_date, eff_date, 
                   item_no, vessel_cd, ann_tsi_amt, tsi_amt, rec_flag,
                   par_id, par_yy, par_seq_no, quote_seq_no, assd_no, par_no, peril_cd,
                   prem_rt, dist_flag, peril_sname, peril_name, assd_name, dist_tsi
                  FROM gipi_vessel_acc_dist_v4
                 WHERE vessel_cd = '
               || ''''
               || p_vessel_cd
               || ''''
               || ' '
               || v_where;
         ELSE
            v_query :=
                  'SELECT line_cd, subline_cd, iss_cd, issue_yy, renew_no, pol_flag, incept_date,
                   expiry_date, endt_expiry_date, eff_date, 
                   item_no, vessel_cd, ann_tsi_amt, tsi_amt, rec_flag,
                   par_id, par_yy, par_seq_no, quote_seq_no, assd_no, par_no, peril_cd,
                   prem_rt, dist_flag, peril_sname, peril_name, assd_name, 0
                  FROM gipi_vessel_acc_v4
                 WHERE vessel_cd = '
               || ''''
               || p_vessel_cd
               || ''''
               || ' '
               || v_where;
         END IF;

         OPEN custom FOR v_query;

         LOOP
            FETCH custom
             INTO v_rec.line_cd, v_rec.subline_cd, v_rec.iss_cd,
                  v_rec.issue_yy, v_rec.renew_no, v_rec.pol_flag,
                  v_rec.incept_date, v_rec.expiry_date,
                  v_rec.endt_expiry_date, v_rec.eff_date, v_rec.item_no,
                  v_rec.vessel_cd, v_rec.ann_tsi_amt, v_rec.tsi_amt,
                  v_rec.rec_flag, v_rec.par_id, v_rec.par_yy,
                  v_rec.par_seq_no, v_rec.quote_seq_no, v_rec.assd_no,
                  v_rec.par_no, v_rec.peril_cd, v_rec.prem_rt,
                  v_rec.dist_flag, v_rec.peril_sname, v_rec.peril_name,
                  v_rec.assd_name, v_rec.dist_tsi;

            v_rec.dsp_expiry_date :=
                                   TO_CHAR (v_rec.expiry_date, 'DD-MON-YYYY');

            BEGIN
               FOR c_rec IN (SELECT line_cd, iss_cd, par_yy, par_seq_no,
                                    quote_seq_no
                               FROM gipi_parlist
                              WHERE par_id = v_rec.par_id)
               LOOP
                  v_rec.par_no :=
                        c_rec.line_cd
                     || ' - '
                     || c_rec.iss_cd
                     || ' - '
                     || LTRIM (TO_CHAR (c_rec.par_yy, '09'))
                     || ' - '
                     || LTRIM (TO_CHAR (c_rec.par_seq_no, '0999999'))
                     || ' - '
                     || LTRIM (TO_CHAR (c_rec.quote_seq_no, '09'));
                  EXIT;
               END LOOP;

               --jabp, july 4, 2001
               --used to check the check boxes if PAR are expired:
               IF v_rec.expiry_date < SYSDATE
               THEN                          -- if expiry date is before today
                  v_rec.expired := 'Y';
               -- then the PAR is already expired
               ELSE
                  v_rec.expired := 'N';
               -- otherwise, the PAR has not yet expired
               END IF;

               --jabp, july 4, 2001
               --used to check the check boxes if PAR are not yet effective:
               IF v_rec.eff_date > SYSDATE
               THEN       --if the effectivity date of the PAR is after today,
                  v_rec.not_yet_eff := 'Y';
               --then, the PAR IS not yet effective
               ELSE
                  v_rec.not_yet_eff := 'N';
               --otherwise, the PAR WAS already effective
               END IF;
            END;

            BEGIN
               FOR mn_info IN (SELECT eta, etd, bl_awb, cargo_class_cd,
                                      cargo_type
                                 FROM gipi_wcargo
                                WHERE par_id = v_rec.par_id
                                  AND item_no = v_rec.item_no)
               LOOP
                  v_rec.eta := mn_info.eta;
                  v_rec.etd := mn_info.etd;
                  v_rec.bl_awb := mn_info.bl_awb;

                  FOR class_cd IN (SELECT cargo_class_desc
                                     FROM giis_cargo_class
                                    WHERE cargo_class_cd =
                                                       mn_info.cargo_class_cd)
                  LOOP
                     v_rec.cargo_class := class_cd.cargo_class_desc;
                     EXIT;
                  END LOOP;

                  FOR class_type IN (SELECT cargo_type_desc
                                       FROM giis_cargo_type
                                      WHERE cargo_class_cd =
                                                        mn_info.cargo_class_cd
                                        AND cargo_type = mn_info.cargo_type)
                  LOOP
                     v_rec.cargo_type := class_type.cargo_type_desc;
                     EXIT;
                  END LOOP;

                  EXIT;
               END LOOP;
            END;

            v_rec.dsp_eta := TO_CHAR (v_rec.eta, 'DD-MON-YYYY');
            v_rec.dsp_etd := TO_CHAR (v_rec.etd, 'DD-MON-YYYY');

            FOR i IN (SELECT currency_rt
                        FROM gipi_witem
                       WHERE par_id = v_rec.par_id AND item_no = v_rec.item_no)
            LOOP
               v_rec.dist_tsi := NVL (v_rec.dist_tsi, 0) * i.currency_rt;
               EXIT;
            END LOOP;

            BEGIN
               IF v_rec.dist_flag = '1'
               THEN
                  v_rec.nbt_dist_status := 'Undistributed';
               ELSIF v_rec.dist_flag = '2'
               THEN
                  v_rec.nbt_dist_status := 'w/ Facultative';
               ELSIF v_rec.dist_flag = '3'
               THEN
                  v_rec.nbt_dist_status := 'Distributed';
               ELSIF v_rec.dist_flag = '4'
               THEN
                  v_rec.nbt_dist_status := 'Undistributed';
               ELSIF v_rec.dist_flag = '5'
               THEN
                  v_rec.nbt_dist_status := 'Undistributed';
               END IF;
            END;

            EXIT WHEN custom%NOTFOUND;
            PIPE ROW (v_rec);
         END LOOP;
      END IF;

      CLOSE custom;
   END;
END;
/


