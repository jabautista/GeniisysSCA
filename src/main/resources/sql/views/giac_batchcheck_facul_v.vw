DROP VIEW CPI.GIAC_BATCHCHECK_FACUL_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_batchcheck_facul_v (line_cd,
                                                          policy_id,
                                                          policy_no,
                                                          binder_no,
                                                          prem_amt
                                                         )
AS
   SELECT a.line_cd, e.policy_id, get_policy_no (e.policy_id) policy_no,
          a.line_cd || '-' || a.binder_yy || '-' || a.binder_seq_no binder_no,
          DECODE (a.acc_rev_date,
                  f.TO_DATE, a.ri_prem_amt * c.currency_rt * -1,
                  a.ri_prem_amt * c.currency_rt
                 ) prem_amt
     FROM giri_frps_ri b,
          giri_distfrps c,
          giri_binder a,
          giuw_pol_dist d,
          gipi_polbasic e,
          giac_batch_check_facul_ext f
    WHERE a.fnl_binder_id = b.fnl_binder_id
      AND c.dist_no = d.dist_no
      AND e.policy_id = d.policy_id
      AND b.frps_yy = c.frps_yy
      AND b.frps_seq_no = c.frps_seq_no
      AND b.line_cd = c.line_cd
      AND f.line_cd = e.line_cd
      AND (   TRUNC (a.acc_ent_date) = f.TO_DATE
           OR TRUNC (a.acc_rev_date) = f.TO_DATE
          );


