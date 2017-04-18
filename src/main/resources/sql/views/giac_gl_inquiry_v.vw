DROP VIEW CPI.GIAC_GL_INQUIRY_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_gl_inquiry_v (tran_no,
                                                    tran_class,
                                                    tran_flag,
                                                    ref_no,
                                                    tran_date,
                                                    dt_posted,
                                                    sl_cd,
                                                    debit_amt,
                                                    credit_amt,
                                                    remarks,
                                                    user_id,
                                                    last_update,
                                                    gacc_tran_id,
                                                    fund_cd,
                                                    branch_cd,
                                                    gl_acct_id,
                                                    sl_type_cd,
                                                    sl_source_cd
                                                   )
AS
   SELECT    LTRIM (TO_CHAR (gacc.tran_year, '9999'))
          || '-'
          || LTRIM (TO_CHAR (gacc.tran_month, '09'))
          || '-'
          || LTRIM (TO_CHAR (gacc.tran_seq_no, '099999')) tran_no,
          gacc.tran_class tran_class, gacc.tran_flag tran_flag,
          DECODE (gacc.tran_class,
                  'COL', DECODE (giop.or_pref_suf,
                                 NULL, NULL,
                                 giop.or_pref_suf || '-'
                                )
                   || LTRIM (TO_CHAR (giop.or_no, '0999999999')),
                  'DV', DECODE (gidv.dv_pref,
                                NULL, NULL,
                                gidv.dv_pref || '-'
                               )
                   || LTRIM (TO_CHAR (gidv.dv_no, '0999999999')),
                  LTRIM (TO_CHAR (gacc.tran_class_no, '0999999999'))
                 ) ref_no,
          gacc.tran_date tran_date, gacc.posting_date dt_posted,
          giae.sl_cd sl_cd, giae.debit_amt debit_amt,
          giae.credit_amt credit_amt, giae.remarks remarks,
          giae.user_id user_id, giae.last_update last_update,
          giae.gacc_tran_id gacc_tran_id, giae.gacc_gfun_fund_cd fund_cd,
          giae.gacc_gibr_branch_cd branch_cd, giae.gl_acct_id gl_acct_id,
          giae.sl_type_cd sl_type_cd, giae.sl_source_cd sl_source_cd
     FROM giac_disb_vouchers gidv,
          giac_order_of_payts giop,
          giac_acctrans gacc,
          giac_acct_entries giae
    WHERE giae.gacc_tran_id = gacc.tran_id
      AND gacc.tran_id = giop.gacc_tran_id(+)
      AND gacc.tran_id = gidv.gacc_tran_id(+)
      AND gacc.tran_flag IN ('O', 'C', 'P')
          WITH READ ONLY;


