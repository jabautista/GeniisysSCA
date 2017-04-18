DROP VIEW CPI.GIAC_PAID_PREM_COMM_DUE_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_paid_prem_comm_due_v (policy_id,
                                                            line_cd,
                                                            cred_branch,
                                                            assd_no,
                                                            iss_cd,
                                                            prem_seq_no,
                                                            inst_no,
                                                            intm_no,
                                                            parent_intm_no,
                                                            peril_cd,
                                                            gross_premium,
                                                            premium_paid,
                                                            premium_os,
                                                            comm_invoice,
                                                            net_comm_paid,
                                                            commission_due,
                                                            wholding_tax_due,
                                                            input_vat_due,
                                                            net_comm_due,
                                                            commission_rt,
                                                            intm_type,
                                                            parent_intm_type,
                                                            payment_date,
                                                            bank_ref_no
                                                           )
AS
   SELECT i.policy_id, i.line_cd, i.cred_branch, i.assd_no, i.iss_cd,
          i.prem_seq_no, i.inst_no, i.intrmdry_intm_no intm_no,
          i.parent_intm_no, i.peril_cd,
          ROUND (NVL (i.premium_amt, 0), 2) gross_premium,
          ROUND (NVL (p.premium_amt, 0), 2) premium_paid,
          ROUND (NVL (i.premium_amt, 0) - NVL (p.premium_amt, 0),
                 2) premium_os,
          
          --ROUND((NVL(i.commission_amt,0)-NVL(i.wholding_tax,0)+NVL(m.input_vat_amt,0)),2) comm_invoice,
          ROUND ((  NVL (i.commission_amt, 0)
                  - NVL (i.wholding_tax, 0)
                  + (  (NVL (i.commission_amt, 0) - NVL (m.comm_amt, 0))
                     * (i.input_vat_rate / 100)
                    )
                  + NVL (m.input_vat_amt, 0)
                 ),
                 2
                ) comm_invoice,
          ROUND ((  NVL (m.comm_amt, 0)
                  - NVL (m.wtax_amt, 0)
                  + NVL (m.input_vat_amt, 0)
                 ),
                 2
                ) net_comm_paid,
          ROUND (NVL (i.commission_amt, 0) - NVL (m.comm_amt, 0),
                 2
                ) commission_due,
          DECODE
             (ROUND (NVL (i.wholding_tax, 0) - NVL (m.wtax_amt, 0), 2),
              -0.01, ROUND (NVL (i.wholding_tax, 0) - NVL (m.wtax_amt, 0), 2)
               + 0.01,
              0.01, ROUND (NVL (i.wholding_tax, 0) - NVL (m.wtax_amt, 0), 2)
               - 0.01,
              ROUND (NVL (i.wholding_tax, 0) - NVL (m.wtax_amt, 0), 2)
             )        --modified by alfie: to handle 0.01 discrepancy 07122010
                                                             wholding_tax_due,
          
          --ROUND(NVL(i.input_vat,0)-NVL(m.input_vat_amt,0),2) input_vat_due,
          ROUND ((  (NVL (i.commission_amt, 0) - NVL (m.comm_amt, 0))
                  * (i.input_vat_rate / 100)
                 ),
                 2
                ) input_vat_due,
          
          --ROUND(((NVL(i.commission_amt,0)-NVL(m.comm_amt,0))
          --      -(NVL(i.wholding_tax,0)-NVL(m.wtax_amt,0))
          --      +(NVL(i.input_vat,0)-NVL(m.input_vat_amt,0))),2) net_comm_due,
          ROUND
             ((  (NVL (i.commission_amt, 0) - NVL (m.comm_amt, 0))
               - DECODE
                    (ROUND (NVL (i.wholding_tax, 0) - NVL (m.wtax_amt, 0), 2),
                     -0.01, ROUND (  NVL (i.wholding_tax, 0)
                                   - NVL (m.wtax_amt, 0),
                                   2
                                  )
                      + 0.01,
                     0.01, ROUND (NVL (i.wholding_tax, 0)
                                  - NVL (m.wtax_amt, 0),
                                  2
                                 )
                      - 0.01,
                     ROUND (NVL (i.wholding_tax, 0) - NVL (m.wtax_amt, 0), 2)
                    )
                   -- --modified by alfie: to handle 0.01 discrepancy 07122010
               + (  (NVL (i.commission_amt, 0) - NVL (m.comm_amt, 0))
                  * (i.input_vat_rate / 100)
                 )
              ),
              2
             ) net_comm_due,
          i.commission_rt, i.intm_type, i.parent_intm_type, p.payment_date,
          i.bank_ref_no
     FROM (SELECT a.policy_id, c.line_cd, c.cred_branch, i.assd_no, a.iss_cd,
                  a.prem_seq_no, inst_no, a.intrmdry_intm_no,
                  b.parent_intm_no, d.intm_type, j.intm_type parent_intm_type,
                  a.peril_cd,
                  ((a.premium_amt * e.currency_rt) / h.no_of_payt
                  ) premium_amt,
                  (  (  NVL (  g.commission_amt
                             * (a.commission_amt / b.commission_amt),
                             a.commission_amt
                            )
                      * e.currency_rt
                     )
                   / NVL (h.no_of_payt, 1)
                  ) commission_amt,
                  (  (  NVL (  g.wholding_tax
                             * (a.commission_amt / b.commission_amt),
                             a.wholding_tax
                            )
                      * e.currency_rt
                     )
                   / NVL (h.no_of_payt, 1)
                  ) wholding_tax,
                  
                  --(((NVL(g.commission_amt*(a.commission_amt/b.commission_amt),a.commission_amt)*e.currency_rt)*Giacp.n('INPUT_VAT_RT')/100)/NVL(h.no_of_payt,1)) input_vat,               --(((NVL(g.commission_amt*(a.commission_amt/b.commission_amt),a.commission_amt)*e.currency_rt)*(d.input_vat_rate/100))/NVL(h.no_of_payt,1)) input_vat,
                  d.input_vat_rate, a.commission_rt, f.due_date,
                  c.bank_ref_no
             FROM gipi_polbasic c,
                  gipi_comm_invoice b,
                  gipi_comm_inv_dtl g,
                  gipi_comm_inv_peril a,
                  gipi_installment f,
                  giis_intermediary d,
                  gipi_invoice e,
                  giis_payterm h,
                  gipi_parlist i,
                  giis_intermediary j
            WHERE 1 = 1
              AND c.pol_flag <> '5'
              AND d.intm_no = a.intrmdry_intm_no
              AND c.policy_id = b.policy_id
              AND b.iss_cd = a.iss_cd
              AND b.prem_seq_no = a.prem_seq_no
              AND b.iss_cd = g.iss_cd(+)
              AND b.prem_seq_no = g.prem_seq_no(+)
              AND b.intrmdry_intm_no = g.intrmdry_intm_no(+)
              AND b.parent_intm_no = j.intm_no
              AND b.iss_cd = f.iss_cd
              AND c.par_id = i.par_id
              AND b.prem_seq_no = f.prem_seq_no
              AND b.intrmdry_intm_no = a.intrmdry_intm_no
              AND e.iss_cd = f.iss_cd
              AND e.prem_seq_no = f.prem_seq_no
              AND e.payt_terms = h.payt_terms
              AND b.premium_amt <> 0
              AND NVL (g.commission_amt, b.commission_amt) <> 0) i,
          (SELECT   z.b140_iss_cd, z.b140_prem_seq_no, z.inst_no,
                    v.intrmdry_intm_no, v.peril_cd,
                    SUM (  z.premium_amt
                         * (v.premium_amt / u.premium_amt)
                         * (u.share_percentage / 100)
                        ) premium_amt,
                    MAX (tran_date) payment_date
               FROM giac_direct_prem_collns z,
                    giac_acctrans w,
                    gipi_comm_inv_peril v,
                    gipi_comm_invoice u
              WHERE 1 = 1
                AND z.b140_iss_cd = u.iss_cd
                AND z.b140_prem_seq_no = u.prem_seq_no
                AND v.iss_cd = u.iss_cd
                AND v.prem_seq_no = u.prem_seq_no
                AND v.intrmdry_intm_no = u.intrmdry_intm_no
                AND z.gacc_tran_id = w.tran_id
                AND w.tran_flag <> 'D'
                AND NOT EXISTS (
                       SELECT '1'
                         FROM giac_reversals x, giac_acctrans y
                        WHERE x.gacc_tran_id = z.gacc_tran_id
                          AND x.reversing_tran_id = y.tran_id
                          AND y.tran_flag <> 'D')
                AND u.premium_amt <> 0
                AND u.commission_amt <> 0
           GROUP BY z.b140_iss_cd,
                    z.b140_prem_seq_no,
                    z.inst_no,
                    v.intrmdry_intm_no,
                    v.peril_cd) p,
          (SELECT   z.iss_cd, z.prem_seq_no, s.inst_no, z.intm_no, v.peril_cd,
                    SUM (  z.comm_amt
                         * (v.commission_amt / u.commission_amt)
                         / NVL (get_max_inst_no (z.iss_cd, z.prem_seq_no), 1)
                        ) comm_amt,
                    SUM (  z.wtax_amt
                         * (v.commission_amt / u.commission_amt)
                         / NVL (get_max_inst_no (z.iss_cd, z.prem_seq_no), 1)
                        ) wtax_amt,
                    SUM (  z.input_vat_amt
                         * (v.commission_amt / u.commission_amt)
                         / NVL (get_max_inst_no (z.iss_cd, z.prem_seq_no), 1)
                        ) input_vat_amt
               FROM giac_comm_payts z,
                    giac_acctrans w,
                    gipi_comm_inv_peril v,
                    gipi_comm_invoice u,
                    gipi_invoice t,
                    gipi_installment s
              WHERE 1 = 1
                AND z.iss_cd = u.iss_cd
                AND z.prem_seq_no = u.prem_seq_no
                AND z.intm_no = u.intrmdry_intm_no
                AND v.iss_cd = u.iss_cd
                AND v.prem_seq_no = u.prem_seq_no
                AND v.intrmdry_intm_no = u.intrmdry_intm_no
                AND u.iss_cd = t.iss_cd
                AND u.prem_seq_no = t.prem_seq_no
                AND t.iss_cd = s.iss_cd
                AND t.prem_seq_no = s.prem_seq_no
                AND z.gacc_tran_id = w.tran_id
                AND w.tran_flag <> 'D'
                AND NOT EXISTS (
                       SELECT '1'
                         FROM giac_reversals x, giac_acctrans y
                        WHERE x.gacc_tran_id = z.gacc_tran_id
                          AND x.reversing_tran_id = y.tran_id
                          AND y.tran_flag <> 'D')
                AND u.commission_amt <> 0
           GROUP BY z.iss_cd, z.prem_seq_no, s.inst_no, z.intm_no, v.peril_cd) m
    WHERE i.iss_cd = p.b140_iss_cd
      AND i.prem_seq_no = p.b140_prem_seq_no
      AND i.inst_no = p.inst_no
      AND i.intrmdry_intm_no = p.intrmdry_intm_no
      AND i.peril_cd = p.peril_cd
      AND i.iss_cd = m.iss_cd(+)
      AND i.prem_seq_no = m.prem_seq_no(+)
      AND i.inst_no = m.inst_no(+)
      AND i.intrmdry_intm_no = m.intm_no(+)
      AND i.peril_cd = m.peril_cd(+);


