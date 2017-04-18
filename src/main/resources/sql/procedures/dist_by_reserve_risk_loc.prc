DROP PROCEDURE CPI.DIST_BY_RESERVE_RISK_LOC;

CREATE OR REPLACE PROCEDURE CPI.dist_by_reserve_risk_loc (
   v1_claim_id          gicl_clm_res_hist.claim_id%TYPE,
   v1_clm_loss_id       gicl_clm_loss_exp.clm_loss_id%TYPE,
   v1_item_no           gicl_clm_res_hist.item_no%TYPE,
   v1_peril_cd          gicl_clm_res_hist.peril_cd%TYPE,
   v1_grouped_item_no   gicl_clm_res_hist.grouped_item_no%TYPE,
   v1_line_cd           giis_line.line_cd%TYPE,
   v1_dist_date         DATE,
   v1_clm_dist_no       gicl_loss_exp_ds.clm_dist_no%TYPE,
   v1_payee_cd          gicl_loss_exp_ds.payee_cd%TYPE,
   v_eff_date           DATE,
   v_expiry_date        DATE
)
IS
/* Modified by Udel
** 03062012
** Added column FNL_BINDER_ID to cursor cur_frperil
** to be inserted into table GICL_LOSS_EXP_RIDS.
*/

   --Cursor for item/peril loss amount
   CURSOR cur_clm_res
   IS
      SELECT claim_id, hist_seq_no, item_no, peril_cd, paid_amt, net_amt,
             advise_amt, grouped_item_no
        FROM gicl_clm_loss_exp
       WHERE claim_id = v1_claim_id AND clm_loss_id = v1_clm_loss_id;

   CURSOR cur_res_ds
   IS
      SELECT a.grp_seq_no, a.share_type, a.shr_pct, a.acct_trty_type
        FROM gicl_reserve_ds a
       WHERE a.peril_cd = v1_peril_cd
         AND a.item_no = v1_item_no
         AND a.grouped_item_no = v1_grouped_item_no
         AND a.claim_id = v1_claim_id
         AND a.share_type NOT IN
                (giacp.v ('XOL_TRTY_SHARE_TYPE'))
         AND NVL (a.negate_tag, 'N') <> 'Y'
         AND a.hist_seq_no =
                (SELECT MAX (b.hist_seq_no)
                   FROM gicl_reserve_ds b
                  WHERE b.dist_year = a.dist_year
                    AND b.peril_cd = a.peril_cd
                    AND b.item_no = a.item_no
                    AND b.grouped_item_no = a.grouped_item_no
                    AND b.claim_id = a.claim_id
                    AND NVL (b.negate_tag, 'N') <> 'Y');

   --Cursor for peril distribution in treaty table.
   CURSOR cur_trty (v_share_cd giis_dist_share.share_cd%TYPE)
   IS
      SELECT ri_cd, trty_shr_pct, prnt_ri_cd
        FROM giis_trty_panel tp, giis_dist_share ds
       WHERE tp.line_cd = ds.line_cd
         AND tp.trty_seq_no = ds.share_cd
         AND tp.line_cd = v1_line_cd
         AND tp.trty_yy = ds.trty_yy
         AND tp.trty_seq_no = v_share_cd;

   --Cursor for peril distribution in ri table.
   CURSOR cur_frperil (
      v_peril_cd   giri_ri_dist_item_v.peril_cd%TYPE,
      v_item_no    giri_ri_dist_item_v.item_no%TYPE
   )
   IS
      SELECT t2.ri_cd, t2.ri_shr_pct, t2.fnl_binder_id --udel 03062012
        FROM gipi_polbasic t5,
             gipi_itmperil t8,
             giuw_pol_dist t4,
             giuw_itemperilds t6,
             giri_distfrps t3,
             giri_frps_ri t2,
             gicl_claims t1
       WHERE t1.claim_id = v1_claim_id
         AND t5.line_cd = t1.line_cd
         AND t5.subline_cd = t1.subline_cd
         AND t5.iss_cd = t1.pol_iss_cd
         AND t5.issue_yy = t1.issue_yy
         AND t5.pol_seq_no = t1.pol_seq_no
         AND t5.renew_no = t1.renew_no
         AND t5.pol_flag IN ('1', '2', '3', '4', 'X')   --kenneth SR4855 100715
         AND t5.policy_id = t8.policy_id
         AND t8.peril_cd = v_peril_cd
         AND t8.item_no = v_item_no
         AND t5.policy_id = t4.policy_id
         AND TRUNC (DECODE (TRUNC (t4.eff_date),
                            TRUNC (t5.eff_date), DECODE
                                                       (TRUNC (t5.eff_date),
                                                        TRUNC (t5.incept_date), v_eff_date,
                                                        t5.eff_date
                                                       ),
                            t4.eff_date
                           )
                   ) <= t1.loss_date
         AND TRUNC (DECODE (TRUNC (t4.expiry_date),
                            TRUNC (t5.expiry_date), DECODE
                                                   (NVL (t5.endt_expiry_date,
                                                         t5.expiry_date
                                                        ),
                                                    t5.expiry_date, v_expiry_date,
                                                    t5.endt_expiry_date
                                                   ),
                            t4.expiry_date
                           )
                   ) >= t1.loss_date
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
         AND t3.ri_flag = '2';

   v_paid_amt      gicl_loss_exp_ds.shr_le_pd_amt%TYPE;
   v_advise_amt    gicl_loss_exp_ds.shr_le_adv_amt%TYPE;
   v_net_amt       gicl_loss_exp_ds.shr_le_net_amt%TYPE;
   v_share_exist   VARCHAR2 (1);

   FUNCTION portfolio_sw (
      v_line_cd      giis_dist_share.line_cd%TYPE,
      v_share_cd     giis_dist_share.share_cd%TYPE,
      v1_dist_date   DATE
   )
      RETURN BOOLEAN
   IS
   BEGIN
      FOR p_sw IN (SELECT '1'
                     FROM giis_dist_share
                    WHERE line_cd = v_line_cd
                      AND share_cd = v_share_cd
                      AND expiry_date < TRUNC (NVL (v1_dist_date, SYSDATE)))
      LOOP
         RETURN (TRUE);
      END LOOP;

      RETURN (FALSE);
   END;
BEGIN
   FOR c1 IN cur_clm_res
   LOOP
      FOR c2 IN cur_res_ds
      LOOP
         IF     portfolio_sw (v1_line_cd, c2.grp_seq_no, v1_dist_date)
            AND c2.share_type = giacp.v ('TRTY_SHARE_TYPE')
         THEN
            BEGIN
               SELECT share_cd, acct_trty_type, share_type
                 INTO c2.grp_seq_no, c2.acct_trty_type, c2.share_type
                 FROM giis_dist_share
                WHERE line_cd = v1_line_cd AND old_trty_seq_no = c2.grp_seq_no;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  raise_application_error (-20888,
                                              'No new treaty set-up for year'
                                           || TO_CHAR (NVL (v1_dist_date,
                                                            SYSDATE
                                                           ),
                                                       'YYYY'
                                                      )
                                          );
               WHEN TOO_MANY_ROWS
               THEN
                  raise_application_error
                                        (-20889,
                                            'Too many treaty set-up for year'
                                         || TO_CHAR (NVL (v1_dist_date,
                                                          SYSDATE
                                                         ),
                                                     'YYYY'
                                                    )
                                        );
            END;
         END IF;

         v_share_exist := 'N';

         FOR i IN (SELECT '1'
                     FROM gicl_loss_exp_ds
                    WHERE claim_id = c1.claim_id
                      AND item_no = c1.item_no
                      AND grouped_item_no = c1.grouped_item_no
                      AND peril_cd = c1.peril_cd
                      AND grp_seq_no = c2.grp_seq_no
                      AND line_cd = v1_line_cd
                      AND clm_dist_no = v1_clm_dist_no
                      AND clm_loss_id = v1_clm_loss_id)
         LOOP
            v_share_exist := 'Y';
         END LOOP;

         v_paid_amt := c1.paid_amt * c2.shr_pct / 100;
         v_advise_amt := c1.advise_amt * c2.shr_pct / 100;
         v_net_amt := c1.net_amt * c2.shr_pct / 100;

         INSERT INTO gicl_loss_exp_ds
                     (claim_id,
                      dist_year,
                      clm_loss_id, clm_dist_no, item_no,
                      peril_cd, payee_cd, grp_seq_no, share_type,
                      shr_loss_exp_pct, shr_le_pd_amt, shr_le_adv_amt,
                      shr_le_net_amt, line_cd, acct_trty_type,
                      distribution_date, grouped_item_no
                     )
              VALUES (c1.claim_id,
                      TO_CHAR (NVL (v1_dist_date, SYSDATE), 'RRRR'),
                      v1_clm_loss_id, v1_clm_dist_no, c1.item_no,
                      c1.peril_cd, v1_payee_cd, c2.grp_seq_no, c2.share_type,
                      c2.shr_pct, v_paid_amt, v_advise_amt,
                      v_net_amt, v1_line_cd, c2.acct_trty_type,
                      NVL (v1_dist_date, SYSDATE), c1.grouped_item_no
                     );

         IF c2.share_type = giacp.v ('TRTY_SHARE_TYPE')
         THEN
            FOR c_trty IN cur_trty (c2.grp_seq_no)
            LOOP
               IF v_share_exist = 'N'
               THEN
                  INSERT INTO gicl_loss_exp_rids
                              (claim_id,
                               dist_year,
                               clm_loss_id, clm_dist_no, item_no,
                               peril_cd, payee_cd, grp_seq_no,
                               share_type, ri_cd,
                               shr_loss_exp_ri_pct,
                               shr_le_ri_pd_amt,
                               shr_le_ri_adv_amt,
                               shr_le_ri_net_amt,
                               line_cd, acct_trty_type,
                               prnt_ri_cd, grouped_item_no
                              )
                       VALUES (c1.claim_id,
                               TO_CHAR (NVL (v1_dist_date, SYSDATE), 'RRRR'),
                               v1_clm_loss_id, v1_clm_dist_no, c1.item_no,
                               c1.peril_cd, v1_payee_cd, c2.grp_seq_no,
                               c2.share_type, c_trty.ri_cd,
                               (c2.shr_pct * (c_trty.trty_shr_pct / 100)
                               ),
                               (v_paid_amt * (c_trty.trty_shr_pct / 100)),
                               (v_advise_amt * (c_trty.trty_shr_pct / 100)
                               ),
                               (v_net_amt * (c_trty.trty_shr_pct / 100)),
                               v1_line_cd, c2.acct_trty_type,
                               c_trty.prnt_ri_cd, c1.grouped_item_no
                              );
               ELSE
                  UPDATE gicl_loss_exp_rids
                     SET shr_loss_exp_ri_pct =
                              NVL (shr_loss_exp_ri_pct, 0)
                            + (  NVL (c2.shr_pct, 0)
                               * (c_trty.trty_shr_pct / 100)
                              ),
                         shr_le_ri_pd_amt =
                              NVL (shr_le_ri_pd_amt, 0)
                            + (  NVL (v_paid_amt, 0)
                               * (c_trty.trty_shr_pct / 100)
                              ),
                         shr_le_ri_adv_amt =
                              NVL (shr_le_ri_adv_amt, 0)
                            + (  NVL (v_advise_amt, 0)
                               * (c_trty.trty_shr_pct / 100)
                              ),
                         shr_le_ri_net_amt =
                              NVL (shr_le_ri_net_amt, 0)
                            + (  NVL (v_net_amt, 0)
                               * (c_trty.trty_shr_pct / 100)
                              ),
                         dist_year =
                                 TO_CHAR (NVL (v1_dist_date, SYSDATE), 'RRRR')
                   WHERE claim_id = c1.claim_id
                     AND item_no = c1.item_no
                     AND grouped_item_no = c1.grouped_item_no
                     AND peril_cd = c1.peril_cd
                     AND grp_seq_no = c2.grp_seq_no
                     AND line_cd = v1_line_cd
                     AND ri_cd = c_trty.ri_cd
                     AND clm_dist_no = v1_clm_dist_no
                     AND clm_loss_id = v1_clm_loss_id;
               END IF;
            END LOOP;
         ELSIF c2.share_type = giacp.v ('FACUL_SHARE_TYPE')
         THEN
            FOR c3 IN cur_frperil (c1.peril_cd, c1.item_no)
            LOOP                                    /*RI peril distribution*/
               INSERT INTO gicl_loss_exp_rids
                           (claim_id,
                            dist_year,
                            clm_loss_id, clm_dist_no, item_no,
                            peril_cd, payee_cd, grp_seq_no,
                            share_type, ri_cd, shr_loss_exp_ri_pct,
                            shr_le_ri_pd_amt,
                            shr_le_ri_adv_amt,
                            shr_le_ri_net_amt, line_cd,
                            acct_trty_type, prnt_ri_cd, grouped_item_no,
                            fnl_binder_id -- Udel 03062012
                           )
                    VALUES (c1.claim_id,
                            TO_CHAR (NVL (v1_dist_date, SYSDATE), 'RRRR'),
                            v1_clm_loss_id, v1_clm_dist_no, c1.item_no,
                            c1.peril_cd, v1_payee_cd, c2.grp_seq_no,
                            c2.share_type, c3.ri_cd, c3.ri_shr_pct,
                            (c1.paid_amt * c3.ri_shr_pct / 100
                            ),
                            (c1.advise_amt * c3.ri_shr_pct / 100),
                            (c1.net_amt * c3.ri_shr_pct / 100
                            ), v1_line_cd,
                            c2.acct_trty_type, c3.ri_cd, c1.grouped_item_no,
                            c3.fnl_binder_id -- Udel 03062012
                           );
            END LOOP;                                      /*End of c3 loop */
         END IF;
      END LOOP;
   END LOOP;

   UPDATE gicl_clm_loss_exp
      SET dist_sw = 'Y'
    WHERE claim_id = v1_claim_id AND clm_loss_id = v1_clm_loss_id;
END;
/


