DROP VIEW CPI.GIAC_PD_CHECKS_V;

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_pd_checks_v (fund_cd,
                                                   fund_desc,
                                                   ouc_id,
                                                   ouc_name,
                                                   branch_cd,
                                                   branch_name,
                                                   payee_class_cd,
                                                   class_desc,
                                                   payee_no,
                                                   payee_last_name,
                                                   payee_first_name,
                                                   payee_middle_name,
                                                   check_no,
                                                   check_date,
                                                   dv_amt,
                                                   particulars,
                                                   bank_name,
                                                   bank_acct_no,
                                                   user_id,
                                                   last_update
                                                  )
AS
   SELECT gidv.gibr_gfun_fund_cd fund_cd, a995.fund_desc,
          gidv.gouc_ouc_id ouc_id, gouc.ouc_name,
          gidv.gibr_branch_cd branch_cd, gibr.branch_name,
          a1290.payee_class_cd, a1290.class_desc, a1280.payee_no,
          a1280.payee_last_name, a1280.payee_first_name,
          a1280.payee_middle_name,
             DECODE (gchd.check_pref_suf,
                     NULL, NULL,
                     gchd.check_pref_suf || '-'
                    )
          || gchd.check_no check_no,
          gchd.check_date, gidv.dv_amt, gidv.particulars, gban.bank_name,
          gbac.bank_acct_no, gidv.user_id, gidv.last_update
     FROM giis_payee_class a1290,
          giis_payees a1280,
          giac_disb_vouchers gidv,
          giac_banks gban,
          giac_bank_accounts gbac,
          giac_chk_disbursement gchd,
          giac_payt_requests_dtl grqd,
          giis_funds a995,
          giac_branches gibr,
          giac_oucs gouc
    WHERE gidv.gouc_ouc_id = gouc.ouc_id
      AND gidv.req_dtl_no = grqd.req_dtl_no
      AND gidv.gprq_ref_id = grqd.gprq_ref_id
      AND gidv.gibr_gfun_fund_cd = a995.fund_cd
      AND gidv.gibr_branch_cd = gibr.branch_cd
      AND a995.fund_cd = gibr.gfun_fund_cd
      AND grqd.payee_cd = a1280.payee_no
      AND grqd.payee_class_cd = a1280.payee_class_cd
      AND a1280.payee_class_cd = a1290.payee_class_cd
      AND gidv.gacc_tran_id = gchd.gacc_tran_id
      AND gchd.bank_cd = gbac.bank_cd
      AND gchd.bank_acct_cd = gbac.bank_acct_cd
      AND gban.bank_cd = gbac.bank_cd
      AND gidv.dv_flag = 'P'
          WITH READ ONLY;


