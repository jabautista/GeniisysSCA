DROP VIEW CPI.GIAC_COMM_VOUCHER_V3;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_comm_voucher_v3 (intm_no,
                                                       iss_cd,
                                                       prem_seq_no,
                                                       policy_id,
                                                       actual_comm,
                                                       comm_payable,
                                                       wtax_amt,
                                                       prem_amt,
                                                       comm_amt,
                                                       input_vat
                                                      )
AS
   SELECT intm_no, iss_cd, prem_seq_no, policy_id, actual_comm, comm_payable,
          wtax_amt, prem_amt, comm_amt, input_vat
     FROM giac_comm_voucher_v2
   UNION ALL
   SELECT   w.intrmdry_intm_no intm_no, w.iss_cd, w.prem_seq_no, w.policy_id,
            (  ((  ROUND ((  NVL (gcid.commission_amt, w.commission_amt)
                           * x.currency_rt
                          ),
                          2
                         )
                 - ROUND ((  NVL (c.wtax_amt, 0)
                           +   (  (  (  (NVL (y.premium_amt, 0))
                                      / DECODE (NVL (y.premium_amt, 0),
                                                0, 1,
                                                NULL, 1,
                                                NVL (y.premium_amt, 0)
                                               )
                                     )
                                   * NVL (gcid.commission_amt,
                                          w.commission_amt
                                         )
                                   * x.currency_rt
                                  )
                                - NVL (c.comm_amt_paid, 0)
                               )
                             * (NVL (a.wtax_rate, 0) / 100)
                          ),
                          2
                         )
                )
               )
             + ROUND ((  NVL (c.input_vat_paid, 0)
                       +   (  (  (  (NVL (gcid.premium_amt, w.premium_amt))
                                  / DECODE (NVL (gcid.premium_amt,
                                                 w.premium_amt
                                                ),
                                            0, 1,
                                            NULL, 1,
                                            NVL (gcid.premium_amt,
                                                 w.premium_amt
                                                )
                                           )
                                 )
                               * NVL (gcid.commission_amt, w.commission_amt)
                               * x.currency_rt
                              )
                            - NVL (c.comm_amt_paid, 0)
                           )
                         * (NVL (a.input_vat_rate, 0) / 100)
                      ),
                      2
                     )
            ) actual_comm,
            
--            (  NVL (gcid.commission_amt * (gcid.share_percentage / 100),
--                    w.commission_amt
--                   )
--             - NVL (gcid.wholding_tax * (gcid.share_percentage / 100),
--                    w.wholding_tax
--                   )
--             + ROUND ((  NVL (c.input_vat_paid, 0)
--                       +   (    (  NVL (  gcid.premium_amt
--                                        * (gcid.share_percentage / 100),
--                                        w.premium_amt
--                                       )
--                                 / DECODE (NVL (  gcid.premium_amt
--                                                * (gcid.share_percentage / 100
--                                                  ),
--                                                  w.premium_amt
--                                                * (w.share_percentage / 100)
--                                               ),
--                                           0, 1,
--                                           NULL, 1,
--                                           NVL (gcid.premium_amt,
--                                                w.premium_amt
--                                               )
--                                          )
--                                )
--                              * NVL (  gcid.commission_amt
--                                     * (gcid.share_percentage / 100),
--                                       w.commission_amt
--                                     * (w.share_percentage / 100)
--                                    )
--                            - NVL (c.comm_amt_paid, 0)
--                           )
--                         * (NVL (a.input_vat_rate, 0) / 100)
--                      ),
--                      2
--                     )
--            ) actual_comm,
              ROUND (SUM ((( (NVL(y.premium_amt,((DECODE (x.prem_amt, --added by steven 11.12.2014 to make the result of the division equal to 1 when the premium is not yet partially paid. Nagiging null kasi pag di pa bayad or partially paid. 
                                                              0, 1,
                                                              NULL, 1,
                                                              x.prem_amt
                                                             )
                                                     )*x.currency_rt))
                               / -- added decode to prevent divisor is equal to zero error : shan 03.24.2015 -- AFP SR-18481 : shan 05.21.2015
                               DECODE(((DECODE (x.prem_amt, 0, 1, NULL, 1, x.prem_amt)) * x.currency_rt), 0, 1, ((DECODE (x.prem_amt, 0, 1, NULL, 1, x.prem_amt)) * x.currency_rt))
                              ) 
                            * (  NVL (gcid.commission_amt, w.commission_amt)
                               * x.currency_rt
                              )
                           )
                          )
                         ),
                     2
                    )	-- AFP SR-18481 : shan 05.21.2015
            + ROUND (SUM ((  NVL (c.input_vat_paid, 0)
                           +   (  (  (  NVL (y.premium_amt, 0)
                                      * (  NVL (gcid.share_percentage,
                                                w.share_percentage
                                               )
                                         / 100
                                        )
                                      / DECODE (NVL (y.premium_amt, 0),
                                                0, 1,
                                                NULL, 1,
                                                NVL (y.premium_amt, 0)
                                               )
                                     )                                     --,
                                   * NVL (gcid.commission_amt,
                                          w.commission_amt
                                         )
                                  )
                                - NVL (c.comm_amt_paid, 0)
                               )
                             * (NVL (a.input_vat_rate, 0) / 100)
                          )
                         ),
                     2
                    )
            - ROUND (  (  (  SUM ((  (  NVL (y.premium_amt, 0)
                                      * (  NVL (gcid.share_percentage,
                                                w.share_percentage
                                               )
                                         / 100
                                        )
                                      / DECODE (  NVL (y.premium_amt, 0)
                                                * x.currency_rt,
                                                0, 1,
                                                NULL, 1,
                                                  NVL (y.premium_amt, 0)
                                                * x.currency_rt
                                               )
                                     )
                                   * (  NVL (gcid.commission_amt,
                                             w.commission_amt
                                            )
                                      * x.currency_rt
                                     )
                                  )
                                 )
                           - SUM (NVL (c.comm_amt_paid, 0))
                          )
                        * (NVL (a.wtax_rate, 1) / 100)
                       )
                     + SUM (NVL (wtax_amt, 0)),
                     2
                    ) comm_payable,
            
--            (  NVL (gcid.commission_amt * (gcid.share_percentage / 100),
--                    w.commission_amt
--                   )
--             - NVL (gcid.wholding_tax * (gcid.share_percentage / 100),
--                    w.wholding_tax
--                   )
--             + ROUND ((  NVL (c.input_vat_paid, 0)
--                       +   (    (  NVL (  gcid.premium_amt
--                                        * (gcid.share_percentage / 100),
--                                        w.premium_amt
--                                       )
--                                 / DECODE (NVL (  gcid.premium_amt
--                                                * (gcid.share_percentage / 100
--                                                  ),
--                                                  w.premium_amt
--                                                * (w.share_percentage / 100)
--                                               ),
--                                           0, 1,
--                                           NULL, 1,
--                                           NVL (gcid.premium_amt,
--                                                w.premium_amt
--                                               )
--                                          )
--                                )
--                              * NVL (  gcid.commission_amt
--                                     * (gcid.share_percentage / 100),
--                                       w.commission_amt
--                                     * (w.share_percentage / 100)
--                                    )
--                            - NVL (c.comm_amt_paid, 0)
--                           )
--                         * (NVL (a.input_vat_rate, 0) / 100)
--                      ),
--                      2
--                     )
--            ) comm_payable,
            ROUND (  (  (  SUM ((  (  NVL (y.premium_amt, 0)
                                    * (  NVL (gcid.share_percentage,
                                              w.share_percentage
                                             )
                                       / 100
                                      )
                                    / DECODE (  NVL (y.premium_amt, 0)
                                              * x.currency_rt,
                                              0, 1,
                                              NULL, 1,
                                                NVL (y.premium_amt, 0)
                                              * x.currency_rt
                                             )
                                   )
                                 * (  NVL (gcid.commission_amt,
                                           w.commission_amt
                                          )
                                    * x.currency_rt
                                   )
                                )
                               )
                         - SUM (NVL (c.comm_amt_paid, 0))
                        )
                      * (NVL (a.wtax_rate, 1) / 100)
                     )
                   + SUM (NVL (wtax_amt, 0)),
                   2
                  ) wtax_amt,
--            ROUND (SUM (NVL (gcid.wholding_tax
--                             * (gcid.share_percentage / 100),
--                             w.wholding_tax * (w.share_percentage / 100)
--                            )
--                       ),
--                   2
--                  ) wtax_amt,
            NVL (SUM (y.premium_amt), 0) prem_amt,
            
              /*(  NVL (gcid.commission_amt * (gcid.share_percentage / 100),
                      w.commission_amt
                     )
               - NVL (gcid.wholding_tax * (gcid.share_percentage / 100),
                      w.wholding_tax
                     )
               + ROUND ((  NVL (c.input_vat_paid, 0)
                         +   (    (  NVL (  gcid.premium_amt
                                          * (gcid.share_percentage / 100),
                                          w.premium_amt
                                         )
                                   / DECODE (NVL (  gcid.premium_amt
                                                  * (  gcid.share_percentage
                                                     / 100
                                                    ),
                                                    w.premium_amt
                                                  * (w.share_percentage / 100
                                                    )
                                                 ),
                                             0, 1,
                                             NULL, 1,
                                             NVL (gcid.premium_amt,
                                                  w.premium_amt
                                                 )
                                            )
                                  )
                                * NVL (  gcid.commission_amt
                                       * (gcid.share_percentage / 100),
                                         w.commission_amt
                                       * (w.share_percentage / 100)
                                      )
                              - NVL (c.comm_amt_paid, 0)
                             )
                           * (NVL (a.input_vat_rate, 0) / 100)
                        ),
                        2
                       )
              )
            - get_comm_paid (w.intrmdry_intm_no, w.iss_cd, w.prem_seq_no)
                                                                     comm_amt,*/--modified by pol, 01.23.2014, based on giac_comm_voucher_v, as per sir jm
            ROUND (SUM ((  (  NVL (y.premium_amt, 0)
                            * (  NVL (gcid.share_percentage,
                                      w.share_percentage
                                     )
                               / 100
                              )
                            / DECODE (  NVL (gcid.premium_amt, w.premium_amt)
                                      * x.currency_rt,
                                      0, 1,
                                      NULL, 1,
                                        NVL (gcid.premium_amt, w.premium_amt)
                                      * x.currency_rt
                                     )
                           )
                         * NVL (gcid.commission_amt, w.commission_amt)
                         * x.currency_rt
                        )
                       ),
                   2
                  ) comm_amt,
            ROUND
               
               -- comment by sir jm, 5.12.2014, to tally the value of input_vat with giac_comm_voucher_v.input_vat
            (   SUM (                              --NVL (c.input_vat_paid, 0)
                     
                     -- +
                     ( /* NVL (  gcid.commission_amt
                                * (gcid.share_percentage / 100),
                                w.commission_amt
                               )
                         - NVL (  gcid.wholding_tax
                                * (gcid.share_percentage / 100),
                                w.wholding_tax
                               )
                         +*/ROUND
                               ((  NVL (c.input_vat_paid, 0)
                                 +   (    (  NVL (  gcid.premium_amt
                                                  * (  gcid.share_percentage
                                                     / 100
                                                    ),
                                                  w.premium_amt
                                                 )
                                           / DECODE
                                                (NVL
                                                    (  gcid.premium_amt
                                                     * (  gcid.share_percentage
                                                        / 100
                                                       ),
                                                       w.premium_amt
                                                     * (  w.share_percentage
                                                        / 100
                                                       )
                                                    ),
                                                 0, 1,
                                                 NULL, 1,
                                                 NVL (gcid.premium_amt,
                                                      w.premium_amt
                                                     )
                                                )
                                          )
                                        * NVL (  gcid.commission_amt
                                               * (gcid.share_percentage / 100
                                                 ),
                                                 w.commission_amt
                                               * (w.share_percentage / 100)
                                              )
                                      - NVL (c.comm_amt_paid, 0)
                                     )
                                   * (NVL (a.input_vat_rate, 0) / 100)
                                ),
                                2
                               )
                     )
                    --* (NVL (a.input_vat_rate, 0) / 100) -- comment by sir jm, 5.12.2014, to tally the value of input_vat with giac_comm_voucher_v.input_vat
                    ),
                2
               ) input_vat
       FROM gipi_comm_invoice w,
            gipi_invoice x,
            giis_intermediary a,
            gipi_comm_inv_dtl gcid,
            (SELECT   m.b140_iss_cd, m.b140_prem_seq_no,
                      SUM (m.premium_amt) premium_amt
                 FROM giac_direct_prem_collns m, giac_acctrans n
                WHERE m.gacc_tran_id = n.tran_id
                  AND n.tran_flag <> 'D'
                  AND NOT EXISTS (
                         SELECT 'X'
                           FROM giac_reversals s, giac_acctrans t
                          WHERE s.reversing_tran_id = t.tran_id
                            AND t.tran_flag != 'D'
                            AND s.gacc_tran_id = m.gacc_tran_id)
             GROUP BY m.b140_iss_cd, m.b140_prem_seq_no) y,
            (SELECT   j.intm_no, j.iss_cd, j.prem_seq_no,
                      SUM (j.comm_amt) comm_amt_paid,
                      SUM (j.wtax_amt) wtax_amt,
                      SUM (j.input_vat_amt) input_vat_paid
                 FROM giac_comm_payts j, giac_acctrans k
                WHERE j.gacc_tran_id = k.tran_id
                  AND k.tran_flag <> 'D'
                  AND NOT EXISTS (
                         SELECT 'X'
                           FROM giac_reversals s, giac_acctrans t
                          WHERE s.reversing_tran_id = t.tran_id
                            AND t.tran_flag != 'D'
                            AND s.gacc_tran_id = j.gacc_tran_id)
             GROUP BY j.intm_no, j.iss_cd, j.prem_seq_no) c
      WHERE 1 = 1
        AND y.b140_iss_cd(+) = x.iss_cd
        AND y.b140_prem_seq_no(+) = x.prem_seq_no
        AND w.intrmdry_intm_no = a.intm_no
        AND w.intrmdry_intm_no = gcid.intrmdry_intm_no(+)
        AND w.intrmdry_intm_no = c.intm_no(+)
        AND w.iss_cd = x.iss_cd
        AND w.iss_cd = gcid.iss_cd(+)
        AND w.iss_cd = c.iss_cd(+)
        AND w.prem_seq_no = x.prem_seq_no
        AND w.prem_seq_no = gcid.prem_seq_no(+)
        AND w.prem_seq_no = c.prem_seq_no(+)
        AND w.intrmdry_intm_no >= 0
   GROUP BY a.input_vat_rate,
            w.intrmdry_intm_no,
            w.iss_cd,
            w.prem_seq_no,
            w.policy_id,
            (  ((  ROUND ((  NVL (gcid.commission_amt, w.commission_amt)
                           * x.currency_rt
                          ),
                          2
                         )
                 - ROUND ((  NVL (c.wtax_amt, 0)
                           +   (  (  (  (NVL (y.premium_amt, 0))
                                      / DECODE (NVL (y.premium_amt, 0),
                                                0, 1,
                                                NULL, 1,
                                                NVL (y.premium_amt, 0)
                                               )
                                     )
                                   * NVL (gcid.commission_amt,
                                          w.commission_amt
                                         )
                                   * x.currency_rt
                                  )
                                - NVL (c.comm_amt_paid, 0)
                               )
                             * (NVL (a.wtax_rate, 0) / 100)
                          ),
                          2
                         )
                )
               )
             + ROUND ((  NVL (c.input_vat_paid, 0)
                       +   (  (  (  (NVL (gcid.premium_amt, w.premium_amt))
                                  / DECODE (NVL (gcid.premium_amt,
                                                 w.premium_amt
                                                ),
                                            0, 1,
                                            NULL, 1,
                                            NVL (gcid.premium_amt,
                                                 w.premium_amt
                                                )
                                           )
                                 )
                               * NVL (gcid.commission_amt, w.commission_amt)
                               * x.currency_rt
                              )
                            - NVL (c.comm_amt_paid, 0)
                           )
                         * (NVL (a.input_vat_rate, 0) / 100)
                      ),
                      2
                     )
            ),
            NVL (a.wtax_rate, 1);


