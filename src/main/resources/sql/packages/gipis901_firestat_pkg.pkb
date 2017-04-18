CREATE OR REPLACE PACKAGE BODY CPI.gipis901_firestat_pkg
AS
   /** Created By:     Edgar Nobleza
    ** Date Created:   04/01/2015
    ** Referenced By:  GIPIS901 - Generate Fire Statistical Reports
    **/
   PROCEDURE extract_fire_stat (
      p_fire_stat    IN       VARCHAR2,
      p_date_rb      IN       VARCHAR2,
      p_date         IN       VARCHAR2,
      p_date_from    IN       VARCHAR2,
      p_date_to      IN       VARCHAR2,
      p_as_of_date   IN       VARCHAR2,
      p_bus_cd       IN       NUMBER,
      p_zone         IN       VARCHAR2,
      p_zone_type    IN       VARCHAR2,
      p_risk_cnt     IN       VARCHAR2,
      p_incl_endt    IN       VARCHAR2,
      p_incl_exp     IN       VARCHAR2,
      p_peril_type   IN       VARCHAR2,
      p_user         IN       VARCHAR2,
      p_cnt          OUT      NUMBER
   )
   AS
      v_datefrom   DATE   := TO_DATE (p_date_from, 'MM-DD-RRRR');
      v_dateto     DATE   := TO_DATE (p_date_to, 'MM-DD-RRRR');
      v_as_of      DATE   := TO_DATE (p_as_of_date, 'MM-DD-RRRR');
      v_ctr        NUMBER;
   BEGIN
      IF p_date_rb = '1'
      THEN
         BEGIN
            /*Determines what kind of statistical report will be extracted (either by zone or by tariff) */
            IF p_fire_stat = 'by_zone'
            THEN
               p_zone_fromto_dtl.extract2 (v_datefrom,
                                           v_dateto,
                                           p_date,
                                           p_bus_cd,
                                           p_zone,
                                           p_zone_type,
                                           p_incl_endt,
                                           p_incl_exp,
                                           p_peril_type,
                                           p_user
                                          );
               COMMIT;

               BEGIN
                  SELECT COUNT (DISTINCT line_cd
                                 || '-'
                                 || subline_cd
                                 || '-'
                                 || iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (issue_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                                 || '-'
                                 || LTRIM (TO_CHAR (renew_no, '09'))
                               ) cnt
                    INTO v_ctr
                    FROM gipi_firestat_extract_dtl
                   WHERE 1 = 1
                     AND as_of_sw = 'N'
                     AND user_id = p_user
                     AND zone_type = p_zone_type
                  HAVING SUM (NVL (share_tsi_amt, 0)) <> 0;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_ctr := 0;
               END;
            ELSIF p_fire_stat = 'by_tariff'
            THEN
               p_zone_fromto_dtl.extract2 (v_datefrom,
                                           v_dateto,
                                           p_date,
                                           p_bus_cd,
                                           p_zone,
                                           p_zone_type,
                                           p_incl_endt,
                                           p_incl_exp,
                                           p_peril_type,
                                           p_user
                                          );
               COMMIT;

               BEGIN
                  SELECT COUNT (DISTINCT line_cd
                                 || '-'
                                 || subline_cd
                                 || '-'
                                 || iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (issue_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                                 || '-'
                                 || LTRIM (TO_CHAR (renew_no, '09'))
                               ) cnt
                    INTO v_ctr
                    FROM gipi_firestat_extract_dtl
                   WHERE 1 = 1
                     AND as_of_sw = 'N'
                     AND user_id = p_user
                     AND zone_type = p_zone_type
                  HAVING SUM (NVL (share_tsi_amt, 0)) <> 0;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_ctr := 0;
               END;
            END IF;
         END;
      ELSIF p_date_rb = '2'
      THEN
         BEGIN
            IF p_fire_stat = 'by_zone'
            THEN
               p_zone_asof_dtl.extract2 (v_as_of,
                                         p_bus_cd,
                                         p_zone,
                                         p_zone_type,
                                         p_incl_endt,
                                         p_incl_exp,
                                         p_peril_type,
                                         p_user
                                        );                  --edgar 02/23/2015
               COMMIT;

               BEGIN
                  SELECT COUNT (DISTINCT line_cd
                                 || '-'
                                 || subline_cd
                                 || '-'
                                 || iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (issue_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                                 || '-'
                                 || LTRIM (TO_CHAR (renew_no, '09'))
                               ) cnt
                    INTO v_ctr
                    FROM gipi_firestat_extract_dtl
                   WHERE 1 = 1
                     AND as_of_sw = 'Y'
                     AND user_id = p_user
                     AND zone_type = p_zone_type
                  HAVING SUM (NVL (share_tsi_amt, 0)) <> 0;
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_ctr := 0;
               END;
            ELSIF p_fire_stat = 'by_tariff'
            THEN
               BEGIN
                  p_zone_asof_dtl.extract2 (v_as_of,
                                            p_bus_cd,
                                            p_zone,
                                            p_zone_type,
                                            p_incl_endt,
                                            p_incl_exp,
                                            p_peril_type,
                                            p_user
                                           );
                  COMMIT;

                  BEGIN
                     SELECT COUNT (DISTINCT line_cd
                                    || '-'
                                    || subline_cd
                                    || '-'
                                    || iss_cd
                                    || '-'
                                    || LTRIM (TO_CHAR (issue_yy, '09'))
                                    || '-'
                                    || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                                    || '-'
                                    || LTRIM (TO_CHAR (renew_no, '09'))
                                  ) cnt
                       INTO v_ctr
                       FROM gipi_firestat_extract_dtl
                      WHERE 1 = 1
                        AND as_of_sw = 'Y'
                        AND user_id = p_user
                        AND zone_type = p_zone_type
                     HAVING SUM (NVL (share_tsi_amt, 0)) <> 0;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_ctr := 0;
                  END;
               END;
            END IF;
         END;
      END IF;

      p_cnt := v_ctr;
   END extract_fire_stat;

   FUNCTION populate_fire_tariff_master (
      p_user_id     gixx_firestat_summary_dtl.user_id%TYPE,
      p_as_of_sw    gixx_firestat_summary_dtl.as_of_sw%TYPE,
      p_zone_type   gipi_firestat_extract_dtl.zone_type%TYPE
   )
      RETURN fire_tariff_master_tab PIPELINED
   AS
      rec   fire_tariff_master_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_tariff
                 WHERE tarf_cd IN (
                          SELECT DISTINCT tarf_cd
                                     FROM gipi_firestat_extract_dtl
                                    WHERE user_id = p_user_id
                                      AND as_of_sw = p_as_of_sw
                                      AND zone_type = p_zone_type))
      LOOP
         rec.tarf_cd := i.tarf_cd;
         rec.tarf_desc := i.tarf_desc;
         PIPE ROW (rec);
      END LOOP;
   END populate_fire_tariff_master;

   FUNCTION populate_fire_tariff_detail (
      p_user_id     gixx_firestat_summary_dtl.user_id%TYPE,
      p_as_of_sw    gixx_firestat_summary_dtl.as_of_sw%TYPE,
      p_tarf_cd     gixx_firestat_summary_dtl.tarf_cd%TYPE,
      p_zone_type   gipi_firestat_extract_dtl.zone_type%TYPE
   )
      RETURN fire_tariff_detail_tab PIPELINED
   AS
      rec   fire_tariff_detail_type;
   BEGIN
      FOR i IN (SELECT DISTINCT assd_no, SUM (NVL (share_tsi_amt, 0))
                                                                     tsi_amt,
                                SUM (NVL (share_prem_amt, 0)) prem_amt,
                                tarf_cd, user_id,
                                   line_cd
                                || ' - '
                                || subline_cd
                                || ' - '
                                || iss_cd
                                || ' - '
                                || LTRIM (TO_CHAR (issue_yy, '00'))
                                || ' - '
                                || LTRIM (TO_CHAR (pol_seq_no, '0000000'))
                                || ' - '
                                || LTRIM (TO_CHAR (renew_no, '00'))
                                                                   policy_no,
                                line_cd, subline_cd, iss_cd, issue_yy,
                                pol_seq_no, renew_no
                           FROM gipi_firestat_extract_dtl
                          WHERE tarf_cd = p_tarf_cd
                            AND user_id = p_user_id
                            AND as_of_sw = p_as_of_sw
                            AND zone_type = p_zone_type
                       GROUP BY assd_no,
                                tarf_cd,
                                line_cd,
                                subline_cd,
                                iss_cd,
                                issue_yy,
                                pol_seq_no,
                                renew_no,
                                user_id
                       ORDER BY line_cd,
                                subline_cd,
                                iss_cd,
                                issue_yy,
                                pol_seq_no,
                                renew_no)
      LOOP
         rec.assd_no := i.assd_no;
         rec.tsi_amt := i.tsi_amt;
         rec.prem_amt := i.prem_amt;
         rec.tarf_cd := i.tarf_cd;
         rec.policy_no := i.policy_no;
         rec.user_id := i.user_id;

         BEGIN
            FOR a IN (SELECT assd_name || ' ' || assd_name2 assd_name
                        FROM giis_assured
                       WHERE assd_no = i.assd_no)
            LOOP
               rec.assd_name := a.assd_name;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rec.assd_name := NULL;
         END;

         PIPE ROW (rec);
      END LOOP;
   END populate_fire_tariff_detail;

   FUNCTION populate_fire_zone_master (
      p_user_id      gixx_firestat_summary_dtl.user_id%TYPE,
      p_as_of_sw     gixx_firestat_summary_dtl.as_of_sw%TYPE,
      p_line_cd_fi   VARCHAR2,
      p_zone_type    VARCHAR2
   )
      RETURN fire_zone_master_tab PIPELINED
   AS
      rec   fire_zone_master_type;
   BEGIN
      FOR i IN (SELECT   line_cd, share_cd, SUM (share_tsi_amt)
                                                               share_tsi_amt,
                         SUM (share_prem_amt) share_prem_amt, as_of_sw,
                         user_id
                    FROM gipi_firestat_extract_dtl
                   WHERE user_id = p_user_id
                     AND as_of_sw = p_as_of_sw
                     AND zone_type = p_zone_type
                GROUP BY line_cd, share_cd, as_of_sw, user_id)
      LOOP
         rec.share_cd := i.share_cd;
         rec.share_tsi_amt := i.share_tsi_amt;
         rec.share_prem_amt := i.share_prem_amt;
         rec.as_of_sw := i.as_of_sw;
         rec.line_cd := i.line_cd;

         BEGIN
            FOR a IN (SELECT DISTINCT trty_name
                                 FROM giis_dist_share
                                WHERE share_cd = i.share_cd
                                  AND line_cd = i.line_cd)
            LOOP
               rec.share_name := a.trty_name;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rec.share_name := NULL;
         END;

         BEGIN                          --added edgar for line name 03/20/2015
            FOR a IN (SELECT line_name
                        FROM giis_line
                       WHERE line_cd = i.line_cd)
            LOOP
               rec.line_name := a.line_name;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rec.share_name := NULL;
         END;

         PIPE ROW (rec);
      END LOOP;
   END populate_fire_zone_master;

   FUNCTION populate_fire_zone_detail (
      p_user_id      gixx_firestat_summary_dtl.user_id%TYPE,
      p_as_of_sw     gixx_firestat_summary_dtl.as_of_sw%TYPE,
      p_line_cd_fi   VARCHAR2,
      p_share_cd     gipi_firestat_zone_dtl_v.share_cd%TYPE,
      p_line_cd      gipi_firestat_extract_dtl.line_cd%TYPE,
      p_zone_type    gipi_firestat_extract_dtl.zone_type%TYPE       --VARCHAR2
   )
      RETURN fire_zone_detail_tab PIPELINED
   AS
      rec   fire_zone_detail_type;
   BEGIN
      FOR i IN (SELECT   b.assd_name assd_name,
                            a.line_cd
                         || ' - '
                         || a.subline_cd
                         || ' - '
                         || a.iss_cd
                         || ' - '
                         || LTRIM (TO_CHAR (a.issue_yy, '00'))
                         || ' - '
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0000000'))
                         || ' - '
                         || LTRIM (TO_CHAR (a.renew_no, '00')) policy_no,
                         SUM (NVL (a.share_tsi_amt, 0)) share_tsi_amt,
                         SUM (NVL (a.share_prem_amt, 0)) share_prem_amt,
                         a.as_of_sw, a.user_id, a.line_cd, a.share_cd
                    FROM gipi_firestat_extract_dtl a, giis_assured b
                   WHERE 1 = 1
                     AND a.user_id = p_user_id
                     AND a.as_of_sw = p_as_of_sw
                     AND a.line_cd = p_line_cd
                     AND a.share_cd = p_share_cd
                     AND a.zone_type = p_zone_type
                     AND a.assd_no = b.assd_no
                GROUP BY a.line_cd,
                         a.subline_cd,
                         a.iss_cd,
                         a.issue_yy,
                         a.pol_seq_no,
                         a.renew_no,
                         a.as_of_sw,
                         a.user_id,
                         a.share_cd,
                         b.assd_name
                ORDER BY a.line_cd,
                         a.subline_cd,
                         a.iss_cd,
                         a.issue_yy,
                         a.pol_seq_no,
                         a.renew_no)
      LOOP
         rec.share_cd := i.share_cd;
         rec.assd_name := i.assd_name;
         rec.policy_no := i.policy_no;
         rec.share_tsi_amt := i.share_tsi_amt;
         rec.share_prem_amt := i.share_prem_amt;
         rec.as_of_sw := i.as_of_sw;
         rec.user_id := i.user_id;
         rec.line_cd := i.line_cd;

         BEGIN
            FOR a IN (SELECT trty_name
                        FROM giis_dist_share
                       WHERE share_cd = i.share_cd AND line_cd = i.line_cd)
            LOOP
               rec.share_name := a.trty_name;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               rec.share_name := NULL;
         END;

         PIPE ROW (rec);
      END LOOP;
   END populate_fire_zone_detail;

   FUNCTION populate_fire_com_accum_master (
      p_as_of_sw    VARCHAR2,
      p_zone_type   gipi_firestat_extract_dtl.zone_type%TYPE,
      p_user_id     gipi_firestat_extract_dtl.user_id%TYPE
   )
      RETURN fire_com_accum_master_tab PIPELINED
   AS
      rec   fire_com_accum_master_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT NVL (b.zone_grp, '0') zone_grp,
                          NVL (b.zone_grp_desc,
                               'NO ZONE GROUP') zone_grp_desc, /*b.share_cd*/
                          0 share_cd, b.share_type,
                          NVL (b.acct_trty_type, 0) acct_trty_type,
                             'TOTAL '
                          || DECODE (b.share_type,
                                     '1', UPPER (c.rv_meaning),
                                     '3', UPPER (c.rv_meaning),
                                     '2', DECODE
                                                (b.acct_trty_type,
                                                 NULL, UPPER
                                                            (b.dist_share_name),
                                                 UPPER (b.acct_trty_type_lname)
                                                ),
                                     b.dist_share_name
                                    ) dist_share
                     FROM gipi_firestat_extract_dtl_vw b,
                          (SELECT rv_meaning, rv_low_value
                             FROM cg_ref_codes
                            WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE') c
                    WHERE 1 = 1
                      AND b.user_id = p_user_id
                      AND NVL (b.as_of_sw, 'N') = p_as_of_sw
                      AND b.zone_type = p_zone_type
                      AND b.share_type = c.rv_low_value
                                                       -- ORDER BY NVL (b.zone_grp, '0'), b.share_type /* ,b.share_cd*/
         )
      LOOP
         rec.zone_group := i.zone_grp;
         rec.share_cd := i.share_cd;
         rec.dist_share := i.dist_share;
         rec.share_type := i.share_type;
         rec.acct_trty_type := i.acct_trty_type;
         rec.nbt_zone_grp := i.zone_grp_desc;
         PIPE ROW (rec);
      END LOOP;
   END populate_fire_com_accum_master;

   FUNCTION populate_fire_com_accum_detail (
      p_zone             VARCHAR2,
      p_as_of_sw         VARCHAR2,
      p_zone_grp         giis_eqzone.zone_grp%TYPE,
      p_nbt_zone_grp     VARCHAR2,
      p_zone_type        gipi_firestat_extract_dtl.zone_type%TYPE,
      p_share_cd         gipi_firestat_extract_dtl.share_cd%TYPE,
      p_user_id          gipi_firestat_extract_dtl.user_id%TYPE,
      p_share_type       giis_dist_share.share_type%TYPE,
      p_acct_trty_type   giis_dist_share.acct_trty_type%TYPE
   )
      RETURN fire_com_accum_detail_tab PIPELINED
   AS
      rec   fire_com_accum_detail_type;
   BEGIN
      FOR i IN (SELECT a.zone_grp, a.as_of_sw, a.zone_no, NULL share_cd,
                       a.zone_type, a.line_cd, a.subline_cd, a.iss_cd,
                       a.issue_yy, a.pol_seq_no, a.renew_no, a.policy_no,
                       a.bldg_tsi_amt, a.bldg_prem_amt, a.contents_tsi_amt,
                       a.contents_prem_amt, a.lossprofit_tsi_amt,
                       a.lossprofit_prem_amt
                  FROM gipi_firestat_accum_dtl_vw a
                 WHERE a.user_id = p_user_id
                   AND a.as_of_sw = p_as_of_sw
                   AND a.zone_type = p_zone_type
                   AND a.zone_grp = NVL (p_zone_grp, '0')
                   AND a.share_type = p_share_type
                   AND DECODE (p_share_type,
                               '1', '1',
                               '3', '3',
                               acct_trty_type
                              ) =
                          DECODE (p_share_type,
                                  '1', '1',
                                  '3', '3',
                                  p_acct_trty_type
                                 )
                                  /*SELECT   NVL (a.zone_grp, '0') zone_grp, a.as_of_sw,
                                                     NVL (a.zone_no, '0') zone_no, NULL share_cd,
                                                     a.zone_type, a.line_cd, a.subline_cd, a.iss_cd,
                                                     a.issue_yy, a.pol_seq_no, a.renew_no, a.policy_no,
                                                     SUM (DECODE (a.fi_item_grp,
                                                                  'B', NVL (a.share_tsi_amt, 0),
                                                                  0
                                                                 )
                                                         ) bldg_tsi,
                                                     SUM (DECODE (a.fi_item_grp,
                                                                  'B', NVL (a.share_prem_amt, 0),
                                                                  0
                                                                 )
                                                         ) bldg_prem,
                                                     SUM (DECODE (a.fi_item_grp,
                                                                  'C', NVL (a.share_tsi_amt, 0),
                                                                  0
                                                                 )
                                                         ) contents_tsi,
                                                     SUM (DECODE (a.fi_item_grp,
                                                                  'C', NVL (a.share_prem_amt, 0),
                                                                  0
                                                                 )
                                                         ) contents_prem,
                                                     SUM (DECODE (a.fi_item_grp,
                                                                  'L', NVL (a.share_tsi_amt, 0),
                                                                  0
                                                                 )
                                                         ) loss_tsi,
                                                     SUM (DECODE (a.fi_item_grp,
                                                                  'L', NVL (a.share_prem_amt, 0),
                                                                  0
                                                                 )
                                                         ) loss_prem
                                                FROM gipi_firestat_extract_dtl_vw a
                                               WHERE a.user_id = p_user_id
                                                 AND a.as_of_sw = p_as_of_sw
                                                 AND a.zone_type = p_zone_type
                                                 --AND a.share_cd = :p_share_cd
                                                 AND a.zone_grp = p_zone_grp
                                                 AND a.share_type = p_share_type
                                                 AND DECODE (p_share_type,
                                                             1, a.share_cd,
                                                             3, a.share_cd,
                                                             acct_trty_type
                                                            ) =
                                                        DECODE (p_share_type,
                                                                1, a.share_cd,
                                                                3, a.share_cd,
                                                                p_acct_trty_type
                                                               )
                                                 AND a.fi_item_grp IS NOT NULL
                                            GROUP BY a.zone_grp,
                                                     a.zone_no,
                                                     a.zone_type,
                                                     a.line_cd,
                                                     a.subline_cd,
                                                     a.iss_cd,
                                                     a.issue_yy,
                                                     a.pol_seq_no,
                                                     a.renew_no,
                                                     a.policy_no,
                                                     a.as_of_sw */
              )
      LOOP
         rec.zone_group := i.zone_grp;
         rec.zone_type := i.zone_type;
         rec.zone_no := i.zone_no;
         rec.share_cd := i.share_cd;
         rec.as_of_sw := i.as_of_sw;
         rec.policy_no := i.policy_no;
         rec.line_cd := i.line_cd;
         rec.subline_cd := i.subline_cd;
         rec.iss_cd := i.iss_cd;
         rec.issue_yy := i.issue_yy;
         rec.pol_seq_no := i.pol_seq_no;
         rec.renew_no := i.renew_no;
         rec.tsi_amt_b := i.bldg_tsi_amt;
         rec.prem_amt_b := i.bldg_prem_amt;
         rec.tsi_amt_c := i.contents_tsi_amt;
         rec.prem_amt_c := i.contents_prem_amt;
         rec.tsi_amt_l := i.lossprofit_tsi_amt;
         rec.prem_amt_l := i.lossprofit_prem_amt;
         /* fire_com_accum_dtl_post_query(p_zone_type, p_as_of_sw, /*p_nbt_zone_grp : edgar 04/01/2015*/--p_zone_grp, i.zone_no, i.share_cd, i.line_cd,
         /*                               i.subline_cd, i.iss_cd, i.issue_yy, i.pol_seq_no, i.renew_no, p_user_id,
                                        rec.tsi_amt_b, rec.prem_amt_b, rec.tsi_amt_c, rec.prem_amt_c,
                                        rec.tsi_amt_l, rec.prem_amt_l); */
         PIPE ROW (rec);
      END LOOP;
   END populate_fire_com_accum_detail;

   PROCEDURE fire_com_accum_dtl_post_query (
      p_zone_type        IN       NUMBER,
      p_as_of_sw         IN       VARCHAR2,
      p_nbt_zone_grp     IN       VARCHAR2,
      p_zone_no          IN       gipi_firestat_extract_dtl.zone_no%TYPE,
      p_share_cd         IN       gipi_firestat_extract_dtl.share_cd%TYPE,
      p_line_cd          IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd       IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd           IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy         IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no       IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no         IN       gipi_polbasic.renew_no%TYPE,
      p_user_id          IN       VARCHAR2,
      p_sum_tsi_amt_b    OUT      NUMBER,
      p_sum_prem_amt_b   OUT      NUMBER,
      p_sum_tsi_amt_c    OUT      NUMBER,
      p_sum_prem_amt_c   OUT      NUMBER,
      p_sum_tsi_amt_l    OUT      NUMBER,
      p_sum_prem_amt_l   OUT      NUMBER
   )
   AS
   BEGIN
      p_sum_tsi_amt_b := 0;
      p_sum_prem_amt_b := 0;
      p_sum_tsi_amt_c := 0;
      p_sum_prem_amt_c := 0;
      p_sum_tsi_amt_l := 0;
      p_sum_prem_amt_l := 0;

      FOR a IN (SELECT   SUM (NVL (share_tsi_amt, 0)) share_tsi_amt,
                         SUM (NVL (share_prem_amt, 0)) share_prem_amt,
                         c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy,
                         c.pol_seq_no, c.renew_no, c.share_cd, c.fi_item_grp
                    FROM gipi_firestat_extract_dtl_vw c
                   WHERE 1 = 1
                     AND c.zone_grp = p_nbt_zone_grp
                     AND c.zone_no = p_zone_no
                     AND c.as_of_sw = p_as_of_sw
                     AND c.line_cd = p_line_cd
                     AND c.subline_cd = p_subline_cd
                     AND c.iss_cd = p_iss_cd
                     AND c.issue_yy = p_issue_yy
                     AND c.pol_seq_no = p_pol_seq_no
                     AND c.renew_no = p_renew_no
                     AND c.share_cd = p_share_cd
                     AND c.user_id = p_user_id
                     AND c.zone_type = p_zone_type
                GROUP BY c.line_cd,
                         c.subline_cd,
                         c.iss_cd,
                         c.issue_yy,
                         c.pol_seq_no,
                         c.renew_no,
                         c.share_cd,
                         c.fi_item_grp)
      LOOP
         IF a.fi_item_grp = 'B'
         THEN
            p_sum_tsi_amt_b := a.share_tsi_amt;
            p_sum_prem_amt_b := a.share_prem_amt;
         ELSIF a.fi_item_grp = 'C'
         THEN
            p_sum_tsi_amt_c := a.share_tsi_amt;
            p_sum_prem_amt_c := a.share_prem_amt;
         ELSIF a.fi_item_grp = 'L'
         THEN
            p_sum_tsi_amt_l := a.share_tsi_amt;
            p_sum_prem_amt_l := a.share_prem_amt;
         END IF;
      END LOOP;
   END fire_com_accum_dtl_post_query;

   PROCEDURE check_fire_stat (
      p_fire_stat    IN       VARCHAR2,
      p_date_rb      IN       VARCHAR2,
      p_date         IN       VARCHAR2,
      p_date_from    IN       VARCHAR2,
      p_date_to      IN       VARCHAR2,
      p_as_of_date   IN       VARCHAR2,
      p_bus_cd       IN       NUMBER,
      p_zone         IN       VARCHAR2,
      p_zone_type    IN       VARCHAR2,
      p_risk_cnt     IN       VARCHAR2,
      p_incl_endt    IN       VARCHAR2,
      p_incl_exp     IN       VARCHAR2,
      p_peril_type   IN       VARCHAR2,
      p_user         IN       VARCHAR2,
      p_cnt          OUT      NUMBER
   )
   AS
      v_datefrom   DATE   := TRUNC (TO_DATE (p_date_from, 'MM-DD-RRRR'));
      v_dateto     DATE   := TRUNC (TO_DATE (p_date_to, 'MM-DD-RRRR'));
      v_as_of      DATE   := TRUNC (TO_DATE (p_as_of_date, 'MM-DD-RRRR'));
      v_ctr        NUMBER;
   BEGIN
      IF p_date_rb = '1'
      THEN
         BEGIN
            SELECT COUNT (DISTINCT line_cd
                           || '-'
                           || subline_cd
                           || '-'
                           || iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (issue_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                           || '-'
                           || LTRIM (TO_CHAR (renew_no, '09'))
                         ) cnt
              INTO v_ctr
              FROM gipi_firestat_extract_dtl
             WHERE zone_type = p_zone_type
               AND as_of_sw = 'N'
               AND TRUNC (date_from) = v_datefrom
               AND TRUNC (date_to) = v_dateto
               AND user_id = p_user
               AND param_date = p_date
               AND inc_null_zone = p_zone
               AND inc_expired = p_incl_exp
               AND inc_endt = p_incl_endt
               AND param_iss_cd = p_bus_cd
               AND param_peril = p_peril_type
            HAVING SUM (NVL (share_tsi_amt, 0)) <> 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_ctr := 0;
         END;
      ELSIF p_date_rb = '2'
      THEN
         BEGIN
            SELECT COUNT (DISTINCT line_cd
                           || '-'
                           || subline_cd
                           || '-'
                           || iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (issue_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                           || '-'
                           || LTRIM (TO_CHAR (renew_no, '09'))
                         ) cnt
              INTO v_ctr
              FROM gipi_firestat_extract_dtl
             WHERE zone_type = p_zone_type
               AND as_of_sw = 'Y'
               AND TRUNC (as_of_date) = v_as_of
               AND user_id = p_user
               AND inc_null_zone = p_zone
               AND inc_expired = p_incl_exp
               AND inc_endt = p_incl_endt
               AND param_iss_cd = p_bus_cd
               AND param_peril = p_peril_type
            HAVING SUM (NVL (share_tsi_amt, 0)) <> 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_ctr := 0;
         END;
      END IF;

      p_cnt := v_ctr;
   END check_fire_stat;

   PROCEDURE validate_before_extract ( --edgar 04/27/2015 FULL WEB SR 4322
      p_fire_stat    IN       VARCHAR2,
      p_date_rb      IN       VARCHAR2,
      p_date         IN       VARCHAR2,
      p_date_from    IN       VARCHAR2,
      p_date_to      IN       VARCHAR2,
      p_as_of_date   IN       VARCHAR2,
      p_bus_cd       IN       NUMBER,
      p_zone         IN       VARCHAR2,
      p_zone_type    IN       VARCHAR2,
      p_risk_cnt     IN       VARCHAR2,
      p_incl_endt    IN       VARCHAR2,
      p_incl_exp     IN       VARCHAR2,
      p_peril_type   IN       VARCHAR2,
      p_user         IN       VARCHAR2,
      p_msg_alert    OUT      VARCHAR2
   )
   AS
      v_datefrom      DATE     := TRUNC (TO_DATE (p_date_from, 'MM-DD-RRRR'));
      v_dateto        DATE       := TRUNC (TO_DATE (p_date_to, 'MM-DD-RRRR'));
      v_as_of         DATE    := TRUNC (TO_DATE (p_as_of_date, 'MM-DD-RRRR'));
      v_ctr           NUMBER;
      v_peril_cnt     NUMBER                           := 0;
      v_eq_zonetype   cg_ref_codes.rv_low_value%TYPE;
      v_sharetype     cg_ref_codes.rv_low_value%TYPE;
   BEGIN
      v_peril_cnt := 0;

      --***************************************** VALIDATIONS BEFORE EXTRACTION *************************************************
      IF p_fire_stat = 'E'
      THEN
         /*1.Validation for null fire item group*/
         FOR i IN (SELECT fr_item_type, fr_itm_tp_ds fire_item_type_desc
                     FROM giis_fi_item_type
                    WHERE fi_item_grp IS NULL)
         LOOP
            raise_application_error
               (-20001,
                   'Geniisys Exception#E#There is/are fire item type record/s which does not belong to any fire item group (Building , Contents , Loss of Profit). '
                || 'Please setup these record/s before proceeding with the extraction.'
               );
            EXIT;
         END LOOP;

         /*2. Validation for no perils setup for the selected zone type*/
         BEGIN
            SELECT COUNT (peril_cd)
              INTO v_peril_cnt
              FROM cpi.giis_peril
             WHERE 1 = 1
               AND zone_type IS NOT NULL
               AND zone_type = p_zone_type
               AND line_cd IN (
                      SELECT line_cd
                        FROM cpi.giis_line
                       WHERE menu_line_cd = 'FI'
                          OR (    menu_line_cd IS NULL
                              AND line_cd = giisp.v ('LINE_CODE_FI')
                             ));

            IF v_peril_cnt = 0
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#I#There are no perils categorized under this zone type. No records can be extracted.'
                  );
            END IF;
         END;

         /*3. Validation for incorrect zone type*/
         v_peril_cnt := 0;

         BEGIN
            SELECT COUNT (peril_cd)
              INTO v_peril_cnt
              FROM cpi.giis_peril
             WHERE 1 = 1
               AND zone_type IS NOT NULL
               AND zone_type NOT IN (
                           SELECT rv_low_value
                             FROM cpi.cg_ref_codes
                            WHERE rv_domain =
                                             'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE')
               AND line_cd IN (
                      SELECT line_cd
                        FROM cpi.giis_line
                       WHERE menu_line_cd = 'FI'
                          OR (    menu_line_cd IS NULL
                              AND line_cd = giisp.v ('LINE_CODE_FI')
                             ));

            IF v_peril_cnt <> 0
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#There is/are peril/s with invalid zone types. Please correct these peril/s before proceeding with the extraction.'
                  );
            END IF;
         END;

         /*4. Validation for earthquake zone type */
         FOR zonetype IN (SELECT TRIM (rv_low_value) rv_low_value
                            FROM cg_ref_codes
                           WHERE rv_domain = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
                             AND UPPER (TRIM (rv_meaning)) = 'EARTHQUAKE')
         LOOP
            v_eq_zonetype := zonetype.rv_low_value;
            EXIT;
         END LOOP;

         IF p_zone_type = v_eq_zonetype
         THEN
            v_peril_cnt := 0;

            /*4.1 Validation for earthquake zone type with null eq zone type */
            BEGIN
               SELECT COUNT (peril_cd)
                 INTO v_peril_cnt
                 FROM giis_peril a
                WHERE 1 = 1
                  AND zone_type IS NOT NULL
                  AND zone_type = v_eq_zonetype
                  AND eq_zone_type IS NULL
                  AND line_cd IN (
                         SELECT line_cd
                           FROM cpi.giis_line
                          WHERE menu_line_cd = 'FI'
                             OR (    menu_line_cd IS NULL
                                 AND line_cd = giisp.v ('LINE_CODE_FI')
                                ));

               IF v_peril_cnt <> 0
               THEN
                  raise_application_error
                     (-20001,
                         'Geniisys Exception#E#There is/are peril/s under the Earthquake Zone which does not have a corresponding Earthquake (EQ) Zone Type.'
                      || ' Please setup these record/s before proceeding with the extraction.'
                     );
               END IF;
            END;

            v_peril_cnt := 0;

            BEGIN
               SELECT COUNT (peril_cd)
                 INTO v_peril_cnt
                 FROM cpi.giis_peril
                WHERE 1 = 1
                  AND zone_type IS NOT NULL
                  AND zone_type = v_eq_zonetype
                  AND eq_zone_type NOT IN (
                         SELECT rv_low_value
                           FROM cpi.cg_ref_codes
                          WHERE rv_domain =
                                          'GIPI_FIRESTAT_EXTRACT.EQ_ZONE_TYPE')
                  AND line_cd IN (
                         SELECT line_cd
                           FROM cpi.giis_line
                          WHERE menu_line_cd = 'FI'
                             OR (    menu_line_cd IS NULL
                                 AND line_cd = giisp.v ('LINE_CODE_FI')
                                ));

               IF v_peril_cnt <> 0
               THEN
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#E#There is/are peril/s with invalid Earthquake (EQ) Zone Type. Please correct these peril/s before proceeding with the extraction.'
                     );
               END IF;
            END;
         /*4.1 Validation for earthquake zone type with invalid eq zone type */
         END IF;
      --***************************** VALIDATIONS BEFORE PRINTING OR VIEWING DETAILS ********************************************
      ELSIF p_fire_stat = 'P' OR p_fire_stat = 'V'
      THEN
         /*5. Validation for treaty with null acct treaty type */
         v_peril_cnt := 0;

         FOR sharetype IN (SELECT TRIM (rv_low_value) rv_low_value
                             FROM cg_ref_codes
                            WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE'
                              AND UPPER (TRIM (rv_meaning)) = 'TREATY')
         LOOP
            v_sharetype := sharetype.rv_low_value;
            EXIT;
         END LOOP;

         BEGIN
            SELECT COUNT (share_cd)
              INTO v_peril_cnt
              FROM gipi_firestat_extract_dtl_vw
             WHERE share_type = v_sharetype
               AND acct_trty_type IS NULL
               AND zone_type = p_zone_type
               AND user_id = p_user
               AND fi_item_grp IS NOT NULL
               AND (       as_of_sw = 'Y'
                       AND TRUNC (as_of_date) =
                                             TRUNC (NVL (v_as_of, as_of_date))
                    OR     as_of_sw = 'N'
                       AND TRUNC (date_from) =
                                           TRUNC (NVL (v_datefrom, date_from))
                       AND TRUNC (date_to) = TRUNC (NVL (v_dateto, date_to))
                   );

            IF v_peril_cnt <> 0
            THEN
               raise_application_error
                  (-20001,
                   'Geniisys Exception#E#There are treaty records extracted with no accounting treaty type. Please setup these records before printing the reports or viewing the details.'
                  );
            END IF;
         END;
      END IF;
      
      p_msg_alert := 'SUCCESS';
   END validate_before_extract;
END gipis901_firestat_pkg;
/

CREATE OR REPLACE PUBLIC SYNONYM gipis901_firestat_pkg FOR cpi.gipis901_firestat_pkg; --edgar 04/27/2015 FULL WEB SR 4322

/