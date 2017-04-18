CREATE OR REPLACE PACKAGE BODY cpi.gicls057_pkg
AS
/* Created by : John Dolon
 * Date Created: 09.09.2013
 * Reference By: GICLS057 - Catastrophic Event Inquiry
 *
*/
   FUNCTION get_cat_lov
      RETURN cat_lov_tab PIPELINED
   IS
      v_list   cat_lov_type;
   BEGIN
      FOR i IN (SELECT   TO_CHAR (catastrophic_cd, '00009') catastrophic_cd,
                         catastrophic_desc
                    FROM gicl_cat_dtl
                ORDER BY catastrophic_cd)
      LOOP
         v_list.catastrophic_cd := i.catastrophic_cd;
         v_list.catastrophic_desc := i.catastrophic_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_cat_lov;

   FUNCTION get_line_lov (p_module_id VARCHAR2, p_user_id VARCHAR2)
      RETURN line_lov_tab PIPELINED
   IS
      v_list   line_lov_type;
   BEGIN
      FOR i IN
         (SELECT   line_cd, line_name
              FROM giis_line
             WHERE line_cd IN DECODE (check_user_per_iss_cd2 (line_cd,'',p_module_id,p_user_id),1, line_cd,0, NULL)
          ORDER BY line_cd)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_branch_lov (p_module_id VARCHAR2, p_user_id VARCHAR2)
      RETURN branch_lov_tab PIPELINED
   IS
      v_list   branch_lov_type;
   BEGIN
      FOR i IN (SELECT   iss_cd, iss_name
                    FROM giis_issource
                   WHERE iss_cd IN DECODE (check_user_per_iss_cd ('',iss_cd,'GICLS057'),1, iss_cd,0, '')
                ORDER BY iss_cd)
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_loss_cat_lov (p_line_cd VARCHAR2)
      RETURN loss_cat_lov_tab PIPELINED
   IS
      v_list   loss_cat_lov_type;
   BEGIN
      FOR i IN (SELECT   loss_cat_cd, loss_cat_des
                    FROM giis_loss_ctgry
                   WHERE line_cd = p_line_cd
                ORDER BY loss_cat_cd)
      LOOP
         v_list.loss_cat_cd := i.loss_cat_cd;
         v_list.loss_cat_des := i.loss_cat_des;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_province_lov
      RETURN province_lov_tab PIPELINED
   IS
      v_list   province_lov_type;
   BEGIN
      FOR i IN (SELECT   province_cd, province_desc
                    FROM giis_province
                ORDER BY province_cd)
      LOOP
         v_list.province_cd := i.province_cd;
         v_list.province_desc := i.province_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_city_lov (p_province_cd VARCHAR2)
      RETURN city_lov_tab PIPELINED
   IS
      v_list   city_lov_type;
   BEGIN
      FOR i IN (SELECT   city_cd, city
                    FROM giis_city
                   WHERE province_cd = NVL (p_province_cd, province_cd)
                ORDER BY city_cd, city)
      LOOP
         v_list.city_cd := i.city_cd;
         v_list.city := i.city;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_district_lov (p_province_cd VARCHAR2, p_city_cd VARCHAR2)
      RETURN district_lov_tab PIPELINED
   IS
      v_list   district_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT district_no, district_desc
                           FROM giis_block
                          WHERE province_cd = NVL (p_province_cd, province_cd)
                            AND city_cd = NVL (p_city_cd, city_cd)
                       ORDER BY district_no, district_desc)
      LOOP
         v_list.district_no := i.district_no;
         v_list.district_desc := i.district_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_block_lov (
      p_province_cd   VARCHAR2,
      p_city_cd       VARCHAR2,
      p_district_cd   VARCHAR2
   )
      RETURN block_lov_tab PIPELINED
   IS
      v_list   block_lov_type;
   BEGIN
      FOR i IN (SELECT   block_no, block_desc
                    FROM giis_block
                   WHERE district_no = NVL (p_district_cd, district_no)
                     AND province_cd = NVL (p_province_cd, province_cd)
                     AND city_cd = NVL (p_city_cd, city_cd)
                ORDER BY block_no, block_desc)
      LOOP
         v_list.block_no := i.block_no;
         v_list.block_desc := i.block_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   PROCEDURE validate_gicls057_line_cd (
      p_line_cd     IN OUT   giis_line.line_cd%TYPE,
      p_line_name   IN OUT   giis_line.line_name%TYPE
   )
   IS
   BEGIN
      SELECT line_cd, line_name
        INTO p_line_cd, p_line_name
        FROM giis_line
       WHERE UPPER (line_cd) LIKE UPPER (NVL (p_line_cd, line_cd))
         AND UPPER (line_name) LIKE UPPER (NVL (p_line_name, line_name));
   EXCEPTION
      WHEN OTHERS
      THEN
         p_line_cd := NULL;
         p_line_name := NULL;
   END;

   PROCEDURE validate_gicls057_cat_cd (
      p_catastrophic_cd     IN OUT   VARCHAR2,
      p_catastrophic_desc   IN OUT   VARCHAR2
   )
   IS
   BEGIN
      SELECT catastrophic_cd, catastrophic_desc
        INTO p_catastrophic_cd, p_catastrophic_desc
        FROM gicl_cat_dtl
       WHERE UPPER (catastrophic_cd) LIKE
                              UPPER (NVL (p_catastrophic_cd, catastrophic_cd))
         AND UPPER (catastrophic_desc) LIKE
                          UPPER (NVL (p_catastrophic_desc, catastrophic_desc))
         AND line_cd IN DECODE (check_user_per_iss_cd (line_cd, '','GIACS057'),1, line_cd,0, NULL);
   EXCEPTION
      WHEN OTHERS
      THEN
         p_catastrophic_cd := NULL;
         p_catastrophic_desc := NULL;
   END;

   PROCEDURE validate_gicls057_branch_cd (
      p_iss_cd     IN OUT   VARCHAR2,
      p_iss_name   IN OUT   VARCHAR2
   )
   IS
   BEGIN
      SELECT iss_cd, iss_name
        INTO p_iss_cd, p_iss_name
        FROM giis_issource
       WHERE UPPER (iss_cd) LIKE UPPER (NVL (p_iss_cd, iss_cd))
         AND UPPER (iss_name) LIKE UPPER (NVL (p_iss_name, iss_name))
         AND iss_cd IN DECODE (check_user_per_iss_cd ('', iss_cd, 'GICLS057'),1, iss_cd,0, '');
   EXCEPTION
      WHEN OTHERS
      THEN
         p_iss_cd := NULL;
         p_iss_name := NULL;
   END;

   FUNCTION get_gicls057_table (
      p_selection         VARCHAR2,
      p_catastrophic_cd   VARCHAR2,
      p_line_cd           VARCHAR2,
      p_iss_cd            VARCHAR2,
      p_location          VARCHAR2,
      p_loss_cat_cd       VARCHAR2,
      p_province_cd       VARCHAR2,
      p_city_cd           VARCHAR2,
      p_district_no       VARCHAR2,
      p_block_no          VARCHAR2,
      p_from_date         VARCHAR2,
      p_to_date           VARCHAR2
   )
      RETURN gicls057_table_tab PIPELINED
   IS
      v_list      gicls057_table_type;
      v_line_fi   BOOLEAN             := TRUE;            --4-26-2016 SR-5417
   BEGIN
      IF p_selection = 1
      THEN
         IF p_catastrophic_cd IS NOT NULL
         THEN
            FOR i IN
               (SELECT DISTINCT a.claim_id, a.loss_cat_cd, a.assd_no,
                                a.in_hou_adj, a.catastrophic_cd, a.loss_date,
                                   a.loss_loc1
                                || ' '
                                || a.loss_loc2
                                || ' '
                                || a.loss_loc3 LOCATION,
                                a.clm_stat_cd, a.loss_res_amt, a.loss_pd_amt,
                                a.exp_res_amt, a.exp_pd_amt, a.line_cd,
                                a.subline_cd, a.pol_iss_cd, a.pol_seq_no,
                                a.issue_yy, a.renew_no
                           FROM gicl_claims a
                          WHERE NVL (a.catastrophic_cd, 0) = NVL (p_catastrophic_cd, NVL (a.catastrophic_cd, 0))
                            AND a.clm_stat_cd NOT IN ('CC', 'WD', 'DN')
                            AND a.line_cd = NVL (UPPER (p_line_cd), a.line_cd)
                            AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                            AND check_user_per_iss_cd2 (a.line_cd, NULL, 'GICLS057', USER) = 1
                            AND check_user_per_iss_cd2 (NULL, a.iss_cd, 'GICLS057', USER) = 1
                            AND UPPER (NVL (a.loss_loc1 || a.loss_loc2 || a.loss_loc3, '@#$')) LIKE '%' || 
                                       NVL (p_location,UPPER (NVL (a.loss_loc1 || a.loss_loc2 || a.loss_loc3,'@#$'))) || '%'
                            AND (TRUNC (a.loss_date) 
                                    BETWEEN NVL (TO_DATE (p_from_date,'MM-DD-YYYY'),TRUNC (a.loss_date)) 
                                        AND NVL (TO_DATE (p_to_date,'MM-DD-YYYY'),TRUNC (a.loss_date))
                                 )
                            AND a.loss_cat_cd = NVL (p_loss_cat_cd, a.loss_cat_cd))
            LOOP
               v_list.line_cd := i.line_cd;
               v_list.claim_no := get_claim_number (i.claim_id);
               --v_list.policy_no           := GET_POLICY_NO(i.policy_id);
               v_list.loss_cat_cd := i.loss_cat_cd;
               v_list.loss_cat_des :=
                                  get_loss_cat_des (i.loss_cat_cd, i.line_cd);
               v_list.assd_no := i.assd_no;
               v_list.assd_name := get_assd_name (i.assd_no);
               v_list.in_hou_adj := i.in_hou_adj;
               v_list.catastrophic_cd := i.catastrophic_cd;
               v_list.loss_date := i.loss_date;
               v_list.LOCATION := i.LOCATION;
               v_list.clm_stat_cd := i.clm_stat_cd;
               v_list.clm_stat_desc := get_clm_stat_desc (i.clm_stat_cd);
               
               IF v_list.catastrophic_cd IS NOT NULL
               THEN
                  SELECT catastrophic_desc
                    INTO v_list.catastrophic_desc
                    FROM gicl_cat_dtl
                   WHERE catastrophic_cd = v_list.catastrophic_cd;
               ELSE
                  v_list.catastrophic_desc := '';
               END IF;

               IF     p_province_cd IS NULL
                  AND p_city_cd IS NULL
                  AND p_district_no IS NULL
                  AND p_block_no IS NULL
                  AND p_line_cd = 'FI'               --start 4-26-2016 SR-5417
               THEN
                  v_line_fi := TRUE;
               ELSIF p_line_cd = 'FI'
               THEN
                  v_line_fi := FALSE;
               ELSE
                  v_line_fi := TRUE;
               END IF;                                 --end 4-26-2016 SR-5417

               IF i.line_cd = 'FI'
               THEN
                  FOR j IN (SELECT province_cd, province, city_cd, city,
                                   district_no, district_desc, block_no,
                                   block_desc
                              FROM giis_block
                             WHERE block_id IN (SELECT block_id
                                                  FROM gicl_fire_dtl
                                                 WHERE claim_id = i.claim_id)
                               AND province_cd =
                                              NVL (p_province_cd, province_cd)
                               AND city_cd = NVL (p_city_cd, city_cd)
                               AND district_no =
                                              NVL (p_district_no, district_no)
                               AND block_no = NVL (p_block_no, block_no))
                  LOOP
                     v_line_fi := TRUE;                  -- 4-26-2016 SR-5417
                     v_list.province_cd := j.province_cd;
                     v_list.province := j.province;
                     v_list.city_cd := j.city_cd;
                     v_list.city := j.city;
                     v_list.district_no := j.district_no;
                     v_list.district_desc := j.district_desc;
                     v_list.block_no := j.block_no;
                     v_list.block_desc := j.block_desc;
                  END LOOP;
               ELSE
                  v_list.province_cd := '';
                  v_list.province := '';
                  v_list.city_cd := '';
                  v_list.city := '';
                  v_list.district_no := '';
                  v_list.district_desc := '';
                  v_list.block_no := '';
                  v_list.block_desc := '';
               END IF;

               v_list.loss_res_amt := 0;
               v_list.loss_pd_amt := 0;
               v_list.exp_res_amt := 0;
               v_list.exp_pd_amt := 0;
               v_list.net_res_amt := 0;
               v_list.trty_res_amt := 0;
               v_list.np_trty_res_amt := 0;
               v_list.facul_res_amt := 0;

               IF v_list.district_no IS NULL OR v_list.block_no IS NULL
               THEN
                  FOR amt IN
                     (SELECT SUM (NVL (b.shr_loss_res_amt * a.convert_rate,0)) loss_res,
                            +SUM (NVL (b.shr_exp_res_amt * a.convert_rate,0)) exp_res,
                               b.share_type
                          FROM gicl_clm_res_hist a,
                               gicl_reserve_ds b,
                               gicl_item_peril c
                         WHERE a.claim_id = b.claim_id
                           AND a.item_no = b.item_no
                           AND a.peril_cd = b.peril_cd
                           AND a.clm_res_hist_id = b.clm_res_hist_id
                           AND NVL (a.dist_sw, 'N') = 'Y'
                           AND NVL (b.negate_tag, 'N') = 'N'
                           AND a.tran_id IS NULL
                           AND a.claim_id = i.claim_id
                           AND a.claim_id = c.claim_id
                           AND a.item_no = c.item_no
                           AND a.peril_cd = c.peril_cd
                           AND a.grouped_item_no = c.grouped_item_no
                           AND NVL (c.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                      GROUP BY b.share_type)
                  LOOP
                     IF v_list.line_cd != 'FI'
                     THEN
                        v_list.loss_res_amt := NVL (i.loss_res_amt, 0);
                        v_list.exp_res_amt := NVL (i.exp_res_amt, 0);
                     ELSE
                        v_list.loss_res_amt :=
                                           v_list.loss_res_amt + amt.loss_res;
                        v_list.exp_res_amt :=
                                             v_list.exp_res_amt + amt.exp_res;
                     END IF;

                     IF amt.share_type = 1
                     THEN                                      --Net Retention
                        v_list.net_res_amt :=
                            v_list.net_res_amt
                            + (amt.loss_res + amt.exp_res);
                     --tot_net_res := tot_net_res + (amt.loss_res + amt.exp_res);
                     ELSIF amt.share_type = giacp.v ('FACUL_SHARE_TYPE')
                     THEN                                        --Facultative
                        v_list.facul_res_amt :=
                             v_list.facul_res_amt
                           + (amt.loss_res + amt.exp_res);
                     --tot_fac_res := tot_fac_res + (amt.loss_res + amt.exp_res);
                     ELSIF amt.share_type = giacp.v ('TRTY_SHARE_TYPE')
                     THEN                                             --Treaty
                        v_list.trty_res_amt :=
                           v_list.trty_res_amt
                           + (amt.loss_res + amt.exp_res);
                     --tot_trty_res := tot_trty_res + (amt.loss_res + amt.exp_res);
                     ELSIF amt.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                     THEN                            --Non-Proportional Treaty
                        v_list.np_trty_res_amt :=
                             v_list.np_trty_res_amt
                           + (amt.loss_res + amt.exp_res);
                     --tot_np_trty_res := tot_np_trty_res + (amt.loss_res + amt.exp_res);
                     END IF;
                  END LOOP;
               ELSE
                  FOR amt IN
                     (SELECT SUM (NVL (b.shr_loss_res_amt * a.convert_rate,0)) loss_res,
                            +SUM (NVL (b.shr_exp_res_amt * a.convert_rate,0)) exp_res,
                               b.share_type
                          FROM gicl_clm_res_hist a,
                               gicl_reserve_ds b,
                               gicl_fire_dtl c,
                               gicl_item_peril d
                         WHERE a.claim_id = b.claim_id
                           AND c.claim_id = a.claim_id
                           AND a.item_no = b.item_no
                           AND a.item_no = a.item_no
                           AND a.peril_cd = b.peril_cd
                           AND a.clm_res_hist_id = b.clm_res_hist_id
                           AND c.district_no =
                                       NVL (v_list.district_no, c.district_no)
                           AND c.block_no = NVL (v_list.block_no, c.block_no)
                           AND b.share_type = 1
                           AND NVL (a.dist_sw, 'N') = 'Y'
                           AND NVL (b.negate_tag, 'N') = 'N'
                           AND a.tran_id IS NULL
                           AND a.claim_id = i.claim_id
                           AND a.claim_id = d.claim_id
                           AND a.item_no = d.item_no
                           AND a.peril_cd = d.peril_cd
                           AND a.grouped_item_no = d.grouped_item_no
                           AND NVL (d.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                      GROUP BY b.share_type)
                  LOOP
                     IF v_list.line_cd != 'FI'
                     THEN
                        v_list.loss_res_amt := NVL (i.loss_res_amt, 0);
                        v_list.exp_res_amt := NVL (i.exp_res_amt, 0);
                     ELSE
                        v_list.loss_res_amt :=
                                           v_list.loss_res_amt + amt.loss_res;
                        v_list.exp_res_amt :=
                                             v_list.exp_res_amt + amt.exp_res;
                     END IF;

                     IF amt.share_type = 1
                     THEN                                      --Net Retention
                        v_list.net_res_amt :=
                            v_list.net_res_amt
                            + (amt.loss_res + amt.exp_res);
                     --tot_net_res_fi := tot_net_res_fi + (amt.loss_res + amt.exp_res);
                     ELSIF amt.share_type = giacp.v ('FACUL_SHARE_TYPE')
                     THEN                                        --Facultative
                        v_list.facul_res_amt :=
                             v_list.facul_res_amt
                           + (amt.loss_res + amt.exp_res);
                     --tot_fac_res_fi := tot_fac_res_fi + (amt.loss_res + amt.exp_res);
                     ELSIF amt.share_type = giacp.v ('TRTY_SHARE_TYPE')
                     THEN                                             --Treaty
                        v_list.trty_res_amt :=
                           v_list.trty_res_amt
                           + (amt.loss_res + amt.exp_res);
                     --tot_trty_res_fi := tot_trty_res_fi + (amt.loss_res + amt.exp_res);
                     ELSIF amt.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                     THEN           --Added Non-Proportional Treaty in FI line
                        v_list.np_trty_res_amt :=
                             v_list.np_trty_res_amt
                           + (amt.loss_res + amt.exp_res);
                     --tot_np_trty_res := tot_np_trty_res + (amt.loss_res + amt.exp_res);
                     END IF;
                  END LOOP;
               END IF;                                --end for reserve amount

               v_list.net_pd_amt := 0;
               v_list.trty_pd_amt := 0;
               v_list.np_trty_pd_amt := 0;
               v_list.facul_pd_amt := 0;

               FOR amt IN (SELECT   SUM (NVL (b.shr_le_pd_amt * a.currency_rate,0)) le_pd,
                                    a.payee_type, b.share_type
                               FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                              WHERE a.claim_id = b.claim_id
                                AND a.clm_loss_id = b.clm_loss_id
                                AND NVL (b.negate_tag, 'N') = 'N'
                                AND a.tran_id IS NOT NULL
                                AND a.claim_id = i.claim_id
                           GROUP BY a.payee_type, b.share_type)
               LOOP
                  IF v_list.line_cd != 'FI'
                  THEN
                     v_list.loss_pd_amt := NVL (i.loss_pd_amt, 0);
                     v_list.exp_pd_amt := NVL (i.exp_pd_amt, 0);
                  ELSE
                     IF amt.payee_type = 'L'
                     THEN
                        v_list.loss_pd_amt := v_list.loss_pd_amt + amt.le_pd;
                     ELSIF amt.payee_type = 'E'
                     THEN
                        v_list.exp_pd_amt := v_list.exp_pd_amt + amt.le_pd;
                     END IF;
                  END IF;

                  IF amt.share_type = 1
                  THEN                                         --Net Retention
                     v_list.net_pd_amt := v_list.net_pd_amt + amt.le_pd;
                  ELSIF amt.share_type = giacp.v ('FACUL_SHARE_TYPE')
                  THEN                                           --Facultative
                     v_list.facul_pd_amt := v_list.facul_pd_amt + amt.le_pd;
                  ELSIF amt.share_type = giacp.v ('TRTY_SHARE_TYPE')
                  THEN                                                --Treaty
                     v_list.trty_pd_amt := v_list.trty_pd_amt + amt.le_pd;
                  ELSIF amt.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                  THEN              --Added Non-Proportional Treaty in FI line
                     v_list.np_trty_pd_amt :=
                                            v_list.np_trty_pd_amt + amt.le_pd;
                  END IF;
               END LOOP;

               FOR pol IN (SELECT policy_id
                             FROM gipi_polbasic
                            WHERE line_cd = i.line_cd
                              AND subline_cd = i.subline_cd
                              AND iss_cd = i.pol_iss_cd
                              AND issue_yy = i.issue_yy
                              AND pol_seq_no = i.pol_seq_no
                              AND renew_no = i.renew_no)
               LOOP
                  v_list.policy_no := get_policy_no (pol.policy_id);
               END LOOP;

               IF v_line_fi
               THEN
                  v_line_fi := FALSE;                    -- 4-26-2016 SR-5417
                  PIPE ROW (v_list);
               END IF;
            END LOOP;
         ELSE
            FOR i IN
               (SELECT DISTINCT a.claim_id, a.loss_cat_cd, a.assd_no,
                                a.in_hou_adj, a.catastrophic_cd, a.loss_date,
                                   a.loss_loc1
                                || ' '
                                || a.loss_loc2
                                || ' '
                                || a.loss_loc3 LOCATION,
                                a.clm_stat_cd, a.loss_res_amt, a.loss_pd_amt,
                                a.exp_res_amt, a.exp_pd_amt, a.line_cd,
                                a.subline_cd, a.pol_iss_cd, a.pol_seq_no,
                                a.issue_yy, a.renew_no
                           FROM gicl_claims a
                          WHERE a.clm_stat_cd NOT IN ('CC', 'WD', 'DN')
                            AND a.line_cd = NVL (UPPER (p_line_cd), a.line_cd)
                            AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                            AND check_user_per_iss_cd2 (a.line_cd, NULL, 'GICLS057', USER) = 1
                            AND check_user_per_iss_cd2 (NULL, a.iss_cd, 'GICLS057', USER) = 1
                            AND UPPER (NVL (a.loss_loc1 || a.loss_loc2 || a.loss_loc3, '@#$')) LIKE '%' || 
                                       NVL (p_location,UPPER (NVL (a.loss_loc1 || a.loss_loc2 || a.loss_loc3,'@#$'))) || '%'
                            AND (TRUNC (a.loss_date) 
                                    BETWEEN NVL (TO_DATE (p_from_date,'MM-DD-YYYY'),TRUNC (a.loss_date)) 
                                        AND NVL (TO_DATE (p_to_date,'MM-DD-YYYY'),TRUNC (a.loss_date))
                                 )
                            AND a.loss_cat_cd = NVL (p_loss_cat_cd, a.loss_cat_cd))
            LOOP
               v_list.line_cd := i.line_cd;
               v_list.claim_no := get_claim_number (i.claim_id);
               --v_list.policy_no           := GET_POLICY_NO(i.policy_id);
               v_list.loss_cat_cd := i.loss_cat_cd;
               v_list.loss_cat_des :=
                                  get_loss_cat_des (i.loss_cat_cd, i.line_cd);
               v_list.assd_no := i.assd_no;
               v_list.assd_name := get_assd_name (i.assd_no);
               v_list.in_hou_adj := i.in_hou_adj;
               v_list.catastrophic_cd := i.catastrophic_cd;
               v_list.loss_date := i.loss_date;
               v_list.LOCATION := i.LOCATION;
               v_list.clm_stat_cd := i.clm_stat_cd;
               v_list.clm_stat_desc := get_clm_stat_desc (i.clm_stat_cd);

               IF     p_province_cd IS NULL
                  AND p_city_cd IS NULL
                  AND p_district_no IS NULL
                  AND p_block_no IS NULL
                  AND p_line_cd = 'FI'              --Start: 4-26-2016 SR-5417
               THEN
                  v_line_fi := TRUE;
               ELSIF p_line_cd = 'FI'
               THEN
                  v_line_fi := FALSE;
               ELSE
                  v_line_fi := TRUE;
               END IF;                                --End: 4-26-2016 SR-5417

               IF v_list.catastrophic_cd IS NOT NULL
               THEN
                  SELECT catastrophic_desc
                    INTO v_list.catastrophic_desc
                    FROM gicl_cat_dtl
                   WHERE catastrophic_cd = v_list.catastrophic_cd;
               ELSE
                  v_list.catastrophic_desc := '';
               END IF;

               IF i.line_cd = 'FI'
               THEN
                  FOR j IN (SELECT province_cd, province, city_cd, city,
                                   district_no, district_desc, block_no,
                                   block_desc
                              FROM giis_block
                             WHERE block_id IN (SELECT block_id
                                                  FROM gicl_fire_dtl
                                                 WHERE claim_id = i.claim_id)
                               AND province_cd =
                                              NVL (p_province_cd, province_cd)
                               AND city_cd = NVL (p_city_cd, city_cd)
                               AND district_no =
                                              NVL (p_district_no, district_no)
                               AND block_no = NVL (p_block_no, block_no))
                  LOOP
                     v_line_fi := TRUE;                   --4-26-2016 SR-5417
                     v_list.province_cd := j.province_cd;
                     v_list.province := j.province;
                     v_list.city_cd := j.city_cd;
                     v_list.city := j.city;
                     v_list.district_no := j.district_no;
                     v_list.district_desc := j.district_desc;
                     v_list.block_no := j.block_no;
                     v_list.block_desc := j.block_desc;
                  END LOOP;
               ELSE
                  v_list.province_cd := '';
                  v_list.province := '';
                  v_list.city_cd := '';
                  v_list.city := '';
                  v_list.district_no := '';
                  v_list.district_desc := '';
                  v_list.block_no := '';
                  v_list.block_desc := '';
               END IF;

               v_list.loss_res_amt := 0;
               v_list.loss_pd_amt := 0;
               v_list.exp_res_amt := 0;
               v_list.exp_pd_amt := 0;
               v_list.net_res_amt := 0;
               v_list.trty_res_amt := 0;
               v_list.np_trty_res_amt := 0;
               v_list.facul_res_amt := 0;

               IF v_list.district_no IS NULL OR v_list.block_no IS NULL
               THEN
                  FOR amt IN
                     (SELECT SUM (NVL (b.shr_loss_res_amt * a.convert_rate,0)) loss_res,
                            +SUM (NVL (b.shr_exp_res_amt * a.convert_rate,0)) exp_res,
                               b.share_type
                          FROM gicl_clm_res_hist a,
                               gicl_reserve_ds b,
                               gicl_item_peril c
                         WHERE a.claim_id = b.claim_id
                           AND a.item_no = b.item_no
                           AND a.peril_cd = b.peril_cd
                           AND a.clm_res_hist_id = b.clm_res_hist_id
                           AND NVL (a.dist_sw, 'N') = 'Y'
                           AND NVL (b.negate_tag, 'N') = 'N'
                           AND a.tran_id IS NULL
                           AND a.claim_id = i.claim_id
                           AND a.claim_id = c.claim_id
                           AND a.item_no = c.item_no
                           AND a.peril_cd = c.peril_cd
                           AND a.grouped_item_no = c.grouped_item_no
                           AND NVL (c.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                      GROUP BY b.share_type)
                  LOOP
                     IF v_list.line_cd != 'FI'
                     THEN
                        v_list.loss_res_amt := NVL (i.loss_res_amt, 0);
                        v_list.exp_res_amt := NVL (i.exp_res_amt, 0);
                     ELSE
                        v_list.loss_res_amt :=
                                           v_list.loss_res_amt + amt.loss_res;
                        v_list.exp_res_amt :=
                                             v_list.exp_res_amt + amt.exp_res;
                     END IF;

                     IF amt.share_type = 1
                     THEN                                      --Net Retention
                        v_list.net_res_amt :=
                            v_list.net_res_amt
                            + (amt.loss_res + amt.exp_res);
                     --tot_net_res := tot_net_res + (amt.loss_res + amt.exp_res);
                     ELSIF amt.share_type = giacp.v ('FACUL_SHARE_TYPE')
                     THEN                                        --Facultative
                        v_list.facul_res_amt :=
                             v_list.facul_res_amt
                           + (amt.loss_res + amt.exp_res);
                     --tot_fac_res := tot_fac_res + (amt.loss_res + amt.exp_res);
                     ELSIF amt.share_type = giacp.v ('TRTY_SHARE_TYPE')
                     THEN                                             --Treaty
                        v_list.trty_res_amt :=
                           v_list.trty_res_amt
                           + (amt.loss_res + amt.exp_res);
                     --tot_trty_res := tot_trty_res + (amt.loss_res + amt.exp_res);
                     ELSIF amt.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                     THEN                            --Non-Proportional Treaty
                        v_list.np_trty_res_amt :=
                             v_list.np_trty_res_amt
                           + (amt.loss_res + amt.exp_res);
                     --tot_np_trty_res := tot_np_trty_res + (amt.loss_res + amt.exp_res);
                     END IF;
                  END LOOP;
               ELSE
                  FOR amt IN
                     (SELECT SUM (NVL (b.shr_loss_res_amt * a.convert_rate,0)) loss_res,
                            +SUM (NVL (b.shr_exp_res_amt * a.convert_rate,0)) exp_res,
                               b.share_type
                          FROM gicl_clm_res_hist a,
                               gicl_reserve_ds b,
                               gicl_fire_dtl c,
                               gicl_item_peril d
                         WHERE a.claim_id = b.claim_id
                           AND c.claim_id = a.claim_id
                           AND a.item_no = b.item_no
                           AND a.item_no = a.item_no
                           AND a.peril_cd = b.peril_cd
                           AND a.clm_res_hist_id = b.clm_res_hist_id
                           AND c.district_no =
                                       NVL (v_list.district_no, c.district_no)
                           AND c.block_no = NVL (v_list.block_no, c.block_no)
                           AND b.share_type = 1
                           AND NVL (a.dist_sw, 'N') = 'Y'
                           AND NVL (b.negate_tag, 'N') = 'N'
                           AND a.tran_id IS NULL
                           AND a.claim_id = i.claim_id
                           AND a.claim_id = d.claim_id
                           AND a.item_no = d.item_no
                           AND a.peril_cd = d.peril_cd
                           AND a.grouped_item_no = d.grouped_item_no
                           AND NVL (d.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                      GROUP BY b.share_type)
                  LOOP
                     IF v_list.line_cd != 'FI'
                     THEN
                        v_list.loss_res_amt := NVL (i.loss_res_amt, 0);
                        v_list.exp_res_amt := NVL (i.exp_res_amt, 0);
                     ELSE
                        v_list.loss_res_amt :=
                                           v_list.loss_res_amt + amt.loss_res;
                        v_list.exp_res_amt :=
                                             v_list.exp_res_amt + amt.exp_res;
                     END IF;

                     IF amt.share_type = 1
                     THEN                                      --Net Retention
                        v_list.net_res_amt :=
                            v_list.net_res_amt
                            + (amt.loss_res + amt.exp_res);
                     --tot_net_res_fi := tot_net_res_fi + (amt.loss_res + amt.exp_res);
                     ELSIF amt.share_type = giacp.v ('FACUL_SHARE_TYPE')
                     THEN                                        --Facultative
                        v_list.facul_res_amt :=
                             v_list.facul_res_amt
                           + (amt.loss_res + amt.exp_res);
                     --tot_fac_res_fi := tot_fac_res_fi + (amt.loss_res + amt.exp_res);
                     ELSIF amt.share_type = giacp.v ('TRTY_SHARE_TYPE')
                     THEN                                             --Treaty
                        v_list.trty_res_amt :=
                           v_list.trty_res_amt
                           + (amt.loss_res + amt.exp_res);
                     --tot_trty_res_fi := tot_trty_res_fi + (amt.loss_res + amt.exp_res);
                     ELSIF amt.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                     THEN           --Added Non-Proportional Treaty in FI line
                        v_list.np_trty_res_amt :=
                             v_list.np_trty_res_amt
                           + (amt.loss_res + amt.exp_res);
                     --tot_np_trty_res := tot_np_trty_res + (amt.loss_res + amt.exp_res);
                     END IF;
                  END LOOP;
               END IF;                                --end for reserve amount

               v_list.net_pd_amt := 0;
               v_list.trty_pd_amt := 0;
               v_list.np_trty_pd_amt := 0;
               v_list.facul_pd_amt := 0;

               FOR amt IN (SELECT   SUM (NVL (b.shr_le_pd_amt * a.currency_rate,0)) le_pd,
                                    a.payee_type, b.share_type
                               FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                              WHERE a.claim_id = b.claim_id
                                AND a.clm_loss_id = b.clm_loss_id
                                AND NVL (b.negate_tag, 'N') = 'N'
                                AND a.tran_id IS NOT NULL
                                AND a.claim_id = i.claim_id
                           GROUP BY a.payee_type, b.share_type)
               LOOP
                  IF v_list.line_cd != 'FI'
                  THEN
                     v_list.loss_pd_amt := NVL (i.loss_pd_amt, 0);
                     v_list.exp_pd_amt := NVL (i.exp_pd_amt, 0);
                  ELSE
                     IF amt.payee_type = 'L'
                     THEN
                        v_list.loss_pd_amt := v_list.loss_pd_amt + amt.le_pd;
                     ELSIF amt.payee_type = 'E'
                     THEN
                        v_list.exp_pd_amt := v_list.exp_pd_amt + amt.le_pd;
                     END IF;
                  END IF;

                  IF amt.share_type = 1
                  THEN                                         --Net Retention
                     v_list.net_pd_amt := v_list.net_pd_amt + amt.le_pd;
                  ELSIF amt.share_type = giacp.v ('FACUL_SHARE_TYPE')
                  THEN                                           --Facultative
                     v_list.facul_pd_amt := v_list.facul_pd_amt + amt.le_pd;
                  ELSIF amt.share_type = giacp.v ('TRTY_SHARE_TYPE')
                  THEN                                                --Treaty
                     v_list.trty_pd_amt := v_list.trty_pd_amt + amt.le_pd;
                  ELSIF amt.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                  THEN              --Added Non-Proportional Treaty in FI line
                     v_list.np_trty_pd_amt :=
                                            v_list.np_trty_pd_amt + amt.le_pd;
                  END IF;
               END LOOP;

               FOR pol IN (SELECT policy_id
                             FROM gipi_polbasic
                            WHERE line_cd = i.line_cd
                              AND subline_cd = i.subline_cd
                              AND iss_cd = i.pol_iss_cd
                              AND issue_yy = i.issue_yy
                              AND pol_seq_no = i.pol_seq_no
                              AND renew_no = i.renew_no)
               LOOP
                  v_list.policy_no := get_policy_no (pol.policy_id);
               END LOOP;

               IF v_line_fi
               THEN
                  v_line_fi := FALSE;                     --4-26-2016 SR-5417
                  PIPE ROW (v_list);
               END IF;
            END LOOP;
         END IF;
      ELSIF p_selection = 2
      THEN
         FOR i IN
            (SELECT DISTINCT a.claim_id, a.loss_cat_cd, a.assd_no,
                             a.in_hou_adj, a.catastrophic_cd, a.loss_date,
                                a.loss_loc1
                             || ' '
                             || a.loss_loc2
                             || ' '
                             || a.loss_loc3 LOCATION,
                             a.clm_stat_cd, a.loss_res_amt, a.loss_pd_amt,
                             a.exp_res_amt, a.exp_pd_amt, a.line_cd,
                             a.subline_cd, a.pol_iss_cd, a.pol_seq_no,
                             a.issue_yy, a.renew_no
                        FROM gicl_claims a
                       WHERE a.clm_stat_cd NOT IN ('CC', 'WD', 'DN')
                         AND (   a.line_cd = p_line_cd
                              OR a.iss_cd = p_iss_cd
                              OR UPPER (NVL (a.loss_loc1|| a.loss_loc2|| a.loss_loc3,'@#$')) LIKE'%' || NVL (p_location, '$#@')|| '%'
                              OR a.loss_cat_cd = p_loss_cat_cd
                              OR a.catastrophic_cd = p_catastrophic_cd
                              OR (TRUNC(a.loss_date)  >= TO_DATE(p_from_date, 'MM-DD-YYYY') 
                                  AND TRUNC(a.loss_date) <= TO_DATE(p_to_date, 'MM-DD-YYYY'))
                              OR EXISTS (
                                    SELECT b.claim_id
                                      FROM gicl_fire_dtl b
                                     WHERE a.claim_id = b.claim_id
                                       AND b.block_id IN (
                                              SELECT c.block_id
                                                FROM giis_block c
                                               WHERE c.province_cd = p_province_cd
                                                 AND c.city_cd = p_city_cd
                                                 AND c.district_no = p_district_no
                                                 AND c.block_no = p_block_no))
                             )
                         AND check_user_per_iss_cd2 (a.line_cd,NULL,'GICLS057',USER) = 1
                         AND check_user_per_iss_cd2 (NULL,a.iss_cd,'GICLS057',USER) = 1
                         AND check_user_per_iss_cd (a.line_cd,a.iss_cd,'GICLS057') = 1)
         LOOP
            v_list.line_cd := i.line_cd;
            v_list.claim_no := get_claim_number (i.claim_id);
            --v_list.policy_no           := GET_POLICY_NO(i.policy_id);
            v_list.loss_cat_cd := i.loss_cat_cd;
            v_list.loss_cat_des :=
                                  get_loss_cat_des (i.loss_cat_cd, i.line_cd);
            v_list.assd_no := i.assd_no;
            v_list.assd_name := get_assd_name (i.assd_no);
            v_list.in_hou_adj := i.in_hou_adj;
            v_list.catastrophic_cd := i.catastrophic_cd;
            v_list.loss_date := i.loss_date;
            v_list.LOCATION := i.LOCATION;
            v_list.clm_stat_cd := i.clm_stat_cd;
            v_list.clm_stat_desc := get_clm_stat_desc (i.clm_stat_cd);

            IF v_list.catastrophic_cd IS NOT NULL
            THEN
               SELECT catastrophic_desc
                 INTO v_list.catastrophic_desc
                 FROM gicl_cat_dtl
                WHERE catastrophic_cd = v_list.catastrophic_cd;
            ELSE
               v_list.catastrophic_desc := '';
            END IF;

            IF i.line_cd = 'FI'
            THEN
               FOR j IN (SELECT province_cd, province, city_cd, city,
                                district_no, district_desc, block_no,
                                block_desc
                           FROM giis_block
                          WHERE block_id IN (SELECT block_id
                                               FROM gicl_fire_dtl
                                              WHERE claim_id = i.claim_id)
                             OR province_cd = p_province_cd
                             OR city_cd = p_city_cd
                             OR district_no = p_district_no
                             OR block_no = p_block_no)
               LOOP
                  v_list.province_cd := j.province_cd;
                  v_list.province := j.province;
                  v_list.city_cd := j.city_cd;
                  v_list.city := j.city;
                  v_list.district_no := j.district_no;
                  v_list.district_desc := j.district_desc;
                  v_list.block_no := j.block_no;
                  v_list.block_desc := j.block_desc;
               END LOOP;
            ELSE
               v_list.province_cd := '';
               v_list.province := '';
               v_list.city_cd := '';
               v_list.city := '';
               v_list.district_no := '';
               v_list.district_desc := '';
               v_list.block_no := '';
               v_list.block_desc := '';
            END IF;

            v_list.loss_res_amt := 0;
            v_list.loss_pd_amt := 0;
            v_list.exp_res_amt := 0;
            v_list.exp_pd_amt := 0;
            v_list.net_res_amt := 0;
            v_list.trty_res_amt := 0;
            v_list.np_trty_res_amt := 0;
            v_list.facul_res_amt := 0;

            IF v_list.district_no IS NULL OR v_list.block_no IS NULL
            THEN
               FOR amt IN (SELECT SUM (NVL (  b.shr_loss_res_amt * a.convert_rate,0)) loss_res,
                                 +SUM (NVL (  b.shr_exp_res_amt * a.convert_rate,0)) exp_res,
                                    b.share_type
                               FROM gicl_clm_res_hist a,
                                    gicl_reserve_ds b,
                                    gicl_item_peril c
                              WHERE a.claim_id = b.claim_id
                                AND a.item_no = b.item_no
                                AND a.peril_cd = b.peril_cd
                                AND a.clm_res_hist_id = b.clm_res_hist_id
                                AND NVL (a.dist_sw, 'N') = 'Y'
                                AND NVL (b.negate_tag, 'N') = 'N'
                                AND a.tran_id IS NULL
                                AND a.claim_id = i.claim_id
                                AND a.claim_id = c.claim_id
                                AND a.item_no = c.item_no
                                AND a.peril_cd = c.peril_cd
                                AND a.grouped_item_no = c.grouped_item_no
                                AND NVL (c.close_flag, 'AP') IN
                                                           ('AP', 'CC', 'CP')
                           GROUP BY b.share_type)
               LOOP
                  IF v_list.line_cd != 'FI'
                  THEN
                     v_list.loss_res_amt := NVL (i.loss_res_amt, 0);
                     v_list.exp_res_amt := NVL (i.exp_res_amt, 0);
                  ELSE
                     v_list.loss_res_amt :=
                                           v_list.loss_res_amt + amt.loss_res;
                     v_list.exp_res_amt := v_list.exp_res_amt + amt.exp_res;
                  END IF;

                  IF amt.share_type = 1
                  THEN                                         --Net Retention
                     v_list.net_res_amt :=
                            v_list.net_res_amt
                            + (amt.loss_res + amt.exp_res);
                  --tot_net_res := tot_net_res + (amt.loss_res + amt.exp_res);
                  ELSIF amt.share_type = giacp.v ('FACUL_SHARE_TYPE')
                  THEN                                           --Facultative
                     v_list.facul_res_amt :=
                          v_list.facul_res_amt
                          + (amt.loss_res + amt.exp_res);
                  --tot_fac_res := tot_fac_res + (amt.loss_res + amt.exp_res);
                  ELSIF amt.share_type = giacp.v ('TRTY_SHARE_TYPE')
                  THEN                                                --Treaty
                     v_list.trty_res_amt :=
                           v_list.trty_res_amt
                           + (amt.loss_res + amt.exp_res);
                  --tot_trty_res := tot_trty_res + (amt.loss_res + amt.exp_res);
                  ELSIF amt.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                  THEN                               --Non-Proportional Treaty
                     v_list.np_trty_res_amt :=
                        v_list.np_trty_res_amt
                        + (amt.loss_res + amt.exp_res);
                  --tot_np_trty_res := tot_np_trty_res + (amt.loss_res + amt.exp_res);
                  END IF;
               END LOOP;
            ELSE
               FOR amt IN (SELECT SUM (NVL (  b.shr_loss_res_amt * a.convert_rate,0)) loss_res,
                                 +SUM (NVL (  b.shr_exp_res_amt * a.convert_rate,0)) exp_res,
                                    b.share_type
                               FROM gicl_clm_res_hist a,
                                    gicl_reserve_ds b,
                                    gicl_fire_dtl c,
                                    gicl_item_peril d
                              WHERE a.claim_id = b.claim_id
                                AND c.claim_id = a.claim_id
                                AND a.item_no = b.item_no
                                AND a.item_no = a.item_no
                                AND a.peril_cd = b.peril_cd
                                AND a.clm_res_hist_id = b.clm_res_hist_id
                                AND c.district_no =
                                       NVL (v_list.district_no, c.district_no)
                                AND c.block_no =
                                             NVL (v_list.block_no, c.block_no)
                                AND b.share_type = 1
                                AND NVL (a.dist_sw, 'N') = 'Y'
                                AND NVL (b.negate_tag, 'N') = 'N'
                                AND a.tran_id IS NULL
                                AND a.claim_id = i.claim_id
                                AND a.claim_id = d.claim_id
                                AND a.item_no = d.item_no
                                AND a.peril_cd = d.peril_cd
                                AND a.grouped_item_no = d.grouped_item_no
                                AND NVL (d.close_flag, 'AP') IN
                                                           ('AP', 'CC', 'CP')
                           GROUP BY b.share_type)
               LOOP
                  IF v_list.line_cd != 'FI'
                  THEN
                     v_list.loss_res_amt := NVL (i.loss_res_amt, 0);
                     v_list.exp_res_amt := NVL (i.exp_res_amt, 0);
                  ELSE
                     v_list.loss_res_amt :=
                                           v_list.loss_res_amt + amt.loss_res;
                     v_list.exp_res_amt := v_list.exp_res_amt + amt.exp_res;
                  END IF;

                  IF amt.share_type = 1
                  THEN                                         --Net Retention
                     v_list.net_res_amt :=
                            v_list.net_res_amt
                            + (amt.loss_res + amt.exp_res);
                  ELSIF amt.share_type = giacp.v ('FACUL_SHARE_TYPE')
                  THEN                                           --Facultative
                     v_list.facul_res_amt :=
                          v_list.facul_res_amt
                          + (amt.loss_res + amt.exp_res);
                  ELSIF amt.share_type = giacp.v ('TRTY_SHARE_TYPE')
                  THEN                                                --Treaty
                     v_list.trty_res_amt :=
                           v_list.trty_res_amt
                           + (amt.loss_res + amt.exp_res);
                  ELSIF amt.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                  THEN              --Added Non-Proportional Treaty in FI line
                     v_list.np_trty_res_amt :=
                        v_list.np_trty_res_amt
                        + (amt.loss_res + amt.exp_res);
                  END IF;
               END LOOP;
            END IF;                                   --end for reserve amount

            v_list.net_pd_amt := 0;
            v_list.trty_pd_amt := 0;
            v_list.np_trty_pd_amt := 0;
            v_list.facul_pd_amt := 0;

            FOR amt IN (SELECT   SUM (NVL (b.shr_le_pd_amt * a.currency_rate,0)) le_pd,
                                 a.payee_type, b.share_type
                            FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                           WHERE a.claim_id = b.claim_id
                             AND a.clm_loss_id = b.clm_loss_id
                             AND NVL (b.negate_tag, 'N') = 'N'
                             AND a.tran_id IS NOT NULL
                             AND a.claim_id = i.claim_id
                        GROUP BY a.payee_type, b.share_type)
            LOOP
               IF v_list.line_cd != 'FI'
               THEN
                  v_list.loss_pd_amt := NVL (i.loss_pd_amt, 0);
                  v_list.exp_pd_amt := NVL (i.exp_pd_amt, 0);
               ELSE
                  IF amt.payee_type = 'L'
                  THEN
                     v_list.loss_pd_amt := v_list.loss_pd_amt + amt.le_pd;
                  ELSIF amt.payee_type = 'E'
                  THEN
                     v_list.exp_pd_amt := v_list.exp_pd_amt + amt.le_pd;
                  END IF;
               END IF;

               IF amt.share_type = 1
               THEN                                            --Net Retention
                  v_list.net_pd_amt := v_list.net_pd_amt + amt.le_pd;
               ELSIF amt.share_type = giacp.v ('FACUL_SHARE_TYPE')
               THEN                                              --Facultative
                  v_list.facul_pd_amt := v_list.facul_pd_amt + amt.le_pd;
               ELSIF amt.share_type = giacp.v ('TRTY_SHARE_TYPE')
               THEN                                                   --Treaty
                  v_list.trty_pd_amt := v_list.trty_pd_amt + amt.le_pd;
               ELSIF amt.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
               THEN                 --Added Non-Proportional Treaty in FI line
                  v_list.np_trty_pd_amt := v_list.np_trty_pd_amt + amt.le_pd;
               END IF;
            END LOOP;

            FOR pol IN (SELECT policy_id
                          FROM gipi_polbasic
                         WHERE line_cd = i.line_cd
                           AND subline_cd = i.subline_cd
                           AND iss_cd = i.pol_iss_cd
                           AND issue_yy = i.issue_yy
                           AND pol_seq_no = i.pol_seq_no
                           AND renew_no = i.renew_no)
            LOOP
               v_list.policy_no := get_policy_no (pol.policy_id);
            END LOOP;

            PIPE ROW (v_list);
         END LOOP;
      END IF;

      RETURN;
   END;
END;
/