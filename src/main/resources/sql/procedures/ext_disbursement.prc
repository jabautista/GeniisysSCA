DROP PROCEDURE CPI.EXT_DISBURSEMENT;

CREATE OR REPLACE PROCEDURE CPI.Ext_Disbursement IS

BEGIN

DELETE eim_disbursement_ext
 WHERE user_id = USER;

FOR disb IN (
  SELECT a.gacc_tran_id,
         a.dv_date,
         a.dv_pref||'-'||dv_no dv_ref_no,
         a.dv_amt,
         a.payee,
         c.branch_cd,
         c.document_cd,
         d.gl_acct_category||'-'||d.gl_control_acct||'-'||d.gl_sub_acct_1||'-'||
         d.gl_sub_acct_2||'-'||d.gl_sub_acct_3||'-'||d.gl_sub_acct_4||'-'||
         d.gl_sub_acct_5||'-'||d.gl_sub_acct_6||'-'||d.gl_sub_acct_7 gl_acct,
         e.gl_acct_sname,
         d.debit_amt,
         d.credit_amt,
         b.tran_date,
  	     b.posting_date,
 	 	 a.gibr_branch_cd,
		 f.branch_name gibr_branch_name
    FROM giac_payt_requests   c,
         giac_disb_vouchers   a,
         giac_acctrans        b,
         giac_acct_entries    d,
         giac_chart_of_accts  e,
         giac_branches        f
   WHERE 1=1
     AND a.req_dtl_no        = 1                 /* for optimization purpose*/
     AND d.gl_acct_id        = e.gl_acct_id
     AND c.ref_id            = a.gprq_ref_id
     AND a.gacc_tran_id      = b.tran_id
     AND b.tran_id           = d.gacc_tran_id
     AND a.dv_flag           = 'P'
     AND b.tran_flag IN ('C','P')
     AND a.gibr_gfun_fund_cd = f.gfun_fund_cd
     AND a.gibr_branch_cd	= f.branch_cd)
LOOP

  INSERT INTO eim_disbursement_ext (
    user_id,                branch_name,
	extraction_date, 		branch_cd,
	gacc_tran_id, 			dv_date,
	dv_ref_no, 				dv_amt,
	payee, 					document_cd,
	gl_acct, 				gl_acct_sname,
	debit_amt, 				credit_amt,
	tran_date, 				posting_date,
	gibr_branch_cd, 		gibr_branch_name)
  VALUES (
    NULL, 					Get_Iss_Name(disb.branch_cd),
	TRUNC(SYSDATE),			disb.branch_cd,
	disb.gacc_tran_id, 		disb.dv_date,
	disb.dv_ref_no, 		disb.dv_amt,
	disb.payee, 			disb.document_cd,
	disb.gl_acct, 			disb.gl_acct_sname,
	disb.debit_amt, 		disb.credit_amt,
	disb.tran_date, 		disb.posting_date,
	disb.gibr_branch_cd, 	disb.gibr_branch_name);

END LOOP;
COMMIT;
END;
/

DROP PROCEDURE CPI.EXT_DISBURSEMENT;