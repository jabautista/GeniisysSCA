CREATE OR REPLACE PACKAGE BODY CPI.gipis111_pkg
AS
   /*
   **  Created by        : Steven Ramirez
   **  Date Created      : 09.24.2013
   **  Reference By      : GIPIS111 - View Property Floater Accumulation
   */
   FUNCTION get_giis_ca_location (p_enter_query VARCHAR2)
      RETURN giis_ca_location_tab PIPELINED
   IS
      v_rec   giis_ca_location_type;
   BEGIN
      IF p_enter_query = 'N'
      THEN
         FOR i IN (SELECT   location_cd, location_desc, from_date, TO_DATE,
                            ret_limit, treaty_limit, remarks
                       FROM giis_ca_location
                   ORDER BY location_cd)
         LOOP
            v_rec.location_cd := i.location_cd;
            v_rec.location_desc := i.location_desc;
            v_rec.from_date := i.from_date;
            v_rec.TO_DATE := i.TO_DATE;
            v_rec.dsp_from_date := TO_CHAR (i.from_date, 'DD-MON-YYYY');
            v_rec.dsp_to_date := TO_CHAR (i.TO_DATE, 'DD-MON-YYYY');
            v_rec.dsp_from_date2 := TO_CHAR (i.from_date, 'MM-DD-YYYY');
            v_rec.dsp_to_date2 := TO_CHAR (i.TO_DATE, 'MM-DD-YYYY');
            v_rec.ret_limit := i.ret_limit;
            v_rec.treaty_limit := i.treaty_limit;
            v_rec.remarks := i.remarks;
            PIPE ROW (v_rec);
         END LOOP;
      END IF;
   END;

   FUNCTION get_giis_ca_location_dtl (
      p_location_cd       giis_ca_location.location_cd%TYPE,
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2
   )
      RETURN giis_ca_location_dtl_tab PIPELINED
   IS
      v_rec              giis_ca_location_dtl_type;
      v_actual_ret       NUMBER;
      v_actual_trty      NUMBER;
      v_actual_fac       NUMBER;
      v_temp_ret         NUMBER;
      v_temp_trty        NUMBER;
      v_temp_fac         NUMBER;
      v_aret             NUMBER                                 := 0;
      v_atrt             NUMBER                                 := 0;
      v_afac             NUMBER                                 := 0;
      v_tret             NUMBER                                 := 0;
      v_ttrt             NUMBER                                 := 0;
      v_tfac             NUMBER                                 := 0;
      v_atsi             NUMBER                                 := 0;
      v_ttsi             NUMBER                                 := 0;
      v_cnt              NUMBER                                 := 0;
      v_ret_beg_bal      giis_ca_location.ret_beg_bal%TYPE;
      v_treaty_beg_bal   giis_ca_location.treaty_beg_bal%TYPE;
      v_fac_beg_bal      giis_ca_location.fac_beg_bal%TYPE;
   BEGIN
      FOR EXP IN (SELECT rv_low_value val
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE')
      LOOP
         v_cnt := v_cnt + 1;
         v_atsi := 0;
         v_ttsi := 0;
         gipis111_pkg.get_ca_actual_exposure2 (NVL (p_exclude_expired, 'N'),
                                               NVL (p_exclude_not_eff, 'N'),
                                               p_location_cd,
                                               EXP.val,
                                               v_atsi
                                              );
         gipis111_pkg.get_ca_temp_exposure2 (NVL (p_exclude_expired, 'N'),
                                             NVL (p_exclude_not_eff, 'N'),
                                             p_location_cd,
                                             EXP.val,
                                             v_ttsi
                                            );

         IF EXP.val = 1
         THEN
            v_aret := v_atsi;
            v_tret := v_ttsi;
         ELSIF EXP.val = 2
         THEN
            v_atrt := v_atsi;
            v_ttrt := v_ttsi;
         ELSIF EXP.val = 3
         THEN
            v_afac := v_atsi;
            v_tfac := v_ttsi;
         END IF;

         IF v_cnt = 3
         THEN
            EXIT;
         END IF;
      END LOOP;

      v_actual_ret := NVL (v_aret, 0);
      v_actual_trty := NVL (v_atrt, 0);
      v_actual_fac := NVL (v_afac, 0);
      v_temp_ret := NVL (v_tret, 0);
      v_temp_trty := NVL (v_ttrt, 0);
      v_temp_fac := NVL (v_tfac, 0);

      FOR k IN (SELECT ret_beg_bal, treaty_beg_bal, fac_beg_bal
                  FROM giis_ca_location
                 WHERE location_cd = p_location_cd)
      LOOP
         v_ret_beg_bal := k.ret_beg_bal;
         v_treaty_beg_bal := k.treaty_beg_bal;
         v_fac_beg_bal := k.fac_beg_bal;
      END LOOP;

      FOR i IN 1 .. 3
      LOOP
         IF i = 1
         THEN
            v_rec.dsp_beg_bal := NVL (v_ret_beg_bal, 0);
            v_rec.dsp_actual := v_actual_ret;
            v_rec.dsp_temp := v_temp_ret;
            v_rec.dsp_sum :=
                        v_rec.dsp_actual + v_rec.dsp_temp + v_rec.dsp_beg_bal;
         ELSIF i = 2
         THEN
            v_rec.dsp_beg_bal := NVL (v_treaty_beg_bal, 0);
            v_rec.dsp_actual := v_actual_trty;
            v_rec.dsp_temp := v_temp_trty;
            v_rec.dsp_sum :=
                        v_rec.dsp_actual + v_rec.dsp_temp + v_rec.dsp_beg_bal;
         ELSIF i = 3
         THEN
            v_rec.dsp_beg_bal := NVL (v_fac_beg_bal, 0);
            v_rec.dsp_actual := v_actual_fac;
            v_rec.dsp_temp := v_temp_fac;
            v_rec.dsp_sum :=
                        v_rec.dsp_actual + v_rec.dsp_temp + v_rec.dsp_beg_bal;
         END IF;

         PIPE ROW (v_rec);
      END LOOP;
   END;

   PROCEDURE get_ca_actual_exposure2 (
      p_exclude_expiry    IN       VARCHAR2,
      p_exclude_not_eff   IN       VARCHAR2,
      p_location_cd       IN       gipi_casualty_item.location_cd%TYPE,
      p_share_type        IN       giis_dist_share.share_type%TYPE,
      p_dist_tsi          IN OUT   gixx_ca_accum_dist.dist_tsi%TYPE
   )
   IS
      v_dist_tsi   gixx_ca_accum_dist.dist_tsi%TYPE   := 0;
   BEGIN
      FOR i IN (SELECT b.currency_rt, a.policy_id, a.item_no
                  FROM gixx_ca_accum_dist a, gipi_item b
                 WHERE a.policy_id = b.policy_id
                   AND a.item_no = b.item_no
                   AND a.location_cd = p_location_cd
                   AND a.share_type = p_share_type)
      LOOP
         IF p_exclude_expiry = 'Y' AND p_exclude_not_eff = 'Y'
         THEN
            FOR j IN (SELECT SUM (dist_tsi) dist_tsi
                        FROM gixx_ca_accum_dist a, giis_peril b
                       WHERE a.line_cd = b.line_cd
                         AND a.peril_cd = b.peril_cd
                         AND a.location_cd = p_location_cd
                         AND b.peril_type = 'B'
                         AND a.share_type = p_share_type
                         AND a.expiry_date >= SYSDATE
                         AND a.eff_date <= SYSDATE
                         AND a.policy_id = i.policy_id
                         AND a.item_no = i.item_no)
            LOOP
               v_dist_tsi := j.dist_tsi;
               EXIT;
            END LOOP;
         ELSIF p_exclude_expiry = 'Y' AND p_exclude_not_eff = 'N'
         THEN
            FOR j IN (SELECT SUM (dist_tsi) dist_tsi
                        FROM gixx_ca_accum_dist a, giis_peril b
                       WHERE a.line_cd = b.line_cd
                         AND a.peril_cd = b.peril_cd
                         AND a.location_cd = p_location_cd
                         AND b.peril_type = 'B'
                         AND a.share_type = p_share_type
                         AND a.expiry_date >= SYSDATE
                         AND a.policy_id = i.policy_id
                         AND a.item_no = i.item_no)
            LOOP
               v_dist_tsi := j.dist_tsi;
               EXIT;
            END LOOP;
         ELSIF p_exclude_expiry = 'N' AND p_exclude_not_eff = 'Y'
         THEN
            FOR j IN (SELECT SUM (dist_tsi) dist_tsi
                        FROM gixx_ca_accum_dist a, giis_peril b
                       WHERE a.line_cd = b.line_cd
                         AND a.peril_cd = b.peril_cd
                         AND a.location_cd = p_location_cd
                         AND b.peril_type = 'B'
                         AND a.share_type = p_share_type
                         AND a.eff_date <= SYSDATE
                         AND a.policy_id = i.policy_id
                         AND a.item_no = i.item_no)
            LOOP
               v_dist_tsi := j.dist_tsi;
               EXIT;
            END LOOP;
         ELSIF p_exclude_expiry = 'N' AND p_exclude_not_eff = 'N'
         THEN
            FOR j IN (SELECT SUM (dist_tsi) dist_tsi
                        FROM gixx_ca_accum_dist a, giis_peril b
                       WHERE a.line_cd = b.line_cd
                         AND a.peril_cd = b.peril_cd
                         AND a.location_cd = p_location_cd
                         AND b.peril_type = 'B'
                         AND a.share_type = p_share_type
                         AND a.policy_id = i.policy_id
                         AND a.item_no = i.item_no)
            LOOP
               v_dist_tsi := j.dist_tsi;
               EXIT;
            END LOOP;
         END IF;
         p_dist_tsi := p_dist_tsi + (NVL (v_dist_tsi, 0) * i.currency_rt);
      END LOOP;
   END;

   PROCEDURE get_ca_temp_exposure2 (
      p_exclude_expiry    IN       VARCHAR2,
      p_exclude_not_eff   IN       VARCHAR2,
      p_location_cd       IN       gipi_casualty_item.location_cd%TYPE,
      p_share_type        IN       giis_dist_share.share_type%TYPE,
      p_dist_tsi          IN OUT   gixx_ca_accum_dist.dist_tsi%TYPE
   )
   IS
   BEGIN
      IF p_exclude_expiry = 'Y' AND p_exclude_not_eff = 'Y'
      THEN
         SELECT SUM (dist_tsi)
           INTO p_dist_tsi
           FROM gipi_ca_item_basic_dist_v a, giis_peril b
          WHERE a.line_cd = b.line_cd
            AND a.peril_cd = b.peril_cd
            AND a.location_cd = p_location_cd
            AND b.peril_type = 'B'
            AND a.share_type = p_share_type
            AND a.expiry_date >= SYSDATE
            AND a.eff_date <= SYSDATE;
      ELSIF p_exclude_expiry = 'Y' AND p_exclude_not_eff = 'N'
      THEN
         SELECT SUM (dist_tsi)
           INTO p_dist_tsi
           FROM gipi_ca_item_basic_dist_v a, giis_peril b
          WHERE a.line_cd = b.line_cd
            AND a.peril_cd = b.peril_cd
            AND a.location_cd = p_location_cd
            AND b.peril_type = 'B'
            AND a.share_type = p_share_type
            AND a.expiry_date >= SYSDATE;
      ELSIF p_exclude_expiry = 'N' AND p_exclude_not_eff = 'Y'
      THEN
         SELECT SUM (dist_tsi)
           INTO p_dist_tsi
           FROM gipi_ca_item_basic_dist_v a, giis_peril b
          WHERE a.line_cd = b.line_cd
            AND a.peril_cd = b.peril_cd
            AND a.location_cd = p_location_cd
            AND b.peril_type = 'B'
            AND a.share_type = p_share_type
            AND a.eff_date <= SYSDATE;
      ELSIF p_exclude_expiry = 'N' AND p_exclude_not_eff = 'N'
      THEN
         SELECT SUM (dist_tsi)
           INTO p_dist_tsi
           FROM gipi_ca_item_basic_dist_v a, giis_peril b
          WHERE a.line_cd = b.line_cd
            AND a.peril_cd = b.peril_cd
            AND a.location_cd = p_location_cd
            AND b.peril_type = 'B'
            AND a.share_type = p_share_type;
      END IF;
   END;

   FUNCTION get_actual_exposure (
      p_location_cd       giis_ca_location.location_cd%TYPE,
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_mode              VARCHAR2
   )
      RETURN actual_exposure_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      custom    cur_typ;
      v_rec     actual_exposure_type;
      v_where   VARCHAR2 (10000)     := '';
      v_query   VARCHAR2 (10000);
   BEGIN
      IF     NVL (p_exclude_expired, 'N') = 'Y'
         AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         v_where :=
               'location_cd = '''
            || p_location_cd
            || ''' AND EXPIRY_DATE >= SYSDATE AND eff_date <= SYSDATE';
      ELSIF     NVL (p_exclude_expired, 'N') = 'Y'
            AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         v_where :=
               'location_cd = '''
            || p_location_cd
            || ''' AND EXPIRY_DATE >= SYSDATE';
      ELSIF     NVL (p_exclude_expired, 'N') = 'N'
            AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         v_where :=
            'location_cd = ''' || p_location_cd
            || ''' AND eff_date <= SYSDATE';
      ELSIF     NVL (p_exclude_expired, 'N') = 'N'
            AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         v_where := 'location_cd = ''' || p_location_cd || '''';
      END IF;

      IF p_mode = 'ITEM'
      THEN
         v_query :=
               'SELECT DISTINCT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                policy_id, item_no, eff_date, expiry_date, endt_expiry_date,
                '''', location_cd,''''
           FROM gixx_ca_accum_dist 
           WHERE 1 = 1 AND '
            || v_where
            || ' ORDER BY eff_date, policy_id';
      ELSIF p_mode = 'PERIL'
      THEN
         v_query :=
               'SELECT DISTINCT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
                policy_id, item_no, eff_date, expiry_date, endt_expiry_date,
                peril_cd, location_cd,peril_name
           FROM gixx_ca_accum_dist 
           WHERE 1 = 1 AND '
            || v_where
            || ' ORDER BY eff_date, policy_id';
      END IF;

      OPEN custom FOR v_query;

      LOOP
         FETCH custom
          INTO v_rec.line_cd, v_rec.subline_cd, v_rec.iss_cd, v_rec.issue_yy,
               v_rec.pol_seq_no, v_rec.renew_no, v_rec.policy_id,
               v_rec.item_no, v_rec.eff_date, v_rec.expiry_date,
               v_rec.endt_expiry_date, v_rec.peril_cd, v_rec.location_cd,
               v_rec.peril_name;

         IF p_mode = 'ITEM'
         THEN
            BEGIN
               SELECT   SUM (dist_tsi), assd_name, dist_flag,
                        incept_date
                   INTO v_rec.dist_tsi, v_rec.assd_name, v_rec.dist_flag,
                        v_rec.incept_date
                   FROM gixx_ca_accum_dist
                  WHERE policy_id = v_rec.policy_id
                    AND item_no = v_rec.item_no
                    AND location_cd = p_location_cd
               GROUP BY policy_id, assd_name, item_no, dist_flag, incept_date;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.dist_tsi := NULL;
                  v_rec.assd_name := NULL;
                  v_rec.dist_flag := NULL;
                  v_rec.incept_date := NULL;
            END;

            BEGIN
               SELECT DISTINCT get_policy_no (policy_id), ann_tsi_amt
                          INTO v_rec.policy_no, v_rec.ann_tsi_amt
                          FROM gixx_ca_accum
                         WHERE policy_id = v_rec.policy_id
                           AND item_no = v_rec.item_no
                           AND location_cd = p_location_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.policy_no := NULL;
                  v_rec.ann_tsi_amt := NULL;
            END;
         ELSIF p_mode = 'PERIL'
         THEN
            BEGIN
               SELECT   SUM (dist_tsi), assd_name, ann_tsi_amt,
                        dist_flag, incept_date,
                        peril_name, prem_rt
                   INTO v_rec.dist_tsi, v_rec.assd_name, v_rec.ann_tsi_amt,
                        v_rec.dist_flag, v_rec.incept_date,
                        v_rec.peril_name, v_rec.prem_rt
                   FROM gixx_ca_accum_dist
                  WHERE policy_id = v_rec.policy_id
                    AND item_no = v_rec.item_no
                    AND peril_cd = v_rec.peril_cd
                    AND location_cd = p_location_cd
               GROUP BY assd_name,
                        ann_tsi_amt,
                        item_no,
                        dist_flag,
                        incept_date,
                        peril_name,
                        prem_rt;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.dist_tsi := NULL;
                  v_rec.assd_name := NULL;
                  v_rec.ann_tsi_amt := NULL;
                  v_rec.dist_flag := NULL;
                  v_rec.incept_date := NULL;
                  v_rec.peril_name := NULL;
                  v_rec.prem_rt := NULL;
            END;

            v_rec.policy_no := get_policy_no (v_rec.policy_id);
         END IF;

         FOR i IN (SELECT currency_rt
                     FROM gipi_item
                    WHERE policy_id = v_rec.policy_id
                      AND item_no = v_rec.item_no)
         LOOP
            v_rec.dist_tsi := NVL (v_rec.dist_tsi, 0) * i.currency_rt;

            IF p_mode = 'PERIL'
            THEN
               v_rec.ann_tsi_amt := NVL (v_rec.ann_tsi_amt, 0)
                                    * i.currency_rt;
            END IF;

            EXIT;
         END LOOP;

         FOR item IN (SELECT item_title
                        FROM gipi_item
                       WHERE policy_id = v_rec.policy_id
                         AND item_no = v_rec.item_no)
         LOOP
            v_rec.item_title := item.item_title;
         END LOOP;

         v_rec.max_expiry := NULL;
         v_rec.dsp_max_expiry := NULL;
         v_rec.expired := 'N';

         FOR max_expiry IN (SELECT   expiry_date
                                FROM gixx_ca_accum
                               WHERE policy_id = v_rec.policy_id
                                 AND item_no = v_rec.item_no
                                 AND location_cd = p_location_cd
                            ORDER BY endt_seq_no DESC)
         LOOP
            v_rec.max_expiry := max_expiry.expiry_date;
            v_rec.dsp_max_expiry :=
                              TO_CHAR (max_expiry.expiry_date, ' MM-DD-YYYY');

            IF (max_expiry.expiry_date) < SYSDATE
            THEN
               v_rec.expired := 'Y';
            END IF;

            EXIT;
         END LOOP;

         IF v_rec.incept_date > SYSDATE
         THEN
            v_rec.not_yet_eff := 'Y';
         END IF;

         IF v_rec.dist_flag = '1'
         THEN
            v_rec.dist_stat := 'Undistributed';
         ELSIF v_rec.dist_flag = '2'
         THEN
            v_rec.dist_stat := 'w/ Facultative';
         ELSIF v_rec.dist_flag = '3'
         THEN
            v_rec.dist_stat := 'Distributed';
         END IF;

         v_rec.claim_exists := 'N';
         v_rec.claim_id := NULL;

         FOR a IN (SELECT claim_id
                     FROM gicl_claims
                    WHERE line_cd = v_rec.line_cd
                      AND subline_cd = v_rec.subline_cd
                      AND pol_iss_cd = v_rec.iss_cd
                      AND issue_yy = v_rec.issue_yy
                      AND pol_seq_no = v_rec.pol_seq_no
                      AND renew_no = v_rec.renew_no)
         LOOP
            v_rec.claim_exists := 'Y';
            v_rec.claim_id := a.claim_id;
         END LOOP;

         EXIT WHEN custom%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE custom;
   END;

   FUNCTION get_temporary_exposure (
      p_location_cd       giis_ca_location.location_cd%TYPE,
      p_exclude_expired   VARCHAR2,
      p_exclude_not_eff   VARCHAR2,
      p_mode              VARCHAR2
   )
      RETURN temporary_exposure_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      custom    cur_typ;
      v_rec     temporary_exposure_type;
      v_where   VARCHAR2 (10000)        := '';
      v_query   VARCHAR2 (10000);
   BEGIN
      IF     NVL (p_exclude_expired, 'N') = 'Y'
         AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         v_where :=
               'location_cd = '''
            || p_location_cd
            || ''' AND EXPIRY_DATE >= SYSDATE AND eff_date <= SYSDATE';
      ELSIF     NVL (p_exclude_expired, 'N') = 'Y'
            AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         v_where :=
               'location_cd = '''
            || p_location_cd
            || ''' AND EXPIRY_DATE >= SYSDATE';
      ELSIF     NVL (p_exclude_expired, 'N') = 'N'
            AND NVL (p_exclude_not_eff, 'N') = 'Y'
      THEN
         v_where :=
            'location_cd = ''' || p_location_cd
            || ''' AND eff_date <= SYSDATE';
      ELSIF     NVL (p_exclude_expired, 'N') = 'N'
            AND NVL (p_exclude_not_eff, 'N') = 'N'
      THEN
         v_where := 'location_cd = ''' || p_location_cd || '''';
      END IF;

      IF p_mode = 'ITEM'
      THEN
         v_query :=
               'SELECT DISTINCT    line_cd
                || '' -  ''
                || iss_cd
                || '' -  ''
                || LTRIM (TO_CHAR (par_yy, ''09''))
                || '' -  ''
                || LTRIM (TO_CHAR (par_seq_no, ''099999''))
                || '' -  ''
                || LTRIM (TO_CHAR (quote_seq_no, ''09'')) par_no,
                par_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                renew_no, par_yy, par_seq_no, quote_seq_no, item_no,
                location_cd, '''', eff_date, expiry_date, ''''
           FROM gipi_ca_item_basic_dist_v
           WHERE 1 = 1 AND '
            || v_where
            || '  ORDER BY eff_date, par_id';
      ELSIF p_mode = 'PERIL'
      THEN
         v_query :=
               'SELECT DISTINCT    line_cd
                || '' -  ''
                || iss_cd
                || '' -  ''
                || LTRIM (TO_CHAR (par_yy, ''09''))
                || '' -  ''
                || LTRIM (TO_CHAR (par_seq_no, ''099999''))
                || '' -  ''
                || LTRIM (TO_CHAR (quote_seq_no, ''09'')) par_no,
                par_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                renew_no, par_yy, par_seq_no, quote_seq_no, item_no,
                location_cd, peril_cd, eff_date, expiry_date, peril_name
           FROM gipi_ca_item_basic_dist_v
           WHERE 1 = 1 AND '
            || v_where
            || '  ORDER BY eff_date, par_id';
      END IF;

      OPEN custom FOR v_query;

      LOOP
         FETCH custom
          INTO v_rec.par_no, v_rec.par_id, v_rec.line_cd, v_rec.subline_cd,
               v_rec.iss_cd, v_rec.issue_yy, v_rec.pol_seq_no,
               v_rec.renew_no, v_rec.par_yy, v_rec.par_seq_no,
               v_rec.quote_seq_no, v_rec.item_no, v_rec.location_cd,
               v_rec.peril_cd, v_rec.eff_date, v_rec.expiry_date,
               v_rec.peril_name;

         IF p_mode = 'ITEM'
         THEN
            BEGIN
               SELECT   SUM (dist_tsi), assd_name, ann_tsi_amt,
                        dist_flag, incept_date
                   INTO v_rec.dist_tsi, v_rec.assd_name, v_rec.ann_tsi_amt,
                        v_rec.dist_flag, v_rec.incept_date
                   FROM gipi_ca_item_basic_dist_v
                  WHERE par_id = v_rec.par_id
                    AND item_no = v_rec.item_no
                    AND location_cd = p_location_cd
               GROUP BY assd_name,
                        ann_tsi_amt,
                        item_no,
                        dist_flag,
                        incept_date;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.dist_tsi := NULL;
                  v_rec.assd_name := NULL;
                  v_rec.ann_tsi_amt := NULL;
                  v_rec.dist_flag := NULL;
                  v_rec.incept_date := NULL;
            END;
         ELSIF p_mode = 'PERIL'
         THEN
            BEGIN
               SELECT   SUM (dist_tsi), assd_name, ann_tsi_amt,
                        dist_flag, incept_date,
                        peril_name, prem_rt
                   INTO v_rec.dist_tsi, v_rec.assd_name, v_rec.ann_tsi_amt,
                        v_rec.dist_flag, v_rec.incept_date,
                        v_rec.peril_name, v_rec.prem_rt
                   FROM gipi_ca_item_basic_dist_v
                  WHERE par_id = v_rec.par_id
                    AND item_no = v_rec.item_no
                    AND peril_cd = v_rec.peril_cd
                    AND location_cd = p_location_cd
               GROUP BY assd_name,
                        ann_tsi_amt,
                        item_no,
                        dist_flag,
                        incept_date,
                        peril_name,
                        prem_rt;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.dist_tsi := NULL;
                  v_rec.assd_name := NULL;
                  v_rec.ann_tsi_amt := NULL;
                  v_rec.dist_flag := NULL;
                  v_rec.incept_date := NULL;
                  v_rec.peril_name := NULL;
                  v_rec.prem_rt := NULL;
            END;
         END IF;

         FOR d_rec IN (SELECT item_title
                         FROM gipi_witem
                        WHERE par_id = v_rec.par_id
                          AND item_no = v_rec.item_no)
         LOOP
            v_rec.item_title := d_rec.item_title;
            EXIT;
         END LOOP;

         v_rec.max_expiry := NULL;
         v_rec.dsp_max_expiry := NULL;
         v_rec.expired := 'N';

         FOR max_expiry IN (SELECT   expiry_date
                                FROM gipi_ca_item_basic_dist_v
                               WHERE par_id = v_rec.par_id
                                 AND item_no = v_rec.item_no
                                 AND location_cd = p_location_cd
                            ORDER BY par_seq_no DESC)
         LOOP
            v_rec.max_expiry := max_expiry.expiry_date;
            v_rec.dsp_max_expiry :=
                              TO_CHAR (max_expiry.expiry_date, ' MM-DD-YYYY');

            IF (max_expiry.expiry_date) < SYSDATE
            THEN
               v_rec.expired := 'Y';
            END IF;

            EXIT;
         END LOOP;

         IF v_rec.incept_date > SYSDATE
         THEN
            v_rec.not_yet_eff := 'Y';
         END IF;

         IF v_rec.dist_flag = '1'
         THEN
            v_rec.dist_stat := 'Undistributed';
         ELSIF v_rec.dist_flag = '2'
         THEN
            v_rec.dist_stat := 'w/ Facultative';
         ELSIF v_rec.dist_flag = '3'
         THEN
            v_rec.dist_stat := 'Distributed';
         END IF;

         v_rec.claim_exists := 'N';
         v_rec.claim_id := NULL;

         FOR a IN (SELECT claim_id
                     FROM gicl_claims
                    WHERE line_cd = v_rec.line_cd
                      AND subline_cd = v_rec.subline_cd
                      AND pol_iss_cd = v_rec.iss_cd
                      AND issue_yy = v_rec.issue_yy
                      AND pol_seq_no = v_rec.pol_seq_no
                      AND renew_no = v_rec.renew_no)
         LOOP
            v_rec.claim_exists := 'Y';
            v_rec.claim_id := a.claim_id;
         END LOOP;

         EXIT WHEN custom%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE custom;
   END;
END;
/


