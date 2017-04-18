DROP VIEW CPI.GIAC_INVOICE_LIST_V1;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_invoice_list_v1 (iss_cd,
                                                       prem_seq_no,
                                                       inst_no,
                                                       collection_amt,
                                                       premium_amt,
                                                       tax_amt,
                                                       collection_amt1,
                                                       premium_amt1,
                                                       tax_amt1,
                                                       ref_inv_no,
                                                       policy_id,
                                                       pol_line_cd,
                                                       pol_subline_cd,
                                                       pol_iss_cd,
                                                       pol_issue_yy,
                                                       pol_seq_no,
                                                       pol_renew_no,
                                                       endt_iss_cd,
                                                       endt_yy,
                                                       endt_seq_no,
                                                       endt_type,
                                                       ref_pol_no,
                                                       assd_no,
                                                       assd_name,
                                                       currency_cd,
                                                       currency_rt
                                                      )
AS
   SELECT   a.iss_cd, a.prem_seq_no, a.inst_no,
            a.balance_amt_due collection_amt, a.prem_balance_due premium_amt,
            a.tax_balance_due tax_amt, a.balance_amt_due collection_amt1,
            a.prem_balance_due premium_amt1, a.tax_balance_due tax_amt1,
            b.ref_inv_no, c.policy_id, c.line_cd pol_line_cd,
            c.subline_cd pol_subline_cd, c.iss_cd pol_iss_cd,
            c.issue_yy pol_issue_yy, c.pol_seq_no pol_seq_no,
            c.renew_no pol_renew_no,
            DECODE (c.endt_seq_no, 0, NULL, c.endt_iss_cd) endt_iss_cd,
            DECODE (c.endt_seq_no, 0, NULL, c.endt_yy) endt_yy,
            DECODE (c.endt_seq_no, 0, NULL, c.endt_seq_no) endt_seq_no,
            DECODE (c.endt_seq_no, 0, NULL, c.endt_type) endt_type,
            c.ref_pol_no, c.assd_no, d.assd_name, b.currency_cd,
            b.currency_rt
       FROM gipi_parlist e,
            giis_assured d,
            gipi_polbasic c,
            gipi_invoice b,
            giac_aging_soa_details a
      WHERE 1 = 1
        /*  AND NOT EXISTS (
                 SELECT 'X'
                   FROM giac_cancelled_policies_v
                  WHERE line_cd = c.line_cd
                    AND subline_cd = c.subline_cd
                    AND iss_cd = c.iss_cd
                    AND issue_yy = c.issue_yy
                    AND pol_seq_no = c.pol_seq_no
                    AND renew_no = c.renew_no) */
        AND e.assd_no = d.assd_no
        AND c.par_id = e.par_id
        AND a.policy_id = c.policy_id
        AND a.prem_seq_no = b.prem_seq_no
        AND a.iss_cd = b.iss_cd
   ORDER BY a.iss_cd, a.prem_seq_no, a.inst_no;


