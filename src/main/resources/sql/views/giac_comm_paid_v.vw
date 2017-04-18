DROP VIEW CPI.GIAC_COMM_PAID_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_comm_paid_v (comm_amt,
                                                   wtax_amt,
                                                   input_vat_amt,
                                                   intm_no,
                                                   iss_cd,
                                                   prem_seq_no,
                                                   gacc_tran_id,
                                                   posting_date,
                                                   tran_date,
                                                   comm_ref_no
                                                  )
AS
   SELECT   SUM (gcpt.comm_amt) comm_amt, SUM (gcpt.wtax_amt) wtax_amt,
            SUM (input_vat_amt) input_vat_amt, gcpt.intm_no, gcpt.iss_cd,
            gcpt.prem_seq_no, gcpt.gacc_tran_id,
            TRUNC (gacc.posting_date) posting_date,
            TRUNC (gacc.tran_date) tran_date,
            DECODE (gacc.tran_class,
                    'COL', (SELECT giop.or_pref_suf || '-' || giop.or_no
                              FROM giac_order_of_payts giop
                             WHERE giop.gacc_tran_id = gacc.tran_id),
                    'JV', gacc.jv_pref_suff || '-' || gacc.jv_no,
                    'CM', (SELECT    gcmdm.memo_type
                                  || '-'
                                  || gcmdm.memo_year
                                  || '-'
                                  || gcmdm.memo_seq_no
                             FROM giac_cm_dm gcmdm
                            WHERE gcmdm.gacc_tran_id = gacc.tran_id),
                    'DM', (SELECT    gcmdm.memo_type
                                  || '-'
                                  || gcmdm.memo_year
                                  || '-'
                                  || gcmdm.memo_seq_no
                             FROM giac_cm_dm gcmdm
                            WHERE gcmdm.gacc_tran_id = gacc.tran_id),
                    'DV', DECODE ((SELECT 'X'
                                     FROM giac_disb_vouchers gidv
                                    WHERE gidv.gacc_tran_id = gacc.tran_id),
                                  'X', (SELECT dv_pref || '-' || dv_no
                                          FROM giac_disb_vouchers gidv
                                         WHERE gidv.gacc_tran_id =
                                                                  gacc.tran_id),
                                  (SELECT    gprq.document_cd
                                          || '-'
                                          || gprq.branch_cd
                                          || '-'
                                          || gprq.doc_year
                                          || '-'
                                          || gprq.doc_mm
                                          || '-'
                                          || gprq.doc_seq_no
                                     FROM giac_payt_requests gprq,
                                          giac_payt_requests_dtl gprqd
                                    WHERE gprq.ref_id = gprqd.gprq_ref_id
                                      AND gprqd.tran_id = gacc.tran_id
                                      AND gprqd.gprq_ref_id >= 1)
                                 ),
                       gacc.tran_class
                    || '-'
                    || gacc.tran_year
                    || '-'
                    || gacc.tran_month
                    || '-'
                    || gacc.tran_seq_no
                   )
       FROM giac_comm_payts gcpt, giac_acctrans gacc
      WHERE gcpt.gacc_tran_id = gacc.tran_id
        AND gacc.tran_flag != 'D'
        AND NOT EXISTS (
               SELECT c.gacc_tran_id
                 FROM giac_reversals c, giac_acctrans d
                WHERE c.reversing_tran_id = d.tran_id
                  AND d.tran_flag != 'D'
                  AND c.gacc_tran_id = gcpt.gacc_tran_id)
   GROUP BY gcpt.intm_no,
            gcpt.iss_cd,
            gcpt.prem_seq_no,
            gcpt.gacc_tran_id,
            TRUNC (gacc.posting_date),
            TRUNC (gacc.tran_date),
            gacc.tran_class,
            gacc.tran_id,
            gacc.jv_pref_suff,
            gacc.jv_no,
            gacc.tran_year,
            gacc.tran_month,
            gacc.tran_seq_no
   ORDER BY gcpt.intm_no, gcpt.iss_cd, gcpt.prem_seq_no;


