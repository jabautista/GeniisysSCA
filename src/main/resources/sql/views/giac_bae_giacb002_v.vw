DROP VIEW CPI.GIAC_BAE_GIACB002_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_bae_giacb002_v (cession_id,
                                                      iss_cd,
                                                      pol_iss_cd,
                                                      policy_id,
                                                      currency_cd,
                                                      currency_rt,
                                                      tk_up_type,
                                                      negate_date,
                                                      item_no,
                                                      line_cd,
                                                      acct_line_cd,
                                                      acct_subline_cd,
                                                      share_cd,
                                                      funds_held,
                                                      dist_no,
                                                      premium_amt,
                                                      fc_prem_amt,
                                                      tax_amt,
                                                      fc_tax_amt,
                                                      prem_vat,
                                                      fc_prem_vat,
                                                      commission_amt,
                                                      fc_comm_amt,
                                                      comm_vat,
                                                      fc_comm_vat,
                                                      ri_wholding_vat,
                                                      fc_ri_wholding_vat,
                                                      prem_tax,
                                                      fc_prem_tax,
                                                      trty_yy,
                                                      ri_cd,
                                                      peril_cd,
                                                      acct_intm_cd,
                                                      acct_trty_type,
                                                      reg_policy_sw,
                                                      acct_ent_date_pol,
                                                      spld_acct_ent_date_pol,
                                                      acct_ent_date_inv,
                                                      spoiled_acct_ent_date_inv,
                                                      local_foreign_sw,
                                                      takeup_seq_no
                                                     )
AS
   SELECT   1 cession_id,
                         /* modified by judyann 03242008; to handle take-up of long-term policies */
                         NVL (a.cred_branch, a.iss_cd) iss_cd,
            a.iss_cd pol_iss_cd                    /*added by alfie 03152010*/
                               ,
            a.policy_id, b.currency_cd, b.currency_rt,
            DECODE (c.negate_date, NULL, 'P', 'N') tk_up_type, c.negate_date,
            e.item_no, e.line_cd, i.acct_line_cd, j.acct_subline_cd,
            e.share_cd, NVL (g.funds_held_pct, f.funds_held_pct) funds_held,
            c.dist_no,
            SUM ((  ((g.trty_shr_pct / 100) * NVL (e.dist_prem, 0))
                  * NVL (b.currency_rt, 1)
                 )
                ) premium_amt,
            SUM ((((g.trty_shr_pct / 100) * NVL (e.dist_prem, 0)))
                ) fc_prem_amt,
            0 tax_amt, 0 fc_tax_amt,
            
            /* modified by judyann 04142009; added parameters to handle different client set-ups for treaty distribution take-up */
            /* modified by judyann 10232009; corrected the value returned for GEN_PREM_VAT_FOREIGN and GEN_COMM_VAT_FOREIGN = 'Y' */
            NVL
               (DECODE
                   (NVL (giacp.v ('GEN_VAT_ON_RI'), 'Y'),
                    'Y', (DECODE
                             (NVL (giacp.v ('GEN_TRTY_PREM_VAT'), 'N'),
                              'Y', (DECODE
                                       (NVL (giacp.v ('GEN_PREM_VAT_FOREIGN'),
                                             'N'
                                            ),
                                        'N', (DECODE
                                                 (k.local_foreign_sw,
                                                  'L', (  (SUM
                                                              ((  (  (  g.trty_shr_pct
                                                                      / 100
                                                                     )
                                                                   * NVL
                                                                        (e.dist_prem,
                                                                         0
                                                                        )
                                                                  )
                                                                * NVL
                                                                     (b.currency_rt,
                                                                      1
                                                                     )
                                                               )
                                                              )
                                                          )
                                                        * (  k.input_vat_rate
                                                           / 100
                                                          )
                                                   ),
                                                  0
                                                 )
                                         ),
                                        (  (SUM ((  (  (g.trty_shr_pct / 100
                                                       )
                                                     * NVL (e.dist_prem, 0)
                                                    )
                                                  * NVL (b.currency_rt, 1)
                                                 )
                                                )
                                           )
                                         * (k.input_vat_rate / 100)
                                        )
                                       )
                               ),
                              0
                             )
                     ),
                    0
                   ),
                0
               ) prem_vat,                     --lina 011006; judyann 10272009
            NVL
               (DECODE
                   (NVL (giacp.v ('GEN_VAT_ON_RI'), 'Y'),
                    'Y', (DECODE
                             (NVL (giacp.v ('GEN_TRTY_PREM_VAT'), 'N'),
                              'Y', (DECODE
                                       (NVL (giacp.v ('GEN_PREM_VAT_FOREIGN'),
                                             'N'
                                            ),
                                        'N', (DECODE
                                                 (k.local_foreign_sw,
                                                  'L', (  (SUM
                                                              (((  (  g.trty_shr_pct
                                                                    / 100
                                                                   )
                                                                 * NVL
                                                                      (e.dist_prem,
                                                                       0
                                                                      )
                                                                )
                                                               )
                                                              )
                                                          )
                                                        * (  k.input_vat_rate
                                                           / 100
                                                          )
                                                   ),
                                                  0
                                                 )
                                         ),
                                        (  (SUM (((  (g.trty_shr_pct / 100)
                                                   * NVL (e.dist_prem, 0)
                                                  )
                                                 )
                                                )
                                           )
                                         * (k.input_vat_rate / 100)
                                        )
                                       )
                               ),
                              0
                             )
                     ),
                    0
                   ),
                0
               ) fc_prem_vat,                  --lina 011006; judyann 10272009
            SUM (((  ((g.trty_shr_pct / 100) * NVL (e.dist_prem, 0))
                   * NVL (b.currency_rt, 1)
                   * (h.trty_com_rt / 100)
                  )
                 )
                ) commission_amt,
            NVL (SUM (((  ((g.trty_shr_pct / 100) * NVL (e.dist_prem, 0))
                        * (h.trty_com_rt / 100)
                       )
                      )
                     ),
                 0
                ) fc_comm_amt,
            NVL
               (DECODE (NVL (giacp.v ('GEN_VAT_ON_RI'), 'Y'),
                        'Y', (DECODE
                                    (NVL (giacp.v ('GEN_COMM_VAT_FOREIGN'),
                                          'Y'
                                         ),
                                     'N', (DECODE
                                              (k.local_foreign_sw,
                                               'L', (  (SUM
                                                           (((  (  (  g.trty_shr_pct
                                                                    / 100
                                                                   )
                                                                 * NVL
                                                                      (e.dist_prem,
                                                                       0
                                                                      )
                                                                )
                                                              * NVL
                                                                   (b.currency_rt,
                                                                    1
                                                                   )
                                                              * (  h.trty_com_rt
                                                                 / 100
                                                                )
                                                             )
                                                            )
                                                           )
                                                       )
                                                     * (k.input_vat_rate / 100
                                                       )
                                                ),
                                               0
                                              )
                                      ),
                                     (  (SUM (((  (  (g.trty_shr_pct / 100)
                                                   * NVL (e.dist_prem, 0)
                                                  )
                                                * NVL (b.currency_rt, 1)
                                                * (h.trty_com_rt / 100)
                                               )
                                              )
                                             )
                                        )
                                      * (k.input_vat_rate / 100)
                                     )
                                    )
                         ),
                        0
                       ),
                0
               ) comm_vat,                     --lina 011006; judyann 10272009
            NVL
               (DECODE (NVL (giacp.v ('GEN_VAT_ON_RI'), 'Y'),
                        'Y', (DECODE
                                    (NVL (giacp.v ('GEN_COMM_VAT_FOREIGN'),
                                          'Y'
                                         ),
                                     'N', (DECODE
                                              (k.local_foreign_sw,
                                               'L', (  (SUM
                                                           (((  (  (  g.trty_shr_pct
                                                                    / 100
                                                                   )
                                                                 * NVL
                                                                      (e.dist_prem,
                                                                       0
                                                                      )
                                                                )
                                                              * (  h.trty_com_rt
                                                                 / 100
                                                                )
                                                             )
                                                            )
                                                           )
                                                       )
                                                     * (k.input_vat_rate / 100
                                                       )
                                                ),
                                               0
                                              )
                                      ),
                                     (  (SUM (((  (  (g.trty_shr_pct / 100)
                                                   * NVL (e.dist_prem, 0)
                                                  )
                                                * (h.trty_com_rt / 100)
                                               )
                                              )
                                             )
                                        )
                                      * (k.input_vat_rate / 100)
                                     )
                                    )
                         ),
                        0
                       ),
                0
               ) fc_comm_vat,                  --lina 011006; judyann 10272009
            NVL
               (DECODE (NVL (giacp.v ('GEN_VAT_ON_RI'), 'Y'),
                        'Y', (DECODE (NVL (giacp.v ('GEN_TRTY_WHOLDING_VAT'),
                                           'N'
                                          ),
                                      'Y', (DECODE
                                               (k.local_foreign_sw,
                                                'A', (  (SUM
                                                            ((  (  (  g.trty_shr_pct
                                                                    / 100
                                                                   )
                                                                 * NVL
                                                                      (e.dist_prem,
                                                                       0
                                                                      )
                                                                )
                                                              * NVL
                                                                   (b.currency_rt,
                                                                    1
                                                                   )
                                                             )
                                                            )
                                                        )
                                                      * (k.input_vat_rate
                                                         / 100
                                                        )
                                                 ),
                                                'F', (  (SUM
                                                            ((  (  (  g.trty_shr_pct
                                                                    / 100
                                                                   )
                                                                 * NVL
                                                                      (e.dist_prem,
                                                                       0
                                                                      )
                                                                )
                                                              * NVL
                                                                   (b.currency_rt,
                                                                    1
                                                                   )
                                                             )
                                                            )
                                                        )
                                                      * (k.input_vat_rate
                                                         / 100
                                                        )
                                                 ),
                                                0
                                               )
                                       ),
                                      0
                                     )
                         ),
                        0
                       ),
                0
               ) ri_wholding_vat,
            NVL
               (DECODE (NVL (giacp.v ('GEN_VAT_ON_RI'), 'Y'),
                        'Y', (DECODE (NVL (giacp.v ('GEN_TRTY_WHOLDING_VAT'),
                                           'N'
                                          ),
                                      'Y', (DECODE
                                                (k.local_foreign_sw,
                                                 'A', (  (SUM
                                                             (((  (  g.trty_shr_pct
                                                                   / 100
                                                                  )
                                                                * NVL
                                                                     (e.dist_prem,
                                                                      0
                                                                     )
                                                               )
                                                              )
                                                             )
                                                         )
                                                       * (  k.input_vat_rate
                                                          / 100
                                                         )
                                                  ),
                                                 'F', (  (SUM
                                                             (((  (  g.trty_shr_pct
                                                                   / 100
                                                                  )
                                                                * NVL
                                                                     (e.dist_prem,
                                                                      0
                                                                     )
                                                               )
                                                              )
                                                             )
                                                         )
                                                       * (  k.input_vat_rate
                                                          / 100
                                                         )
                                                  ),
                                                 0
                                                )
                                       ),
                                      0
                                     )
                         ),
                        0
                       ),
                0
               ) fc_ri_wholding_vat,
            NVL (DECODE (NVL (giacp.v ('GEN_TRTY_PREMIUM_TAX'), 'N'),
                         'Y', (DECODE (k.local_foreign_sw,
                                       'A', (  (SUM ((  (  (  g.trty_shr_pct
                                                            / 100
                                                           )
                                                         * NVL (e.dist_prem,
                                                                0)
                                                        )
                                                      * NVL (b.currency_rt, 1)
                                                     )
                                                    )
                                               )
                                             * (  giisp.n ('RI PREMIUM TAX')
                                                / 100
                                               )
                                        ),
                                       'F', (  (SUM ((  (  (  g.trty_shr_pct
                                                            / 100
                                                           )
                                                         * NVL (e.dist_prem,
                                                                0)
                                                        )
                                                      * NVL (b.currency_rt, 1)
                                                     )
                                                    )
                                               )
                                             * (  giisp.n ('RI PREMIUM TAX')
                                                / 100
                                               )
                                        ),
                                       0
                                      )
                          ),
                         0
                        ),
                 0
                ) prem_tax,                                -- judyann 07162008
            NVL (DECODE (NVL (giacp.v ('GEN_TRTY_PREMIUM_TAX'), 'N'),
                         'Y', (DECODE (k.local_foreign_sw,
                                       'A', (  (SUM (((  (g.trty_shr_pct / 100
                                                         )
                                                       * NVL (e.dist_prem, 0)
                                                      )
                                                     )
                                                    )
                                               )
                                             * (  giisp.n ('RI PREMIUM TAX')
                                                / 100
                                               )
                                        ),
                                       'F', (  (SUM (((  (g.trty_shr_pct / 100
                                                         )
                                                       * NVL (e.dist_prem, 0)
                                                      )
                                                     )
                                                    )
                                               )
                                             * (  giisp.n ('RI PREMIUM TAX')
                                                / 100
                                               )
                                        ),
                                       0
                                      )
                          ),
                         0
                        ),
                 0
                ) fc_prem_tax,                             -- judyann 07162008
            g.trty_yy, g.ri_cd, e.peril_cd, 1 acct_intm_cd, f.acct_trty_type,
            a.reg_policy_sw, a.acct_ent_date acct_ent_date_pol,
            a.spld_acct_ent_date spld_acct_ent_date_pol,
            l.acct_ent_date acct_ent_date_inv,
            l.spoiled_acct_ent_date spoiled_acct_ent_date_inv,
            k.local_foreign_sw, l.takeup_seq_no                 --april 061009
       FROM gipi_polbasic a,
            gipi_invoice l,
            gipi_item b,
            giuw_pol_dist c,
            giuw_itemds d,
            giuw_itemperilds_dtl e,
            giis_dist_share f,
            giis_trty_panel g,
            giis_trty_peril h,
            giis_line i,
            giis_subline j,
            giis_reinsurer k                                            --lina
      WHERE 1 = 1
        --AND a.acct_ent_date IS NOT null
        AND l.acct_ent_date IS NOT NULL
        AND a.policy_id = l.policy_id
        AND a.policy_id = b.policy_id
        AND b.policy_id = c.policy_id
        AND NVL (l.takeup_seq_no, 1) = NVL (c.takeup_seq_no, 1)
        --added by april 060909  commented by alfie for optimization purposes
        --AND l.takeup_seq_no = c.takeup_seq_no --added by alfie 03102010  comment out by belle 05312010;optimization was handled by creating an index(pol_dist_fbi)
        AND b.item_no = d.item_no
        AND (   (    c.acct_ent_date IS NULL
                 AND c.dist_flag = 3
                 AND c.negate_date IS NULL
                )
             OR (    c.acct_ent_date IS NOT NULL
                 AND c.acct_neg_date IS NULL
                 AND c.dist_flag = 4
                 AND c.negate_date IS NOT NULL
                )
             OR (    c.acct_ent_date IS NOT NULL
                 AND c.dist_flag = 5
                 AND c.acct_neg_date IS NULL
                )
            )
        AND c.dist_no = d.dist_no
        AND d.dist_no = e.dist_no
        AND d.dist_seq_no = e.dist_seq_no
        AND d.item_no = e.item_no
        AND e.line_cd = f.line_cd
        AND e.share_cd = f.share_cd
        AND f.share_type = 2
        AND f.line_cd = g.line_cd
        AND f.share_cd = g.trty_seq_no
        AND f.trty_yy = g.trty_yy
        AND k.ri_cd = g.ri_cd                                           --lina
        AND e.line_cd = h.line_cd
        AND e.share_cd = h.trty_seq_no
        AND e.peril_cd = h.peril_cd
        AND a.line_cd = i.line_cd
        AND a.line_cd = j.line_cd
        AND a.subline_cd = j.subline_cd
        AND l.item_grp = b.item_grp                         -- jeremy 02022010
   GROUP BY NVL (a.cred_branch, a.iss_cd),
            a.iss_cd                               /*added by alfie 03152010*/
                    ,
            a.policy_id,
            b.currency_cd,
            b.currency_rt,
            c.negate_date,
            e.item_no,
            e.line_cd,
            i.acct_line_cd,
            j.acct_subline_cd,
            e.share_cd,
            g.funds_held_pct,
            f.funds_held_pct,
            c.dist_no,
            g.trty_yy,
            g.ri_cd,
            e.peril_cd,
            f.acct_trty_type,
            a.reg_policy_sw,
            a.acct_ent_date,
            a.spld_acct_ent_date,
            k.input_vat_rate,
            l.acct_ent_date,
            l.spoiled_acct_ent_date,               -- added by jeremy 02262010
            k.local_foreign_sw,
            l.takeup_seq_no;


