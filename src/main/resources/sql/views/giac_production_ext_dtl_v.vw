DROP VIEW CPI.GIAC_PRODUCTION_EXT_DTL_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_production_ext_dtl_v (pos_neg_inclusion,
                                                            policy_id,
                                                            iss_cd,
                                                            acct_line_cd,
                                                            acct_subline_cd,
                                                            assd_no,
                                                            parent_intm_no,
                                                            acct_intm_cd,
                                                            intrmdry_intm_no,
                                                            prem_seq_no,
                                                            peril_cd,
                                                            premium_amt,
                                                            commission_amt,
                                                            currency_rt,
                                                            prem_amt,
                                                            tax_amt,
                                                            other_charges,
                                                            notarial_fee,
                                                            prem_rec,
                                                            OTHERS,
                                                            wholding_tax --mikel 06.15.2015; SR 4691 Wtax enhancements, BIR demo findings.
                                                           )
AS
   SELECT a.pos_neg_inclusion,
   /* modified by judyann 04032008; to handle take-up of long-term policies */
                              a.policy_id, a.iss_cd, a.acct_line_cd,
          a.acct_subline_cd, a.assd_no, a.intm_no, a.acct_intm_cd,
          b.intrmdry_intm_no, b.prem_seq_no, b.peril_cd,
          (NVL (b.premium_amt, 0) * NVL (c.currency_rt, 1) * 100) premium_amt,
          (NVL (b.commission_amt, 0) * NVL (c.currency_rt, 1) * 100
          ) commission_amt,
          c.currency_rt,
          (NVL (c.prem_amt, 0) * NVL (c.currency_rt, 1) * 100) prem_amt,
          (NVL (c.tax_amt, 0) * NVL (c.currency_rt, 1) * 100) tax_amt,
          (NVL (c.other_charges, 0) * NVL (c.currency_rt, 1) * 100
          ) other_charges,
          (NVL (c.notarial_fee, 0) * NVL (c.currency_rt, 1) * 100
          ) notarial_fee,
          (  (  NVL (c.prem_amt, 0)
              + NVL (c.tax_amt, 0)
              + NVL (c.other_charges, 0)
              + NVL (c.notarial_fee, 0)
             )
           * NVL (c.currency_rt, 1)
           * 100
          ) prem_rec,
          (  (NVL (c.other_charges, 0) + NVL (c.notarial_fee, 0))
           * NVL (c.currency_rt, 1)
           * 100
          ) OTHERS,
          (NVL (b.wholding_tax, 0) * NVL (c.currency_rt, 1) * 100 ) wholding_tax --mikel 06.15.2015
     FROM gipi_invoice c, gipi_comm_inv_peril b, giac_production_ext a
    WHERE 1 = 1
      AND a.policy_id = c.policy_id
      --AND a.policy_id = b.policy_id (+)
      AND c.policy_id = b.policy_id(+)
      AND c.iss_cd = b.iss_cd(+)
      AND c.prem_seq_no = b.prem_seq_no(+)
      --AND b.iss_cd = c.iss_cd
      --AND b.prem_seq_no = c.prem_seq_no --for non exs in comm_invperil
      AND c.iss_cd = a.bill_iss_cd
      AND c.prem_seq_no = a.prem_seq_no
      --To make sure it is in gipi_comm_invoice
      AND EXISTS (SELECT 'X'
                    FROM gipi_comm_invoice b1
                   WHERE b1.policy_id = a.policy_id)
   UNION
   SELECT a.pos_neg_inclusion, a.policy_id, a.iss_cd, a.acct_line_cd,
          a.acct_subline_cd, a.assd_no, a.intm_no, a.acct_intm_cd,
          1 intrmdry_intm_no, 1 prem_seq_no, 1 peril_cd, 0 premium_amt,
          0 commission_amt, c.currency_rt,
          (NVL (c.prem_amt, 0) * NVL (c.currency_rt, 1) * 100) prem_amt,
          (NVL (c.tax_amt, 0) * NVL (c.currency_rt, 1) * 100) tax_amt,
          (NVL (c.other_charges, 0) * NVL (c.currency_rt, 1) * 100
          ) other_charges,
          (NVL (c.notarial_fee, 0) * NVL (c.currency_rt, 1) * 100
          ) notarial_fee,
          (  (  NVL (c.prem_amt, 0)
              + NVL (c.tax_amt, 0)
              + NVL (c.other_charges, 0)
              + NVL (c.notarial_fee, 0)
             )
           * NVL (c.currency_rt, 1)
           * 100
          ) prem_rec,
          (  (NVL (c.other_charges, 0) + NVL (c.notarial_fee, 0))
           * NVL (c.currency_rt, 1)
           * 100
          ) OTHERS,
          0 wholding_tax --mikel 06.15.2015
     FROM gipi_invoice c, giac_production_ext a
    WHERE 1 = 1
      AND a.policy_id = c.policy_id
      AND c.iss_cd = a.bill_iss_cd
      AND c.prem_seq_no = a.prem_seq_no
      AND NOT EXISTS (SELECT 'X'
                        FROM gipi_comm_invoice b
                       WHERE b.policy_id = a.policy_id);
                       
GRANT DELETE, INSERT, SELECT, UPDATE ON CPI.GIAC_PRODUCTION_EXT_DTL_V TO PUBLIC;                       