DROP VIEW CPI.GIAC_SOA_REP_V; 

/* Formatted on 2015/05/15 10:40 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giac_soa_rep_v (policy_id,
                                                 policy_no,
                                                 assd_no,
                                                 iss_cd,
                                                 cred_branch,
                                                 line_cd,
                                                 subline_cd,
                                                 issue_yy,
                                                 renew_no,
                                                 pol_seq_no,
                                                 line_name,
                                                 acct_ent_date,
                                                 ref_pol_no,
                                                 incept_date,
                                                 issue_date,
                                                 spld_date,
                                                 pol_flag,
                                                 eff_date,
                                                 expiry_date,
                                                 policy_id2,
                                                 assd_no2,
                                                 assd_name,
                                                 reg_policy_sw,
                                                 endt_type,
                                                 spld_acct_ent_date
                                                )
AS
   SELECT /*+RULE */
          a.policy_id,
                      /*comment out by MAC 03/01/2013
                      DECODE (a.endt_seq_no,
                            0, SUBSTR (   a.line_cd
                                    || '-'
                                    || a.subline_cd
                                    || '-'
                                    || a.iss_cd
                                    || '-'
                                    || TO_CHAR (a.issue_yy)
                                    || '-'
                                    || TO_CHAR (a.pol_seq_no)
                                    || '-'
                                    || TO_CHAR (a.renew_no),
                                    1,
                                    37
                                   ),
                            SUBSTR (   a.line_cd
                                  || '-'
                                  || a.subline_cd
                                  || '-'
                                  || a.iss_cd
                                  || '-'
                                  || TO_CHAR (a.issue_yy)
                                  || '-'
                                  || TO_CHAR (a.pol_seq_no)
                                  || '-'
                                  || TO_CHAR (a.renew_no)
                                  || '-'
                                  || a.endt_iss_cd
                                  || '-'
                                  || TO_CHAR (a.endt_yy)
                                  || '-'
                                  || TO_CHAR (a.endt_seq_no),
                                  1,
                                  37
                                 )
                           )*/
                      --get_policy_no (a.policy_id) policy_no,
                                    a.line_cd
                                 || '-'
                                 || a.subline_cd
                                 || '-'
                                 || a.iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (a.issue_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                                 || '-'
                                 || LTRIM (TO_CHAR (a.renew_no, '09'))
                                 || DECODE (
                                       NVL (a.endt_seq_no, 0),
                                       0, '',
                                          ' / '
                                       || a.endt_iss_cd
                                       || '-' 
                                       || LTRIM (TO_CHAR (a.endt_yy, '09'))
                                       || '-'
                                       || LTRIM (TO_CHAR (a.endt_seq_no, '0999999'))
                                    ) policy_no,
      --used get_policy_no function in getting policy number by MAC 03/01/2013
                                                            c.assd_no,
          a.iss_cd, a.cred_branch,                         -- judyann 12052008
                                  a.line_cd, a.subline_cd, a.issue_yy,
          a.renew_no, a.pol_seq_no, b.line_name, a.acct_ent_date,
          a.ref_pol_no, a.incept_date, a.issue_date, a.spld_date, a.pol_flag,
          a.eff_date, a.expiry_date,
          DECODE ((SELECT 'X' endt_tax_count
                     FROM gipi_endttext
                    WHERE policy_id = a.policy_id AND endt_tax = 'Y'),
                  'X', (SELECT policy_id
                          FROM gipi_polbasic
                         WHERE line_cd = a.line_cd
                           AND subline_cd = a.subline_cd
                           AND iss_cd = a.iss_cd
                           AND issue_yy = a.issue_yy
                           AND renew_no = a.renew_no
                           AND pol_seq_no = a.pol_seq_no
                           AND endt_seq_no = 0),
                  a.policy_id
                 ) policy_id2,
          (SELECT y.assd_no
             FROM gipi_polbasic x, gipi_parlist y
            WHERE x.par_id = y.par_id
              AND x.par_id = a.par_id --added by pjsantos 11/17/2016 for optimization GENQA 5187
              AND x.line_cd = a.line_cd
              AND x.subline_cd = a.subline_cd
              AND x.iss_cd = a.iss_cd
              AND x.issue_yy = a.issue_yy
              AND x.renew_no = a.renew_no
              AND x.pol_seq_no = a.pol_seq_no
              AND x.endt_seq_no =
                     (SELECT MAX (endt_seq_no)
                        FROM gipi_polbasic
                       WHERE line_cd = a.line_cd
                         AND subline_cd = a.subline_cd
                         AND iss_cd = a.iss_cd
                         AND issue_yy = a.issue_yy
                         AND renew_no = a.renew_no
                         AND pol_seq_no = a.pol_seq_no
                         AND par_id = a.par_id)) assd_no2,--added by pjsantos 11/17/2016 for optimization GENQA 5187
          (SELECT z.assd_name
             FROM gipi_polbasic x, gipi_parlist y, giis_assured z
            WHERE x.par_id = y.par_id
              AND y.assd_no = z.assd_no 
              AND x.par_id = a.par_id --added by pjsantos 11/17/2016 for optimization GENQA 5187
              AND x.line_cd = a.line_cd
              AND x.subline_cd = a.subline_cd
              AND x.iss_cd = a.iss_cd
              AND x.issue_yy = a.issue_yy
              AND x.renew_no = a.renew_no
              AND x.pol_seq_no = a.pol_seq_no
              AND x.endt_seq_no =
                     (SELECT MAX (endt_seq_no)
                        FROM gipi_polbasic
                       WHERE line_cd = a.line_cd
                         AND subline_cd = a.subline_cd
                         AND iss_cd = a.iss_cd
                         AND issue_yy = a.issue_yy
                         AND renew_no = a.renew_no
                         AND pol_seq_no = a.pol_seq_no
                         AND par_id = a.par_id)) assd_name, --added by pjsantos 11/17/2016 for optimization GENQA 5187
          reg_policy_sw, endt_type, spld_acct_ent_date                --rcdatu
     FROM gipi_polbasic a, giis_line b, gipi_parlist c, giis_subline d
    WHERE a.line_cd = b.line_cd
      AND b.line_cd = d.line_cd                    --added by rochelle, 080807
      AND a.line_cd = d.line_cd
      AND a.subline_cd = d.subline_cd                              --end addtn
      AND a.par_id = c.par_id
      AND a.policy_id >= 0
      AND c.par_id >= 0
      AND a.iss_cd != 'RI'
      AND d.op_flag != 'Y';


