DROP VIEW CPI.GIAC_PREMIUM_COLLN_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_premium_colln_v (iss_cd,
                                                       prem_seq_no,
                                                       tran_id,
                                                       tran_class,
                                                       tran_date,
                                                       posting_date,
                                                       ref_no,
                                                       collection_amt,
                                                       premium_amt,
                                                       tax_amt,
                                                       branch_cd
                                                      )
AS
   SELECT gdpc.iss_cd, gdpc.prem_seq_no, gacc.tran_id, gacc.tran_class,
          TRUNC (gacc.tran_date) tran_date,
          TRUNC (gacc.posting_date) posting_date,
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
                                       WHERE gidv.gacc_tran_id = gacc.tran_id),
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
                  || tran_year
                  || '-'
                  || tran_month
                  || '-'
                  || tran_seq_no
                 ) ref_no,
          gdpc.collection_amt, gdpc.premium_amt, gdpc.tax_amt,
          gacc.gibr_branch_cd branch_cd
     FROM (SELECT   b140_iss_cd iss_cd, b140_prem_seq_no prem_seq_no,
                    gacc_tran_id, SUM (collection_amt) collection_amt,
                    SUM (premium_amt) premium_amt, SUM (tax_amt) tax_amt
               FROM giac_direct_prem_collns
           GROUP BY b140_iss_cd, b140_prem_seq_no, gacc_tran_id) gdpc,
          giac_acctrans gacc
    WHERE 1 = 1
      AND gdpc.gacc_tran_id = gacc.tran_id
      AND gacc.tran_flag != 'D'
      AND gacc.tran_id > 0
      AND NOT EXISTS (
             SELECT 'X'
               FROM giac_reversals x, giac_acctrans y
              WHERE x.reversing_tran_id = y.tran_id
                AND y.tran_flag <> 'D'
                AND x.gacc_tran_id = gdpc.gacc_tran_id);


