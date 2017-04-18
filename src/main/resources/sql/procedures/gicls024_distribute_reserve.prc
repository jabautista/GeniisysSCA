CREATE OR REPLACE PROCEDURE     "GICLS024_DISTRIBUTE_RESERVE" (
   p_claim_id            gicl_claims.claim_id%TYPE,
   p_clm_res_hist_id     gicl_clm_res_hist.clm_res_hist_id%TYPE,
   p_item_no             gicl_item_peril.item_no%TYPE,
   p_peril_cd            gicl_item_peril.peril_cd%TYPE,
   p_grouped_item_no     gicl_item_peril.grouped_item_no%TYPE,
   p_distribution_date   gicl_clm_res_hist.distribution_date%TYPE
)
IS
   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 09.26.2012
   **  Reference By  : (GICLS024 - Claim Reserve)
   **  Description   : Converted procedure from GICLS024 - distribute reserve program unit
   */

   --Cursor for item/peril loss amount
   CURSOR cur_clm_res
   IS
      SELECT        claim_id, clm_res_hist_id, hist_seq_no, item_no,
                    peril_cd, loss_reserve, expense_reserve, convert_rate,
                    grouped_item_no                   --added by gmi 02/23/06
               FROM gicl_clm_res_hist
              WHERE claim_id = p_claim_id
                AND clm_res_hist_id = p_clm_res_hist_id
      FOR UPDATE OF dist_sw;

--Cursor for peril distribution in underwriting table.
   CURSOR cur_perilds (
      v_peril_cd       giri_ri_dist_item_v.peril_cd%TYPE,
      v_item_no        giri_ri_dist_item_v.item_no%TYPE,
      p_pol_eff_date   gicl_claims.pol_eff_date%TYPE,
      p_loss_date      gicl_claims.loss_date%TYPE,
      p_expiry_date    gicl_claims.expiry_date%TYPE,
      p_line_cd        gicl_claims.line_cd%TYPE,
      p_subline_cd     gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd     gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy       gicl_claims.issue_yy%TYPE,
      p_pol_seq_no     gicl_claims.pol_seq_no%TYPE,
      p_renew_no       gicl_claims.renew_no%TYPE
   )
   IS
      SELECT   d.share_cd, f.share_type, f.trty_yy, f.prtfolio_sw,
               f.acct_trty_type, SUM (d.dist_tsi) ann_dist_tsi, f.expiry_date
          FROM gipi_polbasic a,
               gipi_item b,
               giuw_pol_dist c,
               giuw_itemperilds_dtl d,
               giis_dist_share f,
               giis_parameters e,
               giis_subline g             --added GIIS_SUBLINE Halley 09.20.13
         WHERE f.share_cd = d.share_cd
           AND f.line_cd = d.line_cd
           AND d.peril_cd = v_peril_cd
           AND d.item_no = v_item_no
           AND d.item_no = b.item_no
           AND d.dist_no = c.dist_no
           AND e.param_type = 'V'
           AND c.dist_flag = e.param_value_v
           AND e.param_name = 'DISTRIBUTED'
           AND c.policy_id = b.policy_id
           AND TO_DATE
                  (CONCAT
                      (TO_CHAR (TRUNC (DECODE (TRUNC (c.eff_date),
                                               TRUNC (a.eff_date), DECODE
                                                        (TRUNC (a.eff_date),
                                                         TRUNC (a.incept_date), p_pol_eff_date,
                                                         a.eff_date
                                                        ),
                                               c.eff_date
                                              )
                                      ),
                                'MM/DD/YYYY'
                               ),
                       SUBSTR (TO_CHAR (TO_DATE (g.subline_time, 'SSSSS'),
                                        ' MM/DD/YYYY HH:MI AM'
                                       ),
                                 INSTR (TO_CHAR (TO_DATE (g.subline_time,
                                                          'SSSSS'
                                                         ),
                                                 'MM/DD/YYYY HH:MM AM'
                                                ),
                                        '/',
                                        1,
                                        2
                                       )
                               + 6
                              )
                      ),
                   'MM/DD/YYYY HH:MI AM'
                  ) <= p_loss_date                  --added by Halley 09.20.13
           AND TO_DATE
                  (CONCAT
                      (TO_CHAR
                           (TRUNC (DECODE (TRUNC (c.expiry_date),
                                           TRUNC (a.expiry_date), DECODE
                                                    (NVL (a.endt_expiry_date,
                                                          a.expiry_date
                                                         ),
                                                     a.expiry_date, p_expiry_date,
                                                     a.endt_expiry_date
                                                    ),
                                           c.expiry_date
                                          )
                                  ),
                            'MM/DD/YYYY'
                           ),
                       SUBSTR (TO_CHAR (TO_DATE (g.subline_time, 'SSSSS'),
                                        ' MM/DD/YYYY HH:MI AM'
                                       ),
                                 INSTR (TO_CHAR (TO_DATE (g.subline_time,
                                                          'SSSSS'
                                                         ),
                                                 'MM/DD/YYYY HH:MM AM'
                                                ),
                                        '/',
                                        1,
                                        2
                                       )
                               + 6
                              )
                      ),
                   'MM/DD/YYYY HH:MI AM'
                  ) >= p_loss_date                  --added by Halley 09.20.13
    /*AND TRUNC(DECODE(TRUNC(c.eff_date),TRUNC(a.eff_date),
          DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_pol_eff_date, a.eff_date ),c.eff_date))
          <= p_loss_date
      AND TRUNC(DECODE(TRUNC(c.expiry_date),TRUNC(a.expiry_date),DECODE(NVL(a.endt_expiry_date, a.expiry_date),
          a.expiry_date, p_expiry_date, a.endt_expiry_date), c.expiry_date))
          >= p_loss_date */  --commented by Halley 09.20.13
--      AND trunc(c.eff_date) <= trunc(:cg$ctrl.loss_date)
--      AND trunc(a.expiry_date) >= trunc(:cg$ctrl.loss_date)
           AND b.policy_id = a.policy_id
           AND a.pol_flag IN ('1', '2', '3', '4', 'X') --kenneth SR4855 100715
           AND a.line_cd = p_line_cd
           AND a.subline_cd = p_subline_cd
           AND a.iss_cd = p_pol_iss_cd
           AND a.issue_yy = p_issue_yy
           AND a.pol_seq_no = p_pol_seq_no
           AND a.renew_no = p_renew_no
           AND a.line_cd = g.line_cd
           AND a.subline_cd = g.subline_cd
      GROUP BY a.line_cd,
               a.subline_cd,
               a.iss_cd,
               a.issue_yy,
               a.pol_seq_no,
               a.renew_no,
               d.share_cd,
               f.share_type,
               f.trty_yy,
               f.acct_trty_type,
               d.item_no,
               d.peril_cd,
               f.prtfolio_sw,
               f.expiry_date;

--Cursor for peril distribution in treaty table.
   CURSOR cur_trty (
      v_share_cd   giis_dist_share.share_cd%TYPE,
      v_trty_yy    giis_dist_share.trty_yy%TYPE,
      p_line_cd    gicl_claims.line_cd%TYPE
   )
   IS
      SELECT ri_cd, trty_shr_pct, prnt_ri_cd
        FROM giis_trty_panel
       WHERE line_cd = p_line_cd
         AND trty_yy = v_trty_yy
         AND trty_seq_no = v_share_cd;

--Cursor for peril distribution in ri table.
   CURSOR cur_frperil (
      v_peril_cd       giri_ri_dist_item_v.peril_cd%TYPE,
      v_item_no        giri_ri_dist_item_v.item_no%TYPE,
      p_expiry_date    gicl_claims.expiry_date%TYPE,
      p_loss_date      gicl_claims.loss_date%TYPE,
      p_pol_eff_date   gicl_claims.pol_eff_date%TYPE,
      p_issue_yy       gicl_claims.issue_yy%TYPE,
      p_pol_seq_no     gicl_claims.pol_seq_no%TYPE,
      p_renew_no       gicl_claims.renew_no%TYPE,
      p_line_cd        gicl_claims.line_cd%TYPE,
      p_subline_cd     gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd     gicl_claims.pol_iss_cd%TYPE
   )
   IS
      SELECT   t2.ri_cd, fnl_binder_id,
               SUM (NVL ((t2.ri_shr_pct / 100) * t8.tsi_amt, 0)
                   ) sum_ri_tsi_amt
          FROM gipi_polbasic t5,
               gipi_itmperil t8,
               giuw_pol_dist t4,
               giuw_itemperilds t6,
               giri_distfrps t3,
               giri_frps_ri t2,
               giis_subline t9            --added GIIS_SUBLINE Halley 09.20.13
         WHERE 1 = 1
           AND t5.line_cd = p_line_cd
           AND t5.subline_cd = p_subline_cd
           AND t5.iss_cd = p_pol_iss_cd
           AND t5.issue_yy = p_issue_yy
           AND t5.pol_seq_no = p_pol_seq_no
           AND t5.renew_no = p_renew_no
           AND t5.pol_flag IN
                             ('1', '2', '3', '4', 'X') --kenneth SR4855 100715
           AND t5.policy_id = t8.policy_id
           AND t8.peril_cd = v_peril_cd
           AND t8.item_no = v_item_no
           AND t5.policy_id = t4.policy_id
           AND t5.line_cd = t9.line_cd
           AND t5.subline_cd = t9.subline_cd
           AND TO_DATE
                  (CONCAT
                      (TO_CHAR
                              (TRUNC (DECODE (TRUNC (t4.eff_date),
                                              TRUNC (t5.eff_date), DECODE
                                                       (TRUNC (t5.eff_date),
                                                        TRUNC (t5.incept_date), p_pol_eff_date,
                                                        t5.eff_date
                                                       ),
                                              t4.eff_date
                                             )
                                     ),
                               'MM/DD/YYYY'
                              ),
                       SUBSTR (TO_CHAR (TO_DATE (t9.subline_time, 'SSSSS'),
                                        ' MM/DD/YYYY HH:MI AM'
                                       ),
                                 INSTR (TO_CHAR (TO_DATE (t9.subline_time,
                                                          'SSSSS'
                                                         ),
                                                 'MM/DD/YYYY HH:MM AM'
                                                ),
                                        '/',
                                        1,
                                        2
                                       )
                               + 6
                              )
                      ),
                   'MM/DD/YYYY HH:MI AM'
                  ) <= p_loss_date                  --added by Halley 09.20.13
           AND TO_DATE
                  (CONCAT
                      (TO_CHAR
                          (TRUNC (DECODE (TRUNC (t4.expiry_date),
                                          TRUNC (t5.expiry_date), DECODE
                                                   (NVL (t5.endt_expiry_date,
                                                         t5.expiry_date
                                                        ),
                                                    t5.expiry_date, p_expiry_date,
                                                    t5.endt_expiry_date
                                                   ),
                                          t4.expiry_date
                                         )
                                 ),
                           'MM/DD/YYYY'
                          ),
                       SUBSTR (TO_CHAR (TO_DATE (t9.subline_time, 'SSSSS'),
                                        ' MM/DD/YYYY HH:MI AM'
                                       ),
                                 INSTR (TO_CHAR (TO_DATE (t9.subline_time,
                                                          'SSSSS'
                                                         ),
                                                 'MM/DD/YYYY HH:MM AM'
                                                ),
                                        '/',
                                        1,
                                        2
                                       )
                               + 6
                              )
                      ),
                   'MM/DD/YYYY HH:MI AM'
                  ) >= p_loss_date                  --added by Halley 09.20.13
           /*AND trunc(DECODE(TRUNC(t4.eff_date),TRUNC(t5.eff_date),
               DECODE(TRUNC(t5.eff_date),TRUNC(t5.incept_date), p_pol_eff_date, t5.eff_date ),t4.eff_date))
               <= p_loss_date
           AND TRUNC(DECODE(TRUNC(t4.expiry_date),TRUNC(t5.expiry_date),
               DECODE(NVL(t5.endt_expiry_date, t5.expiry_date),
               t5.expiry_date,p_expiry_date,t5.endt_expiry_date),t4.expiry_date))
               >= p_loss_date  */   --commented by Halley 09.20.13
           AND t4.dist_flag = '3'
           AND t4.dist_no = t6.dist_no
           AND t8.item_no = t6.item_no
           AND t8.peril_cd = t6.peril_cd
           AND t4.dist_no = t3.dist_no
           AND t6.dist_seq_no = t3.dist_seq_no
           AND t3.line_cd = t2.line_cd
           AND t3.frps_yy = t2.frps_yy
           AND t3.frps_seq_no = t2.frps_seq_no
           AND NVL (t2.reverse_sw, 'N') = 'N'
           AND NVL (t2.delete_sw, 'N') = 'N'
           AND t3.ri_flag = '2'
           --check if peril has facultative in distribution before including peril by MAC 09/25/2013
           AND EXISTS (
                  SELECT 1
                    FROM giuw_itemperilds_dtl x
                   WHERE x.dist_no = t6.dist_no
                     AND x.dist_seq_no = t6.dist_seq_no
                     AND x.item_no = t6.item_no
                     AND x.peril_cd = t6.peril_cd
                     AND x.line_cd = t6.line_cd
                     AND x.share_cd = 999)
      GROUP BY t2.ri_cd, fnl_binder_id
      ORDER BY t2.ri_cd, fnl_binder_id;
                                    --Edison 11.12.2012 -- bonok :: 12.05.2012

   sum_tsi_amt          giri_basic_info_item_sum_v.tsi_amt%TYPE;
   ann_ri_pct           NUMBER (12, 9);
   ann_dist_spct        gicl_reserve_ds.shr_pct%TYPE              := 0;
   me                   NUMBER                                    := 0;
   v_facul_share_cd     giuw_perilds_dtl.share_cd%TYPE;
   v_trty_share_type    giis_dist_share.share_type%TYPE;
   v_facul_share_type   giis_dist_share.share_type%TYPE;
   v_loss_res_amt       gicl_reserve_ds.shr_loss_res_amt%TYPE;
   v_exp_res_amt        gicl_reserve_ds.shr_exp_res_amt%TYPE;
   v_trty_limit         giis_dist_share.trty_limit%TYPE;
   v_facul_amt          gicl_reserve_ds.shr_loss_res_amt%TYPE;
   v_net_amt            gicl_reserve_ds.shr_loss_res_amt%TYPE;
   v_treaty_amt         gicl_reserve_ds.shr_loss_res_amt%TYPE;
   v_qs_shr_pct         giis_dist_share.qs_shr_pct%TYPE;
   v_acct_trty_type     giis_dist_share.acct_trty_type%TYPE;
   v_share_cd           giis_dist_share.share_cd%TYPE;
   v_policy             VARCHAR2 (2000);
   counter              NUMBER                                    := 0;
   v_switch             NUMBER                                    := 0;
   v_policy_id          NUMBER;
   v_clm_dist_no        NUMBER                                    := 0;
   v_peril_sname        giis_peril.peril_sname%TYPE;
   v_trty_peril         giis_peril.peril_sname%TYPE;
--switch to determine if shate_cd is already existing
   v_share_exist        VARCHAR2 (1);
   var_clm_dist_no      NUMBER                                    := 0;
   v_pol_eff_date       gicl_claims.pol_eff_date%TYPE;
   v_loss_date          gicl_claims.loss_date%TYPE;
   v_expiry_date        gicl_claims.expiry_date%TYPE;
   v_line_cd            gicl_claims.line_cd%TYPE;
   v_subline_cd         gicl_claims.subline_cd%TYPE;
   v_pol_iss_cd         gicl_claims.pol_iss_cd%TYPE;
   v_issue_yy           gicl_claims.issue_yy%TYPE;
   v_pol_seq_no         gicl_claims.pol_seq_no%TYPE;
   v_renew_no           gicl_claims.renew_no%TYPE;
   v_catastrophic_cd    gicl_claims.catastrophic_cd%TYPE;
   v_message            VARCHAR2 (500);
   --jen.110706
   v_max_hist_seq_no    gicl_clm_res_hist.hist_seq_no%TYPE;
   v_clm_res_hist_id    gicl_clm_res_hist.clm_res_hist_id%TYPE;
   v_ri_tsi_amt         gipi_itmperil.tsi_amt%TYPE                := 0;
                                    --Edison 11.09.2012 -- bonok :: 12.05.2012
   v_checking           VARCHAR2 (1);
                                    --Edison 11.08.2012 -- bonok :: 12.05.2012
   v_ri_cd              giri_frps_ri.ri_cd%TYPE;
                                    --Edison 11.12.2012 -- bonok :: 12.05.2012
BEGIN
   FOR gc IN (SELECT *
                FROM gicl_claims
               WHERE claim_id = p_claim_id)
   LOOP
      v_pol_eff_date := gc.pol_eff_date;
      v_loss_date := gc.loss_date;
      v_expiry_date := gc.expiry_date;
      v_line_cd := gc.line_cd;
      v_subline_cd := gc.subline_cd;
      v_pol_iss_cd := gc.pol_iss_cd;
      v_issue_yy := gc.issue_yy;
      v_pol_seq_no := gc.pol_seq_no;
      v_renew_no := gc.renew_no;
   END LOOP;

   --get max hist_seq_no to get the clm_res_hist_id
   SELECT MAX (hist_seq_no)
     INTO v_max_hist_seq_no
     FROM gicl_clm_res_hist
    WHERE claim_id = p_claim_id
      AND item_no = p_item_no
      AND peril_cd = p_peril_cd
      AND grouped_item_no = NVL (p_grouped_item_no, 0);

   SELECT clm_res_hist_id
     INTO v_clm_res_hist_id
     FROM gicl_clm_res_hist
    WHERE claim_id = p_claim_id
      AND item_no = p_item_no
      AND peril_cd = p_peril_cd
      AND grouped_item_no = NVL (p_grouped_item_no, 0)
      AND hist_seq_no = v_max_hist_seq_no;

   BEGIN
      SELECT MAX (clm_dist_no)
        INTO var_clm_dist_no
        FROM gicl_reserve_ds
       WHERE claim_id = p_claim_id AND clm_res_hist_id = v_clm_res_hist_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         var_clm_dist_no := 0;
   END;

   var_clm_dist_no := NVL (var_clm_dist_no, 0) + 1;
   v_clm_dist_no := var_clm_dist_no;

   FOR c1 IN cur_clm_res
   LOOP                                           /*Using Item-peril cursor */
      BEGIN
         SELECT param_value_n
           INTO v_facul_share_cd
           FROM giis_parameters
          WHERE param_name = 'FACULTATIVE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
               (-20001,
                'There is no existing FACULTATIVE parameter in GIIS_PARAMETERS table.'
               );
      END;

      BEGIN
         SELECT param_value_v
           INTO v_trty_share_type
           FROM giac_parameters
          WHERE param_name = 'TRTY_SHARE_TYPE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
               (-20002,
                'There is no existing TRTY_SHARE_TYPE parameter in GIAC_PARAMETERS table.'
               );
      END;

      BEGIN
         SELECT param_value_v
           INTO v_facul_share_type
           FROM giac_parameters
          WHERE param_name = 'FACUL_SHARE_TYPE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
               (-20003,
                'There is no existing FACUL_SHARE_TYPE parameter in GIAC_PARAMETERS table.'
               );
      END;

      BEGIN
         SELECT param_value_n
           INTO v_acct_trty_type
           FROM giac_parameters
          WHERE param_name = 'QS_ACCT_TRTY_TYPE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error
               (-20004,
                'There is no existing QS_ACCT_TRTY_TYPE parameter in GIAC_PARAMETERS table.'
               );
      END;

      BEGIN
         SELECT SUM (a.tsi_amt)
           INTO sum_tsi_amt
           FROM giri_basic_info_item_sum_v a,
                giuw_pol_dist b,
                giis_subline c            --added GIIS_SUBLINE Halley 09.20.13
          WHERE a.policy_id = b.policy_id
            AND a.line_cd = c.line_cd
            AND a.subline_cd = c.subline_cd
            --AND trunc(a.eff_date) <= trunc(:control.loss_date)
            --AND trunc(a.expiry_date) >= trunc(:control.loss_date)
             /*AND trunc(DECODE(TRUNC(b.eff_date),TRUNC(a.eff_date),
                 DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), v_pol_eff_date, a.eff_date ),b.eff_date))
                 <= v_loss_date
             AND TRUNC(DECODE(TRUNC(b.expiry_date),TRUNC(a.expiry_date),
                 DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                 a.expiry_date,v_expiry_date,a.endt_expiry_date ),b.expiry_date))
                 >= v_loss_date */  --commented by Halley 09.20.13
            AND TO_DATE
                   (CONCAT
                       (TO_CHAR
                               (TRUNC (DECODE (TRUNC (b.eff_date),
                                               TRUNC (a.eff_date), DECODE
                                                        (TRUNC (a.eff_date),
                                                         TRUNC (a.incept_date), v_pol_eff_date,
                                                         a.eff_date
                                                        ),
                                               b.eff_date
                                              )
                                      ),
                                'MM/DD/YYYY'
                               ),
                        SUBSTR (TO_CHAR (TO_DATE (c.subline_time, 'SSSSS'),
                                         ' MM/DD/YYYY HH:MI AM'
                                        ),
                                  INSTR (TO_CHAR (TO_DATE (c.subline_time,
                                                           'SSSSS'
                                                          ),
                                                  'MM/DD/YYYY HH:MM AM'
                                                 ),
                                         '/',
                                         1,
                                         2
                                        )
                                + 6
                               )
                       ),
                    'MM/DD/YYYY HH:MI AM'
                   ) <= v_loss_date                 --added by Halley 09.20.13
            AND TO_DATE
                   (CONCAT
                       (TO_CHAR
                           (TRUNC (DECODE (TRUNC (b.expiry_date),
                                           TRUNC (a.expiry_date), DECODE
                                                    (NVL (a.endt_expiry_date,
                                                          a.expiry_date
                                                         ),
                                                     a.expiry_date, v_expiry_date,
                                                     a.endt_expiry_date
                                                    ),
                                           b.expiry_date
                                          )
                                  ),
                            'MM/DD/YYYY'
                           ),
                        SUBSTR (TO_CHAR (TO_DATE (c.subline_time, 'SSSSS'),
                                         ' MM/DD/YYYY HH:MI AM'
                                        ),
                                  INSTR (TO_CHAR (TO_DATE (c.subline_time,
                                                           'SSSSS'
                                                          ),
                                                  'MM/DD/YYYY HH:MM AM'
                                                 ),
                                         '/',
                                         1,
                                         2
                                        )
                                + 6
                               )
                       ),
                    'MM/DD/YYYY HH:MI AM'
                   ) >= v_loss_date                 --added by Halley 09.20.13
            AND a.item_no = c1.item_no
            AND a.peril_cd = c1.peril_cd
            AND a.line_cd = v_line_cd
            AND a.subline_cd = v_subline_cd
            AND a.iss_cd = v_pol_iss_cd
            AND a.issue_yy = v_issue_yy
            AND a.pol_seq_no = v_pol_seq_no
            AND a.renew_no = v_renew_no
            AND b.dist_flag = (SELECT param_value_v
                                 FROM giis_parameters
                                WHERE param_name = 'DISTRIBUTED');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20005,
                                     'The TSI for this policy is Zero...'
                                    );
      END;

      DECLARE
         CURSOR quota_share_treaties
         IS
            SELECT trty_limit, qs_shr_pct, share_cd
              FROM giis_dist_share
             WHERE line_cd = v_line_cd
               AND eff_date <= NVL (p_distribution_date, SYSDATE)
               AND expiry_date >= NVL (p_distribution_date, SYSDATE)
               AND acct_trty_type = v_acct_trty_type
               AND qs_shr_pct IS NOT NULL;
      BEGIN
         FOR quota_share_rec IN quota_share_treaties
         LOOP
            BEGIN
               SELECT quota_share_rec.trty_limit,
                      quota_share_rec.qs_shr_pct, quota_share_rec.share_cd
                 INTO v_trty_limit,
                      v_qs_shr_pct, v_share_cd
                 FROM DUAL;
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         END LOOP;
      END;

      FOR me IN cur_perilds (c1.peril_cd,
                             c1.item_no,
                             v_pol_eff_date,
                             v_loss_date,
                             v_expiry_date,
                             v_line_cd,
                             v_subline_cd,
                             v_pol_iss_cd,
                             v_issue_yy,
                             v_pol_seq_no,
                             v_renew_no
                            )
      LOOP
         IF me.acct_trty_type = v_acct_trty_type
         THEN
            v_switch := 1;
         ELSIF     (   (me.acct_trty_type = v_acct_trty_type)
                    OR (me.acct_trty_type IS NULL)
                   )
               AND (v_switch <> 1)
         THEN
            v_switch := 0;
         END IF;
      END LOOP;

      BEGIN
         SELECT peril_sname
           INTO v_peril_sname
           FROM giis_peril
          WHERE peril_cd = c1.peril_cd AND line_cd = v_line_cd;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_trty_peril
           FROM giac_parameters
          WHERE param_name = 'TRTY_PERIL';
      END;

      IF v_peril_sname = v_trty_peril
      THEN
         SELECT param_value_n
           INTO v_trty_limit
           FROM giac_parameters
          WHERE param_name = 'TRTY_PERIL_LIMIT';
      END IF;

      IF sum_tsi_amt > v_trty_limit
      THEN
         FOR i IN cur_perilds (c1.peril_cd,
                               c1.item_no,
                               v_pol_eff_date,
                               v_loss_date,
                               v_expiry_date,
                               v_line_cd,
                               v_subline_cd,
                               v_pol_iss_cd,
                               v_issue_yy,
                               v_pol_seq_no,
                               v_renew_no
                              )
         LOOP
            IF i.share_type = v_facul_share_type
            THEN
               v_facul_amt := sum_tsi_amt * (i.ann_dist_tsi / sum_tsi_amt);
            END IF;
         END LOOP;

         v_net_amt :=
              (sum_tsi_amt - NVL (v_facul_amt, 0))
            * ((100 - v_qs_shr_pct) / 100);
         v_treaty_amt :=
                     (sum_tsi_amt - NVL (v_facul_amt, 0))
                   * (v_qs_shr_pct / 100);
      ELSE
         v_net_amt := sum_tsi_amt * ((100 - v_qs_shr_pct) / 100);
         v_treaty_amt := sum_tsi_amt * (v_qs_shr_pct / 100);
      END IF;

      /*Start of distribution - Marge 4-15-2k*/
      /*modified by mon: date modified: apr. 24, 2002
      **description: validates prtfolio_sw before inserting and updating */
      FOR c2 IN cur_perilds (c1.peril_cd,
                             c1.item_no,
                             v_pol_eff_date,
                             v_loss_date,
                             v_expiry_date,
                             v_line_cd,
                             v_subline_cd,
                             v_pol_iss_cd,
                             v_issue_yy,
                             v_pol_seq_no,
                             v_renew_no
                            )
      LOOP                                 /*Underwriting peril distribution*/
         IF c2.share_type = v_trty_share_type
         THEN
            DECLARE
               v_share_cd      giis_dist_share.share_cd%TYPE   := c2.share_cd;
               v_treaty_yy2    giis_dist_share.trty_yy%TYPE     := c2.trty_yy;
               v_prtf_sw       giis_dist_share.prtfolio_sw%TYPE;
               v_acct_trty     giis_dist_share.acct_trty_type%TYPE;
               v_share_type    giis_dist_share.share_type%TYPE;
               v_expiry_date   giis_dist_share.expiry_date%TYPE;
            BEGIN
               IF     NVL (c2.prtfolio_sw, 'N') = 'P'
                  --AND c2.trty_yy <> to_number(TO_CHAR(SYSDATE,'YY')) THEN
                  AND TRUNC (c2.expiry_date) <
                                    TRUNC (NVL (p_distribution_date, SYSDATE))
               THEN
                  --WHILE v_treaty_yy2 <> to_number(TO_CHAR(SYSDATE,'YY'))
                  WHILE TRUNC (c2.expiry_date) <
                                   TRUNC (NVL (p_distribution_date, SYSDATE))
                  LOOP
                     BEGIN
                        SELECT share_cd, trty_yy, NVL (prtfolio_sw, 'N'),
                               acct_trty_type, share_type, expiry_date
                          INTO v_share_cd, v_treaty_yy2, v_prtf_sw,
                               v_acct_trty, v_share_type, v_expiry_date
                          FROM giis_dist_share
                         WHERE line_cd = v_line_cd
                           AND old_trty_seq_no = c2.share_cd;
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           raise_application_error
                                         (-20006,
                                             'No new treaty set-up for year'
                                          || TO_CHAR
                                                   (NVL (p_distribution_date,
                                                         SYSDATE
                                                        ),
                                                    'YYYY'
                                                   )
                                         );
                           EXIT;
                        WHEN TOO_MANY_ROWS
                        THEN
                           raise_application_error
                                        (-20007,
                                            'Too many treaty set-up for year'
                                         || TO_CHAR
                                                   (NVL (p_distribution_date,
                                                         SYSDATE
                                                        ),
                                                    'YYYY'
                                                   )
                                        );
                     END;

                     c2.share_cd := v_share_cd;
                     c2.share_type := v_share_type;
                     c2.acct_trty_type := v_acct_trty;
                     c2.trty_yy := v_treaty_yy2;
                     c2.expiry_date := v_expiry_date;

                     IF v_prtf_sw = 'N'
                     THEN
                        EXIT;
                     END IF;
                  END LOOP;
               END IF;
            END;
         END IF;

         ann_dist_spct := 0;

         IF     (   (c2.acct_trty_type <> v_acct_trty_type)
                 OR (c2.acct_trty_type IS NULL)
                )
            AND v_switch = 0
         THEN
            ann_dist_spct := (c2.ann_dist_tsi / sum_tsi_amt) * 100;
            v_loss_res_amt := c1.loss_reserve * ann_dist_spct / 100;
            v_exp_res_amt := c1.expense_reserve * ann_dist_spct / 100;
         ELSE
            IF     (c2.share_type = v_trty_share_type)
               AND (c2.share_cd = v_share_cd)
            THEN
               ann_dist_spct := (v_treaty_amt / sum_tsi_amt) * 100;
               v_loss_res_amt := c1.loss_reserve * ann_dist_spct / 100;
               v_exp_res_amt := c1.expense_reserve * ann_dist_spct / 100;
            ELSIF     (c2.share_type != v_trty_share_type)
                  AND (c2.share_type != v_facul_share_type)
                  AND (v_net_amt IS NOT NULL)
            THEN
               ann_dist_spct := (v_net_amt / sum_tsi_amt) * 100;
               v_loss_res_amt := c1.loss_reserve * ann_dist_spct / 100;
               v_exp_res_amt := c1.expense_reserve * ann_dist_spct / 100;
            ELSE
               ann_dist_spct := (c2.ann_dist_tsi / sum_tsi_amt) * 100;
               v_loss_res_amt := c1.loss_reserve * ann_dist_spct / 100;
               v_exp_res_amt := c1.expense_reserve * ann_dist_spct / 100;
            END IF;
         END IF;

/*checks if share_cd is already existing if existing updates gicl_reserve_ds
if not existing then inserts record to gicl_reserve_ds*/
         v_share_exist := 'N';

         FOR i IN (SELECT '1'
                     FROM gicl_reserve_ds
                    WHERE claim_id = c1.claim_id
                      AND hist_seq_no = c1.hist_seq_no
                      AND grouped_item_no = c1.grouped_item_no
                      AND item_no = c1.item_no
                      AND peril_cd = c1.peril_cd
                      AND grp_seq_no = c2.share_cd
                      AND line_cd = v_line_cd)
         LOOP
            v_share_exist := 'Y';
         END LOOP;

         IF ann_dist_spct <> 0
         THEN
            IF v_share_exist = 'N'
            THEN
               INSERT INTO gicl_reserve_ds
                           (claim_id, clm_res_hist_id,
                            dist_year,
                            clm_dist_no, item_no, peril_cd,
                            grouped_item_no,           --added by gmi 02/28/06
                                            grp_seq_no, share_type,
                            shr_pct, shr_loss_res_amt, shr_exp_res_amt,
                            line_cd, acct_trty_type,
                            user_id, last_update,
                            hist_seq_no
                           )
                    VALUES (c1.claim_id, c1.clm_res_hist_id,
                            TO_CHAR (NVL (p_distribution_date, SYSDATE),
                                     'YYYY'
                                    ),
                            v_clm_dist_no, c1.item_no, c1.peril_cd,
                            c1.grouped_item_no, c2.share_cd, c2.share_type,
                            ann_dist_spct, v_loss_res_amt, v_exp_res_amt,
                            v_line_cd, c2.acct_trty_type,
                            NVL (giis_users_pkg.app_user, USER), SYSDATE,
                            c1.hist_seq_no
                           );
            ELSE
               UPDATE gicl_reserve_ds
                  SET shr_pct = NVL (shr_pct, 0) + NVL (ann_dist_spct, 0),
                      shr_loss_res_amt =
                            NVL (shr_loss_res_amt, 0)
                            + NVL (v_loss_res_amt, 0),
                      shr_exp_res_amt =
                              NVL (shr_exp_res_amt, 0)
                              + NVL (v_exp_res_amt, 0)
                WHERE claim_id = c1.claim_id
                  AND hist_seq_no = c1.hist_seq_no
                  AND grouped_item_no = c1.grouped_item_no
                  AND item_no = c1.item_no
                  AND peril_cd = c1.peril_cd
                  AND grp_seq_no = c2.share_cd
                  AND line_cd = v_line_cd;
            END IF;

            me := TO_NUMBER (c2.share_type) - TO_NUMBER (v_trty_share_type);

            IF me = 0
            THEN
               FOR c_trty IN cur_trty (c2.share_cd, c2.trty_yy, v_line_cd)
               LOOP
                  IF v_share_exist = 'N'
                  THEN
                     INSERT INTO gicl_reserve_rids
                                 (claim_id, clm_res_hist_id,
                                  dist_year,
                                  clm_dist_no, item_no, peril_cd,
                                  grp_seq_no, share_type,
                                  ri_cd,
                                  shr_ri_pct,
                                  shr_ri_pct_real,
                                  shr_loss_ri_res_amt,
                                  shr_exp_ri_res_amt,
                                  line_cd, acct_trty_type,
                                  prnt_ri_cd, hist_seq_no,
                                  grouped_item_no
                                 )                     --added by gmi 02/23/06
                          VALUES (c1.claim_id, c1.clm_res_hist_id,
                                  TO_CHAR (NVL (p_distribution_date, SYSDATE),
                                           'YYYY'
                                          ),
                                  v_clm_dist_no, c1.item_no, c1.peril_cd,
                                  c2.share_cd, v_trty_share_type,
                                  c_trty.ri_cd,
                                  (ann_dist_spct * c_trty.trty_shr_pct / 100
                                  ),
                                  c_trty.trty_shr_pct,
                                  (v_loss_res_amt * c_trty.trty_shr_pct / 100
                                  ),
                                  (v_exp_res_amt * c_trty.trty_shr_pct / 100
                                  ),
                                  v_line_cd, c2.acct_trty_type,
                                  c_trty.prnt_ri_cd, c1.hist_seq_no,
                                  c1.grouped_item_no
                                 );                    --added by gmi 02/23/06
                  ELSE
                     UPDATE gicl_reserve_rids
                        SET shr_exp_ri_res_amt =
                                 NVL (shr_exp_ri_res_amt, 0)
                               + (  NVL (v_exp_res_amt, 0)
                                  * c_trty.trty_shr_pct
                                  / 100
                                 ),
                            shr_loss_ri_res_amt =
                                 NVL (shr_loss_ri_res_amt, 0)
                               + (  NVL (v_loss_res_amt, 0)
                                  * c_trty.trty_shr_pct
                                  / 100
                                 ),
                            shr_ri_pct =
                                 NVL (shr_ri_pct, 0)
                               + (  NVL (ann_dist_spct, 0)
                                  * c_trty.trty_shr_pct
                                  / 100
                                 )
                      WHERE claim_id = c1.claim_id
                        AND hist_seq_no = c1.hist_seq_no
                        AND item_no = c1.item_no
                        AND peril_cd = c1.peril_cd
                        AND grouped_item_no =
                                     c1.grouped_item_no
                                                       --added by gmi 02/23/06
                        AND grp_seq_no = c2.share_cd
                        AND ri_cd = c_trty.ri_cd
                        AND line_cd = v_line_cd;
                  END IF;
               END LOOP;                                /*end of c_trty loop*/
            ELSIF c2.share_type = v_facul_share_type
            THEN
               FOR c3 IN cur_frperil (c1.peril_cd,
                                      c1.item_no,
                                      v_expiry_date,
                                      v_loss_date,
                                      v_pol_eff_date,
                                      v_issue_yy,
                                      v_pol_seq_no,
                                      v_renew_no,
                                      v_line_cd,
                                      v_subline_cd,
                                      v_pol_iss_cd
                                     )
               LOOP                                  /*RI peril distribution*/
                  IF    (c2.acct_trty_type <> v_acct_trty_type)
                     OR (c2.acct_trty_type IS NULL)
                  THEN
                     --ann_ri_pct := (c3.sum_ri_tsi_amt / sum_tsi_amt) * 100;
                     /* Modified by   : Edison
                     ** Date modified : 11.09.2012
                     ** Modifications : To update the shr_ri_pct in gicl_reserve_rids. It will add every RI_TSI_AMT
                     **                                    of binder until it get the sum of TSI to compute for shr_ri_pct.
                     **                                    This is for policy that have endorsements with facul.
                     ** Date modified : 11.12.2012
                     ** Modifications : Added if statement if the ri_cd is the same with the previous ri_cd,
                     **                                    if the ri_cd is the same, it will add all the tsi_amt to compute the ri_pct else,
                     **                                    the tsi_amt will reset then it will add all the tsi_amt of the another ri_cd.*/
                     IF c3.ri_cd = v_ri_cd
                     THEN
                        v_ri_tsi_amt := v_ri_tsi_amt + c3.sum_ri_tsi_amt;
                                                          --Edison 11.09.2012
                        ann_ri_pct := (v_ri_tsi_amt / sum_tsi_amt) * 100;
                                 --changed c3.sum_ri_tsi_amt to v_ann_ri_spct
                     ELSE
                        ann_ri_pct := (c3.sum_ri_tsi_amt / sum_tsi_amt) * 100;
                        v_ri_tsi_amt := c3.sum_ri_tsi_amt;
                        v_ri_cd := c3.ri_cd;
                     END IF;
                  ELSE
                     ann_ri_pct := (v_facul_amt / sum_tsi_amt) * 100;
                  END IF;

                  /* Added by    : Edison
                  ** Date added  : 11.08.2012
                  ** Description : To insert in gicl_reserve_rids that is grouped by fnl_binder_id and ri_cd.
                  **                             To insert the fnl_binder_id in new table - gicl_reserve_rids_binders. */

                  --to check if there is already a claim record in gicl_reserve_rids table.
                  BEGIN
                     SELECT '1'
                       INTO v_checking
                       FROM gicl_reserve_rids
                      WHERE claim_id = c1.claim_id
                        AND clm_res_hist_id = c1.clm_res_hist_id
                        AND clm_dist_no = v_clm_dist_no
                        AND grp_seq_no = c2.share_cd
                        AND ri_cd = c3.ri_cd;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        v_checking := NULL;
                  END;

                  IF v_checking IS NULL
                  THEN
                     --if there is no record in gicl_reserve_rids, it will do an insert statement.
                     INSERT INTO gicl_reserve_rids
                                 (claim_id, clm_res_hist_id,
                                  dist_year,
                                  clm_dist_no, item_no, peril_cd,
                                  grp_seq_no, share_type, ri_cd,
                                  shr_ri_pct,
                                  shr_ri_pct_real,
                                  shr_loss_ri_res_amt,
                                  shr_exp_ri_res_amt,
                                  line_cd, acct_trty_type, prnt_ri_cd,
                                  hist_seq_no, grouped_item_no,
                                                       --added by gmi 02/23/06
                                  fnl_binder_id
                                 )                     --added by jen.02082012
                          VALUES (c1.claim_id, c1.clm_res_hist_id,
                                  TO_CHAR (NVL (p_distribution_date, SYSDATE),
                                           'YYYY'
                                          ),
                                  v_clm_dist_no, c1.item_no, c1.peril_cd,
                                  c2.share_cd, v_facul_share_type, c3.ri_cd,
                                  ann_ri_pct,
                                  ann_ri_pct * 100 / ann_dist_spct,
                                  (c1.loss_reserve * ann_ri_pct / 100
                                  ),
                                  (c1.expense_reserve * ann_ri_pct / 100),
                                  v_line_cd, c2.acct_trty_type, c3.ri_cd,
                                  c1.hist_seq_no, c1.grouped_item_no,
                                                                --gmi 02/23/06
                                  c3.fnl_binder_id
                                 );                             --jen.02082012
                  ELSE
                     --if there is already a record in gicl_reserve_rids, it will update the loss/expense amounts of claim and its share_pct
                     UPDATE gicl_reserve_rids
                        SET shr_loss_ri_res_amt =
                                          c1.loss_reserve
                                          * (ann_ri_pct / 100),
                            shr_exp_ri_res_amt =
                                       c1.expense_reserve
                                       * (ann_ri_pct / 100),
                            shr_ri_pct = ann_ri_pct,
                            shr_ri_pct_real =
                                 ann_ri_pct
                               * 100
                               / ann_dist_spct
--allow update of shr_ri_pct_real if reserve is redistributed by MAC 09/26/2013.
                      WHERE claim_id = c1.claim_id
                        AND clm_res_hist_id = c1.clm_res_hist_id
                        AND clm_dist_no = v_clm_dist_no
                        AND grp_seq_no = c2.share_cd
                        AND ri_cd = c3.ri_cd;

                     v_checking := NULL;
                  END IF;

                  --this will insert the fnl_binder_id in table - gicl_reserve_rids_binders
                  INSERT INTO gicl_reserve_rids_binders
                              (claim_id, clm_res_hist_id,
                               clm_dist_no, ri_cd, grp_seq_no,
                               fnl_binder_id
                              )
                       VALUES (c1.claim_id, c1.clm_res_hist_id,
                               v_clm_dist_no, c3.ri_cd, c2.share_cd,
                               c3.fnl_binder_id
                              );
               --end of modifications 11.09.2012
               END LOOP;                                   /*End of c3 loop */
            END IF;
         ELSE
            NULL;
         END IF;
      END LOOP;                                             /*End of c2 loop*/

      FOR x IN (SELECT *
                  FROM gicl_claims                                     --alizaG SR 5482
                 WHERE claim_id = c1.claim_id)
      LOOP
         IF x.catastrophic_cd IS NOT NULL
         THEN
             v_catastrophic_cd := x.catastrophic_cd ;
         END IF;
      END LOOP;

      --EXCESS OF LOSS
      DECLARE
         v_retention               gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_retention_orig          gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_running_retention       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_total_retention         gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_allowed_retention       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_total_xol_share         gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_overall_xol_share       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_overall_allowed_share   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_old_xol_share           gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_allowed_ret             gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
         v_shr_pct                 gicl_reserve_ds.shr_pct%TYPE;
      BEGIN
         IF v_catastrophic_cd IS NULL
         THEN
            FOR net_shr IN
               (SELECT (shr_loss_res_amt * c1.convert_rate) loss_reserve,
                       (shr_exp_res_amt * c1.convert_rate) exp_reserve,
                       shr_pct
                  FROM gicl_reserve_ds
                 WHERE claim_id = c1.claim_id
                   AND grouped_item_no =
                                     c1.grouped_item_no
                                                       --added by gmi 02/28/06
                   AND hist_seq_no = c1.hist_seq_no
                   AND item_no = c1.item_no
                   AND peril_cd = c1.peril_cd
                   AND share_type = '1')
            LOOP
               v_retention :=
                  NVL (net_shr.loss_reserve, 0)
                  + NVL (net_shr.exp_reserve, 0);
               v_retention_orig :=
                  NVL (net_shr.loss_reserve, 0)
                  + NVL (net_shr.exp_reserve, 0);

               FOR tot_net IN
                  (SELECT SUM (  NVL (a.shr_loss_res_amt * c.convert_rate, 0)
                               + NVL (a.shr_exp_res_amt * c.convert_rate, 0)
                              ) ret_amt
                     FROM gicl_reserve_ds a,
                          gicl_item_peril b,
                          gicl_clm_res_hist c
                    WHERE a.claim_id = c1.claim_id
                      AND a.claim_id = b.claim_id
                      AND a.grouped_item_no = b.grouped_item_no
                      AND a.item_no = b.item_no
                      AND a.peril_cd = b.peril_cd
                      AND a.claim_id = c.claim_id
                      AND a.grouped_item_no = c.grouped_item_no
                      AND a.item_no = c.item_no
                      AND a.peril_cd = c.peril_cd
                      AND a.clm_dist_no = c.dist_no
                      AND a.clm_res_hist_id = c.clm_res_hist_id
                      AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                      AND NVL (a.negate_tag, 'N') = 'N'
                      AND a.share_type = '1'
                      AND (   a.item_no <> c1.item_no
                           OR a.peril_cd <> c1.peril_cd
                           OR a.grouped_item_no <> c1.grouped_item_no
                          ))
               LOOP
                  v_total_retention := v_retention + NVL (tot_net.ret_amt, 0);
               END LOOP;

               FOR chk_xol IN (SELECT   a.share_cd, acct_trty_type,
                                        xol_allowed_amount, xol_base_amount,
                                        xol_reserve_amount, trty_yy,
                                        --xol_aggregate_sum, a.line_cd, modified by alizaG 06/03/2016 SR 5482 added reinstatement limit
                                        xol_aggregate_sum, reinstatement_limit, a.line_cd,
                                        a.share_type
                                   FROM giis_dist_share a, giis_trty_peril b
                                  WHERE a.line_cd = b.line_cd
                                    AND a.share_cd = b.trty_seq_no
                                    AND a.share_type = '4'
                                    AND TRUNC (a.eff_date) <=
                                                           TRUNC (v_loss_date)
                                    AND TRUNC (a.expiry_date) >=
                                                           TRUNC (v_loss_date)
                                    AND b.peril_cd = c1.peril_cd
                                    AND a.line_cd = v_line_cd
                               ORDER BY xol_base_amount ASC)
               LOOP
                  v_allowed_retention :=
                                  v_total_retention - chk_xol.xol_base_amount;

                  IF v_allowed_retention < 1
                  THEN
                     EXIT;
                  END IF;

                  FOR get_all_xol IN
                     (SELECT SUM (  NVL (a.shr_loss_res_amt * c.convert_rate,
                                         0
                                        )
                                  + NVL (a.shr_exp_res_amt * c.convert_rate,
                                         0)
                                 ) ret_amt
                        FROM gicl_reserve_ds a,
                             gicl_item_peril b,
                             gicl_clm_res_hist c
                       WHERE NVL (a.negate_tag, 'N') = 'N'
                         AND a.item_no = b.item_no
                         AND a.grouped_item_no =
                                     b.grouped_item_no
                                                      -- added by gmi 02/28/06
                         AND a.peril_cd = b.peril_cd
                         AND a.claim_id = b.claim_id
                         AND a.item_no = c.item_no
                         AND a.grouped_item_no =
                                     c.grouped_item_no
                                                      -- added by gmi 02/28/06
                         AND a.peril_cd = c.peril_cd
                         AND a.claim_id = c.claim_id
                         AND NVL (a.clm_dist_no, -1) =
                                NVL
                                   (c.dist_no, -1)
                           --modified by ailene to handle ORA-01722 12/05/2006
                         AND a.clm_res_hist_id = c.clm_res_hist_id
                         AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                         AND a.grp_seq_no = chk_xol.share_cd
                         AND a.line_cd = chk_xol.line_cd)
                  LOOP
                     v_overall_xol_share :=
                              --chk_xol.xol_aggregate_sum  - get_all_xol.ret_amt; modified by alizaG. SR 5482 06/03/2016
                              NVL(chk_xol.xol_aggregate_sum,NVL(chk_xol.reinstatement_limit*chk_xol.xol_allowed_amount,0)+chk_xol.xol_allowed_amount)  - get_all_xol.ret_amt;
                  END LOOP;

                  IF v_overall_xol_share < 1
                  THEN
 -- added adrel 01082010, should exit loop if already exceeded aggregate limit
                     EXIT;
                  END IF;

                  IF v_allowed_retention > v_overall_xol_share
                  THEN
                     v_allowed_retention := v_overall_xol_share;
                  END IF;

                  IF v_allowed_retention > v_retention
                  THEN
                     v_allowed_retention := v_retention;
                  END IF;

                  v_total_xol_share := 0;
                  v_old_xol_share := 0;

                  FOR total_xol IN
                     (SELECT SUM (  NVL (a.shr_loss_res_amt * c.convert_rate,
                                         0
                                        )
                                  + NVL (a.shr_exp_res_amt * c.convert_rate,
                                         0)
                                 ) ret_amt
                        FROM gicl_reserve_ds a,
                             gicl_item_peril b,
                             gicl_clm_res_hist c
                       WHERE a.claim_id = c1.claim_id
                         AND a.claim_id = b.claim_id
                         AND a.grouped_item_no =
                                      b.grouped_item_no
                                                       --added by gmi 02/28/06
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b.peril_cd
                         AND a.claim_id = c.claim_id
                         AND a.item_no = c.item_no
                         AND a.peril_cd = c.peril_cd
                         AND a.grouped_item_no =
                                      c.grouped_item_no
                                                       --added by gmi 02/28/06
                         AND a.clm_res_hist_id = c.clm_res_hist_id
                         AND a.clm_dist_no = c.dist_no
                         AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                         AND NVL (a.negate_tag, 'N') = 'N'
                         AND a.grp_seq_no = chk_xol.share_cd)
                  LOOP
                     v_total_xol_share := NVL (total_xol.ret_amt, 0);
                     v_old_xol_share := NVL (total_xol.ret_amt, 0);
                  END LOOP;

                  IF v_total_xol_share <= chk_xol.xol_allowed_amount
                  THEN
                     v_total_xol_share :=
                               chk_xol.xol_allowed_amount - v_total_xol_share;
                  END IF;

                  IF v_total_xol_share >= v_allowed_retention
                  THEN
                     v_total_xol_share := v_allowed_retention;
                  END IF;

                  IF v_total_xol_share <> 0
                  THEN
                     v_shr_pct := v_total_xol_share / v_retention_orig;
                     v_running_retention :=
                                      v_running_retention + v_total_xol_share;

                     INSERT INTO gicl_reserve_ds
                                 (claim_id, clm_res_hist_id,
                                  dist_year,
                                  clm_dist_no, item_no, peril_cd,
                                  grouped_item_no,     --added by gmi 02/28/06
                                                  grp_seq_no,
                                  share_type,
                                  shr_pct,
                                  shr_loss_res_amt,
                                  shr_exp_res_amt,
                                  line_cd, acct_trty_type,
                                  user_id,
                                  last_update, hist_seq_no
                                 )
                          VALUES (c1.claim_id, c1.clm_res_hist_id,
                                  TO_CHAR (NVL (p_distribution_date, SYSDATE),
                                           'YYYY'
                                          ),
                                  v_clm_dist_no, c1.item_no, c1.peril_cd,
                                  c1.grouped_item_no,  --added by gmi 02/28/06
                                                     chk_xol.share_cd,
                                  chk_xol.share_type,
                                  (net_shr.shr_pct * v_shr_pct
                                  ),
                                    (net_shr.loss_reserve * v_shr_pct)
                                  / c1.convert_rate,
                                    (net_shr.exp_reserve * v_shr_pct
                                    )
                                  / c1.convert_rate,
                                  v_line_cd, chk_xol.acct_trty_type,
                                  NVL (giis_users_pkg.app_user, USER),
                                  SYSDATE, c1.hist_seq_no
                                 );
                                 
                     FOR update_xol_trty IN
                        (SELECT SUM (  (  NVL (a.shr_loss_res_amt, 0)
                                        * b.convert_rate
                                       )
                                     + (  NVL (shr_exp_res_amt, 0)
                                        * b.convert_rate
                                       )
                                    ) ret_amt
                           FROM gicl_reserve_ds a,
                                gicl_clm_res_hist b,
                                gicl_item_peril c
                          WHERE NVL (a.negate_tag, 'N') = 'N'
                            AND a.claim_id = b.claim_id
                            AND a.clm_res_hist_id = b.clm_res_hist_id
                            AND a.claim_id = c.claim_id
                            AND a.item_no = c.item_no
                            AND a.peril_cd = c.peril_cd
                            AND a.grouped_item_no =
                                      c.grouped_item_no
                                                       --added by gmi 02/28/06
                            AND a.clm_dist_no = b.dist_no
                            AND NVL (c.close_flag, 'AP') IN
                                                           ('AP', 'CC', 'CP')
                            AND a.grp_seq_no = chk_xol.share_cd
                            AND a.line_cd = chk_xol.line_cd)
                     LOOP
                        UPDATE giis_dist_share
                           SET xol_reserve_amount = update_xol_trty.ret_amt
                         WHERE share_cd = chk_xol.share_cd
                           AND line_cd = chk_xol.line_cd;
                     END LOOP;

                     FOR xol_trty IN cur_trty (chk_xol.share_cd,
                                               chk_xol.trty_yy,
                                               v_line_cd
                                              )
                     LOOP
                        INSERT INTO gicl_reserve_rids
                                    (claim_id, clm_res_hist_id,
                                     dist_year,
                                     clm_dist_no, item_no, peril_cd,
                                     grp_seq_no, share_type,
                                     ri_cd,
                                     shr_ri_pct,
                                     shr_ri_pct_real,
                                     shr_loss_ri_res_amt,
                                     shr_exp_ri_res_amt,
                                     line_cd, acct_trty_type,
                                     prnt_ri_cd, hist_seq_no,
                                     grouped_item_no
                                    )
                             VALUES (c1.claim_id, c1.clm_res_hist_id,
                                     TO_CHAR (NVL (p_distribution_date,
                                                   SYSDATE
                                                  ),
                                              'YYYY'
                                             ),
                                     v_clm_dist_no, c1.item_no, c1.peril_cd,
                                     chk_xol.share_cd, chk_xol.share_type,
                                     xol_trty.ri_cd,
                                     (  (net_shr.shr_pct * v_shr_pct)
                                      * (xol_trty.trty_shr_pct / 100)
                                     ),
                                     xol_trty.trty_shr_pct,
                                       (  (net_shr.loss_reserve * v_shr_pct)
                                        * (xol_trty.trty_shr_pct / 100)
                                       )
                                     / c1.convert_rate,
                                       (  (net_shr.exp_reserve * v_shr_pct)
                                        * (xol_trty.trty_shr_pct / 100)
                                       )
                                     / c1.convert_rate,
                                     v_line_cd, chk_xol.acct_trty_type,
                                     xol_trty.prnt_ri_cd, c1.hist_seq_no,
                                     c1.grouped_item_no
                                    );                          --gmi 02/23/06
                     END LOOP;
                  END IF;

                  v_retention := v_retention - v_total_xol_share;
                  v_total_retention := v_total_retention + v_old_xol_share;
               END LOOP;                                             --CHK_XOL
            END LOOP;                                               -- NET_SHR
         ELSE
            FOR net_shr IN
               (SELECT (shr_loss_res_amt * c1.convert_rate) loss_reserve,
                       (shr_exp_res_amt * c1.convert_rate) exp_reserve,
                       shr_pct
                  FROM gicl_reserve_ds
                 WHERE claim_id = c1.claim_id
                   AND hist_seq_no = c1.hist_seq_no
                   AND grouped_item_no =
                                     c1.grouped_item_no
                                                       --added by gmi 02/28/06
                   AND item_no = c1.item_no
                   AND peril_cd = c1.peril_cd
                   AND share_type = '1')
            LOOP
               v_retention :=
                  NVL (net_shr.loss_reserve, 0)
                  + NVL (net_shr.exp_reserve, 0);
               v_retention_orig :=
                  NVL (net_shr.loss_reserve, 0)
                  + NVL (net_shr.exp_reserve, 0);

               FOR tot_net IN
                  (SELECT SUM (  NVL (shr_loss_res_amt * d.convert_rate, 0)
                               + NVL (shr_exp_res_amt * d.convert_rate, 0)
                              ) ret_amt
                     FROM gicl_reserve_ds a,
                          gicl_claims c,
                          gicl_item_peril b,
                          gicl_clm_res_hist d
                    WHERE a.claim_id = c.claim_id
                      AND a.claim_id = b.claim_id
                      AND a.grouped_item_no =
                                      b.grouped_item_no
                                                       --added by gmi 02/28/06
                      AND a.item_no = b.item_no
                      AND a.peril_cd = b.peril_cd
                      AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                      AND c.catastrophic_cd = v_catastrophic_cd
                      AND c.line_cd =
                               v_line_cd
                                        --jen.060210: to hadle cat multi line.
                      AND NVL (negate_tag, 'N') = 'N'
                      AND share_type = '1'
                      AND a.claim_id = d.claim_id
                      AND a.grouped_item_no =
                                      d.grouped_item_no
                                                       --added by gmi 02/28/06
                      AND a.item_no = d.item_no
                      AND a.peril_cd = d.peril_cd
                      AND a.clm_dist_no = d.dist_no
                      AND a.clm_res_hist_id = d.clm_res_hist_id
                      AND (   --a.claim_id <> p_claim_id replaced by Aliza G. 6/10/2016
                           a.claim_id <> c1.claim_id
                           OR a.item_no <> c1.item_no
                           OR a.peril_cd <> c1.peril_cd
                           OR a.grouped_item_no <> c1.grouped_item_no --added by Aliza G. 6/10/2016
                          ))
               LOOP
                  v_total_retention := v_retention + NVL (tot_net.ret_amt, 0);
               END LOOP;

               FOR chk_xol IN (SELECT   a.share_cd, acct_trty_type,
                                        xol_allowed_amount, xol_base_amount,
                                        xol_reserve_amount, trty_yy,
                                        --xol_aggregate_sum, a.line_cd, modified by alizaG SR 5482 06/03/2016 SR 5482 added reinstatement_limit
                                        xol_aggregate_sum, reinstatement_limit, a.line_cd,
                                        a.share_type
                                   FROM giis_dist_share a, giis_trty_peril b
                                  WHERE a.line_cd = b.line_cd
                                    AND a.share_cd = b.trty_seq_no
                                    AND a.share_type = '4'
                                    AND TRUNC (a.eff_date) <=
                                                           TRUNC (v_loss_date)
                                    AND TRUNC (a.expiry_date) >=
                                                           TRUNC (v_loss_date)
                                    AND b.peril_cd = c1.peril_cd
                                    AND a.line_cd = v_line_cd
                               ORDER BY xol_base_amount ASC)
               LOOP
                  v_allowed_retention :=
                                  v_total_retention - chk_xol.xol_base_amount;

                  IF v_allowed_retention < 1
                    THEN
                     --EXIT; aliza 0610 REPLACED ELSE COND SINCE YOU SHOULD CHECK OTHER XOL IF ELIGIBLE AS WELL
                    NULL;
                  
                  ELSE
                        

                      FOR get_all_xol IN
                         (SELECT SUM (  NVL (shr_loss_res_amt * c.convert_rate, 0)
                                      + NVL (shr_exp_res_amt * c.convert_rate, 0)
                                     ) ret_amt
                            FROM gicl_reserve_ds a,
                                 gicl_item_peril b,
                                 gicl_clm_res_hist c
                           WHERE NVL (negate_tag, 'N') = 'N'
                             AND a.claim_id = b.claim_id
                             AND a.item_no = b.item_no
                             AND a.peril_cd = b.peril_cd
                             AND a.grouped_item_no =
                                          b.grouped_item_no
                                                           --added by gmi 02/28/06
                             AND a.claim_id = c.claim_id
                             AND a.grouped_item_no =
                                          c.grouped_item_no
                                                           --added by gmi 02/28/06
                             AND a.item_no = c.item_no
                             AND a.peril_cd = c.peril_cd
                             AND a.clm_dist_no = c.dist_no
                             AND a.clm_res_hist_id = c.clm_res_hist_id
                             AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                             AND grp_seq_no = chk_xol.share_cd
                             AND a.line_cd = chk_xol.line_cd)
                      LOOP
                         v_overall_xol_share :=
                                  --chk_xol.xol_aggregate_sum  - get_all_xol.ret_amt; modified by AlizaG SR 5482 06/03/2016
                                  NVL(chk_xol.xol_aggregate_sum,NVL(chk_xol.reinstatement_limit*chk_xol.xol_allowed_amount,0)+chk_xol.xol_allowed_amount)  - get_all_xol.ret_amt;                     
                      END LOOP;

                      IF v_overall_xol_share < 1
                      THEN
                        -- added adrel 01082010, should exit loop if already exceeded aggregate limit
                         --EXIT; COMMENT OUT BY ALIZA G 610 to allow procedure to evaluate other XOL
                         null;                     
                      ELSE

                          IF v_allowed_retention > v_overall_xol_share
                          THEN
                             v_allowed_retention := v_overall_xol_share;
                          END IF;

                          IF v_allowed_retention > v_retention
                          THEN
                             v_allowed_retention := v_retention;
                          END IF;

                          v_total_xol_share := 0;
                          v_old_xol_share := 0;

                          FOR total_xol IN
                             (SELECT SUM (  NVL (shr_loss_res_amt * d.convert_rate, 0)
                                          + NVL (shr_exp_res_amt * d.convert_rate, 0)
                                         ) ret_amt
                                FROM gicl_reserve_ds a,
                                     gicl_claims c,
                                     gicl_item_peril b,
                                     gicl_clm_res_hist d
                               WHERE c.claim_id = a.claim_id
                                 AND a.grouped_item_no =
                                              b.grouped_item_no
                                                               --added by gmi 02/28/06
                                 AND a.claim_id = b.claim_id
                                 AND a.item_no = b.item_no
                                 AND a.peril_cd = b.peril_cd
                                 AND a.claim_id = d.claim_id
                                 AND a.grouped_item_no =
                                              d.grouped_item_no
                                                               --added by gmi 02/28/06
                                 AND a.item_no = d.item_no
                                 AND a.peril_cd = d.peril_cd
                                 AND a.clm_dist_no = d.dist_no
                                 AND a.clm_res_hist_id = d.clm_res_hist_id
                                 AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                                 AND c.catastrophic_cd = v_catastrophic_cd
                                 AND c.line_cd =
                                        v_line_cd
                                                --jen.060210: to handle cat multi line
                                 AND NVL (negate_tag, 'N') = 'N'
                                 AND grp_seq_no = chk_xol.share_cd)
                          LOOP
                             v_total_xol_share := NVL (total_xol.ret_amt, 0);
                             v_old_xol_share := NVL (total_xol.ret_amt, 0);
                          END LOOP;

                          IF v_total_xol_share <= chk_xol.xol_allowed_amount
                          THEN
                             v_total_xol_share :=
                                       chk_xol.xol_allowed_amount - v_total_xol_share;
                          ELSE
                             v_total_xol_share := 0;
                          END IF;

                          IF v_total_xol_share >= v_allowed_retention
                          THEN
                             v_total_xol_share := v_allowed_retention;
                          END IF;

                          IF v_total_xol_share <> 0
                          THEN
                             v_shr_pct := v_total_xol_share / v_retention_orig;
                             v_running_retention :=
                                              v_running_retention + v_total_xol_share;

                             INSERT INTO gicl_reserve_ds
                                         (claim_id, clm_res_hist_id,
                                          dist_year,
                                          clm_dist_no, item_no, peril_cd,
                                          grouped_item_no, grp_seq_no,
                                          share_type,
                                          shr_pct,
                                          shr_loss_res_amt,
                                          shr_exp_res_amt,
                                          line_cd, acct_trty_type,
                                          user_id,
                                          last_update, hist_seq_no
                                         )
                                  VALUES (c1.claim_id, c1.clm_res_hist_id,
                                          TO_CHAR (NVL (p_distribution_date, SYSDATE),
                                                   'YYYY'
                                                  ),
                                          v_clm_dist_no, c1.item_no, c1.peril_cd,
                                          c1.grouped_item_no,  --added by gmi 02/28/06
                                                             chk_xol.share_cd,
                                          chk_xol.share_type,
                                          (net_shr.shr_pct * v_shr_pct
                                          ),
                                            (net_shr.loss_reserve * v_shr_pct)
                                          / c1.convert_rate,
                                            (net_shr.exp_reserve * v_shr_pct
                                            )
                                          / c1.convert_rate,
                                          v_line_cd, chk_xol.acct_trty_type,
                                          NVL (giis_users_pkg.app_user, USER),
                                          SYSDATE, c1.hist_seq_no
                                         );

                             FOR update_xol_trty IN
                                (SELECT SUM (  (  NVL (a.shr_loss_res_amt, 0)
                                                * b.convert_rate
                                               )
                                             + (  NVL (shr_exp_res_amt, 0)
                                                * b.convert_rate
                                               )
                                            ) ret_amt
                                   FROM gicl_reserve_ds a,
                                        gicl_clm_res_hist b,
                                        gicl_item_peril c
                                  WHERE NVL (a.negate_tag, 'N') = 'N'
                                    AND a.claim_id = b.claim_id
                                    AND a.clm_res_hist_id = b.clm_res_hist_id
                                    AND a.claim_id = c.claim_id
                                    AND a.item_no = c.item_no
                                    AND a.peril_cd = c.peril_cd
                                    AND a.grouped_item_no =
                                              c.grouped_item_no
                                                               --added by gmi 02/28/06
                                    AND NVL (c.close_flag, 'AP') IN
                                                                   ('AP', 'CC', 'CP')
                                    AND a.grp_seq_no = chk_xol.share_cd
                                    AND a.line_cd = chk_xol.line_cd)
                             LOOP
                                UPDATE giis_dist_share
                                   SET xol_reserve_amount = update_xol_trty.ret_amt
                                 WHERE share_cd = chk_xol.share_cd
                                   AND line_cd = chk_xol.line_cd;
                             END LOOP;

                             FOR xol_trty IN cur_trty (chk_xol.share_cd,
                                                       chk_xol.trty_yy,
                                                       v_line_cd
                                                      )
                             LOOP
                                INSERT INTO gicl_reserve_rids
                                            (claim_id, clm_res_hist_id,
                                             dist_year,
                                             clm_dist_no, item_no, peril_cd,
                                             grp_seq_no, share_type,
                                             ri_cd,
                                             shr_ri_pct,
                                             shr_ri_pct_real,
                                             shr_loss_ri_res_amt,
                                             shr_exp_ri_res_amt,
                                             line_cd, acct_trty_type,
                                             prnt_ri_cd, hist_seq_no,
                                             grouped_item_no
                                            )                           --gmi 02/23/06
                                     VALUES (c1.claim_id, c1.clm_res_hist_id,
                                             TO_CHAR (NVL (p_distribution_date,
                                                           SYSDATE
                                                          ),
                                                      'YYYY'
                                                     ),
                                             v_clm_dist_no, c1.item_no, c1.peril_cd,
                                             chk_xol.share_cd, chk_xol.share_type,
                                             xol_trty.ri_cd,
                                             (  (net_shr.shr_pct * v_shr_pct)
                                              * (xol_trty.trty_shr_pct / 100)
                                             ),
                                             xol_trty.trty_shr_pct,
                                               (  (net_shr.loss_reserve * v_shr_pct)
                                                * (xol_trty.trty_shr_pct / 100)
                                               )
                                             / c1.convert_rate,
                                               (  (net_shr.exp_reserve * v_shr_pct)
                                                * (xol_trty.trty_shr_pct / 100)
                                               )
                                             / c1.convert_rate,
                                             v_line_cd, chk_xol.acct_trty_type,
                                             xol_trty.prnt_ri_cd, c1.hist_seq_no,
                                             c1.grouped_item_no
                                            );                          --gmi 02/23/06
                             END LOOP;
                          END IF;

                          v_retention := v_retention - v_total_xol_share;
                          v_total_retention := v_total_retention + v_old_xol_share;
                      
                      END IF;--XOL SHARE (checking XOL is already full)
                      
                  
                  END IF;--v_allowed_retention (checking if eligible for XOL)             
               END LOOP;                                             --CHK_XOL
            END LOOP;                                               -- NET_SHR
         END IF;
         
         /*Added by Aliza G. SR 5482 06/03/2015 to adjust amount for other layers/treaties not included on new distribution but previously included*/

        FOR xol_trty IN (SELECT a.share_cd,        acct_trty_type,       xol_allowed_amount,
                                      xol_base_amount,   xol_allocated_amount, trty_yy,
                                      xol_aggregate_sum, a.line_cd,            a.share_type
                                 FROM GIIS_DIST_SHARE a, GIIS_TRTY_PERIL b
                                WHERE a.line_cd             = b.line_cd
                                  AND a.share_cd            = b.trty_seq_no
                                  AND a.share_type          = '4'
                                  AND TRUNC(a.eff_date)    <= TRUNC(v_loss_date)
                                  AND TRUNC(a.expiry_date) >= TRUNC(v_loss_date)
                                  AND b.peril_cd            = c1.peril_cd             
                                  AND a.line_cd             = v_line_cd                
                             ORDER BY xol_base_amount ASC)
        LOOP
                    FOR update_xol_trty IN (SELECT SUM((NVL(a.SHR_LOSS_RES_AMT,0)+NVL(a.SHR_EXP_RES_AMT,0)) * NVL(b.convert_rate,1)) ret_amt
                                              FROM GICL_RESERVE_DS a,  GICL_CLM_RESERVE b, GICL_ITEM_PERIL c
                                             WHERE a.claim_id             = b.claim_id
                                               AND a.item_no          = b.item_no
                                               AND a.peril_cd         = b.peril_cd
                                               AND a.grouped_item_no  = b.grouped_item_no
                                               AND a.claim_id         = c.claim_id
                                               AND a.item_no          = c.item_no
                                               AND a.peril_cd         = c.peril_cd
                                               AND a.grouped_item_no  = c.grouped_item_no                                               
                                               AND NVL(a.negate_tag, 'N') = 'N'
                                               AND NVL (c.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                                               AND grp_seq_no             = xol_trty.share_cd
                                               AND a.line_cd              = xol_trty.line_cd)
                    LOOP     
                        UPDATE GIIS_DIST_SHARE 
                           SET XOL_RESERVE_AMOUNT = update_xol_trty.ret_amt
                        WHERE share_cd = xol_trty.share_cd
                          AND line_cd = xol_trty.line_cd;
                    END LOOP; 
        
        END LOOP;

         IF v_retention = 0
         THEN
            DELETE FROM gicl_reserve_ds
                  WHERE claim_id = c1.claim_id
                    AND hist_seq_no = c1.hist_seq_no
                    AND item_no = c1.item_no
                    AND peril_cd = c1.peril_cd
                    AND grouped_item_no =
                                     c1.grouped_item_no
                                                       --added by gmi 02/28/06
                    AND share_type = '1';
         ELSIF v_retention <> v_retention_orig
         THEN
            UPDATE gicl_reserve_ds
               SET shr_loss_res_amt =
                        shr_loss_res_amt
                      * (v_retention_orig - v_running_retention)
                      / v_retention_orig,
                   shr_exp_res_amt =
                        shr_exp_res_amt
                      * (v_retention_orig - v_running_retention)
                      / v_retention_orig,
                   shr_pct =
                        shr_pct
                      * (v_retention_orig - v_running_retention)
                      / v_retention_orig
             WHERE claim_id = c1.claim_id
               AND hist_seq_no = c1.hist_seq_no
               AND item_no = c1.item_no
               AND peril_cd = c1.peril_cd
               AND grouped_item_no = c1.grouped_item_no
                                                       --added by gmi 02/28/06
               AND share_type = '1';
         END IF;
      END;

      UPDATE gicl_clm_res_hist
         SET dist_sw = 'Y',
             dist_no = var_clm_dist_no
       WHERE CURRENT OF cur_clm_res;

      --MESSAGE('UPDATED DIST_SW IN DIST_RES'); PAUSE;
      UPDATE gicl_clm_res_hist
         SET dist_sw = 'Y',
             dist_no = var_clm_dist_no
       WHERE CURRENT OF cur_clm_res;
   --MESSAGE('UPDATED DIST_SW IN DIST_RES'); PAUSE;
   END LOOP;                                               /*End of c1 loop */

   --MESSAGE('Distribution Complete.', no_acknowledge);
   offset_amt (v_clm_dist_no, p_claim_id, p_clm_res_hist_id);
--forms_ddl('COMMIT');
--CLEAR_MESSAGE;
END; 
/

