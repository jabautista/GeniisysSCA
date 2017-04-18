DROP VIEW CPI.GIRI_FRPS_OUTFACUL_PREM_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giri_frps_outfacul_prem_v (fnl_binder_id,
                                                            ri_cd,
                                                            binder_date,
                                                            eff_date,
                                                            expiry_date,
                                                            line_cd,
                                                            binder_yy,
                                                            binder_seq_no,
                                                            ri_prem_amt,
                                                            ri_comm_amt,
                                                            prem_tax,
                                                            confirm_no,
                                                            confirm_date,
                                                            subline_cd,
                                                            iss_cd,
                                                            cred_branch,
                                                            policy_id,
                                                            issue_yy,
                                                            pol_seq_no,
                                                            renew_no,
                                                            endt_iss_cd,
                                                            endt_yy,
                                                            endt_seq_no,
                                                            assd_name,
                                                            frps_yy,
                                                            frps_seq_no,
                                                            ri_prem_vat,
                                                            ri_comm_vat,
                                                            payments,
                                                            net_due,
                                                            balance
                                                           )
AS
   SELECT   t1.fnl_binder_id, t1.ri_cd, binder_date, t5.eff_date,
            t5.expiry_date, t1.line_cd, binder_yy, binder_seq_no,
            t1.ri_prem_amt, t1.ri_comm_amt, t1.prem_tax, confirm_no,
            confirm_date, subline_cd, t5.iss_cd, t5.cred_branch,
                                                                -- jeremy 05282010
                                                                t5.policy_id,
                                                        --mark andrew 06012010
            issue_yy, pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no,
            assd_name, t2.frps_yy, t2.frps_seq_no, t1.ri_prem_vat,
            t1.ri_comm_vat,   /*NVL (SUM (t8.disbursement_amt), 0) payments,*/
            
            -- Removed by Jomar Diago 01072013
            NVL (get_outfacul_tot_amt (t1.line_cd,
                                       t1.ri_cd,
                                       t1.fnl_binder_id,
                                       t2.frps_yy,
                                       t2.frps_seq_no
                                      ),
                 0
                ) payments,                   -- Added by Jomar Diago 01072013
            NVL (  (  (NVL (t1.ri_prem_amt, 0) + NVL (t1.ri_prem_vat, 0))
                    - (NVL (t1.ri_comm_amt, 0) + NVL (t1.ri_comm_vat, 0))
                    - NVL (t1.prem_tax, 0)
                   )
                 * (t3.currency_rt),
                 0
                ) net_due,
              NVL (  (  (NVL (t1.ri_prem_amt, 0) + NVL (t1.ri_prem_vat, 0))
                      - (NVL (t1.ri_comm_amt, 0) + NVL (t1.ri_comm_vat, 0))
                      - NVL (t1.prem_tax, 0)
                     )
                   * (t3.currency_rt),
                   0
                  )
            /* - NVL (SUM (t8.disbursement_amt), 0) balance*/
            -- Removed by Jomar Diago 01072013
            - NVL (get_outfacul_tot_amt (t1.line_cd,
                                         t1.ri_cd,
                                         t1.fnl_binder_id,
                                         t2.frps_yy,
                                         t2.frps_seq_no
                                        ),
                   0
                  ) balance                   -- Added by Jomar Diago 01072013
       FROM giri_binder t1,
            giri_frps_ri t2,
            giri_distfrps t3,
            giuw_pol_dist t4,
            gipi_polbasic t5,
            giis_assured t6,
            gipi_parlist t7,
            giac_outfacul_prem_payts t8
      WHERE t1.fnl_binder_id = t2.fnl_binder_id
        AND t1.fnl_binder_id = t8.d010_fnl_binder_id(+)
        AND t2.line_cd = t3.line_cd
        AND t2.frps_yy = t3.frps_yy
        AND t2.frps_seq_no = t3.frps_seq_no
        AND t3.dist_no = t4.dist_no
        AND t4.policy_id = t5.policy_id
        AND t5.par_id = t7.par_id
        AND t7.assd_no = t6.assd_no
        AND NVL (t2.delete_sw, 'N') = 'N'
        AND NVL (t2.reverse_sw, 'N') = 'N'
   GROUP BY t1.fnl_binder_id,
            t1.ri_cd,
            binder_date,
            t5.eff_date,
            t5.expiry_date,
            t1.line_cd,
            binder_yy,
            binder_seq_no,
            t1.ri_prem_amt,
            t1.ri_comm_amt,
            t1.prem_tax,
            confirm_no,
            confirm_date,
            subline_cd,
            t5.iss_cd,
            t5.cred_branch,
            t5.policy_id,
            issue_yy,
            pol_seq_no,
            renew_no,
            endt_iss_cd,
            endt_yy,
            endt_seq_no,
            assd_name,
            t2.frps_yy,
            t2.frps_seq_no,
            t1.ri_prem_vat,
            t1.ri_comm_vat,
            t3.currency_rt;


