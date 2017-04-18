CREATE OR REPLACE FORCE VIEW cpi.giac_invoice_list_web_v2 (tran_id,
                                                           iss_cd,
                                                           prem_seq_no,
                                                           inst_no,
                                                           collection_amt,
                                                           premium_amt,
                                                           tax_amt,
                                                           collection_amt1,
                                                           premium_amt1,
                                                           tax_amt1,
                                                           ref_inv_no,
                                                           payt_ref_no,
                                                           policy_id,
                                                           ref_pol_no,
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
                                                           assd_no,
                                                           assd_name,
                                                           currency_cd,
                                                           currency_rt,
                                                           or_print_tag,
                                                           prem_vatable,
                                                           prem_vat_exempt,
                                                           prem_zero_rated,
                                                           rev_gacc_tran_id
                                                          )
AS
   SELECT   f.tran_id, a.b140_iss_cd iss_cd, a.b140_prem_seq_no prem_seq_no,
            a.inst_no, SUM (a.collection_amt) collection_amt,
            SUM (a.premium_amt) premium_amt, SUM (a.tax_amt) tax_amt,
            (-1) * SUM (a.collection_amt) collection_amt1,
            (-1) * SUM (a.premium_amt) premium_amt1,
            (-1) * SUM (a.tax_amt) tax_amt1, b.ref_inv_no,
            get_ref_no (f.tran_id) payt_ref_no, c.policy_id, c.ref_pol_no,
            c.line_cd pol_line_cd, c.subline_cd pol_subline_cd,
            c.iss_cd pol_iss_cd, c.issue_yy pol_issue_yy,
            c.pol_seq_no pol_seq_no, c.renew_no pol_renew_no,
            DECODE (c.endt_seq_no, 0, NULL, c.endt_iss_cd) endt_iss_cd,
            DECODE (c.endt_seq_no, 0, NULL, c.endt_yy) endt_yy,
            DECODE (c.endt_seq_no, 0, NULL, c.endt_seq_no) endt_seq_no,
            DECODE (c.endt_seq_no, 0, NULL, c.endt_type) endt_type, d.assd_no,
            d.assd_name, b.currency_cd, b.currency_rt, a.or_print_tag,
            a.prem_vatable, a.prem_vat_exempt, a.prem_zero_rated,
            a.gacc_tran_id --a.rev_gacc_tran_id --edited by gab 01.06.2017 SR 23658
       FROM giac_acctrans f,
            gipi_parlist e,
            giis_assured d,
            gipi_polbasic c,
            gipi_invoice b,
            giac_direct_prem_collns a
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
        AND b.policy_id = c.policy_id
        AND a.gacc_tran_id = f.tran_id
        AND a.b140_iss_cd = b.iss_cd
        AND a.b140_prem_seq_no = b.prem_seq_no
        AND NOT EXISTS (
               SELECT 'x'
                 FROM giac_reversals g, giac_acctrans h
                WHERE g.reversing_tran_id = h.tran_id
                  AND g.gacc_tran_id = a.gacc_tran_id
                  AND h.tran_flag <> 'D')
        AND f.tran_flag <> 'D'
   GROUP BY f.tran_id,
            a.b140_iss_cd,
            a.b140_prem_seq_no,
            a.inst_no,
            b.ref_inv_no,
            /*get_ref_no (*/f.tran_id,/*),  Modified by pjsantos 10/06/2016, GENQA 5692 for optimization.*/
            c.policy_id,
            c.ref_pol_no,
            c.line_cd,
            c.subline_cd,
            c.iss_cd,
            c.issue_yy,
            c.pol_seq_no,
            c.renew_no,
            c.endt_iss_cd,
            c.endt_yy,
            c.endt_seq_no,
            c.endt_type,
            d.assd_no,
            d.assd_name,
            b.currency_cd,
            b.currency_rt,
            a.or_print_tag,
            a.prem_vatable,
            a.prem_vat_exempt,
            a.prem_zero_rated,
            a.gacc_tran_id; --a.rev_gacc_tran_id --edited by gab 01.16.2017 SR 23658
   /*ORDER BY a.b140_iss_cd, a.b140_prem_seq_no, a.inst_no; removed by pjsantos 10/06/2016, GENQA 5692 for optimization.*/


