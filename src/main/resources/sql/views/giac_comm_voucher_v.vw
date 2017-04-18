DROP VIEW CPI.GIAC_COMM_VOUCHER_V;

/* Formatted on 2015/08/03 17:51 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_comm_voucher_v (intm_no,
                                                      parent_intm_no,
                                                      iss_cd,
                                                      prem_seq_no,
                                                      policy_id,
                                                      actual_comm,
                                                      comm_payable,
                                                      wtax_amt,
                                                      prem_amt,
                                                      comm_amt,
                                                      input_vat,
                                                      inv_prem_amt,
                                                      net_comm_paid,
                                                      comm_paid,
                                                      wtax_paid,
                                                      input_vat_paid,
                                                      payment_date
                                                     )
AS
   SELECT intm_no, parent_intm_no, iss_cd, prem_seq_no, policy_id,
          actual_comm,
                      --Vincent 01252007: added select for giac_comm_voucher_v2
                      comm_payable, wtax_amt, prem_amt, comm_amt, input_vat,
          inv_prem_amt, net_comm_paid, comm_paid, wtax_paid, input_vat_paid,
          payment_date
     FROM giac_comm_voucher_v2
   UNION ALL
   /* judyann 12282009; removed multiplier share_percentage to amounts taken from gipi_comm_invoice and gipi_comm_inv_dtl */
   /* judyann 06182010; conversion of amounts to local currency */
   SELECT   w.intrmdry_intm_no intm_no,
            NVL (a.parent_intm_no, a.intm_no) parent_intm_no, w.iss_cd,
            w.prem_seq_no, w.policy_id,
            
            /* mikel 08.25.2011; convert comm_amt and wholding_tax to local currency before subtracting the amounts to get net of tax amount */
            /* mikel 08.25.2011; get the correct currency rate before converting input vat to local currency */
            /*(ROUND
                        (  (  (  NVL (gcid.commission_amt, w.commission_amt)
                               - NVL (gcid.wholding_tax, w.wholding_tax)
                              )
                            * x.currency_rt
                 ),
                 2
                ) */
            --mikel 08.25.2011; comment out, replaced by codes below
            (  ((  ROUND ((  NVL (gcid.commission_amt, w.commission_amt)
                           * x.currency_rt
                          ),
                          2
                         )
                 --                 - ROUND ((  NVL (gcid.wholding_tax, w.wholding_tax)
                 --                           * x.currency_rt
                 --                          ),
                 --                          2
                 --                         )
                 /*Commented out by reymon and changed for correct witholding tax formula 10112013
                                  - ROUND (  (  NVL (gcid.commission_amt, w.commission_amt)
                                              * x.currency_rt
                                             )
                                           * (NVL (a.wtax_rate, 1) / 100),
                                           2
                                          )
                 end reymon*/
                 - ROUND ((  NVL (c.wtax_amt, 0)
                           +   (  (  (  (NVL (gcid.premium_amt, w.premium_amt)
                                        )
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
             + ROUND
                  ((  NVL (c.input_vat_paid, 0)
                    +   (  (                    /*ROUND ronnieCD removed round
                                                   (*/
                              (  (NVL (gcid.premium_amt, w.premium_amt)
                                 )       --Vincent 01252007: use w.premium_amt
                               / DECODE (NVL (gcid.premium_amt, w.premium_amt),
                                         0, 1,
                                         NULL, 1,
                                         NVL (gcid.premium_amt, w.premium_amt)
                                        )
                              )
                             --,
                             /*--mikel 08.25.2011; round off based on number of decimal of currency rate on gipi_invoice to get the correct currency rate */
                             /*LENGTH (SUBSTR (x.currency_rt,
                                               INSTR (x.currency_rt, '.')
                                             + 1
                                            )
                                    )
                            ) ronnieCD removed round*/
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
            
              /* mikel 08.25.2011; get the correct currency rate before converting commission amount and input vat to local currency */
              --modified by lina added the function get_max_inst_no 08222007
              ROUND (SUM (((                 /*ROUND (ronnieCD removed round*/
                              (  y.premium_amt
                               / (DECODE (x.prem_amt * x.currency_rt, --koks multiply prem amt by rate 8.3.2015
                                          0, 1,
                                          NULL, 1,
                                          x.prem_amt * x.currency_rt
                                         )
                                 )
                              )                                            --,
                                  /*--mikel 08.25.2011; round off based on number of decimal of currency rate on gipi_invoice to get the correct currency rate */
                                  /*LENGTH (SUBSTR (x.currency_rt,
                                                    INSTR (x.currency_rt, '.')
                                                  + 1
                            )
                                         )
                                 )ronnieCD removed round*/
                            * (  NVL (gcid.commission_amt, w.commission_amt)
                               * x.currency_rt
                              )
                           )
                          )
                         ),
                     2
                    )
            + ROUND
                 (SUM
                     ((  NVL (c.input_vat_paid, 0)
                       +             --(((NVL(gcid.premium_amt, w.premium_amt)
                           (  (                                    /*ROUND (*/
                                 (  NVL (y.premium_amt, 0)
                                  * (  NVL (gcid.share_percentage,
                                            w.share_percentage
                                           )
                                     / 100
                                    )
                                  -- judyann 10292008; paid/receivable
                                  / DECODE (NVL (gcid.premium_amt,
                                                 w.premium_amt
                                                ),
                                            0, 1,
                                            NULL, 1,
                                            NVL (gcid.premium_amt,
                                                 w.premium_amt
                                                )
                                           )
                                 )                                         --,
                                    /*--mikel 08.25.2011; round off based on number of decimal of currency rate on gipi_invoice to get the correct currency rate */
                                    /*LENGTH (SUBSTR (x.currency_rt,
                                                      INSTR
                                                           (x.currency_rt,
                                                            '.'
                                                           )
                                                    + 1
                               )
                                           )
                                   )*/
                               * NVL (gcid.commission_amt, w.commission_amt)
                              )
                            - NVL (c.comm_amt_paid
/*/NVL(Get_Max_Inst_No(Y.B140_ISS_CD, Y.B140_PREM_SEQ_NO),1)--roset, seici prf 4484*/
                                   , 0)
                           )
                         * (NVL (a.input_vat_rate, 0) / 100)
                      )
                     ),
                  2
                 )
            /*Commented out by reymon and changed for correct witholding tax formula 10112013
                        - ROUND (SUM ((  (  y.premium_amt
                                          / (  DECODE (x.prem_amt,
                                                       0, 1,
                                                       NULL, 1,
                                                       x.prem_amt
                                                      )
                                             * x.currency_rt
                                            )
                                         )
                                       --* NVL (gcid.wholding_tax, w.wholding_tax)
                                       --* x.currency_rt
                                       * (  NVL (gcid.commission_amt, w.commission_amt)
                                       * x.currency_rt
                                      )
                                       * (NVL (a.wtax_rate, 1) / 100)                --rcd
                                      )
                                     ),
                                 2
                                )
            end reymon*/
            - ROUND (  (  (  SUM ((  (  NVL (y.premium_amt, 0)
                                      * (  NVL (gcid.share_percentage,
                                                w.share_percentage
                                               )
                                         / 100
                                        )
                                      / DECODE (  NVL (gcid.premium_amt,
                                                       w.premium_amt
                                                      )
                                                * x.currency_rt,
                                                0, 1,
                                                NULL, 1,
                                                  NVL (gcid.premium_amt,
                                                       w.premium_amt
                                                      )
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
            
                        /*ROUND
                           (SUM ((  (  NVL (y.premium_amt, 0)
                                     * (  NVL (gcid.share_percentage, w.share_percentage)
                                        / 100
                                       )
                                     / DECODE (  NVL (gcid.premium_amt, w.premium_amt)
                                               * x.currency_rt,
                                               0, 1,
                                               NULL, 1,
                                                 NVL (gcid.premium_amt, w.premium_amt)
                                               * x.currency_rt
                                              )
                                    )                                  --* x.currency_rt))
            -- ronnie begin here 09.02.2013
            --                      * NVL (gcid.wholding_tax, w.wholding_tax)
            --                      * x.currency_rt
                                  * (  NVL (gcid.commission_amt, w.commission_amt)
                                  * x.currency_rt
                                 )
                                  * (NVL (a.wtax_rate, 1) / 100)
            -- ronnie end here 09.02.2013
                                 )
                                ),
                            2
                           ) wtax_amt,                           --edited by lina 09132005*/
                        --Commented out by reymon and changed for correct witholding tax formula 10112013
            ROUND (  (  (  SUM ((  (  NVL (y.premium_amt, 0)
                                    * (  NVL (gcid.share_percentage,
                                              w.share_percentage
                                             )
                                       / 100
                                      )
                                    / DECODE (  NVL (gcid.premium_amt,
                                                     w.premium_amt
                                                    )
                                              * x.currency_rt,
                                              0, 1,
                                              NULL, 1,
                                                NVL (gcid.premium_amt,
                                                     w.premium_amt
                                                    )
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
            
            --reymon end
            NVL (SUM (y.premium_amt), 0) prem_amt,
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
                  ) comm_amt,                        --edited by lina 09132005
            
            --modified by lina added the function get_max_inst_no 08222007
            ROUND
               (SUM
                   (  NVL (c.input_vat_paid, 0)
                    +                 --((NVL(gcid.premium_amt, w.premium_amt)
                        (    (  NVL (y.premium_amt, 0)
                              * (  NVL (gcid.share_percentage,
                                        w.share_percentage
                                       )
                                 / 100
                                )         -- judyann 10292008; paid/receivable
                              / DECODE ((  NVL (gcid.premium_amt,
                                                w.premium_amt
                                               )
                                         * x.currency_rt
                                        ),
                                        0, 1,
                                        NULL, 1,
                                        (  NVL (gcid.premium_amt,
                                                w.premium_amt
                                               )
                                         * x.currency_rt
                                        )
                                       )
                             )
                           * (  NVL (gcid.commission_amt, w.commission_amt)
                              * x.currency_rt
                             )
                         - NVL (c.comm_amt_paid
                                                       /* / NVL (Get_Max_Inst_No (y.b140_iss_cd,
                                                                y.b140_prem_seq_no
                                                               ),
                                               1
                                                              )--roset, seici prf 4484*/
                                , 0)
                        )
                      * (NVL (a.input_vat_rate, 0) / 100)
                   ),
                2
               ) input_vat,                                -- judyann 06102006
            ROUND (SUM (NVL (x.prem_amt * x.currency_rt, 0)), 2) inv_prem_amt,
            
            --mikel 05.12.2011 round off

            -- alfie 07122010
            SUM (  NVL (c.comm_amt_paid, 0)
                 - NVL (c.wtax_amt, 0)
                 + NVL (c.input_vat_paid, 0)
                ) net_comm_paid,
            SUM (NVL (c.comm_amt_paid, 0)) comm_paid,
            SUM (NVL (wtax_amt, 0)) wtax_paid,
            SUM (NVL (input_vat_paid, 0)) input_vat_paid,
            MAX (payment_date) payment_date
       FROM gipi_comm_invoice w,
            gipi_invoice x,
            giis_intermediary a,
            gipi_comm_inv_dtl gcid,                          --issa 08.08.2005
            (SELECT   m.b140_iss_cd, m.b140_prem_seq_no,
                      SUM (m.premium_amt) premium_amt,
                      MAX (n.tran_date) payment_date
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
            
            -- judyann 09042007; to handle multiple premium collection records
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
      -- judyann 06102006
   WHERE    1 = 1
        AND y.b140_iss_cd = x.iss_cd
        AND y.b140_prem_seq_no = x.prem_seq_no
        AND w.intrmdry_intm_no = a.intm_no
        AND w.intrmdry_intm_no = gcid.intrmdry_intm_no(+)    --issa 08.08.2005
        AND w.intrmdry_intm_no = c.intm_no(+)              -- judyann 06102006
        AND w.iss_cd = x.iss_cd
        AND w.iss_cd = gcid.iss_cd(+)                        --issa 08.08.2005
        AND w.iss_cd = c.iss_cd(+)                         -- judyann 06102006
        AND w.prem_seq_no = x.prem_seq_no
        AND w.prem_seq_no = gcid.prem_seq_no(+)              --issa 08.08.2005
        AND w.prem_seq_no = c.prem_seq_no(+)               -- judyann 06102006
        AND w.intrmdry_intm_no >= 0
   GROUP BY a.input_vat_rate,                                           --issa
            w.intrmdry_intm_no,
            NVL (a.parent_intm_no, a.intm_no),
            w.iss_cd,
            w.prem_seq_no,
            w.policy_id,
            (  ((  ROUND ((  NVL (gcid.commission_amt, w.commission_amt)
                           * x.currency_rt
                          ),
                          2
                         )
                 --                 - ROUND ((  NVL (gcid.wholding_tax, w.wholding_tax)
                 --                           * x.currency_rt
                 --                          ),
                 --                          2
                 --                         )
                 /*start emon
                                  - ROUND (  (  NVL (gcid.commission_amt, w.commission_amt)
                                              * x.currency_rt
                                             )
                                           * (NVL (a.wtax_rate, 1) / 100),
                                           2
                                          )
                 end emon*/
                 - ROUND ((  NVL (c.wtax_amt, 0)
                           +   (  (  (  (NVL (gcid.premium_amt, w.premium_amt)
                                        )
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
             + ROUND
                  ((  NVL (c.input_vat_paid, 0)
                    +   (  (                    /*ROUND ronnieCD removed round
                                                   (*/
                              (  (NVL (gcid.premium_amt, w.premium_amt)
                                 )       --Vincent 01252007: use w.premium_amt
                               / DECODE (NVL (gcid.premium_amt, w.premium_amt),
                                         0, 1,
                                         NULL, 1,
                                         NVL (gcid.premium_amt, w.premium_amt)
                                        )
                              )
                             --,
                             /*--mikel 08.25.2011; round off based on number of decimal of currency rate on gipi_invoice to get the correct currency rate */
                             /*LENGTH (SUBSTR (x.currency_rt,
                                               INSTR (x.currency_rt, '.')
                                             + 1
                                            )
                                    )
                            ) ronnieCD removed round*/
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


DROP PUBLIC SYNONYM GIAC_COMM_VOUCHER_V;

CREATE PUBLIC SYNONYM GIAC_COMM_VOUCHER_V FOR CPI.GIAC_COMM_VOUCHER_V;

