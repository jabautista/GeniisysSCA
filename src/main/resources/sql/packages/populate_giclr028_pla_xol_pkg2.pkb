CREATE OR REPLACE PACKAGE BODY CPI.populate_giclr028_pla_xol_pkg2 AS
   FUNCTION populate_giclr028_pla_xol_ucpb (
      p_claim_id     gicl_claims.claim_id%TYPE,
      p_grp_seq_no   gicl_advs_fla.grp_seq_no%TYPE
   )
      RETURN populate_reports_tab PIPELINED AS
      vrep            populate_reports_type;
      v_platitle      VARCHAR2 (2000);
      v_footer        VARCHAR2 (2000);
      v_hdr           VARCHAR2 (2000);
      v_end           VARCHAR2 (2000);
      v_begin         VARCHAR2 (2000)
         := 'This is to inform you of a loss affecting our treaty, details are as follows:';
      v_xoltrtyname   VARCHAR2 (2000)       := NULL;
      v_policy        VARCHAR2 (2000);
      v_term          VARCHAR2 (2000);
      v_item_title    VARCHAR2 (2000)       := NULL;
      v_ino           NUMBER;
      v_cur           VARCHAR2 (50);
      v_tsi           NUMBER;
      v_curr_name     VARCHAR2 (50);
      v_lossres       NUMBER;
      v_expres        NUMBER;
      v_resamt        NUMBER;
      v_pct_shr       VARCHAR2 (2000)       := NULL;
      v_shrpct        VARCHAR2 (2000)       := NULL;
      v_shramt        VARCHAR2 (2000)       := NULL;
   BEGIN
      FOR i IN (SELECT NVL (   d.line_cd
                            || '-'
                            || LTRIM (TO_CHAR (d.la_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (d.pla_seq_no, '00000009')),
                            '___________________'
                           ) pla_no,
                       d.ri_cd, d.pla_title, d.pla_footer, d.pla_header,
                       a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy,
                       a.pol_seq_no, a.renew_no, d.pla_id, a.assured_name,
                       d.grouped_item_no, d.res_pla_id, b.currency_cd,
                       a.pol_eff_date, a.expiry_date, a.loss_date,
                       a.loss_cat_cd,
                          a.loss_loc1
                       || ' '
                       || a.loss_loc2
                       || ' '
                       || a.loss_loc3 LOCATION
                  FROM gicl_claims a,
                       gicl_clm_res_hist b,
                       gicl_reserve_ds c,
                       gicl_advs_pla d
                 WHERE a.claim_id = p_claim_id
                   AND b.claim_id = a.claim_id
                   AND c.claim_id = b.claim_id
                   AND c.clm_res_hist_id = b.clm_res_hist_id
                   AND b.hist_seq_no IN (
                          SELECT DISTINCT hist_seq_no
                                     FROM gicl_reserve_ds
                                    WHERE (   negate_tag = 'N'
                                           OR negate_tag IS NULL
                                          )
                                      AND claim_id = a.claim_id)
                   AND b.dist_sw = 'Y'
                   AND (c.negate_tag = 'N' OR c.negate_tag IS NULL)
                   AND c.share_type <> 1
                   AND d.claim_id = a.claim_id
                   AND d.grp_seq_no = p_grp_seq_no
                   AND d.grp_seq_no = c.grp_seq_no
                   AND d.share_type = c.share_type
                   AND (d.cancel_tag = 'N' OR d.cancel_tag IS NULL)
                   AND d.pla_id IN (
                          SELECT pla_id
                            FROM gicl_reserve_rids
                           WHERE claim_id = a.claim_id
                             AND grp_seq_no = c.grp_seq_no
                             AND share_type = c.share_type
                             AND clm_res_hist_id = b.clm_res_hist_id)
                   AND c.grp_seq_no = d.grp_seq_no
                   AND c.share_type = d.share_type)
      LOOP
         vrep.wrd_pla_no := i.pla_no;
         vrep.res_pla_id := i.res_pla_id;
         vrep.wrd_loss_date := TO_CHAR (i.loss_date, 'Month dd, yyyy');
         vrep.wrd_loss_loc := i.LOCATION;
         vrep.line_cd := i.line_cd;

         FOR rec IN (SELECT short_name
                       FROM giis_currency
                      WHERE main_currency_cd = i.currency_cd)
         LOOP
            v_curr_name := rec.short_name;
         END LOOP;

         vrep.wrd_s := v_curr_name;
         v_policy :=
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
                 ' '
                );
         vrep.wrd_policy_no := NVL (v_policy, '-');

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
            vrep.wrd_ri_address := rec.address;
            EXIT;
         END LOOP;

         FOR x IN (SELECT param_name, param_value_v
                     FROM giac_parameters
                    WHERE param_name LIKE 'PLA%')
         LOOP
            IF x.param_name = 'PLA_TITLE' AND x.param_value_v IS NULL
            THEN                                                  --pla title
               v_platitle := NVL (i.pla_title, 'PRELIMINARY LOSS ADVICE');
            ELSIF x.param_name = 'PLA_TITLE' AND x.param_value_v IS NOT NULL
            THEN
               v_platitle := x.param_value_v;
            ELSIF x.param_name = 'PLA_FOOTER'
            THEN                                                 -- pla footer
               v_footer := NVL (i.pla_footer, x.param_value_v);
            ELSIF x.param_name = 'PLA_HEADER'
            THEN                                                      --header
               v_hdr := NVL (i.pla_header, x.param_value_v);
            ELSIF x.param_name = 'PLA_ENDING_TEXT'
            THEN                                                   -- end text
               v_end := x.param_value_v;
            --ELSIF x.param_name = 'PLA_BEGINNING_TEXT'
            --THEN
            --dbms_output.put_line('here');                                                    --begin
               --v_begin := x.param_value_v;
            END IF;
         END LOOP;

         FOR LN IN (SELECT line_name
                      FROM giis_line
                     WHERE line_cd = i.line_cd)
         LOOP
            vrep.wrd_line := LN.line_name;
         END LOOP;

         SELECT xol_trty_name
           INTO v_xoltrtyname
           FROM giis_dist_share a, gicl_advs_pla b, giis_xol c
          WHERE b.grp_seq_no = a.share_cd
            AND c.xol_id = a.xol_id
            AND b.pla_id = i.pla_id
            AND b.claim_id = p_claim_id
            AND a.line_cd = i.line_cd;

         FOR rec IN (SELECT (   TO_CHAR (pol_eff_date, 'fmMONTH DD, YYYY')
                             || ' to '
                             || TO_CHAR (expiry_date, 'fmMONTH DD, YYYY')
                            ) term
                       FROM gicl_claims
                      WHERE claim_id = p_claim_id)
         LOOP
            v_term := INITCAP (NVL (rec.term, '-'));
         END LOOP;

         vrep.wrd_ins_term := v_term;

         BEGIN
            SELECT DISTINCT item_no
                       INTO v_ino
                       FROM gicl_reserve_rids
                      WHERE claim_id = p_claim_id
                            AND res_pla_id = i.res_pla_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
            WHEN TOO_MANY_ROWS
            THEN
               v_item_title := 'VARIOUS ITEMS';
         END;

         IF v_ino IS NOT NULL
         THEN
            v_item_title :=
               get_gpa_item_title (p_claim_id,
                                   i.line_cd,
                                   v_ino,
                                   i.grouped_item_no
                                  );
         END IF;

         vrep.wrd_item_title := v_item_title;

         --currency
         FOR rec IN (SELECT short_name
                       FROM giis_currency
                      WHERE main_currency_cd = i.currency_cd)
         LOOP
            v_cur := rec.short_name;
         END LOOP;

         vrep.wrd_s := v_cur;

         --tsi
         IF v_cur <> giacp.v ('DEFAULT_CURRENCY')
         THEN
            v_tsi :=
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
            v_tsi :=
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

         vrep.pla_id := i.pla_id;
         vrep.currency_cd := i.currency_cd;
         vrep.wrd_tsi_amt := NVL (v_tsi, 0);
         vrep.wrd_title :=
            UPPER (   'Excess of Loss '
                   || CHR (10)
                   || NVL (v_platitle, 'Preliminary Loss Advice')
                  );
         vrep.wrd_header := v_hdr;
         vrep.wrd_begin := v_begin;
         vrep.wrd_footer := v_footer;
         vrep.wrd_treaty_name :=
                              NVL (LTRIM (v_xoltrtyname), '_________________');
         vrep.wrd_assured := INITCAP (NVL (LTRIM (i.assured_name), '-'));

         FOR lss IN (SELECT UPPER (loss_cat_des) loss
                       FROM giis_loss_ctgry
                      WHERE line_cd = i.line_cd
                            AND loss_cat_cd = i.loss_cat_cd)
         LOOP
            --variables.v_lossCat := i.loss;
            vrep.wrd_loss_cat := INITCAP (lss.loss);
         END LOOP;

         FOR los IN (SELECT   NVL (loss_reserve, 0)
                            + NVL (expense_reserve, 0) reserve,
                            NVL (loss_reserve, 0) loss,
                            NVL (expense_reserve, 0) EXP
                       FROM gicl_clm_res_hist a
                      WHERE claim_id = p_claim_id
                        AND NVL (dist_sw, 'N') = 'Y'
                        AND EXISTS (
                               SELECT 1
                                 FROM gicl_reserve_rids
                                WHERE claim_id = a.claim_id
                                  AND clm_res_hist_id = a.clm_res_hist_id
                                  AND res_pla_id = i.res_pla_id))
         LOOP
            --v_amt := i.reserve;
            v_resamt := NVL (los.reserve, 0);
            v_lossres := NVL (los.loss, 0);
            v_expres := NVL (los.EXP, 0);
         END LOOP;

         vrep.wrd_los_amt := v_lossres;
         vrep.wrd_exp_amt := v_expres;
         vrep.wrd_total_amt := v_resamt;

         FOR rec_total IN (SELECT SUM (  NVL (a.shr_loss_res_amt, 0)
                                       + NVL (a.shr_exp_res_amt, 0)
                                      ) amt
                             FROM gicl_reserve_ds a
                            WHERE a.claim_id = p_claim_id
                              AND a.share_type = 4
                              AND EXISTS (
                                     SELECT 1
                                       FROM gicl_reserve_rids b
                                      WHERE res_pla_id = i.res_pla_id
                                        AND a.claim_id = b.claim_id
                                        AND a.clm_res_hist_id =
                                                             b.clm_res_hist_id
                                        AND a.clm_dist_no = b.clm_dist_no
                                        AND a.grp_seq_no = b.grp_seq_no))
         LOOP
            FOR ri_rec IN
               (SELECT NVL
                          (SUM (  NVL (c.shr_loss_ri_res_amt, /*1*/ 0)
                                + NVL (c.shr_exp_ri_res_amt, /*1*/ 0)
                               ),                                        /*1*/
                           0
                          ) ri_amt
                  -- modified NVL function from using 1 as default value to 0. - abie
                FROM   gicl_clm_res_hist a,
                       gicl_reserve_ds b,
                       gicl_reserve_rids c
                 WHERE a.claim_id = p_claim_id                           -- 86
                   AND NVL (dist_sw, 'N') = 'Y'
                   AND a.claim_id = b.claim_id
                   AND a.clm_res_hist_id = b.clm_res_hist_id
                   AND c.res_pla_id = i.res_pla_id                        --11
                   AND a.claim_id = c.claim_id
                   AND a.clm_res_hist_id = c.clm_res_hist_id
                   AND b.grp_seq_no = c.grp_seq_no
                   AND c.ri_cd = i.ri_cd                                 -- 10
                   AND b.share_type = 4
                   AND b.claim_id = c.claim_id
                   AND b.clm_res_hist_id = c.clm_res_hist_id
                   AND b.clm_dist_no = c.clm_dist_no)
               -- mark jm 03.19.09 replaced old query due to incorrect amount retrieved
            -- query based on Ms. Jen's select statement ends here
            LOOP
               v_pct_shr :=
                   TO_CHAR (ROUND ((ri_rec.ri_amt / rec_total.amt) * 100, 2));
               v_shrpct :=
                     TO_CHAR (ROUND ((ri_rec.ri_amt / rec_total.amt) * 100, 2)
                             )
                  || '% of Excess of Loss ';
               v_shramt := NVL (ri_rec.ri_amt, 0);
            END LOOP;
         END LOOP;

         vrep.wrd_pct := v_pct_shr;
         vrep.wrd_s4 := v_curr_name;
         vrep.wrd_share_amt := v_shramt;
         --variables.v_resAmt := nvl(variables.v_resAmt,'0.00');
         PIPE ROW (vrep);
      END LOOP;
   END populate_giclr028_pla_xol_ucpb;

   FUNCTION get_pla_xol_rec (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_line_cd       gicl_claims.line_cd%TYPE,
      p_currency_cd   gicl_advice.currency_cd%TYPE
   --p_adv_fla_id    gicl_advs_fla.adv_fla_id%TYPE
   )
      RETURN pla_xol_tab PIPELINED AS
      vrep            pla_xol_type;
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
      v_resdist       VARCHAR2 (2000);
      v_rdistamt      VARCHAR2 (2000);
      v_xolrdist      VARCHAR2 (2000);
      v_xolrdistamt   NUMBER;
      v_curr_name     VARCHAR2 (10);
   BEGIN
      --get adv_fla_id
      FOR i IN (SELECT   a.share_type, grp_seq_no,
                           NVL (shr_loss_res_amt, 0)
                         + NVL (shr_exp_res_amt, 0) amt,
                         UPPER (trty_name) trty_name
                    FROM gicl_reserve_ds a, giis_dist_share b
                   WHERE a.share_type = b.share_type
                     AND a.grp_seq_no = b.share_cd
                     AND claim_id = p_claim_id
                     AND b.line_cd = p_line_cd
                     AND a.share_type = 4
                     AND NVL (a.negate_tag, 'N') = 'N'
                ORDER BY 1, grp_seq_no)
      LOOP
         FOR rec IN (SELECT short_name
                       FROM giis_currency
                      WHERE main_currency_cd = p_currency_cd)
         LOOP
            v_curr_name := rec.short_name;
         END LOOP;

         vrep.wrd_s3 := v_curr_name;

         IF i.share_type = 4
         THEN                                                           -- XOL
            v_xolrdist := i.trty_name;                    --'EXCESS OF LOSS';
            v_xolrdistamt := i.amt;
         END IF;

         vrep.wrd_xol_amt := v_xolrdistamt;
         vrep.wrd_xol_desc := INITCAP (NVL (v_xolrdist, '-'));
         PIPE ROW (vrep);
      END LOOP;
   END get_pla_xol_rec;

   FUNCTION get_pla_xol_dist (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_line_cd       gicl_claims.line_cd%TYPE,
      p_currency_cd   gicl_advice.currency_cd%TYPE,
      p_res_pla_id    gicl_reserve_rids.res_pla_id%TYPE
   )
      RETURN pla_xol_dist_tab PIPELINED AS
      vrep           pla_xol_dist_type;
      v_adv_fla_id   gicl_advs_fla.adv_fla_id%TYPE;
      v_clm_dist     VARCHAR2 (2000)                 := NULL;
      v_dist_amt     NUMBER                          := NULL;
      v_sname2       VARCHAR2 (32767);                           --claim dist
      v_short_name   VARCHAR2 (32767);
      v_resdist      VARCHAR2 (2000)                 := NULL;
      v_rdistamt     NUMBER                          := 0;
      v_rdistpct     NUMBER                          := 0;
      v_net_ret      NUMBER                          := 0;
      v_amt          NUMBER                          := 0;
      v_resamt       NUMBER                          := 0;
      v_lossres      NUMBER                          := 0;
      v_expres       NUMBER                          := 0;
      v_xol_ret      NUMBER                          := 0;
   --v_xolrDist
   BEGIN
      FOR i IN (SELECT   NVL (loss_reserve, 0)
                       + NVL (expense_reserve, 0) reserve,
                       NVL (loss_reserve, 0) loss,
                       NVL (expense_reserve, 0) EXP
                  FROM gicl_clm_res_hist a
                 WHERE claim_id = p_claim_id
                   AND NVL (dist_sw, 'N') = 'Y'
                   AND EXISTS (
                          SELECT 1
                            FROM gicl_reserve_rids
                           WHERE claim_id = a.claim_id
                             AND clm_res_hist_id = a.clm_res_hist_id
                             AND res_pla_id = p_res_pla_id))
      LOOP
         v_amt := i.reserve;
         v_resamt := i.reserve;
         v_lossres := i.loss;
         v_expres := i.EXP;
      END LOOP;

      FOR i IN (SELECT a.share_type, grp_seq_no,
                         NVL (shr_loss_res_amt, 0)
                       + NVL (shr_exp_res_amt, 0) amt,
                       UPPER (trty_name) trty_name
                  FROM gicl_reserve_ds a, giis_dist_share b
                 WHERE a.share_type = b.share_type
                   AND a.grp_seq_no = b.share_cd
                   AND claim_id = p_claim_id
                   AND b.line_cd = p_line_cd
                   AND NVL (a.negate_tag, 'N') = 'N'
				   )
      LOOP
         IF i.share_type = 1
         THEN                                                       --NET RET
            v_resdist := 'Ultimate Net Loss';
            v_rdistamt := i.amt;
         ELSIF i.share_type IN (2, 3)
         THEN                                                     -- FACUL/TRY
            FOR x IN (SELECT DECODE (share_type,
                                     2, trty_name,
                                     3, 'Facultative'
                                    ) trty_name
                        FROM giis_dist_share
                       WHERE line_cd = p_line_cd AND share_cd = i.grp_seq_no)
            LOOP
               IF v_resdist IS NOT NULL
               THEN
                  v_resdist := x.trty_name;
                  v_rdistamt := i.amt;
               ELSE
                  v_resdist := x.trty_name;
                  v_rdistamt := i.amt;
               END IF;
            END LOOP;
         END IF;

         FOR d IN (SELECT   b.layer_no, a.share_type, grp_seq_no,
                            UPPER (trty_name) trty_name,
                            xol_base_amount undr_limit
                       FROM gicl_reserve_ds a, giis_dist_share b
                      WHERE a.share_type = b.share_type
                        AND a.grp_seq_no = b.share_cd
                        AND claim_id = p_claim_id
                        AND b.line_cd = p_line_cd
                        AND a.share_type = 4
                        AND a.share_type = i.share_type
                        AND NVL (a.negate_tag, 'N') = 'N'
                        AND b.layer_no =
                               (SELECT MAX (b.layer_no)
                                  FROM gicl_reserve_ds a, giis_dist_share b
                                 WHERE a.share_type = b.share_type
                                   AND a.grp_seq_no = b.share_cd
                                   AND claim_id = p_claim_id
                                   AND b.line_cd = p_line_cd
                                   AND a.share_type = 4
                                   AND NVL (a.negate_tag, 'N') = 'N')
                   ORDER BY 1 DESC)
         LOOP
            IF v_resdist IS NULL
            THEN
               v_resdist := 'Underlying Limit';
               v_rdistamt := d.undr_limit;
            ELSE
               v_resdist := 'Underlying Limit';
               v_rdistamt := d.undr_limit;
            END IF;
         END LOOP;
		 vrep.Wrd_dist_amt2 :=v_rdistamt;
         vrep.wrd_trty2 := v_resdist;
         PIPE ROW (vrep);
      END LOOP;
   END get_pla_xol_dist;

   FUNCTION get_pla_xol_dist2 (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_line_cd       gicl_claims.line_cd%TYPE,
      p_currency_cd   gicl_advice.currency_cd%TYPE,
      p_pla_id        gicl_advs_pla.pla_id%TYPE,
      p_tsi_amt       NUMBER,
      p_res_pla_id    gicl_advs_pla.res_pla_id%TYPE
   )
      RETURN pla_xol_dist_tab PIPELINED AS
      vrep            pla_xol_dist_type;
      v_short_name    VARCHAR2 (32767);
      v_tsi_dist      VARCHAR2 (2000)   := NULL;
      v_sum_res       NUMBER            := 0;                --total loss amt
      v_loss_res      NUMBER;
      v_exp_res       NUMBER;
      v_tmp           NUMBER            := 0;
      v_net_ret       NUMBER            := 0;
      v_dist          VARCHAR2 (2000);
      v_distamt       VARCHAR2 (2000);
      v_resdist       VARCHAR2 (2000)   := NULL;
      v_xol_ret       NUMBER            := 0;
      v_sum_ret_pct   NUMBER            := 0;
      v_amt           NUMBER            := 1;
      v_tsi_ret       NUMBER            := 0;
      v_tsi           VARCHAR2 (30)     := NULL;
      v_resamt        VARCHAR2 (25)     := NULL;
   BEGIN
      DBMS_OUTPUT.put_line (   'v_amt: '
                            || v_amt
                            || '  p_res_pla_id: '
                            || p_res_pla_id
                           );

      FOR i IN (SELECT   NVL (loss_reserve, 0)
                       + NVL (expense_reserve, 0) reserve,
                       NVL (loss_reserve, 0) loss,
                       NVL (expense_reserve, 0) EXP
                  FROM gicl_clm_res_hist a
                 WHERE claim_id = p_claim_id
                   AND NVL (dist_sw, 'N') = 'Y'
                   AND EXISTS (
                          SELECT 1
                            FROM gicl_reserve_rids
                           WHERE claim_id = a.claim_id
                             AND clm_res_hist_id = a.clm_res_hist_id
                             AND res_pla_id = p_res_pla_id))
      LOOP
         v_amt := i.reserve;
         DBMS_OUTPUT.put_line ('v_amt: ' || v_amt);
         v_resamt := TO_CHAR (i.reserve, 'fm999,999,999,999,990.90');
      END LOOP;

      v_resamt := NVL (v_resamt, '0.00');

      FOR j IN (SELECT   a.share_type, grp_seq_no,

                             --NVL (shr_loss_res_amt, 0)
                           --+ NVL (shr_exp_res_amt, 0) amt,
                           NVL (SUM (shr_loss_res_amt), 0)
                         + NVL (SUM (shr_exp_res_amt), 0) amt,
                         UPPER (trty_name) trty_name
                    FROM gicl_reserve_ds a, giis_dist_share b
                   WHERE a.share_type = b.share_type
                     AND a.grp_seq_no = b.share_cd
                     AND claim_id = p_claim_id
                     AND b.line_cd = p_line_cd
                     AND NVL (a.negate_tag, 'N') = 'N'
                     AND a.share_type IN (1, 4)
                GROUP BY a.share_type, a.grp_seq_no, UPPER (trty_name))
      LOOP
         v_net_ret := v_net_ret + NVL (j.amt, 0);
      END LOOP;

      v_sum_ret_pct := (v_net_ret / v_amt) * 100;
      DBMS_OUTPUT.put_line ('v_net_ret: ' || v_net_ret);

      --distribution treaty 1
      IF NVL (v_net_ret, 0) != 0
      THEN
         v_tsi_ret := p_tsi_amt * (v_sum_ret_pct / 100);
         v_dist := 'Retention';
         --v_cln1       := ':';
         --v_c1         := v_cur;
         v_distamt := LTRIM (TO_CHAR (v_tsi_ret, '999,999,999,999,999.90'));
         v_tmp := 1;
         vrep.wrd_trty1 := INITCAP (NVL (v_dist, '-'));
         vrep.wrd_dist_amt1 := v_net_ret;
         PIPE ROW (vrep);
      END IF;

      FOR i IN (SELECT     SUM (NVL (a.shr_loss_res_amt, 0))
                         + SUM (NVL (a.shr_exp_res_amt, 0)) amt,
                         a.shr_pct, a.grp_seq_no,
                         DECODE (d.trty_name,
                                 'QS', 'TREATY',
                                 d.trty_name
                                ) trty_name
                    FROM gicl_reserve_ds a, giis_dist_share d
                   WHERE 1 = 1
                     AND a.line_cd = d.line_cd
                     AND a.grp_seq_no = d.share_cd
                     AND a.share_type NOT IN (1, 4)
                     AND NVL (a.negate_tag, 'N') = 'N'
                     AND EXISTS (
                            SELECT '1'
                              FROM gicl_advs_pla c
                             WHERE c.claim_id = a.claim_id
                               AND c.pla_id = p_pla_id)
                GROUP BY a.grp_seq_no, d.trty_name, a.shr_pct)
      LOOP
         IF NVL (i.amt, 0) != 0 AND v_tmp = 1
         THEN
            v_dist := i.trty_name;
            v_distamt :=
               LTRIM (TO_CHAR (p_tsi_amt * (i.shr_pct / 100),
                               '999,999,999,999,999.90'
                              )
                     );
         ELSIF NVL (i.amt, 0) != 0 AND v_tmp = 0
         THEN
            v_dist := i.trty_name;
            v_distamt :=
               LTRIM (TO_CHAR (p_tsi_amt * (i.shr_pct / 100),
                               'fm999,999,999,999,990.90'
                              )
                     );
            v_tmp := 1;
         END IF;

         vrep.wrd_trty1 := INITCAP (NVL (v_dist, '-'));
         vrep.wrd_dist_amt1 := v_distamt;
         PIPE ROW (vrep);
      END LOOP;
   END get_pla_xol_dist2;
END;
/


