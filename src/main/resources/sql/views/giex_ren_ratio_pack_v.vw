DROP VIEW CPI.GIEX_REN_RATIO_PACK_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giex_ren_ratio_pack_v (policy_id,
                                                        pack_policy_id,
                                                        line_cd,
                                                        iss_cd,
                                                        iss_name,
                                                        line_name,
                                                        subline_name,
                                                        intm_number,
                                                        assured_no,
                                                        assured_name,
                                                        expiry_date,
                                                        policy_no,
                                                        premium_amt,
                                                        premium_renew_amt,
                                                        remarks,
                                                        renewal_policy,
                                                        ref_pol_no
                                                       )
AS
   SELECT DISTINCT a.policy_id policy_id, a.pack_policy_id pack_policy_id,
                   a.line_cd line_cd, a.iss_cd iss_cd, h.iss_name iss_name,
                   f.line_name line_name, g.subline_name subline_name,
                   TO_CHAR (a.intm_no, '09999999') intm_number,
                   a.assd_no assured_no, b.assd_name assured_name,
                   c.expiry_date expiry_date,
                      c.line_cd
                   || '-'
                   || c.subline_cd
                   || '-'
                   || c.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (c.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                   || '-'
                   || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                   a.prem_amt premium_amt,
                   DECODE (a.renewal_tag,
                           'Y', a.prem_renew_amt,
                           0
                          ) premium_renew_amt,
                   DECODE (a.renewal_tag, 'Y', 'RENEWED') remarks,
                   DECODE (a.renewal_tag,
                           'Y', c.line_cd
                            || '-'
                            || c.iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (c.issue_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (c.pol_seq_no, '099999'))
                            || '-'
                            || LTRIM (TO_CHAR (c.renew_no, '09'))
                          ) renewal_policy,
                   c.ref_pol_no
              FROM giex_ren_ratio_dtl a,
                   gipi_polbasic c,
                   giis_assured b,
                   giis_line f,
                   giis_subline g,
                   giis_issource h
             WHERE 1 = 1
               AND h.iss_cd = a.iss_cd
               AND f.line_cd = a.line_cd
               AND g.subline_cd = a.subline_cd
               AND g.line_cd = a.line_cd
               AND b.assd_no = a.assd_no
               AND c.policy_id = a.policy_id
               AND a.YEAR IN (SELECT MAX (YEAR)
                                FROM giex_ren_ratio_dtl
                               WHERE user_id = USER)
               AND a.user_id = USER;


