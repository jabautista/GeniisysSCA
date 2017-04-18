DROP VIEW CPI.GIAC_CHECK_DISBURSEMENT_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_check_disbursement_v (gacc_tran_id,
                                                            item_no,
                                                            bank_cd,
                                                            bank_acct_cd,
                                                            currency_cd,
                                                            currency_rt,
                                                            amount,
                                                            check_date,
                                                            check_pref_suf,
                                                            check_no,
                                                            check_stat,
                                                            check_class,
                                                            fcurrency_amt,
                                                            user_id,
                                                            last_update,
                                                            particulars,
                                                            cpi_rec_no,
                                                            cpi_branch_cd,
                                                            check_release_date,
                                                            check_released_by,
                                                            check_received_by,
                                                            payee_no,
                                                            payee_class_cd,
                                                            payee,
                                                            gibr_branch_cd,
                                                            gibr_gfun_fund_cd
                                                           )
AS
   SELECT a.gacc_tran_id, a.item_no, a.bank_cd, a.bank_acct_cd, a.currency_cd,
          a.currency_rt, a.amount, a.check_date, a.check_pref_suf, a.check_no,
          a.check_stat, a.check_class, a.fcurrency_amt, a.user_id,
          a.last_update, a.particulars, a.cpi_rec_no, a.cpi_branch_cd,
          a.check_release_date, a.check_released_by, a.check_received_by,
          a.payee_no, a.payee_class_cd, a.payee, b.gibr_branch_cd,
          b.gibr_gfun_fund_cd
     FROM giac_chk_disbursement a, giac_disb_vouchers b
    WHERE a.gacc_tran_id = b.gacc_tran_id;


