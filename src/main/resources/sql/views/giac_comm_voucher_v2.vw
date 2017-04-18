DROP VIEW CPI.GIAC_COMM_VOUCHER_V2;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_comm_voucher_v2 (intm_no,
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
   SELECT
/*Created By  : Vincent
          **Date Created: 01252007
          **Description : This view selects bills with zero prem but with comm. Based from and used by giac_comm_voucher_v.
          */
/* modified by judyann 12282009
** removed multiplier share_percentage to amounts taken from gipi_comm_invoice and gipi_comm_inv_dtl
*/
            w.intrmdry_intm_no intm_no,
            NVL (a.parent_intm_no, a.intm_no) parent_intm_no, w.iss_cd,
            w.prem_seq_no, w.policy_id,
              ROUND (  NVL (gcid.commission_amt, w.commission_amt)
                     * x.currency_rt,
                     2
                    )
            - ROUND (NVL (gcid.wholding_tax, w.wholding_tax) * x.currency_rt,
                     2)
            + ROUND (  NVL (c.input_vat_paid, 0)
                     +   (    NVL (gcid.commission_amt, w.commission_amt)
                            * x.currency_rt
                          - NVL (c.comm_amt, 0)
                         )
                       * (NVL (a.input_vat_rate, 0) / 100),
                     2
                    ) actual_comm,
              ROUND (SUM (  NVL (gcid.commission_amt, w.commission_amt)
                          * x.currency_rt
                         ),
                     2
                    )
            - ROUND (SUM (  NVL (gcid.wholding_tax, w.wholding_tax)
                          * x.currency_rt
                         ),
                     2
                    )
            + ROUND (SUM (  NVL (c.input_vat_paid, 0)
                          +   (    NVL (gcid.commission_amt, w.commission_amt)
                                 * x.currency_rt
                               - NVL (c.comm_amt, 0)
                              )
                            * (NVL (a.input_vat_rate, 0) / 100)
                         ),
                     2
                    ) comm_payable,
            ROUND (SUM (NVL (gcid.wholding_tax, w.wholding_tax)
                        * x.currency_rt),
                   2
                  ) wtax_amt,
            0 prem_amt,
            ROUND (SUM (  NVL (gcid.commission_amt, w.commission_amt)
                        * x.currency_rt
                       ),
                   2
                  ) comm_amt,
            ROUND (SUM (  NVL (c.input_vat_paid, 0)
                        +   (    NVL (gcid.commission_amt, w.commission_amt)
                               * x.currency_rt
                             - NVL (c.comm_amt, 0)
                            )
                          * (NVL (a.input_vat_rate, 0) / 100)
                       ),
                   2
                  ) input_vat,
            0 inv_prem_amt                                   -- alfie 07122010
                          ,
            SUM (  NVL (c.comm_amt, 0)
                 - NVL (wtax_amt, 0)
                 - NVL (input_vat_paid, 0)
                ) net_comm_paid,
            SUM (NVL (c.comm_amt, 0)) comm_paid,
            SUM (NVL (wtax_amt, 0)) wtax_paid,
            SUM (NVL (input_vat_paid, 0)) input_vat_paid,
            x.due_date payment_date
       FROM gipi_comm_invoice w,
            gipi_invoice x,
            giis_intermediary a,
            gipi_comm_inv_dtl gcid,
            (SELECT   j.intm_no, j.iss_cd, j.prem_seq_no,
                      SUM (j.comm_amt) comm_amt, SUM (j.wtax_amt) wtax_amt,
                      SUM (j.input_vat_amt) input_vat_paid,
                      MAX (tran_date) payment_date
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
        AND x.prem_amt = 0
        AND w.commission_amt <> 0
        AND   ROUND (  NVL (gcid.commission_amt, w.commission_amt)
                     * x.currency_rt,
                     2
                    )
            - ROUND (NVL (gcid.wholding_tax, w.wholding_tax) * x.currency_rt,
                     2)
            + ROUND (  NVL (c.input_vat_paid, 0)
                     +   (    NVL (gcid.commission_amt, w.commission_amt)
                            * x.currency_rt
                          - NVL (c.comm_amt, 0)
                         )
                       * (NVL (a.input_vat_rate, 0) / 100),
                     2
                    ) <> 0
   GROUP BY a.input_vat_rate,
            w.intrmdry_intm_no,
            NVL (a.parent_intm_no, a.intm_no),
            w.iss_cd,
            w.prem_seq_no,
            w.policy_id,
              ROUND (  NVL (gcid.commission_amt, w.commission_amt)
                     * x.currency_rt,
                     2
                    )
            - ROUND (NVL (gcid.wholding_tax, w.wholding_tax) * x.currency_rt,
                     2)
            + ROUND (  NVL (c.input_vat_paid, 0)
                     +   (    NVL (gcid.commission_amt, w.commission_amt)
                            * x.currency_rt
                          - NVL (c.comm_amt, 0)
                         )
                       * (NVL (a.input_vat_rate, 0) / 100),
                     2
                    ),
            x.due_date;


