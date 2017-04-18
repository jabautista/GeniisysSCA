DROP VIEW CPI.GIAC_BATCHCHECK_TREATY_DTL_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_batchcheck_treaty_dtl_v (line_cd,
                                                               policy_id,
                                                               policy_no,
                                                               ri_cd,
                                                               prem_amt
                                                              )
AS
   SELECT   a.line_cd, a.policy_id, get_policy_no (a.policy_id) policy_no,
            a.ri_cd, SUM (b.premium_amt) prem_amt
       FROM giac_treaty_cessions a,
            giac_treaty_cession_dtl b,
            giac_batch_check_treaty_ext f
      WHERE a.cession_id = b.cession_id
        AND a.line_cd = f.line_cd
        AND TRUNC (a.acct_ent_date) = f.TO_DATE
   GROUP BY a.line_cd, a.policy_id, ri_cd;


