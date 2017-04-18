DROP VIEW CPI.GIAC_BAE_GIACB001_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_bae_giacb001_v (policy_id,
                                                      fund_cd,
                                                      iss_cd,
                                                      acct_branch_cd,
                                                      branch_name,
                                                      line_cd,
                                                      acct_line_cd,
                                                      line_name,
                                                      subline_cd,
                                                      acct_subline_cd,
                                                      subline_name,
                                                      prem_amt,
                                                      tsi_amt,
                                                      assd_no,
                                                      acct_ent_date,
                                                      pos_neg_inclusion,
                                                      spld_acct_ent_date,
                                                      spld_date,
                                                      booking_mth,
                                                      booking_year,
                                                      incept_date,
                                                      issue_date,
                                                      expiry_date,
                                                      dist_flag,
                                                      parent_intm_no,
                                                      acct_intm_cd,
                                                      policy_no,
                                                      reg_policy_sw,
                                                      bill_iss_cd,
                                                      prem_seq_no
                                                     )
AS
   SELECT DISTINCT a.policy_id,
                               /* modified by judyann 03242008; to handle take-up of long-term policies */
                               d.gfun_fund_cd fund_cd,
                   NVL (a.cred_branch, a.iss_cd) iss_cd, d.acct_branch_cd,
                   d.branch_name, a.line_cd, b.acct_line_cd, b.line_name,
                   a.subline_cd, c.acct_subline_cd, c.subline_name,
                   
                   --a.prem_amt,
                   f.prem_amt, a.tsi_amt, e.assd_no, a.acct_ent_date,
                   
                   --DECODE(a.acct_ent_date, NULL, 'P','N') pos_neg_inclusion,
                   DECODE (f.acct_ent_date,
                           NULL, 'P',
                           'N'
                          ) pos_neg_inclusion,
                                              --a.spld_acct_ent_date,
                                              f.spoiled_acct_ent_date,
                   a.spld_date,
                   
                   --DECODE(a.booking_mth,NULL, TO_CHAR(GREATEST(incept_date,issue_date),'MONTH'),a.booking_mth) booking_mth,
                   --DECODE(a.booking_year,NULL,TO_NUMBER(TO_CHAR(GREATEST(incept_date,issue_date),'YYYY')),a.booking_year) booking_year,
                   DECODE (f.multi_booking_mm,
                           NULL, TO_CHAR (GREATEST (incept_date, issue_date),
                                          'MONTH'
                                         ),
                           f.multi_booking_mm
                          ) booking_mth,
                   DECODE
                      (f.multi_booking_yy,
                       NULL, TO_NUMBER (TO_CHAR (GREATEST (incept_date,
                                                           issue_date
                                                          ),
                                                 'YYYY'
                                                )
                                       ),
                       f.multi_booking_yy
                      ) booking_year,
                   a.incept_date, a.issue_date, a.expiry_date, a.dist_flag,
                   bae_v_polprnt_parent (a.policy_id,
                                         a.line_cd,
                                         a.subline_cd,
                                         a.iss_cd,
                                         a.issue_yy,
                                         a.pol_seq_no,
                                         a.renew_no
                                        ) parent_intm_no,
                   bae_v_polprnt_acctintm (a.policy_id,
                                           a.line_cd,
                                           a.subline_cd,
                                           a.iss_cd,
                                           a.issue_yy,
                                           a.pol_seq_no,
                                           a.renew_no
                                          ) acct_intm_cd,
                   DECODE (a.endt_seq_no,
                           0, SUBSTR (   a.line_cd
                                      || '-'
                                      || a.subline_cd
                                      || '-'
                                      || a.iss_cd
                                      || '-'
                                      || LTRIM (TO_CHAR (a.issue_yy))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.pol_seq_no))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.renew_no)),
                                      1,
                                      37
                                     ),
                           SUBSTR (   a.line_cd
                                   || '-'
                                   || a.subline_cd
                                   || '-'
                                   || a.iss_cd
                                   || '-'
                                   || LTRIM (TO_CHAR (a.issue_yy))
                                   || '-'
                                   || LTRIM (TO_CHAR (a.pol_seq_no))
                                   || '-'
                                   || a.endt_iss_cd
                                   || '-'
                                   || LTRIM (TO_CHAR (a.endt_yy))
                                   || '-'
                                   || LTRIM (TO_CHAR (a.endt_seq_no))
                                   || '-'
                                   || LTRIM (TO_CHAR (a.renew_no)),
                                   1,
                                   37
                                  )
                          ) policy_no,
                   a.reg_policy_sw, f.iss_cd bill_iss_cd, f.prem_seq_no
              FROM gipi_polbasic a,
                   gipi_invoice f,
                   giis_line b,
                   giis_subline c,
                   giac_branches d,
                   gipi_parlist e
             WHERE 1 = 1
               /*AND ((a.acct_ent_date IS NULL
                 AND a.pol_flag <>  '5'
                 AND a.dist_flag = '3')
                 OR (a.pol_flag = '5'
                 AND a.spld_acct_ent_date IS NULL
                 AND a.acct_ent_date IS NOT NULL
                 AND a.spld_date IS NOT NULL
                 AND a.dist_flag = '4'))*/
               AND (   (    f.acct_ent_date IS NULL
                        AND a.pol_flag <> '5'
                        AND a.dist_flag = '3'
                       )
                    OR (    a.pol_flag = '5'
                        AND f.spoiled_acct_ent_date IS NULL
                        AND f.acct_ent_date IS NOT NULL
                        AND a.spld_date IS NOT NULL
                        AND a.dist_flag = '4'
                       )
                   )
               AND a.iss_cd <> 'RI'
               AND a.line_cd <> 'BB'
               AND NVL (a.endt_type, 'A') = 'A'
               AND a.policy_id = f.policy_id
               AND a.line_cd = b.line_cd
               AND a.line_cd = c.line_cd
               AND a.subline_cd = c.subline_cd
               AND NVL (a.cred_branch, a.iss_cd) = d.branch_cd
               AND a.par_id = e.par_id
               AND c.op_flag <> 'Y'
               AND b.sc_tag IS NULL
               AND d.gfun_fund_cd = (SELECT param_value_v
                                       FROM giac_parameters
                                      WHERE param_name = 'FUND_CD');


