DROP VIEW CPI.GIRI_POLBASIC_INWFACUL_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giri_polbasic_inwfacul_v (ri_cd,
                                                           policy_id,
                                                           line_cd,
                                                           b250_iss_cd,
                                                           subline_cd,
                                                           issue_yy,
                                                           pol_seq_no,
                                                           renew_no,
                                                           endt_iss_cd,
                                                           endt_yy,
                                                           endt_seq_no,
                                                           assd_no,
                                                           assd_name,
                                                           ri_sname,
                                                           accept_no,
                                                           iss_cd,
                                                           prem_seq_no,
                                                           due_date,
                                                           prem_amt,
                                                           tax_amt,
                                                           ri_comm_amt,
                                                           ri_comm_vat,
                                                           currency_rt,
                                                           ri_policy_no,
                                                           ri_endt_no,
                                                           ri_binder_no,
                                                           eff_date,
                                                           expiry_date,
                                                           currency_cd,
                                                           currency_desc,
                                                           total_amt,
                                                           net_due,
                                                           total_amt_paid,
                                                           balance
                                                          )
AS
   SELECT   a.ri_cd, b.policy_id, b.line_cd, b.iss_cd b250_iss_cd,
            b.subline_cd, b.issue_yy, b.pol_seq_no, b.renew_no, b.endt_iss_cd,
            b.endt_yy, b.endt_seq_no, e.assd_no, f.assd_name, a.ri_sname,
            d.accept_no, c.iss_cd, c.prem_seq_no, c.due_date, c.prem_amt,
            c.tax_amt, c.ri_comm_amt, c.ri_comm_vat,
                                      /* jhing 11.16.2012 added ri_comm_vat */
                                                    c.currency_rt,
            d.ri_policy_no, d.ri_endt_no, d.ri_binder_no, b.eff_date,
            b.expiry_date, c.currency_cd, g.currency_desc,
            NVL (c.prem_amt, 0) + NVL (c.tax_amt, 0) total_amt,
              NVL (c.prem_amt, 0)
            + NVL (c.tax_amt, 0)
            - NVL (c.ri_comm_amt, 0) net_due,
            NVL (SUM (h.collection_amt), 0) total_amt_paid,
            (  (  NVL (c.prem_amt, 0)
                + NVL (c.tax_amt, 0)
                - NVL (c.ri_comm_amt, 0)
               )
             - NVL (SUM (h.collection_amt), 0)
            ) balance
       FROM giis_reinsurer a,
            gipi_polbasic b,
            gipi_invoice c,
            giri_inpolbas d,
            gipi_parlist e,
            giis_assured f,
            giis_currency g,
            giac_inwfacul_prem_collns h
      WHERE a.ri_cd = d.ri_cd
        AND c.iss_cd = h.b140_iss_cd(+)
        AND c.prem_seq_no = h.b140_prem_seq_no(+)
        AND b.policy_id = c.policy_id
        AND b.policy_id = d.policy_id
        AND b.par_id = e.par_id
        AND e.assd_no = f.assd_no
        AND c.currency_cd = g.main_currency_cd
   GROUP BY a.ri_cd,
            b.policy_id,
            b.line_cd,
            b.iss_cd,
            b.subline_cd,
            c.iss_cd,
            b.issue_yy,
            b.pol_seq_no,
            b.renew_no,
            b.endt_iss_cd,
            b.endt_yy,
            b.endt_seq_no,
            e.assd_no,
            f.assd_name,
            a.ri_sname,
            d.accept_no,
            c.iss_cd,
            c.prem_seq_no,
            c.due_date,
            c.prem_amt,
            c.tax_amt,
            c.ri_comm_amt,
            c.ri_comm_vat,            /* jhing 11.16.2012 added ri_comm_vat */
            c.currency_rt,
            d.ri_policy_no,
            d.ri_endt_no,
            d.ri_binder_no,
            b.eff_date,
            b.expiry_date,
            c.currency_cd,
            g.currency_desc;


