CREATE OR REPLACE PACKAGE BODY CPI.gipir110_pkg
AS
    /*
   **  Created by   : Steven Ramirez
   **  Date Created : 10.14.2013
   **  Reference By : GIPIR110 - Block Cards
   **  Description  :
   */
   FUNCTION populate_gipir110 (p_eff_tag VARCHAR2, p_expiry_tag VARCHAR2)
      RETURN gipir110_tab PIPELINED
   AS
      v_rec         gipir110_type;
      v_not_exist   BOOLEAN       := TRUE;
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_add := giisp.v ('COMPANY_ADDRESS');

      FOR i IN (SELECT DISTINCT    a.line_cd
                                || '-'
                                || a.subline_cd
                                || '-'
                                || a.iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (a.issue_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                                || '-'
                                || LTRIM (TO_CHAR (a.renew_no, '09'))
                                                                   policy_no,
                                a.line_cd, a.subline_cd, a.iss_cd,
                                a.issue_yy, a.pol_seq_no, a.renew_no,
                                a.dist_flag, a.assd_no, a.assd_name,
                                a.eff_date, a.incept_date, a.expiry_date,
                                a.endt_expiry_date, a.tarf_cd,
                                a.construction_cd, a.loc_risk, a.peril_cd,
                                a.prem_rt, a.peril_sname, a.peril_name,
                                a.province_cd, a.city, a.block_id, a.item_no,
                                a.district_no, a.block_no, a.fr_item_type,
                                a.endt_seq_no, a.ann_tsi_amt
                           FROM gixx_block_accumulation_dist a, giis_peril b
                          WHERE 1 = 1
                            AND (   (    NVL (p_expiry_tag, 'N') = 'Y'
                                     AND NVL (p_eff_tag, 'N') = 'Y'
                                     AND expiry_date >= SYSDATE
                                     AND eff_date <= SYSDATE
                                    )
                                 OR (    NVL (p_expiry_tag, 'N') = 'Y'
                                     AND NVL (p_eff_tag, 'N') = 'N'
                                     AND expiry_date >= SYSDATE
                                    )
                                 OR (    NVL (p_expiry_tag, 'N') = 'N'
                                     AND NVL (p_eff_tag, 'N') = 'Y'
                                     AND eff_date <= SYSDATE
                                    )
                                 OR (    NVL (p_expiry_tag, 'N') = 'N'
                                     AND NVL (p_eff_tag, 'N') = 'N'
                                     AND expiry_date = expiry_date
                                     AND eff_date = eff_date
                                    )
                                )
                            AND a.peril_cd = b.peril_cd
                            AND a.line_cd = b.line_cd
                            AND b.peril_type = 'B')
      LOOP
         v_not_exist := FALSE;
         v_rec.exist := 'Y';
         v_rec.policy_no := i.policy_no;
         v_rec.line_cd := i.line_cd;
         v_rec.subline_cd := i.subline_cd;
         v_rec.iss_cd := i.iss_cd;
         v_rec.issue_yy := i.issue_yy;
         v_rec.pol_seq_no := i.pol_seq_no;
         v_rec.renew_no := i.renew_no;
         v_rec.dist_flag := i.dist_flag;
         v_rec.ann_tsi_amt := i.ann_tsi_amt;
         v_rec.assd_no := i.assd_no;
         v_rec.assd_name := i.assd_name;
         v_rec.eff_date := i.eff_date;
         v_rec.incept_date := i.incept_date;
         v_rec.expiry_date := i.expiry_date;
         v_rec.endt_expiry_date := i.endt_expiry_date;
         v_rec.tarf_cd := i.tarf_cd;
         v_rec.construction_cd := i.construction_cd;
         v_rec.loc_risk := i.loc_risk;
         v_rec.peril_cd := i.peril_cd;
         v_rec.prem_rt := i.prem_rt;
         v_rec.peril_sname := i.peril_sname;
         v_rec.peril_name := i.peril_name;
         v_rec.province_cd := i.province_cd;
         v_rec.city := i.city;
         v_rec.block_id := i.block_id;
         v_rec.item_no := i.item_no;
         v_rec.district_no := i.district_no;
         v_rec.block_no := i.block_no;
         v_rec.fr_item_type := i.fr_item_type;
         v_rec.endt_seq_no := i.endt_seq_no;

         BEGIN
            SELECT province
              INTO v_rec.province
              FROM giis_block
             WHERE block_id = i.block_id AND province_cd = i.province_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.province := NULL;
         END;

         FOR a IN (SELECT district_desc
                     FROM giis_block
                    WHERE block_id = i.block_id)
         LOOP
            v_rec.district_desc := '-  ' || a.district_desc;
         END LOOP;

         FOR a IN (SELECT block_desc
                     FROM giis_block
                    WHERE block_id = i.block_id)
         LOOP
            v_rec.block_desc := '-  ' || a.block_desc;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;

      IF v_not_exist
      THEN
         v_rec.exist := 'N';
         PIPE ROW (v_rec);
      END IF;
   END populate_gipir110;

   FUNCTION get_trty_name (p_eff_tag VARCHAR2, p_expiry_tag VARCHAR2)
      RETURN treaty_tab PIPELINED
   IS
      v_rec   treaty_type;
   BEGIN
      FOR j IN (SELECT DISTINCT a.share_cd, a.share_type
                           FROM gixx_block_accumulation_dist a, giis_peril b
                          WHERE 1 = 1
                            AND (   (    NVL (p_expiry_tag, 'N') = 'Y'
                                     AND NVL (p_eff_tag, 'N') = 'Y'
                                     AND expiry_date >= SYSDATE
                                     AND eff_date <= SYSDATE
                                    )
                                 OR (    NVL (p_expiry_tag, 'N') = 'Y'
                                     AND NVL (p_eff_tag, 'N') = 'N'
                                     AND expiry_date >= SYSDATE
                                    )
                                 OR (    NVL (p_expiry_tag, 'N') = 'N'
                                     AND NVL (p_eff_tag, 'N') = 'Y'
                                     AND eff_date <= SYSDATE
                                    )
                                 OR (    NVL (p_expiry_tag, 'N') = 'N'
                                     AND NVL (p_eff_tag, 'N') = 'N'
                                     AND expiry_date = expiry_date
                                     AND eff_date = eff_date
                                    )
                                )
                            AND a.peril_cd = b.peril_cd
                            AND a.line_cd = b.line_cd
                            AND b.peril_type = 'B')
      LOOP
         v_rec.share_cd := j.share_cd;
         v_rec.share_type := j.share_type;

         BEGIN
            SELECT trty_name
              INTO v_rec.trty_name
              FROM giis_dist_share
             WHERE line_cd = 'FI' AND share_cd = j.share_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.trty_name := NULL;
         END;

         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_trty_dtl (
      p_line_cd      gixx_block_accumulation_dist.line_cd%TYPE,
      p_subline_cd   gixx_block_accumulation_dist.subline_cd%TYPE,
      p_iss_cd       gixx_block_accumulation_dist.iss_cd%TYPE,
      p_issue_yy     gixx_block_accumulation_dist.issue_yy%TYPE,
      p_pol_seq_no   gixx_block_accumulation_dist.pol_seq_no%TYPE,
      p_renew_no     gixx_block_accumulation_dist.renew_no%TYPE,
      p_item_no      gixx_block_accumulation_dist.item_no%TYPE,
      p_total        VARCHAR2,
      p_eff_tag      VARCHAR2,
      p_expiry_tag   VARCHAR2
   )
      RETURN treaty_tab PIPELINED
   IS
      v_rec           treaty_type;
      v_sum_insured   NUMBER         := 0;
      v_policy_no     VARCHAR2 (100);
   BEGIN
      FOR k IN (SELECT *
                  FROM TABLE (gipir110_pkg.populate_gipir110 (p_eff_tag,
                                                              p_expiry_tag
                                                             )
                             )
                 WHERE line_cd = NVL (p_line_cd, line_cd)
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                   AND iss_cd = NVL (p_iss_cd, iss_cd)
                   AND issue_yy = NVL (p_issue_yy, issue_yy)
                   AND pol_seq_no = NVL (p_pol_seq_no, pol_seq_no)
                   AND renew_no = NVL (p_renew_no, renew_no)
                   AND item_no = NVL (p_item_no, item_no))
      LOOP
         v_policy_no := k.policy_no;

         FOR j IN (SELECT   *
                       FROM TABLE (gipir110_pkg.get_trty_name (p_eff_tag,
                                                               p_expiry_tag
                                                              )
                                  )
                   ORDER BY share_cd)
         LOOP
            v_rec.share_cd := j.share_cd;
            v_rec.share_type := j.share_type;
            v_rec.trty_name := j.trty_name;
            v_rec.dist_tsi := NULL;

            FOR i IN (SELECT a.dist_tsi
                        FROM gixx_block_accumulation_dist a, giis_peril b
                       WHERE 1 = 1
                         AND (   (    NVL (p_expiry_tag, 'N') = 'Y'
                                  AND NVL (p_eff_tag, 'N') = 'Y'
                                  AND expiry_date >= SYSDATE
                                  AND eff_date <= SYSDATE
                                 )
                              OR (    NVL (p_expiry_tag, 'N') = 'Y'
                                  AND NVL (p_eff_tag, 'N') = 'N'
                                  AND expiry_date >= SYSDATE
                                 )
                              OR (    NVL (p_expiry_tag, 'N') = 'N'
                                  AND NVL (p_eff_tag, 'N') = 'Y'
                                  AND eff_date <= SYSDATE
                                 )
                              OR (    NVL (p_expiry_tag, 'N') = 'N'
                                  AND NVL (p_eff_tag, 'N') = 'N'
                                  AND expiry_date = expiry_date
                                  AND eff_date = eff_date
                                 )
                             )
                         AND a.peril_cd = b.peril_cd
                         AND a.line_cd = b.line_cd
                         AND b.peril_type = 'B'
                         AND a.line_cd = NVL (p_line_cd, k.line_cd)
                         AND a.subline_cd = NVL (p_subline_cd, k.subline_cd)
                         AND a.iss_cd = NVL (p_iss_cd, k.iss_cd)
                         AND a.issue_yy = NVL (p_issue_yy, k.issue_yy)
                         AND a.pol_seq_no = NVL (p_pol_seq_no, k.pol_seq_no)
                         AND a.renew_no = NVL (p_renew_no, k.renew_no)
                         AND a.item_no = NVL (p_item_no, k.item_no)
                         AND a.share_cd = j.share_cd
                         AND a.share_type = j.share_type)
            LOOP
               v_rec.dist_tsi := i.dist_tsi;
            END LOOP;

            PIPE ROW (v_rec);
         END LOOP;
      END LOOP;

      v_rec.share_cd := NULL;
      v_rec.share_type := NULL;
      v_rec.trty_name := 'SUM INSURED';

      FOR si IN (SELECT SUM (a.dist_tsi) sum_insured
                   FROM gixx_block_accumulation_dist a, giis_peril b
                  WHERE 1 = 1
                    AND (   (    NVL (p_expiry_tag, 'N') = 'Y'
                             AND NVL (p_eff_tag, 'N') = 'Y'
                             AND expiry_date >= SYSDATE
                             AND eff_date <= SYSDATE
                            )
                         OR (    NVL (p_expiry_tag, 'N') = 'Y'
                             AND NVL (p_eff_tag, 'N') = 'N'
                             AND expiry_date >= SYSDATE
                            )
                         OR (    NVL (p_expiry_tag, 'N') = 'N'
                             AND NVL (p_eff_tag, 'N') = 'Y'
                             AND eff_date <= SYSDATE
                            )
                         OR (    NVL (p_expiry_tag, 'N') = 'N'
                             AND NVL (p_eff_tag, 'N') = 'N'
                             AND expiry_date = expiry_date
                             AND eff_date = eff_date
                            )
                        )
                    AND a.peril_cd = b.peril_cd
                    AND a.line_cd = b.line_cd
                    AND b.peril_type = 'B'
                    AND a.line_cd = NVL (p_line_cd, a.line_cd)
                    AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                    AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                    AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
                    AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
                    AND a.renew_no = NVL (p_renew_no, a.renew_no))
      LOOP
         v_sum_insured := si.sum_insured;
      END LOOP;

      IF gipir110_policy_no IS NULL
      THEN
         gipir110_policy_no := v_policy_no;
         v_rec.dist_tsi := v_sum_insured;
      ELSE
         IF gipir110_policy_no = v_policy_no
         THEN
            v_rec.dist_tsi := NULL;
         ELSE
            v_rec.dist_tsi := v_sum_insured;
            gipir110_policy_no := v_policy_no;
         END IF;
      END IF;

      IF p_total = 'Y'
      THEN
         v_rec.dist_tsi := v_sum_insured;
      END IF;

      PIPE ROW (v_rec);
   END;
END gipir110_pkg;
/


