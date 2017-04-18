CREATE OR REPLACE PACKAGE BODY CPI.populate_giclr033_fla_xol_pkg AS
   FUNCTION populate_giclr033_fla_xol_ucpb (
      p_claim_id     gicl_claims.claim_id%TYPE,
      p_grp_seq_no   gicl_advs_fla.grp_seq_no%TYPE,
      p_fla_id       gicl_advs_fla.fla_id%TYPE
   )
      RETURN populate_reports_tab PIPELINED AS
      vrep               populate_reports_type;
      v_fla_header       gicl_advs_pla.pla_header%TYPE;
      v_fla_footer       gicl_advs_pla.pla_footer%TYPE;
      v_fla_seq_no       NUMBER (10); 
      v_claim_id         VARCHAR2 (10);
      v_ri_cd            VARCHAR2 (10);
      v_line_cd          VARCHAR2 (10);
      v_share_type       VARCHAR2 (100);
      v_title            VARCHAR2 (200);
      v_pla_id           VARCHAR2 (100);
      v_pla_no           VARCHAR2 (100);
      v_pla_date         VARCHAR2 (100);
      v_loss_cat_cd      VARCHAR2 (10);
      v_curr_cd          VARCHAR2 (10);
      v_layer_no         VARCHAR2 (100);
      v_grp_seq_no       VARCHAR2 (100);
      v_adv_fla_id       VARCHAR2 (100);
      v_xol_clm_dist     VARCHAR2 (2000);
      v_xol_c2           VARCHAR2 (10);
      v_xol_c3           VARCHAR2 (10);
      v_xol_s3           VARCHAR2 (200);
      v_xol_dist_amt     VARCHAR2 (2000);
      v_stype            VARCHAR2 (200);
      v_shr_amt          VARCHAR2 (200);
      v_exists           BOOLEAN                                     := FALSE;
      v_trty_tsi         VARCHAR2 (200);
      v_c1               VARCHAR2 (10)                                 := ' ';
      v_c2               VARCHAR2 (10)                                 := ' ';
      v_sname1           VARCHAR2 (20);
      v_net_amt          NUMBER                                        := 0;
      v_tsi_dist         VARCHAR2 (2000)                              := NULL;
      v_sum_res          NUMBER                                       := 1;
      v_clm_dist         VARCHAR2 (2000)                              := NULL;
      v_dist_amt         VARCHAR2 (2000)                              := NULL;
      v_trty_name        VARCHAR2 (2000);
      v_wrd_s            VARCHAR2 (100);
      v_itemno           gicl_clm_item.item_no%TYPE;
      v_gitemno          gicl_clm_item.grouped_item_no%TYPE;
      v_grp_item_title   gicl_accident_dtl.grouped_item_title%TYPE;
      v_item_title       gicl_clm_item.item_title%TYPE;
      v_des              giis_loss_ctgry.loss_cat_des%TYPE;
      v_loss_loc         VARCHAR2 (150);
      v_loss_res         NUMBER                                        := 0;
      v_exp_res          NUMBER                                        := 0;
      v_xol              NUMBER                                        := 0;
      v_ri_shr           gicl_loss_exp_rids.shr_le_ri_adv_amt%TYPE;
      v_ri_shr_pct       gicl_loss_exp_rids.shr_loss_exp_ri_pct%TYPE;
      v_short_name       VARCHAR2 (20);
      v_sdl              VARCHAR2 (2000); -- added by jdiago 03.26.2014 for signatory
   BEGIN
      FOR i IN (SELECT a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy,
                       a.pol_seq_no, a.renew_no, a.pol_eff_date,
                       a.expiry_date, a.assured_name, b.fla_id, b.fla_seq_no,
                       b.ri_cd, b.fla_header, b.fla_footer, b.share_type,
                       NVL (   b.line_cd
                            || '-'
                            || LTRIM (TO_CHAR (b.la_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (b.fla_seq_no, '0000009')),
                            ' '
                           ) fla_no,
                       c.adv_fla_id, c.currency_cd, d.grp_seq_no,
                       b.fla_title,
                       TO_CHAR (a.loss_date, 'fmMonth dd, yyyy') loss_date, --editted by MJ for consolidation 01022013 [FROM Month to fmMonth]
                       a.loss_cat_cd, b.fla_date
                  FROM gicl_claims a,
                       gicl_advs_fla b,
                       gicl_advice c,
                       (SELECT   a.claim_id, a.advice_id, b.line_cd,
                                 b.share_type, b.grp_seq_no,
                                 SUM (b.shr_le_pd_amt) paid_amt,
                                 SUM (b.shr_le_net_amt) net_amt,
                                 SUM (b.shr_le_adv_amt) adv_amt
                            FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                           WHERE a.claim_id = b.claim_id
                             AND a.clm_loss_id = b.clm_loss_id
                             AND NVL (b.negate_tag, 'N') = 'N'
                             AND b.share_type <> 1
                        GROUP BY a.claim_id,
                                 a.advice_id,
                                 b.line_cd,
                                 b.share_type,
                                 b.grp_seq_no) d
                 WHERE a.claim_id = p_claim_id
                   AND b.claim_id = a.claim_id
                   AND c.claim_id = b.claim_id
                   AND d.claim_id = c.claim_id
                   AND b.grp_seq_no = p_grp_seq_no
                   AND b.grp_seq_no = d.grp_seq_no
                   AND b.share_type = d.share_type
                   AND (b.cancel_tag = 'N' OR cancel_tag IS NULL)
                   AND b.fla_id = NVL(p_fla_id, fla_id)
                   AND b.adv_fla_id IN (
                          SELECT adv_fla_id
                            FROM gicl_advice
                           WHERE claim_id = c.claim_id
                             AND advice_id = c.advice_id))
      LOOP
         vrep.wrd_fla_no := i.fla_no;
         vrep.adv_fla_id := i.adv_fla_id;
         vrep.currency_cd := i.currency_cd;
         vrep.wrd_loss_date := i.loss_date;
         vrep.wrd_date := TO_CHAR (i.fla_date, 'fmMonth dd, rrrr');

         FOR rec IN (SELECT fla_header, fla_footer
                       FROM gicl_advs_fla
                      WHERE claim_id = p_claim_id
                        AND ri_cd = i.ri_cd
                        AND fla_seq_no = i.fla_seq_no)
         LOOP
            v_fla_header := NVL (i.fla_header, rec.fla_header);
            v_fla_footer := NVL (i.fla_footer, rec.fla_footer);
         END LOOP;

         vrep.wrd_footer := v_fla_footer;

         FOR rec IN (SELECT short_name
                       FROM giis_currency
                      WHERE main_currency_cd = i.currency_cd)
         LOOP
            v_short_name := NVL (UPPER (rec.short_name), ' ');
         END LOOP;

         FOR rec IN (SELECT ri_name,
                               mail_address1
                            || CHR (10)
                            || mail_address2
                            || CHR (10)
                            || mail_address3 address
                       FROM giis_reinsurer
                      WHERE ri_cd = i.ri_cd)
         LOOP
            vrep.wrd_ri_name := rec.ri_name;
            vrep.wrd_ri_address := initcap(rec.address);
            EXIT;
         END LOOP;

         vrep.wrd_title :=
            UPPER (   'EXCESS OF LOSS'
                   || CHR (10)
                   || NVL (i.fla_title, 'Final Loss Advice')
                  );

         FOR rec IN (SELECT fla_header, fla_footer
                       FROM gicl_advs_fla
                      WHERE claim_id = p_claim_id
                        AND ri_cd = i.ri_cd
                        AND fla_seq_no = i.fla_seq_no)
         LOOP
            vrep.wrd_header := NVL (i.fla_header, rec.fla_header);
            vrep.wrd_footer := NVL (i.fla_footer, rec.fla_footer);
         END LOOP;


         FOR pla IN (SELECT pla_id, claim_id,
                               line_cd
                            || '-'
                            || la_yy
                            || '-'
                            || TO_CHAR (pla_seq_no, '099') pla_no, -- returned by jdiago 03.26.2014 
                            -- removed by jdiago 03.26.2014 || LTRIM(TO_CHAR (pla_seq_no, '999')) pla_no, -- modified by Kris 12.04.2012: To remove leading zeroes and spaces
                            TO_CHAR (pla_date, 'fmMonth dd, RRRR') pla_date
                       FROM gicl_advs_pla b
                      WHERE claim_id = p_claim_id
                        AND ri_cd = i.ri_cd
                        AND share_type = i.share_type
                        AND NVL (cancel_tag, 'N') = 'N'
                        AND b.res_pla_id =
                               (SELECT MAX (res_pla_id)
                                  FROM gicl_advs_pla c
                                 WHERE b.claim_id = c.claim_id
                                   AND NVL (cancel_tag, 'N') = 'N')
                        AND ROWNUM = 1)
         LOOP
            /*IF v_pla_no IS NULL
            THEN
               v_pla_no := pla.pla_no;
               v_pla_date := pla.pla_date;
            ELSE
               --v_pla_no := v_pla_no || ', ' || pla.pla_no;
               --v_pla_date := v_pla_date || ', ' || pla.pla_date;
               v_pla_no := pla.pla_no;
               v_pla_date := pla.pla_date;
            END IF;*/
            
            -- commented by Kris 12.04.2012
            v_pla_no := pla.pla_no;
            v_pla_date := pla.pla_date;
            
         END LOOP;

         vrep.wrd_begin :=
               'Further to our Preliminary Loss Advice No., '
            || NVL (v_pla_no, '_______________')
            || ' dated '
            || NVL (v_pla_date, '___________________')
            || ' we wish to advise that we have made final settlement of the claim, details are as follows:';

         FOR line IN (SELECT line_name nm
                        FROM giis_line
                       WHERE line_cd = i.line_cd)
         LOOP
            vrep.wrd_line := line.nm;
            EXIT;
         END LOOP;

         SELECT xol_trty_name
           INTO vrep.wrd_treaty_name
           FROM giis_dist_share a, gicl_advs_fla b, giis_xol c
          WHERE b.grp_seq_no = a.share_cd
            AND c.xol_id = a.xol_id
            AND b.fla_id = i.fla_id
            AND b.claim_id = p_claim_id
            AND a.line_cd = i.line_cd;

         vrep.wrd_assured := NVL (INITCAP (LTRIM (i.assured_name)), '-');
         vrep.wrd_policy_no :=
            NVL (   i.line_cd
                 || '-'
                 || i.subline_cd
                 || '-'
                 || i.pol_iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (i.issue_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (i.pol_seq_no, '0000009'))
                 || '-'
                 || LTRIM (TO_CHAR (i.renew_no, '09')),
                 '-'
                );

         FOR rec IN (SELECT    TO_CHAR (b.pol_eff_date,
                                        'fmMonth DD, RRRR'
                                       )
                            || ' to '
                            || TO_CHAR (b.expiry_date, 'fmMonth DD, RRRR')
                                                                         term
                       FROM gicl_claims b
                      WHERE b.claim_id = p_claim_id)
         LOOP
            vrep.wrd_ins_term := rec.term;
            EXIT;
         END LOOP;

         BEGIN
            SELECT DISTINCT item_no, NVL (grouped_item_no, 0)
                       INTO v_itemno, v_gitemno
                       FROM gicl_clm_loss_exp a
                      WHERE claim_id = p_claim_id
                        AND NVL (a.dist_sw, 'N') = 'Y'
                        AND EXISTS (
                               SELECT 1
                                 FROM gicl_advice
                                WHERE claim_id = a.claim_id
                                  AND advice_id = a.advice_id
                                  AND adv_fla_id = NVL (i.adv_fla_id, 0));
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               ---msg_alert('No data found in GICL_CLM_LOSS_EXP table','E',TRUE);
               NULL;
            WHEN TOO_MANY_ROWS
            THEN
               v_grp_item_title := 'Various';
               v_item_title := 'Various Items';
         END;

         IF v_gitemno <> 0
         THEN
            v_grp_item_title :=
               INITCAP (get_gpa_item_title (p_claim_id,
                                            i.line_cd,
                                            v_itemno,
                                            v_gitemno
                                           )
                       );
            v_item_title := v_grp_item_title;
         ELSE
            BEGIN
               SELECT INITCAP (item_title)
                 INTO v_item_title
                 FROM gicl_clm_item
                WHERE claim_id = p_claim_id AND item_no = v_itemno;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
               WHEN TOO_MANY_ROWS
               THEN
                  v_item_title := 'Various Items';
            END;
         END IF;

         vrep.wrd_item_title := NVL (INITCAP (v_item_title), '-');

         FOR rec IN (SELECT short_name
                       FROM giis_currency
                      WHERE main_currency_cd = i.currency_cd)
         LOOP
            vrep.wrd_s := NVL (UPPER (rec.short_name), ' ');
         END LOOP;

         IF vrep.wrd_s <> giacp.v ('DEFAULT_CURRENCY')
         THEN
            vrep.wrd_tsi_amt :=
               NVL (get_ann_tsi_oc (i.line_cd,
                                    i.subline_cd,
                                    i.pol_iss_cd,
                                    i.issue_yy,
                                    i.pol_seq_no,
                                    i.renew_no,
                                    TRUNC (i.pol_eff_date),
                                    TRUNC (i.expiry_date),
                                    'ED'
                                   ),
                    0
                   );
         ELSE
            vrep.wrd_tsi_amt :=
               NVL (get_ann_tsi (i.line_cd,
                                 i.subline_cd,
                                 i.pol_iss_cd,
                                 i.issue_yy,
                                 i.pol_seq_no,
                                 i.renew_no,
                                 TRUNC (i.pol_eff_date),
                                 TRUNC (i.expiry_date),
                                 'ED'
                                ),
                    0
                   );
         END IF;

         -- loss cat des
         FOR rec IN (SELECT loss_cat_des
                       FROM giis_loss_ctgry
                      WHERE line_cd = i.line_cd
                            AND loss_cat_cd = i.loss_cat_cd)
         LOOP
            v_des := rec.loss_cat_des;
            EXIT;
         END LOOP;

         vrep.wrd_loss_cat := initcap(v_des);

         -- location of Loss
         FOR loss IN (SELECT    loss_loc1
                             || ' '
                             || loss_loc2
                             || ' '
                             || loss_loc3 LOCATION
                        FROM gicl_claims
                       WHERE claim_id = p_claim_id)
         LOOP
            v_loss_loc := loss.LOCATION;
            EXIT;
         END LOOP;

         vrep.wrd_loss_loc := v_loss_loc;

         -- losses pd/ exp pd
         FOR lose IN (SELECT   --SUM (a.net_amt) * b.convert_rate amt, removed by jdiago 03.26.2014 no need to convert
                               SUM(a.net_amt) amt, -- added by jdiago 03.26.2014
                               payee_type
                          FROM gicl_clm_loss_exp a, gicl_advice b
                         WHERE a.claim_id = p_claim_id
                           AND NVL (a.dist_sw, 'N') = 'Y'
                           AND a.claim_id = b.claim_id
                           AND a.advice_id = b.advice_id
                           AND b.adv_fla_id = NVL (i.adv_fla_id, 0)
                      GROUP BY b.convert_rate, payee_type)
         LOOP
            IF lose.payee_type = 'L'
            THEN
               v_loss_res := lose.amt;
            ELSIF lose.payee_type = 'E'
            THEN
               v_exp_res := lose.amt;
            END IF;
         END LOOP;

         ---share of ri: sum ri share if ri exists in multiple layers
         FOR x IN (SELECT     SUM (shr_le_ri_adv_amt)
                            --* b.convert_rate ri_shr_amt removed by jdiago 03.26.2014 no need to convert
                              ri_shr_amt
                       FROM gicl_loss_exp_rids a, gicl_advice b
                      WHERE a.claim_id = b.claim_id
                        AND a.claim_id = p_claim_id
                        AND NVL (a.prnt_ri_cd, a.ri_cd) = i.ri_cd
                        AND b.adv_fla_id = NVL (i.adv_fla_id, 0)
                        AND EXISTS (
                               SELECT 1
                                 FROM gicl_loss_exp_ds c
                                WHERE claim_id = a.claim_id
                                  AND clm_loss_id = a.clm_loss_id
                                  AND clm_dist_no = a.clm_dist_no
                                  AND grp_seq_no = a.grp_seq_no
                                  AND NVL (negate_tag, 'N') = 'N'
                                  AND share_type = 4
                                  AND EXISTS (
                                         SELECT 1
                                           FROM gicl_clm_loss_exp
                                          WHERE claim_id = c.claim_id
                                            AND clm_loss_id = c.clm_loss_id
                                            AND advice_id = b.advice_id
                                            AND NVL (dist_sw, 'N') = 'Y'))
                   GROUP BY b.convert_rate)
         LOOP
            v_ri_shr := x.ri_shr_amt;
         END LOOP;

         --excess of loss    by reymon 10192010
         FOR x1 IN (SELECT --SUM (a.shr_le_adv_amt * b.convert_rate) xol removed by jdiago 03.26.2014 no need to convert
                           SUM (a.shr_le_adv_amt) xol --added by jdiago
                      FROM gicl_loss_exp_ds a,
                           gicl_advice b,
                           gicl_clm_loss_exp c
                     WHERE a.claim_id = b.claim_id
                       AND a.claim_id = p_claim_id
                       AND b.adv_fla_id = NVL (i.adv_fla_id, 0)
                       AND a.claim_id = c.claim_id
                       AND a.clm_loss_id = c.clm_loss_id
                       AND b.advice_id = c.advice_id
                       AND a.share_type = 4
                       AND NVL (c.dist_sw, 'N') = 'Y'
                       AND NVL (a.negate_tag, 'N') = 'N')
         LOOP
            v_xol := x1.xol;
         END LOOP;
         
         --v_ri_shr_pct := ROUND ((v_ri_shr / /*v_sum_res*/ v_xol) * 100, 2); removed by jdiago 03.26.2014
         /* added by jdiago 03.26.2014 to avoid divisor is 0 */
         IF v_xol = 0 THEN
            v_ri_shr_pct := ROUND ((v_ri_shr / 0.000001) * 100, 2);
         ELSE
            v_ri_shr_pct := ROUND ((v_ri_shr / v_xol) * 100, 2);
         END IF;
         
         FOR rec IN (SELECT   b.item_no, c.signatory, c.designation, b.label, a.report_id
                        FROM giac_documents a, giac_rep_signatory b, giis_signatory_names c
                       WHERE a.report_no = b.report_no
                         AND a.report_id = 'GICLR033_XOL'
                         AND a.line_cd IS NULL
                         AND EXISTS (SELECT 1
                                       FROM giac_documents
                                      WHERE report_id = 'GICLR033_XOL'
                                      )
                         AND b.signatory_id = c.signatory_id
                    ORDER BY 1)
      LOOP
         IF v_sdl IS NOT NULL
         THEN
            v_sdl :=
                  v_sdl
               || CHR (10)
               || CHR (10)
               || rec.label
               || CHR (10)
               || CHR (10)
               || CHR (10)
               || rec.signatory
               || CHR (10)
               || rec.designation;
         ELSE
            v_sdl :=
                  rec.label
               || CHR (10)
               || CHR (10)
               || CHR (10)
               || rec.signatory
               || CHR (10)
               || rec.designation;
         END IF;
      END LOOP;
      
      vrep.wrd_signatory :=
         NVL (v_sdl,
                 'Very truly yours,'
              || CHR (10)
              || CHR (10)
              || '__________________'
              || CHR (10)
              || 'Authorized Signature'
      );
         
         vrep.wrd_share_amt := v_ri_shr;
         v_sum_res := NVL (v_loss_res, 0) + NVL (v_exp_res, 0);
         vrep.wrd_s4 := v_short_name;
         vrep.wrd_pct := TO_CHAR (v_ri_shr_pct, '999.99');
         vrep.wrd_los_amt := v_loss_res;
         vrep.wrd_exp_amt := v_exp_res;
         vrep.wrd_total_amt := v_sum_res;
         PIPE ROW (vrep);
      END LOOP;
   END populate_giclr033_fla_xol_ucpb;

   FUNCTION get_fla_xol_rec (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_currency_cd   gicl_advice.currency_cd%TYPE,
      p_adv_fla_id    gicl_advs_fla.adv_fla_id%TYPE
   )
      RETURN fla_xol_tab PIPELINED AS
      vrep            fla_xol_type;
      v_adv_fla_id    gicl_advs_fla.adv_fla_id%TYPE;
      v_xoltrtyname   VARCHAR2 (2000);
      v_xolclmdist    VARCHAR2 (2000)                 := NULL;
      --distribution: claims
      v_xoldistamt    NUMBER;
      --distribution amt: claims
      v_xolc2         VARCHAR2 (1000);                           --claim dist
      v_xolsname2     VARCHAR2 (32767);                          --claim dist
      v_sdl           VARCHAR2 (2000)                 := NULL;
      v_deduct_amt    VARCHAR2 (2000)                 := NULL;
      v_short_name    VARCHAR2 (5000);
   BEGIN
      --get adv_fla_id
      FOR i IN (SELECT   a.share_type,
                         DECODE (a.share_type,
                                 1, 'Retention',
                                 2, 'Treaty',
                                 3, 'Facultative',
                                 4, 'Retention'
                                ) stype,
                         --SUM (shr_le_adv_amt) * b.convert_rate shr_amt, removed by jdiago 03.26.2014 no need to convert
                         SUM (shr_le_adv_amt) shr_amt, -- added by jdiago 03.26.2014
                         g.trty_name trty_nm
                    FROM gicl_loss_exp_ds a, gicl_advice b,
                         giis_dist_share g
                   WHERE a.claim_id = p_claim_id
                     AND NVL (a.negate_tag, 'N') = 'N'
                     AND a.claim_id = b.claim_id
                     AND a.line_cd = g.line_cd
                     AND a.grp_seq_no = g.share_cd
                     AND b.adv_fla_id = NVL (p_adv_fla_id, 0)
                     AND EXISTS (
                            SELECT 1
                              FROM gicl_clm_loss_exp c
                             WHERE claim_id = a.claim_id
                               AND clm_loss_id = a.clm_loss_id
                               AND NVL (dist_sw, 'N') = 'Y'
                               AND advice_id = b.advice_id)
                GROUP BY a.share_type, b.convert_rate, g.trty_name
                ORDER BY a.share_type ASC)
      LOOP
         FOR rec IN (SELECT short_name
                       FROM giis_currency
                      WHERE main_currency_cd = p_currency_cd)
         LOOP
            v_short_name := NVL (UPPER (rec.short_name), ' ');
         END LOOP;

         IF i.share_type = 4
         THEN
            IF v_xolclmdist IS NULL
            THEN
               v_xolclmdist := i.trty_nm;
               --v_xolc2 := ':';
               v_xolsname2 := v_short_name;
               v_xoldistamt := i.shr_amt;
            ELSE
               v_xolclmdist := i.trty_nm;
               --v_xolc2 := ':';
               v_xolsname2 := v_short_name;
               v_xoldistamt := i.shr_amt;
            END IF;
         END IF;

         ---vrep.share_type := i.share_type;
            --vrep.stype := i.stype;
            --vrep.wrd_xol_amt := i.share_amt;
         IF v_xolclmdist IS NOT NULL
         THEN
            vrep.wrd_xol_amt := v_xoldistamt;
            vrep.wrd_xol_desc := initcap(v_xolclmdist);
            vrep.wrd_s3 := v_short_name;
            PIPE ROW (vrep);
         END IF;
      END LOOP;
   END get_fla_xol_rec;

   FUNCTION get_fla_xol_dist (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_grp_seq_no    gicl_advs_fla.grp_seq_no%TYPE,
      p_currency_cd   gicl_advice.currency_cd%TYPE,
      p_adv_fla_id    gicl_advs_fla.adv_fla_id%TYPE,
      p_tsi_amt       NUMBER
   )
      RETURN fla_xol_dist_tab PIPELINED AS
      vrep           fla_xol_dist_type;
      v_adv_fla_id   gicl_advs_fla.adv_fla_id%TYPE;
      v_clm_dist     VARCHAR2 (2000)                 := NULL;
      v_dist_amt     NUMBER                          := NULL;
      v_sname2       VARCHAR2 (32767);                           --claim dist
      v_short_name   VARCHAR2 (32767);
   BEGIN
      FOR j IN (SELECT   a.share_type,
                         DECODE (a.share_type,
                                 1, 'Retention',
                                 2, g.trty_name,
                                 3, 'Facultative',
                                 4, 'Retention'
                                ) stype,
                         --SUM (shr_le_adv_amt) * b.convert_rate shr_amt, removed by jdiago 03.26.2014 no need to convert
                         SUM (shr_le_adv_amt) shr_amt, --added by jdiago 03.26.2014
                         g.line_cd
                    FROM gicl_loss_exp_ds a, gicl_advice b, giis_dist_share g
                   WHERE a.claim_id = p_claim_id
                     AND NVL (a.negate_tag, 'N') = 'N'
                     AND a.claim_id = b.claim_id
                     AND a.line_cd = g.line_cd
                     AND a.grp_seq_no = g.share_cd
                     AND b.adv_fla_id = NVL (p_adv_fla_id, 0)
                     AND EXISTS (
                            SELECT 1
                              FROM gicl_clm_loss_exp c
                             WHERE claim_id = a.claim_id
                               AND clm_loss_id = a.clm_loss_id
                               AND NVL (dist_sw, 'N') = 'Y'
                               AND advice_id = b.advice_id)
                GROUP BY a.share_type,
                         b.convert_rate,
                         DECODE (a.share_type,
                                 1, 'Retention',
                                 2, g.trty_name,
                                 3, 'Facultative',
                                 4, 'Retention'
                                ),
                         g.line_cd
                ORDER BY a.share_type ASC)
      LOOP
         FOR rec IN (SELECT short_name
                       FROM giis_currency
                      WHERE main_currency_cd = p_currency_cd)
         LOOP
            v_short_name := NVL (UPPER (rec.short_name), ' ');
         END LOOP;

         --for claims distribution -- modified by abie 04/11/2011
         IF v_clm_dist IS NULL
         THEN
            IF j.share_type != 4
            THEN
               IF j.share_type IN (2, 3)
               THEN
                  v_clm_dist := j.stype;
                  v_sname2 := v_short_name;
                  v_dist_amt := j.shr_amt;
               ELSE
                  v_clm_dist := 'Ultimate Net Loss';
                  v_sname2 := v_short_name;
                  v_dist_amt := j.shr_amt;
               END IF;
            END IF;
         ELSE
            IF j.share_type != 4
            THEN
               IF j.share_type IN (2, 3)
               THEN
                  v_clm_dist := j.stype;
                  v_sname2 := v_short_name;
                  v_dist_amt := j.shr_amt;
               ELSE
                  v_clm_dist := 'Ultimate Net Loss';
                  v_sname2 := v_short_name;
                  v_dist_amt := j.shr_amt;
               END IF;
            END IF;
         END IF;

         FOR d IN (SELECT DISTINCT b.layer_no, a.share_type, grp_seq_no,
                                   UPPER (trty_name) trty_name,
                                   xol_base_amount undr_limit
                              FROM gicl_loss_exp_ds a, giis_dist_share b
                             WHERE a.share_type = b.share_type
                               AND a.grp_seq_no = b.share_cd
                               AND claim_id = p_claim_id
                               AND b.line_cd = j.line_cd
                               AND a.share_type = j.share_type
                               AND a.share_type = 4
                               AND NVL (a.negate_tag, 'N') = 'N'
                               AND b.layer_no =
                                      (SELECT MAX (b.layer_no)
                                         FROM gicl_loss_exp_ds a,
                                              giis_dist_share b
                                        WHERE a.share_type = b.share_type
                                          AND a.grp_seq_no = b.share_cd
                                          AND claim_id = p_claim_id
                                          AND b.line_cd = j.line_cd
                                          AND a.share_type = 4
                                          AND NVL (a.negate_tag, 'N') = 'N')
                          ORDER BY 1 DESC)
         LOOP
            IF v_clm_dist IS NULL
            THEN
               v_clm_dist := 'Underlying Limit';
               v_sname2 := v_short_name;
               v_dist_amt := d.undr_limit;
            ELSE
               v_clm_dist := 'Underlying Limit';
               v_sname2 := v_short_name;
               v_dist_amt := d.undr_limit;
            END IF;
         END LOOP;

         vrep.wrd_trty2 := v_clm_dist;
         vrep.wrd_s2 := v_sname2;
         vrep.wrd_dist_amt2 := v_dist_amt;
         PIPE ROW (vrep);
      END LOOP;
   END get_fla_xol_dist;

   FUNCTION get_fla_xol_dist2 (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_currency_cd   gicl_advice.currency_cd%TYPE,
      p_adv_fla_id    gicl_advs_fla.adv_fla_id%TYPE,
      p_tsi_amt       NUMBER
   )
      RETURN fla_xol_dist_tab PIPELINED AS
      vrep           fla_xol_dist_type;
      v_short_name   VARCHAR2 (32767);
      v_tsi_dist     VARCHAR2 (2000)                 := NULL;
      v_sum_res      NUMBER                          := 0;   --total loss amt
      v_loss_res     NUMBER;
      v_exp_res      NUMBER;
   BEGIN
      FOR i IN (SELECT   --SUM (a.net_amt) * b.convert_rate amt, payee_type removed by jdiago 03.26.2014 no need to convert
                         SUM (a.net_amt) amt, payee_type --added by jdiago 03.26.2014
                    FROM gicl_clm_loss_exp a, gicl_advice b
                   WHERE a.claim_id = p_claim_id
                     AND NVL (a.dist_sw, 'N') = 'Y'
                     AND a.claim_id = b.claim_id
                     AND a.advice_id = b.advice_id
                     AND b.adv_fla_id = NVL (p_adv_fla_id, 0)
                GROUP BY b.convert_rate, payee_type)
      LOOP
         IF i.payee_type = 'L'
         THEN
            v_loss_res := i.amt;
         ELSIF i.payee_type = 'E'
         THEN
            v_exp_res := i.amt;
         END IF;
      END LOOP;

      v_sum_res := NVL (v_loss_res, 0) + NVL (v_exp_res, 0);

      FOR j IN (SELECT   DECODE (a.share_type,
                                 1, 'Retention',
                                 2, g.trty_name,
                                 3, 'Facultative',
                                 4, 'Retention'
                                ) stype,
                         --SUM (shr_le_adv_amt) * b.convert_rate shr_amt, removed by jdiago 03.26.2014 no need to convert
                         SUM (shr_le_adv_amt) shr_amt, --added by jdiago
                         g.line_cd
                    FROM gicl_loss_exp_ds a, gicl_advice b, giis_dist_share g
                   WHERE a.claim_id = p_claim_id
                     AND NVL (a.negate_tag, 'N') = 'N'
                     AND a.claim_id = b.claim_id
                     AND a.line_cd = g.line_cd
                     AND a.grp_seq_no = g.share_cd
                     AND b.adv_fla_id = NVL (p_adv_fla_id, 0)
                     AND EXISTS (
                            SELECT 1
                              FROM gicl_clm_loss_exp c
                             WHERE claim_id = a.claim_id
                               AND clm_loss_id = a.clm_loss_id
                               AND NVL (dist_sw, 'N') = 'Y'
                               AND advice_id = b.advice_id)
                GROUP BY b.convert_rate,
                         DECODE (a.share_type,
                                 1, 'Retention',
                                 2, g.trty_name,
                                 3, 'Facultative',
                                 4, 'Retention'
                                ),
                         g.line_cd)
      LOOP
         FOR rec IN (SELECT short_name
                       FROM giis_currency
                      WHERE main_currency_cd = p_currency_cd)
         LOOP
            v_short_name := NVL (UPPER (rec.short_name), ' ');
         END LOOP;

         IF j.stype = 'RETENTION'
         THEN
            v_tsi_dist := TO_CHAR (j.shr_amt, '999,999,999,990.90');
         ELSE
            v_tsi_dist :=
               TO_CHAR ((p_tsi_amt * (j.shr_amt / v_sum_res)),
                        '999,999,999,990.90'
                       );
         END IF;

         vrep.wrd_trty1 := j.stype;
         vrep.wrd_dist_amt1 := v_tsi_dist;
         vrep.wrd_s1 := v_short_name;
         PIPE ROW (vrep);
      END LOOP;
   END get_fla_xol_dist2;
END;
/


